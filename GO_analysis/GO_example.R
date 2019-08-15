#!/usr/bin/env Rscript

# Gene Ontology Analysis with TopGO
# 8/15/19
# cjfiscus

# install and load pkgs
## no need to run install code if already installed

options(stringsAsFactors = F)

### install topGO and org.Db
### org.At.tair.db is for *A. thaliana*, install respective db for your spp
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("topGO")
BiocManager::install("org.At.tair.db")

# install ggplot2 (if not already installed)
install.packages("ggplot2")

# load packages
library("topGO")
library("org.At.tair.db")
library("ggplot2")

# import list of all genes
geneList<-read.delim("Araport11_geneids.txt")

# annotate genes that you care about (upregulated, etc.) with a 1 and all other
# genes as 0. In this example I'm just going to take the top 5K genes. 

# subset the first 50 genes, these would be your genes of interest
first50genes<-geneList$ID[1:50]

# set genes of interest to 1, all others to 0
coolGenes<-ifelse(geneList$ID %in% first50genes, 1, 0)

# make sure the data looks ok
table(coolGenes)

# coolGenes is just a list of 1s and 0s, we need to add in the gene names. 
# for *A. thaliana* gene models have .X after gene name, we need to remove this
names(coolGenes)<-unlist(lapply(strsplit(geneList$ID, split=".", fixed=T), function(x)x[1]))

# make object for GO analysis 
# can use different ontologies, here using biological process
GO<-new("topGOdata", ontology="BP", 
        allGenes=coolGenes, 
        geneSelectionFun=function(x)(x==1), 
        annot=annFUN.org, mapping = "org.At.tair.db")

# do GO analysis with Fisher's Exact Test (read man about diff. tests and options)
resultFisher <- runTest(GO, algorithm = "elim", statistic = "fisher")

# save results to a table
tab <- GenTable(GO, raw.p.value = resultFisher, topNodes = length(resultFisher@score),
                numChar = 120)

# subset only results with statistical significance 
tab<-tab[tab$raw.p.value< 0.05,]

# transform p-values for plotting
tab$enrich<-log10(as.numeric(as.character(tab$raw.p.value)))*-1

# produce enrichment plot of significant results
ggplot(tab, aes(x=reorder(Term, enrich, FUN="identity"), y=enrich)) + 
  stat_summary(geom="bar", fun.y="mean", fill="dodgerblue1") + 
  coord_flip() + xlab("Biological Process") + 
  ylab("Enrichment") + ylim(0,3) + theme_classic()
