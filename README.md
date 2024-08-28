# United States Information Systems


## Purpose

This **R package** contains **data about occupational exposure to chemicals** from databases managed by the U.S. Occupational Health and Safety Administration (OSHA). Access was obtained through successive freedom of information act (FOIA) requests for research purposes for several years[^1]. The package contains the results of documentation, cleaning and standardization efforts applied to the data obtained.

The development of this package is part of a research study led by **Jérôme Lavoué** (Professor at [University of Montreal](https://recherche.umontreal.ca/english/home/), department of environmental health and occupational health) whose title is "Portrait of multiexposure situations in the workplace in Quebec from occupational exposure databases". The essence of this study is to explore several occupational exposure databases to identify and describe patterns of co-occurrence of chemicals as defined, for example, by the presence of measurements showing detected concentrations for the same occupation within the same company. The work performed led to the creation of several R packages, including [uom.dat](https://github.com/UofMontreal-Multiexpo/uom.dat) (generic analysis tools), [uom.agents](https://github.com/UofMontreal-Multiexpo/uom.agents) (chemical agent data) and `uom.usis` (occupational exposure data).

[^1]: For example see:
  Lavoué, J., Vincent, R., Gérin, M. (2008). Formaldehyde Exposure in U.S. Industries from OSHA Air Sampling Data. *Journal of Occupational and Environmental Hygiene, 5*(9), 575-587. PMID: 18618336.
  Lavoué, J., Burstyn, I., Friesen, M. (2012). Workplace Measurements by the US Occupational Safety and Health Administration since 1979: Descriptive Analysis and Potential Uses for Exposure Assessment. *Annals of Occupational Hygiene, 57*(1), 77-97. PMID: 22952385.
  Burstyn, I., Sarazin, P., Luta, G., Friesen, M. C., Kincl, L., Lavoué, J. (2023). Prerequisite for Imputing Non-detects among Airborne Samples in OSHA's IMIS Databank: Prediction of Sample's Volume. *Annals of Work Exposures and Health, 67*(6), 744-757. PMID: 36975192.


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


## Contact

For any inquiries, you can send an email to Jérôme Lavoué at <jerome.lavoue@umontreal.ca>.


## Authors

* [Gauthier Magnin](https://fr.linkedin.com/in/gauthier-magnin) - R programmer analyst.
* [Isabelle Valois](https://espum.umontreal.ca/lespum/departement-de-sante-environnementale-et-sante-au-travail/lequipe-du-departement/agents-et-professionnels-de-recherche/) - Research officer at University of Montreal.
* [Delphine Bosson-Rieutort](https://espum.umontreal.ca/lespum/departement-de-gestion-devaluation-et-de-politique-de-sante/lequipe-du-departement/personnel-enseignant/professeur/in/in30464/sg/Delphine%20Bosson-Rieutort/) - Assistant professor at University of Montreal School of Public Health.


## Collaboration

* [OSHA](https://www.osha.gov/): Occupational Safety and Health Administration, agency of the United States Department of Labor.
