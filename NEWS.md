# uom.usis 1.0.0.9000-3 (development version)

## Data

* In datasets `USIS_inspections` and `USIS_sheets`, columns previously named `number` are now named `inspection_number` and `sheet_number`.
* In dataset `USIS_locations`, the location identified NA-NA-NA and associated with no territory, no city and no zip has been removed. In dataset `USIS_establishments`, the location ID NA-NA-NA has been replaced by the value `NA`.
* In dataset `US_territories`, values "Other territory" in column `Type` have been replaced by "Territory".
* All raw data files are now available in the Dropbox folder (see the package main help page) instead of being split between it and the Github repository.

## Documentation

* The relationships between the numbers of characters of the class identifiers and the hierarchical structures of classifications SIC and NAICS are now mentioned in the help pages of datasets `SIC` and `NAICS`.
* In dataset help pages, types or classes are now mentioned for all datasets and all columns of data frames (character, numeric, Date, etc.).
* Dataset help pages now state that establishments can be associated with no locations and that locations can be associated with no cities or zip codes.
* References to “U.S. territories” have been replaced by “U.S. territorial divisions”.
* A small space (more specifically, a narrow non-breaking space) is now used instead of a comma as a digit group separator in numbers.
* Corrections have been applied to the PDF file.
    - Relationship cardinalities have been corrected in figure 1.
    - Missing variable `inspection_number` has been added in table 1.
    - The term "variable" has been replaced by "field".



# uom.usis 1.0.0-3 (2023-09-19)

`uom.usis` is now under the CC-BY License.
Its GitHub repository is now publicly available.

## Documentation

* OSHA has been added to the package help page as data contributor.



# uom.usis 0.1.2-3 (2023-05-30)

## Data

* Measures associated with exposure levels lower than 0 have been removed (2 measures).
* As a side effect, measure identifiers after ID 701100 have changed.



# uom.usis 0.1.2-2 (2023-04-24)

## Data

* A missing substance (ID 0473) has been added in the substance reference table.
* An incorrect substance name (ID 0472) has been changed in the substance reference table.
* All measures associated with the following measure units have been removed: % (percentage), D (milligrams per deciliter, blood), G (million particles per cubic foot), L (milligrams per liter, urine) and R (millirems).
* Measures for which measure units were inconsistent with the sampled substances have been removed.
* Measures associated with substances whose names contain the mention "Action Level" have been added.
* Some measures having been added and others having been removed, the preceding changes result in the following differences in the total numbers.
    - 308 fewer measures.
    - 739 fewer sheets.
    - 199 fewer inspections.
    - 191 fewer workplaces.
    - 183 fewer establishments.
    - 6 fewer locations.

## Fixes

* Incorrect values were returned by functions `join_USIS`, `join_IMIS` and `join_OIS` in variables `inspection_type_name`, `sample_type_name`, `measure_unit_name` and `exposure_type_name`:
    - `inspection_type_name` values were incorrect for measures having the following `inspection_type_id` values: L2 and M.
    - `sample_type_name` values were incorrect for measures having the following `sample_type_id` value: P.
    - `measure_unit_name` values were incorrect for measures having the following `measure_unit_id` values: D, F, G, L, M, P and R.
    - `exposure_type_name` values were incorrect for measures having the following `exposure_type_id` values: C, L, P and T.

## Documentation

* A missing mention of a source has been added to the manual of dataset `USIS_exposure_types`.



# uom.usis 0.1.1-1 (2023-03-10)

## Documentation

* In the PDF file, the unary relation concerning SIC (between `division` and `id`) has been added to figure 1.
* The package help page has been modified:
    - The main interlocutor (i.e., the maintainer) has changed.
    - The copyright holder and funder has been added.
    - Additional information about authors has been added.



# uom.usis 0.1.0-1 (2023-01-26)

Initial stable release version.


---
