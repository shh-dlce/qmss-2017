###########################
## QMSS 2017
## Tutorial
## Plotting phylogenies in R
## Catherine Sheard & Fiona Jordan
###########################
## Phylogenetic tree from Bowern and Atkinson 2012
###########################

library(ape)
library(phytools)
library(geiger)
library(phangorn)

setwd("~/qmss-2017/plottingPhylogenies/") #set working directory

########################################
# ## WRITE CODE ## means just that!
########################################

########################################
## Section 1: reading and writing trees
########################################

PN<-read.nexus("pamanyungan.txt") #read in NEXUS file of Pama-Nyungan phylogenetic tree

plot(PN)

#Wow, doesn't that look ugly?!
#The purpose of this tutorial is give you tools for improving this plot!

#To start with, what is 'PN'?

PN

#PN is an object of class 'phylo'. Typing in just the name of the tree is a good way to check that you're working with the tree you think you are!

#Now let's explore what it means to be an object of class 'phylo'.

names(PN) #what makes up a phylo object? Gives us four parts of the object: edge, Nnode, tip.label, edge.length. Each of these have data associated.

PN$edge

#A long matrix. Each tip and node is assigned a number, with tips assigned numbers 1 through N (where N = number of tips). PN$edge lists which nodes/tips are connected by edges (branches, in the vernacular). This is MUCH easier to conceptualise if you look at the simplest tree possible:

abc <- read.tree(text = "((A,B),C);") #create a tree with three taxa
plot.phylo(abc, type="clado") #plot the tree
tiplabels()
nodelabels() #plot the node and tip labels on the tree. Tips come first, so A=1, B=2, C=3 etc
abc$edge #show the matrix 

#You can reconstruct the tree itself with this matrix, which is sometimes useful for checking things, but is otherwise a masochistic waste of time. Moving on!

#lists, unsurprisingly, the number of nodes (which, for a fully-resolved tree like this one, is the number of tips, minus 1). Again, good for checking!

PN$Nnode

#PN$tip.label lists the tip labels (Pama-Nyungan language names)

PN$tip.label

#PN$edge.length lists the edge lengths (branch lengths), with edges in the same order as PN$edge

PN$edge.length

#The Pama-Nyungan tree has edge lengths, which happen to be in the scale of 'year'. Objects of class "phylo" need not have edge lengths, however:

babytree <- read.tree(text = "(((A,B),(C,D)),E);") #simulate a small tree
babytree 
names(babytree)
plot(babytree)

#On a tree this small, we easily add in the automatically-assigned tip and node labels:

plot(babytree, label.offset = 5) # That looks stupid. 'label.offset' gives a scaling parameter that lets you determine how much space there is between the end of the branch and the label. Change it to see what it does. 
nodelabels() #nodes now have labels
tiplabels() #same for the tips

#Note that node and tip labels are fairly ugly on larger trees:
plot(PN)
nodelabels()
tiplabels() #hideous!

#Let's save our example tree before returning to the Pama-Nyungan tree
write.nexus(babytree, file="tinyexampletree.nex") 

#We just saved it as a NEXUS file, to match the format of the Pama-Nyungan tree. We could also have saved in Newick format:
write.tree(babytree, file="tinyexampletree-newick.tre")

#You could now open these in another programme such as FigTree.

########################################
## Section 2: manipulating trees
########################################

#Okay, back to Pama-Nyungan

plot(PN,show.tip.label=FALSE) #this turns off the tip labels, which are illegible at this scale

#We can use R to manipulate the tree. For example, maybe you're only interested in part of the Pama-Nyungan phylogeny?
subsetPN <- extract.clade(PN, 300)  # extract a clade that descends from an arbitrary node number (here, 300). Choose a different number to check.
plot(subsetPN)  #plot this subset

#Figuring out what node you actually want can be messy on larger trees.
#A handy way of figuring out what node you want uses the command 'mrca', which stands for 'Most Recent Common Ancestor'
#The MRCA is the latest possible (i.e., most recent) node that contains the specified tips as a monophyletic clade

randomnode<-mrca(PN)["Birrpayi", "Dharawal"]  # find the MRCA of Birrpayi and Dharawal
#This should be 300. Do you see why? Look again at the plot of 'subsetPN'
randomnode

subsetPN1<-extract.clade(PN,randomnode)
plot(subsetPN1)

#Now you try. Pick some languages from PN$tip.label and see what their smallest possible monophyletic clade looks like.

PN$tip.label

#We can also remove languages from the tree, for example because we don't have data for them, or because they're inconvenient for our purposes today

tipswithlongnames <- c("MaryRiverandBunyaBunyaCountry","WalmajarriBilliluna","NorthernNyangumarta")
PN.shortnames <- drop.tip(PN, tipswithlongnames) #create phylo object without longnames
plot(PN.shortnames,show.tip.label=FALSE) #plot it

#The drop.tip command is very useful for editing trees 
#(Note that the drop.tip command will also work across lists of multiple phylogenies -- class 'multiPhylo' -- using the command lapply.)

#Now you try. What if you want a tree that just shows the languages 'Umpila', 'Biri', and 'Yidiny'? 
#HINT: try to use the command 'setdiff'. The elements of setdiff(x,y) are those elements in x but not in y.
#Depending on how good your R is, this may be a very hard problem, so don't worry. 

PN.uby <- drop.tip(PN,setdiff(PN$tip.label,c("Umpila","Biri","Yidiny")))

#work from inside out here. 'setdiff' will give us the members of PN that are NOT our 3 languages of interest. 'drop.tip' will then drop these from the tree, and we'll assign the "leftover" bits of the tree to 'PN.uby'
plot(PN.uby)

#What if you sample 10 languages at random (using the command 'sample') and just plot those? 
#HINT: remember that PN$tip.label will list all tips and that there are 194 languages total.
#The answer to this mini-exercise is at the end of this tutorial.

PN.10<-drop.tip(PN,sample(PN$tip.label,184))
plot(PN.10)

#The commands 'getExtant' and 'getExtinct' will create lists of tips that, respectively, do (18) and do not (176) extend to the present.
#Using the command drop.tip, what would you do if you want a tree of just extant languages?
#The answer to this mini-exercise is at the end of this tutorial.

PN.extant<-drop.tip(PN,getExtinct(PN))
plot(PN.extant)
plot(PN)

#Let's return to our sample tree for this next one:
plot(babytree)
nodelabels()

#At the moment, it reads top-to-bottom E, D, C, B, A, which is annoying. Let's try to rotate the tree.
babytree1 <- rotate(babytree, 8)
plot(babytree1)

#Do you see what just happened? That's better, but not quite what we want. Let's try this:
babytree2<- rotateNodes(babytree, "all")
plot(babytree2)

#We can also re-root the tree:

nodelabels()
babytree3<- root(babytree, node = 9)
plot(babytree3)

#Remember how our tree didn't have edge lengths? What happens if we try to re-root a tree that has edge lengths?
plot(PN,show.tip.label=FALSE)
PN1<-root(PN,node=321) #re-root tree at node 321
plot(PN1,show.tip.label=FALSE) #plot it

#If we don't want to deal with node labels, we can also root by a specific taxon:

PN2 <- root(PN, "GuuguYimidhirr")
plot(PN2,show.tip.label=FALSE)

#This is useful if your analysis contains a known outgroup!

#One more piece of phylogeny manipulation, and then we'll move on to the actual graphics. 
#You might have reason to want to know the phylogenetic distance between two languages.
#For example, you might want to know if phylogenetic separation correlates with geographic separation, or differences in cultural traits, etc.
#One way to extract this information uses the command 'cophenetic.'

cophenetic(PN)["Dharumbal", "WikMungkan"]

#This gives you an answer in the units of the branch lengths, which may or may not be meaningful in terms of estimated years of separation.
#In this case, branch lengths = years, so Dharumbal and WikMungkan have been separated by an estimated cophenetic(PN)["Dharumbal", "WikMungkan"]/2 years.
#Running the 'cophenetic' command on an entire tree gives you a matrix of all pairwise distances:

cophenetic(PN)
cophenetic(PN)[1:5,1:5]



########################################
## Section 3: graphics
########################################


# Back to graphics. So far, we have a Pama-Nyungan phylogeny that looks like this:
plot(PN,show.tip.label=FALSE)

#The plot.phylo command is really flexible, though!
#For example, we can plot various types of trees:

plot(PN,type="cladogram",show.tip.label=FALSE) 
plot(PN,type="fan",show.tip.label=FALSE)
plot(PN,type="radial",show.tip.label=FALSE)
plot(PN, type="phylogram") #default

#We can change the edge colors/thickness:
plot(PN,edge.color="3", edge.width=2, show.tip.label=FALSE)

#The edge.color command can take a vector, so with some careful coding you can color the edges by, say, a particular trait.
N<-PN$Nnode #number of nodes
N #193
plot(PN,edge.color=rainbow(2*N), edge.width=2, show.tip.label=FALSE) #shiny!

colorscheme<-rep("black",2*N) #creates a vector of 'black' with 2N length
for(i in 1:(2*N)){
	if(PN$edge[i,2] < N+2){colorscheme[i]<-rainbow(N+1)[PN$edge[i,2]]}
}
#What's going on here? This is a really super clunky way to figure out which edges belong to tips, but, hey, it works!
colorscheme

plot(PN,edge.color=colorscheme,edge.width=2,show.tip.label=FALSE)

#Okay, moving away from rainbow silliness, let's say that you wanted to plot an ancestral state.
#Because this is an example, let's use as our character the number of letters in the language name, because that's obviously an important cultural trait! :-)

trait<-nchar(PN$tip.label)
names(trait)<-PN$tip.label
trait

x<-contMap(PN,trait,plot=FALSE) #reconstruct ancestral state using phytools function 'fastAnc'
x

#This is going to get a little messy, so let's only label every 10th tip
for(i in 1:(x$tree$Nnode+1)){
	if( i %% 10 !=0){	x$tree$tip.label[i]<-""}
}

plot(x)

#Does something look weird about the color scheme to you?
#Remember how we removed the tips with really long names? Yeah, let's do that again.

tipswithlongnames <- names(trait[trait>15])
PN.shortnames <- drop.tip(PN, tipswithlongnames)


#Now let's re-run the code:

trait<-nchar(PN.shortnames$tip.label)
names(trait)<-PN.shortnames$tip.label
trait
x1<-contMap(PN.shortnames,trait,plot=FALSE) #reconstruct ancestral state using phytools function 'fastAnc'

#Only label every 10th tip
for(i in 1:(x1$tree$Nnode+1)){
	if( i %% 10 !=0){	x1$tree$tip.label[i]<-""}
}

plot(x1) #this looks so much nicer!
#we don't really expect language name length to display any phylogenetic signal (or DO WE?)

#Let's try plotting the ancestral states of discrete characters.
#We start by simulating a trait.

sims<-sample(c("S1","S2","S3"), PN$Nnode+1, replace=TRUE) #this is simulating a character (S1-S3) at random, with no regard for phylogeny.
names(sims)<-PN$tip.label
sims

#We can first plot the characters on the tips:

plot(PN,type="fan",show.tip.label=FALSE)

cols<-setNames(palette()[1:length(unique(sims))],sort(unique(sims))) #setting a color palette
cols
tiplabels(pie=to.matrix(sims,sort(unique(sims))),piecol=cols,cex=0.4)
add.simmap.legend(colors=cols) #click where you want to draw your legend!

#Then we can add ancestral states probabilities for each node, again using 'ace':

fitER<-ace(sims,PN,model="ER",type="discrete") 
#ER here stands for 'equal-rates'; ace can estimate ancestral states under a few other models, and the packages 'diversitree' has even more flexibility. 
#Note diversitree requires  ultrametric trees, or trees with all of the tips being the same age, i.e., no extinct languages.

#We can inspect the estimated probabilities of each trait for each node.

fitER$lik.anc

#See how all of the node likelihoods are equal? That's a problem; it's indicating that the algorithm has failed in some way.
#'ace' is known to stop working over long branch lengths, so let's try shrinking the tree.

PN.scaled<-PN
PN.scaled$edge.length <- PN$edge.length/100

fitER<-ace(sims,PN.scaled,model="ER",type="discrete") 
fitER$lik.anc

#Oh, look, that worked! (If you got an error about 'NaNs', you accidentally divided by 0, don't worry, re-run the 'sample' code and try again.)


#Add the node labels:
nodelabels(node=1:PN$Nnode+Ntip(PN),
    pie=fitER$lik.anc,piecol=cols,cex=0.5)
 

#Isn't this pretty?
#(Actually, no, it probably isn't, because this was randomized data. Real-world data will probably display greater phylogenetic signal.)

#If you want to simulate some discrete traits with phylogenetic signal, you can use this code:

q<-list(rbind(c(-.5, .5), c(.5, -.5))) #this is a matrix of rates of evolution from state 1 to state 2.
q
sims<-sim.char(PN, q, model="discrete", n=1)#simulates one character under the discrete model of evolution described by q, over the phylogeny PN 

#Now go back and re-run the tip and node ancestral states and plotting above from line 281
#What is the relationship between the q matrix and what you see?

#Try plotting discrete ancestral states with another simulated dataset, this one more similar to real-world data. Or, just make the first 64 languages S1, the next 64 S2, and the final 65 S3.

#Note, incidentally, that there are ways of estimating ancestral states when some node states are known (historical language/cultural data).
#One can also overlay these sorts of phylogenies onto maps, to visually check for spatial signal, or into morphospace.
#We're not going to cover this here, but Google is your friend.




#One final type of phylogenetic graphs: lineage-through-time (LTT) plots.
#LTT plots count the accumulation of lineages (languages) through time.
#They are super-easy in R.

ltt.plot(PN, xlab = "Time", ylab = "N")

#This shows the accumulation of languages over the past 5,000 or so years, starting with proto-Pama-Nyungan.
#There seem to have been no particular bursts of language speciation/extinction, at least not until the present day.
#What would an LTT plot look like if there had been a major diversification or extinction event in a language family's history?

#One can also do LTT plots on discrete traits, showing the accumulation of particular traits. Google is your friend.


########################################
## Section 4: ggtree
########################################



#Okay, one final set of examples: ggtree.
#ggtree extends the ggplot2 package and is brand-new (published earlier in 2017)

#To install:

source("https://bioconductor.org/biocLite.R")
biocLite("ggtree",type="source")

library(ggtree)

#Basic trees:

ggtree(PN)

ggtree(PN, color="purple", size=1, linetype="dotted") #slightly more exciting tree

ggtree(PN, color="white") + theme_tree("black") #epic background

ggtree(PN)+geom_point(aes(shape=isTip, color=isTip), size=3) #color nodes and tips

ggtree(PN) + theme_tree2() #add a time scale 

#The following command takes a while, so we're going to do it on the smaller phylogeny
ggtree(subsetPN1, layout="unrooted") + ggtitle("unrooted layout")+geom_tiplab() #plot the tree as an unrooted fan

#ggtree makes more sense if you're familiar with ggplot2
#Regardless, try playing around with the command 'ggtree.' 

?ggtree
#What sort of aesthetically pleasing phylogenies can you make?

#A few more fun ggtree examples:

#ggtree can also be used to 'zoom in' on parts of a large phylogeny:
gzoom(PN, unlist(Descendants(PN,219)))

#Note that the 'Descendants' command lists the tip-numbers of all descendants of a particular node.
#(We used node 300 above, which was picked arbitrarily.)
#The command 'Ancestors' will list all nodes in the lineage from a given tree tip all the way back to the root of the tree, Proto-Pama-Nyungan.


#ggtree can annotate clades:

ggtree(PN)+geom_cladelabel(node=300, label="label", align=TRUE, angle=90, offset=.5,color="red")

#ggtree can highlight  clades:

ggtree(PN) + geom_hilight(node=300, fill="steelblue", alpha=.6)
ggtree(PN,layout="circular") + geom_hilight(node=300, fill="steelblue", alpha=.6)

#ggtree can draw (but not infer) horizontal events!

ggtree(subsetPN1) + geom_tiplab() + geom_taxalink('Ngunawal', 'Katthang', color = 'blue') + geom_taxalink('Dharuk', 'Dhurga', color='red', arrow=grid::arrow(length = grid::unit(0.02, "npc")))

#ggtree can also annotate nodes with graphs, images, etc, and tips can be followed by visual matrices, of, for example, traits or sequence alignments

# Visualise two different kinds of data with our land tenure tree
d1 <- data.frame(id=lt97.tree$tip.label, val=ltdata$lt_main) 
p <- ggtree(lt97.tree)
p2 <- facet_plot(p, panel="tenure", data=d1, geom=geom_point, aes(x=val), color='firebrick')
d2 <- data.frame(id=lt97.tree$tip.label, value = abs(rnorm(97, mean = 15000, sd=9000)))
facet_plot(p2, panel='pop size', data=d2, geom=geom_segment, aes(x=0, xend=value, y=y, yend=y), size=3, color='steelblue') + theme_tree2()


#See https://bioconductor.org/packages/devel/bioc/vignettes/ggtree/inst/doc/advanceTreeAnnotation.html for more information

#This is just the tip of the ggtree iceberg; much more information can be found at https://guangchuangyu.github.io/ggtree/  !









########################################
## Appendix: Answers to (some) mini-exercises
########################################




#Plotting a tree containing only Umpila, Biri, and Yidiny
#Note that there are other ways to do this!
PN.uby<-drop.tip(PN,setdiff(PN$tip.label,c("Umpila","Biri","Yidiny")))
plot(PN.uby)

#Plotting a tree containing a random 10 languages
PN.100<-drop.tip(PN,sample(PN$tip.label,184))
plot(PN.100)

#Plotting a tree with just extant languages
PN.extant<- drop.tip(PN, getExtinct(PN))
plot(PN.extant)
