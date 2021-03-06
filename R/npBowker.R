
## @knitr unnamed-chunk-1
categ <- factor(1:3, labels=c("lo", "med", "hi"))
drug  <- rep(categ, c(30, 50, 20))
plac  <- rep(rep(categ, length(categ)), c(14,7,9, 5,26,19, 1,7,12))
cTab  <- table(drug, plac)
addmargins(cTab)


## @knitr unnamed-chunk-2
Q         <- nlevels(categ)
sqDiffs   <- (cTab - t(cTab))^2 / (cTab + t(cTab))
(chisqVal <- sum(sqDiffs[upper.tri(cTab)]))
(bowDf <- choose(Q, 2))
(pVal <- 1-pchisq(chisqVal, bowDf))


