## ----setup, include=FALSE---------------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)


## ---- label=infoR, warning=FALSE, message = FALSE---------------------------------

## Package

library(tidyverse)

library(questionr) # pour describe()

library(magrittr) # pour >%>

library(flextable) # pour les tableaux

library(knitr)

library(openxlsx) # ouvrir et sauvegarder en xlsx

library(lubridate) # manipuler les dates

library(readxl)

library(officer) # formatage flextable

## Flextable

set_flextable_defaults(
  text.align = 'center',
  decimal.mark = ",",
  big.mark = " ",
  digits = 1)


small_border = fp_border(color="gray", width = 1)
big_border = fp_border(color="black", width = 2)

## Information sur la session

knitr::opts_chunk$set(options("scipen"=100, "digits"=1, "big.mark"=" "))


xfun::session_info()

help(set_caption)




## ---- label=datachem, echo=TRUE---------------------------------------------------
oischem1011 <- openxlsx::read.xlsx("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/OIS FOIA 2021/raw_data/OSHAOIS sampling records.20210817102056/Sampling - fed and state - 2010-2011 - chem for R.xlsx")

oischem1014 <- openxlsx::read.xlsx("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/OIS FOIA 2021/raw_data/OSHAOIS sampling records.20210817102056/Sampling - fed and state - 2010-2014 - chem for R.xlsx")

oischem1213 <- openxlsx::read.xlsx("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/OIS FOIA 2021/raw_data/OSHAOIS sampling records.20210817102056/Sampling - fed and state - 2012-2013 - chem for R.xlsx")

oischem1415 <- openxlsx::read.xlsx("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/OIS FOIA 2021/raw_data/OSHAOIS sampling records.20210817102056/Sampling - fed and state - 2014-2015 - chem for R.xlsx")

oischem1617 <- openxlsx::read.xlsx("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/OIS FOIA 2021/raw_data/OSHAOIS sampling records.20210817102056/Sampling - fed and state - 2016-2017 - chem for R.xlsx")

oischem1819 <- openxlsx::read.xlsx("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/OIS FOIA 2021/raw_data/OSHAOIS sampling records.20210817102056/Sampling - fed and state - 2018-2019 - chem for R.xlsx")

oischem2021 <- openxlsx::read.xlsx("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/OIS FOIA 2021/raw_data/OSHAOIS sampling records.20210817102056/Sampling - fed and state - 2020-2021 - chem for R.xlsx")


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

insp1 <- read.xlsx("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/OIS FOIA 2021/raw_data/_OIS Fed and state SCAN Detail Y Redacted/2010-2011 OIS for R.xlsx")

insp2 <- read.xlsx("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/OIS FOIA 2021/raw_data/_OIS Fed and state SCAN Detail Y Redacted/2012-2013 OIS for R.xlsx")

insp3 <- read.xlsx("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/OIS FOIA 2021/raw_data/_OIS Fed and state SCAN Detail Y Redacted/2014-2015 OIS for R.xlsx")

insp4 <- read.xlsx("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/OIS FOIA 2021/raw_data/_OIS Fed and state SCAN Detail Y Redacted/2016-2017 OIS for R.xlsx")

insp5 <- read.xlsx("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/OIS FOIA 2021/raw_data/_OIS Fed and state SCAN Detail Y Redacted/2018-2019 OIS for R.xlsx")


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

imis <- readRDS("C:/Users/i_val/Dropbox/SHARE OSHA data/IMIS/RawDataMerging/data/IMIS.merged.aug2017.rds")


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

label.subs.usData <- readRDS("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/usa_data/label_substance_brute/subst_usData_brute.rds")



## ---- include=FALSE---------------------------------------------------------------
# Lors de la fusion d'oischem et avec les données d'inspection, il s'est avéré que tout les éléments d'inspection n'avait pas de correspondance malgré qu'un échantillonnage a été réalisé. S'agit-il de pertes du au nettoyage ?

insp.select$el <- is.element(insp.select$insp, oischem$insp)

table(insp.select$el) # FALSE 70594  TRUE 52890. Seulement 40 % de correspondance



## ---- label=chemclean1,  include=FALSE--------------------------------------------
# 228 684

# identifier les substances NA

oischem$subs.na <- is.na(oischem$substance)
table(oischem$subs.na ) # 16 075 TRUE

# Identifier les enregistrements autre 

oischem$autre <- str_detect(oischem$substance,"T110|2587|8110|8111|8120|8130|8280|8310|8320|8330|8350|8360|8390|8400|8430|8470|8650|8880|8891|8893|8895|8920|9591|9613|9614|9838|B418|C730|E100|E101|F006|G301|G302|I100|L130|L131|L294|M102|M103|M104|M110|M124|M125|M340|P100|P200|Q100|Q115|Q116|Q118|R100|R252|R274|R278|S102|S108|S325|S777|V219|WFBW|BWPB|I200|L295")

oischem_subs <- filter(oischem, autre == TRUE)

oischem_subs <- as.data.frame(table(oischem_subs$substance))

oischem_subs <- rename(oischem_subs, Substance = Var1)

## Nbr retiré

sum(oischem_subs$Freq) # 15 547

# conserver seulement les agents chimiques d'OIS

oischem <- filter(oischem, autre == FALSE)

oischem <- filter(oischem, subs.na == FALSE)
      
# 228 684 - 16 075 - 15 547 = 197 062



## ---- label=chemclean2------------------------------------------------------------

flextable(oischem_subs)%>%
  set_caption(caption = "Tableau 1 : Agents retirés d'OIS et leur fréquence dans les données brutes", autonum = )%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)




## ---- label=chemclean3, include=FALSE---------------------------------------------
# OIS = 197 062

describe(oischem$exposure.units)

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


unit.remove <- filter(oischem, unit.v == TRUE | is.na(unit.v))

unit.remove <- as.data.frame(table(unit.remove$exposure.units, useNA = "always"))

unit.remove <- rename(unit.remove, exposure.units = Var1)

sum(unit.remove$Freq) # 2330

# retirer les unités non désirées

oischem <- filter(oischem, unit.v == FALSE)

# 197 062 - 2 330 = 194 732


## ---- label=chemclean4------------------------------------------------------------
flextable(unit.remove)%>%
  theme_booktabs()%>%
  colformat_char(j = 1, na_str = "NA")%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)%>%
  set_caption(caption = "Tableau 2 : Unités retirées d'OIS et leur fréquence")



## ---- label=n3, include = FALSE---------------------------------------------------
oischem$subs.na <- NULL
oischem$autre <- NULL
oischem$unit.v <- NULL

remove(oischem_subs)
remove(unit.remove)



## ---- label=chemclean5, include=FALSE---------------------------------------------

# Création d'une variable composée du contenu de chaque variable d'origine de l'enregistrement 

oischem$combi <- paste(oischem$rid, oischem$insp,  oischem$estab.name,  oischem$open.conf.date,  oischem$site.naics,  oischem$csho.id,  oischem$supv.id,  oischem$insp.type,  oischem$sampling.date,  oischem$exposure.record,  oischem$sample.sheet,  oischem$sample.type,  oischem$sheet.type,  oischem$sheet.status,  oischem$substance,   oischem$exposure.type,   oischem$exposure.units,  oischem$oel.value,  oischem$severity,  oischem$job.title,  oischem$occupation.title,  oischem$exposure.duration,  oischem$expo.duration.units,  oischem$exposure.frequency,   oischem$strategic.program,  oischem$emphasis.program,  oischem$additional.code, oischem$analyst.comments, oischem$exposure.assessment, oischem$updated.by)

length(unique(oischem$combi)) / length(oischem$combi)*100



## ---- label=n4, include=FALSE-----------------------------------------------------
## distribution des doublons parmi les DF d'origine

unique_iddf <- as.data.frame(table(oischem$iddf, oischem$combi))

unique_iddf <- filter(unique_iddf, Freq > 0)

max(unique_iddf$Freq)

remove(unique_iddf)

# 194 732


## ---- label=chemclean6------------------------------------------------------------
# Identifier les enregistrements en double
# Créer une liste des éléments de la variable combi qui sont en double

double <- as.data.frame(table(oischem$combi))

double <- filter(double, Freq > 1)

#identifier les enregistrements en double

oischem$test2 <- oischem$combi %in% double$Var1 # Test si la valeur de combi se retrouve dans la liste des valeurs en doubles.

#d'où viennent les doublons

dfdouble <- filter(oischem, test2 == "TRUE")

dfdouble <- as.data.frame(table(dfdouble$iddf))

dfdouble <- dfdouble %>% rename (Fichier = Var1)


flextable(dfdouble)%>%
  set_caption(caption = "Tableau 3 : Fréquences des doublons selon le jeu d'origine")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)




## ---- label=chemclean, include=FALSE----------------------------------------------
oischem$t <- oischem$test2 == "FALSE" & oischem$iddf == "oischem1014"

table(oischem$t) # 94 184

sum(dfdouble$Freq) # 94 184


## ---- label=n5, include=FALSE-----------------------------------------------------

# oischem 194 732

oischem <- filter(oischem, iddf != "oischem1014")

remove(dfdouble)
remove(double)


oischem$test2 <- NULL
oischem$t <- NULL

# 194 732 - 47 092 = 147 640



## ---- label=inspclean1,  include=FALSE--------------------------------------------
# 123 484

# Présence de doublon dans le jeu inspection ?

insp$d <- paste(
insp$insp, 
insp$case.status, 
insp$rid, 
insp$estab.name, 
insp$business.address, 
insp$mailing.address, 
insp$site.address, 
insp$ownership.type, 
insp$primary.naics, 
insp$site.naics, 
insp$emp.in.estab, 
insp$emp.cvrd, 
insp$emp.cntrld, 
insp$entry.date, 
insp$open.conf.date, 
insp$closing.conf.1.date, 
insp$exit.date, 
insp$isa.event.date, 
insp$contest.date, 
insp$referred.to.dcat.date, 
insp$closed.date, 
insp$insp.scope, 
insp$insp.category, 
insp$insp.type, 
insp$reason.no.insp, 
insp$primary.emphasis.program, 
insp$emphasis.program, 
insp$strategic.program, 
insp$additional.code, 
insp$union, 
insp$sampling.performed, 
insp$svep, 
insp$denial.of.entry, 
insp$citn.item.no, 
insp$current.vio.type, 
insp$standard, 
insp$initial.penalty, 
insp$current.penalty, 
insp$issuance.date, 
insp$final.order.date, 
insp$citn.status, 
insp$vio.desc, 
insp$abatement.note, 
insp$abatement.date, 
insp$contest, 
insp$abatement.status, 
insp$abatement.due.date, 
insp$assessed.penalty, 
insp$assessed.other, 
insp$interest.and.fees, 
insp$assessed.total, 
insp$total.paid, 
insp$waived, 
insp$refund, 
insp$balance.due, 
insp$amount.referred.to.dcat, 
insp$preparation, 
insp$travel, 
insp$onsite, 
insp$denial.warrant, 
insp$informal.conference, 
insp$settlement.agreement, 
insp$report.preparation, 
insp$abate, 
insp$litigate, 
insp$other.conference, 
insp$total.hours, 
insp$invest.rid, 
insp$invest.no, 
insp$upa.no, 
insp$invest.event.date, 
insp$invest.event.time, 
insp$construction.related)

length(unique(insp$d)) / length(insp$d)*100 # le nombre de valeur unique équivaut au nombre d'enregistrement.


# Présence de doublon dans le jeu réduit

insp.select$d <- paste(insp.select$insp, 
insp.select$rid, 
insp.select$open.conf.date, 
insp.select$estab.name, 
insp.select$mailing.address, 
insp.select$site.address, 
insp.select$ownership.type, 
insp.select$primary.naics, 
insp.select$site.naics, 
insp.select$nr.in.estab, 
insp.select$insp.scope, 
insp.select$insp.category, 
insp.select$insp.type, 
insp.select$union, 
insp.select$strategic.program, 
insp.select$additional.code, 
insp.select$emphasis.program)


length(unique(insp.select$d)) / length(insp.select$d)*100

## Le jeu réduit compte seule 27 % de valeurs uniques. Est-ce que cette différence pourrait entraîner une mauvaise association avec oischem

# Voyons quels sont les variables qui en leur absence entraîne la création de doublon

insp$d2 <- paste(insp.select$insp, 
insp$rid, 
insp$open.conf.date, 
insp$estab.name, 
insp$mailing.address, 
insp$site.address, 
insp$ownership.type, 
insp$primary.naics, 
insp$site.naics, 
insp$nr.in.estab, 
insp$insp.scope, 
insp$insp.category, 
insp$insp.type, 
insp$union, 
insp$strategic.program, 
insp$additional.code, 
insp$emphasis.program)

## recherche d'un insp$d2 avec une fréquence élevée

d_insp <- as.data.frame(table(insp$d2)) # les fréquences font de 1 à 94

### isolons les deux éléments avec les plus grandes fréquences  

t <- d_insp[11227, 1] # id l'un des éléments
insp$d3 <- insp$d2 == t # tester les valeurs de d2 qui corresponds à l'élément identifié 
d_ex <- filter(insp, d3 == TRUE) # isoler les valeurs vrais

t2 <- d_insp[6785, 1]
insp$d4 <- insp$d2 == t2
d_ex2 <- filter(insp, d4 == TRUE)

### Nombre de valeurs uniques par variables

doubon.exp <- c(length(unique(d_ex$insp)), 
length(unique(d_ex$case.status)), 
length(unique(d_ex$rid)), 
length(unique(d_ex$estab.name)), 
length(unique(d_ex$business.address)), 
length(unique(d_ex$mailing.address)), 
length(unique(d_ex$site.address)), 
length(unique(d_ex$ownership.type)), 
length(unique(d_ex$primary.naics)), 
length(unique(d_ex$site.naics)), 
length(unique(d_ex$emp.in.estab)), 
length(unique(d_ex$emp.cvrd)), 
length(unique(d_ex$emp.cntrld)), 
length(unique(d_ex$entry.date)), 
length(unique(d_ex$open.conf.date)), 
length(unique(d_ex$closing.conf.1.date)), 
length(unique(d_ex$exit.date)), 
length(unique(d_ex$isa.event.date)), 
length(unique(d_ex$contest.date)), 
length(unique(d_ex$referred.to.dcat.date)), 
length(unique(d_ex$closed.date)), 
length(unique(d_ex$insp.scope)), 
length(unique(d_ex$insp.category)), 
length(unique(d_ex$insp.type)), 
length(unique(d_ex$reason.no.insp)), 
length(unique(d_ex$primary.emphasis.program)), 
length(unique(d_ex$emphasis.program)), 
length(unique(d_ex$strategic.program)), 
length(unique(d_ex$additional.code)), 
length(unique(d_ex$union)), 
length(unique(d_ex$sampling.performed)), 
length(unique(d_ex$svep)), 
length(unique(d_ex$denial.of.entry)), 
length(unique(d_ex$citn.item.no)), 
length(unique(d_ex$current.vio.type)), 
length(unique(d_ex$standard)), 
length(unique(d_ex$initial.penalty)), 
length(unique(d_ex$current.penalty)), 
length(unique(d_ex$issuance.date)), 
length(unique(d_ex$final.order.date)), 
length(unique(d_ex$citn.status)), 
length(unique(d_ex$vio.desc)), 
length(unique(d_ex$abatement.note)), 
length(unique(d_ex$abatement.date)), 
length(unique(d_ex$contest)), 
length(unique(d_ex$abatement.status)), 
length(unique(d_ex$abatement.due.date)), 
length(unique(d_ex$assessed.penalty)), 
length(unique(d_ex$assessed.other)), 
length(unique(d_ex$interest.and.fees)), 
length(unique(d_ex$assessed.total)), 
length(unique(d_ex$total.paid)), 
length(unique(d_ex$waived)), 
length(unique(d_ex$refund)), 
length(unique(d_ex$balance.due)), 
length(unique(d_ex$amount.referred.to.dcat)), 
length(unique(d_ex$preparation)), 
length(unique(d_ex$travel)), 
length(unique(d_ex$onsite)), 
length(unique(d_ex$denial.warrant)), 
length(unique(d_ex$informal.conference)), 
length(unique(d_ex$settlement.agreement)), 
length(unique(d_ex$report.preparation)), 
length(unique(d_ex$abate)), 
length(unique(d_ex$litigate)), 
length(unique(d_ex$other.conference)), 
length(unique(d_ex$total.hours)), 
length(unique(d_ex$invest.rid)), 
length(unique(d_ex$invest.no)), 
length(unique(d_ex$upa.no)), 
length(unique(d_ex$invest.event.date)), 
length(unique(d_ex$invest.event.time)), 
length(unique(d_ex$construction.related)) 
)

doubon.exp2 <- c(length(unique(d_ex2$insp)), 
length(unique(d_ex2$case.status)), 
length(unique(d_ex2$rid)), 
length(unique(d_ex2$estab.name)), 
length(unique(d_ex2$business.address)), 
length(unique(d_ex2$mailing.address)), 
length(unique(d_ex2$site.address)), 
length(unique(d_ex2$ownership.type)), 
length(unique(d_ex2$primary.naics)), 
length(unique(d_ex2$site.naics)), 
length(unique(d_ex2$emp.in.estab)), 
length(unique(d_ex2$emp.cvrd)), 
length(unique(d_ex2$emp.cntrld)), 
length(unique(d_ex2$entry.date)), 
length(unique(d_ex2$open.conf.date)), 
length(unique(d_ex2$closing.conf.1.date)), 
length(unique(d_ex2$exit.date)), 
length(unique(d_ex2$isa.event.date)), 
length(unique(d_ex2$contest.date)), 
length(unique(d_ex2$referred.to.dcat.date)), 
length(unique(d_ex2$closed.date)), 
length(unique(d_ex2$insp.scope)), 
length(unique(d_ex2$insp.category)), 
length(unique(d_ex2$insp.type)), 
length(unique(d_ex2$reason.no.insp)), 
length(unique(d_ex2$primary.emphasis.program)), 
length(unique(d_ex2$emphasis.program)), 
length(unique(d_ex2$strategic.program)), 
length(unique(d_ex2$additional.code)), 
length(unique(d_ex2$union)), 
length(unique(d_ex2$sampling.performed)), 
length(unique(d_ex2$svep)), 
length(unique(d_ex2$denial.of.entry)), 
length(unique(d_ex2$citn.item.no)), 
length(unique(d_ex2$current.vio.type)), 
length(unique(d_ex2$standard)), 
length(unique(d_ex2$initial.penalty)), 
length(unique(d_ex2$current.penalty)), 
length(unique(d_ex2$issuance.date)), 
length(unique(d_ex2$final.order.date)), 
length(unique(d_ex2$citn.status)), 
length(unique(d_ex2$vio.desc)), 
length(unique(d_ex2$abatement.note)), 
length(unique(d_ex2$abatement.date)), 
length(unique(d_ex2$contest)), 
length(unique(d_ex2$abatement.status)), 
length(unique(d_ex2$abatement.due.date)), 
length(unique(d_ex2$assessed.penalty)), 
length(unique(d_ex2$assessed.other)), 
length(unique(d_ex2$interest.and.fees)), 
length(unique(d_ex2$assessed.total)), 
length(unique(d_ex2$total.paid)), 
length(unique(d_ex2$waived)), 
length(unique(d_ex2$refund)), 
length(unique(d_ex2$balance.due)), 
length(unique(d_ex2$amount.referred.to.dcat)), 
length(unique(d_ex2$preparation)), 
length(unique(d_ex2$travel)), 
length(unique(d_ex2$onsite)), 
length(unique(d_ex2$denial.warrant)), 
length(unique(d_ex2$informal.conference)), 
length(unique(d_ex2$settlement.agreement)), 
length(unique(d_ex2$report.preparation)), 
length(unique(d_ex2$abate)), 
length(unique(d_ex2$litigate)), 
length(unique(d_ex2$other.conference)), 
length(unique(d_ex2$total.hours)), 
length(unique(d_ex2$invest.rid)), 
length(unique(d_ex2$invest.no)), 
length(unique(d_ex2$upa.no)), 
length(unique(d_ex2$invest.event.date)), 
length(unique(d_ex2$invest.event.time)), 
length(unique(d_ex2$construction.related)) 
)


variables <- c("insp", 
"case.status", 
"rid", 
"estab.name", 
"business.address", 
"mailing.address", 
"site.address", 
"ownership.type", 
"primary.naics", 
"site.naics", 
"emp.in.estab", 
"emp.cvrd", 
"emp.cntrld", 
"entry.date", 
"open.conf.date", 
"closing.conf.1.date", 
"exit.date", 
"isa.event.date", 
"contest.date", 
"referred.to.dcat.date", 
"closed.date", 
"insp.scope", 
"insp.category", 
"insp.type", 
"reason.no.insp", 
"primary.emphasis.program", 
"emphasis.program", 
"strategic.program", 
"additional.code", 
"union", 
"sampling.performed", 
"svep", 
"denial.of.entry", 
"citn.item.no", 
"current.vio.type", 
"standard", 
"initial.penalty", 
"current.penalty", 
"issuance.date", 
"final.order.date", 
"citn.status", 
"vio.desc", 
"abatement.note", 
"abatement.date", 
"contest", 
"abatement.status", 
"abatement.due.date", 
"assessed.penalty", 
"assessed.other", 
"interest.and.fees", 
"assessed.total", 
"total.paid", 
"waived", 
"refund", 
"balance.due", 
"amount.referred.to.dcat", 
"preparation", 
"travel", 
"onsite", 
"denial.warrant", 
"informal.conference", 
"settlement.agreement", 
"report.preparation", 
"abate", 
"litigate", 
"other.conference", 
"total.hours", 
"invest.rid", 
"invest.no", 
"upa.no", 
"invest.event.date", 
"invest.event.time", 
"construction.related"
)

source_d <- as.data.frame(cbind(variables, doubon.exp, doubon.exp2))

source_d <- source_d %>% rename(Exemple.1 = doubon.exp, Exemple.2 = doubon.exp2)


flextable(source_d)%>%
  set_caption(caption = "Nombre de valeur unique par variables pour deux exemples de variable combi avec doublon")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)



## ---- label=inspclean3, include=FALSE---------------------------------------------
remove(d_ex)
remove(d_ex2)
remove(d_insp)
remove(source_d)
remove(doubon.exp)
remove(doubon.exp2)
remove(t)
remove(t2)
remove(variables)

insp$d2 <- NULL
insp.select$d <- NULL
insp$d <- NULL



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

insp.web <- read_excel("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/OIS FOIA 2021/raw_data/Collecte_data_web_JFS/oischem_nodetail_JFS.xlsx")

## ajouter les variables d'identification

insp.web$iddf <- "insp.recup.web" # id source

insp.web$idno <- as.integer(rownames(insp.web)) #  no ligne

insp.web$id.dfno <-paste(insp.web$iddf, insp.web$idno, sep="_") # combiner les identifiants

insp.web$idno <- NULL



## ---- include=FALSE---------------------------------------------------------------
# l'inspection 1417182 n'a pas la même date. Les trois enregistrements sont éliminés

oischem$t <- str_detect(oischem$insp, "1417182")

table(oischem$t)

oischem <- filter(oischem, t == FALSE)

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



## ---- label=inspclean8, include=FALSE---------------------------------------------

# State.1 

## insp.select

### 1er motif pour extraire l'état

insp.select$t1 <- str_count(insp.select$site.address, ",[:alpha:]{2},[:digit:]") # compte le nombre de fois où il y a le motif

table(insp.select$t1) # pas de double occurrence avec ce motif. N'est pas présent dans 138 cas. D'autres motifs ont été testé, mais aucun ne donnait résultats plus satisfaisant.

#### Extraire le 1er motif

insp.select$state.2  <- str_extract(insp.select$site.address, ",[:alpha:]{2},[:digit:]") 

insp.select$state.2  <- str_remove_all(insp.select$state.2, ",") 

insp.select$state.2  <- str_remove_all(insp.select$state.2, "[:digit:]")

describe(insp.select$state.2)

### Second motif (cas où l'état n'est pas suivi par le code postal)

insp.select$t1 <- str_count(insp.select$site.address, ",[:alpha:]{2},.UNITED") # compte le nombre de fois où il y a le motif

table(insp.select$t1) # pas de double occurrence avec ce motif. Motif présent dans 129 cas

#### extraire le motif

insp.select$state.3  <- str_extract(insp.select$site.address, ",[:alpha:]{2},.UNITED") 

insp.select$state.3  <- str_remove_all(insp.select$state.3, ",") 

insp.select$state.3  <- str_remove_all(insp.select$state.3, ".UNITED")

describe(insp.select$state.3)

### combiner résultat 1 et 2

insp.select$state.1 <- if_else(is.na(insp.select$state.2), insp.select$state.3, insp.select$state.2)

describe(insp.select$state.1)

### éliminer les résultats intermédiaires

insp.select$state.2 <- NULL

insp.select$state.3 <- NULL

### voir les résultats 

state <- as.data.frame(table(insp.select$state.1)) # inclus des territoires 

sum(is.na(insp.select$state.1))-sum(is.na(insp.select$site.address))  # 9 nouveaux NA. Après une vérification visuelle,  les 9 résultats NA n'ont pas vraiment d'adresse. Nous pourrions utiliser le mailing adresse


## insp.web

insp.web$state.1 <- str_count(insp.web$site.address, ", [:upper:][:upper:]") # compte le motif

table(insp.web$state.1) # pas de doublon, motif non présent dans 2 cas. Pas moyen des récupérer 

insp.web$state.1 <- str_extract(insp.web$site.address, ", [:upper:][:upper:]") # Isole le motif

insp.web$state.1 <- str_remove(insp.web$state.1, ", ") # retire la virgule et l'espace

sum(is.na(insp.web$state.1))-sum(is.na(insp.web$site.address)) # 2 nouveaux NA


# Code postal

## insp.select 

insp.select$t1 <- str_count(insp.select$site.address, "[:digit:]{5} UNITED") # compte le nombre de fois où il y a cinq chiffre et UNITED

table(insp.select$t1) # pas de double occurrence avec ce motif. N'est pas présent dans 138 cas

insp.select$zip <- str_extract(insp.select$site.address,  "[:digit:]{5} UNITED") # conserve uniquement le code postal

insp.select$zip <- str_remove(insp.select$zip,  " UNITED") # retirer ce qui n'est pas le code postal

sum(is.na(insp.select$site.address))-sum(is.na(insp.select$zip)) # 138 nouveaux NA

### récupérer les zip manquants

zip <- filter(insp.select, is.na(zip)& !is.na(site.address))

zip <- as.data.frame(table(zip$site.address)) # il y a 93 valeurs uniques. Aucune ne contient zip code

### validation que zip à 5 digits

insp.select$validzip <- str_detect(insp.select$zip, "[:digit:]{5}")
table(insp.select$validzip ) # 100 % true

insp.select$validzip <- NULL


## inps.web

insp.web$t1 <- str_count(insp.web$site.address, "[:digit:]{5}$") # compte le nombre de fois où il y a cinq chiffre à la fin

table(insp.web$t1) # pas de double occurrence avec ce motif. N'est pas présent dans 34 cas. Une inspection visuelle a permis de constaté qu'ils ne sont pas ailleurs

insp.web$zip <- str_extract(insp.web$site.address,  "[:digit:]{5}$") # conserve uniquement le code postal

### récupérer les zip manquants

zip <- filter(insp.web, is.na(zip)& !is.na(site.address))

zip <- as.data.frame(table(zip$site.address)) # il y a 31 valeurs uniques. Aucune ne contient de zip code


sum(is.na(insp.web$site.address))-sum(is.na(insp.web$zip)) # 34 nouveaux NA



# Ville

## insp.select

### le nom de la ville se trouve devant l'état et à un nombre de caractère variable. 

insp.select$t1 <- str_count(insp.select$site.address, ".{20,}[:alpha:]{2},[:digit:]{5}") # compte le nombre de motif
table(insp.select$t1) # pas de double occurrence avec ce motif. N'est pas présent dans 445 cas

### isoler le nom de la ville 

insp.select$city <- str_extract(insp.select$site.address,".{20,}[:alpha:]{2},[:digit:]{5}")

insp.select<- insp.select %>% relocate(city, .after = site.address)

insp.select$city <- str_remove(insp.select$city, ",[:alpha:]{2},[:digit:]{5}") # retire l'état et le code postal

insp.select$city2 <- str_extract(insp.select$city, "(?<=, ).{2,}") # ?<= signifit précédé par  

insp.select$city2 <- str_remove(insp.select$city2, ".{2,}(?=,, )")

insp.select<- insp.select %>% relocate(city2, .after = site.address)

insp.select$city2  <- str_remove(insp.select$city2, ",, ")


sum(is.na(insp.select$city2))-sum(is.na(insp.select$site.address)) ## bilan création de 465 NA


### nouveau NA

city <- filter(insp.select, is.na(insp.select$city2))

### extraction avec un nouveau motif

city$city1 <- str_extract(city$site.address,",, .{20,}[:alpha:]{2},")

city2 <- as.data.frame(table(city$site.address))

# write.xlsx(city2, file = "C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/usa_data/data_intermediaire/city_ois.xlsx")

### Les noms de ville ont été isolé manuellement dans le fichier excel

city.modif<- openxlsx::read.xlsx("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/usa_data/data_intermediaire/city_ois_modif.xlsx")

### faire correspondre Site.Adress pour marquer le nom isoler manuellement

insp.select$city3 <- city.modif$City[match(insp.select$site.address, city.modif$Var1)]

insp.select<- insp.select %>% relocate(city3, .after = site.address)

### combiner les deux séries de noms de city

insp.select$city.t <- is.na(insp.select$city3)

insp.select$city <- if_else(insp.select$city.t =="FALSE", insp.select$city3, insp.select$city2)

insp.select<- insp.select %>% relocate(city, .after = site.address)

### bilan création de 76 NA

sum(is.na(insp.select$city))-sum(is.na(insp.select$site.address)) # nouveau NA 76

### valider qu'il ne reste plus de virgule ou de chiffre

insp.select$t1 <- str_detect(insp.select$city, ",|[:digit:]")

table(insp.select$t1)

### isoler les noms problématiques

city <- filter(insp.select, t1 == TRUE)

city2 <- as.data.frame(table(city$site.address, city$city))

city2 <- filter(city2, Freq != 0) # 203 cas

### Corriger 

insp.select$city2 <- str_remove(insp.select$city, ".{2,}(?=, )") # permet de retirer ce qui se trouve devant la virgule

insp.select$city2 <- str_remove(insp.select$city2, ", ") # retire le motif

### valider qu'il ne reste plus de chiffre ou de virgule

insp.select$t2 <- str_detect(insp.select$city2, "[:digit:]|,")

table(insp.select$t2) # aucune ville avec une virgule ou un chiffre

### nettoyer les variables

insp.select$city <- NULL
insp.select <- rename(insp.select, city = city2)

insp.select$city <- str_to_upper(insp.select$city) # tout mettre en majuscule

insp.select$city <- str_squish(insp.select$city)

### voir la liste des villes

city <- as.data.frame(table(insp.select$city))

### NA

sum(is.na(insp.select$city)) # 76


## insp.web

### Il ne semble pas avoir un motif uniforme. Le nom de la ville est collée sur le nom de la rue.

insp.web$t1 <- str_count(insp.web$site.address, "[:graph:][:upper:][:graph:]+,") # compte le motif

table(insp.web$t1) # pas de double occurrence avec ce motif. N'est pas présent dans 929 cas. 

insp.web$city1 <- str_extract(insp.web$site.address, "[:graph:][:upper:][:graph:]+,") # Isole le motif

insp.web$city1 <- str_remove(insp.web$city1, "^[:graph:]") # retire le premier élément

insp.web$city1 <- str_remove(insp.web$city1, ",") # retire la virgule

insp.web$t1 <- str_count(insp.web$site.address, "[:graph:][:upper:].+,") # compte le motif

table(insp.web$t1) # pas de double occurrence avec ce motif. N'est pas présent dans 10 cas. 

insp.web$city2 <- str_extract(insp.web$site.address, "[:graph:][:upper:].+,") # Isole le motif

insp.web$city2 <- str_remove(insp.web$city2, "^[:graph:]") # retire le premier élément

insp.web$city2 <- str_remove(insp.web$city2, ",") # retire la virgule

insp.web$t2 <- is.na(insp.web$city1)&is.na(insp.web$city2)

table(insp.web$t2) # 16 cas où un nom de ville n'a pas été détection et visuellement cela semble correcte.

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


### NA

sum(is.na(insp.web$city)) # 16



## ---- label=inspclean6, include=FALSE---------------------------------------------
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

#### validation
insp.select$t <- str_detect(insp.select$insp.type, "!!!")
table(insp.select$t) # aucun nouveau NA

insp.select$t <- NULL


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

#### validation
insp.web$t <- str_detect(insp.web$insp.type, "!!!")
table(insp.web$t) # aucun nouveau NA

insp.web$t <- NULL


## insp.scope

### insp.select


insp.select$insp.scope <- if_else(insp.select$insp.scope == "Comprehensive", "A",
                       if_else(insp.select$insp.scope == "Partial", "B",
                       if_else(insp.select$insp.scope == "Records Only", "C",
                       if_else(insp.select$insp.scope == "No Inspection", "D",
                                       "!!!"))))

#### validation
insp.select$t <- str_detect(insp.select$insp.scope, "!!!")
table(insp.select$t) # aucun nouveau NA

insp.select$t <- NULL


### insp.web

insp.web$insp.scope <- if_else(insp.web$insp.scope == "Complete", "A",
                       if_else(insp.web$insp.scope == "Partial", "B",
                       if_else(insp.web$insp.scope == "Records", "C",
                       if_else(insp.web$insp.scope == "No Insp/Denied Entry", "D",
                       if_else(insp.web$insp.scope == "No Insp/Other", "D",
                       if_else(insp.web$insp.scope == "No Insp/Process Inactive", "D",
                       if_else(insp.web$insp.scope == "No Insp/Out of Business", "D",
                       "!!!")))))))


#### validation
insp.web$t <- str_detect(insp.web$insp.type, "!!!")
table(insp.web$t) # aucun nouveau NA

insp.web$t <- NULL



## Union

### insp.select est sous la forme de Y ou N

### inps.web

insp.web$union <- if_else(insp.web$union == "Union Status: NonUnion", "N",
                  if_else(insp.web$union == "Union Status: Union", "Y",
                  "X"))

### validation

table(insp.web$union) # pas de x


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
remove(state)
remove(zip)



## ---- label=inspclean12, include=FALSE--------------------------------------------
# select : 123484
# web : 5154

# conserver uniquement les enregistrements uniques d'insp.select

insp.select$d <- duplicated(insp.select$insp) # marquer l'ensemble des valeurs en double sauf la première occurrence (contrairement à duplicated2()).

table(insp.select$d, useNA = "ifany")

insp.unique <- filter(insp.select, d == FALSE)


# S'assurer qu'il n'y a pas de doublon entre le deux jeux insp

insp.web$web <- is.element(insp.web$insp, insp.unique$insp)

table(insp.web$web) # il y a 49 enregistrements qui sont présent dans les deux banques. Pourquoi s'ont-il sortie comme manquant ?


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


## ---- label=fcheminsp3, include=FALSE---------------------------------------------

# Est-ce oischem = insp.complet ?

oischem$el <- is.element(oischem$insp, insp.complet$insp)

table(oischem$el)

insp.complet$el <- is.element(insp.complet$insp, oischem$insp)

table(insp.complet$el)

## Qu'est-ce qui se trouve dans insp.complet mais pas oischem

insp.no.oischem <- filter(insp.complet, el == FALSE)


table(insp.no.oischem$sampling.performed, useNA = "ifany") #

table(insp.no.oischem$insp.type) # rien qui ressort


### insp.category

table(insp.no.oischem$insp.category) # 90 % Health soit un peu plus que dans le jeu insp.complet

table(insp.complet$insp.category) # 80 % Health

### reason.no.insp

describe(insp.no.oischem$reason.no.insp) # 93,4 % NA

describe(insp.complet$reason.no.insp) # 90.1 % NA

### insp.scope

table(insp.no.oischem$insp.scope)

table(insp.complet$insp.scope) # rien qui ressort


### strategic.program

table(insp.no.oischem$strategic.program)

insp.no.oischem$noise <- str_detect(insp.no.oischem$strategic.program, "Noise|NOISE")

table(insp.no.oischem$noise) # seulement présent dans 2 495 enregistrements


insp.no.oischem$noise <- str_detect(insp.no.oischem$sampling.performed, "Noise|NOISE")

table(insp.no.oischem$noise) # seulement présent dans 2 495 enregistrements

  
# Retirons les variables inutiles 

## oischem

oischem$combi	<-	NULL

oischem$el	<-	NULL


## inps.complet

insp.complet$el	<-	NULL


# Fusion

oischem_complet <- merge(oischem, insp.complet, by = "insp", all.x = TRUE) # même nombre d'enregistrement qu'oischem (158 947)


# Validation des correspondances

## rid

oischem_complet$v1 <- oischem_complet$rid.x == oischem_complet$rid.y

table(oischem_complet$v1) # 100 % true 


## open.conf.date

oischem_complet$v2 <- oischem_complet$open.conf.date.x == oischem_complet$open.conf.date.y

table(oischem_complet$v2) # 100 % true 

## site.naics
oischem_complet$v3 <- oischem_complet$site.naics.x == oischem_complet$site.naics.y

table(oischem_complet$v3) # 100 % true 

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

table(oischem_complet$insp.type.x)


oischem_complet$v4 <- oischem_complet$insp.type.x == oischem_complet$insp.type.y

table(oischem_complet$v4) # faux dans 3 250 cas

### pourquoi pas de correspondances

v4 <- filter(oischem_complet, v4 == FALSE)

insptype_faux <- as.data.frame(table(v4$insp.type.x, v4$insp.type.y, useNA = "always"))

insptype_faux <- filter(insptype_faux, Freq > 0)


## strategic.program

oischem_complet$v5 <- oischem_complet$strategic.program.x == oischem_complet$strategic.program.y

table(oischem_complet$v5) # 100 % true 


# Combiner une variable combinant les informations sur les données

oischem_complet$id.dfno <- paste(oischem_complet$id.dfno.x, oischem_complet$id.dfno.y, sep = ";")

## Éliminer les autres variables d'id 

oischem_complet$id.dfno.x <- NULL
oischem_complet$id.dfno.y <- NULL


# Retirer les variables rendues inutiles

oischem_complet$v1 <- NULL
oischem_complet$v2 <- NULL
oischem_complet$v3 <- NULL
oischem_complet$v4 <- NULL
oischem_complet$v5 <- NULL


oischem_complet$strategic.program.y <- NULL
oischem_complet$insp.type.y <- NULL
oischem_complet$site.naics.y <- NULL
oischem_complet$open.conf.date.y <- NULL
oischem_complet$rid.y <- NULL


## Renommer

oischem_complet <- oischem_complet %>% rename(rid = rid.x, open.conf.date = open.conf.date.x, site.naics = site.naics.x, insp.type = insp.type.x, strategic.program = strategic.program.x, iddf.chem = iddf.x, iddf.insp = iddf.y)




## ---- label=n9, include=FALSE-----------------------------------------------------

remove(insp)

remove(oischem)

remove(insptype_faux)

remove(v4)

remove(insp.no.oischem)



## ---- label=imisclean1, include=FALSE---------------------------------------------
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

describe(imis$subst) # aucun NA. double validé avec un tableau

# Retirer les substances autres

imis$autre <- str_detect(imis$subst,"T110|2587|8110|8111|8120|8130|8280|8310|8320|8330|8350|8360|8390|8400|8430|8470|8650|8880|8891|8893|8895|8920|9591|9613|9614|9838|B418|C730|E100|E101|F006|G301|G302|I100|L130|L131|L294|M102|M103|M104|M110|M124|M125|M340|P100|P200|Q100|Q115|Q116|Q118|R100|R252|R274|R278|S102|S108|S325|S777|V219|WFBW|BWPB|I200|L295")

##  Présenter les enregistrements retirés

imis_subs <- filter(imis, autre == TRUE)

imis_subs <- as.data.frame(table(imis_subs$subst))

imis_subs <- rename(imis_subs, Substance = Var1)

imis_subs$label <- label.subs.usData$label[match(imis_subs$Substance, label.subs.usData$code)]

imis_subs <- imis_subs %>% relocate(label, .after = Substance)

## Nbr retiré

sum(imis_subs$Freq) #208 322

# conserver seulement les agents chimiques d'OIS

imis <- filter(imis, autre == FALSE)

# 877519-36924-1-208322 = 632272



## ---- label=imisclean1b-----------------------------------------------------------

flextable(imis_subs)%>%
  set_caption(caption = "Tableau 4 : Agents retirés d'IMIS et leur fréquence dans les données brutes")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)



## ---- label=n10, include=FALSE----------------------------------------------------

imis$autre <-  NULL

remove(imis_subs)



## ---- label=oisimis4--------------------------------------------------------------
# créer un tableau de comparaison

etype_ois <- as.data.frame(table(oischem_complet$exposure.type))
etype_ois <- etype_ois %>% rename(e.type_ois = Var1, Freq_ois = Freq)

etype_ois$etypeUSAdata <- if_else(etype_ois$e.type_ois == "Not Analyzed","A", 
                     if_else(etype_ois$e.type_ois  == "Ceiling","C", 
                     if_else(etype_ois$e.type_ois  == "Dose", "D", 
                     if_else(etype_ois$e.type_ois  == "non-detect", "F", 
                     if_else(etype_ois$e.type_ois  == "STEL", "L", 
                     if_else(etype_ois$e.type_ois  == "PEAK", "P", 
                     if_else(etype_ois$e.type_ois  == "Sound Level","S", 
                     if_else(etype_ois$e.type_ois  == "TWA","T",
                     if_else(etype_ois$e.type_ois  == "TWA-8","T", 
                     if_else(etype_ois$e.type_ois  == "Not valid", "V",  
                     if_else(etype_ois$e.type_ois  == "Action Level", "Z",           
                             "!!!")))))))))))

etype_imis <- as.data.frame(table(imis$e.type))

etype_imis <-etype_imis %>% rename(e.type_imis = Var1, Freq_imis = Freq)

etype_imis$etypeUSAdata <- etype_imis$e.type_imis


etypeUSAdata <- merge(etype_imis, etype_ois, by = "etypeUSAdata", all = TRUE)

etypeUSAdata <-etypeUSAdata[-1,]


# 147637
describe(oischem_complet$exposure.type) # 9 NA

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

e.type <- as.data.frame(table(oischem_complet$e.type, oischem_complet$exposure.type))

e.type <- filter(e.type, Freq > 0)

oischem_complet$exposure.type <- NULL

# 147637

flextable(etypeUSAdata)%>%
  set_caption(caption = "Tableau 6 :Valeurs des e.levels pour OIS et IMIS")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)



## ---- label=oisimis5--------------------------------------------------------------

remove(e.type)



## ---- label=oisimis7, include=FALSE-----------------------------------------------
# 147637
oischem_complet$l <- str_length(oischem_complet$site.naics)

table(oischem_complet$l, useNA = "always") # 3 NA

## combler les 3 NA

oischem_complet$naics <- if_else(is.na(oischem_complet$site.naics), oischem_complet$primary.naics, oischem_complet$site.naics)

oischem_complet$primary.naics <- NULL

describe(oischem_complet$site.naics) # toujours 3 NA

## Est-ce que l'on peut attribuer des codes NAICS à partir de la même compatnie aux 3 NA ?

na.naics <- filter(oischem_complet, is.na(site.naics))

oischem_complet$t <- str_detect(oischem_complet$estab.name, "USDOL OSHA - TOLEDO|US DOL OSHA - Parsippany AO") # 491 avec l'un des deux noms

oischem_complet$t2 <- str_detect(oischem_complet$site.address, "1575 Long View Ave.Mansfield, OH 44906|250 Hamburg Tpke,, BUTLER,NJ,07405 UNITED STATES OF AMERICA,MORRIS") # les site.adresses des NA

na.naics.cie <- filter(oischem_complet, t == TRUE & t2 == TRUE) # seulement les trois enregistrements

# retrait des NA

oischem_complet <- filter(oischem_complet, !is.na(site.naics))

# 147634


## ---------------------------------------------------------------------------------
remove(na.naics)
remove(na.naics.cie)
oischem_complet$t2 <- NULL
oischem_complet$l <- NULL


## ----label=oisimis8---------------------------------------------------------------


oischem_complet$s.type <- if_else(oischem_complet$sample.type == "Area", "A",
              if_else(oischem_complet$sample.type == "Personal", "P", "NA"))

oischem_complet$sample.type <- NULL


## ---- label=oisimis9--------------------------------------------------------------


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

units_ois <- as.data.frame(table(oischem_complet$exposure.units, oischem_complet$units))

units_ois <- filter(units_ois, Freq > 0)


# tableau unité 

units.imis <- units.imis %>% rename(units_imis = Var1, Freq_imis = Freq)

units.imis$units_USAdata <- units.imis$units_imis

units_ois <- units_ois %>% rename(units_ois = Var1, units_USAdata = Var2, Freq_ois = Freq)

unitsUSAdata <- merge(units.imis, units_ois, by = "units_USAdata", all = TRUE )

unitsUSAdata <- unitsUSAdata[-1,] # ligne à suprimer
unitsUSAdata <- unitsUSAdata[-21,] # ligne à suprimer

unitsUSAdata$source_description_imis <- if_else(unitsUSAdata$units_imis == "%", "Chemical Exposure Health Data - Dataset Field Definitions^1^",
                       if_else(unitsUSAdata$units_imis == "B", "Seulement les substances 8110, 8111 et 8130",      
                       if_else(unitsUSAdata$units_imis == "C", "IMIS data dictionary_tracy2020.xlsx^2^",
                       if_else(unitsUSAdata$units_imis == "D", "IMIS data dictionary_tracy2020.xlsx^2^",
                       if_else(unitsUSAdata$units_imis == "F", "Chemical Exposure Health Data - Dataset Field Definitions^1^",
                       if_else(unitsUSAdata$units_imis == "G", "IMIS data dictionary_tracy2020.xlsx^2^",
                       if_else(unitsUSAdata$units_imis == "L", "IMIS data dictionary_tracy2020.xlsx^2^",
                       if_else(unitsUSAdata$units_imis == "M", "Chemical Exposure Health Data - Dataset Field Definitions^1^",
                       if_else(unitsUSAdata$units_imis == "P", "Chemical Exposure Health Data - Dataset Field Definitions^1^",
                       if_else(unitsUSAdata$units_imis == "X", "Chemical Exposure Health Data - Dataset Field Definitions^1^",
                       if_else(unitsUSAdata$units_imis == "Y", "Chemical Exposure Health Data - Dataset Field Definitions^1^", 
        "")))))))))))


flextable(unitsUSAdata)%>%
  set_caption(caption = "Tableau 8 : Agents retirés d'IMIS et leur fréquence dans les données brutes")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)




## ---- label=n11, include=FALSE----------------------------------------------------
remove(units_ois)
remove(units.imis)


## ---- label=oisimis_subst, include=FALSE------------------------------------------
# OIS

## valider motif

oischem_complet$t1 <- str_count(oischem_complet$substance, "^....-") # compte le nombre de fois où il y a le motif

table(oischem_complet$t1) # pas de double occurrence avec ce motif. 

## Extraire le motif

oischem_complet$subst  <- str_extract(oischem_complet$substance, "^....-") 

oischem_complet$subst  <- str_remove_all(oischem_complet$subst, "-") 

## Valider

subst <- as.data.frame(table(oischem_complet$subst, oischem_complet$substance)) 

subst <- filter(subst, Freq > 0)

sum(is.na(oischem_complet$substance))-sum(is.na(oischem_complet$subst))  # aucun nouveau NA


oischem_complet$subst2  <- oischem_complet$subst


# IMIS

## est ce que les codes imis ont toujours 4 éléments

imis$t.nb.subs <- str_count(imis$subst,".")

table(imis$t.nb.subs) # il y a 1949 enregistrements avec code 2 caractères et 43 820 avec 3 caractères

t.imis.subst <- filter(imis, t.nb.subs < 4 )

t.imis.subst <- as.data.frame(table(t.imis.subst$subst))


t.imis.subst$code.option <- c("0230, 1230, P230, 2230", "0261, 2610, 2611, 2612, 2616, R261","0320, 2320, 8320, E320","0360, 1360, 2360, 8360, T360","0040 + 39 autres options","0430, 1430, 2430, 8430","0440, 1440, 2440","0490, 1490, 2490","0491","0685, 2685, 9685","0686","0720, 2720, 1720","0731" )


t.imis.subst<- t.imis.subst %>% rename(code.imis = Var1)


## ---- label=oisimis_subst2a-------------------------------------------------------
#présenter les résultats

flextable(t.imis.subst)%>%
  set_caption(caption = "Tableau 9 : Substances n'ayant pas un code à 4 chiffres dans IMIS")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)


## ---- label=oisimis_subst3, include=FALSE-----------------------------------------

imis$subst2 <- str_pad(imis$subst, 4, side = "left", pad = "0")

# count

imis$t <- str_count(imis$subst2, ".")

table(imis$t)




## ---- label=n12, include=FALSE----------------------------------------------------
remove(t.imis.subst)
remove(subst)


## ---- label=oisimis_combi, include=FALSE------------------------------------------
#OIS

## nettoyer substance pour enlever le code

oischem_complet$substance2  <- str_remove_all(oischem_complet$substance, "^....-") 


# ajouter le nom des substances dans IMIS

## faire correspondre

imis$substance2 <- label.subs.usData$label[match(imis$subst2, label.subs.usData$code)]

imis.code.na <- filter(imis, is.na(imis$substance2)) # 402 enregistrement NA
  
imis.code.na <- as.data.frame(table(imis.code.na$subst2)) # 100 codes différent




## ----label=oisimis_subst2b--------------------------------------------------------

## Présenter

imis.code.na <- rename(imis.code.na, code = Var1)

ft.imis.code.na <- filter(imis.code.na, Freq >= 10)

flextable(ft.imis.code.na)%>%
  set_caption(caption = "Tableau 10 : Codes sans nom de substances et ayant une fréquence d'au moins 10 dans IMIS")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)




## ----label=n13, include=FALSE-----------------------------------------------------
remove(imis.code.na)
remove(ft.imis.code.na)



## ---- label=oisimis_nr.exposed----------------------------------------------------
summary(imis$nr.exposed)
summary(oischem_complet$emp.cvrd)



## ---- label=oisimis_ownership-----------------------------------------------------
describe(oischem_complet$ownership.type)
table(oischem_complet$ownership.type)



## ---------------------------------------------------------------------------------
describe(imis$s.nbr)
describe(oischem_complet$exposure.assessment)
describe(oischem_complet$exposure.record)

label <- c("bd$variable", "nbr.valeur.unique", "nbr.enregistrement.bd/nbr.valeur.unique")

s.nbr <- c("imis$s.nbr", n_distinct(imis$s.nbr), length(imis$s.nbr)/n_distinct(imis$s.nbr))

exposure.assessment <- c("ois$e.assessment", n_distinct(oischem_complet$exposure.assessment), length(oischem_complet$exposure.assessment)/n_distinct(oischem_complet$exposure.assessment))

exposure.record <- c("ois$e.record", n_distinct(oischem_complet$exposure.record), length(oischem_complet$exposure.record)/n_distinct(oischem_complet$exposure.record))

association <- as.data.frame(rbind(s.nbr, exposure.assessment, exposure.record))

names(association) <- label

flextable(association)%>%
  set_caption(caption = "Tableau x : exposure.assessment ou exposure.record vs s.nbr")%>%
  theme_booktabs()%>% 
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)%>%
  colformat_num(j = 2, digits = 3)

fivenum(table(imis$s.nbr))

fivenum(table(oischem_complet$exposure.assessment))

fivenum(table(oischem_complet$exposure.record))

mytable <- data.frame(table(oischem_complet$exposure.record))

mytable <- filter(mytable, Freq == 4)

t552 <- filter(oischem_complet, exposure.record == 552)


table(oischem_complet$sample.sheet == oischem_complet$exposure.record)

t <- oischem_complet[oischem_complet$sample.sheet != oischem_complet$exposure.record,]



## ---- label=oisimis_prep, include=FALSE-------------------------------------------
#  Uniformisation des textes

## establishment

### valider le format

imis$t.esta <- str_detect(imis$establishment, "[:lower:]")

table(imis$t.esta) # aucune minuscule

### transformé le format d'OIS pour correspondre à IMIS

oischem_complet$establishment <- str_to_upper(oischem_complet$estab.name) # Cette variable dans imis est 100 % en majuscule

oischem_complet$estab.name <- NULL

imis$t.esta <- NULL


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




## ---- label=fusionOISIMIS, include=FALSE------------------------------------------
# vérifier les différences

name.imis <- as.data.frame(names(imis))

name.ois <- as.data.frame(names(oischem_complet))

name.imis$na <- is.element(name.imis$`names(imis)`, name.ois$`names(oischem_complet)`)

name.ois$na <- is.element(name.ois$`names(oischem_complet)`, name.imis$`names(imis)`)

dfusa <- as.data.frame(rbind(imis, oischem_complet))

nrow(imis)+nrow(oischem_complet)==nrow(dfusa) # True et le nombre de variable est identique

# write.xlsx(dfusa, file = "C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/usa_data/data_intermediaire/dfusa.xlsx")




## ----label=n14,  include=FALSE----------------------------------------------------
remove(name.imis)
remove(name.ois)



## ----label=fusionOISIMIS2---------------------------------------------------------
# Ajout d'un identifiant IMIS ou OIS

dfusa$t <- str_detect(dfusa$id.dfno, "ois")

dfusa$iddf <- ifelse(dfusa$t == TRUE, "OIS", "IMIS")

table(dfusa$iddf, useNA = "ifany") # résultat corresponds au nombre d'enregistrement de oischem et imis avant la fusion


## ---- label=dfusa_activity.nr, include=FALSE--------------------------------------

describe(dfusa$activity.nr)



## ---- include=FALSE---------------------------------------------------------------
describe(dfusa$state)

table(dfusa$state, useNA = "always")


## ---- label=dfusa_report.id, include=FALSE----------------------------------------
describe(dfusa$report.id)



## ---- label=dfusaestablishment, include=FALSE-------------------------------------
describe(dfusa$establishment)

dfusa$establishment <- str_squish(dfusa$establishment) # retire les espaces avant et après le texte et modifie les doubles espaces en une seule

describe(dfusa$establishment) # le nettoyage précédant à retiré 10 valeurs uniques

dfusa$establishment <- str_to_upper(dfusa$establishment)




## ---- label=dfusa_city------------------------------------------------------------


## correction

dfusa$city2 <- str_squish(dfusa$city2) # retire les espaces avant et après le texte et modifie les doubles espaces en une seule

### Convertir Saint en st (à permis d'ajouter 10 correspondances)

dfusa$city2 <- str_replace(dfusa$city2, "^SAINT ", "ST ")

### Mount vs Mt vs Mt.

dfusa$city2 <- str_replace(dfusa$city2, "^MT ", "MOUNT ")
dfusa$city2 <- str_replace(dfusa$city2, "^MT. ", "MOUNT ")


# s'assurer que tout est en majuscule

dfusa$t <- str_detect(dfusa$city2, "[:lower:]")

table(dfusa$t)

# city, abréviation AFB et A F B est utilisé pour Air Force Base, parfois au long.

dfusa$city2 <- str_replace(dfusa$city2, "A F B", "AFB")

dfusa$city2 <- str_squish(dfusa$city2)

describe(dfusa$city2)




## ---- label=dfusa_state1, include=FALSE-------------------------------------------
describe(dfusa$state.1)

dfusa$t <- str_length(dfusa$state.1)


state_dfusa <- as.data.frame(table(dfusa$state.1))

state_dfusa <- rename(state_dfusa, code = Var1)

# ouvrir une source pour les label des états

state <- read.xlsx("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/usa_data/data_intermediaire/state_imis_ois.xlsx")

state_dfusa$label <- state$label[match(state_dfusa$code, state$id.imis)]


state_dfusa <- state_dfusa %>% relocate(label, .after = code)


## ---- label=dfusa_state1_flex-----------------------------------------------------
flextable(state_dfusa)%>%
  set_caption(caption = "Tableau 11 : Code and label for insp.scope")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)




## ---------------------------------------------------------------------------------
remove(state)
remove(state_dfusa)


## ---- , label=dfusa_zip, include=FALSE--------------------------------------------


dfusa$t <- str_length(dfusa$zip)

zipcor <- filter(dfusa, t < 5)

zipcor <- as.data.frame(table(zipcor$zip))

zipusa <- read_xls("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/usa_data/data_intermediaire/zip_code_database.xls")

zipcor$el <- is.element(zipcor$Var1, zipusa$zip)

table(zipcor$el)

zippb <- filter(zipcor, el == FALSE) # isoler les codes problématiques

dfusa$zip3 <- str_pad(dfusa$zip, 5, side = "left", pad = "0")

dfusa$zip4 <-  is.element(dfusa$zip, zippb$Var1)

dfusa$zip2 <- if_else(dfusa$zip4 == TRUE, dfusa$zip, dfusa$zip3)

dfusa$zip3 <- NULL

dfusa$zip4 <- NULL

describe(dfusa$zip)


## ---------------------------------------------------------------------------------
remove(zipcor)
remove(zippb)
remove(zipusa)


## ---- label=dfusa_sic, include=FALSE----------------------------------------------
# Count NA by group
data_count <- dfusa %>%  
  group_by(iddf) %>%
  dplyr::summarize(count_na = sum(is.na(sic)))

data_count # Print group counts


# longueur des codes

dfusa$t <- str_length(dfusa$sic)
table(dfusa$t)



## ---- label=dfusa_insptype, include=FALSE-----------------------------------------
describe(dfusa$insp.type)

insp.type <- as.data.frame(table(dfusa$insp.type, useNA = "ifany"))

insp.type <-  rename(insp.type, code = Var1)

insp.type$label <- if_else(insp.type$code == "A", " Accident",
       if_else(insp.type$code == "B", " Complaint",
       if_else(insp.type$code == "C", " Referral",
       if_else(insp.type$code == "C1", " Referral-Employer Reported",
       if_else(insp.type$code == "D", " Monitoring",
       if_else(insp.type$code == "E", " Variance",
       if_else(insp.type$code == "F", " Follow-Up",
       if_else(insp.type$code == "G", " Unprogrammed Related",
       if_else(insp.type$code == "H", " Program Planned",
       if_else(insp.type$code == "I", " Programmed Related",
       if_else(insp.type$code == "J", " Unprogrammed Other",
       if_else(insp.type$code == "K", " Programmed Other",
       if_else(insp.type$code == "L", " Other--Other",
       if_else(insp.type$code == "L1", " Other--Data Initiative Non-Responder",
       if_else(insp.type$code == "L2", " Other--ATARs",
       if_else(insp.type$code == "M", " Fatality/Catastrophe",
       if_else(insp.type$code == "X", " No Insp/Other",
                                 "NA"))))))))))))))))) 

insp.type <- insp.type %>% relocate(label, .after = code)


## ---- label=dfusa_insptype_flex---------------------------------------------------
flextable(insp.type)%>%
  set_caption(caption = "tableau 12 : Code et label pour insp.type")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)



## ---- label=n15, include=FALSE----------------------------------------------------
remove(insp.type)


## ---- label=dfusa_subst, include=FALSE--------------------------------------------

describe(dfusa$subst2)

# longueur des codes

dfusa$t <- str_length(dfusa$subst2)
table(dfusa$t)



## ---- label=dfusa_substance, include=FALSE----------------------------------------
describe(dfusa$substance)

describe(dfusa$substance2)


# Count NA by group
data_count <- dfusa %>%  
  group_by(iddf) %>%
  dplyr::summarize(count_na = sum(is.na(substance2)))

data_count # Print group counts

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






## ---- label=dfusa_exps.freq, include=FALSE----------------------------------------

dfusa$exps.freq <- str_squish(dfusa$exps.freq)

dfusa$exps.freq <- str_to_upper(dfusa$exps.freq)

describe(dfusa$exps.freq)



## ---- label=dfusa_emp.cvrd, include=FALSE-----------------------------------------
describe(dfusa$emp.cvrd)



## ---- label=dfusa_pel-------------------------------------------------------------
describe(dfusa$pel)



## ---- label=dfusa_nrexposed-------------------------------------------------------
describe(dfusa$nr.exposed)



## ---- label=dfusa_units, include=FALSE--------------------------------------------
describe(dfusa$units)


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


# Présent le résultat
units <- as.data.frame(table(dfusa$units, dfusa$units.label, useNA = "ifany"))

units <- units %>% rename(Code = Var1, Label = Var2)

units <- filter(units, Freq > 0)


## ---- label=dfusa_units_flex------------------------------------------------------
flextable(units)%>%
  set_caption(caption = "Tableau 13 : Code and label for units")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)



## ---- label=n16, include=FALSE----------------------------------------------------
remove(units)



## ---- label=dfusa_inspscope, include=FALSE----------------------------------------
insp.scope <- as.data.frame(table(dfusa$insp.scope, useNA = "ifany"))

insp.scope <- rename(insp.scope, code = Var1)


insp.scope$label <- if_else(insp.scope$code == "A", "Comprehensive", 
                    if_else(insp.scope$code == "D", "No Inspection", 
                    if_else(insp.scope$code == "B", "Partial", 
                    if_else(insp.scope$code == "C", "Records Only",  "!!!"))))



insp.scope <- insp.scope %>% relocate(label, .after = code)


## ---- label=dfusa_inspscope_flex--------------------------------------------------
flextable(insp.scope)%>%
  set_caption(caption = "Tableau 14 : Code and label for insp.scope")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)



## ---- label=n18, include=FALSE----------------------------------------------------
remove(insp.scope)



## ---- label=dfusa_adjpel, include=FALSE-------------------------------------------
describe(dfusa$adj.pel)

# Count NA by group
data_count <- dfusa %>%  
  group_by(iddf) %>%
  dplyr::summarize(count_na = sum(is.na(adj.pel)))

data_count # Print group counts

table(dfusa$adj.pel, useNA = "always")


dfusa$adj.pel <- NULL



## ---- label=dfusa_jobtitle, include=FALSE-----------------------------------------

dfusa$job.title <- str_squish(dfusa$job.title) # retire les espaces avant et après le texte et modifie les doubles espaces en une seule

dfusa$job.title <- str_to_upper(dfusa$job.title)

describe(dfusa$job.title)



## ---- label=dfusa_naics, include=FALSE--------------------------------------------
describe(dfusa$naics)

# Count NA by group
data_count <- dfusa %>%  
  group_by(iddf) %>%
  dplyr::summarize(count_na = sum(is.na(naics)))

data_count # Print group counts


# longueur des codes

dfusa$t <- str_length(dfusa$naics)

table(dfusa$t)



## ---- label=dfusa_expodurationunits-----------------------------------------------
describe(dfusa$expo.duration.units)

# Count NA by group
data_count <- dfusa %>%  
  group_by(iddf) %>%
  dplyr::summarize(count_na = sum(is.na(expo.duration.units)))

data_count # Print group counts




## ---- label=dfusa_union-----------------------------------------------------------
describe(dfusa$union)

table(dfusa$union, useNA = "ifany")


## ---- label=dfusa_severity--------------------------------------------------------
describe(dfusa$severity)



## ---- label=dfusa_elevel----------------------------------------------------------

describe(dfusa$e.level)

# Count NA by group
data_count <- dfusa %>%  
  group_by(iddf) %>%
  dplyr::summarize(count_na = sum(is.na(e.level)))

data_count # Print group counts





## ---------------------------------------------------------------------------------
remove(data_count)


## ---- label=dfusa_advnotice-------------------------------------------------------
describe(dfusa$adv.notice)



## ---- label=dfusa_etype,include=FALSE---------------------------------------------
# 779906

table(dfusa$e.type, useNA = "ifany") # il y a 9 enregistrements NA et une qui n'ont pas de valeur, mais qui ne sorte pas NA. On va forcer pour le NA

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


e.type <- as.data.frame(table(dfusa$e.type, useNA = "always"))

e.type <- rename(e.type, code = Var1)

e.type$label <- if_else(e.type$code== "A", "Not Analyzed",
                if_else(e.type$code == "C", "Ceiling",
                if_else(e.type$code == "D", "Dose", 
                if_else(e.type$code == "F", "non-detect", 
                if_else(e.type$code == "L", "STEL",  
                if_else(e.type$code == "P", "PEAK",  
                if_else(e.type$code == "S", "Sound Level", 
                if_else(e.type$code == "T", "TWA",
                if_else(e.type$code == "V", "Not valid",  
                if_else(e.type$code == "Z", "Action Level",            
                             "x"))))))))))

e.type <- e.type %>% relocate(label, .after = code)


## ---- label=dfusa_etype_flex------------------------------------------------------
flextable(e.type)%>%
  set_caption(caption = "Tableau 15 : Code and label for e.type")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)



## ---------------------------------------------------------------------------------
dfusa$t <- is.na(dfusa$e.type)

table(dfusa$t)

dfusa <- filter(dfusa, t == FALSE)
# 779896



## ---- label=n20-------------------------------------------------------------------
remove(e.type)


## ---- label=dfusa_exposureduration, include=FALSE---------------------------------
describe(dfusa$exposure.duration)



## ---- label=dfusa_occcode, include=FALSE------------------------------------------
describe(dfusa$occ.code)



## ---- label=dfusa_sdatea----------------------------------------------------------

# Min et Max par DF
data_count <- dfusa %>%  
  group_by(iddf) %>%
  dplyr::summarize(min = min(s.date), max(s.date))

data_count # Print group counts



## ---- label=dfusa_stype, include=FALSE--------------------------------------------

table(dfusa$s.type, useNA = "ifany")

dfusa$t <- is.na(dfusa$s.type)

dfusa <- filter(dfusa, t == FALSE)

# 779896 - 628 = 779268



## ---- label=dfusa_exposure.record, include=FALSE----------------------------------

describe(dfusa$exposure.record)



## ---------------------------------------------------------------------------------
# dfusa 779 268

# combinaison e.type = A "Not Analyzed" et e.level

e.typeA.level <- filter(dfusa, e.type == "A")

describe(e.typeA.level$e.level)


# combinaison e.type = V "Not valid" et e.level

e.typeV.level <- filter(dfusa, e.type == "V")

describe(e.typeV.level$e.level)

# Éliminer les e.type V et A

dfusa$t <- str_detect(dfusa$e.type, "V|A")

table(dfusa$t)

dfusa <- dfusa[dfusa$t == FALSE, ]

#774197-5071 = 774197



## ---------------------------------------------------------------------------------
# dfusa 774197

# combinaison e.type = F "non-detect" et e.level

describe(dfusa$e.level[dfusa$e.type =="F"])



## ---------------------------------------------------------------------------------
# Créer la variable e.type.ois

## copier les valeurs de e.type

dfusa$e.type.ois <- dfusa$e.type 

## mettre les valeurs en provenance d'IMIS à NA 

dfusa$e.type.ois[dfusa$iddf == "IMIS"] <- NA

table(dfusa$e.type.ois, useNA = "always") # le nombre de NA correspond bien au nombre d'enregistrement d'IMIS

# 774197

dfusa$zero <- dfusa$e.level == 0

# distribution des zéro en fonction de la source et du e.type

fzero <- dfusa %>%  
  group_by(iddf, e.type, zero) %>%
  dplyr::summarize(Total = length(zero))

# présenter les résultats

## séparer les vrais et les faux dans deux colonnes

fzero.t.imis <- filter(fzero, zero == TRUE & iddf == "IMIS")

fzero.f.imis <- filter(fzero, zero == FALSE  & iddf == "IMIS")

fzero.t.ois <- filter(fzero, zero == TRUE & iddf == "OIS")

fzero.f.ois <- filter(fzero, zero == FALSE  & iddf == "OIS")

## fusionner

fzero2 <- merge(fzero.t.imis, fzero.f.imis, by = "e.type", all = TRUE)

fzero2 <- fzero2 %>% rename(egal.zero = Total.x, pas.egal.zero = Total.y)

fzero2$zero.x <- NULL

fzero2$zero.y <- NULL

fzero2$iddf.x <- NULL

fzero2$iddf.y <- "IMIS"


fzero3 <- merge(fzero.t.ois, fzero.f.ois, by = "e.type", all = TRUE)

fzero3 <- fzero3 %>% rename(egal.zero = Total.x, pas.egal.zero = Total.y)

fzero3$zero.x <- NULL

fzero3$zero.y <- NULL

fzero3$iddf.x <- NULL


fzero <- rbind(fzero2, fzero3)

fzero <- rename(fzero, iddf = iddf.y)

fzero <- fzero %>% relocate(iddf, .after = e.type)

fzero <- fzero[order(fzero$e.type),] # trier 

myft <- flextable(fzero)

myft <- border_remove(myft)

myft%>%
  set_caption(caption = "Distribution des e.level = 0 selon e.type")%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)%>%
  add_header_row(values = c("", "Frequence des e.level"), colwidths = c(2, 2))%>%
  hline_bottom(border = big_border, part = "body")%>%
  hline_top(border = big_border, part = "head")%>%
  hline_bottom(border = big_border, part = "head")



## ---------------------------------------------------------------------------------
# 774197

dfusa$e.type2 <- if_else(is.na(dfusa$e.level), dfusa$e.type,
                         if_else(dfusa$e.level == 0, "F", 
                          dfusa$e.type)) # doit passer par is.na avant, car sinon les e.level NA attribuent des NA aux e.type

table(dfusa$e.type2, useNA = "always")



## ---------------------------------------------------------------------------------
remove(fzero)
remove(fzero.f.imis)
remove(fzero.t.imis)
remove(fzero.f.ois)
remove(fzero.t.ois)
remove(fzero2)
remove(fzero3)
remove(e.typeA.level)
remove(e.typeV.level)
remove(myft)



## ---------------------------------------------------------------------------------
# 774197

# D'où proviennent les e.level NA

elevel.na <- filter(dfusa, is.na(e.level))

table(elevel.na$iddf)

# Convertir les NA en zéro

dfusa$e.level2 <- if_else(is.na(dfusa$e.level), 0, dfusa$e.level)

describe(dfusa$e.level2)

# Mettre la valeur F pour les valeurs de zéro

dfusa$e.type2 <- if_else(dfusa$e.level2 == 0, "F", dfusa$e.type)

table(dfusa$e.type2, useNA = "always")



## ---------------------------------------------------------------------------------
remove(elevel.na)



## ---- include=FALSE---------------------------------------------------------------
# 774197
# présenter les combinaisons

units_byDF <- as.data.frame(table(dfusa$iddf, dfusa$units))

units_byDF <- filter(units_byDF, Freq > 0)

units_byDF <- units_byDF %>% rename(Source = Var1, Unit = Var2)

units_byDF <- units_byDF[order(units_byDF$Source),]

units_byDF$Label <- if_else(units_byDF$Unit ==  "C", "picocuries per liter",
                    if_else(units_byDF$Unit == "B", "decibel",  
                    if_else(units_byDF$Unit == "D", "milligrams per deciliter", 
                    if_else(units_byDF$Unit == "F1", "fibers",  
                    if_else(units_byDF$Unit == "G", "million particles per cubic foot",  
                    if_else(units_byDF$Unit == "L", "milligrams per liter",  
                    if_else(units_byDF$Unit == "M", "milligrams per cubic meter",  
                    if_else(units_byDF$Unit == "P", "parts per million",  
                    if_else(units_byDF$Unit == "%", "percent",  
                    if_else(units_byDF$Unit == "Y", "milligram",  
                    if_else(units_byDF$Unit == "X", "micrograms",  
                    if_else(units_byDF$Unit == "F", "fibers per cubic centimeter",  
                    if_else(units_byDF$Unit == "X1", "micrograms per cubic meter", 
                    if_else(units_byDF$Unit == "X3", "microgram per liter", 
                    if_else(units_byDF$Unit == "A", "picocuries/l (radon) ?",
                    if_else(units_byDF$Unit == "R", "micrograms",
                    if_else(units_byDF$Unit == "S", "micrograms",
                    if_else(units_byDF$Unit == "T", "micrograms",
                    if_else(units_byDF$Unit == "U", "micrograms",
                    if_else(units_byDF$Unit == "W", "micrograms",
                    "blank observations"))))))))))))))))))))

units_byDF <- units_byDF %>% relocate(Label, .after = Unit)


## ---------------------------------------------------------------------------------
flextable(units_byDF)%>%
  set_caption(caption = "Tableau 16 : Unités présentes par origine des données")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)


## ---------------------------------------------------------------------------------
# 774197

#### IMIS : T, U, W, X, Y comparativement à M

imis_TF <- dfusa[dfusa$iddf == "IMIS" 
                      & is.element(dfusa$e.type, c("T", "F")) 
                                   & is.element(dfusa$units, c("T", "U", "W", "X", "Y", "M")),]

table(imis_TF$e.type2, imis_TF$units)


## ---------------------------------------------------------------------------------
# 774197

#### OIS : T, U, W, X, Y comparativement à M

ois_TF <- dfusa[dfusa$iddf == "OIS" 
          & is.element(dfusa$e.type, c("T", "F")) 
          & is.element(dfusa$units, c("T", "U", "W", "X", "Y", "M")),]

table(ois_TF$e.type2, ois_TF$units)



## ---- include=FALSE---------------------------------------------------------------
# 774197
dfusa$t <- str_detect(dfusa$units, "T|Y|X|W|U")

dfusa$t2 <- dfusa$t == TRUE & dfusa$e.type2 != "F"

table(dfusa$t2) # 1805 true

dfusa <- filter(dfusa, t2 == FALSE)

#774197-1805 =772392



## ---------------------------------------------------------------------------------
# 772392
#### fibre ois

ois_TF <- dfusa[dfusa$iddf == "OIS" 
                     & is.element(dfusa$units, c("F", "F1")),]

table(ois_TF$e.type, ois_TF$units)



ois_TF <- dfusa[dfusa$iddf == "OIS" 
                     & is.element(dfusa$units, "F1"),]

table(ois_TF$units, ois_TF$e.level)




## ---------------------------------------------------------------------------------
remove(ois_TF)
remove(imis_TF)
remove(units_byDF)



## ---------------------------------------------------------------------------------
## 772392

dfusa$units2 <- dfusa$units

dfusa$units2[dfusa$e.type2 == "F"] <- NA

table(is.na(dfusa$units2), dfusa$e.type2)

table(is.na(dfusa$units2), dfusa$e.level2==0)



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



write.xlsx(units.subst, file = "C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/usa_data/data_intermediaire/dfusa_unitssubsts_pour_validation.xlsx")


## ---- label=dfusa_unit_substb, include=FALSE--------------------------------------
# 772392

# combinaison à retirer

## ouvrir le df vérifieré

units.subst <- read.xlsx("C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/usa_data/data_intermediaire/dfusa_unitssubsts_verifie.xlsx")

## création de la variable combinant units et substance2

dfusa$combi <- paste(dfusa$units, dfusa$substance2)

units.subst$combi <- paste(units.subst$code.units, units.subst$substance2)

## ajouter décision

dfusa$valid.unit.subst <- units.subst$decision[match(dfusa$combi, units.subst$combi)]

retrait.unit.subst <- filter(dfusa, valid.unit.subst == "remove")


## présenter les retraits

retrait.unit.subst <- as.data.frame(table(retrait.unit.subst$units, retrait.unit.subst$substance2))

retrait.unit.subst <- filter(retrait.unit.subst, Freq > 0)

retrait.unit.subst <- retrait.unit.subst %>% rename(units = Var1, substance2 = Var2)

# ajouter signification des unités

retrait.unit.subst$label.units <- if_else(retrait.unit.subst$units ==  "C", "picocuries per liter",
                    if_else(retrait.unit.subst$units == "B", "decibel",  
                    if_else(retrait.unit.subst$units == "D", "milligrams per deciliter", 
                    if_else(retrait.unit.subst$units == "F1", "fibers",  
                    if_else(retrait.unit.subst$units == "G", "million particles per cubic foot",  
                    if_else(retrait.unit.subst$units == "L", "milligrams per liter",  
                    if_else(retrait.unit.subst$units == "M", "milligrams per cubic meter",  
                    if_else(retrait.unit.subst$units == "P", "parts per million",  
                    if_else(retrait.unit.subst$units == "%", "percent",  
                    if_else(retrait.unit.subst$units == "Y", "milligram",  
                    if_else(retrait.unit.subst$units == "X", "micrograms",  
                    if_else(retrait.unit.subst$units == "F", "fibers per cubic centimeter",  
                    if_else(retrait.unit.subst$units == "X1", "micrograms per cubic meter", 
                    if_else(retrait.unit.subst$units == "X3", "microgram per liter", 
                    if_else(retrait.unit.subst$units == "A", "picocuries/l (radon) ?",
                    if_else(retrait.unit.subst$units == "R", "micrograms",
                    if_else(retrait.unit.subst$units == "S", "micrograms",
                    if_else(retrait.unit.subst$units == "T", "micrograms",
                    if_else(retrait.unit.subst$units == "U", "micrograms",
                    if_else(retrait.unit.subst$units == "W", "micrograms",
                    "blank observations"))))))))))))))))))))


retrait.unit.subst <- retrait.unit.subst %>% relocate(label.units, .after = units) 

retrait.unit.subst <- retrait.unit.subst[order(retrait.unit.subst$Freq, decreasing = TRUE),]


## ---- label=dfusa_unit_substb_flex------------------------------------------------

flextable(retrait.unit.subst)%>%
  set_caption(caption = "Tableau 17 : combinaisons unités et substance à retirer")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)



## ---------------------------------------------------------------------------------
# 772392
sum(retrait.unit.subst$Freq) # 1058

table(dfusa$valid.unit.subst, useNA = "always")

dfusa$units.subst.na <- is.na(dfusa$valid.unit.subst)

table(dfusa$units.subst.na, useNA = "always")

dfusa <- filter(dfusa, valid.unit.subst != "remove" | is.na(valid.unit.subst))

#772392-1058 = 771334



## ---- label=n22-------------------------------------------------------------------

remove(retrait.unit.subst)
remove(units.subst)



## ---- label=actionlevel, include=FALSE--------------------------------------------
# 771334

# Identifier les mentions du e.type dans les noms des substances

## ACTION LEVEL Action Level

dfusa$al <- str_detect(dfusa$substance2, "ACTION LEVEL") 

action.level <- filter(dfusa, al == TRUE & e.type != "Z" & e.type != "F"& e.type != "V"& e.type != "A")

action.level <- as.data.frame(table(action.level$e.type, action.level$substance2))

action.level <- filter(action.level, Freq > 0)

action.level <- action.level %>% rename(e.type = Var1, substance2 = Var2)

sum(action.level$Freq)


## ---- label=actionlevel_flex------------------------------------------------------
flextable(action.level)%>%
  set_caption(caption = "Tableau 18 :Substances avec une mention action level mais avec un e.types différent")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)



## ---------------------------------------------------------------------------------

# 771334 

dfusa$t.al <- str_detect(dfusa$e.type,  "Z|F|V|A")

dfusa$t.al2 <- dfusa$al == TRUE & dfusa$t.al == FALSE

table(dfusa$t.al2, useNA = "ifany")

dfusa <- filter(dfusa, t.al2 == FALSE | is.na(dfusa$al))

#771334-2032-125 = 769302



## ---- label=twa, include=FALSE----------------------------------------------------
# 769302
## TWA

dfusa$twa <- str_detect(dfusa$substance2, "TWA")


twa <- filter(dfusa, twa == TRUE & e.type != "T" & e.type != "F"& e.type != "V"& e.type != "A")

twa <- as.data.frame(table(twa$e.type, twa$substance2))

twa <- filter(twa, Freq > 0)

twa <- twa %>% rename(e.type = Var1, substance2 = Var2)


## ---- label=twa_flex--------------------------------------------------------------
flextable(twa)%>%
  set_caption(caption = "Tableau 19 : Substance avec une mention TWA avec un e.type associé autre que TWA")%>%
  theme_booktabs()%>%
  align_text_col(align = "center", header = TRUE, footer = TRUE)%>%
  autofit(add_w = 0.1, add_h =  0.1)


## ---------------------------------------------------------------------------------

# 769302
sum(twa$Freq) # 28

dfusa$twa2 <- str_detect(dfusa$e.type,  "F|V|T")

dfusa$twa3 <- dfusa$twa == TRUE & dfusa$twa2 == FALSE

table(dfusa$twa3, useNA = "ifany")

dfusa <- filter(dfusa, twa3 == FALSE | is.na(dfusa$twa))

# 769302-28 = 769274



## ---- label=ceiling---------------------------------------------------------------
# CEILING

dfusa$ceiling <- str_detect(dfusa$substance2, "CEILING")

ceiling <- filter(dfusa, ceiling == TRUE & e.type !="C"  & e.type != "F"& e.type != "V"& e.type != "A")




## ---- label=n24-------------------------------------------------------------------

dfusa$twa <- NULL
dfusa$ceiling <- NULL
dfusa$al <-  NULL
dfusa$ceiling <- NULL

remove(action.level)
remove(ceiling)
remove(twa)




## ---------------------------------------------------------------------------------

substances.dfusa <- as.data.frame(table(dfusa$subst2, dfusa$substance2))

substances.dfusa <- substances.dfusa %>% rename(code = Var1, label = Var2)

substances.dfusa <- filter(substances.dfusa, Freq > 0)

# write.xlsx(substances.dfusa, "C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/usa_data/substances_dfusa.xlsx")



## ---- label=dfusa_sdateb, include=FALSE-------------------------------------------
describe(dfusa$s.date)

imis.dfusa <- dfusa[dfusa$iddf == "IMIS",]

describe(imis.dfusa$s.date)


ois.dfusa <- dfusa[dfusa$iddf == "OIS",]

describe(ois.dfusa$s.date)


## ---------------------------------------------------------------------------------
#769274

table(dfusa$e.type)

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

table(dfusa$t)

# Pourquoi a-t-il des doublons

dfusa.doublon <- filter(dfusa, t == TRUE)


## est-ce que les doublons sont entre imis et ois ?


test <- as.data.frame(table(dfusa.doublon$iddf, dfusa.doublon$combi))

test <- filter(test, Freq >0)

## Si les données sont en double entre les deux jeux de données, ils vont sortir deux fois dans un tableau iddf et combi

## testons

test$dublicated <- duplicated2(test$Var2)

table(test$dublicated)



## ---- label=sauvegarde_final------------------------------------------------------

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

# sauvegarde

write.xlsx(dfusa, "C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/usa_data/USAdata_clean.xlsx")


write_rds(dfusa, "C:/Users/i_val/Dropbox/SHARE Multiexpo_data/IMIS/usa_data/USAdata_clean.rds")


