# Find patterns using a decision tree with random effects.

setwd("~/Documents/Teaching/QMSS2017/gitfiles/qmss-2017/FindingPatterns/analysis/")
# Let's try to find what predicts the intensity of agriculture.
# We'll use a few measures: Belief in trance states, Belief in high moralising gods, and games

# Load some libraries

library(REEMtree)
library(party)
library(lattice)

# Load the data, taken from D-Place
d = read.csv("../data/dplace-societies-2017-05-12.csv", stringsAsFactors = T, skip=1)

######
# Let's convert the categories to more sensible labels

# Shorten Trance categories
d$trance = as.factor(c("Trance", "Posession","Trance (due to posession)",'Trance (due to possesion and other)','Trance and Poseesion','Trance (due to posession) and Posession','Trance (due to posession only)','None')[d$Code..EA112.Trance.states])

# Shorten High Gods categories.  Also, note that these are nicely ordered
d$HighGods = as.factor(c("None",'Present','Active','Supportive')[d$Code..EA034.Religion..high.gods])

# We can split the Games variable into three variables, showing whether cultures have games of physical skill, chance or strategy
d$Games.PhysicalSkill = d$Code..EA035.Games %in% c(2,4,6,8)
d$Games.Chance = d$Code..EA035.Games %in% c(3,4,7,8)
d$Games.Strategy = d$Code..EA035.Games %in% c(5,6,7,8)

# We'll treat agricultural intensity as an ordered measure
d$Agriculture = d$Code..EA028.Agriculture..intensity

# Make a basic decision tree, not controlling for langauge family
party.tree = ctree(Agriculture ~ 
                HighGods + 
                Games.PhysicalSkill + 
                Games.Chance + 
                Games.Strategy +
                trance,
                data= d)
plot(party.tree)


# A RE-EM tree with a random effect for language family
reem.tree = REEMtree(Agriculture ~ 
                       HighGods + 
                       Games.PhysicalSkill + 
                       Games.Chance + 
                       Games.Strategy,
           data= d,
           random = ~1|Language.family)

plot(reem.tree)

# RE-EM trees are a bit hard to read, but here we have a single node: "Games.Chance < 0.5".  The actual variable just has TRUE and FALSE values.  TRUE values are converted to 1 and FALSE values are converted to 0.  So if Games.Chance < 0.5, it's FALSE.
# Data branches to the right if the condition is met, so in this tree the right side is if Games.Chance is TRUE (mean Agriculture of 3.918) and the left side if Games.Chance is FALSE (mean Agriculture value of 2.391).


# It's sometimes easier to look at the tree as a text representation:
reem.tree$Tree

# More types of decision trees:
# http://www.statsblogs.com/2013/04/29/a-brief-tour-of-the-trees-and-forests/

rf = ranef(reem.tree)[,1]
names(rf) = rownames(ranef(reem.tree))
dotplot(sort(rf))
