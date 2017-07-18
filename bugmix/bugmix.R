#!/usr/bin/env Rscript

library(plyr)
library(ggplot2)

#SETWD: Location of centrifuge_report.tsv files. Should all be in same directory
setwd("/Users/jetjr/bugmix/new/")

#OUTPUT Directory: Location to store bubble plot and summary data file
out.dir <- "/Users/jetjr/mockcommunity/mcom/"

normal <- read.delim("IonXpress_030_Mockcommunity_even.fasta-centrifuge_report.tsv")

temp = list.files(pattern="*report.tsv")
myfiles = lapply(temp, read.delim)
sample_names <- as.list(sub("-centrifuge_report.tsv", "", temp))
sample_names <- as.list(sub(".fasta", "", sample_names))
myfiles = Map(cbind, myfiles, sample = sample_names)

#Proportion calculations: Each species "Number of Unique Reads" is divided by total "Unique Reads"
props = lapply(myfiles, function(x) { 
    x$proportion <- (x$numUniqueReads / sum(x$numUniqueReads)) * 100
    x$abundance <- x$abundance * 100
    x$hitratio <- x$numUniqueReads / x$numReads
    return(x[,c("name","proportion","sample", "numUniqueReads", "abundance", "taxID", "genomeSize", "hitratio")])
})

#Final dataframe created for plotting, can change proportion value (Default 1%)
left <- 0.01
final <- llply(props, subset, abundance > 0.05)
final <- llply(final, subset, proportion > .08)
final <- llply(final, subset, hitratio > left)
df <- ldply(final, data.frame)

#E. coli Shigella
df1 <- df[24:42,]
df1$group <- factor(c(rep("0.1/99.9",3), rep("1/99", 3), rep("10/90", 3), rep("50/50", 4), rep("90/10", 2), rep("99/1", 2), rep("99.9/0.1",2)), levels = c("0.1/99.9", "1/99", "10/90", "50/50", "90/10", "99/1", "99.9/0.1"))
df1$sample <- as.factor(c(rep("69",3), rep("70", 3), rep("71", 3), rep("72", 4), rep("73", 2), rep("75", 2), rep("76", 2)))
df1$known <- "E. coli / Shigella flexneri"


#E. coli Staphylococcus saprophyticus
df2 <- df[69:89,]
df2$group <- factor(c(rep("0.1/99.9",3), rep("1/99", 4), rep("10/90", 4), rep("50/50", 4), rep("90/10", 3), rep("99/1", 2), "99.9/0.1"), levels = c("0.1/99.9", "1/99", "10/90", "50/50", "90/10", "99/1", "99.9/0.1"))
df2$sample <- as.factor(c(rep("84",3), rep("85", 4), rep("86", 4), rep("87", 4), rep("88", 3), rep("89", 2), "90"))
df2$known <- "E. coli / S. saprophyticus"

#Live Bug E.coli/S. saprophyticus
df3 <- df[c(84:105, 1:3),]
df3$group <- factor(c(rep("0.1/99.9",3), rep("1/99", 4), rep("10/90", 4), rep("50/50", 4), rep("90/10", 4), rep("99/1", 3), rep("99.9/0.1",3)), levels = c("0.1/99.9", "1/99", "10/90", "50/50", "90/10", "99/1", "99.9/0.1"))
df3$sample <- as.factor(c(rep("91",3), rep("92", 4), rep("93", 4), rep("94", 4), rep("95", 4), rep("96", 3), rep("1",3)))
df3$known <- "Live Bug E.coli / S. saphyticus"

#S. saprophyticus/St. pyogenes
df4 <- df[43:68,]
df4$group <- factor(c(rep("0.1/99.9",3), rep("1/99", 3), rep("10/90", 3), rep("50/50", 4), rep("90/10", 4), rep("99/1", 5), rep("99.9/0.1",4)), levels = c("0.1/99.9", "1/99", "10/90", "50/50", "90/10", "99/1", "99.9/0.1"))
df4$sample <- as.factor(c(rep("77",3), rep("78", 3), rep("79", 3), rep("80", 4), rep("81", 4), rep("82", 5), rep("83",4)))
df4$known <- "S. saprophyticus / St. pyogenes"

dff <- rbind(df1, df2, df4)
dff$type <- c(rep("present", 2), "not present", rep("present", 2), "not present", rep("present", 2), "not present", rep("present", 2), "not present", rep("present", 5), rep("not present", 2), rep("present", 2), rep("not present", 2), rep("present", 2), rep("not present", 2), rep("present", 2), "not present", rep("present", 2), "not present", rep("present", 5), )

#MRSA/MSSA PURE
df5 <- df[8:9,]
df5$group <- factor(c(rep("MSSA", 1), rep("MRSA", 1)), levels = c("MSSA","MRSA"))
df5$sample <- as.factor(c(rep("25",1), rep("26", 1)))

#Ecoli/Shigella Pure
df6 <- df[4:7,]
df6$group <- factor(c(rep("E. coli", 1), rep("Shigella flexneri", 3)), levels = c("E. coli","Shigella flexneri"))
df6$sample <- as.factor(c(rep("23",1), rep("24", 3)))

#S saprophyticus
df7 <- df[10:13,]
df7$group <- "S. saprophyticus"
df7$sample <- "27"

#St. pyogenes
df8 <- df[14:15,]
df8$group <- "St. pyogenes"
df8$sample <- "28"

dfg <- rbind(df5, df6, df7, df8)

#MRSA/MSSA
df9 <- df[15:20,]
df9$group <- factor(c(rep("25", 3), rep("26",3)))

#SCATTER PLOT WITH POINT SIZE

#Set file name and bubble plot title. Stored in out.dir
file_name <- "S. saprophyticus/St. pyogenes"
plot_title <- "Figure 3: Time Series Classification"

text1 <- round(df1$abundance[which(df1$sample == "69")], digits = 2)

tiff('test.tiff', units="in", width=20, height=20, res=300)
png(filename=paste0(out.dir, paste0(file_name,".png")), width = 850, height = 400)
p2 <- ggplot(df9, aes(as.factor(group), as.factor(name))) + geom_point(aes(size = abundance), color = "burlywood3", position=position_nudge(x = .1)) + geom_point(aes(size = proportion), color = "deepskyblue2", position=position_nudge(x = -.1))
p2 <- p2 + theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(size=12))
p2 <- p2 + labs(y = "Organism", x = "Sample")
p2 <- p2 + ggtitle("MRSA/MSSA Centrifuge Proporition vs Abundance Classification") + theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill="white", colour="gray53"))
#p2 <- p2 + guides(colour=F)
p2 <- p2 + geom_text(data = df9, aes(label = round(abundance, digits = 2)), nudge_x = 0.27)
p2 <- p2 + geom_text(data = df9, aes(label = round(proportion, digits = 2)), nudge_x = -0.27)
#p2 <- p2 + facet_grid(known ~ ., scales = "free_y")
print(p2)
dev.off()

#NEW PLOT#
dfe <- dff[which(dff$name == "Escherichia coli"),]
dfg <-dff[which(dff$name == "Staphylococcus saprophyticus"),]
dfh <-dff[which(dff$name == "Shigella flexneri"),]
dfi <-dff[which(dff$name == "Streptococcus pyogenes"),]
dff <- rbind(dfe, dfg, dfh, dfi)
dff$name <- factor(dff$name,levels=rev(unique(dff$name)))
p2 <- ggplot(dff, aes(as.factor(group), as.factor(name))) + geom_point(aes(size = abundance))
p2 <- p2 + theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(size=12))
p2 <- p2 + labs(y = "Organism", x = "Sample", size = "Abundance (%)")
p2 <- p2 + ggtitle("Binary Bug Mix Centrifuge Abundance") + theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill="white", colour="gray53"))
#p2 <- p2 + guides(colour=F)
p2 <- p2 + geom_text(data = dff, aes(label = round(abundance, digits = 2)), nudge_x = 0.27, nudge_y = .40)
p2 <- p2 + theme(axis.text =element_text(size=11), legend.text = element_text(size=12), axis.title.x = element_text(size =12), axis.title.y = element_text(size =12))
p2 <- p2 + facet_grid(known ~ ., scales = "free_y")
print(p2)

svg(filename = "bugmix.svg", width = 9, height =7)
p2
dev.off()


write.csv(df, file = paste0(out.dir, file_name, ".csv"))

df_sub <- df[c(1:2,4,6,8:9,13,14,16:22,23,24,26,27,29,30,32,33,35,36,37,38,39,40,42,44,45,47,49,51,54,55,58,59,62,63,66,67,70,71,74,75,77,78,80,81,82,83,
               86,87,90,91,94,95,97,99,101,103,104),]
df_sub$known <- c(99.9,0.1,rep(100,13),.1,99.9,1,99,10,90,50,50,90,10,99,1,99.9,
                  99.9,99,1,90,10,50,50,10,90,1,99,.1,99,
                  99.9,1,99,10,90,50,50,90,10,99,1,99.9,
                  99.9,1,99,10,90,50,50,90,10,99,1)

loglm_abund <- lm(log(df_sub$abundance) ~ log(df_sub$known))
loglm_prop <- lm(log(df_sub$proportion) ~ log(df_sub$known))

p3 <- ggplot(df_sub, aes(x=log(df_sub$proportion), y=log(df_sub$known))) + geom_point() + geom_smooth(method = "lm")
p3 <- p3 + ggtitle("Bug Mix Proportion vs. Known: R-squared = 90.52") + theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill="white", colour="gray53"))

p3
#STATISTICS------------------------------------------#
error <- qt(0.975,df=length(df$hitratio)-1)*sd(df$hitratio)/sqrt(length(df$hitratio))
left <- mean(df$hitratio)-error
right <- mean(df$hitratio)+error



#SCRATCH---------------------------------------------#
name <- c("E. coli", "Shigella", "Sap")
prop <- c(5, 10, 15)
abund <- c(3, 6, 9, 5, 10, 15)
sample <- c(rep("a", 3), rep("b", 3))
type <- c(rep("prop", 2), rep("abund", 4))
df <- data.frame(name,prop, abund, sample, type)

p2 <- ggplot(df, aes(as.factor(sample), as.factor(name))) + geom_point(aes(size = prop, color = type), position=position_nudge(x = .1)) + geom_point(aes(size = abund, color = type), position=position_nudge(x = -.1))
p2 <- p2 + theme(axis.text.x = element_text(angle = 45, hjust = 1), text = element_text(size=14))
p2 <- p2 + labs(y = "Organism", x = "Sample")
p2 <- p2 + ggtitle("E. coli/Shigella flexneri Pure") + theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill="gray95", colour="white"))
#p2 <- p2 + guides(colour=F)
p2 <- p2 + geom_text(data = df, aes(label = round(abund, digits = 2)), nudge_x = 0.27)
p2 <- p2 + facet_grid(. ~ sample, scales = "free_x")
p2
