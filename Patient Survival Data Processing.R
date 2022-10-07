library(stringr)
library(data.table)
library(dplyr)
library(ggplot2)
library(reshape2)
library(plotly)
library(hrbrthemes)
library(tidyverse)
library(heatmaply)
library(factoextra)

patient_data <- read.csv('Patient Survival.csv', na.strings = "", stringsAsFactors = T) # Loading data via CSV file

str(patient_data) # Visualizing the data structure

namedCounts <- sapply(patient_data, function(x) sum(is.na(x)))
namedCounts <- namedCounts[namedCounts>0]
print(paste0(names(namedCounts)," :",unname(namedCounts))) # Finding rows having NA values with NA Count

dim(patient_data) # checking dimension of data-frame

columns_to_delete <- c('encounter_id', 'patient_id', 'icu_admit_source', 'icu_id', 'icu_stay_type', 'icu_type', 'X') 
patient_data <- patient_data[, ! names(patient_data) %in% columns_to_delete, drop = F] # Removing irrelevant columns

dim(patient_data) # checking dimension again after deleting some columns

str(patient_data) # Data has character Data types!

unique(patient_data$apache_2_bodysystem) # Finite set of strings (Nominal) - can be converted to factors
unique(patient_data$apache_3j_bodysystem) # Finite set of strings (Nominal) - can be converted to factors
unique(patient_data[['gender']])
patient_data <- patient_data %>% mutate_if(is.character,as.factor) # Converting Character to Factor Data-type 

Mode <- function(x) { 
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))] # Defining a Mode function, since there's no built in Mode Function in R
}               

patient_data <- patient_data %>% mutate_if(is.numeric, funs(replace(.,is.na(.), median(., na.rm = TRUE)))) %>%
                mutate_if(is.factor, funs(replace(.,is.na(.), Mode(na.omit(.))))) # replacing NA values with median for numeric variables & mode for factor variables

col_to_convert <- c()
for(name in names(patient_data)){              # Finding relevant columns to convert to Factor
  if(length(unique(patient_data[[name]]))<10){
    col_to_convert <- append(col_to_convert, name)}
  else next
  }

patient_data[col_to_convert] <- lapply(patient_data[col_to_convert], factor) # Converting those columns to Factor

patient_data_table  <- copy(patient_data) # Copy data for 

setDT(patient_data_table) # setting the df as data table, we will use this for data manipulation

deaths_vs_age <- patient_data_table[,sum(as.numeric(hospital_death)), by=c('age', 'gender')] # Grouping Deaths by AGE
names(deaths_vs_age) <- c('Age', 'Gender', 'Deaths')

View(deaths_vs_age[deaths>2000]) # At 65 Age, deaths are significantly high, coincidence?

ggplot(deaths_vs_age, aes(x = Age, y = Deaths)) + geom_area(aes(fill = Gender), position = "identity", alpha = 0.3) + 
geom_line(aes(group = Gender)) + theme(legend.title = element_blank()) + labs(x = "Age", y = "Deaths") +
  scale_x_continuous(breaks = seq(0, 90, 10), limits = c(0, 90)) + 
  scale_y_continuous(breaks = seq(0, 4000, 800), limits = c(0,4000)) 
  theme_minimal()   # Visualizing the Deaths vs Age and Gender Influence
  
ggplot(patient_data_table, aes(apache_2_bodysystem,
                   fill = apache_2_bodysystem)) +
  geom_bar() + scale_x_discrete(guide = guide_axis(angle = 90)) # Patient Diagnosis results


ggplot(patient_data_table, aes(apache_3j_bodysystem,
                               fill = apache_3j_bodysystem)) +
  geom_bar() + scale_x_discrete(guide = guide_axis(angle = 90)) # Patient Diagnosis results

num_cols <- unlist(lapply(patient_data, is.numeric)) # Identify numeric columns

corr_mat <- round(cor(patient_data[num_cols]),2)
melted_corr_mat <- melt(corr_mat)
ggplot(data = melted_corr_mat, aes(x=Var1, y=Var2,
                                   fill=value)) + geom_tile() + scale_x_discrete(guide = guide_axis(angle = 90))

heatmaply_cor(x = cor(cor(patient_data[num_cols])), xlab = "Features", ylab = "Features", k_col = 2, k_row = 2)


patient_data[num_cols]

res.pca <- prcomp(patient_data[num_cols], scale = TRUE) # Applying PCA to reduce the dimensions

fviz_eig(res.pca) # scree plot

summary(res.pca)

var_explained = res.pca$sdev^2 / sum(res.pca$sdev^2) #calculate total variance explained by each principal component

qplot(c(1:20), var_explained[1:20]) +  # First 20 PCs are covering 85% of the total variance 
  geom_line() + 
  xlab("Principal Component") + 
  ylab("Variance Explained") +
  ggtitle("Scree Plot") +
  ylim(0, 1)                   
