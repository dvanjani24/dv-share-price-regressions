<img align = "right" width="75" alt="logo" src="https://user-images.githubusercontent.com/97678601/149636901-fb79e698-7c0e-47fb-bb88-033785485fc7.png"> 

# DV Share Price Predictor
This personal project explores using multivariate regressions to predict public stock share prices. The indepdenent variables covered include various macroeconomic and internal company-level financial metrics. 

As an avid investor and statistics geek, I enjoy exploring quantitative methods that can support my investment thesis. That said, I thoroughly appreciate that succesful investing is not as straightforward as crunching numbers, as qualitative factors like market sentiment, news flow, earnings surprises/disappointments, etc. can make or break an investment. An investment thesis should be a function of various factors, and each factor is just that, one factor.

The models are calibrated using quarterly data, as generally internal company-level metrics (e.g., earnings) are reported quarterly through earnings releases. Based on this, any inferences made on future stock performance should be aligned to the frequency of the historical data. Therefore, using regressions such as the ones explored in this project to predict day-to-day moves in stock prices would not make much sense. But for longer term investors, regressions against key macro/internal variables can certainly support the long-run trend of a stock's share price. 

## Functionality:
1. The program consumes a model configuration template containing dependent variable (i.e., share price) and independent variable data (i.e., macro/internal variables). Below is a subset of the independent variables considered:

Macroeconomic variables  | Internal company-level variables
------------- | -------------
Federal Funds Rate | Earnings per Share
10Y vs. 2Y Treasury Yield Spread  | Current Ratio
Yuan/USD | Quick Ratio
GDP | Debt to Equity Ratio
CPI | Total Assets
M2 Money Supply | Dividend Yield
Federal Reserve Balance Sheet | Tax Rate
M1 Money Supply | Revenue
Industrial Production Index | Gross Profit
Total US Bank Assets | Market Cap

2. Multivariate regressions for all possible permutations of independent variables while minimizing Akaike information criterion (AIC) are calibrated.

3. An excel report with model results is automatically generated. The report contains four tabs: 
  - Model Data: All the data used to calibrate all models
  - Full Model Selection: Coefficient estimates, R-sq values, F-score, df, log-likelihood, and AIC for all possible model permutations, sorted from lowest to highest AIC
  - Candidate Models: For the ten highest ranked models (by AIC), additional statistical measures are presented, including p values, MAPE, and MPE
  - Model Forecast: Shows the fitted values across the top 10 models compared to the historical dependent variable data

## Input Files and Libraries:
The only input file required is "model_configuration.xlsx". This input file is key to the program as it will contain all the required data to calibrate the regressions. A limitation of using an input file is that it will require a reasonable amount of manual data sourcing to gather the independent/dependent variable data. However, a benefit is that users can tailor their models more closely by deciding which variables are the most intuitive to include in the model selection analysis. 

Libraries:
  - readxl
  - openxlsx
  - lubridate
  - data.table
  - dplyr
  - xts

## Future Enhancements
A key limitation of this program is that it relies quite heavily on manual data sourcing. As a future enhancement, I can further automate the data sourcing of the model variables and eliminate the need for a model configuration template.
