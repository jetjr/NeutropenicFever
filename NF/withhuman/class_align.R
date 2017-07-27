library(data.table)

#READ CENTRIFUGE HITS FILES
df <- fread("NF001-centrifuge_hits.tsv")

#DETERMINE HUMAN AND MICROBIAL HITS
human <- length(unique(df$readID[which(df$taxID == "9606")]))
microbial <- length(unique(df$readID[which(df$taxID != "9606")]))

#USE ALL READ IDS FROM FILE AND CROSS REFERENCE WITH READ IDS THAT WERE CLASSIFIED TO DETERMINE UNKNOWN. ID LIST WAS OBTAINED BY - grep '>' NF001.fasta > NF001.ids

ids <- unique(df$readID)
id_list <- scan("NF001.ids", sep = "\n", what = "numeric")

#GET LIST OF IDS NOT INCLUDED IN FULL ID LIST
unknown <- setdiff(id_list, ids)

length(unknown)
