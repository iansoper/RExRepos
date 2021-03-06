
## @knitr unnamed-chunk-1
wants <- c("car")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr unnamed-chunk-2
P    <- 3
Q    <- 3
g11  <- c(41, 43, 50)
g12  <- c(51, 43, 53, 54, 46)
g13  <- c(45, 55, 56, 60, 58, 62, 62)
g21  <- c(56, 47, 45, 46, 49)
g22  <- c(58, 54, 49, 61, 52, 62)
g23  <- c(59, 55, 68, 63)
g31  <- c(43, 56, 48, 46, 47)
g32  <- c(59, 46, 58, 54)
g33  <- c(55, 69, 63, 56, 62, 67)
dfMD <- data.frame(IV1=factor(rep(1:P, c(3+5+7, 5+6+4, 5+4+6))),
                   IV2=factor(rep(rep(1:Q, P), c(3,5,7, 5,6,4, 5,4,6))),
                   DV =c(g11, g12, g13, g21, g22, g23, g31, g32, g33))


## @knitr unnamed-chunk-3
xtabs(~ IV1 + IV2, data=dfMD)


## @knitr unnamed-chunk-4
anova(lm(DV ~ IV1 + IV2 + IV1:IV2, data=dfMD))
anova(lm(DV ~ IV2 + IV1 + IV1:IV2, data=dfMD))


## @knitr unnamed-chunk-5
SS.I1 <- anova(lm(DV ~ 1,                 data=dfMD),
               lm(DV ~ IV1,               data=dfMD))
SS.I2 <- anova(lm(DV ~ IV1,               data=dfMD),
               lm(DV ~ IV1+IV2,           data=dfMD))
SS.Ii <- anova(lm(DV ~ IV1+IV2,           data=dfMD),
               lm(DV ~ IV1+IV2 + IV1:IV2, data=dfMD))


## @knitr unnamed-chunk-6
SS.I1[2, "Sum of Sq"]
SS.I2[2, "Sum of Sq"]
SS.Ii[2, "Sum of Sq"]


## @knitr unnamed-chunk-7
SST <- anova(lm(DV ~ 1,       data=dfMD),
             lm(DV ~ IV1*IV2, data=dfMD))
SST[2, "Sum of Sq"]
SS.I1[2, "Sum of Sq"] + SS.I2[2, "Sum of Sq"] + SS.Ii[2, "Sum of Sq"]


## @knitr unnamed-chunk-8
library(car)
Anova(lm(DV ~ IV1*IV2, data=dfMD), type="II")


## @knitr unnamed-chunk-9
SS.II1 <- anova(lm(DV ~     IV2,         data=dfMD),
                lm(DV ~ IV1+IV2,         data=dfMD))
SS.II2 <- anova(lm(DV ~ IV1,             data=dfMD),
                lm(DV ~ IV1+IV2,         data=dfMD))
SS.IIi <- anova(lm(DV ~ IV1+IV2,         data=dfMD),
                lm(DV ~ IV1+IV2+IV1:IV2, data=dfMD))


## @knitr unnamed-chunk-10
SS.II1[2, "Sum of Sq"]
SS.II2[2, "Sum of Sq"]
SS.IIi[2, "Sum of Sq"]


## @knitr unnamed-chunk-11
SST <- anova(lm(DV ~ 1,       data=dfMD),
             lm(DV ~ IV1*IV2, data=dfMD))
SST[2, "Sum of Sq"]
SS.II1[2, "Sum of Sq"] + SS.II2[2, "Sum of Sq"] + SS.IIi[2, "Sum of Sq"]


## @knitr unnamed-chunk-12
# options(contrasts=c(unordered="contr.sum",       ordered="contr.poly"))


## @knitr unnamed-chunk-13
# options(contrasts=c(unordered="contr.treatment", ordered="contr.poly"))


## @knitr unnamed-chunk-14
fitIII <- lm(DV ~ IV1 + IV2 + IV1:IV2, data=dfMD,
             contrasts=list(IV1=contr.sum, IV2=contr.sum))


## @knitr unnamed-chunk-15
library(car)
Anova(fitIII, type="III")


## @knitr unnamed-chunk-16
# A: lm(DV ~     IV2 + IV1:IV2) vs. lm(DV ~ IV1 + IV2 + IV1:IV2)


## @knitr unnamed-chunk-17
# B: lm(DV ~ IV1     + IV1:IV2) vs. lm(DV ~ IV1 + IV2 + IV1:IV2)


## @knitr unnamed-chunk-18
drop1(fitIII, ~ ., test="F")


## @knitr unnamed-chunk-19
drop1(fitIII, ~ ., test="F")


## @knitr unnamed-chunk-20
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))


