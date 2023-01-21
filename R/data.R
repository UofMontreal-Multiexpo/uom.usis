
#' North American Industry Classification System
#' 
#' The version of 2002 of the North American Industry Classification System
#'  (NAICS). It is a hierarchical classification of 5 levels: sectors,
#'  subsectors, industry groups, NAICS industries and national industries.
#'  Only United States industries are considered. Other national industries
#'  (i.e., used in Canada and Mexico) are not.
#' 
#' @format Named vector of 2,341 elements.
#' @source Manual for the North American industry classification system of 2002
#'  used in the United States, published by the National Technical Information
#'  Service.
#'  
#'  Executive Office of the President, Office of Management and Budget, 2002.
#'  *North American Industry Classification System: United States, 2002*.
#'  Springfield, Virginia (United States): National Technical Information
#'  Service, 1,419 p. ISBN: 0-934213-86-0.
#'  
#'  A version of this document (digitized by Google; original from Purdue
#'  University) is available on the HathiTrust Digital Library website
#'  [here](https://hdl.handle.net/2027/pur1.32754074680129).
#'  An extract of this document containing the class definitions is available
#'  on the official website of the United States Census Bureau
#'  [here](https://www.census.gov/naics/2002NAICS/2002_Definition_File.pdf).
#'  An interactive version is also available on the website of the United States
#'  Census Bureau [here](https://www.census.gov/naics/?58967?yearbck=2002).
"NAICS"


#' U.S. census occupational classification system
#' 
#' The version of 1980 of the United States census occupational classification
#'  system (OCC). The occupations are organized into several large groupings of
#'  socioeconomic status. Some of these occupation categories are recursively
#'  subdivided into several sub-categories.
#' 
#' @format Matrix of 506 rows (whose names are occupation identifiers) and 5
#'  columns:
#'  \describe{
#'    \item{`name`}{Name of the occupation.}
#'    \item{`category_level_1`}{Occupation category, level 1.}
#'    \item{`category_level_2`}{Occupation category, level 2.}
#'    \item{`category_level_3`}{Occupation category, level 3.}
#'    \item{`category_level_4`}{Occupation category, level 4.}
#'  }
#' @source
#'  Occupation identifiers and names were obtained from the IPUMS-USA website,
#'  on the page dedicated to the
#'  [1980 occupation codes](https://usa.ipums.org/usa/volii/occ1980.shtml).
#'  
#'  Occupation categories were obtained from a technical documentation available
#'  on the official website of the United States Census Bureau
#'  [here](https://www2.census.gov/prod2/decennial/documents/D1-D80-S300-14-TECH.pdf).
#'  The occupation list is presented in appendix B6 (pages 462 to 477 of the PDF
#'  file).
#'  
#'  Bureau of the Census, 1982. *Census of Population and Housing, 1980: Summary
#'  Tape File 3, Technical Documentation*. Washington, D.C. (United States): The
#'  Bureau. Appendix B6, Occupational Classification Codes for Detailed
#'  Occupational Categories, p. 421-436.
"OCC"


#' U.S. Standard Industrial Classification
#'
#' The version of 1987 of the United States standard industrial classification
#'  (SIC). It is a hierarchical classification of 4 levels: divisions, major
#'  groups, industry groups and industries.
#'
#' @format Matrix of 1,514 rows (whose names are activity identifiers) and 2
#'  columns:
#'  \describe{
#'    \item{`name`}{Name of the activity.}
#'    \item{`division`}{Division to which the activity is attached.}
#'  }
#' @source Manual for the United States standard industrial classification of
#'  1987, published by the National Technical Information Service.
#'  
#'  Executive Office of the President, Office of Management and Budget, 1987.
#'  *Standard Industrial Classification Manual*. Springfield, Virginia (United
#'  States): National Technical Information Service, 705 p. ISBN: 9997807650.
#'  
#'  A version of this document can be found
#'  [here](https://www.dropbox.com/s/qjheehrqfav3g9r/United\%20States\%20Standard\%20Industrial\%20Classification\%20-\%20Reference\%20document.pdf?dl=0).
#'  An interactive version is available on the official website of the
#'  Occupational Safety and Health Administration of the United States
#'  Department of Labor [here](https://www.osha.gov/data/sic-manual).
"SIC"


#' U.S. territories
#' 
#' States and other inhabited territories of the United States.
#' Associate territory identifiers with territory names and types.
#' 
#' @format Matrix of 56 rows (whose names are territory identifiers) and 2
#'  columns:
#'  \describe{
#'    \item{`name`}{Name of the territory.}
#'    \item{`type`}{Type of the territory.}
#'  }
#' @source 
#'  WIKIPEDIA. *List of states and territories of the United States* \[online\].
#'  Available at
#'  <https://en.wikipedia.org/wiki/List_of_states_and_territories_of_the_United_States>
#'  \[accessed 12 January 2023\].
"US_territories"


#' USIS agencies
#' 
#' Agencies responsible for conducting inspections.
#' Associate agency identifiers with agency types.
#' 
#' @format Named factor of 263 elements.
#' @source Data provided by the [OSHA](https://www.osha.gov/).
"USIS_agencies"


#' USIS establishment names
#' 
#' Associate establishment identifiers with their names.
#' 
#' @template establishment_identifiers
#' 
#' @format Matrix of 80,029 rows and 2 columns:
#'  \describe{
#'    \item{`establishment_id`}{Identifier of an establishment.}
#'    \item{`establishment_name`}{Name of the establishment.}
#'  }
#' @source
#'  Establishment names are data provided by the [OSHA](https://www.osha.gov/).
#'  Establishment identifiers were created (see 'Details' section).
"USIS_establishment_names"


#' USIS establishments
#' 
#' Establishments in which inspections were conducted.
#' Associate establishment identifiers with establishment types and location
#'  identifiers.
#' 
#' @template establishment_identifiers
#' @template location_identifiers
#' 
#' @format Data frame of 77,519 rows (whose names are establishment identifiers)
#'  and 2 variables:
#'  \describe{
#'    \item{`type`}{Type of the establishment.}
#'    \item{`location_id`}{Identifier of the location of the establishment.}
#'  }
#' @source Data provided by the [OSHA](https://www.osha.gov/), except
#'  establishment and location identifiers (see 'Details' section).
"USIS_establishments"


#' USIS exposure types
#' 
#' Types of exposure reported. Types of standard verified by the samples.
#' Associate exposure type identifiers with exposure type names.
#' 
#' @note
#' Exposure type "F" for "Not Detected (N/D) or Not Found (N/F)" originally used
#'  in IMIS data and listed in the document mentionned in 'Source' section was
#'  not included in this dataset since this category does not express a type of
#'  standard and is no longer used in OIS data.
#'  See in [`USIS_measures`] the variable named `is_detected` used to define if
#'  the sampled substance is actually detected.
#' 
#' @format Named vector of 8 elements.
#' @source
#'  Division of Occupational Safety and Health, 1995.
#'  *Air Sampling Report (OSHA 91(S))*.
#'  Policy and Procedures Manual no. C-91, 16 p.
#'  
#'  A version of this document can be found on the California Department of
#'  Industrial Relations website
#'  [here](https://www.dir.ca.gov/DOSHPol/P&PC-91.pdf).
"USIS_exposure_types"


#' USIS inspection types
#' 
#' Types of inspection conducted. Reasons for inspection.
#' Associate inspection type identifiers with inspection type names and
#'  schedules.
#' 
#' @details
#' Inspection type identifiers C1, L1 and L2 were created because their
#'  corresponding types are only used in OIS data and type identifiers does not
#'  exist in OIS data. These are sub-categories of types C and L.
#'  Such inspections may exist in IMIS data but are labeled C and L.
#' 
#' Inspection types A and M may have been confused in some data.
#' 
#' @format Matrix of 16 rows (whose names are inspection type identifiers) and 2
#'  columns:
#'  \describe{
#'    \item{`name`}{Name of the inspection type.}
#'    \item{`schedule`}{Schedule of the inspection type.}
#'  }
#' @source Data provided by the [OSHA](https://www.osha.gov/) and data from a
#'  file named "osha_data_dictionary" available on a website of the U.S.
#'  Department of Labor
#'  [here](https://enfxfr.dol.gov/data_catalog/OSHA/osha_data_dictionary_20230119.csv.zip),
#'  except some identifers (see 'Details' section).
"USIS_inspection_types"


#' USIS inspections
#' 
#' Inspections conducted in the United States between 1971 and 2021 by both
#'  federal and state agencies which carry out federally-approved OSHA programs.
#'  Inspection data reported in two different databases: IMIS and OIS.
#' 
#' @template inspection_identifiers
#' @template workplace_identifiers
#' 
#' @format Data frame of 94,446 rows (whose names are inspection identifiers)
#'  and 9 variables:
#'  \describe{
#'    \item{`number`}{Number of the inspection.}
#'    \item{`original_db`}{Original database of the inspection data (IMIS or
#'          OIS).}
#'    \item{`inspection_type_id`}{Identifier of the inspection type.}
#'    \item{`scope_id`}{Identifier of the inspection scope.}
#'    \item{`was_notified`}{`TRUE` or `FALSE` whether advance notice of the
#'          inspection was given to the establishment inspected.
#'          Only available for IMIS data.}
#'    \item{`is_unionized`}{`TRUE` or `FALSE` whether employees covered by
#'          inspection are affiliated with a union.}
#'    \item{`number_of_covered`}{Number of employees covered by the inspection.
#'          Only available for OIS data.}
#'    \item{`agency_id`}{Identifier of the agency responsible for the
#'          inspection.}
#'    \item{`workplace_id`}{Identifier of the workplace where the inspection was
#'          conducted.}
#'  }
#' @source Data provided by the [OSHA](https://www.osha.gov/), except inspection
#'  and workplace identifiers (see 'Details' section).
"USIS_inspections"


#' USIS locations
#' 
#' Locations of the establishments in which inspections were conducted.
#' Associate location identifiers with U.S. territories, cities and zip codes.
#' 
#' @template location_identifiers
#' 
#' @format Data frame of 18,693 rows (whose names are location identifiers) and
#'  3 variables:
#'  \describe{
#'    \item{`territory_id`}{Identifier of the U.S. territory corresponding to
#'          the location.}
#'    \item{`city`}{City corresponding to the location.}
#'    \item{`zip`}{Postal code corresponding to the location.}
#'  }
#' @source Data provided by the [OSHA](https://www.osha.gov/), except location
#'  identifiers (see 'Details' section).
"USIS_locations"


#' USIS measure units
#' 
#' Units in which the measured exposure levels are expressed.
#' Associate unit identifiers with unit names.
#' 
#' @format Named vector of 12 elements.
#' @source
#'  Division of Occupational Safety and Health, 1995.
#'  *Screening Report (OSHA 98)*.
#'  Policy and Procedures Manual no. C-98, 4 p.
#'  
#'  A version of this document can be found on the California Department of
#'  Industrial Relations website
#'  [here](https://www.dir.ca.gov/DOSHPol/P&PC-98.pdf).
"USIS_measure_units"


#' USIS measures
#' 
#' Industrial hygiene measurements in the United States between 1971 and 2021.
#'  It contains results of inspections conducted by both federal and state
#'  inspectors.
#' 
#' @details
#' Measure identifiers were created for all measures.
#' @template sheet_identifiers
#' 
#' @note
#' Further works will be to identify the versions of the U.S. census
#'  occupational classification systems used for data of the variable
#'  `occ_title` as well as the corresponding identifiers.
#'  This will lead to the removal of the variable `occ_title` and to the
#'  completion of the variable `occ_id` (currently `NA` when `occ_title` is
#'  not).
#' 
#' @format Data frame of 765,647 rows (whose names are measure identifiers) and
#'  16 variables:
#'  \describe{
#'    \item{`number_of_exposed`}{Number of employees exposed to the hazard.
#'          Only available for IMIS data.}
#'    \item{`occ_id`}{Identifier of the occupation of the employee sampled, or
#'          of the employee the most at risk from exposure, according to the
#'          U.S. census occupational classification system of 1980.
#'          Only available for IMIS data.}
#'    \item{`occ_title`}{Occupation title of the employee sampled, or of the
#'          employee the most at risk from exposure, according to the U.S.
#'          census occupational classification system.
#'          Only available for OIS data.}
#'    \item{`job_title`}{Descriptive job title of the employee being sampled, or
#'          of the employee the most at risk from exposure.}
#'    \item{`exposure_frequency`}{Frequency of exposure for all exposed
#'          employees.}
#'    \item{`sample_date`}{Sampling date.}
#'    \item{`sample_type_id`}{Identifier of the type of sample taken.}
#'    \item{`exposure_assessment`}{Identifier of an exposure assessment.
#'          Only available for OIS data.}
#'    \item{`substance_id`}{Identifier of the sampled substance.}
#'    \item{`is_detected`}{`TRUE` or `FALSE` whether the sampled substance has
#'          been detected.}
#'    \item{`exposure_level`}{Concentration, level of exposure.}
#'    \item{`measure_unit_id`}{Identifier of the unit of the measure in which
#'          the exposure level and the OEL are expressed.}
#'    \item{`exposure_type_id`}{Identifier of the type of exposure reported.}
#'    \item{`oel`}{Occupational Exposure Limit corresponding to the type of
#'          exposure and to the sampled substance.}
#'    \item{`severity`}{The severity of exposure. It corresponds to the exposure
#'          level with regard to the exposure limit.}
#'    \item{`sheet_id`}{Identifier of the sample sheet to which the measure is
#'          attached.}
#'  }
#' @source Data provided by the [OSHA](https://www.osha.gov/), except measure
#'  and sheet identifiers (see 'Details' section).
"USIS_measures"


#' USIS sample types
#' 
#' Types of sample taken.
#' Associate sample type identifiers with sample type names.
#' 
#' @format Named vector of 7 elements.
#' @source
#'  Division of Occupational Safety and Health, 1995.
#'  *Air Sampling Report (OSHA 91(S))*.
#'  Policy and Procedures Manual no. C-91, 16 p.
#'  
#'  A version of this document can be found on the California Department of
#'  Industrial Relations website
#'  [here](https://www.dir.ca.gov/DOSHPol/P&PC-91.pdf).
"USIS_sample_types"


#' USIS scopes
#' 
#' Coverages of inspection conducted.
#' Associate scope identifiers with scope names.
#' 
#' @format Named vector of 4 elements.
#' @source Data provided by the [OSHA](https://www.osha.gov/).
"USIS_scopes"


#' USIS sheets
#' 
#' Sample sheets corresponding to sampling experiences during inspections.
#' 
#' @template sheet_identifiers
#' @template inspection_identifiers
#' 
#' @format Data frame of 339,755 rows (whose names are sheet identifiers) and 5
#'  variables:
#'  \describe{
#'    \item{`number`}{Number of the sample sheet.}
#'    \item{`exposure_duration`}{Duration of time the hazard has existed.
#'          Only available for OIS data.}
#'    \item{`duration_unit`}{Unit of the exposure duration.
#'          Only available for OIS data.}
#'    \item{`record_id`}{Identifier of the related exposure record, identifying
#'          the area or employee sampled.
#'          Only available for OIS data.}
#'    \item{`inspection_id`}{Identifier of the inspection to which the sample
#'          sheet is attached.}
#'  }
#' @source Data provided by the [OSHA](https://www.osha.gov/), except sheet
#'  and inspection identifiers (see 'Details' section).
"USIS_sheets"


#' USIS substances
#' 
#' Substances sampled.
#' Associate substance identifiers with substance names.
#' 
#' @format Named vector of 1,243 elements.
#' @source Data provided by the [OSHA](https://www.osha.gov/) and data from
#'  other OSHA resources.
#'  
#'  A list of substance names and identifiers is available on the official
#'  website of the Occupational Safety and Health Administration
#'  [here](https://www.osha.gov/chemicaldata/search).
#'  
#'  A version of the following document can be found on the State of Michigan
#'  website
#'  [here](https://www.michigan.gov/-/media/Project/Websites/leo/Documents/MIOSHA24/vii_imis_code_appendixc_cim_2006v042.pdf).
#'  
#'  Occupational Safety and Health Administration, National Institute for
#'  Occupational Safety and Health, 2006. *Chemical Information Manual*. Version
#'  4.2. Michigan (United States): Michigan Occupational Safety and Health
#'  Administration. Appendix C, Index to Substances by IMIS Code, 35 p.
#'  
#'  A version of the following document (digitized by Google; original from
#'  Indiana University) is available via Google Books
#'  [here](https://books.google.fr/books?id=7c7jMCXM148C&pg=PP5&source=gbs_selected_pages&cad=3#v=onepage&q&f=false).
#'  
#'  U.S. Department of Labor, Occupational Safety and Health Administration,
#'  1984. *Industrial Hygiene Technical Manual*. Volume VI. Washington, D.C.
#'  (United States): U.S. Government Printing Office. Appendix A, Chemical
#'  Information Table, p. A1-A282.
"USIS_substances"


#' USIS workplaces
#' 
#' Workplaces where samples were taken. One workplace is defined by one
#'  establishment and at least one industry class.
#' 
#' @template workplace_identifiers
#' @template establishment_identifiers
#' 
#' @note
#' Only the version of 2002 of the North American Industry Classification System
#'  is currently available in the reference table [`NAICS`]. This version allows
#'  to identify almost all values of `naics_id`.
#'  Further works will be to identify the NAICS versions associated with values
#'  not belonging to the one of 2002. This will lead to a modification of the
#'  structures of the datasets `NAICS` and/or `USIS_workplaces`.
#' 
#' @format Matrix of 82,106 rows (whose names are workplace identifiers) and 3
#'  columns:
#'  \describe{
#'    \item{`establishment_id`}{Identifier of the establishment.}
#'    \item{`sic_id`}{Identifier of the industry, according to the U.S. Standard
#'          Industrial Classification of 1987.
#'          Only available for IMIS data.}
#'    \item{`naics_id`}{Identifier of the industry, according to the North
#'          American Industry Classification System.}
#'  }
#' @source Data provided by the [OSHA](https://www.osha.gov/), except workplace
#'  and establishment identifiers (see 'Details' section).
"USIS_workplaces"
