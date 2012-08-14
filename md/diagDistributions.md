Visualize univariate and bivariate distributions
=========================




TODO
-------------------------

 - link to diagCategorical, diagScatter, diagMultivariate, diagAddElements, diagBounding
 - new R 2.15.1+ `qqplot()` options `distribution` and `probs`

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car), [`hexbin`](http://cran.r-project.org/package=hexbin)


```r
wants <- c("car", "hexbin")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Histograms
-------------------------

### Histogram with absolute class frequencies
    

```r
set.seed(1.234)
x <- rnorm(200, 175, 10)
hist(x, xlab="x", ylab="N", breaks="FD")
```

![plot of chunk rerDiagDistributions01](figure/rerDiagDistributions01.png) 


### Add individual values and normal probability density function


```r
hist(x, freq=FALSE, xlab="x", ylab="relative frequency",
     breaks="FD", main="Histogram und normal PDF")
rug(jitter(x))
curve(dnorm(x, mean(x), sd(x)), lwd=2, col="blue", add=TRUE)
```

![plot of chunk rerDiagDistributions02](figure/rerDiagDistributions02.png) 


### Add estimated probability density function


```r
hist(x, freq=FALSE, xlab="x", breaks="FD",
     main="Histogram and density estimate")
lines(density(x), lwd=2, col="blue")
rug(jitter(x))
```

![plot of chunk rerDiagDistributions03](figure/rerDiagDistributions03.png) 


To compare the histograms from two groups, see `histbackback()` from package [`Hmisc`](http://cran.r-project.org/package=Hmisc).

Stem and leaf plot
-------------------------


```r
y <- rnorm(100, mean=175, sd=7)
stem(y)
```

```

  The decimal point is 1 digit(s) to the right of the |

  15 | 4
  15 | 9
  16 | 01134444
  16 | 5556777788999
  17 | 0000000011111222222222233444
  17 | 5555555667777788999999999
  18 | 001122333344
  18 | 5556778
  19 | 0112
  19 | 
  20 | 2

```


Boxplot
-------------------------


```r
Nj <- 40
P  <- 3
DV <- rnorm(P*Nj, mean=100, sd=15)
IV <- gl(P, Nj, labels=c("Control", "Group A", "Group B"))
```



```r
boxplot(DV ~ IV, ylab="Score", col=c("red", "blue", "green"),
        main="Boxplot of scores in 3 groups")
stripchart(DV ~ IV, pch=16, col="darkgray", vert=TRUE, add=TRUE)
```

![plot of chunk rerDiagDistributions04](figure/rerDiagDistributions04.png) 



```r
xC <- DV[IV == "Control"]
xA <- DV[IV == "Group A"]
boxplot(xC, xA)
```

![plot of chunk rerDiagDistributions05](figure/rerDiagDistributions05.png) 


Dotchart
-------------------------


```r
Nj  <- 5
DV1 <- rnorm(Nj, 20, 2)
DV2 <- rnorm(Nj, 25, 2)
DV  <- c(DV1, DV2)
IV  <- gl(2, Nj)
Mj  <- tapply(DV, IV, FUN=mean)
```



```r
dotchart(DV, gdata=Mj, pch=16, color=rep(c("red", "blue"), each=Nj),
         gcolor="black", labels=rep(LETTERS[1:Nj], 2), groups=IV,
		 xlab="AV", ylab="group",
         main="individual results and means from 2 groups")
```

![plot of chunk rerDiagDistributions06](figure/rerDiagDistributions06.png) 


Stripchart
-------------------------


```r
Nj   <- 25
P    <- 4
dice <- sample(1:6, P*Nj, replace=TRUE)
IV   <- gl(P, Nj)
```



```r
stripchart(dice ~ IV, xlab="Result", ylab="group", pch=1, col="blue",
           main="Dice results: 4 groups", sub="jitter-method", method="jitter")
```

![plot of chunk rerDiagDistributions07](figure/rerDiagDistributions071.png) 

```r
stripchart(dice ~ IV, xlab="Result", ylab="group", pch=16, col="red",
           main="Dice results: 4 groups", sub="stack-method", method="stack")
```

![plot of chunk rerDiagDistributions07](figure/rerDiagDistributions072.png) 


QQ-plot
-------------------------


```r
DV1 <- rnorm(200)
DV2 <- rf(200, df1=3, df2=15)
qqplot(DV1, DV2, xlab="quantile N(0, 1)", ylab="quantile F(3, 15)",
       main="Comparison of quantiles from N(0, 1) and F(3, 15)")
```

![plot of chunk rerDiagDistributions08](figure/rerDiagDistributions08.png) 



```r
height <- rnorm(100, mean=175, sd=7)
qqnorm(height)
qqline(height, col="red", lwd=2)
```

![plot of chunk rerDiagDistributions09](figure/rerDiagDistributions09.png) 


Empirical cumulative distribution function
-------------------------


```r
vec <- round(rnorm(10), 1)
Fn  <- ecdf(vec)
plot(Fn, main="Empirical cumulative distribution function")
curve(pnorm, add=TRUE, col="gray", lwd=2)
```

![plot of chunk rerDiagDistributions10](figure/rerDiagDistributions10.png) 


Joint distribution of two variables in separate groups
-------------------------

### Simulate data


```r
N  <- 200
P  <- 2
x  <- rnorm(N, 100, 15)
y  <- 0.5*x + rnorm(N, 0, 10)
IV <- gl(P, N/P, labels=LETTERS[1:P])
```


### Identify group membership by plot symbol and color


```r
plot(x, y, pch=c(4, 16)[unclass(IV)], lwd=2,
     col=c("black", "blue")[unclass(IV)],
     main="Joint distribution per group")
legend(x="topleft", legend=c("group A", "group B"),
       pch=c(4, 16), col=c("black", "blue"))
```

![plot of chunk rerDiagDistributions11](figure/rerDiagDistributions11.png) 


### Add distribution ellipse

Pooled groups


```r
library(car)
dataEllipse(x, y, xlab="x", ylab="y", asp=1, levels=0.5, lwd=2, center.pch=16,
            col="blue", main="Joint distribution of two variables")
legend(x="bottomright", legend=c("Data", "centroid", "distribution ellipse"),
       pch=c(1, 16, NA), lty=c(NA, NA, 1), col=c("black", "blue", "blue"))
```

![plot of chunk rerDiagDistributions12](figure/rerDiagDistributions12.png) 


Joint distribution of two variables with many observations
-------------------------

### Using transparency


```r
N  <- 5000
xx <- rnorm(N, 100, 15)
yy <- 0.4*xx + rnorm(N, 0, 10)
plot(xx, yy, pch=16, col=rgb(0, 0, 1, 0.3))
```

![plot of chunk rerDiagDistributions13](figure/rerDiagDistributions13.png) 


### Smooth scatter plot

Based on a 2-D kernel density estimate


```r
smoothScatter(xx, yy, bandwidth=4)
```

![plot of chunk rerDiagDistributions14](figure/rerDiagDistributions14.png) 


### Hexagonal 2-D binning


```r
library(hexbin)
res <- hexbin(xx, yy, xbins=20)
plot(res)
```

![plot of chunk rerDiagDistributions15](figure/rerDiagDistributions15.png) 

```r
summary(res)
```

```
Length  Class   Mode 
     1 hexbin     S4 
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))
try(detach(package:hexbin))
try(detach(package:grid))
try(detach(package:lattice))
```


Get this post from github
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/diagDistributions.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/diagDistributions.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/diagDistributions.R) - [all posts](https://github.com/dwoll/RExRepos)
