#!/usr/bin/env Rscript

library(plyr)
library(ggplot2)

#SETWD: Location of centrifuge_report.tsv files. Should all be in same directory
setwd("/rsgrps/bhurwitz/jetjr/NeutropenicFever/qc_effect/no_qc")

#OUTPUT Directory: Location to store bubble plot and summary data file
out.dir <- "/rsgrps/bhurwitz/jetjr/NeutropenicFever/qc_effect"

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
final <- llply(props, subset, abundance > 5)
final <- llply(final, subset, numReads > 1)

fq <- ldply(final, data.frame)

#REPEAT FOR FASTA FORMAT
setwd("/rsgrps/bhurwitz/jetjr/NeutropenicFever/qc_effect/with_qc")

#OUTPUT Directory: Location to store bubble plot and summary data file
out.dir <- "/rsgrps/bhurwitz/jetjr/NeutropenicFever/qc_effect"

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

#ABUNDANCE FILTER DIFFERS FROM FASTQ DATA FOR THE PURPOSE OF INCLUDING BeAN virus hits for Paired T-test
final <- llply(props, subset, abundance > 1)
final <- llply(final, subset, numReads > 1)

fa <- ldply(final, data.frame)

#ADD FASTA ABUNDANCE VALUES TO FASTQ DATASET FOR EASY GGPLOT VISUALIZATION
fq$sample <- c("NF002", rep("NF003",5), rep("NF004",3), rep("NF005",3), rep("NF006",4), rep("NF001",4))
fq$abund <- c(99.28, 14.45, 18.27, NA, 55.42, NA, 21.70, NA, 57.40, 16.10, 27.40, 21.80, 23.94, NA, 50.08, NA, 40.82, 9.53, 7.72, 9.59)
fq$method <- "QC"

#PLOT FASTQ VS FASTA BUBBLE (5 removed rows belong to 5 hits not found in FASTA)
p2 <- ggplot(fq, aes(as.factor(sample), as.factor(name))) + geom_point(aes(size = abund, color = "burlywood3"), color="burlywood3", position=position_nudge(x = .2)) + geom_point(aes(size = abundance, color = "deepskyblue2"), color = "deepskyblue2",position=position_nudge(x = -.2))
p2 <- p2 + theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(size=12))
p2 <- p2 + labs(y = "Organism", x = "Sample", size = "Abundance (%)")
p2 <- p2 + theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill="white", colour="gray53"))
p2 <- p2 + guides(colour=F)
p2 <- p2 + geom_text(data = fq, aes(label = round(abund, digits = 2)), nudge_x = 0.30, size = 4)
p2 <- p2 + geom_text(data = fq, aes(label = round(abundance, digits = 2)), nudge_x = -0.30, size = 4)
p2 <- p2 + theme(axis.text =element_text(size=12), legend.text = element_text(size=12), axis.title.x = element_text(size =12), axis.title.y = element_text(size =12))
print(p2)

#SAVE SVG FORMAT
svg(filename = "NF_class1.svg", width = 7.5, height =5)
p2
dev.off()

#VIRAL PAIRED T-TEST - PAIR WISE COMPARISON OF NUMBER OF READS CLASSIFIED BETWEEN TWO METHODS
#SUBSET FILTERED REPORTS TO INCLUDE ONLY VIRAL HITS
viral.qc <- fq[c(1,3:5,8,9,12,15,19),]
viral <- fa[c(6,14,16:18,22:23,28,35),]
#MOVE NF001 HERV TO TOP FOR PAIRWISE COMPARISON
top <- viral.qc[9,]
viral.qc <- viral.qc[-9,]
viral.qc <- rbind(top,viral.qc)

tv <- t.test(viral.qc$numReads,viral$numReads,paired=T)
vdiff <- viral.qc$numReads - viral$numReads
vtotal <- sum(viral.qc$numReads + viral$numReads)
netred <- sum(vdiff)
vdf <- data.frame(viral$name, vdiff)
names(vdf) <- c("name", "diff")
vdf$type <- "Virus"

#BACTERIAL PAIRED T-TEST
bacterial.qc <- fq[c(2,7,10:11,13,16:18,20),]
bacterial <- fa[c(1,3,11,15,21,25,26,34,36),]
top <- bacterial.qc[7:9,]
bacterial.qc <- bacterial.qc[-c(7:9),]
bacterial.qc <- rbind(top,bacterial.qc)

t.test(bacterial$numReads,bacterial.qc$numReads,paired=T)
bdiff <- bacterial.qc$numReads - bacterial$numReads 
bdf <- data.frame(bacterial$name, bdiff)
btotal <- sum(bacterial.qc$numReads + bacterial$numReads)
netredb <- sum(bdiff)
names(bdf) <- c("name", "diff")
bdf$type <- "Bacteria"

df <- rbind(vdf, bdf)

ggplot(df, aes(x=name, y=log(diff), color = type)) + geom_point() + scale_y_continuous(limits = c(0, 15)) + geom_hline(yintercept=1)

#COMBINE
fq <- rbind(viral.qc,bacterial.qc)
fa <- rbind(viral,bacterial)
t.test(fq$numReads,fa$numReads,paired=T)
