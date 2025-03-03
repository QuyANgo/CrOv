# Make bar graphs for cell counts & proportions of TR & NTR clones per CD8 cluster

options("download.file.method"="wininet") # IMPORTANT to install packages from CRAN!!!!

setwd("C:/Users/Susan/Desktop/CrOv")

library(tidyverse)
library(data.table)
library(ggpattern)
library(Seurat)


# Load table with all 5272 cells of cleaned CD8 & add cluster labels
data = read.table("CD8_CrOv.9pt_all.5272cells_with_TRscores_by_8.signatures_and_cellWisePrediction_by_CrOv.signature_20240424.txt", sep = "\t", header = T)


# Load CD8pr object
CD8pr <- readRDS("./20230830_CrOv.9pt_full.pipeline/intgHarCD8pr_CrOv.9pt_23pc.30k_res0.7_20230922.rds")
CD8pr <- RenameIdents(CD8pr, '0' = 'naive/CM', '1' = 'EM', '2' = 'exhausted', '3' = 'cytotoxic', '4' = 'cycling', '5' = 'HSP', '6' = 'MAIT', '7' = 'NKlike/EMRA', '8' = 'CM')

CD8pr$cluster_label = Idents(CD8pr)

meta = FetchData(CD8pr, vars = c("annotated_reactivity", "cluster_label")) %>% 
  rownames_to_column(var = "barcode") %>%
  left_join(data) %>% 
  mutate(CancerType = ifelse(Patient %in% c("OvCa1637", "OvCa1682", "OvCa1809", "OvCa210"), "OV", "CR"))

write.table(meta, "CD8_CrOv.9pt_all.5272.cells_all.data_20240425.txt", sep = "\t", row.names = F)

CD8tr <- meta %>% filter(annotated_reactivity != "ND") %>% 
  group_by(CancerType, annotated_reactivity, cluster_label, .drop = F) %>% 
  summarise(cellNb = n()) #%>%
  #ungroup() %>% 
  #group_by(cluster_label) %>% 
  #mutate(proportion = cellNb/sum(cellNb))

CD8tr$annotated_reactivity <- factor(CD8tr$annotated_reactivity, levels = c("reactive", "nonreactive"))


# plot
pdf("CD8_CrOv.9pt_distribution_of_TR.and.NTR.cells_per_cluster_20240425.pdf", width = 7, height = 4)

ggplot(CD8tr, aes(x = cluster_label, y = cellNb, 
                  fill = annotated_reactivity, pattern = CancerType
                  #alpha = 0.6
                  )) +
  geom_bar_pattern(stat = "identity",
                   position = position_dodge(width = 0.8), # use "dodge" for side-by-side bars, "stack" for stacked bars
                   color = NA, # color of bar border 
                   pattern_fill = "white", # color of pattern
                   pattern_density = 0.05, #size
                   pattern_spacing = 0.01) +
  scale_fill_manual(values = c("orange", "lightblue")) +
  scale_pattern_manual(values = c(CR = "none", OV = "circle")) +
  #scale_pattern_angle_manual(values = c(0, 90)) +
  #scale_fill_manual(values = c("gold1", "darkorange", "lightblue", "royalblue")) +
  #facet_grid(~ Patient, switch = "x") +
  scale_x_discrete(expand = c(0,0, 0,0)) +
  scale_y_continuous(expand = c(0.01,0, 0.04,0)) +
  
  guides(pattern = guide_legend(override.aes = list(fill = "grey", color = "white"), title = "cancer type"), # override default legend style
         #pattern_angle = guide_legend(override.aes = list(fill = "white", color = "black")),
         fill = guide_legend(override.aes = list(pattern = "none"), title = "annotated reactivity")
  ) +
  
  #geom_point(position = position_dodge(width=0.2)) +
  geom_text(aes(label = cellNb), size = 2.5, 
            position = position_dodge(width = 0.8), vjust = -0.2,
            color = "black") +
  ylab("cell number") +
  xlab("") +
  ggtitle("Distribution of annotated TR and NTR cells per CD8 cluster") +
  #scale_shape_manual(values = c(1,3)) +
  #scale_y_log10() +
  #scale_x_discrete(expand = c(0,0, 0,0)) +
  #scale_y_continuous(expand = c(0,0, 0.03,0)) +
  #theme_classic() +
  theme(legend.title = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(angle = -20, vjust = 0, hjust = 0.3, size = 12))

dev.off()
  

