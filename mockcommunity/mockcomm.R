library(ggplot2)

setwd("/Users/jetjr/mockcommunity/mcom/new/")
clark <- read.csv("IonXpress_029_PR-CARTMAN-77_staggered.fasta.abundance.csv")
names(clark) <- c("name", "Lineage", "numReads", "Proportion_All", "abundance")
clark$abundance <- as.numeric(as.character(clark$abundance))
clark_sub <- subset(clark, abundance > 0.01, select = c("name", "abundance"))
clark_sub <- clark_sub[c(1:5,7:16,19,21,23:25),]

known <- c(0.22, 0.05, 0.88, 0.02, 0.78, 0.03, 0.03, 15.59, 0.55, 0.18, 0.18, 0.27, 0.36, 2.70, 31.28, 2.24, 21.65, 1.54, 21.44, 0.03)

df <- cbind(clark_sub, known)
df$method <- "CLARK"
lm1 <- lm(log(df$abundance) ~ log(df$known))

p1 <- ggplot(df, aes(x=log(abundance), y=log(known))) + geom_point() + geom_smooth(method=lm, color = "red")
p1

centrifuge <- read.delim("IonXpress_029_PR-CARTMAN-77_staggered-centrifuge_newdb_report.tsv")
centrifuge$abundance <- centrifuge$abundance * 100
cent_sub <- subset(centrifuge, abundance > 0.01, select = c("name", "abundance"))
cent_sub <- cent_sub[c(1:16, 18:22,24:28),]

# CORRECT DUPLICATES

name <- c("Helicobacter pylori", "Pseudomonas aeruginosa", "Acinetobacter baumannii", "Neisseria meningitidis", "Escherichia coli",
          "Rhodobacter sphaeroides", "Staphylococcus aureus", "Staphylococcus epidermidis", "Streptococcus mutans", "Streptococcus agalactiae",
          "Streptococcus pneumoniae", "Enterococcus faecalis", "Bacillus cereus", "Clostridium beijerinckii", "Listeria monocytogenes", 
          "Cutibacterium acnes", "Deinococcus radiodurans", "Lactobacillus gasseri", "Bacteroides vulgatus", "Actinomyces odontolyticus")
abundance <- c(0.92, 4.83, 0.38, 0.58, 12.52, 24.08, 2.41, 20.69, 23.59, 2.8, 0.03, 0.03, 1.49, 1.15, 0.29, 0.96, 0.02, 0.38, 0.05, 0.06)
known <- c(0.55, 2.71, 0.22, 0.27, 15.59, 31.28, 2.24, 21.44, 21.52, 1.54, 0.03, 0.03, 0.88, 0.78, 0.18, 0.36, 0.03, 0.18, 0.02, 0.05)

df1 <- data.frame(name, abundance, known)
df1$method <- "Centrifuge-Comprehensive"

lm1 <- lm(abundance ~ known)

setwd("/Users/jetjr/mockcommunity/mcom/new")
centrifuge2 <- read.delim("IonXpress_029_PR-CARTMAN-77_staggered-centrifuge_report.tsv")
centrifuge2$abundance <- centrifuge2$abundance * 100
cent_sub2 <- subset(centrifuge2, abundance > 0.01, select = c("name", "abundance"))
known <- c(0.55, 2.70, 0.22, 0.27, 15.59, 0.02, 31.28, 2.24, 21.44, 0.03, 21.52, 1.54, 0.03, 0.03, 0.88, 0.78, 0.18, 0.18, 0.05, 0.36)
df2 <- cbind(cent_sub2, known)
df2$method <- "Centrifuge-Restrictive"
lm1 <- lm(df$abundance ~ df$known)


combine <- rbind(df, df1, df2)

lm1 <- lm(log(df2$abundance) ~ log(df2$known))
p2 <- ggplot(combine, aes(x=abundance, y=known, color = method)) + geom_point(aes(shape=method), size=3) + geom_smooth(method=lm, se = F)
p2 <- p2 + ggtitle("Centrifuge vs CLARK: Known Staggered Mock Community") + theme(plot.title = element_text(hjust = 0.5, size = 12, face = "bold"), panel.background = element_rect(fill="white", colour="black"))
p2 <- p2 + theme(legend.title=element_blank(), axis.text =element_text(size=12), legend.text = element_text(size=12), axis.title.x = element_text(size =12), axis.title.y = element_text(size =12))
p2 <- p2 + labs(x = "Experimental Abundance", y = "Known Abundance")
p2 <- p2 + annotate("text", x = 4.00, y = 33.50, label = "R-squared = 0.9664", color = "#F8766D", size = 4)
p2 <- p2 + annotate("text", x = 4.00, y = 31.50, label = "R-squared = 0.9720", color = "#619CFF", size = 4)
p2 <- p2 + annotate("text", x = 4.00, y = 29.50, label = "R-squared = 0.9799", color = "#00BA38", size = 4)
p2 <- p2 + geom_abline(intercept = 0, slope = 1, linetype="dashed")
p2

svg(filename = "centvclark2.svg", width = 8, height =4)
p2
dev.off()


grid.arrange(p1, p2, ncol = 2)
