### Project Update
* 10/25/2019, beagle imputation and phasing then apply 2LOF analysis to AS-Target-Seq dataset. 
* 10/24/2019, rvtest based on 4 different models (CMC, VTP,Skat, Kbac) completed and QQ-plot were prepared. 
* 10/24/2019, QC: remove >10% genotyping missing SNPs and Individuals && SNPs with <0.001 MAFs 
* 10/24/2019, QC: Remove false postive SNPs:
`bcftools view -f PASS Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_variants.VA.vcf.gz -Oz -o Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_PASS_variants.VA.vcf.gz`
* Capture efficiency and sequencing depth estimation: 
* 10/24/2019, run FASTQ -> BWA alignment -> Picard SortSAM -> SAMtools split -> GATK Base Recalibration -> GATK PrintReads -> GATK DepthOfCoverage -> GATK Haplotype caller pipeline to call SNPs and Indels. 
* 10/23/2019, Steve share with me the AS target sequencing raw data (80 fastq). FASTQ: 6 MiSeq runs were used to generate genotypes in IL23/IL17 pathway genes. I will first try the compound het analysis to n=50 for SpA and n=30 for Controls
