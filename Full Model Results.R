# Input Model Configuration
config <- "model_configuration.xlsx"

# Load Data
dv.data <- data.table(read_xlsx(config, "DV"))
iv.data <- data.table(read_xlsx(config,"IV"))
config.data <- data.table(read_xlsx(config,"Configure"))

# Date Cleaning
dv.data$Time <- as.Date(dv.data$Time)
iv.data$Time <- as.Date(iv.data$Time)

start.date <- as.Date(config.data$Start_Date[1])
end.date <- as.Date(config.data$End_Date[1])

dv.data <- dv.data[!dv.data$Time < start.date & !dv.data$Time > end.date]
dv.data <- dv.data[dv.data$Ticker == na.omit(config.data$Ticker)]
dv.data <- dv.data[dv.data$DV == na.omit(config.data$DV)] 

ifelse(start.date < min(dv.data$Time), 
                     start.date <- min(dv.data$Time), 
                     start.date <- start.date)

iv.select <- iv.data[iv.data$Ticker == na.omit(config.data$Ticker) & 
                       apply(iv.data, 1, function(r) any(r %in% na.omit(config.data$IV.Internal))) |
                       apply(iv.data, 1, function(r) any(r %in% na.omit(config.data$IV.Macro)))]

iv.select <- iv.select[!iv.select$Time < start.date & !iv.select$Time > end.date]

iv.model.data <- split(iv.select, iv.select$IV)
iv.names <- na.omit(c(config.data$IV.Internal, config.data$IV.Macro))

iv.model.data.x <- c()
for (i in iv.names){
  iv.value <- as.numeric(iv.model.data[[i]]$Value)
  iv.model.data.x <- cbind(iv.value, iv.model.data.x)
}

iv <- data.table(iv.model.data.x)
colnames(iv) <- rev(iv.names)

model.data <- data.frame(DV = dv.data$Value, iv)
model.data <- model.data[ , apply(model.data, 2, function(x) !any(is.na(x)))] #Remove any IV's containing NA's
export.model.data <- data.frame(Time = dv.data$Time, model.data)
model.data.ts <- ts(model.data, start = c(year(start.date), quarter(start.date)), 
                    end = c(year(end.date), quarter(end.date)), frequency = 4)

# Model Selection - run DV against all IVs
full.model <- lm(DV~., data = model.data, na.action = "na.fail")

# Run all possible variations of models, ranking by AIC
model.combinations <- dredge(full.model, m.lim = c(1,3), extra = list("*" = function(x) { s <- summary(x)
c(Rsq = s$r.squared, adjRsq = s$adj.r.squared, F = s$fstatistic[[1]])}))


# Prepare for focused selection / reporting
dredge.model <- get.models(model.combinations, subset = TRUE)[[1]]
dredge.export <- data.frame(model.combinations)
dredge.export$delta <- NULL
dredge.export$weight <- NULL
names(dredge.export)[names(dredge.export) == "X.Intercept."] <- "Intercept"
names(dredge.export)[names(dredge.export) == "X..Rsq"] <- "R-Sq."
names(dredge.export)[names(dredge.export) == "X..adjRsq"] <- "Adj. R-Sq."
names(dredge.export)[names(dredge.export) == "X..F"] <- "F"
dredge.export <- cbind("#" = seq(1,nrow(dredge.export)),dredge.export)

export.model.data <- data.frame(export.model.data)
export.forecast <- data.frame(Time = export.model.data$Time, DV = export.model.data$DV, 
                              Fit = fitted.values(dredge.model))

MAPE = MAPE(export.forecast$Fit, export.forecast$DV)
MPE = mean((export.forecast$Fit - export.forecast$DV)/(abs(export.forecast$DV)))
error <- data.frame(MAPE = MAPE, MPE = MPE)

summary = summary(dredge.model)
export.model.summary <- data.frame(summary$coefficients)
export.model.summary <- cbind(Variable = rownames(export.model.summary), export.model.summary)
names(export.model.summary) <- c("Variable","Estimate", "Std. Error", "t-value", "p-value")
adj.rsq <- summary$adj.r.squared
rsq <- summary$r.squared
export.rsq <- data.frame(adj.rsq, rsq)

