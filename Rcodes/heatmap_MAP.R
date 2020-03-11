
mkdir <- function(d){
if (! file.exists(d)){
    dir.create(file.path(d))
   }
}


#source("Decorate.r") 
#library(pheatmap)
library(ggplot2)
library(RColorBrewer)
library(viridis)
heatmap_name='bcc.all.'
out='d_input_bcc/combined.txt'
table_r = read.table(out,sep='\t',header=T,row.names=1)
#cell_mean.shape
head(table_r)
table_r=table_r[order(table_r$DB),]
x=quantile(table_r$DF)
x
#table_r=table_r[as.numeric(table_r$DF)<x[2]|as.numeric(table_r$DF)>x[4],]
table_r_sample_low=table_r[as.numeric(table_r$DF)<x[2],]
out='d_input_bcc/sample_back.txt'
write.table(table_r_sample_low,out,sep='\t',quote=F)
table_r_sample_high=table_r[as.numeric(table_r$DF)>x[4],]
out='d_input_bcc/sample_front.txt'
write.table(table_r_sample_high,out,sep='\t',quote=F)
#table_r_sample_medium=table_r[as.numeric(table_r$DF)<x[4] && as.numeric(table_r$DF)>x[2],]
Danno=c(rep("HD-low",length(table_r_sample_low[,1])),
  rep("HD-medium",length(table_r[,1])-length(table_r_sample_high[,1])-length(table_r_sample_low[,1])),
  rep("HD-high",length(table_r_sample_high[,1])))
dim(table_r)
table_r=data.frame(Danno,table_r)

library(ComplexHeatmap)
library(circlize)
library(gplots)
library(scales)

#head(table_r)
data=table_r[,2:(length(table_r[1,])-9)] #rowsplit error, change the number in minus
#class(data)='numeric'
#head(data)
dim(data)
#data=t(data)
data=scale(data)
#data=t(data)
#data=data.frame(data)
head(data)
col="deepskyblue2"

coln=4
#f2=colorRamp2(seq(0,1,length = coln), colorpanel(coln,"black","yellow","yellow"), space = "RGB") 
f2=colorRamp2(c(0,1), c("yellow", "red"))
f2=colorRamp2(c(min(data),-0.725,max(data)-3), c("black","black","yellow"))#rev(colorRampPalette(brewer.pal(11, "RdYlBu"))(2000))
#f2=colorRamp2(c(min(data), min(data)/2, 0, max(data)-3), c("white", "cornflowerblue", "yellow", "red"))

col_fun = colorRamp2(c(min(table_r$DF), mean(table_r$DF), max(table_r$DF)), c("black", "grey","red"))
coln=5
col_fun = colorRamp2(seq(min(table_r$DF),max(table_r$DF),length = coln), colorpanel(coln,"white","darkcyan","darkcyan"), space = "RGB") 
col_fun_DB = colorRamp2(c(min(table_r$DB), max(table_r$DB)), c("#00441b", "#f7fcfd"))
col_fun_Sscore = colorRamp2(c(min(table_r$Sscore), max(table_r$Sscore)), c("white", "red"))
col_fun_Fscore = colorRamp2(c(min(table_r$Fscore), max(table_r$Fscore)), c("white", "green"))
color_response=c("Yes" = "green", "No" = "red")

row_ha_top = HeatmapAnnotation(
   HD_type=table_r$Danno,
   Db = table_r$DB,
  Response=table_r$R,
  Acquisition=table_r$treat,
  #sample_source=table_r$sample_source, 
  #sample=table_r$samp,
  #type=table_r$type,
  col=list(
    HD_type=c("HD-low"="cadetblue1","HD-high"="darkorange2","HD-medium"='azure4'),
    Db=col_fun,
    Response=color_response,
    Acquisition=c("pre"="#1f78b4","post"="#b2df8a")
    #sample_source=c("tumor"="black","CD45"="grey")
    #type=c('front'="red","medium"="pink","back"="yellow","unsorted"="grey")
    ),
  simple_anno_size = unit(1, "cm")
  )

row_ha_bottom = HeatmapAnnotation(
 
  Df=table_r$DF,
  S=table_r$Sscore,
  F=table_r$Fscore,
  
  #sample_source=table_r$sample_source, 
  #sample=table_r$samp,
  #type=table_r$type,
  col=list(
    Db=col_fun_DB,
    Df=col_fun,
    S=col_fun_Sscore,
    F=col_fun_Fscore
    #sample_source=c("tumor"="black","CD45"="grey")
    #type=c('front'="red","medium"="pink","back"="yellow","unsorted"="grey")
    )
  )
class(table_r$DF)

high=data.frame(table_r[table_r$DF>-1,1:2])
dim(high)[1]
n_high=dim(high)[1]
n_low=dim(table_r)[1]-n_high
split=c(rep("HD-low",n_low),rep("HD-high", n_high))


col_split=c(rep("exh",8),rep("eff",12),rep("mem",15))
#heatmap_name='D-value_withmarkers'
cell_fun=c("exh" = "black", "eff" = "darkgreen","mem"='purple')
top_anno=rowAnnotation(Marker = col_split, col = list(Marker = cell_fun))
dim(data)
ha = rowAnnotation(foo = anno_mark(at = c(1:length(data[1,])),labels = colnames(data),extend = unit(15, "mm")))
ht1 = Heatmap(t(as.matrix(data)), 
  name = "ht1", 
  col = f2, 
  #row_split = factor(split,levels=c("D-low","D-high")),
  row_split = factor(col_split,levels=c("exh","eff","mem")),
  #row_km = 5,
  #column_title = heatmap_name,
  cluster_rows = F, 
  cluster_columns = F, 
  show_row_names = F,
  show_column_names = F,
  show_column_dend = F,
  #cluster_rows = dend,
  column_names_gp = gpar(fontsize = 4),
  #row_order = order(as.numeric(sort(marker[,2]))),

  #column_names_gp = gpar(fontsize = 6),
  #rect_gp = gpar(col = 'grey90'),
  #split=table[,2],
  #rect_gp = gpar(col = "white", lty = 2, lwd = 2)
  right_annotation = ha,
  left_annotation = top_anno,
  top_annotation = row_ha_top,
  bottom_annotation = row_ha_bottom,
  heatmap_legend_param = list(
    #legend_direction = "horizontal",
    legend_side="right",
    title = "Exp",
    legend_height = unit(1, "cm")
)
  )


library(ComplexHeatmap)

max(table_r$DF)
min(table_r$DF)
width = 15
heigth = 5
outdir = 'plots_bcc/'
mkdir(outdir)
prefix = heatmap_name
pdf(file.path(outdir, paste0(prefix, ".pdf")), w = width, h = heigth)
draw(ht1,heatmap_legend_side = "right")
decorate_annotation("HD_type", {
    grid.text("HD_type", unit(8, "mm"), just = "right")
    grid.rect(gp = gpar(fill = NA, col = "black"))
    grid.lines(unit(c(0, 1), "npc"), unit(c(20, 20), "native"), gp = gpar(lty = 3))
})
decorate_annotation("Db", {
    grid.text("Db", unit(8, "mm"), just = "right")
    grid.rect(gp = gpar(fill = NA, col = "black"))
    grid.lines(unit(c(0, 1), "npc"), unit(c(20, 20), "native"), gp = gpar(lty = 2))
})

decorate_annotation("Response", {
    grid.text("Response", unit(8, "mm"), just = "right")
    grid.rect(gp = gpar(fill = NA, col = "black"))
    grid.lines(unit(c(0, 1), "npc"), unit(c(20, 20), "native"), gp = gpar(lty = 3))
})

decorate_annotation("Acquisition", {
    grid.text("Acquisition", unit(8, "mm"), just = "right")
    grid.rect(gp = gpar(fill = NA, col = "black"))
    grid.lines(unit(c(0, 1), "npc"), unit(c(20, 20), "native"), gp = gpar(lty = 2))
})

decorate_annotation("Df", {
    grid.text("Df", unit(8, "mm"), just = "right")
    grid.rect(gp = gpar(fill = NA, col = "black"))
    grid.lines(unit(c(0, 1), "npc"), unit(c(20, 20), "native"), gp = gpar(lty = 2))
})

decorate_annotation("S", {
    grid.text("S", unit(8, "mm"), just = "right")
    grid.rect(gp = gpar(fill = NA, col = "black"))
    grid.lines(unit(c(0, 1), "npc"), unit(c(20, 20), "native"), gp = gpar(lty = 2))
})

decorate_annotation("F", {
    grid.text("F", unit(8, "mm"), just = "right")
    grid.rect(gp = gpar(fill = NA, col = "black"))
    grid.lines(unit(c(0, 1), "npc"), unit(c(20, 20), "native"), gp = gpar(lty = 2))
})
dev.off()
out='d_input_bcc/combined_1.txt'
write.table(table_r,out,sep='\t',quote=F)