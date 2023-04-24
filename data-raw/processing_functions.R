## Formatting and correction functions.
## 
## Note: functions in this file require functions from the file
##       'utility_functions.R' to work.


#' Format and correct data
#' 
#' Apply specific formatting and corrections to IMIS and OIS data.
#' 
#' @template function_not_exported
#' 
#' @param data Data to format and correct.
#' @param rename Logical indicating whether to rename columns.
#' @param agencies Two-column character matrix or data frame containing
#'  identifiers and types of agencies conducting inspections.
#' @return Data formatted and corrected.
#' 
#' @author Gauthier Magnin
#' @keywords internal
#' 
format_and_correct = function(data, rename = TRUE, agencies = NULL) {
  
  ## Specific corrections
  
  # Remove one duplicate measure
  # 
  # All values are equals (inspection identifier, date, e.level, etc.) except:
  #  - NAICS is missing first then present
  #  - insp.type has changed
  data = data[-which(data$activity.nr == 315736603 & data$iddf == "IMIS")[1], ]
  
  # Correct an OSHA establishment that was both considered as "Federal Government" and "Private Sector"
  data$ownership.type[data$activity.nr == 424384 & data$iddf == "OIS"] = "Federal Government"
  
  
  ## Generic corrections
  
  # Remove measures whose unit is "S" since no documentation have been found for
  # its meaning
  # 
  # A better way to deal with it would be to turn the value into NA.
  # But previous processing was to remove measures about detected substance 
  # having NA unit.
  which_data_unit_s = which(!is.na(data$units) & data$units == "S" & data$e.type != "F")
  if (length(which_data_unit_s) != 0) data = data[-which_data_unit_s, ]
  
  # Replace impossible values by NA
  data$emp.cvrd[data$emp.cvrd >= 1e+9] = NA
  
  
  # Logical variables identifying which rows are from IMIS and which ones are from OIS
  is_from_imis = (data$iddf == "IMIS")
  is_from_ois  = (data$iddf == "OIS")
  
  # Remove values used to express that data is missing and convert variables to logical
  data$union      = unname(c(Y = TRUE, N = FALSE, X = NA)[data$union])
  data$adv.notice = unname(c(Y = TRUE, N = FALSE, X = NA)[data$adv.notice])
  
  # Split variable about the OCC classification which contains identifiers in IMIS but names in OIS
  data$occ.title = rep(NA_character_, nrow(data))
  data$occ.title[is_from_ois] = data$occ.code[is_from_ois]
  data$occ.code[is_from_ois] = NA_character_
  
  # Merge variables 'e.type' and 'e.type.ois' referring to the same information
  # and extract the category differentiating them in a boolean variable
  data$is_detected = (data$e.type != "F")
  data$e.type[!data$is_detected & is_from_ois]  = data$e.type.ois[!data$is_detected & is_from_ois]
  data$e.type[!data$is_detected & is_from_imis] = NA_character_
  data$e.type.ois = NULL
  
  # Add missing 0s to the left of some identifiers (activity, occupation, reporting agency)
  data$sic       = extend_left(data$sic,       "0", 4)
  data$occ.code  = extend_left(data$occ.code,  "0", 3)
  data$report.id = extend_left(data$report.id, "0", 7)
  
  # Correct occurrences of "NONE" that are supposed to be "X"
  data$e.freq = gsub("NONE", "X", data$e.freq)
  
  # Use OIS notation for variable 'state' to avoid needing a reference table
  data$state = unname(c(S = "State", "F" = "Federal")[data$state])
  
  # Add 'state' values (all missing in OIS) for values of 'report.id' existing in both IMIS and OIS
  report_state = sapply(unique(data[is_from_imis, "report.id"]),
                        function(report) {
                          unique(data$state[is_from_imis & data$report.id == report])
                        })
  data$state = unname(report_state[data$report.id])
  
  # Add 'state' values for values of 'report.id' existing in the agency reference table
  if (!is.null(agencies)) {
    data$state[is.na(data$state)] = agencies[match(data$report.id[is.na(data$state)], agencies[, 1]), 2]
  }
  
  # Add NAICS values for measures in inspections having both measures with and without NAICS values
  insp_id = paste(data$iddf, data$activity.nr, sep = "-")
  inspections = unique(insp_id)
  insp_naics = stats::setNames(lapply(inspections,
                                      function(insp) unique(data$naics[insp_id == insp])),
                               inspections)
  insp_naics_to_add = sapply(insp_naics[lengths(insp_naics) == 2 & sapply(insp_naics, anyNA)],
                             function(naics) {
                               return(setdiff(naics, NA_character_))
                             })
  for (insp in names(insp_naics_to_add)) {
    data$naics[insp_id == insp] = insp_naics_to_add[insp]
  }
  
  # Add 'ownership.type' values (all missing in OIS data extracted from the Web
  # and in IMIS) for values of 'COMPANY_INDEX' also existing in OIS
  company_type = sapply(unique(data[is_from_ois, "COMPANY_INDEX"]),
                        function(company) {
                          type = unique(data$ownership.type[is_from_ois & data$COMPANY_INDEX == company])
                          if (length(type) > 1) {
                            return(setdiff(type, NA_character_))
                          }
                          return(type)
                        })
  data$ownership.type = unname(company_type[data$COMPANY_INDEX])
  
  # Convert data types
  # (Variables 'adv.notice' and  'union' have been previously converted to logical)
  new_types = c(activity.nr         = "integer",
                e.duration.units    = "factor",
                e.record            = "integer",
                e.type              = "factor",
                emp.cvrd            = "integer",
                exposure.assessment = "integer",
                iddf                = "factor",
                insp.scope          = "factor",
                insp.type           = "factor",
                nr.exposed          = "integer",
                ownership.type      = "factor",
                s.nbr               = "integer",
                s.type              = "factor",
                state               = "factor",
                state.1             = "factor",
                units               = "factor")
  
  for (col in names(new_types)) {
    data[, col] = typecast(data[, col], new_types[col])
  }
  
  # Reorder levels in one of the factor variables
  data$e.duration.units = factor(data$e.duration.units,
                                 levels = levels(data$e.duration.units)[c(5, 3, 2, 1, 6, 4, 7)])
  
  # Creation of identifiers for the measures in a new column
  data = cbind(measure_id = seq_len(nrow(data)),
               data)
  
  
  ## Renaming and reordering
  
  # Rename some columns
  if (rename) {
    colnames(data) = c(
      "measure_id",
      "inspection_number",   # activity.nr
      "agency_id",           # report.id
      "establishment_name",  # establishment
      "sic_id",              # sic
      "naics_id",            # naics
      "substance_id",        # subst
      "exposure_level",      # e.level
      "measure_unit_id",     # units
      "oel",
      "severity",
      "sample_date",         # s.date
      "sample_type_id",      # s.type
      "inspection_type_id",  # insp.type
      "scope_id",            # insp.scope
      "exposure_type_id",    # e.type
      "exposure_frequency",  # e.freq
      "exposure_duration",   # e.duration
      "duration_unit",       # e.duration.units
      "sheet_number",        # s.nbr
      "exposure_assessment", # exposure.assessment
      "record_id",           # e.record
      "territory_id",        # state.1
      "city",
      "zip",
      "is_unionized",        # union
      "was_notified",        # adv.notice
      "occ_id",              # occ.code
      "number_of_exposed",   # nr.exposed
      "number_of_covered",   # emp.cvrd
      "job_title",           # job.title
      "agency_type",         # state
      "establishment_type",  # ownership.type
      "original_db",         # iddf
      "measure_origins",     # id.dfno
      "location_id",         # STATE_CITY_ZIP
      "establishment_id",    # COMPANY_INDEX
      "occ_title",           # occ.title
      "is_detected"
    )
  }
  
  # Reorder columns
  return(data[, c("measure_id",
                  
                  "inspection_number",
                  "original_db",
                  "inspection_type_id",
                  "scope_id",
                  "was_notified",
                  "is_unionized",
                  "number_of_covered",
                  
                  "agency_id",
                  "agency_type",
                  
                  "establishment_id",
                  "establishment_name",
                  "establishment_type",
                  "location_id",
                  "territory_id",
                  "city",
                  "zip",
                  "sic_id",
                  "naics_id",
                  
                  "record_id",
                  "sheet_number",
                  "number_of_exposed",
                  "occ_id",
                  "occ_title",
                  "job_title",
                  "exposure_frequency",
                  "exposure_duration",
                  "duration_unit",
                  
                  "sample_date",
                  "sample_type_id",
                  
                  "exposure_assessment",
                  "substance_id",
                  "is_detected",
                  "exposure_level",
                  "measure_unit_id",
                  "exposure_type_id",
                  "oel",
                  "severity",
                  "measure_origins")])
}
