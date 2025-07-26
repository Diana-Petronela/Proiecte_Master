#[1]
install.packages("ranger")
install.packages("tidymodels")
install.packages("vip")
install.packages("broom")

#[2]
install.packages("tidyverse")
library(tidyverse)
library(tidymodels)
library(ggplot2)
library(dplyr)
library(gridExtra)  # Pentru combinarea mai multor grafice
library(caret)      # Pentru machine learning și tuning
library(data.table) # (opțional, pentru citire rapidă)


# Exploratory Data Analysis
#[3]
customer_travel <- read_csv("Customertravel.csv")

#[4]
glimpse(customer_travel); head(customer_travel) #examina rapid structura și un eșantion din setul de date

#[5]
sapply(customer_travel, function(x) sum(is.na(x))) #verifica dacă există valori lipsă (NA) în fiecare coloană, ceea ce este esențial
                                                   #pentru curățarea și pregătirea datelor înainte de a construi un model.



#[6]Evaluarea distribuției variabilelor numerice și distribuția relativă a variabilei Target
skewness <- function(x) mean((x - mean(x))^3) / sd(x)^3

customer_travel %>% 
  summarise(Age_Skew = skewness(Age), Services_Med = median(ServicesOpted))

table(customer_travel$Target) / nrow(customer_travel)

#[7]
install.packages("ggplot2")


# 2.Data visualization (ggplot2)
# 2.1.Single nominal - Se cere crearea unui Stacked  bar plot cu AccountSyncedToSocialMedia si Target pentu a analiza distributia 
# comportamentului de churn (daca clientul paraseste compania sau nu) in functie de sincronizarea continutului cu retelele sociale.

#[8]
  ggplot(customer_travel, aes(x = AccountSyncedToSocialMedia, fill = as.factor(Target))) +
  geom_bar(position = "stack") +
  labs(title = "Social Media Sync by Target", x = "Account Synced To Social Media", y = "Frequency") +
  theme_minimal()
 
# 2.2 Single numric - Se cer doua histohrame pentru Age si ServiceOpted oferind o privire generală asupra distribuțiilor variabilelor numerice
# Majoritatea clienților sunt într-o anumită grupă de vârstă.
# Care este numărul tipic de servicii pe care utilizatorii le aleg.

#[9]
  ggplot(customer_travel, aes(x = Age)) +
  geom_histogram(binwidth = 5, fill = "skyblue", color = "black") +
  labs(title = "Distribuția vârstei clienților", x = "Vârsta", y = "Frecvență")


#[10]
  ggplot(customer_travel, aes(x = ServicesOpted)) +
  geom_histogram(binwidth = 1, fill = "lightgreen", color = "black") +
  labs(title = "Distribuția serviciilor opționate", x = "Numărul de servicii opționate", y = "Frecvență")
  
# 2.3 2 sau 3 variabile - Se cere crearea unui Scatter plot pentru Age vs. ServiceOpted grupate dupa BookedHotelOrNot////Se cere să creezi un scatter plot (grafice de tip punct)
# pentru variabilele Age și ServicesOpted, iar punctele să fie colorate în funcție de valoarea variabilei BookedHotelOrNot (adică dacă clientul a rezervat un hotel sau nu).

#[11]
  ggplot(customer_travel, aes(x = Age, y = ServicesOpted, color = BookedHotelOrNot)) +
  geom_point() +
  labs(title = "Scatter plot: Vârsta vs Serviciile opționate, grupate după BookedHotelOrNot",
       x = "Vârsta", 
       y = "Numărul de servicii opționate") +
  theme_minimal()
  
# 2.4. Multi-figure - Se cere crearea unui histogramă pentru variabila ServicesOpted, dar împărțită (faceted) în funcție de Target (adică dacă utilizatorul a părăsit compania sau nu).

#[12]
 ggplot(customer_travel, aes(x = ServicesOpted)) +
  geom_histogram(binwidth = 1, fill = "skyblue", color = "black", alpha = 0.7) +
  facet_wrap(~ Target) +
  labs(title = "Distribuția serviciilor opționate, grupate după Target", x = "Numărul de servicii opționate", y = "Frecvență") +
  theme_minimal()

# 3. Machine Learning - cerința presupune utilizarea k-fold cross-validation pe un model Random Forest pentru a evalua performanța acestuia utilizând mai multe metrici, cum ar fi accuracy,
#   brier_class, și roc_auc.

#[13]
install.packages("caret")

#[14]
library(caret)

#[15]
install.packages("kernlab")

#[16]
library(kernlab)

#[17]
rf_model <- rand_forest(trees = 100, mode = "classification") %>%
  set_engine("ranger")

travel_recipe <- recipe(Target ~ ., data = travel_train) %>%
  step_dummy(all_nominal(), -all_outcomes())

rf_workflow <- workflow() %>%
  add_recipe(travel_recipe) %>%
  add_model(rf_model)

rf_cv <- fit_resamples(rf_workflow, resamples = vfold_cv(travel_train, v = 5))

collect_metrics(rf_cv)

#[18]
library(ggplot2)
library(tidyr)

# Se presupune că 'rf_cv' conține rezultatele tale din validarea încrucișată
# Convertim rezultatele într-un format long pentru a le vizualiza mai ușor
rf_cv_metrics_long <- rf_cv %>%
  collect_metrics() %>%
  pivot_longer(cols = -c(.metric, .estimator, .config), names_to = "Metric", values_to = "Value")

# Creăm un bar plot pentru a vizualiza metricile
ggplot(rf_cv_metrics_long, aes(x = .metric, y = Value, fill = .metric)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Performanța modelului Random Forest (k-fold cross-validation)",
       x = "Metrică",
       y = "Valoare") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotim etichetele pentru claritate