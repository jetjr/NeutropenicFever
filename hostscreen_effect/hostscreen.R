library(plyr)
library(ggplot2)

#SCREENED

setwd("/Users/jetjr/neutropenicfever/final/hostscreen/screened/")

temp = list.files(pattern="*report.tsv")
myfiles = lapply(temp, read.delim)
sample_names <- as.list(sub("-centrifuge_report.tsv", "", temp))
myfiles = Map(cbind, myfiles, sample = sample_names)

props = lapply(myfiles, function(x) { 
  x$proportion <- (x$numUniqueReads / sum(x$numUniqueReads)) * 100
  x$abundance <- x$abundance * 100
  x$hitratio <- x$numUniqueReads / x$numReads
  return(x[,c("name","sample","abundance", "numReads", "proportion", "numUniqueReads")])
})

final <- llply(props, subset, proportion > 1)
final <- llply(final, subset, numReads > 1)
final <- llply(final, subset, abundance > 1)

screened <- ldply(final, data.frame)

#DB EXCLUSION

setwd("/Users/jetjr/neutropenicfever/final/hostscreen/db/")

temp = list.files(pattern="*report.tsv")
myfiles = lapply(temp, read.delim)
sample_names <- as.list(sub("-centrifuge_report.tsv", "", temp))
myfiles = Map(cbind, myfiles, sample = sample_names)

props = lapply(myfiles, function(x) { 
  x$proportion <- (x$numUniqueReads / sum(x$numUniqueReads)) * 100
  x$abundance <- x$abundance * 100
  x$hitratio <- x$numUniqueReads / x$numReads
  return(x[,c("name","sample","abundance", "numReads", "proportion", "numUniqueReads", "taxID")])
})

final <- llply(props, subset, proportion > 0.05)
final <- llply(final, subset, numReads > 1)
final <- llply(final, subset, abundance > 1)

db <- ldply(final, data.frame)

#ID EXCLUSION

setwd("/Users/jetjr/neutropenicfever/final/hostscreen/exclude/")

temp = list.files(pattern="*report.tsv")
myfiles = lapply(temp, read.delim)
sample_names <- as.list(sub("-centrifuge_report.tsv", "", temp))
myfiles = Map(cbind, myfiles, sample = sample_names)

props = lapply(myfiles, function(x) { 
  x$proportion <- (x$numUniqueReads / sum(x$numUniqueReads)) * 100
  x$abundance <- x$abundance * 100
  x$hitratio <- x$numUniqueReads / x$numReads
  return(x[,c("name","sample","abundance", "numReads", "proportion", "numUniqueReads")])
})

final <- llply(props, subset, proportion > 1)
final <- llply(final, subset, numReads > 1)
final <- llply(final, subset, abundance > 1)

exclude <- ldply(final, data.frame)

#################
value <- c(1154523,1192678,1279067)
treatment <- c("Screened", "Exclude", "DB Manipulations")
df <- data.frame(value, treatment)

ggplot(df, aes(y=value, x=treatment)) + geom_point() + geom_segment(aes(xend=treatment), yend=0) + expand_limits(y=0) + coord_flip()

################

setwd("/Users/jetjr/Documents/")
df <- read.csv("hostscreen.csv")
df <- df[-c(2,12,22,10,20,30),]

cbPalette <- c("#D00000", "#FFBA08", "#032B43")
p1 <- ggplot(df, aes(y=value, x=sample, color = type)) + geom_point(size = 5) + facet_wrap( ~ name, scales = "free") + theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill="white", colour="gray53"), text = element_text(size=12), strip.text = element_text(face = "italic"))
p1 <- p1 + labs(y = "Number of Reads Classified", x = "Sample", color = "Method")
p1 <- p1 + scale_color_manual(values=cbPalette)
p1

svg(filename = "hostscreen.svg", width = 10, height =7)
p1
dev.off()
