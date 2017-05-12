library(party)
library(lattice)

# Set the working directory (will be different for you)
setwd("~/Documents/Teaching/QMSS2017/gitfiles/qmss-2017/FindingPatterns/analysis/")

# Load the word data
d = read.csv("../data/wordData.csv", stringsAsFactors = F)

# Pick some variables to look at
# (choose 4-5, so that the program runs quickly)
myVars = c("length","frequency",'valence','concreteness')

# Take out first two columns (X and word)
d = d[,myVars]

# Make a ctree predicting length by all other variables (the . represents all other variables)
tree = ctree(length ~ ., data=d)
plot(tree)

# It's quite complicated!  And hard to read on a graph.
# We can look at the tree directly:

tree@tree

#Let's restrict the maximum depth of the tree to 2.  We use ctree_control():

tree2 = ctree(length ~ ., data=d,
             control=ctree_control(maxdepth = 2))
plot(tree2, terminal_panel=node_boxplot)

# There are other things you can change in ctree_control(), such as 'mincriterion', which controls the p-value cutoff where the tree will stop growing.  If you lower this value, you'll get more tree, but the splits will be less reliable.


# Random Forests:

# Let's set some parameters for the Random Forest.  We want to use 3 predictors in each random tree, with 100 trees in total.
# The first choice is limited by the number of variables in our dataset, but the rule of thumb is to use 5 if possible.
# The number of trees should be bigger (like 1000), but we'll just set it to be 100 so it runs quickly
forestControl = cforest_control(
  mtry = 3, # number of predictor variables in each tree
  ntree = 100) # Number of trees to run)

# Calculate the forest
forest = cforest(length~ ., data=d,
                 control = forestControl)

# Now we work out the importance measures.
# For real analyses, we should set conditional=TRUE
# This will calculate importance measures as indpendent from other variables.  But this can take some time, so for now we just set it to FALSE
d.varimp <- varimp(forest, conditional=FALSE)

# Plot the importance
# The values are relative, so bigger values are more important variables.
# The rule of thumb is to work out a cutoff for 'important' and 'not important variables.  Important variables should have values bigger than the absolute smallest value.
# e.g. if the smallest value is -0.5, then important values will be > +0.5.

barplot(sort(d.varimp))
abline(h=0)
abline(h=min(abs(d.varimp)), lty=2,col=2)
abline(h=-min(abs(d.varimp)), lty=2, col=2)
