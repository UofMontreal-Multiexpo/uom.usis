## Preparation of the datasets relating to the IMIS and OIS databases: one main
## data frame and supplementary tables.
## 
## Input files:
##  - US_SIC_1987.csv
##  - NAICS_2002.csv
##  - OCC_1980.csv
##  
##  - OIS_RID_OFFICENAME FOIA.xlsx
##  
##  - subst_usData_brute.xlsx
##  - reference_tables.xlsx
##  
##  - utility_functions.R
##  - processing_functions.R
##  
##  - merge_USIS_raw_datasets.R, requiring:
##    - city_ois_modif.xlsx
##    - dfusa_unitssubsts_verifie.xlsx
##    - subst_usData_brute.RDS
##    - zip_code_database.xls
##    - IMIS.merged.aug2017.RDS
##    - 2010-2011 OIS for R.xlsx
##    - 2012-2013 OIS for R.xlsx
##    - 2014-2015 OIS for R.xlsx
##    - 2016-2017 OIS for R.xlsx
##    - 2018-2019 OIS for R.xlsx
##    - oischem_nodetail_JFS.xlsx
##    - Sampling - fed and state - 2010-2011 - chem for R.xlsx
##    - Sampling - fed and state - 2010-2014 - chem for R.xlsx
##    - Sampling - fed and state - 2012-2013 - chem for R.xlsx
##    - Sampling - fed and state - 2014-2015 - chem for R.xlsx
##    - Sampling - fed and state - 2016-2017 - chem for R.xlsx
##    - Sampling - fed and state - 2018-2019 - chem for R.xlsx
##    - Sampling - fed and state - 2020-2021 - chem for R.xlsx
##  - identify_cities_and_establishments.R
## 
## Output files:
##  - USIS_measures.RData and .csv
##  - SIC.RData and .csv
##  - NAICS.RData and .csv
##  - OCC.RData and .csv
##  - USIS_agencies.RData and .csv
##  - USIS_establishment_names.RData and .csv
##  - USIS_establishments.RData and .csv
##  - USIS_exposure_types.RData and .csv
##  - USIS_inspection_types.RData and .csv
##  - USIS_inspections.RData and .csv
##  - USIS_locations.RData and .csv
##  - USIS_measure_origins.RData
##  - USIS_measure_units.RData and .csv
##  - USIS_measures.RData and .csv
##  - USIS_sample_types.RData and .csv
##  - USIS_scopes.RData and .csv
##  - USIS_sheets.RData and .csv
##  - USIS_substances.RData and .csv
##  - USIS_workplaces.RData and .csv
##  - US_territories.RData and .csv
## 
## Other output files, resource files for tests:
##  - tests/res/testing_resources.RDS
##  - tests/res/USIS_data.RDS
## 
## Temporary files:
##  - tmp/USIS_data.RDS (output of merge_USIS_raw_datasets.R
##                          and of identify_cities_and_establishments.R)
##  - tmp/USIS_data.csv
##  - tmp/USIS_measure_origins.csv



#### Merge initial IMIS and OIS datasets ####

# Run the file merging all initial IMIS and OIS datasets to create ./tmp/USIS_data.RDS
source("./data-raw/merge_USIS_raw_datasets.R", local = new.env(), encoding = "UTF-8")

# Run the script adding identifiers to locations and establishments to update ./tmp/USIS_data.RDS
source("./data-raw/identify_locations_and_establishments.R", local = new.env(), encoding = "UTF-8")



#### Loading ####

# Loading functions
source("./data-raw/utility_functions.R",    encoding = "UTF-8")
source("./data-raw/processing_functions.R", encoding = "UTF-8")

data_path = function(x) paste0("./data-raw/create_USIS_data/", x)

# Loading data
USIS_data = readRDS("./tmp/USIS_data.RDS")

# Loading agency data
agencies = xlsx::read.xlsx(data_path("OIS_RID_OFFICENAME FOIA.xlsx"),
                           sheetIndex = 1,
                           colIndex = c(2, 4),
                           colClasses = "character",
                           encoding = "UTF-8",
                           stringsAsFactors = FALSE)

# Loading activity and occupation reference tables
SIC   = read.csv2(data_path("US_SIC_1987.csv"), colClasses = "character")
NAICS = read.csv(data_path("NAICS_2002.csv"), colClasses = "character")
OCC   = read.csv(data_path("OCC_1980.csv"), colClasses = "character")

# Loading substance reference table
USIS_substances = xlsx::read.xlsx(data_path("subst_usData_brute.xlsx"),
                                  sheetIndex = 1,
                                  colIndex = c(1, 2),
                                  colClasses = "character",
                                  encoding = "UTF-8",
                                  stringsAsFactors = FALSE)

# Loading other reference tables
load_reference_table = function(sheet, ...) {
  xlsx::read.xlsx(data_path("reference_tables.xlsx"),
                  sheetIndex = sheet,
                  header = FALSE,
                  colClasses = "character",
                  encoding = "UTF-8",
                  stringsAsFactors = FALSE,
                  ...)
}
USIS_exposure_types   = load_reference_table(1)
USIS_scopes           = load_reference_table(2)
USIS_inspection_types = load_reference_table(3)
USIS_measure_units    = load_reference_table(4, endRow = 12, colIndex = c(1, 2))
USIS_sample_types     = load_reference_table(5)
US_territories        = load_reference_table(6)



#### 1. Formatting and correction of the data ####

USIS_data = format_and_correct(USIS_data, agencies = agencies)



#### 2. Creation of the datasets ####

# Variables to be combined to create identifiers
inspection_id_vars = c("inspection_number", "original_db")
sheet_id_vars      = c("sheet_number", "inspection_number", "original_db")
workplace_id_vars  = c("establishment_id", "sic_id", "naics_id")


# Break down the data frame into several ones
USIS_inspections = unique(USIS_data[, c(
  "inspection_number", "original_db", "inspection_type_id",
  "scope_id", "was_notified", "is_unionized", "number_of_covered", "agency_id",
  workplace_id_vars
)])
USIS_agencies            = unique(USIS_data[, c("agency_id", "agency_type")])
USIS_establishments      = unique(USIS_data[, c("establishment_id", "establishment_type", "location_id")])
USIS_establishment_names = unique(USIS_data[, c("establishment_id", "establishment_name")])
USIS_locations           = unique(USIS_data[, c("location_id", "territory_id", "city", "zip")])
USIS_sheets              = unique(USIS_data[, c("sheet_number", inspection_id_vars,
                                                "exposure_duration", "duration_unit", "record_id")])


# Create official SIC and NAICS tables
SIC   = SIC[, c("code", "title", "division")]
NAICS = NAICS[is.element(NAICS$country, c("all", "US")), c("code", "title")]

# Create esblishment-activity associations
USIS_workplaces = unique(USIS_data[, c("establishment_id", "sic_id", "naics_id")])
USIS_workplaces = cbind(workplace_id = seq_len(nrow(USIS_workplaces)),
                        USIS_workplaces)
USIS_inspections$workplace_id = USIS_workplaces$workplace_id[match(
  paste(USIS_inspections$establishment_id, USIS_inspections$sic_id, USIS_inspections$naics_id, sep = "/"),
  paste(USIS_workplaces$establishment_id, USIS_workplaces$sic_id, USIS_workplaces$naics_id, sep = "/")
)]

# Break down a variable grouping several information about initial dataset files
origins = strsplit(USIS_data$measure_origins, ";")
USIS_measure_origins = cbind(rep(USIS_data$measure_id, lengths(origins)),
                             t(strsplit_last(unlist(origins), "_")))
USIS_measure_origins = data.frame(measure_id       = as.integer(USIS_measure_origins[, 1]),
                                  original_dataset = USIS_measure_origins[, 2],
                                  original_row     = as.integer(USIS_measure_origins[, 3]))

# Create the main data frame containing the remaining data
USIS_measures = USIS_data[c(
  "measure_id", "number_of_exposed", "occ_id", "occ_title", "job_title",
  "exposure_frequency", "sample_date", "sample_type_id", "exposure_assessment",
  "substance_id", "is_detected", "exposure_level", "measure_unit_id",
  "exposure_type_id", "oel", "severity", sheet_id_vars
)]

# Create identifiers for inspections and sheets
USIS_inspections = cbind(inspection_id = seq_len(nrow(USIS_inspections)),
                         USIS_inspections)
USIS_sheets = cbind(sheet_id = seq_len(nrow(USIS_sheets)),
                    USIS_sheets)

USIS_sheets$inspection_id = USIS_inspections$inspection_id[match(
  paste(USIS_sheets$inspection_number, USIS_sheets$original_db, sep = "/"),
  paste(USIS_inspections$inspection_number, USIS_inspections$original_db, sep = "/")
)]
USIS_measures$sheet_id = USIS_sheets$sheet_id[match(
  paste(USIS_measures$sheet_number, USIS_measures$inspection_number, USIS_measures$original_db, sep = "/"),
  paste(USIS_sheets$sheet_number, USIS_sheets$inspection_number, USIS_sheets$original_db, sep = "/")
)]

# Remove variables used to find foreign identifiers
USIS_inspections = USIS_inspections[, -which(colnames(USIS_inspections) %in% workplace_id_vars)]
USIS_measures    = USIS_measures[, -which(colnames(USIS_measures) %in% sheet_id_vars)]
USIS_sheets      = USIS_sheets[, -which(colnames(USIS_sheets) %in% inspection_id_vars)]


# Rename columns
colnames(USIS_agencies)               = c("id", "type")
colnames(USIS_establishments)[c(1,2)] = c("id", "type")
colnames(USIS_inspections)[c(1,2)]    = c("id", "number")
colnames(USIS_locations)[1]           = "id"
colnames(USIS_sheets)[c(1,2)]         = c("id", "number")
colnames(USIS_workplaces)[1]          = "id"

colnames(SIC)   = c("id", "name", "division")
colnames(NAICS) = c("id", "name")
colnames(OCC)   = c("id", "name", "category_level_1", "category_level_2",
                    "category_level_3", "category_level_4")

colnames(USIS_substances) = c("id", "name")

colnames(USIS_exposure_types)   = c("id", "name")
colnames(USIS_scopes)           = c("id", "name")
colnames(USIS_inspection_types) = c("id", "name", "schedule")
colnames(USIS_measure_units)    = c("id", "name")
colnames(USIS_sample_types)     = c("id", "name")
colnames(US_territories)        = c("id", "name", "type")


# Names of the variables
supplementary_tables = c(setdiff(ls()[grepl("USIS_", ls(), fixed = TRUE)],
                                 c("USIS_data", "USIS_measures")),
                         "US_territories")
dataset_names = c("USIS_measures", "SIC", "NAICS", "OCC", supplementary_tables)

# Columns forming the primary keys of the supplementary tables
id_columns = setNames(lapply(dataset_names, function(name) 1),
                      dataset_names)
id_columns[["USIS_establishment_names"]] = c(1, 2)
id_columns[["USIS_measure_origins"]]     = c(1, 2)



#### 3. Validation ####

# Checking the validity of the supplementary tables
for (name in supplementary_tables) {
  validate_keys(get(name),
                keys = id_columns[[name]],
                name = substr(name, 6, nchar(name)))
}



#### 4. Formatting the datasets ####

# Remove NA keys from the supplementary tables
for (name in supplementary_tables) {
  
  # If x has a one-column primary key: x <- x[!is.na(x[[1]]), ]
  # If x has a two-column primary key: x <- x[!is.na(x[[1]]) | !is.na(x[[2]]), ]
  eval(parse(text = paste0(name, " <- ", name, "[",
                           paste0(
                             "!is.na(", name, "[[", id_columns[[name]], "]])",
                             collapse = " | "
                           ),
                           ", ]")))
}

# Order the keys of the supplementary tables
for (name in supplementary_tables) {
  
  # If x has a one-column primary key: x <- x[order(x[[1]]), ]
  # If x has a two-column primary key: x <- x[order(x[[1]], x[[2]]), ]
  eval(parse(text = paste0(name, " <- ", name, "[",
                           paste0("order(",
                                  paste0(name, "[[", id_columns[[name]], "]]",
                                         collapse = ", "),
                                  ")"),
                           ", ]")))
}

# Remove rownames of the supplementary tables
for (name in supplementary_tables) {
  
  # rownames(x) <- NULL
  eval(parse(text = paste0("rownames(", name, ") <- NULL")))
}



#### 5. Export as CSV ####

# CSV directory and temporary directory
csv_dir = "./data/csv/"
tmp_dir = "./tmp/"

# Use "N/A" for NA values
missing_value = "N/A"


# Distinguish non-exported datasets (not exported as CSV and only internal in the package)
internal_datasets = "USIS_measure_origins"
exported_datasets = setdiff(dataset_names, internal_datasets)

# Save the exported datasets
for (name in exported_datasets) {
  
  write.csv(get(name),
            file = paste0(csv_dir, name, ".csv"),
            na = missing_value,
            row.names = FALSE)
}

# Temporarily save as CSV the internal datasets
# as well as the overall data frame (for assessment)
for (name in c(internal_datasets, "USIS_data")) {
  
  write.csv(get(name),
            file = paste0(tmp_dir, name, ".csv"),
            na = missing_value,
            row.names = FALSE)
}



#### 6. Simplify the tables ####

# Distinguish tables having two columns from those having more than two
is_vectorizable = sapply(dataset_names,
                         function(name) ncol(get(name)) == 2 && length(id_columns[[name]]) == 1)
not_vectorizable_tables = names(which(!is_vectorizable))
vectorizable_tables = names(which(is_vectorizable))

# Turn two-column tables having one-column primary keys into named vectors
for (name in vectorizable_tables) {
  
  # x <- turn_2c_into_vec(x)
  eval(parse(text = paste0(name, " <- turn_2c_into_vec(", name, ")")))
}

# Use primary keys as rownames for tables having more than two columns
# and remove the related column, if the key is formed by a single column
for (name in not_vectorizable_tables) {
  
  if (length(id_columns[[name]]) == 1) {
    # rownames(x) <- as.character(x[[1]])
    # x <- x[, -1]
    eval(parse(text = paste0("rownames(", name, ") <- as.character(", name, "[[1]])")))
    eval(parse(text = paste0(name, " <- ", name, "[, -1]")))
    
  }
  # else {
  #   # Paste columns composing the key and use the result as rownames
  #   
  #   # If x has a two-column primary key:
  #   # rownames(x) <- paste(x[[1]], x[[2]], sep = ".")
  #   eval(parse(text = paste0("rownames(", name, ") <- ",
  #                            paste0("paste(",
  #                                   paste0(name, "[[", id_columns[[name]], "]]", collapse = ", "),
  #                                   ", sep = \".\")")
  #                            )))
  # }
}

# Turn data frames into matrices if all their columns have the same type
for (name in not_vectorizable_tables) {
  if (length(unique(sapply(get(name), class))) == 1) {
    
    # x <- as.matrix(x)
    eval(parse(text = paste0(name, "<- as.matrix(", name, ")")))
  }
}



#### 7. Add prepared data to package ####

# Save exported data in data/
for (name in exported_datasets) {
  save(list = name, file = paste0("./data/", name, ".RData"))
}

# Save internal data in R/sysdata.rda
# usethis::use_data(internal_datasets[1], internal_datasets[2], ...,
#                   internal = TRUE, overwrite = TRUE)
eval(parse(text = paste0("usethis::use_data(",
                         paste0(internal_datasets, collapse = ", "),
                         ", internal = TRUE, overwrite = TRUE)")))

# Optimize compression
resave_with_best_compression(paste0("./data/", exported_datasets, ".RData"))
resave_with_best_compression(paste0("./R/sysdata.rda"))



#### Assessment ####

## Compute data weight saved by the new structure

weight_env = c(
  initial = object.size(USIS_data[, -1]), # Ignore first column that was added then moved to row names
  final   = sum(sapply(dataset_names, function(x) object.size(get(x))))
)
weight_env["difference"] = weight_env["final"] - weight_env["initial"]

weight_rd = c(
  initial = file.size("./tmp/USIS_data.RDS"),
  final   = sum(file.size(list.files("./data/", full.names = TRUE, pattern = "*.RData")))
)
weight_rd["difference"] = weight_rd["final"] - weight_rd["initial"]

weight_csv = c(
  initial = file.size("./tmp/USIS_data.csv"),
  final   = sum(file.size(list.files(csv_dir, full.names = TRUE)),
                file.size(list.files(tmp_dir,
                                     pattern = paste(internal_datasets, collapse = "|"),
                                     full.names = TRUE)))
)
weight_csv["difference"] = weight_csv["final"] - weight_csv["initial"]


# Count the amount of data
amount_of_data = c(
  initial = prod(dim(USIS_data)),
  final   = sum(sapply(not_vectorizable_tables,
                       function(name) prod(dim(get(name)) + c(0, 1))),
                sapply(vectorizable_tables,
                       function(name) length(get(name)) * 2))
)
amount_of_data["difference"] = amount_of_data["final"] - amount_of_data["initial"]


# Display the assessment
{
  cat("Amount of data:\n")
  print(amount_of_data)
  
  cat("\nWeight environment (MiB):\n")
  print(round(weight_env / 1024^2, 1))
  
  cat("\nWeight as RDS/RData files (MiB):\n")
  print(round(weight_rd / 1024^2, 1))
  
  cat("\nWeight as CSV files (MiB):\n")
  print(round(weight_csv / 1024^2, 1))
}



#### Test preparation ####

# Export data to use for comparisons when testing functions
test_res_dir  = "./tests/res/"
test_res_path = function(x) paste0(test_res_dir, x)

# Data based on the overall data frame USIS_data
saveRDS(
  list(
    # Measures from IMIS and measures from OIS
    measure_ids_imis = USIS_data$measure_id[USIS_data$original_db == "IMIS"],
    measure_ids_ois  = USIS_data$measure_id[USIS_data$original_db == "OIS"]
  ),
  test_res_path("testing_resources.RDS"),
  compress = "xz"
)

# Overall data frame USIS_data
saveRDS(USIS_data, test_res_path("USIS_data.RDS"), compress = "xz")



#### Post-processing ####

# Remove tmp directory
unlink(substr(tmp_dir, 1, nchar(tmp_dir) - 1), recursive = TRUE)
