monme <- function(){
  dat = 20
  ff = dat *20
  ff
}
monme()
data("ChickWeight")

tt <- agricolae::LSD.test(aov(weight~Diet,ChickWeight),"Diet", p.adj = "bonferroni")
ass <- read.csv("data/ass.csv")

dd <- aov(observation~block,ass)
ddd <- agricolae::duncan.test(dd,"block")
d <- table(ddd[["groups"]])
factor(ass[,"block"])
d
as.