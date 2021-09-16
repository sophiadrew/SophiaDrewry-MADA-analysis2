###############################
# analysis script
#
#this script loads the processed, cleaned data, does a simple analysis
#and saves the results to the results folder

#load needed packages. make sure they are installed.
library(ggplot2) #for plotting
library(broom) #for cleaning up output from lm()
library(here) #for data loading/saving

#path to data
#note the use of the here() package and not absolute paths
data_location <- here::here("data","processed_data","processedFINAL.rds")

#load data. 
mydata <- readRDS(data_location)

######################################
#Data exploration/description
######################################


#summarize data 
mysummary = summary(mydata)

#look at summary
print(mysummary)

#do the same, but with a bit of trickery to get things into the 
#shape of a data frame (for easier saving/showing in manuscript)
summary_df = data.frame(do.call(cbind, lapply(mydata, summary)))

#save data frame table to file for later use in manuscript
summarytable_file = here("results", "summarytable.rds")
saveRDS(summary_df, file = summarytable_file)

# after loading the processed data, we have four variables: week, hepA, hepB, and hepC.
# Our goal is to compare the cases of hepA, hepB, and hepC cumulatively and over time



#reshape data by shifting columns hepA, hepB, hepC, to rows
tidydata <- tidyr::gather(mydata, key = virus, value = cases, 3:5)

# First, let's make a boxplot to compare the prevalence of each viral strain
p1 <- tidydata %>% ggplot(aes(x = virus, y = cases)) + geom_boxplot()

# look at figure
plot(p1)

#make a scatterplot of data

p2 <- tidydata %>% ggplot(aes(x = week, y = cases)) + geom_point(aes(color = virus))

#look at figure
plot(p2)

#fit a model to the scatterplot
p3 <- tidydata %>% ggplot(aes(x = week, y = cases)) + geom_point(aes(color = virus)) + geom_smooth(method=lm, aes(color = virus))

#look at figure
plot(p3)

#view a cleaner plot with the line of best fit and no individual scatterplot points
p4 <- tidydata %>% ggplot(aes(x = week, y = cases)) + geom_smooth(method=lm, aes(color = virus))

#look at figure
plot(p4)

#save figure
figure_file = here("results","resultfigure.png")
ggsave(filename = figure_file, plot=p1) 

figure_file2 = here("results", "resultfigure2.png")
ggsave(filename = figure_file2, plot=p2)

figure_file3 = here("results", "resultfigure3.png")
ggsave(filename = figure_file3, plot=p3)

figure_file4 = here("results", "resultfigure4.png")
ggsave(filename = figure_file4, plot=p4)
  