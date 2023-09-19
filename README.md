# United States Information Systems


## Purpose

Make data about occupational exposure to chemicals available in an R package.


## Data

Exposure data are from the **IMIS** database (Integrated Management Information System) and its successor the **OIS** database (OSHA Information System). Raw data used from these databases and CSV format of final datasets are available in this [Dropbox folder](https://www.dropbox.com/sh/09ygmyw7ds5myz3/AADtdE2LMbDphVwjPzbWNDbRa?dl=0).

The **OSHA** (USA's Occupational Safety and Health Administration) hosts the original IMIS and OIS data. The University of Montreal is **not** the owner of IMIS and OIS data.


## Installation

To install the latest version, run the following instruction.
```r
remotes::install_github("UofMontreal-Multiexpo/uom.usis")
```

To install the development version, use:
```r
remotes::install_github("UofMontreal-Multiexpo/uom.usis",
                        ref = "develop")
```

To install a previous version, run the following instruction, replacing `X.X.X-X` with the desired version number.
```r
remotes::install_github("UofMontreal-Multiexpo/uom.usis",
                        ref = "vX.X.X-X")
```


## Documentation

The package main page can be accessed using:
```r
help("uom.usis")
```

In addition to the manuals of the package, data and functions accessible by the `help` function, the `inst/doc` directory contains:

* An organized list of the datasets and functions, in the file `list_of_help_pages.html`.
* A description of the IMIS and OIS data, in the file `USIS_database.pdf`.

These files can be accessed using `help(package = "uom.usis")` then clicking on "User guides, package vignettes and other documentation".


## Authors

* [Gauthier Magnin](https://fr.linkedin.com/in/gauthier-magnin) - R programmer analyst.
* [Isabelle Valois](https://espum.umontreal.ca/lespum/departement-de-sante-environnementale-et-sante-au-travail/lequipe-du-departement/agents-et-professionnels-de-recherche/) - Research officer at University of Montreal.
* [Delphine Bosson-Rieutort](https://espum.umontreal.ca/lespum/departement-de-gestion-devaluation-et-de-politique-de-sante/lequipe-du-departement/personnel-enseignant/professeur/in/in30464/sg/Delphine%20Bosson-Rieutort/) - Assistant professor at University of Montreal School of Public Health.


## Collaboration

* [OSHA](https://www.osha.gov/): Occupational Safety and Health Administration, agency of the United States Department of Labor.


---
