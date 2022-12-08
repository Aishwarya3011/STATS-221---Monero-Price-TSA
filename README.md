# STATS-221---Monero-Price-TSA
This repository contains the python notebook and R files for STATS 221 - Monero Price TSA

The analysis is summarized here. Figure references are from the report.

1 Stationarity

A stationary time series is a process for which the statistical properties or moments (e.g., mean and
variance) do not vary in time. A time series is stationary if it does not have any trends or seasonal
effects. If it does have a trend and is not stationary, it needs to be detrended before further analysis.
Generally speaking, for predictive or forecasting purposes, it is important to assume independence
between data points.
For my analysis, I used two approaches for stationarity analysis.
1. Splitting the dataset into two equal groups and comparing their respective means and vari-
ances. Figure 2 shows how the variance varies widely across the two groups. This suggests
the possibility of non-stationarity at the most fundamental level of analysis.
2. To solidify the stationarity hypothesis, I used the Augmented Dickey-Fuller Test to check
the P-value. The ADF test statistic was -2.713149 and P-value is 0.071790. This P-value
is pretty close to the threshold for null hypothesis which is 0.05. However, this closeness
does not approximate to statistical significance. Therefore, it is safe to say that the time
series is non-stationary as the p-value is not small enough to reject the null hypothesis.


2 Data Cleanup

There are some outliers in the data which represent the natural variation. For the most accurate
statistical representation of the data, it is ideal to eliminate outliers. However, removing outliers
tampers with the pristineness of data hence an evidently better alternative is to clip the outliers
outside some minimum and maximum bounds.
Figure 3 shows the box plot of outliers in my data. The minimum and maximum bounds are re-
spectively Q1 - 1.5*IQR and Q3 + 1.5*IQR where Q1 and Q3 have been set to the 25th and 75th
percentile of the data and IQR represents the inter-quartile range. There are around 15 outliers in
this range and they are not too extreme. Given the limited number of data points, I decided to clip
the data outside the 5th and 95th percentile. This effectively reduced the standard deviation from
18.57 to 17.08. Figure 4 and Figure 5 show the price histograms before and after the clipping.

3 ACF and PACF of data

The autocorrelation function (ACF) and partial autocorrelation function (PACF) of the time series
help analyze the ARMA model/s selection for forecasting through parameter determination.
Figure 6 shows the ACF and PACF plots of the original time series. the ACF plot shows a decaying
approximately sinusoidal pattern while the PACF plot shows a significant spike at lag 1 and none
thereafter. This appears to be an AR process.

4 Regression Curve Fitting

After establishing the non-stationarity of the time series, it is important to detrend it to make it
stationary. Regression analysis helps detrend the data by fitting a curve that best approximates it and
subtracting the differences from the original data to generate a residual series which is detrended.
I used Ordinary Least Squares (OLS) regression analysis to fit a linear curve through the series.
Then I generated the residual series which is seemingly smoother. Figure 7 and Figure 8 show the
regression curve fitting and residual series respectively. The AIC and BIC values were 1603 and
1609 respectively.

5 Spectral Analysis

After detrending the linear trend, I plotted the periodogram of the time series to identify any seasonal
patterns in the data. Figure 9 shows the periodogram of the detrended data and it appears to be pretty
smooth, indicating no seasonal trends or cycles in the data.

6 First Differencing

While regression modeling for detrending is clearly superior for linearly increasing data, it becomes
pretty wobbly when the data becomes stochastic as is the case with financial data. For such data,
there is a multi-variate dependency that requires more complex regression analysis. For preliminary
modeling, detrending followed by differencing evidently does a better job.
Figure 10 shows the first differenced series. After differencing the P-value becomes 20e-27 which
is sufficient to pass the ADF stationarity test. The mean becomes approximately 0. At this point, the
series is pretty stationary so we plot the ACF and PACF plots of the first differenced series.
Figure 11 shows the ACF and PACF plots of the first differenced series. There are no evident
spikes outside the cut-offs which makes it difficult to say anything definitively so I took the second
differences to be more conclusive.

7 Second Differencing

Figure 12 shows the second differenced series. Figure 13 shows the ACF and PACF plots of the
second differenced series. From the ACF and PACF of the second differenced TS, it can be seen
that ACF has a spike at lag 1 outside the cutoff and no lags thereafter whereas PACF has 3 lags
outside cutoff and no lags thereafter which means the model that should give the best fit should be
an ARIMA(3, 2, 1).

Results

1 Evaluation Metric

In order to select the best ARIMA model for forecasting, I used Akaike Information Criterion (AIC)
and Bayesian Information Criterion (BIC) as evaluation criteria. Figure 14 shows the results ob-
tained for different projected ARIMA models in terms of AIC and BIC values. ARIMA(3, 2, 1)
supersedes all other models in our evaluation which validates my hypothesis for model selection.

2 Selected Best Fit Model

ARIMA(3, 2, 1) was selected as the best fit model. Figure 15 shows the standardized residuals, ACF
of residuals, Normal Q-Q plot and p-values of Ljung box statistic for ARIMA(3, 2, 1). The ACF
of residuals is like white noise. The Q-Q plot indicates an almost accurate fit. The p-values in the
Ljung box statistic are pretty significant. Overall, the selected model is theoretically a good fit for
the data.

3 Forecasting

Forecasting was done on 6 months data from Apr 29, 2022 to Oct 29, 2022 leaving November out as
a test set. Here too, ARIMA(3, 2, 1) gave the best fit. Figure 16 shows the forecast. The predictions
looked promising but were entirely off when compared against the actual price data for the month
of November. 

The pink line in first figure shows the part of the actual data that was split into training and test for
forecasting. The left portion of the split is the data common between both datasets, the right portion
is the actual data for November.

The left portion of the split in second figure shows April data which may be ignored for the current
analysis. The right portion of the split shows the predicted price data for the month of November.
Clearly, the predicted data does not model the actual data. This is expected given the highly stochas-
tic and volatile nature of financial data and the plethora of factors influencing it.

