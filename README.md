### Project Update
* 
* generate new lof vcf from imputated dataset ``
* New LoF list were created and saved in `~/hpc/db/Gnomad/exome/aloft-exome-rec/annovar` check my script [here](https://raw.githubusercontent.com/Shicheng-Guo/HowtoBook/master/ANNOVAR/annovar2lof.R)
* 10/25/2019, the [1st round test](/result/2LOF/1st) are completed without any significant signals. try to loose the definition of [1st round LoF](https://raw.githubusercontent.com/Shicheng-Guo/AnnotationDatabase/master/LOF/2019/ALoFT/gnomad.exomes.r2.1.sites.dq.rec.vcf.gz.vat.aloft.hg19). Here, I take all 206,282 stop, 280,935 frameshift and 2,425,858 Nsyn6I12 SNPs into the system (updated [LoF]()). 
* 10/25/2019, beagle imputation and phasing then apply 2LOF analysis to AS-Target-Seq dataset:[imputation result](//mcrfnas2/bigdata/Genetic/Projects/Schrodi_IL23_IL17_variants/Shicheng/2LOF/MIS/)
* 10/24/2019, rvtest based on 4 different models (CMC, VTP,Skat, Kbac) completed and [QQ-plot](https://github.com/Shicheng-Guo/aStargetseq/tree/master/result/rvtest) were prepared. 
* 10/24/2019, QC: remove >10% genotyping missing SNPs and Individuals && SNPs with <0.001 MAFs 
* 10/24/2019, QC: Remove false postive SNPs:
`bcftools view -f PASS Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_variants.VA.vcf.gz -Oz -o Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_PASS_variants.VA.vcf.gz`
* Capture efficiency and sequencing depth estimation: 
* 10/24/2019, run FASTQ -> BWA alignment -> Picard SortSAM -> SAMtools split -> GATK Base Recalibration -> GATK PrintReads -> GATK DepthOfCoverage -> GATK Haplotype caller pipeline to call SNPs and Indels. 
* 10/23/2019, Steve share with me the AS target sequencing raw data (80 fastq). FASTQ: 6 MiSeq runs were used to generate genotypes in IL23/IL17 pathway genes. I will first try the compound het analysis to n=50 for SpA and n=30 for Controls
* fix project folder: `/gpfs/home/guosa/hpc/project/IL23IL17`. BTW,it is a soft symbolic link while real-D in Steven's folder
