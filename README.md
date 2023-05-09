# time-series-analysis-with-R
Forecasting S&amp;P500 with Time Series Analysis - ARIMA Modelling in Rstudio

•	Examine your data
o	Plot the data and examine its patterns and irregularities
o	Clean up any outliers or missing values if needed
o	tsclean() is a convenient method for outlier removal and inputting missing values
o	Take a logarithm of a series to help stabilize a strong growth trend
 
•	Decompose your data
o	Does the series appear to have trends or seasonality?
o	Use decompose() or stl() to examine and possibly remove components of the series
 
•	Stationarity
o	Is the series stationary?
o	Use adf.test(), ACF, PACF plots to determine order of differencing needed
 
•	Autocorrelations and choosing model order
o	Choose order of the ARIMA by examining ACF and PACF plots
 
•	Fit an ARIMA model

•	Evaluate and iterate
o	Check residuals, which should have no patterns and be normally distributed
o	If there are visible patterns or bias, plot ACF/PACF. Are any additional order parameters needed?
o	Refit model if needed. Compare model errors and fit criteria such as AIC or BIC.
o	Calculate forecast using the chosen model
