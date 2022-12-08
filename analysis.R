library(astsa)

data = read.table(text = gsub(",", "\t", readLines("Monero_TSA.csv")))
data1 = as.numeric(data$V2)
data1 = rev(data1[2:(length(data1))])

data1 = as.ts(data1, frequency=1)
print(data1)

#### spectral analysis
spectrum(data1,log="no",spans=c(3,3)) 
# spectrum(data1,method="ar",add=T,lty=2) 
# legend("topright",c("nonparametric","AR"),lty=c(1,2)) 

#### sarima analysis
sarima(data1, 3, 2, 1)

#### forecasting
# regr = arima(data1, order=c(11, 1, 2))
fore = sarima.for(data1, n.ahead=24, p=11, d=1, q=2, gg=TRUE, col=4, main='arf')
# fore = predict(regr, n.ahead=24)
ts.plot(data1, fore$pred, xlim=c(1,180 + 24), ylab="Return")
U = fore$pred+fore$se;  L = fore$pred-fore$se
xx = c(time(U), rev(time(U)));  yy = c(L, rev(U))
polygon(xx, yy, border = 8, col = gray(.6, alpha = .2))
lines(fore$pred, type="p", col=2)
