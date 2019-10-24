wget http://www.well.ox.ac.uk/~wrayner/tools/HRC-1000G-check-bim-v4.2.7.zip
wget http://ngs.sanger.ac.uk/production/hrc/HRC.r1-1/HRC.r1-1.GRCh37.wgs.mac5.sites.tab.gz
unzip HRC-1000G-check-bim-v4.2.7.zip
gunzip HRC.r1-1.GRCh37.wgs.mac5.sites.tab.gz
wget http://qbrc.swmed.edu/zhanxw/software/checkVCF/checkVCF-20140116.tar.gz
tar xzvf checkVCF-20140116.tar.gz

plink --freq --bfile pmrp2019merge --out pmrp2019merge
perl HRC-1000G-check-bim.pl -b pmrp2019merge.bim -f pmrp2019merge.frq -r HRC.r1-1.GRCh37.wgs.mac5.sites.tab -h
sh Run-plink.sh
python checkVCF.py -r hs37d5.fa -o out Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_variants.VA.chr22.Minimac4.vcf.gz
plink --vcf Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_variants.VA.chr19.Minimac4.vcf.gz --double-id --freq --make-bed --out Schrodi_IL23_IL17.chr19
perl HRC-1000G-check-bim.pl -b Schrodi_IL23_IL17.chr19.bim -f Schrodi_IL23_IL17.chr19.frq -r HRC.r1-1.GRCh37.wgs.mac5.sites.tab -h
sh Run-plink.sh

for i in {1..23}
do
plink --bfile pmrp2019merge-updated-chr$i --recode vcf --out pmrp2019merge.hrc.chr$i
bcftools view pmrp2019merge.hrc.chr$i.vcf -Oz -o pmrp2019merge.hrc.chr$i.vcf.gz
tabix -p vcf pmrp2019merge.hrc.chr$i.vcf.gz
done


for i in {1..22} X Y MT
do
bcftools view Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_variants.VA.vcf.gz -r chr$i -Oz -o ./imputation/Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_variants.VA.chr$i.vcf.gz
done

for i in {1..22} X Y MT
do
echo "chr$i $i" > chr_name_conv.txt
bcftools annotate --rename-chrs chr_name_conv.txt Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_variants.VA.chr$i.vcf.gz -Oz -o Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_variants.VA.chr$i.Minimac4.vcf.gz
tabix -p vcf Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_variants.VA.chr$i.Minimac4.vcf.gz
done



install.packages("DNAcopy")
install.packages("DPpackage")
install.packages("https://cran.r-project.org/src/contrib/Archive/CHAT/CHAT_1.1.tar.gz")
install.packages("https://cran.r-project.org/src/contrib/Archive/DPpackage/DPpackage_1.1-7.tar.gz")


# remove false postive SNPs (VQSRTrancheSNP99.00to99.90):
bcftools view -f PASS Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_variants.VA.vcf.gz -Oz -o Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_PASS_variants.VA.vcf.gz

# change chrosome name:
rm chr_name_conv.txt
for i in {1..22} X Y M
do
echo "chr$i $i" >> chr_name_conv.txt
done
bcftools annotate --rename-chrs chr_name_conv.txt Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_PASS_variants.VA.vcf.gz -Oz -o Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_PASS_NUM.variants.VA.vcf.gz

# add gene symbol 
bcftools annotate -x INFO,^FORMAT/GT -a ~/hpc/db/hg19/refGene.hg19.VCF.sort.bed.gz -c CHROM,FROM,TO,GENE -h <(echo '##INFO=<ID=GENE,Number=1,Type=String,Description="Gene name">') Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_PASS_NUM.variants.VA.vcf.gz -Ov -o Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_PASS_NUM.variants.VA.refGene.vcf

# vcf to plink 
plink --vcf Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_PASS_NUM.variants.VA.refGene.vcf --geno 0.1 --make-bed --double-id --out Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_PASS_NUM
plink --bfile Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_PASS_NUM --mind 0.1 --maf 0.001 --freq --make-bed --out Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_PASS_NUM_GENO_MIND

cp HRC-1000G-check-bim.pl  ~/hpc/bin/
cp HRC.r1-1.GRCh37.wgs.mac5.sites.tab ~/hpc/bin/

# check input for michegen imputaiton
perl ~/hpc/bin/HRC-1000G-check-bim.pl -b Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_PASS_NUM_GENO_MIND.bim -f Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_PASS_NUM_GENO_MIND.frq -r ~/hpc/bin/HRC.r1-1.GRCh37.wgs.mac5.sites.tab -h

# burden test
plink --bfile Schrodi_IL23_IL17_combined_RECAL_SNP_INDEL_PASS_NUM_GENO_MIND --recode vcf --out ../rvtest/Schrodi_IL23_IL17
rvtest --inVcf Schrodi_IL23_IL17.vcf --pheno rvtest.phen --pheno-name b27 --out output --geneFile ~/hpc/bin/refFlat_hg19.txt.gz --burden cmc --vt price --kernel skat,kbac --noweb


perl -p -i -e 's/\t/ /g' rvtest.phen




wget http://qbrc.swmed.edu/zhanxw/seqminer/data/refFlat_hg19.txt.gz
gunzip refFlat_hg19.txt.gz
perl -p -i -e 's/chr//' refFlat_hg19.txt
gzip refFlat_hg19.txt
cp refFlat_hg19.txt.gz ~/hpc/bin/
