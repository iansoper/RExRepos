Diagrams for multivariate data
=========================




TODO
-------------------------

 - make [`rgl`](http://cran.r-project.org/package=rgl) snapshot work with `knitr`

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car), [`ellipse`](http://cran.r-project.org/package=ellipse), [`lattice`](http://cran.r-project.org/package=lattice), [`mvtnorm`](http://cran.r-project.org/package=mvtnorm), [`rgl`](http://cran.r-project.org/package=rgl)


```r
wants <- c("car", "ellipse", "lattice", "mvtnorm", "rgl")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


3-D data
-------------------------

### Contour plots
    

```r
mu    <- c(1, 3)
sigma <- matrix(c(1, 0.6, 0.6, 1), nrow=2)
rng   <- 2.5
N     <- 50
X     <- seq(mu[1]-rng*sigma[1, 1], mu[1]+rng*sigma[1, 1], length.out=N)
Y     <- seq(mu[2]-rng*sigma[2, 2], mu[2]+rng*sigma[2, 2], length.out=N)
```



```r
set.seed(1.234)
library(mvtnorm)
genZ <- function(x, y) { dmvnorm(cbind(x, y), mu, sigma) }
matZ <- outer(X, Y, FUN="genZ")
```



```r
contour(X, Y, matZ, main="Contours for 2D-normal density")
```

![plot of chunk rerDiagMultivariate01](figure/rerDiagMultivariate011.png) 

```r
filled.contour(X, Y, matZ, main="Colored contours for 2D-normal density")
```

![plot of chunk rerDiagMultivariate01](figure/rerDiagMultivariate012.png) 


Bubble plot et c.
-------------------------


```r
N      <- 10
age    <- rnorm(N, 30, 8)
sport  <- abs(-0.25*age + rnorm(N, 60, 40))
weight <- -0.3*age -0.4*sport + 100 + rnorm(N, 0, 3)
wScale <- (weight-min(weight)) * (0.8 / abs(diff(range(weight)))) + 0.2
symbols(age, sport, circles=wScale, inch=0.6, fg=NULL, bg=rainbow(N),
        main="Weight against age and sport")
```

![plot of chunk rerDiagMultivariate02](figure/rerDiagMultivariate02.png) 


See `sunflowerplot()` and `stars()` for altenative approaches.


3-D grid plot
-------------------------


```r
par(cex.main=1.4, mar=c(2, 2, 4, 2) + 0.1)
persp(X, Y, matZ, xlab="x", ylab="y", zlab="Density", theta=5, phi=35,
      main="2D-normal probability density")
```

![plot of chunk rerDiagMultivariate03](figure/rerDiagMultivariate03.png) 


Interactive 3-D scatter plot
-------------------------


```r
library(rgl)
vecX <- rep(seq(-10, 10, length.out=10), times=10)
vecY <- rep(seq(-10, 10, length.out=10),  each=10)
vecZ <- vecX*vecY
plot3d(vecX, vecY, vecZ, main="3D Scatterplot",
       col="blue", type="h", aspect=TRUE)
spheres3d(vecX, vecY, vecZ, col="red", radius=2)
grid3d(c("x", "y+", "z"))
# not shown
```



```r
demo(rgl)
example(persp3d)
# not shown
```


Conditioning plots
-------------------------


```r
Njk    <- 25
P      <- 2
Q      <- 2
IQ     <- rnorm(P*Q*Njk, mean=100, sd=15)
height <- rnorm(P*Q*Njk, mean=175, sd=7)
IV1    <- factor(rep(c("control", "treatment"), each=Q*Njk))
IV2    <- factor(rep(c("f", "m"), times=P*Njk))
myDf   <- data.frame(IV1, IV2, IQ, height)
coplot(IQ ~ height | IV1*IV2, pch=16, data=myDf)
```

![plot of chunk rerDiagMultivariate06](figure/rerDiagMultivariate06.png) 



```r
library(lattice)
res <- histogram(IQ ~ height | IV1*IV2, data=myDf,
                 main="Histograms per group")
print(res)
```

![plot of chunk rerDiagMultivariate07](figure/rerDiagMultivariate07.png) 


Scatterplot matrices
-------------------------


```r
N      <- 20
P      <- 2
IV     <- rep(c("CG", "T"), each=N/P)
age    <- sample(18:35, N, replace=TRUE)
IQ     <- round(rnorm(N, mean=rep(c(100, 115), each=N/P), sd=15))
rating <- round(0.4*IQ - 30 + rnorm(N, 0, 10), 1)
score  <- round(-0.3*IQ + 0.7*age + rnorm(N, 0, 8), 1)
mvDf   <- data.frame(IV, age, IQ, rating, score)
```



```r
pairs(mvDf[c("age", "IQ", "rating", "score")], main="Scatter plot matrix",
      pch=16, col=c("red", "blue")[unclass(mvDf$IV)])
```

![plot of chunk rerDiagMultivariate08](figure/rerDiagMultivariate08.png) 



```r
myHist <- function(x, ...) { par(new=TRUE); hist(x, ..., main="") }
myEll  <- function(x, y, nSegments=100, rad=1, ...) {
    splLL <- split(data.frame(x, y), mvDf$IV)
    CG <- data.matrix(splLL$CG)
    TT <- data.matrix(splLL$T)

    library(car)
    dataEllipse(CG, level=0.5, col="red",  center.pch=4,
                plot.points=FALSE, add=TRUE)
    dataEllipse(TT, level=0.5, col="blue", center.pch=4,
                plot.points=FALSE, add=TRUE)
}
```



```r
pairs(mvDf[c("age", "IQ", "rating", "score")], diag.panel=myHist,
      upper.panel=myEll, main="Scatter plot matrix", pch=16,
      col=c("red", "blue")[unclass(mvDf$IV)])
```

![plot of chunk rerDiagMultivariate09](figure/rerDiagMultivariate09.png) 


Heatmap
-------------------------

Illustrating the correlation matrix of several variables.


```r
library(mvtnorm)
N <- 200
P <- 8
Q <- 2
Lambda <- matrix(round(runif(P*Q, min=-0.9, max=0.9), 1), nrow=P)
FF <- rmvnorm(N, mean=c(0, 0),   sigma=diag(Q))
E  <- rmvnorm(N, mean=rep(0, P), sigma=diag(P)*0.3)
X  <- FF %*% t(Lambda) + E
```



```r
corMat <- cor(X)
rownames(corMat) <- paste("X", 1:P, sep="")
colnames(corMat) <- paste("X", 1:P, sep="")
round(corMat, 2)
```

```
      X1    X2    X3    X4    X5    X6    X7    X8
X1  1.00  0.01  0.16  0.08  0.60  0.57  0.08 -0.38
X2  0.01  1.00 -0.76  0.64  0.56  0.51 -0.59  0.02
X3  0.16 -0.76  1.00 -0.59 -0.38 -0.35  0.52 -0.06
X4  0.08  0.64 -0.59  1.00  0.42  0.45 -0.46  0.01
X5  0.60  0.56 -0.38  0.42  1.00  0.73 -0.35 -0.23
X6  0.57  0.51 -0.35  0.45  0.73  1.00 -0.34 -0.25
X7  0.08 -0.59  0.52 -0.46 -0.35 -0.34  1.00 -0.03
X8 -0.38  0.02 -0.06  0.01 -0.23 -0.25 -0.03  1.00
```



```r
image(corMat, axes=FALSE, main=paste("Correlation matrix of", P, "variables"))
axis(side=1, at=seq(0, 1, length.out=P), labels=rownames(corMat))
axis(side=2, at=seq(0, 1, length.out=P), labels=colnames(corMat))
```

![plot of chunk rerDiagMultivariate10](figure/rerDiagMultivariate10.png) 


See `heatmap()` for a heatmap including dendograms added to the plot sides and correlation for an alternative approach to visualize correlation matrices.

Correlation matrix plot
-------------------------


```r
library(ellipse)
plotcorr(corMat, type="lower", diag=FALSE, main="Bivariate correlations")
```

![plot of chunk rerDiagMultivariate11](figure/rerDiagMultivariate11.png) 


Useful packages
-------------------------

 - See package [`tourr`](http://cran.r-project.org/package=tourr) for an alternative to visualizing high-dimensional data.
 - Packages [`ggplot2`](http://cran.r-project.org/package=ggplot2) and [`lattice`](http://cran.r-project.org/package=lattice) provide their own graphics system and many functions for multi-panel plots.
 - Packages [`iplots`](http://www.rosuda.org/iplots/), [`rggobi`](http://cran.r-project.org/package=rggobi), and [`playwith`](http://cran.r-project.org/package=playwith) also create interactive diagrams.

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
try(detach(package:ellipse))
try(detach(package:nnet))
try(detach(package:MASS))
try(detach(package:mvtnorm))
try(detach(package:rgl))
try(detach(package:lattice))
```


Get this post from github
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/diagMultivariate.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/diagMultivariate.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/diagMultivariate.R) - [all posts](https://github.com/dwoll/RExRepos)
