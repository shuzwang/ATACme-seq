### Function to visualize the enrichment results:
experiment_list = list.files("~/Desktop/enrichment_results/",pattern = ".bed")
experiment_name_list = gsub(".bed","",experiment_list)
setwd("~/Desktop/enrichment_results/")
#enrich_analysis_plot_list = list()

enrich_analysis_prep = function(experiment_list){
  library(ggplot2)
  enrich_analysis_list = list()
  if(length(experiment_list) == 1){
    enrich_analysis_list = read.delim(experiment_list,sep = "\t",header = T,stringsAsFactors = F)
    enrich_analysis_list[,"experiment_name"] = experiment_name_list
    
    enrich_analysis_list$annotation = as.factor(enrich_analysis_list$annotation)
    enrich_analysis_list$star = ""
    enrich_analysis_list$star[enrich_analysis_list$qvalue <= 0.05] = "*"
    enrich_analysis_list$star[enrich_analysis_list$qvalue <= 0.01] = "**"
    enrich_analysis_list$star[enrich_analysis_list$qvalue <= 0.001] = "***"
    enrich_analysis_list$star[enrich_analysis_list$qvalue > 0.05] = "ns"
    
    gplot = ggplot(enrich_analysis_list,aes(x = annotation,y = log2(fold))) + 
      geom_bar(aes(fill=annotation), stat="identity", width=0.5, colour="black") +
      geom_text(aes(label=star), colour="red", vjust=0.8, size=7,hjust =1,position = position_stack(vjust = 0)) + 
      theme(strip.text.x = element_text(size=7,hjust = 0),panel.background = element_rect(fill="white", colour="black"), axis.text.y = element_text(hjust=0, size=10),panel.grid = element_blank(),legend.position = "none") +
      labs(x = "",y = "log2(Fold Enrichment)") + coord_flip() + geom_hline(yintercept = 0,color="red",linetype="dotted",size=1.5)
  }
  else{
    for(i in 1:length(experiment_list)){
      enrich_analysis_list[[i]] = read.delim(experiment_list[i],sep = "\t",header = T,stringsAsFactors = F)
      enrich_analysis_list[[i]][,"experiment_name"] = experiment_name_list[i]
    }
    
    enrich_analysis_combined = enrich_analysis_list[[1]]
    for(i in 2:length(experiment_list)){
      enrich_analysis_combined = rbind(enrich_analysis_combined,enrich_analysis_list[[i]])
    }
    
    enrich_analysis_combined$annotation = as.factor(enrich_analysis_combined$annotation)
    enrich_analysis_combined$star = ""
    enrich_analysis_combined$star[enrich_analysis_combined$qvalue <= 0.05] = "*"
    enrich_analysis_combined$star[enrich_analysis_combined$qvalue <= 0.01] = "**"
    enrich_analysis_combined$star[enrich_analysis_combined$qvalue <= 0.001] = "***"
    enrich_analysis_combined$star[enrich_analysis_combined$qvalue > 0.05] = "ns"
    
    gplot = ggplot(enrich_analysis_combined,aes(x = annotation,y = log2(fold))) + 
      geom_bar(aes(fill=annotation), stat="identity", width=0.8, colour="black") +
      geom_text(aes(label=star), colour="red", vjust=0.8, size=2,hjust =1,position = position_stack(vjust = 0)) + 
      facet_wrap(~experiment_name, nrow=2) +
      theme(strip.text.x = element_text(size=7,hjust = 0),panel.background = element_rect(fill="white", colour="black"), axis.text.y = element_text(hjust=0, size=7),panel.grid = element_blank(),legend.position = "none") +
      labs(x = "",y = "log2(Fold Enrichment)") + coord_flip()
  }
  
  return(gplot)
}
