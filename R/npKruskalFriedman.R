
## @knitr unnamed-chunk-1
wants <- c("coin")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr unnamed-chunk-2
IQ1  <- c( 99, 131, 118, 112, 128, 136, 120, 107, 134, 122)
IQ2  <- c(134, 103, 127, 121, 139, 114, 121, 132)
IQ3  <- c(110, 123, 100, 131, 108, 114, 101, 128, 110)
IQ4  <- c(117, 125, 140, 109, 128, 137, 110, 138, 127, 141, 119, 148)
Nj   <- c(length(IQ1), length(IQ2), length(IQ3), length(IQ4))
KWdf <- data.frame(DV=c(IQ1, IQ2, IQ3, IQ4),
                   IV=factor(rep(1:4, Nj), labels=c("I", "II", "III", "IV")))


## @knitr unnamed-chunk-3
kruskal.test(DV ~ IV, data=KWdf)


## @knitr unnamed-chunk-4
library(coin)
kruskal_test(DV ~ IV, distribution=approximate(B=9999), data=KWdf)


## @knitr unnamed-chunk-5
pairwise.wilcox.test(KWdf$DV, KWdf$IV, p.adjust.method="holm")


## @knitr unnamed-chunk-6
oneway_test(DV ~ IV, distribution=approximate(B=9999), data=KWdf)


## @knitr unnamed-chunk-7
set.seed(1.234)
P    <- 4
Nj   <- c(41, 37, 42, 40)
muJ  <- rep(c(-1, 0, 1, 2), Nj)
JTdf <- data.frame(IV=ordered(rep(LETTERS[1:P], Nj)),
                   DV=rnorm(sum(Nj), muJ, 7))


## @knitr unnamed-chunk-8
library(coin)
kruskal_test(DV ~ IV, distribution=approximate(B=9999), data=JTdf)


## @knitr unnamed-chunk-9
N   <- 5
P   <- 4
DV1 <- c(14, 13, 12, 11, 10)
DV2 <- c(11, 12, 13, 14, 15)
DV3 <- c(16, 15, 14, 13, 12)
DV4 <- c(13, 12, 11, 10,  9)
Fdf <- data.frame(id=factor(rep(1:N, times=P)),
                  DV=c(DV1, DV2, DV3, DV4),
                  IV=factor(rep(1:P, each=N),
                            labels=LETTERS[1:P]))


## @knitr unnamed-chunk-10
friedman.test(DV ~ IV | id, data=Fdf)


## @knitr unnamed-chunk-11
friedman_test(DV ~ IV | id, distribution=approximate(B=9999), data=Fdf)


## @knitr unnamed-chunk-12
oneway_test(DV ~ IV | id, distribution=approximate(B=9999), data=Fdf)


## @knitr unnamed-chunk-13
N   <- 10
P   <- 4
muJ <- rep(c(-1, 0, 1, 2), each=N)
Pdf <- data.frame(id=factor(rep(1:N, times=P)),
                  DV=rnorm(N*P, muJ, 3),
                  IV=ordered(rep(LETTERS[1:P], each=N)))


## @knitr unnamed-chunk-14
friedman_test(DV ~ IV | id, distribution=approximate(B=9999), data=Pdf)


## @knitr unnamed-chunk-15
try(detach(package:coin))
try(detach(package:modeltools))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))
try(detach(package:stats4))


