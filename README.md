* Capture efficiency and sequencing depth estimation: 
* 10/24/2019, run FASTQ -> BWA alignment -> Picard SortSAM -> SAMtools split -> `Picard Mark Duplicates` -> GATK Base Recalibration -> GATK PrintReads -> GATK DepthOfCoverage -> GATK Haplotype caller pipeline to call SNPs and Indels.
* 10/23/2019, Steve share with me the AS target sequencing raw data (80 fastq). FASTQ: 6 MiSeq runs were used to generate genotypes in IL23/IL17 pathway genes. I will first try the compound het analysis to n=50 for SpA and n=30 for Controls
