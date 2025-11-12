#!/bin/bash
# setup.sh - Generate all sample data files for Linux bioinformatics tutorial
# This creates realistic but synthetic data for practice exercises

set -e

echo "=== Generating Sample Data for Linux Bioinformatics Tutorial ==="
echo "This may take a few minutes..."

# Create directory structure
mkdir -p fasta fastq vcf gtf expression metadata logs

#############################################
# 1. FASTA FILES
#############################################
echo "Generating FASTA files..."

# Human genes FASTA (50 genes with realistic descriptions)
cat > fasta/human_genes.fasta << 'EOF'
>ENSG00000139618|BRCA2|breast cancer susceptibility protein
ATGGCGATTCTTGAGGACGAGAAGGAGAAGGAGCTGCAGAAGGAGATCGAGCAGCTCAAG
GCGGCCTTCAACATGATCACTATCGTGGACAAGTCAGAGGAGATCCGCATGCAGATCGAG
GAGGTGAAGAAGGAGCTGAAGAAGCAGCTGGAGAAGCTGCGGGCCGAGAAGCTGCAGGAG
CTGAAGGACGAGAAGGAGCTGCAGAAGGAGATCGAGCAGCTCAAGGCGGCCTTCAACATG
>ENSG00000141510|TP53|tumor protein p53
ATGGAGGAGCCGCAGTCAGATCCTAGCGTCGAGCCCCCTCTGAGTCAGGAAACATTTTCA
GACCTATGGAAACTACTTCCTGAAAACAACGTTCTGTCCCCCTTGCCGTCCCAAGCAATG
GATGATTTGATGCTGTCCCCGGACGATATTGAACAATGGTTCACTGAAGACCCAGGTCCA
GATGAAGCTCCCAGAATGCCAGAGGCTGCTCCCCCCGTGGCCCCTGCACCAGCAGCTCCT
>ENSG00000146648|EGFR|epidermal growth factor receptor
ATGCGACCCTCCGGGACGGCCGGGGCAGCGCTCCTGGCGCTGCTGGCTGCGCTCTGCCCG
GCGAGTCGGGCTCTGGAGGAAAAGAAAGTTTGCCAAGGCACGAGTAACAAGCTCACGCAG
TTGGGCACTTTTGAAGATCATTTTCTCAGCCTCCAGAGGATGTTCAATAACTGTGAGGTG
GTCCTTGGGAATTTGGAAATTACCTATGTGCAGAGGAATTATGATCTTTCCTTCTTAAAG
>ENSG00000133703|KRAS|KRAS proto-oncogene
ATGACTGAATATAAACTTGTGGTAGTTGGAGCTGGTGGCGTAGGCAAGAGTGCCTTGACG
ATACAGCTAATTCAGAATCATTTTGTGGACGAATATGATCCAACAATAGAGGATTCCTAC
AGGAAGCAAGTAGTAATTGATGGAGAAACCTGTCTCTTGGATATTCTCGACACAGCAGGT
CAAGAGGAGTACAGTGCAATGAGGGACCAGTACATGAGGACTGGGGAGGGCTTTCTTTGT
>ENSG00000136997|MYC|MYC proto-oncogene
ATGCCCCTCAACGTTAGCTTCACCAACAGGAACTATGACCTCGACTACGACTCGGTGCAG
CCGTATTTCTACTGCGACGAGGAGGAGAACTTCTACCAGCAGCAGCAGCAGCAGCAAAGT
CATTATCCGACTCGACCTTCACCACCGAGCCGCCCGCACCACCAGCAGCAGCAGCAGCAG
AGCGGGAAGGCGCTGCACAACGTCTTGGAGCGACTCCGCTGCCAAGCTGGAAAAGTTCAC
EOF

# Generate 45 more genes with random sequences
for i in {6..50}; do
    GENEID="ENSG$(printf "%011d" $i)"
    GENENAME="GENE$(printf "%03d" $i)"
    LENGTH=$((500 + RANDOM % 4500))
    
    echo ">$GENEID|$GENENAME|protein coding gene" >> fasta/human_genes.fasta
    # Generate random DNA sequence
    cat /dev/urandom | tr -dc 'ATCG' | fold -w 60 | head -n $((LENGTH/60 + 1)) | head -c $LENGTH >> fasta/human_genes.fasta
    echo "" >> fasta/human_genes.fasta
done

# Contaminants FASTA
cat > fasta/contaminants.fasta << 'EOF'
>Adapter1|Illumina_TruSeq_Adapter
AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC
>Adapter2|Nextera_Transposase_Sequence
CTGTCTCTTATACACATCT
>PhiX174|Control_sequence
GAGTTTTATCGCTTCCATGACGCAGAAGTTAACACTTTCGGATATTTCTGATGAGTCGAAAAATTATCTT
GATAAAGCAGGAATTACTACTGCTTGTTTACGAATTAAATCGAAGTGGACTGCTGGCGGAAAATGAGAAA
>Vector|pUC19_partial
TTGAGGCAGGTCAGACGATTGGCCTTGATATTCACAAACAAATAAATCCTCATTATACCATGATTGAATA
CGATTCGGTGATGTCGGCGATATAGGCGCCAGCAACCGCACCTGTGGCGCCGGTGATGCCGGCCACGATG
EOF

# Small genome for testing
cat > fasta/small_genome.fasta << 'EOF'
>chr1 chromosome 1
ATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCG
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTA
TTTTAAAACCCCGGGGTTTTAAAACCCCGGGGTTTTAAAACCCC
ATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCG
>chr2 chromosome 2
GGGGCCCCAAAATTTTGGGGCCCCAAAATTTTGGGGCCCCAAAA
TTTTGGGGCCCCAAAATTTTGGGGCCCCAAAATTTTGGGGCCCC
ATATATATATCGCGCGCGATATATATCGCGCGCGATATATCGCG
CGCGCGCGATATATATCGCGCGCGCGCGCGCGATATATATCGCG
>chr3 chromosome 3
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
EOF

#############################################
# 2. FASTQ FILES
#############################################
echo "Generating FASTQ files..."

# Function to generate random DNA sequence
generate_seq() {
    local length=$1
    cat /dev/urandom | tr -dc 'ATCGN' | head -c $length
}

# Function to generate quality string
generate_qual() {
    local length=$1
    local quality=${2:-"I"}  # Default high quality
    python3 -c "import random; print(''.join(random.choices('!\"#\$%&\\'()*+,-./0123456789:;<=>?@ABCDEFGHIJ', k=$length)))" 2>/dev/null || \
    perl -e "print chr(33+int(rand(40))) for 1..$length; print \"\n\"" || \
    head -c $length < /dev/urandom | tr '\000-\377' '!-J'
}

# Generate sample1 R1
{
    for i in {1..10000}; do
        echo "@READ${i}/1"
        generate_seq 150
        echo "+"
        generate_qual 150
    done
} > fastq/sample1_R1.fastq

# Generate sample1 R2
{
    for i in {1..10000}; do
        echo "@READ${i}/2"
        generate_seq 150
        echo "+"
        generate_qual 150
    done
} > fastq/sample1_R2.fastq

# Generate sample2 with slightly different quality
{
    for i in {1..10000}; do
        echo "@READ${i}/1"
        generate_seq 150
        echo "+"
        if [ $((i % 100)) -eq 0 ]; then
            generate_qual 150 "F"  # Lower quality every 100th read
        else
            generate_qual 150
        fi
    done
} > fastq/sample2_R1.fastq

{
    for i in {1..10000}; do
        echo "@READ${i}/2"
        generate_seq 150
        echo "+"
        if [ $((i % 100)) -eq 0 ]; then
            generate_qual 150 "F"
        else
            generate_qual 150
        fi
    done
} > fastq/sample2_R2.fastq

# Generate sample3 single-end with variable lengths
{
    for i in {1..5000}; do
        LENGTH=$((50 + RANDOM % 151))
        echo "@READ${i}"
        generate_seq $LENGTH
        echo "+"
        generate_qual $LENGTH
    done
} > fastq/sample3_single.fastq

# Compress all FASTQ files
echo "Compressing FASTQ files..."
gzip fastq/*.fastq

#############################################
# 3. VCF FILES
#############################################
echo "Generating VCF files..."

cat > vcf/variants.vcf << 'EOF'
##fileformat=VCFv4.2
##reference=hg38.fa
##INFO=<ID=DP,Number=1,Type=Integer,Description="Total Depth">
##INFO=<ID=AF,Number=A,Type=Float,Description="Allele Frequency">
##INFO=<ID=TYPE,Number=1,Type=String,Description="Variant Type">
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=GQ,Number=1,Type=Integer,Description="Genotype Quality">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Read Depth">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	SAMPLE1
EOF

# Generate 1000 variants
for i in {1..1000}; do
    CHR="chr$((1 + RANDOM % 22))"
    POS=$((10000 + RANDOM % 90000))
    QUAL=$((20 + RANDOM % 60))
    
    if [ $((RANDOM % 10)) -lt 2 ]; then
        FILTER="LOW_QUAL"
    else
        FILTER="PASS"
    fi
    
    if [ $((RANDOM % 10)) -lt 8 ]; then
        # SNP
        REF=$(echo "ATCG" | fold -w1 | shuf | head -1)
        ALT=$(echo "ATCG" | fold -w1 | grep -v $REF | shuf | head -1)
        TYPE="SNP"
    else
        # INDEL
        REF="AT"
        ALT="A"
        TYPE="INDEL"
    fi
    
    DP=$((10 + RANDOM % 90))
    AF=$(echo "scale=2; $((RANDOM % 100)) / 100" | bc)
    
    echo -e "$CHR\t$POS\t.\t$REF\t$ALT\t$QUAL\t$FILTER\tDP=$DP;AF=$AF;TYPE=$TYPE\tGT:GQ:DP\t0/1:$QUAL:$DP"
done | sort -k1,1V -k2,2n >> vcf/variants.vcf

# Create high quality subset
grep "^#" vcf/variants.vcf > vcf/high_quality.vcf
awk '$6>30 && $7=="PASS"' vcf/variants.vcf >> vcf/high_quality.vcf

#############################################
# 4. GTF FILES
#############################################
echo "Generating GTF files..."

cat > gtf/annotations.gtf << 'EOF'
chr1	HAVANA	gene	11869	14409	.	+	.	gene_id "ENSG00000223972"; gene_name "DDX11L1"; gene_type "transcribed_unprocessed_pseudogene";
chr1	HAVANA	transcript	11869	14409	.	+	.	gene_id "ENSG00000223972"; transcript_id "ENST00000456328"; gene_name "DDX11L1";
chr1	HAVANA	exon	11869	12227	.	+	.	gene_id "ENSG00000223972"; transcript_id "ENST00000456328"; exon_number "1";
chr1	HAVANA	exon	12613	12721	.	+	.	gene_id "ENSG00000223972"; transcript_id "ENST00000456328"; exon_number "2";
chr1	HAVANA	exon	13221	14409	.	+	.	gene_id "ENSG00000223972"; transcript_id "ENST00000456328"; exon_number "3";
chr1	HAVANA	gene	14404	29570	.	-	.	gene_id "ENSG00000227232"; gene_name "WASH7P"; gene_type "unprocessed_pseudogene";
chr1	HAVANA	transcript	14404	29570	.	-	.	gene_id "ENSG00000227232"; transcript_id "ENST00000488147"; gene_name "WASH7P";
chr1	HAVANA	exon	14404	14501	.	-	.	gene_id "ENSG00000227232"; transcript_id "ENST00000488147"; exon_number "1";
chr2	HAVANA	gene	38814	46588	.	-	.	gene_id "ENSG00000233750"; gene_name "FAAP24"; gene_type "protein_coding";
chr2	HAVANA	transcript	38814	46588	.	-	.	gene_id "ENSG00000233750"; transcript_id "ENST00000423372"; gene_name "FAAP24";
EOF

# Generate more genes
for i in {1..90}; do
    CHR="chr$((1 + i % 22))"
    START=$((10000 * i))
    END=$((START + 1000 + RANDOM % 4000))
    STRAND=$([ $((RANDOM % 2)) -eq 0 ] && echo "+" || echo "-")
    GENE_ID="ENSG$(printf "%011d" $i)"
    GENE_NAME="GENE$(printf "%03d" $i)"
    
    echo -e "$CHR\tHAVANA\tgene\t$START\t$END\t.\t$STRAND\t.\tgene_id \"$GENE_ID\"; gene_name \"$GENE_NAME\"; gene_type \"protein_coding\";" >> gtf/annotations.gtf
done

# Create subset
head -50 gtf/annotations.gtf > gtf/subset.gtf

#############################################
# 5. EXPRESSION DATA
#############################################
echo "Generating expression data..."

# Generate counts matrix (500 genes x 12 samples)
{
    echo -e "Gene\tControl_1\tControl_2\tControl_3\tTreat1_1\tTreat1_2\tTreat1_3\tTreat2_1\tTreat2_2\tTreat2_3\tTreat3_1\tTreat3_2\tTreat3_3"
    for i in {1..500}; do
        printf "GENE%03d" $i
        for j in {1..12}; do
            printf "\t%d" $((RANDOM % 10000))
        done
        echo ""
    done
} > expression/counts.tsv

# Generate normalized matrix
{
    echo -e "Gene\tControl_1\tControl_2\tControl_3\tTreat1_1\tTreat1_2\tTreat1_3\tTreat2_1\tTreat2_2\tTreat2_3\tTreat3_1\tTreat3_2\tTreat3_3"
    for i in {1..500}; do
        printf "GENE%03d" $i
        for j in {1..12}; do
            printf "\t%.2f" $(echo "scale=2; $((RANDOM % 10000)) / 10" | bc)
        done
        echo ""
    done
} > expression/normalized.tsv

# Sample metadata
cat > expression/metadata.csv << 'EOF'
SampleID,Condition,Replicate,Batch,ReadCount,MappingRate
Control_1,Control,1,A,25000000,0.95
Control_2,Control,2,A,28000000,0.94
Control_3,Control,3,B,26000000,0.93
Treat1_1,Treatment1,1,A,27000000,0.96
Treat1_2,Treatment1,2,B,29000000,0.95
Treat1_3,Treatment1,3,A,26500000,0.94
Treat2_1,Treatment2,1,B,28500000,0.95
Treat2_2,Treatment2,2,A,27500000,0.96
Treat2_3,Treatment2,3,B,26000000,0.94
Treat3_1,Treatment3,1,A,30000000,0.97
Treat3_2,Treatment3,2,B,28000000,0.96
Treat3_3,Treatment3,3,A,27000000,0.95
EOF

#############################################
# 6. METADATA
#############################################
echo "Generating metadata files..."

cat > metadata/samples.csv << 'EOF'
SampleID,PatientID,Age,Gender,Tissue,Batch,QC_Pass
Sample001,Patient001,45,M,Tumor,A,TRUE
Sample002,Patient001,45,M,Normal,A,TRUE
Sample003,Patient002,52,F,Tumor,A,TRUE
Sample004,Patient002,52,F,Normal,A,FALSE
Sample005,Patient003,38,M,Tumor,B,TRUE
Sample006,Patient003,38,M,Normal,B,TRUE
Sample007,Patient004,61,F,Tumor,B,TRUE
Sample008,Patient004,61,F,Normal,B,TRUE
Sample009,Patient005,47,M,Tumor,C,TRUE
Sample010,Patient005,47,M,Normal,C,TRUE
Sample011,Patient006,55,F,Tumor,C,FALSE
Sample012,Patient006,55,F,Normal,C,TRUE
EOF

cat > metadata/experiments.tsv << 'EOF'
ExperimentID	Date	Protocol	Instrument	Flowcell	Notes
EXP001	2024-01-15	RNASeq_v2	NovaSeq6000	FC001	Standard protocol
EXP002	2024-01-20	RNASeq_v2	NovaSeq6000	FC002	Low input
EXP003	2024-02-10	RNASeq_v2	NovaSeq6000	FC003	Standard protocol
EXP004	2024-02-15	WGS_v1	NovaSeq6000	FC004	High coverage
EXP005	2024-03-01	WGS_v1	NovaSeq6000	FC005	Standard coverage
EOF

#############################################
# 7. LOG FILES
#############################################
echo "Generating log files..."

cat > logs/analysis.log << 'EOF'
[2024-11-07 10:00:00] INFO: Analysis pipeline started
[2024-11-07 10:00:05] INFO: Loading configuration from config.yaml
[2024-11-07 10:00:10] INFO: Validating input files
[2024-11-07 10:00:15] INFO: Processing Sample001
[2024-11-07 10:05:20] INFO: Sample001 - 25000000 reads processed
[2024-11-07 10:05:25] WARNING: Sample001 - Low mapping rate: 85%
[2024-11-07 10:05:30] INFO: Processing Sample002
[2024-11-07 10:10:35] INFO: Sample002 - 28000000 reads processed
[2024-11-07 10:10:40] ERROR: Sample003 - File not found: Sample003_R2.fastq
[2024-11-07 10:10:45] INFO: Skipping Sample003
[2024-11-07 10:10:50] INFO: Processing Sample004
[2024-11-07 10:15:55] WARNING: Sample004 - High duplication rate: 45%
[2024-11-07 10:16:00] INFO: Sample004 - 26000000 reads processed
[2024-11-07 10:16:05] INFO: Processing Sample005
[2024-11-07 10:21:10] INFO: Sample005 - 27000000 reads processed
[2024-11-07 10:21:15] ERROR: Sample006 - Insufficient memory
[2024-11-07 10:21:20] INFO: Retrying Sample006 with reduced threads
[2024-11-07 10:26:25] INFO: Sample006 - 29000000 reads processed
[2024-11-07 10:26:30] INFO: Running quality control
[2024-11-07 10:31:35] INFO: Quality control completed
[2024-11-07 10:31:40] INFO: Generating alignment statistics
[2024-11-07 10:36:45] INFO: Alignment statistics complete
[2024-11-07 10:36:50] INFO: Analysis pipeline completed
[2024-11-07 10:36:55] INFO: Total runtime: 36 minutes 55 seconds
EOF

cat > logs/qc_report.log << 'EOF'
=== Quality Control Report ===
Generated: 2024-11-07 10:31:35

Sample001:
  Total Reads: 25,000,000
  Passed QC: 24,250,000 (97.0%)
  Failed QC: 750,000 (3.0%)
  Average Quality: 35.2
  GC Content: 48.5%

Sample002:
  Total Reads: 28,000,000
  Passed QC: 27,440,000 (98.0%)
  Failed QC: 560,000 (2.0%)
  Average Quality: 36.1
  GC Content: 47.8%

Sample004:
  Total Reads: 26,000,000
  Passed QC: 25,220,000 (97.0%)
  Failed QC: 780,000 (3.0%)
  Average Quality: 34.8
  GC Content: 49.2%
  WARNING: High duplication rate detected

Sample005:
  Total Reads: 27,000,000
  Passed QC: 26,460,000 (98.0%)
  Failed QC: 540,000 (2.0%)
  Average Quality: 35.9
  GC Content: 48.1%

Sample006:
  Total Reads: 29,000,000
  Passed QC: 28,420,000 (98.0%)
  Failed QC: 580,000 (2.0%)
  Average Quality: 36.3
  GC Content: 47.5%

Summary:
  Total Samples: 5
  Total Reads: 135,000,000
  Overall Pass Rate: 97.6%
  Average GC Content: 48.2%
EOF

#############################################
# COMPLETION
#############################################

echo ""
echo "=== Sample Data Generation Complete ==="
echo ""
echo "Generated files:"
echo "  FASTA: $(ls fasta/ | wc -l) files"
echo "  FASTQ: $(ls fastq/ | wc -l) files (compressed)"
echo "  VCF: $(ls vcf/ | wc -l) files"
echo "  GTF: $(ls gtf/ | wc -l) files"
echo "  Expression: $(ls expression/ | wc -l) files"
echo "  Metadata: $(ls metadata/ | wc -l) files"
echo "  Logs: $(ls logs/ | wc -l) files"
echo ""
echo "Total size: $(du -sh . | cut -f1)"
echo ""
echo "Files are ready for use in exercises!"
echo "See README.md for usage examples."
