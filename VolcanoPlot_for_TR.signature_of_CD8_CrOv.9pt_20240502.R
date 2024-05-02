# Plot volcano for TR signature of CD8

options("download.file.method"="wininet") # IMPORTANT to install packages from CRAN!!!!

setwd("C:/Users/Susan/Desktop/CrOv")


library(tidyverse) # includes ggplot2, for data visualisation. dplyr, for data manipulation.
library(RColorBrewer) # for a colourful plot
library(ggrepel) 

df <- read.table("20230830_CrOv.9pt_full.pipeline/CrOv.9pt_CD8.allAnnotatedTCRs_tumor.reactivity_reactive_vs_nonreactive_LR.test_all.DEgenes_0.1cells_20230917.txt", header = T) %>% 
  mutate(DE = ifelse(log2FC >= 0.5 & padj <= 0.01, "UP",
                     ifelse(log2FC < -0.5 & padj <= 0.01, "DOWN",
                            "NS")
  ))
df$DE <- factor(df$DE)
df$DElabel = ifelse(df$DE == "NS", NA, df$gene)

write.table(df, "CD8_CrOv.9pt_all.DEgenes_for_volcano.plot_TR.vs.NTR_LR.test_0.1cell_20230502.txt",
            sep = "\t", row.names = F)

#DElab <- df %>% filter(!is.na(DElabel))
  
p <- ggplot(data = df, aes(x = log2FC, y = -log10(p_val), color = DE, label = DElabel, alpha = 0.8)) +
  geom_vline(xintercept = c(-0.5, 0.5), col = "gray", linetype = 'dashed') +
  geom_hline(yintercept = -log10(0.01), col = "gray", linetype = 'dashed') + 
  geom_point(size = 0.3) + 
  scale_color_manual(values = c("#00AFBB", "grey", "#bb0c00"), # to set the colours of our variable  
                     labels = c("Downregulated", "Not significant", "Upregulated")) + # to set the labels in case we want to overwrite the categories from the dataframe (UP, DOWN, NO)
  #coord_cartesian(ylim = c(0, 50), xlim = c(-10, 10)) + # since some genes can have minuslog10padj of inf, we set these limits
  labs(color = '', #legend_title, 
       x = expression("log"[2]*"FC"), y = expression("-log"[10]*"p-value")) + 
  scale_x_continuous(breaks = seq(-10, 10, 2)) + # to customise the breaks in the x axis
  scale_y_continuous(breaks = seq(0, 30, 5)) +
  ggtitle("Tumor reactive signature of CD8 T-cells from CrOv.9pt") +
  theme_classic() +
  geom_text(check_overlap = F, vjust = 0, nudge_y = 0.2, size=1.5) #+
  #geom_text_repel(max.overlaps = Inf) # To show all labels 

p

pdf("CD8_CrOv.9pt_tumor.reactive.signature_by_volcano.plot_20240502.pdf", width = 8, height = 6)
p
dev.off()





# Note. with coord_cartesian() even if we have genes with p-values or log2FC ourside our limits, they will still be plotted.
