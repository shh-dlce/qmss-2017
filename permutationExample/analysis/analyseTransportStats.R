# set the working directory
# (this will depend on your system)
setwd("~/Documents/Teaching/QMSS2017/gitfiles/qmss-2017/permutationExample/analysis/")

# Load the data
d = read.csv("../data/TransportData.csv")

# Plot the real data
plot(d$fate, d$greenberg, xlab='Road Fatalities', ylab='Linguistic Diversity')
abline(lm(d$greenberg~ d$fate), col=2, lwd=2)

# Calculate the true correlation
true.r = cor(d$fate, d$greenberg)


# Demonstrate sample function
x = c(1,2,3,4,5)
sample(x)
sample(x)

# A function to permute the data
perm = function(){
  cor(d$fate, sample(d$greenberg))
}

# set the random seed
set.seed(666)

# use repliate to permute the data many times
perm.r = replicate(1000, perm())

# Plot the distribution of permuted data
hist(perm.r)
abline(v=true.r,col=2)

# Work out p value and z-value
p.value = sum(perm.r >= true.r) / length(perm.r)
z.value = (true.r - mean(perm.r)) / sd(perm.r)

###########
# Stratified permutation

# Demonstrate tapply with stratification

myLetters   <-      c('x','z','d','a','e','o')
vowelOrConsonant <- c('c','c','c','v','v','v')

sample(myLetters)

tapply(myLetters, vowelOrConsonant, sample)

unlist(tapply(myLetters, vowelOrConsonant, sample))
unlist(tapply(myLetters, vowelOrConsonant, sample))
unlist(tapply(myLetters, vowelOrConsonant, sample))

# Function to sample within continents
# Note: assumes that data is sorted by continents
stratSample = function(X,groups){
  unlist(tapply(X, groups, sample))
}

# permute the data and measure the correlation once
strat.perm = function(){
  perm = stratSample(d$greenberg, d$continent)
  cor(d$fate, perm)
}

set.seed(123)
strat.perm.r = replicate(1000, strat.perm())
hist(strat.perm.r)
abline(v=true.r,col=2)

# Work out p value and z-value
p.value.strat = sum(strat.perm.r >= true.r) / length(strat.perm.r)
z.value.strat = (true.r - mean(strat.perm.r)) / sd(strat.perm.r)


z.value
p.value
z.value.strat
p.value.strat
