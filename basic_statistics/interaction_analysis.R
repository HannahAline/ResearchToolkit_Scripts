Interactions
##### Code for Interactions

library(emmeans)

### import the data


datum=read.csv(file.choose())
head(datum)


### Plot the Data


plot(datum$Age,datum$Size)



### multi-variable analyses


results=lm(Size~Age+Sex,data=datum) ### model doesn't include interaction
summary(results)

results=lm(Size~Age+Sex+Age:Sex,data=datum) ### model includes interaction
summary(results)


#### Other ways of specifying interaction


results2=lm(Size~Age*Sex,data=datum) ### '*' means include all main effects and interactions
summary(results2) ### note results are same as for results4

results3=lm(Size~Age+SexN+I(Age*SexN),data=datum) ### note that only works for dummy coded factors
summary(results3) ### note results are same as for results5 and results4


### Break apart analysis due to interaction - calculate effect of age separately for each sex


resultsFemale=lm(Size~Age,data=datum,subset=c(Sex=="Female"))
summary(resultsFemale)

resultsMale=lm(Size~Age,data=datum,subset=c(Sex=="Male"))
summary(resultsMale)


#### Use emmeans to examine interation
emmip(results,Sex~Age,cov.reduce=range)
#'Y' is grouping variable
#'X' is covariate
#cov.reduce=range uses the range of x values for plotting relationship



###############################################
###### Multifactorial example #################



#### import the data

datum=read.csv(file.choose())
head(datum)


#### plot the data

datum$Species=as.factor(datum$Species)
datum$Sex=as.factor(datum$Sex)
plot(HomeRangeSize~Species,data=datum)


#### Multivariable analysis

results=lm(HomeRangeSize~Species+Sex+Species:Sex,data=datum)
summary(results)
#### We know that the interaction as a whole is significant,
### because one of the interaction variables is significant. 
### However, what if we want that single p-value indicating
### Whether there is an interaction between the two variables?

### F-drop test
results2=lm(HomeRangeSize~Species+Sex,data=datum)
anova(results,results2)

### Alternative
library(car)
Anova(results)
### Note that these are type II Sum of Squares tests


#Break apart analysis due to interaction
resultsWolf=lm(HomeRangeSize~Sex,data=datum,subset=c(Species=="Wolf"))
summary(resultsWolf)

resultsCoyote=lm(HomeRangeSize~Sex,data=datum,subset=c(Species=="Coyote"))
summary(resultsCoyote)

resultsDog=lm(HomeRangeSize~Sex,data=datum,subset=c(Species=="Dog"))
summary(resultsDog)



#### But can't say anything about differences among species. 
###Alternative: emmeans function

emmeans(results,~Species*Sex)
emmeans(results,~Species|Sex)
emmeans(results,pairwise~Species*Sex)
emmeans(results,pairwise~Sex|Species)
resultsMeans=emmeans(results,pairwise~Sex*Species)
plot(resultsMeans$emmeans)
plot(resultsMeans$contrast)
