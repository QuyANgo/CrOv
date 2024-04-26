# Make bar graphs for cell counts & proportions of TR & NTR clones per CD8 cluster

options("download.file.method"="wininet") # IMPORTANT to install packages from CRAN!!!!

setwd("C:/Users/Susan/Desktop/CrOv")

library(tidyverse)
library(data.table)
library(Seurat)


# Load table with all 5272 cells of cleaned CD8 & add cluster labels
data = read.table("CD8_CrOv.9pt_all.5272cells_with_TRscores_by_8.signatures_and_cellWisePrediction_by_CrOv.signature_20240424.txt", sep = "\t", header = T)

# '0' = 'naive/CM', '1' = 'EM', '2' = 'exhausted', '3' = 'cytotoxic', '4' = 'cycling', '5' = 'HSP', '6' = 'MAIT', '7' = 'NKlike/EMRA', '8' = 'CM'

# Load CD8pr object
CD8pr <- readRDS("./20230830_CrOv.9pt_full.pipeline/intgHarCD8pr_CrOv.9pt_23pc.30k_res0.7_20230922.rds")
CD8pr <- RenameIdents(CD8pr, '0' = 'naive/CM', '1' = 'EM', '2' = 'exhausted', '3' = 'cytotoxic', '4' = 'cycling', '5' = 'HSP', '6' = 'MAIT', '7' = 'NKlike/EMRA', '8' = 'CM')

CD8pr$cluster_label = Idents(CD8pr)

meta = FetchData(CD8pr, vars = c("annotated_reactivity", "cluster_label")) %>% 
  rownames_to_column(var = "barcode") %>% left_join(data)

CD8tr <- meta %>% filter(annotated_reactivity != "ND") %>% 
  group_by(annotated_reactivity, cluster_label, .drop = F) %>% 
  summarise(cellNb = n()) %>%
  #ungroup() %>% 
  group_by(cluster_label) %>% 
  mutate(proportion = cellNb/sum(cellNb))

CD8tr$annotated_reactivity <- factor(CD8tr$annotated_reactivity, levels = c("reactive", "nonreactive"))


# plot
pdf("CD8_CrOv.9pt_distribution_of_TR.and.NTR.clones_per_cluster_20240425.pdf", width = 7, height = 4)

ggplot(CD8tr, aes(x = cluster_label, y = proportion, fill = annotated_reactivity)) +
  geom_bar(stat = "identity", position = "stack") +
  geom_text(aes(label = cellNb), size = 3, position = position_stack(vjust = 0.5), color = "black") +
  ylab("proportion with cell number") +
  xlab("") +
  ggtitle("Distribution of annotated TR and NTR clones per CD8 cluster") +
  scale_x_discrete(expand = c(0,0, 0,0)) +
  scale_y_continuous(expand = c(0,0, 0.03,0)) +
  theme_classic() +
  theme(legend.title = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(angle = -20, vjust = 0, hjust = 0.3, size = 12))

dev.off()
  

