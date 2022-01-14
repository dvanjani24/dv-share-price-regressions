# Create Output for Model Selection.R 

report_all_models <- function(){
wb <- createWorkbook()

addWorksheet(wb, "Model Selection")
writeData(wb, "Model Selection", dredge.export)
writeData(wb, "Model Selection", export.rsq, startRow = nrow(dredge.export) + 4)
writeData(wb, "Model Selection", export.model.summary, startRow = nrow(dredge.export) + 7)

addWorksheet(wb, "Model Data")
writeData(wb, "Model Data", export.model.data)

saveWorkbook(wb, paste0("Model Results_", na.omit(config.data$Ticker),".xlsx", sep=""), overwrite = TRUE)
}

# Create Output for Model Selection.R 
report_selected_models <- function(){
  wb <- createWorkbook()
  
  addWorksheet(wb, "Model Forecast")
  writeData(wb, "Model Forecast", select.fit)
  
  addWorksheet(wb, "Candidate Models")
  writeData(wb, "Candidate Models", selected.model.summary)
  
  addWorksheet(wb, "Full Model Selection")
  writeData(wb, "Full Model Selection", dredge.export)
  writeData(wb, "Full Model Selection", export.rsq, startRow = nrow(dredge.export) + 4)
  writeData(wb, "Full Model Selection", export.model.summary, startRow = nrow(dredge.export) + 7)
  
  addWorksheet(wb, "Model Data")
  writeData(wb, "Model Data", export.model.data)

  saveWorkbook(wb, paste0("Model Results_", na.omit(config.data$Ticker),".xlsx", sep=""), overwrite = TRUE)
}
