## ---- warning=FALSE, message = FALSE----------------------------------------------
## Package

library(tidyverse)

library(questionr) # pour describe()

# library(magrittr) # pour >%>

# library(flextable) # pour les tableaux

# library(knitr)

library(openxlsx) # ouvrir et sauvegarder en xlsx

# library(lubridate) # manipuler les dates

library(readxl)

# library(officer) # formatage flextable


## ---- label=datapath -------------------------------------------------------------
data_path <- "./data-raw/prep_imis_ois_20230113/"
data_ois_path   <- function(x) paste0(data_path, "OIS/",        x)
data_imis_path  <- function(x) paste0(data_path, "IMIS/",       x)
data_other_path <- function(x) paste0(data_path, "additional/", x)

data_tmp_path <- function(x) paste0("./tmp/", x)
dir.create(data_tmp_path(""), showWarnings = FALSE)


## ---- label=datachem, echo=TRUE---------------------------------------------------
oischem1011 <- openxlsx::read.xlsx(data_ois_path("Sampling - fed and state - 2010-2011 - chem for R.xlsx"))

oischem1014 <- openxlsx::read.xlsx(data_ois_path("Sampling - fed and state - 2010-2014 - chem for R.xlsx"))

oischem1213 <- openxlsx::read.xlsx(data_ois_path("Sampling - fed and state - 2012-2013 - chem for R.xlsx"))

oischem1415 <- openxlsx::read.xlsx(data_ois_path("Sampling - fed and state - 2014-2015 - chem for R.xlsx"))

oischem1617 <- openxlsx::read.xlsx(data_ois_path("Sampling - fed and state - 2016-2017 - chem for R.xlsx"))

oischem1819 <- openxlsx::read.xlsx(data_ois_path("Sampling - fed and state - 2018-2019 - chem for R.xlsx"))

oischem2021 <- openxlsx::read.xlsx(data_ois_path("Sampling - fed and state - 2020-2021 - chem for R.xlsx"))


## ---- label=datachem2-------------------------------------------------------------
# Nettoyage sommaire : La dernier ligne des DF n'est pas un enregistrement valide (RID = Count et les autres valeurs sont NA).

oischem1011 <- oischem1011[-1359,]
oischem1014 <- oischem1014[-55435,]
oischem1213 <- oischem1213[-30303,]
oischem1415 <- oischem1415[-46719,]
oischem1617 <- oischem1617[-46092,]
oischem1819 <- oischem1819[-38739,]
oischem2021 <- oischem2021[-10044,]

# Ajouter une variable pour reconnaître la source

## le jeu d'origine

oischem1011$iddf <- "oischem1011"
oischem1014$iddf <- "oischem1014" 
oischem1213$iddf <- "oischem1213"
oischem1415$iddf <- "oischem1415" 
oischem1617$iddf <- "oischem1617" 
oischem1819$iddf <- "oischem1819" 
oischem2021$iddf <- "oischem2021" 

## la ligne 

oischem1011$idno <- as.integer(rownames(oischem1011))
oischem1014$idno <- as.integer(rownames(oischem1014))
oischem1213$idno <- as.integer(rownames(oischem1213))
oischem1415$idno <- as.integer(rownames(oischem1415))
oischem1617$idno <- as.integer(rownames(oischem1617))
oischem1819$idno <- as.integer(rownames(oischem1819))
oischem2021$idno <- as.integer(rownames(oischem2021))

# Combiner les jeux de données

oischem <- as.data.frame(rbind(oischem1011, oischem1014, oischem1213, oischem1415, oischem1617, oischem1819, oischem2021))


# combiner les identifiants

oischem$id.dfno <-paste(oischem$iddf, oischem$idno,sep="_")


# Modifier format

oischem$Open.Conf.Date <- as.Date(oischem$Open.Conf.Date,  origin = "1899-12-30") 

oischem$Sampling.Date <- as.Date(oischem$Sampling.Date, origin = "1899-12-30")


# Renommer les variables

oischem <- oischem %>% rename(rid = RID, 
insp = Insp, 
estab.name = Estab.Name, 
open.conf.date = Open.Conf.Date, 
site.naics = Site.NAICS, 
csho.id = CSHO.ID, 
supv.id = Supv.ID, 
insp.type = Insp.Type, 
sampling.date = Sampling.Date, 
exposure.record = Exposure.Record, 
sample.sheet = Sample.Sheet, 
sample.type = Sample.Type, 
sheet.type = Sheet.Type, 
sheet.status = Sheet.Status, 
substance = Substance, 
exposure.concentration = Exposure.Concentration, 
exposure.units = Exposure.Units, 
oel.value = OEL.Value, 
severity = Severity, 
job.title = Job.Title, 
occupation.title = Occupation.Title, 
exposure.duration = Exposure.Duration, 
expo.duration.units = Expo.Duration.Units, 
exposure.frequency = Exposure.Frequency, 
analyst.comments = Analyst.Comments, 
strategic.program = Strategic.Program, 
emphasis.program = Emphasis.Program, 
additional.code = Additional.Code, 
exposure.assessment = Exposure.Assessment, 
updated.by = Updated.By, 
exposure.type = Exposure.Type
)

# Sauvegarde version intermédiaire

# write.xlsx(oischem, file = "C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/usa_data/data_intermediaire/oischem.xlsx")


## ---- label=n1, include=FALSE-----------------------------------------------------

# Retirer les DF inutiles

remove(oischem1011)
remove(oischem1014)
remove(oischem1213)
remove(oischem1415)
remove(oischem1617)
remove(oischem1819)
remove(oischem2021)

# retirer les variables inutiles

oischem$idno <- NULL



## ---- label=datainsp1, echo=TRUE--------------------------------------------------
# Jeux de données sur l'inspection

insp1 <- read.xlsx(data_ois_path("2010-2011 OIS for R.xlsx"))

insp2 <- read.xlsx(data_ois_path("2012-2013 OIS for R.xlsx"))

insp3 <- read.xlsx(data_ois_path("2014-2015 OIS for R.xlsx"))

insp4 <- read.xlsx(data_ois_path("2016-2017 OIS for R.xlsx"))

insp5 <- read.xlsx(data_ois_path("2018-2019 OIS for R.xlsx"))


## ---- label=datainsp2, echo=FALSE-------------------------------------------------
# Ajouter une variable pour reconnaître la source

## le jeu d'origine

insp1$iddf <- "insp.2010.2011"
insp2$iddf <- "insp.2012.2013"
insp3$iddf <- "insp.2014.2015"
insp4$iddf <- "insp.2016.2017"  
insp5$iddf <- "insp.2018.2019"  

## la ligne 

insp1$idno <- as.integer(rownames(insp1))
insp2$idno <- as.integer(rownames(insp2))
insp3$idno <- as.integer(rownames(insp3))
insp4$idno <- as.integer(rownames(insp4))
insp5$idno <- as.integer(rownames(insp5))

## les deux combinés


# Fusion  
insp <- rbind(insp1, insp2, insp3, insp4, insp5)


# combiner les identifiants

insp$id.dfno <-paste(insp$iddf, insp$idno, sep="_")

insp$idno <- NULL


# Renommer les variables pour faciliter l'utilisation

insp <- insp %>% rename(
  insp = `Insp.#`, 
case.status = Case.Status, 
rid = RID, 
estab.name = `Estab.Name/DBA`, 
business.address = Business.Address, 
mailing.address = Mailing.Address, 
site.address = Site.Address, 
ownership.type = Ownership.Type, 
primary.naics = Primary.NAICS, 
site.naics = Site.NAICS, 
emp.in.estab = `#.Emp.in.Estab`, 
emp.cvrd = `#.Emp.Cvrd`, 
emp.cntrld = `#.Emp.Cntrld`, 
`entry.date` = Entry.Date, 
open.conf.date = Open.Conf.Date, 
closing.conf.1.date = Closing.Conf.1.Date, 
exit.date = Exit.Date, 
isa.event.date = ISA.Event.Date, 
contest.date = Contest.Date, 
referred.to.dcat.date = Referred.to.DCAT.Date, 
closed.date = Closed.Date, 
insp.scope = Insp.Scope, 
insp.category = Insp.Category, 
insp.type = Insp.Type, 
reason.no.insp = Reason.No.Insp, 
primary.emphasis.program = Primary.Emphasis.Program, 
emphasis.program = Emphasis.Program, 
strategic.program = Strategic.Program, 
additional.code = Additional.Code, 
union = Union, 
sampling.performed = Sampling.Performed, 
svep = SVEP, 
denial.of.entry = Denial.of.Entry, 
citn.item.no = `Citn.Item.#`, 
current.vio.type = Current.Vio.Type, 
standard = Standard, 
initial.penalty = Initial.Penalty, 
current.penalty = Current.Penalty, 
issuance.date = Issuance.Date, 
final.order.date = Final.Order.Date, 
citn.status = Citn.Status, 
vio.desc = Vio.Desc, 
abatement.note = Abatement.Note, 
abatement.date = Abatement.Date, 
contest = Contest, 
abatement.status = Abatement.Status, 
abatement.due.date = Abatement.Due.Date, 
assessed.penalty = Assessed.Penalty, 
assessed.other = Assessed.Other, 
interest.and.fees = Interest.and.Fees, 
assessed.total = Assessed.Total, 
total.paid = Total.Paid, 
waived = Waived, 
refund = Refund, 
balance.due = Balance.Due, 
amount.referred.to.dcat = Amount.Referred.to.DCAT, 
preparation = Preparation, 
travel = Travel, 
onsite = Onsite, 
denial.warrant = `Denial/Warrant`, 
informal.conference = Informal.Conference, 
settlement.agreement = Settlement.Agreement, 
report.preparation = Report.Preparation, 
abate = Abate, 
litigate = Litigate, 
other.conference = Other.Conference, 
total.hours = Total.Hours, 
invest.rid = Invest.RID, 
invest.no = `Invest.#`, 
upa.no = `UPA.#`, 
invest.event.date = Invest.Event.Date, 
invest.event.time = Invest.Event.Time, 
construction.related = Construction.Related, 
)

# Conserver les variables essentielles pour compléter OIS selon le modèle d'IMIS

insp.select <- insp

insp.select$case.status <- NULL
insp.select$emp.in.estab <- NULL
insp.select$`entry.date` <- NULL
insp.select$closing.conf.1.date <- NULL
insp.select$exit.date <- NULL
insp.select$isa.event.date <- NULL
insp.select$contest.date <- NULL
insp.select$referred.to.dcat.date <- NULL
insp.select$closed.date <- NULL
insp.select$svep <- NULL
insp.select$denial.of.entry <- NULL
insp.select$citn.item.no <- NULL
insp.select$current.vio.type <- NULL
insp.select$standard <- NULL
insp.select$initial.penalty <- NULL
insp.select$current.penalty <- NULL
insp.select$issuance.date <- NULL
insp.select$final.order.date <- NULL
insp.select$citn.status <- NULL
insp.select$vio.desc <- NULL
insp.select$abatement.note <- NULL
insp.select$abatement.date <- NULL
insp.select$contest <- NULL
insp.select$abatement.status <- NULL
insp.select$abatement.due.date <- NULL
insp.select$assessed.penalty <- NULL
insp.select$assessed.other <- NULL
insp.select$interest.and.fees <- NULL
insp.select$assessed.total <- NULL
insp.select$total.paid <- NULL
insp.select$waived <- NULL
insp.select$refund <- NULL
insp.select$balance.due <- NULL
insp.select$amount.referred.to.dcat <- NULL
insp.select$preparation <- NULL
insp.select$travel <- NULL
insp.select$denial.warrant <- NULL
insp.select$informal.conference <- NULL
insp.select$settlement.agreement <- NULL
insp.select$report.preparation <- NULL
insp.select$abate <- NULL
insp.select$litigate <- NULL
insp.select$other.conference <- NULL
insp.select$total.hours <- NULL
insp.select$invest.rid <- NULL
insp.select$upa.no <- NULL
insp.select$invest.event.date <- NULL
insp.select$invest.event.time <- NULL
insp.select$construction.related <- NULL
insp.select$idno <- NULL

# Sauvegarde version intermédiaire

# write.xlsx(insp, file = "C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/usa_data/data_intermediaire/insp_all.xlsx")
# write.xlsx(insp.select, file = "C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/usa_data/data_intermediaire/insp_selected.xlsx")


# Changer le format de date

insp.select$open.conf.date <- as.numeric(insp.select$open.conf.date)

insp.select$open.conf.date <- as.Date(insp.select$open.conf.date, origin = "1899-12-30")



## ---- label=n2,  include=FALSE----------------------------------------------------
# Retrait des jeux d'origine

remove(insp1)
remove(insp2)
remove(insp3)
remove(insp4)
remove(insp5)



## ----  label=dataimis, echo=TRUE--------------------------------------------------

imis <- readRDS(data_imis_path("IMIS.merged.aug2017.RDS"))


## ----  label=dataimis2------------------------------------------------------------
# Modification format

imis$S.DATE <- as.Date(imis$S.DATE, format = "%Y%m%d")

# Renommer les variables pour les mettre en minuscule

imis <- imis %>% rename(activity.nr = ACTIVITY.NR,   state = STATE,   report.id = REPORT.ID,   establishment = ESTABLISHMENT,   city = CITY,   state.1 = STATE.1,   zip = ZIP,   sic = SIC,   insp.type = INSP.TYPE,   insp.scope = INSP.SCOPE,   union = UNION,   adv.notice = ADV.NOTICE,   form.type = FORM.TYPE,   occ.code = OCC.CODE,   anal.req = ANAL.REQ,   pel = PEL,   adj.pel = ADJ.PEL,   severity = SEVERITY,   s.nbr = S.NBR,   s.date = S.DATE,   subst = SUBST,   nr.exposed = NR.EXPOSED,   job.title = JOB.TITLE,   e.level = E.LEVEL,   e.type = E.TYPE,   s.type = S.TYPE,   exps.freq = EXPS.FREQ,   units = UNITS,   naics = NAICS,   year = YEAR)

# ajouter un marqueur d'identifiant de l'enregistrement du jeu d'origine

imis$iddf <- "imis_aug2017"  

imis$idno <- as.integer(rownames(imis))

imis$id.dfno <- paste(imis$iddf, imis$idno, sep = "_")



## ---------------------------------------------------------------------------------
## ajouter les noms (utilisation le fichier généré par subst_usData_brute qui se trouve dans Dropbox/SHARE Multiexpo_data/IMIS/usa_data/)

label.subs.usData <- readRDS(data_other_path("subst_usData_brute.RDS"))





## ---- label=chemclean1a,  include=FALSE-------------------------------------------
# 228 684

# identifier les substances NA

oischem$subs.na <- is.na(oischem$substance)
table(oischem$subs.na ) # 16 075 TRUE

# Identifier les enregistrements autre 

oischem$autre <- str_detect(oischem$substance,"T110|2587|8110|8111|8120|8130|8280|8310|8320|8330|8350|8360|8390|8400|8430|8470|8650|8880|8891|8893|8895|8920|9591|9613|9614|9838|B418|C730|E100|E101|F006|G301|G302|I100|L130|L131|L294|M102|M103|M104|M110|M124|M125|M340|P100|P200|Q100|Q115|Q116|Q118|R100|R252|R274|R278|S102|S108|S325|S777|V219|WFBW|BWPB|I200|L295")




## ---- label=chemclean1c,  include=FALSE-------------------------------------------

# conserver seulement les agents chimiques d'OIS

oischem <- filter(oischem, autre == FALSE)

oischem <- filter(oischem, subs.na == FALSE)
      
# 228 684 - 16 075 - 15 547 = 197 062







## ---- label=chemclean3b, include=FALSE--------------------------------------------
# Retrait des units non désiré

oischem$unit.v <- oischem$exposure.units == "Bar Meters per Second" |
oischem$exposure.units == "cubic centimenter per minute" |
oischem$exposure.units == "CFU/m3" |
oischem$exposure.units == "cubic centimeter" |
oischem$exposure.units == "fiber per milimeter squared" |
oischem$exposure.units == "microgram per centimeter squared" |
oischem$exposure.units == "microgram per sample" |
oischem$exposure.units == "micrograms per gram" |
oischem$exposure.units == "micrograms per punch" |
oischem$exposure.units == "milligram per centimeter squared" |
oischem$exposure.units == "milligram per filter" |
oischem$exposure.units == "milligram per sample" |
oischem$exposure.units == "milligram per square foot" |
oischem$exposure.units == "Newton" |
oischem$exposure.units == "None" |
oischem$exposure.units == "parts per billion" |
oischem$exposure.units == "percent of slope" |
oischem$exposure.units == "Unknown" |
oischem$exposure.units == "year"




## ---- label=chemclean3d, include=FALSE--------------------------------------------
# retirer les unités non désirées

oischem <- filter(oischem, unit.v == FALSE)

# 197 062 - 2 330 = 194 732




## ---- label=n3a, include = FALSE--------------------------------------------------
oischem$subs.na <- NULL
oischem$autre <- NULL
oischem$unit.v <- NULL












## ---- label=n5a, include=FALSE----------------------------------------------------
# oischem 194 732

oischem <- filter(oischem, iddf != "oischem1014")








## ---- label=inspclean4, include=FALSE---------------------------------------------
# Conserver uniquement les valeurs sans correspondance dans insp

## oischem.nodata <- filter(oischem, el == FALSE) # 37 237 enregistrements

# conserver une valeur par combinaisons

## oischem.nodata <- as.data.frame(table(oischem.nodata$insp, oischem.nodata$open.conf.date))

## oischem.nodata <- filter(oischem.nodata, Freq > 0)

# sauvegarde

## write.xlsx(oischem.nodata, file = "C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/OIS FOIA 2021/oischem_nodata.xlsx")


# Nouvelles informations

## Ouvrir le jeu qui résulte de la récupération effectué par JFS

insp.web <- read_excel(data_ois_path("oischem_nodetail_JFS.xlsx"))

## ajouter les variables d'identification

insp.web$iddf <- "insp.recup.web" # id source

insp.web$idno <- as.integer(rownames(insp.web)) #  no ligne

insp.web$id.dfno <-paste(insp.web$iddf, insp.web$idno, sep="_") # combiner les identifiants

insp.web$idno <- NULL



## ---- include=FALSE---------------------------------------------------------------
# l'inspection 1417182 n'a pas la même date. Les trois enregistrements sont éliminés

oischem$t <- str_detect(oischem$insp, "1417182")


## ---- include=FALSE---------------------------------------------------------------
oischem <- filter(oischem, t == FALSE)

oischem$t <- NULL

## retirer l'enregistrement avec une différence de temps

insp.web <- filter(insp.web, timediff == 0)



## ---- label=inspclean7, include=FALSE---------------------------------------------

# Variables à ajouter dans insp.web

insp.web$business.address <- NA
insp.web$emp.cntrld <- NA
insp.web$emp.cvrd <- NA
insp.web$insp.category <- NA
insp.web$invest.no <- NA
insp.web$onsite <- NA
insp.web$ownership.type <- NA
insp.web$primary.emphasis.program <- NA
insp.web$reason.no.insp <- NA
insp.web$rid <- NA
insp.web$sampling.performed <- NA
insp.web$site.naics <- NA
insp.web$strategic.program <- NA
insp.web$primary.naics <- NA

# variables à éliminer dans insp.select

insp.select$additional.code <- NULL # présente dans oischem
insp.select$combif <- NULL # variable temporaire, ajouté pour fin de test
insp.select$el <- NULL # variable temporaire, ajouté pour fin de test
insp.select$emphasis.program <- NULL# présente dans oischem
insp.select$estab.name <- NULL # présente dans oischem

# renommer les variables pour qu'elles aient le même nom

insp.web <- insp.web %>% rename(site.address = location, insp.scope = scope, insp.type	= inspectiontype, union	= unionstatus)




## ---- label=inspclean8b, include=FALSE--------------------------------------------
#### Extraire le 1er motif

insp.select$state.2  <- str_extract(insp.select$site.address, ",[:alpha:]{2},[:digit:]") 

insp.select$state.2  <- str_remove_all(insp.select$state.2, ",") 

insp.select$state.2  <- str_remove_all(insp.select$state.2, "[:digit:]")


## ---- label=inspclean8d, include=FALSE--------------------------------------------
#### extraire le motif

insp.select$state.3  <- str_extract(insp.select$site.address, ",[:alpha:]{2},.UNITED") 

insp.select$state.3  <- str_remove_all(insp.select$state.3, ",") 

insp.select$state.3  <- str_remove_all(insp.select$state.3, ".UNITED")


## ---- label=inspclean8f, include=FALSE--------------------------------------------
### combiner résultat 1 et 2

insp.select$state.1 <- if_else(is.na(insp.select$state.2), insp.select$state.3, insp.select$state.2)


## ---- label=inspclean8h, include=FALSE--------------------------------------------
### éliminer les résultats intermédiaires

insp.select$state.2 <- NULL

insp.select$state.3 <- NULL


## ---- label=inspclean8j, include=FALSE--------------------------------------------
## insp.web

insp.web$state.1 <- str_count(insp.web$site.address, ", [:upper:][:upper:]") # compte le motif


## ---- label=inspclean8l, include=FALSE--------------------------------------------
insp.web$state.1 <- str_extract(insp.web$site.address, ", [:upper:][:upper:]") # Isole le motif

insp.web$state.1 <- str_remove(insp.web$state.1, ", ") # retire la virgule et l'espace


## ---- label=inspclean8n, include=FALSE--------------------------------------------
insp.select$zip <- str_extract(insp.select$site.address,  "[:digit:]{5} UNITED") # conserve uniquement le code postal

insp.select$zip <- str_remove(insp.select$zip,  " UNITED") # retirer ce qui n'est pas le code postal


## ---- label=inspclean8p, include=FALSE--------------------------------------------
insp.web$zip <- str_extract(insp.web$site.address,  "[:digit:]{5}$") # conserve uniquement le code postal


## ---- label=inspclean8r, include=FALSE--------------------------------------------
### isoler le nom de la ville 

insp.select$city <- str_extract(insp.select$site.address,".{20,}[:alpha:]{2},[:digit:]{5}")

insp.select<- insp.select %>% relocate(city, .after = site.address)

insp.select$city <- str_remove(insp.select$city, ",[:alpha:]{2},[:digit:]{5}") # retire l'état et le code postal

insp.select$city2 <- str_extract(insp.select$city, "(?<=, ).{2,}") # ?<= signifit précédé par  

insp.select$city2 <- str_remove(insp.select$city2, ".{2,}(?=,, )")

insp.select<- insp.select %>% relocate(city2, .after = site.address)

insp.select$city2  <- str_remove(insp.select$city2, ",, ")


## ---- label=inspclean8t, include=FALSE--------------------------------------------
### nouveau NA

city <- filter(insp.select, is.na(insp.select$city2))

### extraction avec un nouveau motif

city$city1 <- str_extract(city$site.address,",, .{20,}[:alpha:]{2},")

city2 <- as.data.frame(table(city$site.address))

# write.xlsx(city2, file = "C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/usa_data/data_intermediaire/city_ois.xlsx")

### Les noms de ville ont été isolé manuellement dans le fichier excel

city.modif<- openxlsx::read.xlsx(data_other_path("city_ois_modif.xlsx"))

### faire correspondre Site.Adress pour marquer le nom isoler manuellement

insp.select$city3 <- city.modif$City[match(insp.select$site.address, city.modif$Var1)]

insp.select<- insp.select %>% relocate(city3, .after = site.address)

### combiner les deux séries de noms de city

insp.select$city.t <- is.na(insp.select$city3)

insp.select$city <- if_else(insp.select$city.t =="FALSE", insp.select$city3, insp.select$city2)

insp.select<- insp.select %>% relocate(city, .after = site.address)


## ---- label=inspclean8v, include=FALSE--------------------------------------------
### Corriger 

insp.select$city2 <- str_remove(insp.select$city, ".{2,}(?=, )") # permet de retirer ce qui se trouve devant la virgule

insp.select$city2 <- str_remove(insp.select$city2, ", ") # retire le motif


## ---- label=inspclean8x, include=FALSE--------------------------------------------
### nettoyer les variables

insp.select$city <- NULL
insp.select <- rename(insp.select, city = city2)

insp.select$city <- str_to_upper(insp.select$city) # tout mettre en majuscule

insp.select$city <- str_squish(insp.select$city)


## ---- label=inspclean8z, include=FALSE--------------------------------------------
insp.web$city1 <- str_extract(insp.web$site.address, "[:graph:][:upper:][:graph:]+,") # Isole le motif

insp.web$city1 <- str_remove(insp.web$city1, "^[:graph:]") # retire le premier élément

insp.web$city1 <- str_remove(insp.web$city1, ",") # retire la virgule


## ---- label=inspclean8b2, include=FALSE-------------------------------------------
insp.web$city2 <- str_extract(insp.web$site.address, "[:graph:][:upper:].+,") # Isole le motif

insp.web$city2 <- str_remove(insp.web$city2, "^[:graph:]") # retire le premier élément

insp.web$city2 <- str_remove(insp.web$city2, ",") # retire la virgule


## ---- label=inspclean8d2, include=FALSE-------------------------------------------
insp.web$city <- if_else(!is.na(insp.web$city1), insp.web$city1, insp.web$city2)

city.web <- as.data.frame(table(insp.web$city))

### Validation 

city.web$dm <- str_detect(city.web$Var1, "[:upper:][:upper:]") # détecter double majuscule

city.web$city1 <- if_else(city.web$dm == TRUE, str_remove(city.web$Var1, "^[:upper:]"), paste(city.web$Var1)) # retrait de la première majuscule lorsque le mot commence par deux majuscules

#### retirer les cas où il y des chiffres précédés de texte

city.web$t2 <- str_count(city.web$city1, ".+[:digit:]") 

table(city.web$t2)

city.web$city1 <- str_remove(city.web$city1, ".+[:digit:]")

#### majuscule espace majuscule

city.web$t2 <- str_count(city.web$city1, "[:upper:][:space:][:upper:]") # cas présence mais parfois vrai. à corriger avec if_else

#### majuscule point majuscule

city.web$t2 <- str_count(city.web$city1, "[:upper:][:punct:][:upper:]") # Correction avec if_else

####punct

city.web$t2 <- str_count(city.web$city1, "[:punct:]") # cas réglés

####digits

city.web$t2 <- str_count(city.web$city1, "[:digit:]") # cas réglès

### retrait de la première majuscule lorsque le mot commence par deux majuscules

city.web$city3 <- if_else(city.web$dm == TRUE, str_remove(city.web$Var1, "^[:upper:]"), paste(city.web$Var1)) 


### correction particulière

city.web$city1 <- if_else(city.web$city1 == ") Naval Air Station North IslandSan Diego", "San Diego",
                  if_else(city.web$city1=="th AveMiami Gardens", "Miami Gardens", 
                  if_else(city.web$city1== "th Ave.Pompano Beach", "Pompano Beach",
                  if_else(city.web$city1 == "Coopers Creek BridgeBig Chimney", "Big Chimney",
                  if_else(city.web$city1 == "St. Elias National Park And Preserve Kennicott MineCopper Center", "Copper Center",
                  if_else(city.web$city1 == "Pac Mfg. Inc.Menomonee Falls,", "Menomonee Falls",
                  if_else(city.web$city1 == "N Attleboro", "Attleboro",
                  if_else(city.web$city1 == "S Rule", "Rule",
                  if_else(city.web$city1 == "Shaw A F B", "Shaw AFB",
                  if_else(city.web$city1 == "E.Dalton", "Dalton",
                  if_else(city.web$city1 == "E.East Canton", "East Canton",
                          paste(city.web$city1))))))))))))


### appliquer les corrections au jeu de base

insp.web$city3 <- city.web$city1[match(insp.web$city, city.web$Var1)]

### retirer les variables non requises 

insp.web$t1 <- NULL
insp.web$city1 <- NULL
insp.web$city <- NULL
insp.web$city2 <- NULL
insp.web$t2 <- NULL
insp.web$idno <- NULL

### renommer

insp.web <- rename(insp.web, city = city3)



## ---- label=inspclean6a, include=FALSE--------------------------------------------
# select : 123484
# web : 5154

# Nettoyage pour combiner avec insp.select


## retirer les variables non nécessaire

insp.web$Freq <- NULL
insp.web$url <- NULL
insp.web$date <- NULL
insp.web$date2 <- NULL
insp.web$timediff <- NULL
insp.web$time_error <- NULL

# corriger les formats des valeurs
 
## insp.type

### insp.select

insp.select$insp.type <- if_else(insp.select$insp.type == "Accident", "A",
                       if_else(insp.select$insp.type == "Complaint", "B",
                       if_else(insp.select$insp.type == "Referral", "C",
                       if_else(insp.select$insp.type == "Referral-Employer Reported", "C1",         
                       if_else(insp.select$insp.type == "Monitoring", "D",
                       if_else(insp.select$insp.type == "Variance", "E",                               
                       if_else(insp.select$insp.type == "Follow-Up", "F",
                       if_else(insp.select$insp.type == "Unprogrammed Related", "G",
                       if_else(insp.select$insp.type == "Program Planned", "H",
                       if_else(insp.select$insp.type == "Programmed Related", "I",
                       if_else(insp.select$insp.type == "Unprogrammed Other", "J",
                       if_else(insp.select$insp.type == "Programmed Other", "K", 
                       if_else(insp.select$insp.type == "Other--Other", "L", 
                       if_else(insp.select$insp.type == "Other--Data Initiative Non-Responder", "L1",
                       if_else(insp.select$insp.type == "Other--ATARs", "L2",                                
                       if_else(insp.select$insp.type == "Fatality/Catastrophe", "M",
                       "!!!"))))))))))))))))



## ---- label=inspclean6c, include=FALSE--------------------------------------------
### insp.web

insp.web$insp.type <-  if_else(insp.web$insp.type == "Accident", "A",
                       if_else(insp.web$insp.type == "Complaint", "B",
                       if_else(insp.web$insp.type == "Referral", "C",
                       if_else(insp.web$insp.type == "Monitoring", "D",                       
                       if_else(insp.web$insp.type == "FollowUp", "F", 
                       if_else(insp.web$insp.type == "Unprog Rel", "G",
                       if_else(insp.web$insp.type == "Planned", "H",
                       if_else(insp.web$insp.type == "Prog Related", "I",                               
                       if_else(insp.web$insp.type == "Unprog Other", "J",
                       if_else(insp.web$insp.type == "Prog Other", "K",
                       if_else(insp.web$insp.type == "Other", "L",       
                       if_else(insp.web$insp.type == "Fat/Cat", "M",                                 
                       if_else(insp.web$insp.type == "No Insp/Other", "X",
                       "!!!")))))))))))))



## ---- label=inspclean6e, include=FALSE--------------------------------------------
## insp.scope

### insp.select


insp.select$insp.scope <- if_else(insp.select$insp.scope == "Comprehensive", "A",
                       if_else(insp.select$insp.scope == "Partial", "B",
                       if_else(insp.select$insp.scope == "Records Only", "C",
                       if_else(insp.select$insp.scope == "No Inspection", "D",
                                       "!!!"))))



## ---- label=inspclean6g, include=FALSE--------------------------------------------
### insp.web

insp.web$insp.scope <- if_else(insp.web$insp.scope == "Complete", "A",
                       if_else(insp.web$insp.scope == "Partial", "B",
                       if_else(insp.web$insp.scope == "Records", "C",
                       if_else(insp.web$insp.scope == "No Insp/Denied Entry", "D",
                       if_else(insp.web$insp.scope == "No Insp/Other", "D",
                       if_else(insp.web$insp.scope == "No Insp/Process Inactive", "D",
                       if_else(insp.web$insp.scope == "No Insp/Out of Business", "D",
                       "!!!")))))))



## ---- label=inspclean6i, include=FALSE--------------------------------------------
## Union

### insp.select est sous la forme de Y ou N

### inps.web

insp.web$union <- if_else(insp.web$union == "Union Status: NonUnion", "N",
                  if_else(insp.web$union == "Union Status: Union", "Y",
                  "X"))



## ---- label=inspclean6k, include=FALSE--------------------------------------------
# Retirer les variables qui ne sont plus utile

insp.select$t1 <- NULL
insp.select$t2 <- NULL
insp.select$city.t <- NULL
insp.select$city1 <- NULL
insp.select$city3 <- NULL
insp.select$mailing.address <- NULL

remove(city)
remove(city.modif)
remove(city2)



## ---- label=inspclean12a, include=FALSE-------------------------------------------
# select : 123484
# web : 5154

# conserver uniquement les enregistrements uniques d'insp.select

insp.select$d <- duplicated(insp.select$insp) # marquer l'ensemble des valeurs en double sauf la première occurrence (contrairement à duplicated2()).


## ---- label=inspclean12c, include=FALSE-------------------------------------------
insp.unique <- filter(insp.select, d == FALSE)


# S'assurer qu'il n'y a pas de doublon entre le deux jeux insp

insp.web$web <- is.element(insp.web$insp, insp.unique$insp)


## ---- label=inspclean12e, include=FALSE-------------------------------------------
## retirer les doublons de insp.web car insp.unique est plus complet

insp.web <- filter(insp.web, web == FALSE)


# retirer les variables inutiles

insp.unique$d <- NULL
insp.web$web <-  NULL


# Fusion

insp.complet <- rbind(insp.unique, insp.web)

# 32 792 (select sans doublon) + 4 105 (web) = 36 897 compi


## ---- label=n8, include=FALSE-----------------------------------------------------
remove(city.web)
remove(insp.select)
remove(insp.unique)
remove(insp.web)




## ---- label=fcheminsp3b, include=FALSE--------------------------------------------
# Fusion

oischem_complet <- merge(oischem, insp.complet, by = "insp", all.x = TRUE) # même nombre d'enregistrement qu'oischem (158 947)



## ---- label=fcheminsp3d, include=FALSE--------------------------------------------
## insp.type

oischem_complet$insp.type.x <- if_else(oischem_complet$insp.type.x == "Accident", "A",
                       if_else(oischem_complet$insp.type.x == "Complaint", "B",
                       if_else(oischem_complet$insp.type.x == "Referral", "C",
                       if_else(oischem_complet$insp.type.x == "Monitoring", "D",
                       if_else(oischem_complet$insp.type.x == "Follow-Up", "F",
                       if_else(oischem_complet$insp.type.x == "Unprogrammed Related", "G",
                       if_else(oischem_complet$insp.type.x == "Program Planned", "H",
                       if_else(oischem_complet$insp.type.x == "Programmed Related", "I",
                       if_else(oischem_complet$insp.type.x == "Unprogrammed Other", "J",
                       if_else(oischem_complet$insp.type.x == "Programmed Other", "K", 
                       if_else(oischem_complet$insp.type.x == "Other--Other", "L", 
                       if_else(oischem_complet$insp.type.x == "Fatality/Catastrophe", "M",
                       if_else(oischem_complet$insp.type.x == "Other--ATARs", "L2",                                
                       if_else(oischem_complet$insp.type.x == "Referral-Employer Reported", "C1",                               
                                                              "!!!"))))))))))))))



## ---- label=fcheminsp3f, include=FALSE--------------------------------------------
# Combiner une variable combinant les informations sur les données

oischem_complet$id.dfno <- paste(oischem_complet$id.dfno.x, oischem_complet$id.dfno.y, sep = ";")

## Éliminer les autres variables d'id 

oischem_complet$id.dfno.x <- NULL
oischem_complet$id.dfno.y <- NULL


## ---- label=fcheminsp3h, include=FALSE--------------------------------------------
oischem_complet$strategic.program.y <- NULL
oischem_complet$insp.type.y <- NULL
oischem_complet$site.naics.y <- NULL
oischem_complet$open.conf.date.y <- NULL
oischem_complet$rid.y <- NULL


## Renommer

oischem_complet <- oischem_complet %>% rename(rid = rid.x, open.conf.date = open.conf.date.x, site.naics = site.naics.x, insp.type = insp.type.x, strategic.program = strategic.program.x, iddf.chem = iddf.x, iddf.insp = iddf.y)




## ---- label=n9.a, include=FALSE---------------------------------------------------
remove(insp)

remove(oischem)



## ---- label=imisclean1a, include=FALSE--------------------------------------------
# nbr enregistrements imis 877 519

#  retrait des mesures dans imis qui ne sont pas area ou personnel

imis <- filter(imis, s.type == "A" | s.type == "P" ) # - 36 924 enregistrements (imis à ce point 840 595 enregistrements)

# unités

## uniformiser les unités

imis$units <- str_to_upper(imis$units)

units.imis <- as.data.frame(table(imis$units, useNA = "always")) # un enregistrement sans unité, mais pas traité comme NA

imis$units[imis$units == ""] <- NA

### 840 595

imis <- filter(imis, !is.na(units)) # retrait du NA

# les enregistrements sans substance


## ---- label=imisclean1c, include=FALSE--------------------------------------------
# Retirer les substances autres

imis$autre <- str_detect(imis$subst,"T110|2587|8110|8111|8120|8130|8280|8310|8320|8330|8350|8360|8390|8400|8430|8470|8650|8880|8891|8893|8895|8920|9591|9613|9614|9838|B418|C730|E100|E101|F006|G301|G302|I100|L130|L131|L294|M102|M103|M104|M110|M124|M125|M340|P100|P200|Q100|Q115|Q116|Q118|R100|R252|R274|R278|S102|S108|S325|S777|V219|WFBW|BWPB|I200|L295")

##  Présenter les enregistrements retirés

imis_subs <- filter(imis, autre == TRUE)

imis_subs <- as.data.frame(table(imis_subs$subst))

imis_subs <- rename(imis_subs, Substance = Var1)

imis_subs$label <- label.subs.usData$label[match(imis_subs$Substance, label.subs.usData$code)]

imis_subs <- imis_subs %>% relocate(label, .after = Substance)


## ---- label=imisclean1e, include=FALSE--------------------------------------------
# conserver seulement les agents chimiques d'OIS

imis <- filter(imis, autre == FALSE)

# 877519-36924-1-208322 = 632272





## ---- label=n10, include=FALSE----------------------------------------------------

imis$autre <-  NULL

remove(imis_subs)




## ---- label=oisimis4b-------------------------------------------------------------
oischem_complet$e.type <- if_else(oischem_complet$exposure.type == "Not Analyzed","A", 
                     if_else(oischem_complet$exposure.type  == "Ceiling","C", 
                     if_else(oischem_complet$exposure.type  == "Dose", "D", 
                     if_else(oischem_complet$exposure.type  == "non-detect", "F", 
                     if_else(oischem_complet$exposure.type  == "STEL", "L", 
                     if_else(oischem_complet$exposure.type  == "PEAK", "P", 
                     if_else(oischem_complet$exposure.type  == "Sound Level","S", 
                     if_else(oischem_complet$exposure.type  == "TWA","T",
                     if_else(oischem_complet$exposure.type  == "TWA-8","T", 
                     if_else(oischem_complet$exposure.type  == "Not valid", "V",  
                     if_else(oischem_complet$exposure.type  == "Action Level", "Z",           
                             "!!!")))))))))))


## ---- label=oisimis4d-------------------------------------------------------------
oischem_complet$exposure.type <- NULL

# 147637






## ---- label=oisimis7b, include=FALSE----------------------------------------------
## combler les 3 NA

oischem_complet$naics <- if_else(is.na(oischem_complet$site.naics), oischem_complet$primary.naics, oischem_complet$site.naics)

oischem_complet$primary.naics <- NULL


## ---- label=oisimis7d, include=FALSE----------------------------------------------
# retrait des NA

oischem_complet <- filter(oischem_complet, !is.na(site.naics))

# 147634




## ----label=oisimis8---------------------------------------------------------------


oischem_complet$s.type <- if_else(oischem_complet$sample.type == "Area", "A",
              if_else(oischem_complet$sample.type == "Personal", "P", "NA"))

oischem_complet$sample.type <- NULL


## ---- label=oisimis9a-------------------------------------------------------------
oischem_complet$units <- if_else(oischem_complet$exposure.units == "picocuries per liter", "C",
                    if_else(oischem_complet$exposure.units == "decibel", "B", 
                    if_else(oischem_complet$exposure.units == "milligrams per deciliter", "D", 
                    if_else(oischem_complet$exposure.units == "fibers", "F1", 
                    if_else(oischem_complet$exposure.units == "million particles per cubic foot", "G", 
                    if_else(oischem_complet$exposure.units == "milligrams per liter", "L", 
                    if_else(oischem_complet$exposure.units == "milligrams per cubic meter", "M", 
                    if_else(oischem_complet$exposure.units == "parts per million", "P", 
                    if_else(oischem_complet$exposure.units == "percent", "%", 
                    if_else(oischem_complet$exposure.units == "milligram", "Y", 
                    if_else(oischem_complet$exposure.units == "micrograms", "X", 
                    if_else(oischem_complet$exposure.units == "fibers per cubic centimeter", "F", 
                    if_else(oischem_complet$exposure.units == "micrograms per cubic meter", "X1",
                    if_else(oischem_complet$exposure.units == "microgram per liter", "X3",
                    "!!!"))))))))))))))






## ---- label=oisimis_subst1b, include=FALSE----------------------------------------
## Extraire le motif

oischem_complet$subst  <- str_extract(oischem_complet$substance, "^....-") 

oischem_complet$subst  <- str_remove_all(oischem_complet$subst, "-")


## ---- label=oisimis_subst1d, include=FALSE----------------------------------------
oischem_complet$subst2  <- oischem_complet$subst






## ---- label=oisimis_subst3a, include=FALSE----------------------------------------
imis$subst2 <- str_pad(imis$subst, 4, side = "left", pad = "0")





## ---- label=oisimis_combi.a, include=FALSE----------------------------------------
#OIS

## nettoyer substance pour enlever le code

oischem_complet$substance2  <- str_remove_all(oischem_complet$substance, "^....-") 


# ajouter le nom des substances dans IMIS

## faire correspondre

imis$substance2 <- label.subs.usData$label[match(imis$subst2, label.subs.usData$code)]














## ---- label=oisimis_prep.b, include=FALSE-----------------------------------------
oischem_complet$establishment <- str_to_upper(oischem_complet$estab.name) # Cette variable dans imis est 100 % en majuscule

oischem_complet$estab.name <- NULL



## ---- label=oisimis_prep.d, include=FALSE-----------------------------------------
## city

### transformer en majuscule. Création de city2 pour conserver les noms originaux avant les corrections

oischem_complet$city2 <- str_to_upper(oischem_complet$city)
imis$city2 <- str_to_upper(imis$city)

### correction

#### nom débutant par un espace

oischem_complet$city2 <- str_remove(oischem_complet$city2, "^[:space:]")
imis$city2<- str_remove(imis$city2, "^[:space:]")


# Éliminer les variables sans correspondance

## OIS

oischem_complet$estab.name.y <- NULL
oischem_complet$csho.id <- NULL
oischem_complet$additional.code <- NULL
oischem_complet$analyst.comments <- NULL
oischem_complet$business.address <- NULL
oischem_complet$emphasis.program <- NULL
oischem_complet$open.conf.date <- NULL
oischem_complet$primary.emphasis.program <- NULL
oischem_complet$sheet.status <- NULL
oischem_complet$sheet.type <- NULL
oischem_complet$site.address <- NULL
oischem_complet$site.naics <- NULL
oischem_complet$strategic.program <- NULL
oischem_complet$supv.id <- NULL
oischem_complet$updated.by <- NULL
oischem_complet$exposure.units <- NULL
oischem_complet$emp.cntrld <- NULL
oischem_complet$sampling.performed <- NULL
oischem_complet$reason.no.insp <- NULL
oischem_complet$insp.category <- NULL
oischem_complet$iddf.insp <- NULL
oischem_complet$iddf.chem <- NULL
oischem_complet$onsite <- NULL
oischem_complet$invest.no <- NULL
oischem_complet$t1 <- NULL

## IMIS

imis$form.type <- NULL
imis$hash <- NULL
imis$idno <- NULL
imis$year <- NULL
imis$iddf <- NULL
imis$anal.req <- NULL
imis$t.nb.subs <- NULL


# Créer les correspondances pour les variables à conserver

## Dans ois

oischem_complet$adv.notice <- NA
oischem_complet$sic <- NA
oischem_complet$nr.exposed <- NA
oischem_complet$adj.pel <- NA
oischem_complet$state <- NA

## Dans imis

imis$expo.duration.units <- NA
imis$exposure.duration <- NA
imis$exposure.record <- NA
imis$emp.cvrd <- NA
imis$substance <- NA
imis$ownership.type <- NA
imis$exposure.assessment <- NA
imis$exposure.record <- NA


# Renommer les variables similaires

oischem_complet <- oischem_complet %>% rename(activity.nr = insp, e.level = exposure.concentration, exps.freq = exposure.frequency, occ.code = occupation.title, pel = oel.value, report.id = rid, s.date = sampling.date, s.nbr = sample.sheet)





## ---- label=fusionOISIMIS.b, include=FALSE----------------------------------------
dfusa <- as.data.frame(rbind(imis, oischem_complet))





## ----label=fusionOISIMIS2.a-------------------------------------------------------
# Ajout d'un identifiant IMIS ou OIS

dfusa$t <- str_detect(dfusa$id.dfno, "ois")

dfusa$iddf <- ifelse(dfusa$t == TRUE, "OIS", "IMIS")










## ---- label=dfusaestablishment.b, include=FALSE-----------------------------------
dfusa$establishment <- str_squish(dfusa$establishment) # retire les espaces avant et après le texte et modifie les doubles espaces en une seule


## ---- label=dfusaestablishment.d, include=FALSE-----------------------------------
dfusa$establishment <- str_to_upper(dfusa$establishment)


## ---- label=dfusa_city.a----------------------------------------------------------
## correction

dfusa$city2 <- str_squish(dfusa$city2) # retire les espaces avant et après le texte et modifie les doubles espaces en une seule

### Convertir Saint en st (à permis d'ajouter 10 correspondances)

dfusa$city2 <- str_replace(dfusa$city2, "^SAINT ", "ST ")

### Mount vs Mt vs Mt.

dfusa$city2 <- str_replace(dfusa$city2, "^MT ", "MOUNT ")
dfusa$city2 <- str_replace(dfusa$city2, "^MT. ", "MOUNT ")


## ---- label=dfusa_city.c----------------------------------------------------------
# city, abréviation AFB et A F B est utilisé pour Air Force Base, parfois au long.

dfusa$city2 <- str_replace(dfusa$city2, "A F B", "AFB")

dfusa$city2 <- str_squish(dfusa$city2)









## ---- , label=dfusa_zip.a, include=FALSE------------------------------------------
dfusa$t <- str_length(dfusa$zip)

zipcor <- filter(dfusa, t < 5)

zipcor <- as.data.frame(table(zipcor$zip))

zipusa <- read_xls(data_other_path("zip_code_database.xls"))

zipcor$el <- is.element(zipcor$Var1, zipusa$zip)


## ---- , label=dfusa_zip.c, include=FALSE------------------------------------------
zippb <- filter(zipcor, el == FALSE) # isoler les codes problématiques

dfusa$zip3 <- str_pad(dfusa$zip, 5, side = "left", pad = "0")

dfusa$zip4 <-  is.element(dfusa$zip, zippb$Var1)

dfusa$zip2 <- if_else(dfusa$zip4 == TRUE, dfusa$zip, dfusa$zip3)

dfusa$zip3 <- NULL

dfusa$zip4 <- NULL



## ---------------------------------------------------------------------------------
remove(zipcor)
remove(zippb)
remove(zipusa)













## ---- label=dfusa_substance.b, include=FALSE--------------------------------------
# un peu d'uniformisation du texte

dfusa$substance2 <- str_to_upper(dfusa$substance2)

dfusa$substance2 <- str_squish(dfusa$substance2)


# correction d'écriture

## les noms des substances différent entre IMIS et OIS, voici les modifications apportées. Sauf autrement préciser, le nom avec la fréquence la plus importante a été favorisé

dfusa$substance2 <- str_replace(dfusa$substance2, "&", "AND")

dfusa$substance2 <- str_remove(dfusa$substance2, " .PEL.$")

dfusa$substance2 <- str_replace(dfusa$substance2, "DIETHYLENE GLYCOL MONOBUTYL ETHER .BUTYL CARBITOL.", "BUTYL CARBITOL")

dfusa$substance2 <- str_replace(dfusa$substance2, "CARBARYL .SEVIN.", "CARBARYL")

dfusa$substance2 <- str_replace(dfusa$substance2, "BUTYL CELLOSOLVE ACETATE$", "BUTYL CELLOSOLVE ACETATE 0473 TERT-BUTYL CHROMATE (AS CRO3), PRIOR TO 5/30/2006") # le deuxième nom donnait des informations qui me sablaient important de ne pas perdre.

dfusa$substance2 <- str_replace(dfusa$substance2, "CHROMIUM, METAL AND INSOLUBLE SALTS", "CHROMIUM")

dfusa$substance2 <- str_replace(dfusa$substance2, "HEXAVALENT CHROMIUM, TWA", "CHROMIUM (VI) - TWA")

dfusa$substance2 <- str_replace(dfusa$substance2, "AMMONIUM DICHROMATE$", "AMMONIUM DICHROMATE (IMIS), CHROMIC ACID AND CHROMATES (AS CRO3) (OIS)") # conserver les deux noms

dfusa$substance2 <- str_replace(dfusa$substance2, "CHROMIC ACID AND CHROMATES .AS CRO3.", "AMMONIUM DICHROMATE (IMIS), CHROMIC ACID AND CHROMATES (AS CRO3) (OIS)") # conserver les deux noms

dfusa$substance2 <- str_replace(dfusa$substance2, "HEXAVALENT CHROMIUM, AEROSPACE PAINT", "CHROMIUM (VI) - PAINTING (OIS SPECIFIED AEROSPACE PAINT)") # conserver les deux noms

dfusa$substance2 <- str_replace(dfusa$substance2, "CHROMIUM .VI. - PAINTING$", "CHROMIUM (VI) - PAINTING (OIS SPECIFIED AEROSPACE PAINT") # conserver les deux noms

dfusa$substance2 <- str_replace(dfusa$substance2, "BENZO .A. PYRENE$", "BENZO (ALPHA) PYRENE")

dfusa$substance2 <- str_replace(dfusa$substance2, "3.3..DICHLOROBENZIDINE", "3,3'-DICHLOROBENZIDINE AND ITS SALTS")

dfusa$substance2 <- str_replace(dfusa$substance2, "DIMETHYLANILINE .N.N.DIMETHYLANILINE.", "DIMETHYLANILINE")

dfusa$substance2 <- str_replace(dfusa$substance2, "FLUORIDE .AS F..AS DUST.", "FLUORIDE (AS F)")

dfusa$substance2 <- str_replace(dfusa$substance2, "HEPTANE .N-HEPTANE.", "HEPTANE")

dfusa$substance2 <- str_replace(dfusa$substance2, "DESMODUR N", "HEXAMETHYLENE DIISOCYANATE") # Fréquence similaire, conservation du nom au lieu de la marque

dfusa$substance2 <- str_replace(dfusa$substance2, "HEXANE .N-HEXANE.", "HEXANE")

dfusa$substance2 <- str_replace(dfusa$substance2, "HYDROGEN FLUORIDE .AS F.", "HYDROGEN FLUORIDE")

dfusa$substance2 <- str_replace(dfusa$substance2, "HYDROGEN PEROXIDE$", "HYDROGEN PEROXIDE (90%)")

dfusa$substance2 <- str_replace(dfusa$substance2, "MOLYDBENUM .AS MO., INSOLUBLE COMPOUNDS .TOTAL DUST.", "MOLYBDENUM (AS MO), INSOLUBLE COMPOUNDS (TOTAL DUST)") # orthographe

dfusa$substance2 <- str_replace(dfusa$substance2, "NICKEL SOLUBLE$", "NICKEL, SOLUBLE COMPOUNDS (AS NI)")

dfusa$substance2 <- str_replace(dfusa$substance2, "TETRACHLOROETHYLENE .PERCHLOROETHYLENE.", "PERCHLOROETHYLENE")

dfusa$substance2 <- str_replace(dfusa$substance2, "PETROLEUM DISTILLATES .NAPHTHA. .RUBBER SOLVENT.", "PETROLEUM DISTILLATES (NAPHTHA)")

dfusa$substance2 <- str_replace(dfusa$substance2, "N-PROPYL ALCOHOL", "PROPYL ALCOHOL")

dfusa$substance2 <- str_replace(dfusa$substance2, "SODIUM HYDROXIDE", "SODIUM AND COMPOUNDS")

dfusa$substance2 <- str_replace(dfusa$substance2, "BUTYLTIN TRICHLORIDE", "BUTYLTIN TRICHLORIDE (OIS TIN, ORGANIC COMPOUNDS (AS SN))") # combinaison des deux

dfusa$substance2 <- str_replace(dfusa$substance2, "TIN, ORGANIC COMPOUNDS .AS SN.", "BUTYLTIN TRICHLORIDE (OIS TIN, ORGANIC COMPOUNDS (AS SN))")  # combinaison des deux

dfusa$substance2 <- str_replace(dfusa$substance2, "TIN OXIDE .AS SN. .TOTAL DUST.", "TIN OXIDE (AS SN)")

dfusa$substance2 <- str_replace(dfusa$substance2, "TRIMETHYLBENZENE$", "TRIMETHYLBENZENE (MIXED ISOMERS)")

dfusa$substance2 <- str_replace(dfusa$substance2, "METHYLENE.BIS.4.CYCLOHEXYLISOCYANATE.$", "METHYLENE-BIS (4-CYCLOHEXYLISOCYANATE)") # différence espace

dfusa$substance2 <- str_replace(dfusa$substance2, "SILICA, CRYSTALLINE QUARTZ .RESPIRABLE FRACTION.", "SILICA, CRYSTALLINE QUARTZ (AS QUARTZ), RESPIRABLE DUST")

dfusa$substance2 <- str_replace(dfusa$substance2, "TALC .CONTAINING NO ASBESTOS.", "TALC (CONTAINING NO ASBESTOS), RESPIRABLE DUST")

dfusa$substance2 <- str_replace(dfusa$substance2, "COAL DUST .5. SI02. .RESPIRABLE FRACTION.", "COAL DUST (<5% SIO2, RESPIRABLE FRACTION)") # un zéro à la place du o

dfusa$substance2 <- str_replace(dfusa$substance2, "CHROMIUM .III. COMPOUNDS .AS CR.", "CHROMIUM III COMPOUNDS (AS CR)")

dfusa$substance2 <- str_replace(dfusa$substance2, "N.METHYL.2.PYRROLIDINONE", "1-METHYL-2-PYRROLIDINONE")

dfusa$substance2 <- str_replace(dfusa$substance2, "PAPI$", "POLYMERIC MDI (PAPI)")

dfusa$substance2 <- str_replace(dfusa$substance2, "1.METHOXY.2.PROPYL ACETATE", "PROPYLENE GLYCOL MONOMETHYL ETHER ACETATE")

dfusa$substance2 <- str_replace(dfusa$substance2, "2.METHYLBUTANE .ISOPENTANE.", "2-METHYLBUTANE")

dfusa$substance2 <- str_replace(dfusa$substance2, "CHLOROBENZOTRIFLUORIDE.4..", "1-CHLORO-4-TRIFLUOROMETHYLBENZENE")

dfusa$substance2 <- str_replace(dfusa$substance2, "SILICA .QUARTZ, NON-RESPIRABLE.", "SILICA (QUARTZ, TOTAL)")






## ---- label=dfusa_exps.freq.a, include=FALSE--------------------------------------
dfusa$exps.freq <- str_squish(dfusa$exps.freq)

dfusa$exps.freq <- str_to_upper(dfusa$exps.freq)










## ---- label=dfusa_units.b, include=FALSE------------------------------------------
dfusa$units.label <- if_else(dfusa$units ==  "C", "picocuries per liter",
                    if_else(dfusa$units == "B", "decibel",  
                    if_else(dfusa$units == "D", "milligrams per deciliter", 
                    if_else(dfusa$units == "F", "fibers per cubic centimeter",  
                    if_else(dfusa$units == "G", "million particles per cubic foot",  
                    if_else(dfusa$units == "L", "milligrams per liter",  
                    if_else(dfusa$units == "M", "milligrams per cubic meter",  
                    if_else(dfusa$units == "P", "parts per million",  
                    if_else(dfusa$units == "%", "percent",  
                    if_else(dfusa$units == "Y", "milligram",  
                    if_else(dfusa$units == "X", "micrograms",  
                    if_else(dfusa$units == "F1", "Fibers",  
                    if_else(dfusa$units == "X1", "micrograms per cubic meter", 
                    if_else(dfusa$units == "X3", "microgram per liter", 
                    if_else(dfusa$units == "A", "picocuries/l (radon) ?",
                    if_else(dfusa$units == "R", "micrograms",
                    if_else(dfusa$units == "S", "micrograms",
                    if_else(dfusa$units == "T", "micrograms",
                    if_else(dfusa$units == "U", "micrograms",
                    if_else(dfusa$units == "W", "micrograms",
                    "blank observations"))))))))))))))))))))

dfusa$t <- dfusa$units.label == "blank observations" # il s'agit bien du case vide dans imis et elle ne sort pas comme NA

dfusa <- filter(dfusa, t!= TRUE)














## ---- label=dfusa_adjpel.b, include=FALSE-----------------------------------------
dfusa$adj.pel <- NULL



## ---- label=dfusa_jobtitle.a, include=FALSE---------------------------------------
dfusa$job.title <- str_squish(dfusa$job.title) # retire les espaces avant et après le texte et modifie les doubles espaces en une seule

dfusa$job.title <- str_to_upper(dfusa$job.title)


















## ---- label=dfusa_etype.b,include=FALSE-------------------------------------------
dfusa$e.type <- if_else(dfusa$e.type== "A", "A",
                if_else(dfusa$e.type == "C", "C",
                if_else(dfusa$e.type == "D", "D", 
                if_else(dfusa$e.type == "F", "F", 
                if_else(dfusa$e.type == "L", "L",  
                if_else(dfusa$e.type == "P", "P",  
                if_else(dfusa$e.type == "S", "S", 
                if_else(dfusa$e.type == "T", "T",
                if_else(dfusa$e.type == "V", "V",  
                if_else(dfusa$e.type == "Z", "Z",            
                             "xxx"))))))))))

dfusa$e.type[dfusa$e.type == "xxx"] <- NA # imis avait des cases vides, mais non NA. Une valeur NA a été forcé






## ---------------------------------------------------------------------------------
dfusa$t <- is.na(dfusa$e.type)


## ---------------------------------------------------------------------------------
dfusa <- filter(dfusa, t == FALSE)
# 779896












## ---- label=dfusa_stype.b, include=FALSE------------------------------------------
dfusa$t <- is.na(dfusa$s.type)

dfusa <- filter(dfusa, t == FALSE)

# 779896 - 628 = 779268






## ---------------------------------------------------------------------------------
# Éliminer les e.type V et A

dfusa$t <- str_detect(dfusa$e.type, "V|A")


## ---------------------------------------------------------------------------------
dfusa <- dfusa[dfusa$t == FALSE, ]

#774197-5071 = 774197





## ---------------------------------------------------------------------------------
# Créer la variable e.type.ois

## copier les valeurs de e.type

dfusa$e.type.ois <- dfusa$e.type 

## mettre les valeurs en provenance d'IMIS à NA 

dfusa$e.type.ois[dfusa$iddf == "IMIS"] <- NA


## ---------------------------------------------------------------------------------
dfusa$zero <- dfusa$e.level == 0



## ---------------------------------------------------------------------------------
# 774197

dfusa$e.type2 <- if_else(is.na(dfusa$e.level), dfusa$e.type,
                         if_else(dfusa$e.level == 0, "F", 
                          dfusa$e.type)) # doit passer par is.na avant, car sinon les e.level NA attribuent des NA aux e.type






## ---------------------------------------------------------------------------------
# Convertir les NA en zéro

dfusa$e.level2 <- if_else(is.na(dfusa$e.level), 0, dfusa$e.level)


## ---------------------------------------------------------------------------------
# Mettre la valeur F pour les valeurs de zéro

dfusa$e.type2 <- if_else(dfusa$e.level2 == 0, "F", dfusa$e.type)













## ---- include=FALSE---------------------------------------------------------------
# 774197
dfusa$t <- str_detect(dfusa$units, "T|Y|X|W|U")

dfusa$t2 <- dfusa$t == TRUE & dfusa$e.type2 != "F"


## ---- include=FALSE---------------------------------------------------------------
dfusa <- filter(dfusa, t2 == FALSE)

#774197-1805 =772392







## ---------------------------------------------------------------------------------
## 772392

dfusa$units2 <- dfusa$units

dfusa$units2[dfusa$e.type2 == "F"] <- NA



## ---- label=dfusa_unit_substa-----------------------------------------------------

# 772392

units.subst <- as.data.frame(table(dfusa$units2, dfusa$substance2))

units.subst <- filter(units.subst, Freq > 0)

units.subst <- units.subst %>% rename(code.units = Var1, substance2 = Var2)


units.subst$label.units <- if_else(units.subst$code.units ==  "C", "picocuries per liter",
                    if_else(units.subst$code.units == "B", "decibel",  
                    if_else(units.subst$code.units == "D", "milligrams per deciliter", 
                    if_else(units.subst$code.units == "F1", "fibers",  
                    if_else(units.subst$code.units == "G", "million particles per cubic foot",  
                    if_else(units.subst$code.units == "L", "milligrams per liter",  
                    if_else(units.subst$code.units == "M", "milligrams per cubic meter",  
                    if_else(units.subst$code.units == "P", "parts per million",  
                    if_else(units.subst$code.units == "%", "percent",  
                    if_else(units.subst$code.units == "Y", "milligram",  
                    if_else(units.subst$code.units == "X", "micrograms",  
                    if_else(units.subst$code.units == "F", "fibers per cubic centimeter",  
                    if_else(units.subst$code.units == "X1", "micrograms per cubic meter", 
                    if_else(units.subst$code.units == "X3", "microgram per liter", 
                    if_else(units.subst$code.units == "A", "picocuries/l (radon) ?",
                    if_else(units.subst$code.units == "R", "micrograms",
                    if_else(units.subst$code.units == "S", "micrograms",
                    if_else(units.subst$code.units == "T", "micrograms",
                    if_else(units.subst$code.units == "U", "micrograms",
                    if_else(units.subst$code.units == "W", "micrograms",
                    "blank observations"))))))))))))))))))))

units.subst <- units.subst %>% relocate(label.units, .after = code.units) 



write.xlsx(units.subst, file = data_tmp_path("dfusa_unitssubsts_pour_validation.xlsx"))


## ---- label=dfusa_unit_substb, include=FALSE--------------------------------------
# 772392

# combinaison à retirer

## ouvrir le df vérifieré

units.subst <- read.xlsx(data_other_path("dfusa_unitssubsts_verifie.xlsx"))

## création de la variable combinant units et substance2

dfusa$combi <- paste(dfusa$units, dfusa$substance2)

units.subst$combi <- paste(units.subst$code.units, units.subst$substance2)

## ajouter décision

dfusa$valid.unit.subst <- units.subst$decision[match(dfusa$combi, units.subst$combi)]






## ---------------------------------------------------------------------------------
dfusa$units.subst.na <- is.na(dfusa$valid.unit.subst)


## ---------------------------------------------------------------------------------
dfusa <- filter(dfusa, valid.unit.subst != "remove" | is.na(valid.unit.subst))

#772392-1058 = 771334




## ---- label=n22.b-----------------------------------------------------------------
remove(units.subst)


## ---- label=actionlevel.a, include=FALSE------------------------------------------
# 771334

# Identifier les mentions du e.type dans les noms des substances

## ACTION LEVEL Action Level

dfusa$al <- str_detect(dfusa$substance2, "ACTION LEVEL")





## ---------------------------------------------------------------------------------
# 771334 

dfusa$t.al <- str_detect(dfusa$e.type,  "Z|F|V|A")

dfusa$t.al2 <- dfusa$al == TRUE & dfusa$t.al == FALSE


## ---------------------------------------------------------------------------------
dfusa <- filter(dfusa, t.al2 == FALSE | is.na(dfusa$al))

#771334-2032-125 = 769302



## ---- label=twa.a, include=FALSE--------------------------------------------------
# 769302
## TWA

dfusa$twa <- str_detect(dfusa$substance2, "TWA")






## ---------------------------------------------------------------------------------
dfusa$twa2 <- str_detect(dfusa$e.type,  "F|V|T")

dfusa$twa3 <- dfusa$twa == TRUE & dfusa$twa2 == FALSE


## ---------------------------------------------------------------------------------
dfusa <- filter(dfusa, twa3 == FALSE | is.na(dfusa$twa))

# 769302-28 = 769274





## ---- label=n24.a-----------------------------------------------------------------
dfusa$twa <- NULL
dfusa$ceiling <- NULL
dfusa$al <-  NULL
dfusa$ceiling <- NULL









## ---------------------------------------------------------------------------------
dfusa$t <- str_detect(dfusa$e.type, "D|Z")

DZ <- filter(dfusa, t == TRUE)

dfusa <- filter(dfusa, t == FALSE)

# 769274-3461-18 = 765795



## ---------------------------------------------------------------------------------
# Créer une variable avec les informations communes entre IMIS et OIS, mais qui ne sont pas des champs de texte car les enregistrements pourraient être considéré différences à cause du différence de typographie.


dfusa$combi <- paste(dfusa$activity.nr, 
dfusa$report.id, 
dfusa$state.1, 
dfusa$insp.type, 
dfusa$insp.scope, 
dfusa$union, 
dfusa$adv.notice, 
dfusa$occ.code, 
dfusa$pel, 
dfusa$severity, 
dfusa$s.date, 
dfusa$e.type, 
dfusa$s.type, 
dfusa$exps.freq, 
dfusa$city2, 
dfusa$subst2, 
dfusa$zip2, 
dfusa$e.type2, 
dfusa$e.level2, 
dfusa$units2,
dfusa$naics)

# valider qu'il n'ait pas de doublon

dfusa$t <- duplicated2(dfusa$combi)


## ---------------------------------------------------------------------------------
# Pourquoi a-t-il des doublons

dfusa.doublon <- filter(dfusa, t == TRUE)



## ---------------------------------------------------------------------------------
# retrait des variables temporaires pour les analyses
dfusa$valid.unit.subst <- NULL
dfusa$combi <- NULL
dfusa$nac <- NULL
dfusa$t <- NULL
dfusa$twa3  <- NULL
dfusa$t.al  <- NULL
dfusa$zero   <- NULL
dfusa$twa2   <- NULL
dfusa$t.al2   <- NULL
dfusa$t2   <- NULL

# info codé dans une autre variable

dfusa$units.label  <- NULL 
dfusa$substance2 <- NULL

# variables avec une version plus récentes
dfusa$zip    <- NULL
dfusa$subst <- NULL
dfusa$substance <- NULL
dfusa$city <- NULL
dfusa$e.level  <- NULL
dfusa$units  <- NULL
dfusa$e.type <- NULL



# renommer les variables 

dfusa <- dfusa %>% rename( 
city = city2, 
subst = subst2, 
zip = zip2, 
e.type = e.type2, 
e.level = e.level2, 
units = units2, 
e.freq = exps.freq, 
e.duration = exposure.duration, 
e.duration.units = expo.duration.units, 
e.record = exposure.record
)


# ordonner les variables

dfusa <- dfusa[ ,c("activity.nr", 
"report.id", 
"establishment", 
"sic", 
"naics", 
"subst", 
"e.level", 
"units", 
"pel", 
"severity", 
"s.date", 
"s.type", 
"insp.type", 
"insp.scope", 
"e.type", 
"e.type.ois", 
"e.freq", 
"e.duration", 
"e.duration.units", 
"s.nbr",
"exposure.assessment", 
"e.record", 
"state.1", 
"city", 
"zip", 
"union", 
"adv.notice", 
"occ.code", 
"nr.exposed", 
"emp.cvrd", 
"job.title",
"state",
"ownership.type", 
"iddf", 
"id.dfno"
)]


## ---- label=sauvegarde_final------------------------------------------------------
# sauvegarde

# write.xlsx(dfusa, "./data-raw/USAdata_clean.xlsx")


saveRDS(dfusa, data_tmp_path("USIS_data.RDS"))


