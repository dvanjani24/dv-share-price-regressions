
model.output <- get.models(model.combinations, subset=TRUE)[rownames(dredge.export[selected.models,])]
selected.model.summary <- dredge.export[selected.models,]

get_pval<-c()
for (i in 1:length(selected.models)){
  res = summary(model.output[[i]])$coefficients[,4]  
  get_pval = rbind(get_pval,res)
}
get_pval <- data.frame(get_pval)[,-c(1)]
colnames(get_pval) <- paste("P_Val", colnames(get_pval), sep = ".")

get_errors <- c()
  for (i in 1:length(selected.models)){
    MAPE = MAPE(fitted.values(model.output[[i]]), export.forecast$DV)
    MPE = mean((fitted.values(model.output[[i]]) - export.forecast$DV)/(abs(export.forecast$DV)))
    error <- cbind(MAPE, MPE)
    get_errors <- rbind(get_errors, error)
  }

# selected.model.summary <- selected.model.summary[,-c(which(names(selected.model.summary) == c("F", "df")),
#                            which(names(selected.model.summary) == c("logLik", "AICc")))]
selected.model.summary <- cbind(selected.model.summary, get_pval, get_errors)
selected.model.summary <- selected.model.summary[,!apply(selected.model.summary, 2, function(var) length(unique(var)) == 1)]

fitted <- c()
for (i in 1:length(selected.models)){
  get.fitted <- fitted.values(model.output[[i]])
  fitted <- cbind(fitted, get.fitted)
}

get_fit_dat<-c()
  for(i in 1:length(selected.models)){
    fit<-fitted[,i]
    get_fit_dat<-cbind(fit,get_fit_dat)
  }
for (i in 1:length(colnames(get_fit_dat))){
  colnames(get_fit_dat)[i] <- paste0("Fit_",selected.model.summary$`#`[i],"")
}

select.fit <- data.frame(Time = as.Date(export.forecast$Time),DV = export.forecast$DV, get_fit_dat)

