
#### Global variables ####

#' DB_IMIS
#' @description Reference value for naming a database: IMIS.
#' @keywords internal
DB_IMIS = "IMIS"

#' DB_OIS
#' @description Reference value for naming a database: OIS.
#' @keywords internal
DB_OIS = "OIS"

#' DB_USIS
#' @description Reference value for naming a database: USIS (i.e., both IMIS and
#'  OIS).
#' @keywords internal
DB_USIS = "USIS"



#### Database join ####

#' Join USIS data or only IMIS or OIS data
#' 
#' Join USIS data into a single data frame. Consider the main datasets (those
#'  named `USIS_inspections`, `USIS_sheets` and `USIS_measures`), combine them
#'  according to sheet and inspection identifiers, and combine the result with
#'  the corresponding values from the other datasets (`OCC`, `USIS_agencies`,
#'  `USIS_establishments`, etc.).
#' Functions `join_IMIS` and `join_OIS` consider only IMIS or OIS data according
#'  to the variable `original_db` in `USIS_inspections`.
#' 
#' @inherit join_db details
#' 
#' @note
#' Prefer to use initial datasets instead of the single data frame resulting
#'  from one of these functions if you care about memory usage.
#' 
#' @inheritParams join_db
#' @inherit join_db return
#' 
#' @author Gauthier Magnin
#' @name join_USIS
NULL

#' @rdname join_USIS
#' 
#' @examples
#' ## Create the full USIS data frame
#' USIS_data <- join_USIS()
#' 
#' ## Look at one variable (substance_name)
#' identical(
#'   USIS_data$substance_name,
#'   unname(
#'     USIS_substances[USIS_measures$substance_id]
#'   )
#' )
#' 
#' @export
join_USIS = function(estab_names = FALSE) { join_db(DB_USIS, estab_names) }

#' @rdname join_USIS
#' 
#' @examples
#' ## Create the full IMIS data frame
#' IMIS_data <- join_IMIS()
#' 
#' @export
join_IMIS = function(estab_names = FALSE) { join_db(DB_IMIS, estab_names) }

#' @rdname join_USIS
#' 
#' @examples
#' ## Create the full OIS data frame
#' OIS_data <- join_OIS()
#' 
#' @export
join_OIS  = function(estab_names = FALSE) { join_db(DB_OIS,  estab_names) }


#' Join data from IMIS, OIS or both databases
#' 
#' Join USIS data into a single data frame. Consider the main datasets (those
#'  named `USIS_inspections`, `USIS_sheets` and `USIS_measures`), combine them
#'  according to sheet and inspection identifiers, and combine the result with
#'  the corresponding values from the other datasets (`OCC`, `USIS_agencies`,
#'  `USIS_establishments`, etc.).
#' 
#' @details
#' In the resulting object, variables named `number` from the datasets
#'  `USIS_inspections` and `USIS_sheets` are named `inspection_number` and
#'  `sheet_number`.
#' 
#' Additional variables created (regarding the datasets `USIS_inspections`,
#'  `USIS_sheets` and `USIS_measures`) are the following.
#' \describe{
#'   \item{`inspection_type_name`}{Inspection types corresponding to
#'         identifiers from `USIS_inspections$inspection_type_id`.}
#'   \item{`scope_name`}{Inspection scopes corresponding to identifiers from
#'         `USIS_inspections$scope_id`.}
#'   \item{`agency_type`}{Types of agencies from `USIS_inspections$agency_id`.}
#'   \item{`establishment_id`}{Establishment identifiers corresponding to
#'         workplace identifiers from `USIS_inspections$workplace_id`.}
#'   \item{`establishment_type`}{Types of establishments from
#'        `establishment_id`.}
#'   \item{`location_id`}{Location identifiers corresponding to establishment
#'         identifiers from `establishment_id`.}
#'   \item{`territory_id`}{Territory identifiers corresponding to location
#'         identifiers from `location_id`.}
#'   \item{`territory_name`}{Territories corresponding to identifiers from
#'         `territory_id`.}
#'   \item{`city`}{Cities corresponding to location identifiers from
#'         `location_id`.}
#'   \item{`zip`}{Postal codes corresponding to location identifiers from
#'         `location_id`.}
#'   \item{`sic_id`}{SIC identifiers corresponding to workplace identifiers from
#'         `USIS_inspections$workplace_id`.}
#'   \item{`sic_name`}{Industries corresponding to identifiers from `sic_id` in
#'         the SIC classification (the U.S. Standard Industrial
#'         Classification).}
#'   \item{`naics_id`}{NAICS identifiers corresponding to workplace identifiers
#'         from `USIS_inspections$workplace_id`.}
#'   \item{`naics_name`}{Industries corresponding to identifiers from `naics_id`
#'         in the NAICS classification (the North American Industry
#'         Classification System).}
#'   \item{`occ_name`}{Occupations corresponding to identifiers from
#'         `USIS_measures$occ_id` in the OCC classification (U.S. census
#'         occupational classification system).}
#'   \item{`sample_type_name`}{Sample types corresponding to identifiers from
#'         `USIS_measures$sample_type_id`.}
#'   \item{`substance_name`}{Substance names corresponding to identifiers from
#'         `USIS_measures$substance_id`.}
#'   \item{`measure_unit_name`}{Measure units corresponding to identifiers from
#'         `USIS_measures$measure_unit_id`.}
#'   \item{`exposure_type_name`}{Exposure types corresponding to identifiers
#'         from `USIS_measures$exposure_type_id`.}
#' }
#' 
#' An additional list column named `establishment_names` containing
#'  establishment names corresponding to establishment identifiers from
#'  `establishment_id` is added after this column if argument `estab_names` is
#'  `TRUE`.
#' If so, the memory usage of the resulting object increases significantly.
#' 
#' Some variables are not included in the resulting object:
#'  * `division` from `SIC`;
#'  * `type` from `US_territories`;
#'  * `schedule` from `USIS_inspections_types`; and
#'  * `category_level_1`, `category_level_2`, `category_level_3` and
#'    `category_level_4` from `OCC`.
#' 
#' @template function_not_exported
#' 
#' @param db Name of the database from which to join data.
#'  Character corresponding to `DB_IMIS`, `DB_OIS` or `DB_USIS`.
#' @param estab_names `TRUE` or `FALSE` whether to include establishment names
#'  in the join.
#' @return A single data frame combining all tables from the package. Its row
#'  names are measure identifiers.
#' 
#' @author Gauthier Magnin
#' 
#' @examples
#' ## Create the full USIS data frame
#' join_db(DB_USIS)
#' 
#' ## Create the full OIS data frame, including establishment names
#' join_db(DB_OIS, estab_names = TRUE)
#' 
#' @keywords internal
#' 
join_db = function(db, estab_names = FALSE) {
  
  # Identifiers of the measures from the database to join (IMIS, OIS or both)
  measure_ids = rownames(get_measures(db))
  
  # Identifiers of other entities (sheets, inspections, workplaces...) for each measure
  sheet_ids         = uom.usis::USIS_measures      [measure_ids,       "sheet_id"]
  inspection_ids    = uom.usis::USIS_sheets        [sheet_ids,         "inspection_id"]
  workplace_ids     = uom.usis::USIS_inspections   [inspection_ids,    "workplace_id"]
  establishment_ids = uom.usis::USIS_workplaces    [workplace_ids,     "establishment_id"]
  location_ids      = uom.usis::USIS_establishments[establishment_ids, "location_id"]
  territory_ids     = uom.usis::USIS_locations     [location_ids,      "territory_id"]
  
  # Join
  joined_db = cbind(
    
    # Inspection data
    inspection_id = inspection_ids,
    inspection_number = uom.usis::USIS_inspections[inspection_ids, "number"],
    uom.usis::USIS_inspections[inspection_ids, c("original_db", "inspection_type_id")],
    inspection_type_name = uom.usis::USIS_inspection_types[
      uom.usis::USIS_inspections[inspection_ids, "inspection_type_id"],
      "name"
    ],
    scope_id = uom.usis::USIS_inspections[inspection_ids, "scope_id"],
    scope_name = uom.usis::USIS_scopes[uom.usis::USIS_inspections[inspection_ids, "scope_id"]],
    uom.usis::USIS_inspections[inspection_ids, c("was_notified", "is_unionized",
                                                 "number_of_covered", "agency_id")],
    agency_type = uom.usis::USIS_agencies[uom.usis::USIS_inspections[inspection_ids, "agency_id"]],
    
    # Workplace data
    workplace_id = workplace_ids,
    establishment_id = establishment_ids,
    establishment_type = uom.usis::USIS_establishments[establishment_ids, "type"],
    location_id = location_ids,
    territory_id = territory_ids,
    territory_name = uom.usis::US_territories[territory_ids, "name"],
    uom.usis::USIS_locations[location_ids, c("city", "zip")],
    sic_id = uom.usis::USIS_workplaces[workplace_ids, "sic_id"],
    sic_name = uom.usis::SIC[match(uom.usis::USIS_workplaces[workplace_ids, "sic_id"],
                                   rownames(uom.usis::SIC)),
                             "name"],
    naics_id = uom.usis::USIS_workplaces[workplace_ids, "naics_id"],
    naics_name = uom.usis::NAICS[uom.usis::USIS_workplaces[workplace_ids, "naics_id"]],
    
    # Sheet data
    sheet_id = sheet_ids,
    sheet_number = uom.usis::USIS_sheets[sheet_ids, "number"],
    uom.usis::USIS_sheets[sheet_ids, c("exposure_duration", "duration_unit", "record_id")],
    
    # Measure data
    uom.usis::USIS_measures[measure_ids, c("number_of_exposed", "occ_id")],
    occ_name = uom.usis::OCC[match(uom.usis::USIS_measures[measure_ids, "occ_id"],
                                   rownames(uom.usis::OCC)),
                             "name"],
    uom.usis::USIS_measures[measure_ids, c("occ_title", "job_title", "exposure_frequency",
                                           "sample_date", "sample_type_id")],
    sample_type_name = uom.usis::USIS_sample_types[
      uom.usis::USIS_measures[measure_ids, "sample_type_id"]
    ],
    uom.usis::USIS_measures[measure_ids, c("exposure_assessment", "substance_id")],
    substance_name = uom.usis::USIS_substances[uom.usis::USIS_measures[measure_ids, "substance_id"]],
    uom.usis::USIS_measures[measure_ids, c("is_detected", "exposure_level", "measure_unit_id")],
    measure_unit_name = uom.usis::USIS_measure_units[
      uom.usis::USIS_measures[measure_ids, "measure_unit_id"]
    ],
    exposure_type_id = uom.usis::USIS_measures[measure_ids, "exposure_type_id"],
    exposure_type_name = uom.usis::USIS_exposure_types[
      uom.usis::USIS_measures[measure_ids, "exposure_type_id"]
    ],
    uom.usis::USIS_measures[measure_ids, c("oel", "severity")]
  )
  rownames(joined_db) = measure_ids
  
  # Join establishment names or not
  if (estab_names) {
    joined_db$establishment_names = unname(get_establishment_names(joined_db$establishment_id))
    
    # Move the new column after establishment_id
    estab_id_index = which(names(joined_db) == "establishment_id")
    joined_db = joined_db[, c(seq_len(estab_id_index),
                              ncol(joined_db),
                              seq(estab_id_index + 1, ncol(joined_db) - 1))]
  }
  
  return(joined_db)
}



#### Measure selectors ####

#' Get IMIS or OIS measures
#' 
#' Extract from the dataset `USIS_measures` measurement data relating to IMIS or
#'  OIS database.
#' 
#' @inherit get_measures details
#' 
#' @return Data frame, subset of [`USIS_measures`].
#' 
#' @author Gauthier Magnin
#' @seealso To get all USIS measurement data: [`USIS_measures`].
#' @name get_USIS_measures
NULL

#' @rdname get_USIS_measures
#' 
#' @examples
#' ## Get IMIS measurement data
#' IMIS_data <- get_IMIS_measures()
#' 
#' @export
get_IMIS_measures = function() { get_measures(DB_IMIS) }

#' @rdname get_USIS_measures
#' 
#' @examples
#' ## Get OIS measurement data
#' OIS_data <- get_OIS_measures()
#' 
#' @export
get_OIS_measures  = function() { get_measures(DB_OIS) }


#' Get measures from IMIS, OIS or both databases
#' 
#' Extract from the dataset `USIS_measures` measurement data relating to IMIS or
#'  OIS database.
#' Can also be used to get `USIS_measures`.
#' 
#' @details
#' IMIS and OIS measures are distinguished using the variable `original_db`
#'  associated with the related inspections in the dataset `USIS_inspections`.
#'  Related inspections are identified through `USIS_measures$sheet_id` and
#'  `USIS_sheets$inspection_id`.
#' 
#' @param db Name of the database from wich to get data.
#'  Character corresponding to `DB_IMIS`, `DB_OIS` or `DB_USIS`.
#' @return Data frame, [`USIS_measures`] or subset of it.
#' 
#' @author Gauthier Magnin
#' 
#' @examples
#' ## Get all USIS measurement data
#' get_measures(DB_USIS)
#' 
#' ## Get OIS measurement data
#' get_measures(DB_OIS)
#' 
#' @keywords internal
#' 
get_measures = function(db) {
  if (db == DB_USIS) return(uom.usis::USIS_measures)
  return(uom.usis::USIS_measures[get_original_db() == db, ])
}



#### Data search ####

#' Get original database name
#' 
#' Extract original database names of the given measures.
#' 
#' @inherit get_measures details
#' 
#' @param measure_id Numeric or character. Identifiers of the measures for which
#'  to find their original databases. Any subset of `USIS_measures` rownames.
#'  If `NULL`, all measures are considered.
#' @return Factor whose levels are `"IMIS"` and `"OIS"`. Name of the original
#'  database corresponding to each given measure.
#' 
#' @author Gauthier Magnin
#' @seealso [`get_IMIS_measures`], [`get_OIS_measures`],
#'  [`get_establishment_names`].
#' 
#' @examples
#' ## Search for original databases of some measures
#' get_original_db(c(1, 2, 700000, 700001))
#' 
#' @export
#' 
get_original_db = function(measure_id = NULL) {
  
  if (is.null(measure_id)) measure_id = rownames(uom.usis::USIS_measures)
  else measure_id = format(measure_id, scientific = FALSE, trim = TRUE)
  # Function format is used instead of as.character so as not to convert 100000 to "1e+05"
  
  return(
    uom.usis::USIS_inspections[
      as.character(uom.usis::USIS_sheets[
        as.character(uom.usis::USIS_measures[measure_id, "sheet_id"]),
        "inspection_id"
      ]),
      "original_db"
    ]
  )
}


#' Get establishment names
#' 
#' Extract names of the given establishments from the dataset
#'  `USIS_estabishment_names`.
#' 
#' @param estab_id Identifiers of the establishments for which to find their
#'  names. Any subset of `USIS_establishments` rownames.
#'  If `NULL`, all establishments are considered.
#' @param as_vector Ignored if more than one identifier is given. `TRUE` or
#'  `FALSE` whether to return the result as a vector or a list.
#' @return Named list or unnamed vector (according to argument `as_vector`).
#'  Names associated with each given establishment.
#' 
#' @author Gauthier Magnin
#' @seealso [`get_IMIS_measures`], [`get_OIS_measures`], [`get_original_db`].
#' 
#' @examples
#' ## Get any establishment identifiers then find their names
#' establishments = rownames(USIS_establishments)[396:399]
#' get_establishment_names(establishments)
#' 
#' @export
#' 
get_establishment_names = function(estab_id = NULL, as_vector = TRUE) {
  
  # Set identifiers if no one was given and associated rows in the establishment name reference table
  if (is.null(estab_id)) {
    estab_id = rownames(uom.usis::USIS_establishments)
    rows = TRUE
  } else {
    rows = is.element(uom.usis::USIS_establishment_names[, "establishment_id"], estab_id)
  }
  
  # Group establishment names according to their identifiers
  estab_names = tapply(uom.usis::USIS_establishment_names[rows, "establishment_name"],
                       uom.usis::USIS_establishment_names[rows, "establishment_id"],
                       FUN = function(x) unname(c(x)),
                       simplify = FALSE)[estab_id]
  
  if (as_vector && length(estab_names) == 1) return(estab_names[[1]])
  
  # Remove dimensions otherwise can be both a list and an array in certain cases
  if (is.array(estab_names)) {
    list_names = names(estab_names)
    dim(estab_names) = NULL
    names(estab_names) = list_names
  }
  return(estab_names)
}


#' Get data origins
#' 
#' Get original dataset files and related rows of the given measures. This
#'  refers to the raw data.
#' 
#' @param measure_id Numeric or character. Identifiers of the measures for which
#'  to find their original dataset files and rows inside these datasets.
#'  Any subset of `USIS_measures` rownames.
#'  If `NULL`, all measures are considered.
#' @return Data frame containing two lists. Original dataset names and original
#'  rows inside these datasets, for each given measure.
#' 
#' @author Gauthier Magnin
#' 
#' @examples
#' ## Search for origins of some measures
#' get_origins(c(1, 2, 700000, 700001))
#' 
#' @export
#' 
get_origins = function(measure_id = NULL) {
  
  # Set identifiers if no one was given
  if (is.null(measure_id)) {
    measure_id = as.integer(rownames(uom.usis::USIS_measures))
  } else {
    measure_id = as.integer(measure_id)
  }
  
  # Adding lists in a data frame requires that it already contains data
  origins = data.frame(tmp = rep(NA, length(measure_id)))
  rownames(origins) = measure_id
  
  # Indices and numbers of rows from USIS_measure_origins corresponding to the measure IDs
  row_indices = which(uom.usis:::USIS_measure_origins$measure_id %in% measure_id)
  nb_rows = stats::setNames(
    as.vector(table(uom.usis:::USIS_measure_origins$measure_id)[as.character(measure_id)]),
    measure_id
  )
  
  # Create lists of original datasets and rows for each measure ID
  origins$original_datasets = unname(split(
    uom.usis:::USIS_measure_origins$original_dataset[row_indices],
    rep.int(measure_id, nb_rows)
  ))
  origins$original_rows = unname(split(
    uom.usis:::USIS_measure_origins$original_row[row_indices],
    rep.int(measure_id, nb_rows)
  ))
  
  # Remove the temporary column and return
  origins$tmp = NULL
  return(origins)
}
