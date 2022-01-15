# Clear
rm(list = ls())
current_working_dir <-
  dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_working_dir)

# Libraries
libraries = c(
  "shiny","tidyverse","readr","plotly","shinydashoard","rsconnect","rvest",
  "data.table","BatchGetSymbols","dplyr","googlesheets4","DT","tableHTML",
  "qdapRegex","quantmod","shinythemes","stringi","xlsx","xts","stringr",
  "forcats","lubridate","PerformanceAnalytics","forecast","tseries","fGarch",
  "rugarch","tsfknn","MLmetrics", "finreportr", "devtools", "XBRL", "readxl",
  "MASS", "leaps", "caret", "MuMIn", "openxlsx")
suppressWarnings(lapply(libraries, require, character.only = TRUE))

# Full-model examination
source("Full Model Results.R")
source("Reporting.R")
report_all_models()

# Focused model selection
selected.models <-  c(1:10)
source("Selected Model Results.R")
source("Reporting.R")
report_selected_models()
