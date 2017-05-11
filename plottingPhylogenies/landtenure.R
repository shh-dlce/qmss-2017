###########################
## QMSS 2017
## Tutorial
## Plotting phylogenies in R
## Fiona Jordan
###########################
## Data from Kushnick et al 2014
###########################

## -- LIBRARIES --------

library(ape)
library(RColorBrewer)

## -- READ IN TREE --------

setwd("~/qmss-2017/plottingPhylogenies/")
read.nexus("lt97.mcc.tree") -> lt97.tree
plot(lt97.tree)

## -- READ IN TRAIT DATA  ----

read.delim("lt.trait", row.names = 1, header=TRUE) -> ltdata
head(ltdata)

#### ---- VISUALISE ----------

##    create four colours to use
# see what this does
library(RColorBrewer)
ltcols <- brewer.pal(4, "Set1")
hist(discoveries, col = ltcols) # visualise our colours using a built-in dataset

# Or play with colours at http://tools.medialab.sciences-po.fr/iwanthue/ 
# Another palette
ltcols <- c("#bf823b", "#9372c6", "#6ca75d", "#cc556f")

##    create columns indicating colours
ltdata$none_col = "gray90"
ltdata$none_col[ltdata$lt_none == 1] = ltcols[1]
ltdata$group_col = "gray90"
ltdata$group_col[ltdata$lt_group == 1] = ltcols[2]
ltdata$kin_col = "gray90"
ltdata$kin_col[ltdata$lt_kin == 1] = ltcols[3]
ltdata$ind_col = "gray90"
ltdata$ind_col[ltdata$lt_indiv == 1] = ltcols[4]

ltdata$main_col = "white"
ltdata$main_col[ltdata$lt_main == 0] = ltcols[1]
ltdata$main_col[ltdata$lt_main== 1] = ltcols[2]
ltdata$main_col[ltdata$lt_main == 2] = ltcols[3]
ltdata$main_col[ltdata$lt_main == 3] = ltcols[4]

ltdata[lt97.tree$tip.label,] -> ltdata; head(ltdata) #order the data frame by the order of tree tiplabels
head(ltdata)

## -- plot all four traits and colour tip labels by main type

# print the figure to a pdf
# get your figure right first and then run this (delete the hash)
#pdf("landtenure.pdf", paper="a4", width=14, height=20)

plot.phylo(lt97.tree,  tip.color = ltdata$main_col, use.edge.length=F, no.margin=TRUE,  cex=0.7, adj=0, font=1, direction = "right", label.offset=10)
tiplabels(pch=15, cex=1.2, col=ltdata$none_col, adj= c(2.5))
tiplabels(pch=15, cex=1.2, col=ltdata$group_col, adj= c(4.6))
tiplabels(pch=15, cex=1.2, col=ltdata$kin_col, adj= c(6.7))
tiplabels(pch=15, cex=1.2, col=ltdata$ind_col, adj= c(8.8))
legend("topleft",
       legend=c("no tenure", "group ownership", "kin ownership", "individual ownership"), pch=c(16), col=ltcols, 
       title="Land Tenure")

#dev.off()


