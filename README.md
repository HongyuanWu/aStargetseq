### Comprehensive eQTL and pQTL Analysis to Axial Spondyloarthritis Macrophage Cells

In this project, we generated target sequencing (N=80), RNA-seq(N=278) and protein outcome (N=240) to 80 macrophage cells induced from PBMC derived from 80 Axial Spondyloarthritis patients. 

Aim: eQTL, pQTL and alternative splicing analysis

Timeline

* Update detail [clinical information to these 80 samples](AxialSpA_MasterFile_02Nov2015_corrected_for_SampSwap.csv	). eQTL and pQTL analysis were considered to be conducted. 
* RNA-seq to 240 samples conducted in Judy's lab. Target seqeuncing to IL17/21 pathway were conducted in MCRI
* Macrophase (N=80) have 3 status: naive, LPS-stimuli and 
* 80 samples (50 case vs 30 control, 50%MCRI-50%-UW-Madison, PBMC were extracted and induced to macrophage
* 2019/12/11: Steven introduce this AS project again including: target seqeuncing, RNA-seq and PLS treatment
* with the 2nd analysis, more SNPs occured in each gene, however, neither significant signal was found [here](/result/2LOF/2nd/).
* 10/29/2019, the most convinent way to run Steve's 2LOF test come out before Halloween. check my script [here](2LOF.pbs) 
* 10/29/2019,generate new lof vcf from imputated dataset `~/hpc/project/IL23IL17/Shicheng/2LOF/MIS`
* 10/29/2019, Re-QC: remove >10% genotyping missing SNPs and Individuals && keep SNPs with `any` MAFs  
* 10/29/2019, In order to repeat the analysis, I uploaded all the lof file to [here](extdata/LOF/). `bcftools view -R` to extract raw data.
* 10/28/2019,new LoF were created and saved in `~/hpc/db/Gnomad/exome/aloft-exome-rec/annovar` check my script [here](https://raw.githubusercontent.com/Shicheng-Guo/HowtoBook/master/ANNOVAR/annovar2lof.R)
* 10/25/2019, the [1st round test](/result/2LOF/1st) are completed without any significant signals. try to loose the definition of [1st round LoF](https://raw.githubusercontent.com/Shicheng-Guo/AnnotationDatabase/master/LOF/2019/ALoFT/gnomad.exomes.r2.1.sites.dq.rec.vcf.gz.vat.aloft.hg19). Here, I take all 206,282 stop, 280,935 frameshift and 2,425,858 Nsyn6I12 SNPs into the system (updated [LoF]()). 
* 10/25/2019, beagle imputation and phasing then apply 2LOF analysis to AS-Target-Seq dataset:[imputation result](//mcrfnas2/bigdata/Genetic/Projects/Schrodi_IL23_IL17_variants/Shicheng/2LOF/MIS/)
* 10/24/2019, rvtest based on 4 different models (CMC, VTP,Skat, Kbac) completed and [QQ-plot](https://github.com/Shicheng-Guo/aStargetseq/tree/master/result/rvtest) were prepared. 
* 10/24/2019, QC: remove >10% genotyping missing SNPs and Individuals && SNPs with <0.001 MAFs 
* 10/24/2019, QC: Remove false postive SNPs:
`bcftools view -f PASS Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_variants.VA.vcf.gz -Oz -o Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_PASS_variants.VA.vcf.gz`
* Capture efficiency and sequencing depth estimation: 
* 10/24/2019, run FASTQ -> BWA alignment -> Picard SortSAM -> SAMtools split -> GATK Base Recalibration -> GATK PrintReads -> GATK DepthOfCoverage -> GATK Haplotype caller pipeline to call SNPs and Indels. 
* 10/23/2019, Steve share with me the AS target sequencing raw data (80 fastq). FASTQ: 6 MiSeq runs were used to generate genotypes in IL23/IL17 pathway genes. I will first try the compound het analysis to n=50 for SpA and n=30 for Controls. We also have other phenotypes and should be re-exam again after B27.
* fix project folder: `/gpfs/home/guosa/hpc/project/IL23IL17`. BTW,it is a soft symbolic link while real-D in Steven's folder
