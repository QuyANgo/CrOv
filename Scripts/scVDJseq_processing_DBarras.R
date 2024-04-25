format_10X <- function(VDJ){
  
  VDJ[]<-lapply(VDJ,as.character) # Transform factors into character
  
  # Remove the few multi-mapping chains
  if(length(which(VDJ$chain=="Multi"))>0){VDJ<-VDJ[-which(VDJ$chain=="Multi"),]} 
  
  # Remove non-productive CD3 (out of frame)
  if(length(which(VDJ$productive=="False"))>0){VDJ<-VDJ[-which(VDJ$productive=="False"),]} 
  
  # Keep those that are attributed to a cell
  if(length(which(VDJ$is_cell=="False"))>0){VDJ<-VDJ[-which(VDJ$is_cell=="False"),]} 
  
  # Remove the cells that have 4 chains
  duplets<-names(which(table(VDJ$barcode)==4))
  if(length(duplets)>0){VDJ<-VDJ[-which(VDJ$barcode %in% duplets),]}
  
  # Keep the total number of cells for percentage
  VDJ$total_number_cells<-length(unique(VDJ$barcode))
  
  # Separate alpha and beta chains in two files
  VDJ_a<-VDJ[which(VDJ$chain=="TRA"),]
  VDJ_b<-VDJ[which(VDJ$chain=="TRB"),]
  
  # Create unique ID
  VDJ_a$unique_id<-paste(VDJ_a$v_gene,VDJ_a$j_gene,VDJ_a$cdr3,sep="_")
  VDJ_b$unique_id<-paste(VDJ_b$v_gene,VDJ_b$j_gene,VDJ_b$cdr3,sep="_")
  return(list("alpha"=VDJ_a,"beta"=VDJ_b))
}