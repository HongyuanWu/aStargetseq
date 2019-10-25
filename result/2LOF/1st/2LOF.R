#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
ssum<-function(vector){
options(warn=-1)
rlt<-c()
  for(i in seq(1,length(vector),by=2)){
    tmp<-(vector[i]>=1)+(vector[i+1]>=1)
    rlt<-c(rlt,tmp)
  }
rlt
}

cssum<-function(vector){
options(warn=-1)
rlt<-c()
  for(i in seq(1,length(vector),by=2)){
    tmp<-(vector[i])*(vector[i+1])
    rlt<-c(rlt,tmp)
  }
rlt
}

restru<-function(data){
  rlt<-c()
  for(i in 1:ncol(data)){
    yy<-lapply(strsplit(as.character(data[,i]),"[|]"),function(x) t(x))
    zz<-matrix(unlist(yy),ncol=2,byrow=T)
    rlt<-cbind(rlt,zz)
  }
  rlt
}

vcfile=as.character(args[1])  
samfile=as.character(args[2]) 
#vcfile="/gpfs/home/guosa/hpc/project/IL23IL17/Shicheng/2LOF/MIS/chr17.dose.lof.refGene.vcf"
#samfile="/gpfs/home/guosa/hpc/project/IL23IL17/Shicheng/rvtest.phen"

print(vcfile);
print(samfile);
chr=unlist(strsplit(vcfile,"chr|.dose"))[2]
fileout=unlist(strsplit(samfile,"/"))
samfilehead=fileout[length(fileout)]

output<-paste(vcfile,"pvalue.txt",sep=".")
head<-readLines(vcfile)
data<-read.table(vcfile,head=F,sep="\t",check.names=F)
head<-head[-(grep("#CHROM",head)+1):-(length(head))]
vcfnames<-unlist(strsplit(head[length(head)],"\t"))
names(data)<-vcfnames

phen<-read.table(samfile,head=T)
fid=phen[,1]
iid=phen[,2]
newphen<-phen[match(colnames(data),as.character(paste(fid,"_",iid,sep=""))),]
case<-which(newphen[,6]==2)
con<-which(newphen[,6]==1)
rlt<-c()

GeneList<-sort(unique(unlist(lapply(unique(data$INFO),function(x) unlist(strsplit(as.character(x),split="GENE=|;"))[2]))))
GeneList

add2LOF<-function(sxx,syy){
  A<-sum(ssum(sxx)>1)
  B<-sum(ssum(sxx)<=1)
  C<-sum(ssum(syy)>1)
  D<-sum(ssum(syy)<=1)
  z<-matrix(c(A,B,C,D),2,2)
  try(test<-fisher.test(z, alternative = "greater"))
  P=test$p.value
  OR=((A*D)+0.5)/((B*C)+0.5)
  return(c(A,B,C,D,OR,P))
}

mult2LOF<-function(sxx,syy){
  Av<-cssum(sxx)
  Dv<-cssum(syy)
  try(test<-t.test(Av,Dv))
  P=test$p.value
  beta=test$statistic
  return(c(beta,P))
}

for(i in GeneList){
  sel<-which(unlist(lapply(data$INFO,function(x) sum(unlist(strsplit(as.character(x),split="GENE=|;"))%in% i)>0)))
  ca<-data[sel,case]
  co<-data[sel,con]
  head(ca)
  head(co)
  xx<-data.matrix(restru(ca))
  yy<-data.matrix(restru(co))
  class(xx)="numeric"
  class(yy)="numeric"
  rm<-which(rowMeans(yy)>=0.3)
  if(length(rm)>0){
  xx<-xx[-rm,]
  yy<-yy[-rm,]  
  print(i)
  }
  xx<-matrix(xx,ncol=2*ncol(ca))
  yy<-matrix(yy,ncol=2*ncol(co))
  if(nrow(xx)>0){
  sxx<-colSums(xx)
  syy<-colSums(yy)

  rlt1<-add2LOF(sxx,syy)
  #rlt2<-mult2LOF(sxx,syy)
  #temp<-data.frame(i,chr,nrow(yy),A=rlt1[1],B=rlt1[2],C=rlt1[3],D=rlt1[4],OR=rlt1[5],P1=rlt1[6],Beta=rlt2[1],P2=rlt2[2])
  temp<-data.frame(i,chr,nrow(yy),A=rlt1[1],B=rlt1[2],C=rlt1[3],D=rlt1[4],OR=rlt1[5],P1=rlt1[6])
  print(temp)
  rlt<-rbind(rlt,temp)
  }
}
colnames(rlt)<-c("GeneSymbol","chr","NSNP","Case+","Case-","Normal+","Normal-","OR","P")
write.table(rlt,file=output,sep="\t",quote=F,col.names=T,row.names = F)


