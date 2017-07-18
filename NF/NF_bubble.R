#!/usr/bin/env Rscript

library(plyr)
library(ggplot2)

#SETWD: Location of centrifuge_report.tsv files. Should all be in same directory
setwd("/Users/jetjr/neutropenicfever/final/new/comprehensiveNF/fastq/")
setwd("/Users/jetjr/neutropenicfever/final/new/comprehensiveNF/")


#OUTPUT Directory: Location to store bubble plot and summary data file
out.dir <- "/Users/jetjr/neutropenicfever/final/new/comprehensiveNF"

temp = list.files(pattern="*report.tsv")
myfiles = lapply(temp, read.delim)
sample_names <- as.list(sub("-centrifuge_report.tsv", "", temp))
myfiles = Map(cbind, myfiles, sample = sample_names)

#Proportion calculations: Each species "Number of Unique Reads" is divided by total "Unique Reads"
props = lapply(myfiles, function(x) { 
  x$proportion <- (x$numUniqueReads / sum(x$numUniqueReads)) * 100
  x$abundance <- x$abundance * 100
  x$hitratio <- x$numUniqueReads / x$numReads
  return(x[,c("name","sample","abundance", "numReads", "proportion", "numUniqueReads")])
})

final <- llply(props, subset, proportion > 1)
final <- llply(final, subset, numReads > 1)

fq <- ldply(final, data.frame)
fa <- ldply(final, data.frame)
fq$sample <- c("NF002", rep("NF003",5), rep("NF004",3), rep("NF005",3), rep("NF006",4), rep("NF001",4))
fq$abund <- c(99.28, 14.45, 18.27, NA, 55.42, NA, 21.70, NA, 57.40, 16.10, 27.40, 21.80, 23.94, NA, 50.08, NA, 40.82, 9.53, 7.72, 9.59)

p2 <- ggplot(fq, aes(as.factor(sample), as.factor(name))) + geom_point(aes(size = abund, color = "burlywood3"), color="burlywood3", position=position_nudge(x = .1)) + geom_point(aes(size = abundance, color = "deepskyblue2"), color = "deepskyblue2",position=position_nudge(x = -.1))
p2 <- p2 + theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(size=12))
p2 <- p2 + labs(y = "Organism", x = "Sample", size = "Abundance (%)")
p2 <- p2 + ggtitle("MRSA/MSSA Centrifuge Proporition vs Abundance Classification") + theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill="white", colour="gray53"))
p2 <- p2 + guides(colour=F)
p2 <- p2 + geom_text(data = fq, aes(label = round(abund, digits = 2)), nudge_x = 0.30, size = 3.5)
p2 <- p2 + geom_text(data = fq, aes(label = round(abundance, digits = 2)), nudge_x = -0.30, size = 3.5)
#p2 <- p2 + facet_grid(known ~ ., scales = "free_y")
print(p2)

fa <- ldply(final, data.frame)
fa$method <- "No QC"

df <- rbind(fa, fq)

p2 <- ggplot(df, aes(as.factor(sample), as.factor(name))) + geom_point(aes(size = abundance))
p2 <- p2 + theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(size=12))
p2 <- p2 + labs(y = "Organism", x = "Sample", size = "Abundance (%)")
p2 <- p2 + ggtitle("Neutropenic Fever Centrifuge Classification") + theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill="white", colour="gray53"))
#p2 <- p2 + guides(colour=F)
p2 <- p2 + geom_text(data = df, aes(label = round(abundance, digits = 2)), nudge_x = 0.27, nudge_y = .40)
p2 <- p2 + theme(axis.text =element_text(size=11), legend.text = element_text(size=12), axis.title.x = element_text(size =12), axis.title.y = element_text(size =12))
print(p2)

write.csv(df, file = paste0(out.dir, "Mock_new_index", ".csv"))

svg(filename = "NF_class1.svg", width = 13, height =5)
p2
dev.off()

#-----VIRAL T TEST------#
viral.qc <- fq[c(2,3,7,9:13,18,23,27),]
viral <- fa[c(3,11,12,16,19:23,27,32),]
top <- viral[1,]
viral <- viral[-1,]
viral <- rbind(viral,top)

tv <- t.test(viral$numReads,viral.qc$numReads,paired=T)
vdiff <- viral.qc$numReads - viral$numReads
vtotal <- sum(viral.qc$numReads + viral$numReads)
netred <- sum(vdiff)
vdf <- data.frame(viral$name, vdiff)
names(vdf) <- c("name", "diff")
vdf$type <- "Virus"

boxplot(vdf$vdiff,vdf$name,data=vdf)


#------BACTERIAL T TEST------#
bacterial.qc <- fq[c(1,4:6,8,14:17,19:22,24:26,28:33),]
bacterial.qc <- bacterial.qc[-15,]

bacterial <- fa[c(1:2,4:10,13:15,17,18,24:26,28:31,33),]
top <- bacterial[1:8,]
bacterial <- bacterial[-c(1:8),]
bacterial <- rbind(bacterial,top)
bacterial <- bacterial[-18,]

t.test(bacterial$numReads,bacterial.qc$numReads,paired=T)
bdiff <- bacterial.qc$numReads - bacterial$numReads 
bdf <- data.frame(bacterial$name, bdiff)
btotal <- sum(bacterial.qc$numReads + bacterial$numReads)
netredb <- sum(bdiff)
names(bdf) <- c("name", "diff")
bdf$type <- "Bacteria"

df <- rbind(vdf, bdf)

ggplot(df, aes(x=name, y=log(diff), color = type)) + geom_point() + scale_y_continuous(limits = c(0, 15)) + geom_hline(yintercept=1)

