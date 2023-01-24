## Note: some tests require additional data for comparisons.
##       The files concerned are available in the following Dropbox folder:
##       SHARE Multiexpo_databases/Testing resources/USIS/
##       These files must be placed in the directory "./tests/res/".



#### Preparation ####

##### Loading resource data for tests #####

# The following condition allows the instruction to be run both manually or automatically
if (grepl("testthat", getwd())) {
  test_res_path = function(x) paste0("../res/", x)
} else {
  test_res_path = function(x) paste0("./tests/res/", x)
}

# These data were exported by the script "create_USIS_data.R" from the overall
# data frame before its restructuring.
# This avoids having to modify the tested values corresponding to real data when
# new versions (i.e., new data) are created.
testing_resources = readRDS(test_res_path("testing_resources.RDS"))

# Overall data frame before its restructuring, exported by the script "create_USIS_data.R"
old_USIS = readRDS(test_res_path("USIS_data.RDS"))
rownames(old_USIS) = as.character(old_USIS$measure_id)


##### Creation of the results of some functions #####

# Create results of functions that take a long time to execute and are used in several tests
joined_USIS = join_USIS()
joined_IMIS = join_IMIS()
joined_OIS  = join_OIS()



#### Data search ####

##### get_original_db #####

test_that("get_original_db returns an unnamed object", {
  expect_named(get_original_db(), NULL)
})

test_that("get_original_db does not interpret given numeric identifiers in scientific notation", {
  expect_false(is.na(get_original_db(100000)))
})

test_that("get_original_db extracts original database information of the given measures", {
  
  # Get identifiers of two measures from IMIS and two measures from OIS
  # and use an order different from the order in the initial data
  ids = c(testing_resources$measure_ids_imis[1],
          testing_resources$measure_ids_ois[c(1, 2)],
          testing_resources$measure_ids_imis[2])
  expected = factor(c("IMIS", "OIS", "OIS", "IMIS"))
  
  # Alternative test data. These are real data and may change with new versions.
  # ids = rownames(USIS_measures)[c(1, 700001, 700002, 2)]
  # expected = factor(c("IMIS", "OIS", "OIS", "IMIS"))
  
  expect_equal(get_original_db(ids),
               expected)
})

test_that("get_original_db extracts original database information of all measures if no one is given", {
  # Only compare the numbers of values
  # (the validation of extracted values is performed by the previous test)
  expect_length(get_original_db(), nrow(USIS_measures))
})


##### get_establishment_names #####

test_that("get_establishment_names returns an unnamed vector if a single ID is given and as_vector is TRUE", {
  id = rownames(USIS_establishments)[1]
  result = get_establishment_names(id, as_vector = TRUE)
  
  expect_vector(result, character(0))
  expect_named(result, NULL)
})

test_that("get_establishment_names returns a named list if a single ID is given and as_vector is FALSE", {
  id = rownames(USIS_establishments)[1]
  result = get_establishment_names(id, as_vector = FALSE)
  
  expect_type(result, "list")
  expect_false(is.array(result))
  expect_named(result, id)
})

test_that("get_establishment_names returns a named list if several IDs are given", {
  ids = rownames(USIS_establishments)[1:5]
  result = get_establishment_names(ids)
  
  expect_type(result, "list")
  expect_false(is.array(result))
  expect_named(result, ids)
})

test_that("get_establishment_names returns a named list if no IDs are given", {
  # Note: this test assumes that there is more than on establishment in the database
  result = get_establishment_names()
  
  expect_type(result, "list")
  expect_false(is.array(result))
  expect_named(result, rownames(USIS_establishments))
})

test_that("get_establishment_names extracts names of the given establishments", {
  
  # Extract the identifiers of one establishment having only one name and of
  # another one having several names
  ids = c(names(which(table(USIS_establishment_names[, "establishment_id"]) > 1))[1],
          names(which(table(USIS_establishment_names[, "establishment_id"]) == 1))[1])
  expected = stats::setNames(
    list(
      unname(
        USIS_establishment_names[USIS_establishment_names[, "establishment_id"] == ids[1],
                                 "establishment_name"]
      ),
      unname(
        USIS_establishment_names[USIS_establishment_names[, "establishment_id"] == ids[2],
                                 "establishment_name"]
      )
    ),
    ids
  )
  
  # Alternative test data. These are real data and may change with new versions.
  # ids = c("AK-99501-9119", "AK-99501-76033")
  # expected = stats::setNames(
  #   list("BOB S SERVICES",
  #        c("ANCHORAGE MUNICIPALITY", "ANCHORAGE MUNICIPALITY ML P")),
  #   ids
  # )
  
  expect_identical(get_establishment_names(ids),
                   expected)
})

test_that("get_establishment_names extracts names of all establishments if no one is given", {
  # Note: this test assumes that there is more than on establishment in the database
  result = get_establishment_names()
  
  # Only compare the numbers of values obtained and expected
  # (the validation of extracted values is performed by another test)
  expect_identical(
    stats::setNames(as.vector(lengths(result)), names(result)),
    as.matrix(
      table(USIS_establishment_names)[unique(USIS_establishment_names[, "establishment_id"])]
    )[, 1]
  )
})


#### get_origins ####

test_that("get_origins returns a data frame containing two list columns", {
  result = get_origins()
  
  expect_s3_class(result, "data.frame")
  expect_identical(ncol(result), 2L)
  expect_type(result[, 1], "list")
  expect_type(result[, 2], "list")
})

test_that("get_origins returns an object whose rownames are measure identifiers", {
  ids = rownames(USIS_measures)[c(1,5,10,11)]
  
  expect_identical(rownames(get_origins(ids)),
                   ids)
})

test_that("get_origins extracts original dataset files and related rows of the given measures", {
  result = get_origins()
  
  # Paste dataset files and rows to compare with the overall dataset
  nb_origins = lengths(result$original_datasets)
  pasted_origins = lapply(seq_len(nrow(result)), function(i) {
    sapply(seq_len(nb_origins[i]), function(j) {
      paste(result$original_datasets[[i]][j],
            result$original_rows[[i]][j],
            sep = "_")
    })
  })
  
  # Split the different pairs file/row originally pasted and sort them
  expected = lapply(strsplit(old_USIS$measure_origin, ";"), sort)
  
  expect_identical(pasted_origins, expected)
})



#### Measure selectors ####

##### get_IMIS_measures #####

test_that("get_IMIS_measures selects measures relating to IMIS database", {
  result = get_IMIS_measures()
  
  # Number of measures
  expect_identical(
    nrow(result),
    length(testing_resources$measure_ids_imis)
  )
  
  # Measure identifiers
  expect_identical(
    as.integer(rownames(result)),
    testing_resources$measure_ids_imis
  )
})


##### get_OIS_measures #####

test_that("get_OIS_measures selectes measures relating to OIS database", {
  result = get_OIS_measures()
  
  # Number of measures
  expect_identical(
    nrow(result),
    length(testing_resources$measure_ids_ois)
  )
  
  # Measure identifiers
  expect_identical(
    as.integer(rownames(result)),
    testing_resources$measure_ids_ois
  )
})



#### Database join ####

##### join_USIS #####

test_that("join_USIS reconstructs the original dataset structure for USIS measures", {
  
  # Compare measure identifiers
  expect_identical(
    rownames(joined_USIS),
    rownames(USIS_measures)
  )
})

test_that("join_USIS adds an unnamed list column for establishment names if estab_names is TRUE", {
  result = join_USIS(estab_names = TRUE)
  
  expect_type(result$establishment_names, "list")
  expect_named(result$establishment_names, NULL)
})

test_that("join_USIS reconstructs the original dataset structure", {
  
  # Some data are not tested because they have been added for the restructuring
  # or they correspond to additional information associated with identifiers
  new_cols_to_ignore = c(
    "inspection_id", "sheet_id", "workplace_id",
    "occ_name", "sample_type_name", "substance_name", "measure_unit_name",
    "exposure_type_name","inspection_type_name", "scope_name", "sic_name",
    "naics_name", "territory_name")
  
  # Measure IDs are not tested as a column since they have been moved to row names
  # Measure origins are not tested since they are not concerned by this function
  # Establishment names are tested in another test
  old_cols_to_ignore = c("measure_id", "measure_origins", "establishment_name")
  
  expect_identical(
    joined_USIS[, -which(colnames(joined_USIS) %in% new_cols_to_ignore)],
    old_USIS[, -which(colnames(old_USIS) %in% old_cols_to_ignore)][
      c(1:17, 19, 25, 26, 18, 20:24, 27:36)
    ]
  )
})


##### join_IMIS #####

test_that("join_IMIS reconstructs the original dataset structure for IMIS measures", {
  
  # Compare measure identifers
  expect_identical(
    rownames(joined_IMIS),
    rownames(get_IMIS_measures())
  )
})

test_that("join_IMIS adds an unnamed list column for establishment names if estab_names is TRUE", {
  result = join_IMIS(estab_names = TRUE)
  
  expect_type(result$establishment_names, "list")
  expect_named(result$establishment_names, NULL)
})

test_that("join_IMIS reconstructs the original dataset structure, including IMIS data only", {
  
  old_IMIS = old_USIS[old_USIS$original_db == "IMIS", ]
  
  # Some data are not tested because they have been added for the restructuring
  # or they correspond to additional information associated with identifiers
  new_cols_to_ignore = c(
    "inspection_id", "sheet_id", "workplace_id",
    "occ_name", "sample_type_name", "substance_name", "measure_unit_name",
    "exposure_type_name","inspection_type_name", "scope_name", "sic_name",
    "naics_name", "territory_name")
  
  # Measure IDs are not tested as a column since they have been moved to row names
  # Measure origins are not tested since they are not concerned by this function
  # Establishment names are tested in another test
  old_cols_to_ignore = c("measure_id", "measure_origins", "establishment_name")
  
  expect_identical(
    joined_IMIS[, -which(colnames(joined_IMIS) %in% new_cols_to_ignore)],
    old_IMIS[, -which(colnames(old_IMIS) %in% old_cols_to_ignore)][
      c(1:17, 19, 25, 26, 18, 20:24, 27:36)
    ]
  )
})


##### join_OIS #####

test_that("join_OIS reconstructs the original dataset structure for OIS measures", {
  
  # Compare measure identifers
  expect_identical(
    rownames(joined_OIS),
    rownames(get_OIS_measures())
  )
})

test_that("join_OIS adds an unnamed list column for establishment names if estab_names is TRUE", {
  result = join_OIS(estab_names = TRUE)
  
  expect_type(result$establishment_names, "list")
  expect_named(result$establishment_names, NULL)
})

test_that("join_OIS reconstructs the original dataset structure, including OIS data only", {
  
  old_OIS = old_USIS[old_USIS$original_db == "OIS", ]
  
  # Some data are not tested because they have been added for the restructuring
  # or they correspond to additional information associated with identifiers
  new_cols_to_ignore = c(
    "inspection_id", "sheet_id", "workplace_id",
    "occ_name", "sample_type_name", "substance_name", "measure_unit_name",
    "exposure_type_name","inspection_type_name", "scope_name", "sic_name",
    "naics_name", "territory_name")
  
  # Measure IDs are not tested as a column since they have been moved to row names
  # Measure origins are not tested since they are not concerned by this function
  # Establishment names are tested in another test
  old_cols_to_ignore = c("measure_id", "measure_origins", "establishment_name")
  
  expect_identical(
    joined_OIS[, -which(colnames(joined_OIS) %in% new_cols_to_ignore)],
    old_OIS[, -which(colnames(old_OIS) %in% old_cols_to_ignore)][
      c(1:17, 19, 25, 26, 18, 20:24, 27:36)
    ]
  )
})
