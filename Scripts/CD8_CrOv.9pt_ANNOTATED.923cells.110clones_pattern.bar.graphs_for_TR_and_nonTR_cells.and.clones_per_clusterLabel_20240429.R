# Make bar graphs for cell counts & proportions of TR & NTR clones per CD8 cluster

options("download.file.method"="wininet") # IMPORTANT to install packages from CRAN!!!!

setwd("C:/Users/Susan/Desktop/CrOv")

library(tidyverse)
library(data.table)
library(ggpattern)
library(Seurat)

# 
# # Load table with all 5272 cells of cleaned CD8 & add cluster labels
# data = read.table("CD8_CrOv.9pt_all.5272cells_with_TRscores_by_8.signatures_and_cellWisePrediction_by_CrOv.signature_20240424.txt", sep = "\t", header = T)
# 
# 
# # Load CD8pr object
# CD8pr <- readRDS("./20230830_CrOv.9pt_full.pipeline/intgHarCD8pr_CrOv.9pt_23pc.30k_res0.7_20230922.rds")
# CD8pr <- RenameIdents(CD8pr, '0' = 'activatedRM', '1' = 'EM', '2' = 'exhausted', '3' = 'cytotoxic', '4' = 'cycling', '5' = 'HSP', '6' = 'MAIT', '7' = 'NKlike/EMRA', '8' = 'CM')
# 
# CD8pr$cluster_label = Idents(CD8pr)
# 
# meta = FetchData(CD8pr, vars = c("annotated_reactivity", "cluster_label")) %>%
#   rownames_to_column(var = "barcode") %>%
#   left_join(data) %>%
#   mutate(CancerType = ifelse(Patient %in% c("OvCa1637", "OvCa1682", "OvCa1809", "OvCa210"), "OV", "CR"))
# 
# meta$cluster_label <- factor(meta$cluster_label,
#                              levels = c('activatedRM', 'EM', 'exhausted', 'cytotoxic', 'cycling', 'HSP', 'MAIT', 'NKlike/EMRA', 'CM'))

clusterColor <- c("#D2185C", "#E06DBB", "#FFC107", "#D8D274", "#517D36", "#49E8F1", "#318AD8",  "#917D87", "#7A43BF")


# write.table(meta, "CD8_CrOv.9pt_all.5272.cells_all.data_20240429.txt", sep = "\t", row.names = F)


meta <- read.table("CD8_CrOv.9pt_all.5272.cells_all.data_20240429.txt", header = T)

# # Re-do UMAP with corrected cluster labels for CD8 seurat object
# pdf("CD8_CrOv.9pt_clusterLabels_20230429.pdf", width = 7, height = 6)
# print(DimPlot(CD8pr, reduction = "umap", #group.by = "newSubcluster",
#               #cols = distinctColorPalette(length(unique(Idents(CD8pr)))),
#               cols = clusterColor,
#               label = T, repel = T
# ))
# dev.off()


# Subset CD8tr
CD8tr <- meta %>% filter(annotated_reactivity != "ND")

CD8tr$annotated_reactivity <- factor(CD8tr$annotated_reactivity, 
                                     levels = c("reactive", "nonreactive"))


# 1. Plot at CLUSTER per CancerType level
CD8tr1 <- CD8tr %>% #filter(annotated_reactivity != "ND") %>% 
  group_by(CancerType, annotated_reactivity, cluster_label, .drop = F) %>% 
  summarise(cellNb = n()) %>%
  ungroup() %>% 
  group_by(CancerType, cluster_label, .drop = F) %>% 
  mutate(proportion = cellNb/sum(cellNb))

# CD8tr1b <- CD8tr %>% filter(annotated_reactivity != "ND") %>% 
#   group_by(CancerType, cluster_label, annotated_reactivity, cloneID, .drop = F) %>% 
#   summarise(cloneNb = n()) #%>%
#ungroup() %>% 
#group_by(cluster_label) %>% 
#mutate(proportion = cellNb/sum(cellNb))


# plot
pdf("CD8_CrOv.9pt_distribution_of_TR.and.NTR_cells_per_cluster_20240502.pdf", width = 9, height = 4)

# cell number
ggplot(CD8tr1, aes(x = cluster_label, y = cellNb, 
                  fill = annotated_reactivity, pattern = CancerType
                  #alpha = 0.6
                  )) +
  geom_bar_pattern(stat = "identity",
                   position = position_dodge(width = 0.9), # use "dodge" for side-by-side bars, "stack" for stacked bars
                   color = "grey", # color of bar border 
                   pattern_fill = "white", # color of pattern
                   pattern_density = 0.01, #size
                   pattern_spacing = 0.02) +
  scale_fill_manual(values = c("orange", "lightblue")) +
  scale_pattern_manual(values = c(CR = "none", OV = "circle")) +
  #scale_pattern_angle_manual(values = c(0, 90)) +
  #facet_grid(~ Patient, switch = "x") +
  scale_x_discrete(expand = c(0,0, 0,0)) +
  scale_y_continuous(expand = c(0.01,0, 0.04,0)) +
  
  guides(pattern = guide_legend(override.aes = list(fill = "grey", color = "white"), title = "cancer type"), # override default legend style
         #pattern_angle = guide_legend(override.aes = list(fill = "white", color = "black")),
         fill = guide_legend(override.aes = list(pattern = "none"), title = "annotated reactivity")
  ) +
  
  #geom_point(position = position_dodge(width=0.2)) +
  geom_text(aes(label = cellNb), size = 2.5, 
            position = position_dodge(width = 0.9), vjust = -0.2,
            color = "black") +
  ylab("cell number") +
  xlab("") +
  ggtitle("Number of annotated TR and NTR cells per CD8 cluster") +
  #scale_shape_manual(values = c(1,3)) +
  #scale_y_log10() +
  #scale_x_discrete(expand = c(0,0, 0,0)) +
  #scale_y_continuous(expand = c(0,0, 0.03,0)) +
  theme_classic() +
  theme(legend.title = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(angle = -20, vjust = 0, hjust = 0.3, size = 12))


# cell proportion
ggplot(CD8tr1, aes(x = cluster_label, y = proportion, 
                  fill = annotated_reactivity, pattern = CancerType
                  #alpha = 0.6
)) +
  geom_bar_pattern(stat = "identity",
                   position = "stack", # use "dodge" for side-by-side bars, "stack" for stacked bars
                   color = "grey", # color of bar border 
                   pattern_fill = "white", # color of pattern
                   pattern_density = 0.01, #size
                   pattern_spacing = 0.02) +
  scale_fill_manual(values = c("orange", "lightblue")) +
  scale_pattern_manual(values = c(CR = "none", OV = "circle")) +
  #scale_pattern_angle_manual(values = c(0, 90)) +
  facet_grid(~ CancerType, switch = "x") +
  scale_x_discrete(expand = c(0,0, 0,0)) +
  scale_y_continuous(expand = c(0.01,0, 0.04,0)) +
  
  guides(pattern = guide_legend(override.aes = list(fill = "grey", color = "white"), title = "cancer type"), # override default legend style
         #pattern_angle = guide_legend(override.aes = list(fill = "white", color = "black")),
         fill = guide_legend(override.aes = list(pattern = "none"), title = "annotated reactivity")
  ) +
  
  #geom_point(position = position_dodge(width=0.2)) +
  geom_text(aes(label = cellNb), size = 3.5, 
            position = position_stack(vjust = 0.5),
            color = "blue") +
  ylab("cell proportion with cell number") +
  xlab("") +
  ggtitle("Proportion & number of annotated TR and NTR cells per CD8 cluster") +
  #scale_shape_manual(values = c(1,3)) +
  #scale_y_log10() +
  #scale_x_discrete(expand = c(0,0, 0,0)) +
  #scale_y_continuous(expand = c(0,0, 0.03,0)) +
  theme_classic() +
  theme(legend.title = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(angle = -45, vjust = 0.5, hjust = 0.0, size = 12))

dev.off()


# 2. Plot at CLONE per CancerType level
CD8tr2 <- CD8tr %>% group_by(CancerType, annotated_reactivity, cloneID, cluster_label) %>% 
  summarise(cellNb = n())

# plot
pdf("CD8_CrOv.9pt_distribution_of_TR.and.NTR.cells_per.cluster_per.clonotype_20240429.pdf",
    width = 7, height = 14)
ggplot(CD8tr2, aes(x = cloneID, y = cellNb, 
                   fill = cluster_label, pattern = annotated_reactivity
                  )) +
  geom_bar_pattern(stat = "identity",
                   position = "stack", # use "dodge" for side-by-side bars, "stack" for stacked bars
                   color = NA, # color of bar border 
                   pattern_fill = "white", # color of pattern
                   pattern_density = 0.005, #size
                   pattern_spacing = 0.01) +
  scale_fill_manual(values = clusterColor) +
  scale_pattern_manual(values = c(nonreactive = "none", reactive = "circle")) +
  #scale_pattern_angle_manual(values = c(0, 90)) +
  #facet_grid(~ CancerType, switch = "x") +
  scale_x_discrete(expand = c(0,0, 0,0)) +
  scale_y_continuous(expand = c(0,0, 0.03,0),
                     breaks = c(0, 5, 10, 20, 30, 40, 50, 60, 70, 80)) +
  
  guides(pattern = guide_legend(override.aes = list(fill = "grey", color = "white"), title = "tumor reactivity"), # override default legend style
         #pattern_angle = guide_legend(override.aes = list(fill = "white", color = "black")),
         fill = guide_legend(override.aes = list(pattern = "none"), title = "cluster")
  ) +
  
  #geom_point(position = position_dodge(width=0.2)) +
  # geom_text(aes(label = cellNb), size = 2.5, 
  #           position = position_dodge(width = 0.9), vjust = -0.2,
  #           color = "black") +
  ylab("cell count") +
  xlab("clonotype") +
  ggtitle("Distribution of annotated TR and NTR cells",
          subtitle = "per CD8 cluster per clonotype") +
  theme_classic() +
  theme(#legend.title = element_blank(),
        #axis.ticks.x = element_blank(),
        axis.text.x = element_text(#angle = -90, 
                                   size = 10),
        axis.text.y = element_text(size = 8),
        panel.grid.major.x = element_line(linetype = "dashed")) +
  coord_flip()

dev.off()


# cellCount_CD8_ord <- cellCount_CD8 %>% arrange(cellCount) %>% 
#   mutate(clone = as.character(annotated_clone)) %>% 
#   mutate(reactivity = as.character(annotated_reactivity)) %>% ungroup() %>% 
#   select(clone, reactivity, cellCount)
# cellCount_CD8_ord$clone <- factor(cellCount_CD8_ord$clone, levels = rev(unique(cellCount_CD8_ord$clone)))
# 
# cellCountPlot(cellCount_CD8_ord, cellCount_CD8_ord$cellCount, "cell.counts", "CrOv.9patients.ordered", "CD8")



