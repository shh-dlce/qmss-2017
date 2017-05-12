# Use a PCA to visualise the distances between datapoints with many variables at the same time
setwd("~/Documents/Teaching/QMSS2017/gitfiles/qmss-2017/FindingPatterns/analysis/")

# Load some data on words
d = read.csv("../data/wordData.csv", stringsAsFactors = F)


# The first two columns are an ID variable and the actual word.  We don't want to analyse those, so let's take them out.
words = d$word

d = d[,-c(1,2)]

# First, let's plot the correlation between each variable
pairs(d, upper.panel = NULL,lower.panel = panel.smooth)

# We can scale each variable to be in the same range and centered around 0.
# (For real analyses, we'd want to do this more carefully)
scaled.d = scale(d)

# Run the PCA
pca <- prcomp(scaled.d)

# Plot the first and second principle components
plot(pca$x[,1:2])

# There are some words outside the main cluster, what are those?
plot(pca$x[,1:2])
outliers = which(pca$x[,1]< -7)
text(pca$x[outliers,1], pca$x[outliers,2], words[outliers])


# Look at the rotation (loadings) of variables
dim2 = pca$rotation[,1:2]
dim2[order(dim2[,1]),]

# A fancier plot
biplot(pca)

# Look at the eigenvalues: how much cumulative variance is explained by each dimension
pca.summary = summary(pca)
plot(cumsum(pca.summary$importance[2,]), type='b')


# More ways to plot PCA data:
#http://www.sthda.com/english/wiki/principal-component-analysis-in-r-prcomp-vs-princomp-r-software-and-data-mining

# Phylogenetic PCA using phyl.pca from the phytools package:
#http://www.phytools.org/static.help/phyl.pca.html