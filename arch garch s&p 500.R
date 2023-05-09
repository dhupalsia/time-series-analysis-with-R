## comparison of ARCH & GARCH

install.packages("FinTS")
library(FinTS)
library(rugarch)
library(zoo)
library(tseries)
install.packages("dynlm")
library(dynlm)
library(vars)
library(strucchange)
library(sandwich)
library(urca)
library(lmtest)
install.packages("nlWaldTest")
library(nlWaldTest)
library(broom)
library(car)
library(carData)
library(knitr)
library(ggplot2)
library(pdfetch)
library(tsbox)
library(stats)
library(vrtest)
library(forecast)

#setting theme
theme_set(theme_bw())

#importing reliance data
df<-pdfetch_YAHOO(c("^gspc"),fields = c("close"))

dfts<-ts(df,start=c(2020,3),end = c(2022,161),frequency = 365)

data.frame(dfts)

#visuals
plot.ts(df)
title("Time Series Plot of S&P 500")
hist(df,main = "Histograms of S&P 500",freq = TRUE,col = "grey")

plot.ts(diff(df),ylab="Change in S&P 500")
title("First difference of S&P 500")

#step 1: Normality Test
shapiro.test(dfts)
#null hypothesis: data is normal
#variance evaluate significant means data is not normal
#we'll use log
df1<-log(df)

#step 2: check for stationary of variance and mean
plot.ts(df1)
title("Time Series Plot of Log of S&P 500")

Auto.VR(df1)
#variance is not constant

adf.test(df1$`^gspc`,k=3)
df2<-diff(df1)
df2<-na.remove(df2)
adf.test(df2,k=2)
#series is I(1)

#step 3: determine Auto Regressive and Moving Averages components
acf.df2<-acf(df2,main="ACF of S&P 500",lag.max = 50)
pacf.df2<-pacf(df2,main="PACF of S&P 500", lag.max = 50)

# ARIMA (p,i,q) = (1,1,2)

#step 4: estimating ARIMA model
auto.arima(df1)
# ARIMA = (0,1,1)

########################################

arima<-auto.arima(df1)
forecast<-forecast(arima)
forecast
qqnorm(forecast$residuals)
summary(arima)
accuracy(arima)
plot(forecast)

##########################################

arima001<-arima(df1,order = c(0,1,1))
summary(arima001)
tsdiag(arima001)
checkresiduals(arima001)
autoplot(arima001)


arimar<-arima001$residuals
ggtsdisplay(arimar,main="S&P 500 ARIMA Residuals")


#step 5: estimate mean equation r = beta + error

sp.mean<-dynlm(arimar~1)
summary(sp.mean)


#step 6: determination of ARCH effect
ehatsq<-ts(resid(sp.mean)^2)
sp.archeffect<-dynlm(ehatsq~L(ehatsq))
summary(sp.archeffect)

#chi-square test
t<-nobs(sp.mean)
q<-length(coef(sp.archeffect))-1
rsq<-glance(sp.archeffect)[[1]]
lm<-(t-q)*rsq
alpha<-0.05
chi<-qchisq(1-alpha,q)
lm
chi


sp.archeffect1<-ArchTest(arimar,lags = 1, demean = TRUE)
sp.archeffect1

#step 7: estimating ARCH & GARCH equation

sp.arch<-garch(arimar,c(0,3),control = garch.control(maxiter = 500,grad = "numerical"))
#first item in c() is garch effect and second is arch effect

sp500arch<-summary(sp.arch)
sp500arch


volatility<-ts(2*sp.arch$fitted.values[-1,1]^2)  
plot.ts(volatility)
title("Volatility of S&P500")


