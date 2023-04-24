# uom.usis 0.1.1.9000-1 (development version)

## Fixes

* Incorrect values were returned by functions `join_USIS`, `join_IMIS` and `join_OIS` in variables `inspection_type_name`, `sample_type_name`, `measure_unit_name` and `exposure_type_name`:
    - `inspection_type_name` values were incorrect for measures having the following `inspection_type_id` values: `L2` and `M`.
    - `sample_type_name` values were incorrect for measures having the following `sample_type_id` value: `P`.
    - `measure_unit_name` values were incorrect for measures having the following `measure_unit_id` values: `D`, `F`, `G`, `L`, `M`, `P` and `R`.
    - `exposure_type_name` values were incorrect for measures having the following `exposure_type_id` values: `C`, `L`, `P` and `T`.

## Documentation

* A missing mention of a source has been added to the manuel of dataset `USIS_exposure_types`.



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
