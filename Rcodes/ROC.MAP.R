

svm_data <- function(data,k){

  x <- subset(data, select=-y)
  y <- data$y
  model <- svm(y~data[,k],cross=5)
  pred <- predict(model,y)
  #pred

  } 


svm_data_cols <- function(data,l,k){
  x <- subset(data, select=c(l,k))
  y <- data$y
  model <- svm(y~x,cross=5)
  pred <- predict(model,y)
  #pred

  } 


ROC<- function (pred,data,width, heigth,outdir, prefix){
  roc_data=data.frame(pred,data$y)
  #print (roc_data)
  pred <- prediction(roc_data$pred,roc_data$data.y)
  
  auc_ROCR <- performance(pred, measure = "auc")
  auc_ROCR <- auc_ROCR@y.values[[1]]
  #auc_ROCR_0 <- auc_ROCR@y.values[[2]]
  #print (auc_ROCR_0)
  print ("AUC:")
  print (auc_ROCR)

  pred <- prediction(roc_data$pred,roc_data$data.y)
  roc_perf = performance(pred, measure = "tpr", x.measure = "fpr")
  roc_perf

}

draw.ROC<- function (data_svm,width, heigth,outdir, prefix){
  out=c()
  pdf(file.path(outdir, paste0(prefix, "_ROC_front.pdf")), w = width, h = heigth)
  colors=c("#762a83")
  lt=c(1)
  for (k in 1:1) {
  draw_num=k
  pred=svm_data(data_svm,k)
  perf=ROC(pred,data_svm)

  plot(perf,add=((k)!=1),col=colors[k],lwd=2,lty=lt[k])
  print ('roccurve')
  }

  

  abline(a=0, b= 1)
  dev.off()
}

library(ROCR)
library(e1071)
#library("verification")
width = 5
heigth = 5
outdir = 'plots_bcc/'
prefix = 'roc_MAP'
color_conditions = c("#8c510a")
f = "d_input_bcc/roc.txt"
table = read.table(f,sep='\t',header=T)
#table=table[table[,6] <0,][-1].split('_')[0]
#data=table
head(table)
length(table[,1])

r=table[table[,5]=='Yes',]
nr=table[table[,5]=='No',]
for (k in c(7:9))
{ 
print(wilcox.test(nr[,k],r[,k]))
}
#colnames(data)=c('a','b','c')
y=as.numeric(table$R=='Yes')
#table[1:100,]

x=table$Db
data_svm=data.frame(x,y)
head(data_svm)
#colnames(data)=c(")
draw.ROC(data_svm,width, heigth,outdir, prefix)


 








