#!/usr/bin/env Rscript

library(plyr)
library(ggplot2)

#SETWD: Location of centrifuge_report.tsv files. Should all be in same directory
setwd("/Users/jetjr/neutropenicfever/BMT/new/clark/screened/")

#OUTPUT Directory: Location to store bubble plot and summary data file
out.dir <- "/Users/jetjr/neutropenicfever/"

temp = list.files(pattern="*.csv")
myfiles = lapply(temp, read.csv)
sample_names <- as.list(sub(".unmapped.abundance.csv", "", temp))
myfiles = Map(cbind, myfiles, sample = sample_names)

#Proportion calculations: Each species "Number of Unique Reads" is divided by total "Unique Reads"
props1 = lapply(myfiles, function(x) { 
  names(x) <- c("name", "Lineage", "Count", "Proportion_All", "Percent", "sample")
  x$Percent <- as.numeric(as.character(x$Percent))
  x$method <- "CLARK"
  return(x[,c("name", "Percent", "sample", "method")])
})

## START CENTRIFUGE PARSING ##
setwd("/Users/jetjr/neutropenicfever/centrifuge/post-qc/")

temp = list.files(pattern="*report.tsv")
myfiles = lapply(temp, read.delim)
sample_names <- as.list(sub("-centrifuge_report.tsv", "", temp))
myfiles = Map(cbind, myfiles, sample = sample_names)

#Proportion calculations: Each species "Number of Unique Reads" is divided by total "Unique Reads"
props2 = lapply(myfiles, function(x) { 
  x$Percent <- (x$numUniqueReads / sum(x$numUniqueReads)) * 100
  x$method <- "Centrifuge"
  return(x[,c("name","Percent","sample", "method")])
})

#Final dataframe created for plotting, can change proportion value (Default 1%)
final1 <- llply(props1, subset, Percent > 2)
df1 <- ldply(final1, data.frame)

#Final dataframe created for plotting, can change proportion value (Default 1%)
final2 <- llply(props2, subset, Percent > 2)
df2 <- ldply(final2, data.frame)

combine <- rbind(df1, df2)

#Set file name and bubble plot title. Stored in out.dir
file_name <- "BMT001_bubble"
plot_title <- "BMT001 Classifcation Method Comparisons"

png(filename=paste0(out.dir, paste0(file_name,".png")), width = 1000, height = 800)
p2 <- ggplot(combine, aes(as.factor(method), as.factor(name)), colour = method) + geom_point(aes(size = Percent))
p2 <- p2 + theme(axis.text.x = element_text(angle = 90, hjust = 1), text = element_text(size=15))
p2 <- p2 + labs(y = "Organism", x = "Method")
p2 <- p2 + ggtitle(plot_title) + theme(plot.title = element_text(hjust = 0.5))
p2 <- p2 + guides(colour=F)
p2 <- p2 + facet_grid(. ~ sample)
print(p2)
dev.off()

write.csv(df, file = paste0(out.dir, file_name, ".csv"))

