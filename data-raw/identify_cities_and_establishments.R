##################################### IMIS CLEANING #######################################

# Input:  ./data-raw/USIS_data.RDS
# Output: ./tmp/USIS_data.RDS
#
# Processing:
# 1. Cleaning of establishment names (and to a lesser extent, of cities and
#    states):
#    * Set `establishment`, `city` and `state` in upper case.
#    * Remove punctuation marks in `establishment`.
#    * Remove legal forms in `establishment` (LLC, INC, CO., etc.).
#    * Remove space between letters "U" and "S" in this order.
#    * Remove extra spaces and ending spaces
# 2. Assignment of identifiers to cities. An identifier is created by pasting
#    the state name with the city name and the US postal code.
#    This new variable is named "STATE_CITY_ZIP".
# 3. Assignment of identifiers to establishments. The same identifier is
#    assigned to establishments located in the same city/state and having very
#    similar names.
#    This new variable is named "COMPANY_INDEX".


##################################### DATA IMPORT #########################################

# Loading packages for the functions multigsub and stringdist
library(qdap)
library(stringdist)

# Data to clean
IMIS <- readRDS("./data-raw/USIS_data.RDS")

# Change variable names for this script
var_initial_names   <- c("establishment", "state.1", "city", "zip")
var_temporary_names <- toupper(var_initial_names)
var_indices <- match(var_initial_names, colnames(IMIS))
colnames(IMIS)[var_indices] <- var_temporary_names


########################## CLEANING ON COMPANIES - PART 1 #################################
## Clean establishment names

# Standardize the letter case of the variables identifying an establishment
IMIS[, c("ESTABLISHMENT", "CITY", "STATE.1")] <- data.frame(apply(IMIS[, c("ESTABLISHMENT", "CITY", "STATE.1")],
                                                                  2, toupper))

# Create an identifier for each city : STATE_CITY_ZIP
IMIS$STATE_CITY_ZIP <- paste0(IMIS$STATE.1, '-', IMIS$CITY,'-', IMIS$ZIP)


# Exclusion of punctuation
IMIS$ESTABLISHMENT <- gsub('[[:punct:]]+', ' ', IMIS$ESTABLISHMENT)

# Vector of some words to exclude
corp.vect <- c("INC", "CORP", "CO", "MFG", "LTD", "LLT", "LLC", "COMPANY", "COMP", "COMPAN",
               "CORPORATION", "CORPORA", "CORPOR", "CORPORAT", "INCORPORATED","MANUFACTURING",
               "LIMITED","DIV","DIVISION", "DIVI", "THE", "OF", "AND", "DBA", "D B A","DEPT", "I")
no.change <- which(IMIS$ESTABLISHMENT %in% corp.vect)
corp.vect <- paste0('(?<!\\w)', corp.vect, '(?!\\w)') # Add boudaries to the whole word only

# If the name of the establishment is nothing more than one of these words: no change
IMIS$ESTABLISHMENT[-no.change] <- multigsub(corp.vect,
                                            rep(' ', length(corp.vect)),
                                            IMIS$ESTABLISHMENT[-no.change],
                                            fixed = FALSE, perl = TRUE)

# Exclusion of US space
IMIS$ESTABLISHMENT <- gsub('U S', 'US', IMIS$ESTABLISHMENT)

# Exclusion of extra spaces
IMIS$ESTABLISHMENT <- gsub('[[:space:]]+', ' ', IMIS$ESTABLISHMENT)

# Exclusion of ending spaces
IMIS$ESTABLISHMENT <- gsub('[[:space:]]+$', '', IMIS$ESTABLISHMENT)


########################## CLEANING ON COMPANIES - PART 2 #################################
## Creation of company index
######################## 2.1. IDENTIFICATION OF CLOSE NAMES ###############################

# List unique names
distinct_company <- unique(IMIS[, c("ESTABLISHMENT", "STATE_CITY_ZIP", "CITY", "ZIP", "STATE.1")])
distinct_company <- distinct_company[order(distinct_company$ESTABLISHMENT), ]

# Calculation of distances
list_state_city_zip <- unique(distinct_company$STATE_CITY_ZIP) # Search and regroupement by STATE_CITY_ZIP
result_distance <- matrix(NA, nrow(distinct_company), 5)
m <- 1 ; n <- 0

for(i in 1:length(list_state_city_zip)){
  
  TMP <- subset(distinct_company, STATE_CITY_ZIP == list_state_city_zip[i])
  distance <- list()
  
  if(nrow(TMP) > 1){
    
    for(j in 1:(nrow(TMP)-1)){
      distance[[j]] <- stringdist(TMP$ESTABLISHMENT[j] , TMP$ESTABLISHMENT[(j+1):nrow(TMP)], method = 'jw') #one of the best fitted method when applied on several words
      
      if(any(distance[[j]] <= 0.25)){ # only keeping close names
        n <- n + 1
        close <- which(distance[[j]] <= 0.25)
        
        result_distance[m:(m + length(close) - 1), 1] <- TMP$ESTABLISHMENT[j]
        result_distance[m:(m + length(close) - 1), 2] <- TMP$ESTABLISHMENT[j + which(distance[[j]] <= 0.25)]
        result_distance[m:(m + length(close) - 1), 3] <- list_state_city_zip[i]
        result_distance[m:(m + length(close) - 1), 4] <- as.numeric(distance[[j]][distance[[j]] <= 0.25])
        result_distance[m:(m + length(close) - 1), 5] <- which(distinct_company$ESTABLISHMENT %in% TMP$ESTABLISHMENT[j] & distinct_company$STATE_CITY_ZIP == list_state_city_zip[i])
        
        m <- m + length(close)
      }
    }
  }
}

result_distance <- data.frame(result_distance[1:(m-1), ]) # data.frame of all potential close names
colnames(result_distance) <- c("ESTA1", "ESTA2", "STATE_CITY_ZIP", "DISTANCE", "ID")


################# 2.2. DEEPER ANALYSIS BY WORD AND LETTER FOR CLOSE NAMES #################

# Split all company names by words or letters
Col1_word <- lapply(strsplit(as.character(result_distance$ESTA1), ' '), function(x) x[x != ' '])
Col1_letter <- lapply(strsplit(as.character(result_distance$ESTA1), ''), function(x) x[x != ' '])
Col2_word <- lapply(strsplit(as.character(result_distance$ESTA2), ' '), function(x) x[x != ' '])
Col2_letter <- lapply(strsplit(as.character(result_distance$ESTA2), ''), function(x) x[x != ' '])

# Determine closeness
result_closeness <- matrix(NA, nrow(result_distance), 9)

for(i in 1 : nrow(result_distance)){
  
  # Number of identical words
  compa_word <- intersect(Col1_word[[i]], Col2_word[[i]])
  
  # Number of identical letters (all duplicates are keeped)
  compa_letter <- rep(sort(intersect(Col1_letter[[i]], Col2_letter[[i]])),
                      pmin(table(Col1_letter[[i]][Col1_letter[[i]] %in% Col2_letter[[i]]]),
                           table(Col2_letter[[i]][Col2_letter[[i]] %in% Col1_letter[[i]]]))) 
  
  # Percentage of similitude
  result_closeness[i, 1] <- as.character(result_distance[i, 1])
  result_closeness[i, 2] <- as.character(result_distance[i, 2])
  result_closeness[i, 3] <- as.character(result_distance[i, 3])
  result_closeness[i, 4] <- round(length(compa_word) / length(Col1_word[[i]]) * 100, 4)
  result_closeness[i, 5] <- round(length(compa_word) / length(Col2_word[[i]]) * 100, 4)
  result_closeness[i, 6] <- round(length(compa_letter) / length(Col1_letter[[i]]) * 100, 4)
  result_closeness[i, 7] <- round(length(compa_letter) / length(Col2_letter[[i]]) * 100, 4)
  result_closeness[i, 8] <- as.numeric(as.character(result_distance$ID[i]))
  
  # Decision according to percentage
  if (any(as.numeric(result_closeness[i, 4:7]) == 100) & all(as.numeric(result_closeness[i, 4:7]) > 25)) {
    result_closeness[i, 9] <- 1
    
  } else if (any(as.numeric(result_closeness[i, 4:7]) == 0)) {
    result_closeness[i, 9] <- 0
      
  } else if (any(as.numeric(result_closeness[i, 6:7]) > 80)) {
    
    if (all(as.numeric(result_closeness[i, 6:7]) > 80) || all(as.numeric(result_closeness[i, 4:5]) > 50)) {
      result_closeness[i, 9] <- 1
    } else {
      result_closeness[i, 9] <- 0
    }
  } else {
    result_closeness[i, 9] <- 0
  }
}

result_closeness <- data.frame(result_closeness)
result_closeness[ , 4:9] <- apply(result_closeness[ , 4:9], 2, as.numeric)
colnames(result_closeness) <- c("ESTA1", "ESTA2", "STATE_CITY_ZIP", "W1", "W2", "L1", "L2", "ID", "KEEP")


############################ 2.3. CREATION OF THE 1ST INDEX ###############################

# Selection of all companies with close names to merge
company_to_merge <- result_closeness[result_closeness$KEEP == 1, ]

# Same data frame but formatted to create first index
company_not_indexable <- unique(data.frame(ESTABLISHMENT = c(as.character(company_to_merge$ESTA1), as.character(company_to_merge$ESTA2)),
                                           STATE_CITY_ZIP = c(as.character(company_to_merge$STATE_CITY_ZIP), as.character(company_to_merge$STATE_CITY_ZIP))))

# Creation of the first index by DIFFERENCE with all names needed to be merged
CORRESP_INDEX <- data.frame(distinct_company[!paste0(distinct_company$ESTABLISHMENT,'-',distinct_company$STATE_CITY_ZIP) 
                                             %in% paste0(company_not_indexable$ESTABLISHMENT,'-',company_not_indexable$STATE_CITY_ZIP) ,])
CORRESP_INDEX$INDEX <- paste0(CORRESP_INDEX$STATE.1, '-', CORRESP_INDEX$ZIP, '-', 1:nrow(CORRESP_INDEX)) # INDEX = STATE - ZIP - #'random' Number
CORRESP_INDEX <- CORRESP_INDEX[, c("ESTABLISHMENT", "STATE_CITY_ZIP", "INDEX")]


############################# 2.4. MERGE OF ALL CLOSE NAMES ###############################

list_state_city_zip2 <- unique(as.character(company_to_merge$STATE_CITY_ZIP))
merged_company <- matrix(NA, (nrow(company_to_merge) * 2), 3)
m <- 0

for(i in 1:length(list_state_city_zip2)){
  
  TMP <- subset(company_to_merge, STATE_CITY_ZIP == list_state_city_zip2[i])
  ID_to_check <- unique(TMP$ID)
  
  for(j in 1:length(unique(ID_to_check))){
    
    TMP2 <- subset(TMP, ID == ID_to_check[j])
    
    merged_company_identifier = apply(merged_company[, c(1, 2)], 1, paste, collapse = "--")
    tmp2_identifier1 = apply(TMP2[, c("ESTA1", "STATE_CITY_ZIP")], 1, paste, collapse = "--")
    tmp2_identifier2 = apply(TMP2[, c("ESTA2", "STATE_CITY_ZIP")], 1, paste, collapse = "--")
    
    if(!unique(tmp2_identifier1) %in% merged_company_identifier){ # Test if A is not in the list yet
      
      if(!any(tmp2_identifier2 %in% merged_company_identifier)){ # Test if Bs are not in the list yet
        m <- m + 1
        
        merged_company[m, 1] <- unique(as.character(TMP2$ESTA1))
        merged_company[m, 2] <- list_state_city_zip2[i]  
        merged_company[m, 3] <- m
        
        to_add <- as.character(TMP2[!tmp2_identifier2 %in% merged_company_identifier, "ESTA2"])
        
        if(length(to_add) > 0){
          
          merged_company[(m+1):(m+length(to_add)), 1] <- to_add
          merged_company[(m+1):(m+length(to_add)), 2] <- list_state_city_zip2[i]  
          merged_company[(m+1):(m+length(to_add)), 3] <- m
          
          m <- m + length(to_add)
        }
      } else { # A not in the list but Bs are
        
        to_add <- unique(c(as.character(TMP2$ESTA1), as.character(TMP2[!tmp2_identifier2 %in% merged_company_identifier, "ESTA2"])))
        recup_m <- unique(merged_company[which(merged_company_identifier %in% tmp2_identifier2), 3])
        
        merged_company[(m+1):(m+length(to_add)), 1] <- to_add
        merged_company[(m+1):(m+length(to_add)), 2] <- list_state_city_zip2[i] 
        merged_company[(m+1):(m+length(to_add)), 3] <- unique(merged_company[which(merged_company[,3] %in% recup_m[length(recup_m)]), 3])
        
        m <- m + length(to_add)
      }
    } else { # A already exists so add Bs
      
      if(!all(tmp2_identifier2 %in% merged_company_identifier)){
        
        to_add <- as.character(TMP2[!tmp2_identifier2 %in% merged_company_identifier, "ESTA2"])
        
        merged_company[(m+1):(m+length(to_add)), 1] <- to_add
        merged_company[(m+1):(m+length(to_add)), 2] <- list_state_city_zip2[i] 
        recup_m <- unique(merged_company[which(merged_company_identifier %in% tmp2_identifier1), 3])
        merged_company[(m+1):(m+length(to_add)), 3] <- unique(merged_company[which(merged_company[,3] %in% recup_m[length(recup_m)]), 3])
        
        m <- m + length(to_add)
      }
    }
  } # end j
} # end i

merged_company <- data.frame(merged_company[1:m, ], stringsAsFactors = FALSE)
colnames(merged_company) <- c("ESTABLISHMENT", "STATE_CITY_ZIP", "INDEX")


########################### 2.5. CREATION OF THE FINAL INDEX ##############################

# Number in the index continues the list in the first index
merged_company$INDEX <- paste0(substring(merged_company$STATE_CITY_ZIP, 1, 2), '-', 
                               substring(merged_company$STATE_CITY_ZIP, nchar(as.character(merged_company$STATE_CITY_ZIP))-4), '-', 
                               rep((nrow(CORRESP_INDEX)+1):(nrow(CORRESP_INDEX) + length(unique(merged_company$INDEX))), as.vector(table(merged_company$INDEX))))


# Merge of the first and second index
CORRESP_INDEX <- rbind(CORRESP_INDEX, merged_company)

# Associate the created index to the company in the database
ID_for_match <- match(paste0(IMIS$ESTABLISHMENT, '-', IMIS$STATE_CITY_ZIP), 
                      paste0(CORRESP_INDEX$ESTABLISHMENT, '-', CORRESP_INDEX$STATE_CITY_ZIP))
IMIS$COMPANY_INDEX <- CORRESP_INDEX[ID_for_match, 'INDEX']


##################################### DATA EXPORT #########################################

# Change variable names back
colnames(IMIS)[var_indices] <- var_initial_names

# Save the data frame in a specific folder
tmp_dir = "./tmp/"
dir.create(tmp_dir, showWarnings = FALSE)
saveRDS(IMIS, paste0(tmp_dir, "USIS_data.RDS"))
