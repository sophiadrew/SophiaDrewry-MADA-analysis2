###############################
# processing script
#
#this script loads the raw data, processes and cleans it 
#and saves it as Rds file in the processed_data folder

#load needed packages. make sure they are installed.
library(readxl) #for loading Excel files
library(dplyr) #for data processing
library(here) #to set paths

#path to data
#note the use of the here() package and not absolute paths
data_location <- here::here("data","raw_data","NNDSS Hep.csv")

#load data

rawdata <- read.csv(data_location)

#take a look at the data
dplyr::glimpse(rawdata)

# After looking at this data, I have decided I want to plot the weekly incidence of Hep A, B & C by week.
# From the glimpse(rawdata) command I can see that each column has a intiger form and character form
# I am going to create a new data frame with the variables of interest; Location, Week #, # of weekly HepA, # of weekly HepB & # of weekly HepC.

processed1 <- rawdata[c("Reporting.Area", "MMWR.Week","Hepatitis..viral..acute...type.A..Current.week", "Hepatitis..viral..acute...type.B..Current.week", "Hepatitis..viral..acute...type.C..Current.week")]

# Now to inspect
dplyr::glimpse(processed1)

# Renaming the columns
processed2 <- processed1 %>% rename(area = Reporting.Area, week =MMWR.Week, hepA = Hepatitis..viral..acute...type.A..Current.week, hepB = Hepatitis..viral..acute...type.B..Current.week, hepC = Hepatitis..viral..acute...type.C..Current.week)

# There are quite a lot of NA in the sets
# Since we know the value of NA, meaning there were no cases that week, we can turn them all into 0.
# Before turning all NA -> 0, just want to make sure there are no NA in the area or week column
colSums(is.na(processed2))

# Replace all NA with 0
processed2[is.na(processed2)] <- 0
dplyr::glimpse(processed2)

# Now lets look at the categorical variable
unique(processed1$Reporting.Area)

# For analyzation purposes, I only want to look at cases in the South
# Subset data to only show information from the south, aka "S. ATLANTIC"

processedFINAL <- subset(processed2, area == "S. ATLANTIC")


# location to save file
"~/Documents/School/Fall 2021/MADA/SophiaDrewry-MADA-analysis2/data/processed_data/" <- here::here("data","processed_data","processedFINAL.rds")

saveRDS(processedFINAL, file = data_location)


