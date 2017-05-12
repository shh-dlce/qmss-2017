###########################
## QMSS 2017
## Tutorial
## MCMCglmm tutorial
## Does range size and avian biodiversity predict Pama-Nyungan population sizes?
## (Yes, this is a pretty silly question)
## Catherine Sheard & Cara Evans
###########################
## Phylogenetic tree from Bowern and Atkinson 2012
## Data from D-PLACE (slightly modified)
###########################


install.packages('MCMCglmm') #install MCMCglmm
install.packages('phangorn') #install phangorn

library(MCMCglmm) #load MCMCglmm library
library(phangorn) #we'll need this to deal with the finickiness of the PN tree, but not normally necessary

setwd("C:/Users/Catherine/Desktop") #set working directory

PN<-read.nexus("pamanyungan.txt") #read in the Pama-Nyungan tree

x<-read.csv("MCMCglmm-data-PN.csv") #read in the data

str(x)

# This dataset four meta-data columns and three variables
# 'treename' matches the data to the Bowern & Atkinson tree
# glottocode matches the language to Glottolog
# BIN_soc_ids & EA_soc_ids match the data to D-PLACE. 
# (EA is the Ethnographic Atlas and BIN is Binford hunter-gatherer data.)
# 'area' is the area occupied by the society at time of data collection, in sq km.
# 'birds' is a binary variable, indicating if the area occupied by the ethnic group has (1) 'a lot' of birds (>150) or (0) 'not many' birds (<150).
# 'population' is the estimated population of the society at time of data collection

hist(x$area)
hist(x$population)

# Both of these continuous variables should probably be log-transformed. 
# We'll also scale them to have a mean of 0 and a standard deviation of 1.

x$logarea<-scale(log(x$area))
x$logpop<-scale(log(x$population))

hist(x$logarea)
hist(x$logpop)

plot(x$logpop~x$logarea) 
# Okay, so, groups with larger areas maybe have greater populations.
# (This isn't actually all that obvious in Pama-Nyungan languages, where desert communities may have very low population densities.)
# Not the tightest of relationships.
# But not terrible.

boxplot(x$logpop~x$birds)
# Okay, so groups with more bird species seem to have greater populations.
# But looks like the variance isn't particularly equal between these two groups.
# Also, larger geographic areas probably have both more birds and more people.
# These are all good points to think about *before* you conduct your statistical tests!




# Anyway.


# MCMCglmm requires that the tree exactly match the data, so let's get rid of all these extra tips:

PN.trimmed<-drop.tip(PN,setdiff(PN$tip.label,x$treename))

# PN isn't ultrametric (not all branches extend to the present), which will cause problems later on
# So let's just pretend every Pama-Nyungan language still exists, and force PN.trimmed to be ultrametric

PN.trimmed.u<-nnls.tree(cophenetic(PN.trimmed),PN.trimmed,rooted=TRUE)


# We can plot the trees to see what just happened.
par(mfrow=c(1,2)) #allow R to plot two figures next to each other
plot(PN.trimmed,main="Non-ultrametric")
plot(PN.trimmed.u,main="Ultrametric")

par(mfrow=c(1,1)) #reset the graphic parameters, just to be safe.



# Because MCMCglmm is a Bayesian method, we need to set some priors.
# G refers to the random effects (it stands for "genealogy", as MCMCglmm was originally created to analyze genetic data)
# R refers to the 'residuals,' or the individual-level data.
# The package defaults to a wide normal prior distribution for the fixed effects which we don't need to alter
# The package defaults to an inverse-Wishart prior distribution for the random effects, a common choice. 
# V is the variance of the parameter, and 'nu' is what's called the 'shape parameter' of inverse-Wishart distribution.
# The smaller the nu, the greater the uncertainty around our parameters.
# V = 1 and nu = 0.002 is suggested by Jarrod Hadfield (author of MCMCglmm) in his course notes, so let's go with that for now.
# One may want to specify more informative priors, of course!


prior.PN<-list(G=list(G1=list(V=1,nu=0.002)),R=list(V=1,nu=0.002))




model0<-MCMCglmm(logpop~logarea+as.factor(birds),
                     random=~treename, 
                     ginverse=list(treename=inverseA(PN.trimmed.u)$Ainv), 
                     prior = prior.PN, 
                     verbose=TRUE, #this will let us see how fast the model is running
                     family="gaussian",
                     data = x,
                     nitt=55000, #number of iterations (this is a very small number! a real analysis would run for much longer)
                     thin=50, #sampling of iterations (will record every 50th iteration, for a total posterior sample size of 1000)
                     burnin=5000) #initial iterations to discard

# Wait for it...


summary(model0)

# There will be some stochastic variation in your model, but I got a highly significant effect of area on population (p < 0.001) and of bird diversity on population (p = 0.004)
# The uncertainties on these parameters are pretty wide, though. (Check out the CIs.)
# The 'G-structure' estimates the effect of phylogeny on our dataset


# Let's visually inspect the model output.

plot(model0)

# You should  be seeing a nice, smooth, unimodel distribution (think bell curve) on the 'density' plots
# And in the 'trace' plots, you should be seeing perfect noise, with no evidence of autocorrelation
# Again, there will be stochasticity in your models, but mine are definitely problematic.

# When you get problematic results, you have three obvious choices:
# (1) Run the model for longer,
# (2) Specify more informative priors, or
# (3) Consider if your model is too big (too many fixed effects, or fixed effects that are autocorrelated or undersampled or otherwise odd)

# Let's try running the model for longer:

model1<-MCMCglmm(logpop~logarea+as.factor(birds),
                     random=~treename, 
                     ginverse=list(treename=inverseA(PN.trimmed.u)$Ainv), 
                     prior = prior.PN, 
                     verbose=TRUE, #this will let us see how fast the model is running
                     family="gaussian",
                     data = x,
                     nitt=55000*10, 
				#number of iterations (this still not that big of a number! a real analysis would probably run for several hours/days, depending on the size of your phylogy)
                     thin=50*10, #sampling of iterations (will record every 500th iteration, for a total posterior sample size of 1000)
                     burnin=5000*10) #initial iterations to discard

# Uh, have a nice chat with your seatmate or check Twitter or something. This will take a few minutes.


summary(model1)

# Okay! Still highly significant, still pretty wide confidence intervals.

plot(model1)

# Better, but still not great.

# Keep in mind, we only have a sample size of 30. Accounting for two fixed effects, plus phylogeny, is probably asking too much.
# Let's try testing just the effect of area on population size.
# Let's also try making the priors slightly more informative.

prior.PN.1<-list(G=list(G1=list(V=1,nu=0.2)),R=list(V=1,nu=0.2))

model2<-MCMCglmm(logpop~logarea,
                     random=~treename, 
                     ginverse=list(treename=inverseA(PN.trimmed.u)$Ainv), 
                     prior = prior.PN.1, 
                     verbose=TRUE, #this will let us see how fast the model is running
                     family="gaussian",
                     data = x,
                     nitt=55000, #number of iterations (this is a very small number! a real analysis would run for much longer)
                     thin=50, #sampling of iterations (will record every 50th iteration, for a total posterior sample size of 1000)
                     burnin=5000) #initial iterations to discard

summary(model2)
plot(model2)
# Yeah, we still aren't running this for long enough. One more time, a longer model.

model3<-MCMCglmm(logpop~logarea,
                     random=~treename, 
                     ginverse=list(treename=inverseA(PN.trimmed.u)$Ainv), 
                     prior = prior.PN.1, 
                     verbose=TRUE, #this will let us see how fast the model is running
                     family="gaussian",
                     data = x,
                     nitt=55000*10, #number of iterations (this is a very small number! a real analysis would run for much longer)
                     thin=50*10, #sampling of iterations (will record every 500th iteration, for a total posterior sample size of 1000)
                     burnin=5000*10) #initial iterations to discard

# Go back to socializing; this will take a few minutes.
# I would make an Aaron Burr joke here (from the musical Hamilton), but I'm worried not everyone would get it.

summary(model3)
plot(model3)
# Not perfect, but much better.

# So, we're pretty sure that in Pama-Nyungan societies, after controlling for phylogenetic non-independence, population increases as area increases.
# Furthermore, above and beyond any area effect, we think societies with more birds have greater populations.
# (This makes sense -- locations that support many species of birds are likely to be highly ecologically productive and thus can also support many humans!)
# It would probably be a good idea to collect more data, though!
# Or, even better, to come up with a more sensible hypothesis to test.



#Let's calculate the heritability statistic for model3 from the model variance
#This is conceptually identical to Pagel's lambda. See: Hadfield and Nakagawa (2010)

lambda <- model3$VCV[, "treename"]/(model3$VCV[, "treename"] + model3$VCV[, "units"])
mean(model3)
posterior.mode(model3)
HPDinterval(model3)

#It would seem that we are unable to estimate lamda with much accuracy
#The credible intervals are very wide
#This is perhaps unsurprising given the small size of this dataset


#Further questions:
#What if we had a grouping variable, indicating spatial clustering among socities?
#How would we add this variable to the list of model random effects?
#How then would we calcuate lambda?    







