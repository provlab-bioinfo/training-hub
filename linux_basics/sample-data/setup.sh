#!/bin/bash
# setup.sh - Generate all sample data files for Linux bioinformatics tutorial
# Optimized FASTQ generation (fast + scalable)

set -euo pipefail

echo "=== Generating Sample Data for Linux Bioinformatics Tutorial ==="

mkdir -p fasta fastq vcf gtf expression metadata logs

#############################################
# 1. FASTA FILES
#############################################
echo "Generating FASTA files..."

cat > fasta/human_genes.fasta << 'EOF'
>ENSG00000139618|BRCA2|breast cancer susceptibility protein
ATGGCGATTCTTGAGGACGAGAAGGAGAAGGAGCTGCAGAAGGAGATCGAGCAGCTCAAG
GCGGCCTTCAACATGATCACTATCGTGGACAAGTCAGAGGAGATCCGCATGCAGATCGAG
>ENSG00000141510|TP53|tumor protein p53
ATGGAGGAGCCGCAGTCAGATCCTAGCGTCGAGCCCCCTCTGAGTCAGGAAACATTTTCA
GACCTATGGAAACTACTTCCTGAAAACAACGTTCTGTCCCCCTTGCCGTCCCAAGCAATG
>ENSG00000146648|EGFR|epidermal growth factor receptor
ATGCGACCCTCCGGGACGGCCGGGGCAGCGCTCCTGGCGCTGCTGGCTGCGCTCTGCCCG
GCGAGTCGGGCTCTGGAGGAAAAGAAAGTTTGCCAAGGCACGAGTAACAAGCTCACGCAG
EOF

for i in {4..50}; do
    GENEID="ENSG$(printf "%011d" "$i")"
    GENENAME="GENE$(printf "%03d" "$i")"
    LENGTH=$((500 + RANDOM % 2000))
    echo ">$GENEID|$GENENAME|protein coding gene" >> fasta/human_genes.fasta
    awk -v L="$LENGTH" 'BEGIN{
        bases="ATCG"
        for(i=1;i<=L;i++) printf substr(bases,int(rand()*4)+1,1)
        print ""
    }' >> fasta/human_genes.fasta
done

#############################################
# 2. FASTQ FILES (OPTIMIZED)
#############################################
echo "Generating FASTQ files (fast)..."

generate_fastq () {
    local outfile=$1
    local reads=$2
    local minlen=$3
    local maxlen=$4
    local pair=$5

    awk -v N="$reads" -v MIN="$minlen" -v MAX="$maxlen" -v P="$pair" '
    BEGIN {
        srand(42)
        bases="ATCG"
        quals="IIIIIIIIIIIIHHHHHHHHHHFFFFEEE"
        for (i=1; i<=N; i++) {
            len = (MIN==MAX)?MIN:(MIN+int(rand()*(MAX-MIN+1)))
            seq=""; qual=""
            for (j=1; j<=len; j++) {
                seq = seq substr(bases, int(rand()*4)+1, 1)
                qual = qual substr(quals, int(rand()*length(quals))+1, 1)
            }
            suffix = (P>0 ? "/"P : "")
            print "@READ" i suffix
            print seq
            print "+"
            print qual
        }
    }' > "$outfile"
}

generate_fastq fastq/sample1_R1.fastq 10000 150 150 1
generate_fastq fastq/sample1_R2.fastq 10000 150 150 2
generate_fastq fastq/sample2_R1.fastq 10000 150 150 1
generate_fastq fastq/sample2_R2.fastq 10000 150 150 2
generate_fastq fastq/sample3_single.fastq 5000 50 200 0

gzip fastq/*.fastq

#############################################
# 3. VCF FILES
#############################################
echo "Generating VCF files..."

cat > vcf/variants.vcf << 'EOF'
##fileformat=VCFv4.2
##reference=hg38.fa
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	SAMPLE1
EOF

for i in {1..1000}; do
    awk 'BEGIN{
        bases="ATCG"
        ref=substr(bases,int(rand()*4)+1,1)
        alt=substr(bases,int(rand()*4)+1,1)
        if(ref==alt) alt="A"
        printf "chr%d\t%d\t.\t%s\t%s\t%d\tPASS\tDP=%d\tGT\t0/1\n",
        int(rand()*22)+1, int(rand()*100000)+10000, ref, alt, int(rand()*60)+20, int(rand()*90)+10
    }'
done >> vcf/variants.vcf

#############################################
# 4. GTF FILES
#############################################
echo "Generating GTF files..."

cat > gtf/annotations.gtf << 'EOF'
chr1	HAVANA	gene	11869	14409	.	+	.	gene_id "ENSG00000223972"; gene_name "DDX11L1";
EOF

for i in {1..90}; do
    echo -e "chr$((i%22+1))\tHAVANA\tgene\t$((i*10000))\t$((i*10000+2000))\t.\t+\t.\tgene_id \"ENSG$(printf "%011d" "$i")\"; gene_name \"GENE$(printf "%03d" "$i")\";"
done >> gtf/annotations.gtf

#############################################
# 5. EXPRESSION DATA
#############################################
echo "Generating expression data..."

{
    echo -e "Gene\tSample1\tSample2\tSample3"
    for i in {1..500}; do
        echo -e "GENE$(printf "%03d" "$i")\t$((RANDOM%10000))\t$((RANDOM%10000))\t$((RANDOM%10000))"
    done
} > expression/counts.tsv

#############################################
# 6. METADATA
#############################################
echo "Generating metadata..."

cat > metadata/samples.csv << 'EOF'
SampleID,Condition,Batch
Sample1,Control,A
Sample2,Treated,B
Sample3,Treated,A
EOF

#############################################
# 7. LOG FILES
#############################################
echo "Generating logs..."

cat > logs/analysis.log << 'EOF'
[INFO] Pipeline started
[INFO] FASTQ generation complete
[INFO] Analysis finished successfully
EOF

#############################################
# COMPLETION
#############################################
echo ""
echo "=== Sample Data Generation Complete ==="
echo "FASTA: $(ls fasta | wc -l)"
echo "FASTQ: $(ls fastq | wc -l)"
echo "VCF: $(ls vcf | wc -l)"
echo "GTF: $(ls gtf | wc -l)"
echo "Expression: $(ls expression | wc -l)"
echo "Metadata: $(ls metadata | wc -l)"
echo "Logs: $(ls logs | wc -l)"
echo "Total size: $(du -sh . | cut -f1)"
