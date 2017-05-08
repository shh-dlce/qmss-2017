setwd("~/Documents/Teaching/JenaSpringSchool/Projects/Connor/")
d = read.delim("CSnoek-AthapaskanDataSet.txt",sep='\t', header=T, quote = '', encoding = 'utf-16', fileEncoding = 'utf-16', strip.white = T, stringsAsFactors = F)

cognates= unique(d$COGNATE_SET)
languages = unique(d$LANGUAGE)



languages2 = iconv(languages2, to='ASCII//TRANSLIT')
languages2[is.na(languages2)] = paste("L",1:sum(is.na(languages2)), sep='')

languages2 = languages
languages2 = gsub(" ",'',languages2)
languages2 = gsub("\\(",'',languages2)
languages2 = gsub("\\)",'',languages2)
languages2 = gsub("'",'',languages2)
languages2 = gsub('\\"','',languages2)
languages2 = gsub("_",'',languages2)
languages2 = gsub("-",'',languages2)


m = sapply(cognates, function(cog){
  sapply(languages, function(l){cog %in% d[d$LANGUAGE==l,]$COGNATE_SET})
})


m= matrix(as.numeric(m),ncol=length(cognates))
rownames(m) = languages2
colnames(m) = cognates

source("makeNexusFile.R")
makeNexusFile(rownames(m), m, "CSnoek-AthapaskanDataSet.nex", convertToBinary=F, spacesBetweenCharacters='')

library(ape)

nd = read.nexus.data("CSnoek-AthapaskanDataSet.nex")
