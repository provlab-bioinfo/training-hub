# Bioinformatics File Formats

Bioinformatics uses specific file formats for different types of data. Understanding these formats is essential for working with sequence data, alignments, variants, and annotations. This tutorial covers the most common formats you'll encounter.
***

<details>
<summary>FASTA Format - Sequences</summary>

FASTA is the most basic and widely used format for nucleotide or protein sequences.

### Structure

```
>sequence_id description
ATCGATCGATCGATCGATCG
GCTAGCTAGCTAGCTAGCTA
>another_sequence some description
TTTTAAAACCCCGGGG
```

**Components:**
- **Header line**: Starts with `>`, followed by sequence ID and optional description
- **Sequence lines**: The actual sequence (can span multiple lines)

### Examples

**Single sequence:**
```
>chr1 Homo sapiens chromosome 1
ATCGATCGATCGATCGATCG
GCTAGCTAGCTAGCTAGCTA
```

**Multiple sequences:**
```
>gene1 hypothetical protein
ATGGCTAGCATCGATCG
>gene2 kinase domain
ATGAAATTTCCCGGGAAA
>gene3 transcription factor
ATGGGCTAG
```

### Working with FASTA Files

**Count sequences:**
```bash
grep -c ">" sequences.fasta
```

**Extract sequence IDs:**
```bash
grep ">" sequences.fasta
# Or just IDs without descriptions:
grep ">" sequences.fasta | cut -d' ' -f1
```

**Get specific sequence:**
```bash
awk -v seq="gene1" '/^>/ {p=($0~seq)} p' sequences.fasta
```

**Count total bases:**
```bash
grep -v ">" sequences.fasta | tr -d '\n' | wc -c
```

**Calculate sequence lengths:**
```bash
awk '/^>/ {if (seq) print id,length(seq); id=$1; seq=""} !/^>/ {seq=seq $0} END {print id,length(seq)}' sequences.fasta
```

**Find sequences longer than 1000bp:**
```bash
awk '/^>/ {if (seq && length(seq)>1000) print header"\n"seq; header=$0; seq=""} !/^>/ {seq=seq $0} END {if (length(seq)>1000) print header"\n"seq}' sequences.fasta
```

**Convert to single-line format:**
```bash
awk '/^>/ {if (NR>1) printf("\n"); printf("%s\n",$0); next} {printf("%s",$0)} END {printf("\n")}' sequences.fasta
```

### FASTA Best Practices

- **One sequence per record** - each starts with `>`
- **No spaces in sequence IDs** - use underscores
- **Keep descriptions informative** but concise
- **Use standard nucleotide codes** (A, T, C, G, N)
- **Wrap sequences** at 60-80 characters (optional)
</details>

<details>
<summary>FASTQ Format - Sequences with Quality</summary>

FASTQ stores sequences with quality scores, primarily used for raw sequencing reads.

### Structure

Each read has **exactly 4 lines**:
```
@read_id description
ATCGATCGATCGATCG
+
IIIIIIIIIIIIIIII
```

1. **Line 1**: `@` followed by sequence ID and description
2. **Line 2**: Raw sequence
3. **Line 3**: `+` (optionally followed by ID again)
4. **Line 4**: Quality scores (same length as sequence)

### Example

```
@SEQ_ID_1
GATTTGGGGTTCAAAGCAGTATCGATCAAATAGTAAATCCATTTGTTCAACTCACAGTTT
+
!''*((((***+))%%%++)(%%%%).1***-+*''))**55CCF>>>>>>CCCCCCC65
@SEQ_ID_2
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTA
+
IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
```

### Quality Scores

Quality scores are encoded as ASCII characters. Each character represents the confidence in that base call.

**Common encodings:**
- **Phred+33** (Sanger, Illumina 1.8+): Most common
- **Phred+64** (Illumina 1.3-1.7): Older format

**Quality score meaning:**
- Higher ASCII value = better quality
- Q30 means 99.9% accuracy (1 in 1000 error)
- Q20 means 99% accuracy (1 in 100 error)

**Quality characters (Phred+33):**
```
!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJ
^                     ^        ^
Low quality           Q20      Q30 (high quality)
```

### Working with FASTQ Files

**Count reads:**
```bash
# Divide total lines by 4
echo $(($(wc -l < reads.fastq) / 4))

# For compressed files:
echo $(($(zcat reads.fastq.gz | wc -l) / 4))
```

**View first read:**
```bash
head -n 4 reads.fastq
```

**View first 10 reads:**
```bash
head -n 40 reads.fastq
```

**Extract read IDs:**
```bash
awk 'NR%4==1' reads.fastq
# Or with grep:
grep "^@" reads.fastq
```

**Extract sequences only:**
```bash
awk 'NR%4==2' reads.fastq
```

**Extract quality scores:**
```bash
awk 'NR%4==0' reads.fastq
```

**Check read lengths:**
```bash
awk 'NR%4==2 {print length}' reads.fastq | sort | uniq -c
```

**Convert FASTQ to FASTA:**
```bash
awk 'NR%4==1 {print ">"substr($0,2)} NR%4==2' reads.fastq > reads.fasta
```

**Extract subset of reads:**
```bash
# First 1000 reads (4000 lines)
head -n 4000 reads.fastq > subset.fastq

# Random sample
seqtk sample reads.fastq 1000 > sample.fastq  # If seqtk installed
```

**Search for reads with specific sequence:**
```bash
zcat reads.fastq.gz | awk '/^@/ {header=$0; getline seq; getline plus; getline qual; if (seq ~ /ATCGATCG/) print header"\n"seq"\n"plus"\n"qual}'
```

### FASTQ File Naming Conventions

**Single-end:**
```
sample_name.fastq
sample_name.fastq.gz
```

**Paired-end:**
```
sample_name_R1.fastq.gz    # Forward reads
sample_name_R2.fastq.gz    # Reverse reads

# Alternative naming:
sample_name_1.fastq.gz
sample_name_2.fastq.gz
```
</details>

<details>
<summary>SAM/BAM Format - Alignments</summary>

SAM (Sequence Alignment/Map) stores aligned sequences. BAM is the compressed binary version.

### SAM Structure

**Header lines** (start with `@`):
```
@HD	VN:1.0	SO:coordinate
@SQ	SN:chr1	LN:248956422
@PG	ID:bwa	PN:bwa	VN:0.7.17
```

**Alignment lines** (11 mandatory columns):
```
read_name	flag	chr	pos	mapq	cigar	mate_chr	mate_pos	tlen	seq	qual	[optional_tags]
```

### SAM Mandatory Fields

| Field | Name | Description |
|-------|------|-------------|
| 1 | QNAME | Query/read name |
| 2 | FLAG | Bitwise flags |
| 3 | RNAME | Reference name (chromosome) |
| 4 | POS | 1-based leftmost position |
| 5 | MAPQ | Mapping quality (0-255) |
| 6 | CIGAR | Alignment representation |
| 7 | RNEXT | Reference name of mate |
| 8 | PNEXT | Position of mate |
| 9 | TLEN | Template length |
| 10 | SEQ | Sequence |
| 11 | QUAL | Quality scores |

### SAM FLAGS

Common flag values:
```
1    = read paired
2    = read mapped in proper pair
4    = read unmapped
8    = mate unmapped
16   = read reverse strand
32   = mate reverse strand
64   = first in pair
128  = second in pair
256  = not primary alignment
512  = read fails quality checks
1024 = PCR or optical duplicate
2048 = supplementary alignment
```

**Add flags together:**
- Flag 99 = 1+2+32+64 = paired, proper pair, mate reverse, first in pair
- Flag 147 = 1+2+16+128 = paired, proper pair, reverse strand, second in pair

### Working with SAM/BAM Files

**Convert SAM to BAM:**
```bash
samtools view -b alignment.sam > alignment.bam
```

**Convert BAM to SAM:**
```bash
samtools view -h alignment.bam > alignment.sam
```

**Sort BAM file:**
```bash
samtools sort alignment.bam -o sorted.bam
```

**Index BAM file:**
```bash
samtools index sorted.bam
# Creates sorted.bam.bai
```

**View alignments:**
```bash
samtools view alignment.bam | head
samtools view -h alignment.bam | less  # Include header
```

**Get alignment statistics:**
```bash
samtools flagstat alignment.bam
samtools stats alignment.bam
```

**Filter alignments:**
```bash
# Extract mapped reads only
samtools view -F 4 alignment.bam > mapped.sam

# Extract unmapped reads
samtools view -f 4 alignment.bam > unmapped.sam

# Extract proper pairs
samtools view -f 2 alignment.bam > proper_pairs.sam

# Extract by chromosome
samtools view alignment.bam chr1 > chr1.sam

# Filter by mapping quality
samtools view -q 30 alignment.bam > high_quality.sam
```

**Count reads:**
```bash
samtools view -c alignment.bam              # All reads
samtools view -c -F 4 alignment.bam         # Mapped reads
samtools view -c -f 4 alignment.bam         # Unmapped reads
```

**Extract specific region:**
```bash
samtools view alignment.bam chr1:1000000-2000000
```

### BAM Best Practices

- **Always sort before indexing**
- **Index BAM files** for fast access
- **Use BAM not SAM** for storage (much smaller)
- **Keep sorted BAM and index together**
- **Use proper file naming** (sample.sorted.bam)
</details>

<details>
<summary>VCF Format - Variants</summary>

VCF (Variant Call Format) stores genetic variants (SNPs, indels, etc.).

### VCF Structure

**Header lines** (start with `##`):
```
##fileformat=VCFv4.2
##reference=hg38.fa
##INFO=<ID=DP,Number=1,Type=Integer,Description="Total Depth">
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
```

**Column header line** (starts with `#CHROM`):
```
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	sample1
```

**Data lines** (8 mandatory columns + sample columns):
```
chr1	12345	rs123	A	G	30	PASS	DP=50	GT:GQ	0/1:99
```

### VCF Columns

| Column | Description |
|--------|-------------|
| CHROM | Chromosome |
| POS | Position (1-based) |
| ID | Variant ID (rs number or `.`) |
| REF | Reference allele |
| ALT | Alternative allele(s) |
| QUAL | Quality score |
| FILTER | PASS or filter status |
| INFO | Additional information |
| FORMAT | Sample format fields |
| Samples | Sample-specific data |

### Genotype Field (GT)

```
0/0  = Homozygous reference
0/1  = Heterozygous
1/1  = Homozygous alternate
./.  = Missing/unknown
```

### Working with VCF Files

**Skip header:**
```bash
grep -v "^#" variants.vcf
```

**Count variants:**
```bash
grep -v "^#" variants.vcf | wc -l
```

**Extract specific chromosome:**
```bash
grep -v "^#" variants.vcf | awk '$1=="chr1"'
```

**Filter by quality:**
```bash
awk '$1 !~ /^#/ && $6 > 30' variants.vcf
```

**Extract SNPs only:**
```bash
awk '$1 !~ /^#/ && length($4)==1 && length($5)==1' variants.vcf
```

**Extract indels:**
```bash
awk '$1 !~ /^#/ && (length($4)>1 || length($5)>1)' variants.vcf
```

**Count variants by chromosome:**
```bash
grep -v "^#" variants.vcf | cut -f1 | sort | uniq -c
```

**Get PASS variants only:**
```bash
awk '$1 !~ /^#/ && $7=="PASS"' variants.vcf
```

**Extract variant positions:**
```bash
grep -v "^#" variants.vcf | cut -f1,2
```

**Filter by region:**
```bash
awk '$1=="chr1" && $2>=1000000 && $2<=2000000' variants.vcf
```

### VCF Tools

**Using bcftools:**
```bash
# View VCF
bcftools view variants.vcf.gz | head

# Filter variants
bcftools view -f PASS variants.vcf.gz

# Query specific region
bcftools view -r chr1:1000000-2000000 variants.vcf.gz

# Convert to different format
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\n' variants.vcf.gz
```
</details>

<details>
<summary>GFF/GTF Format - Gene Annotations</summary>

GFF (General Feature Format) and GTF (Gene Transfer Format) store genomic features and annotations.

### GTF Structure

**9 tab-separated columns:**
```
chr1	source	feature	start	end	score	strand	frame	attributes
```

**Example:**
```
chr1	HAVANA	gene	11869	14409	.	+	.	gene_id "ENSG00000223972"; gene_name "DDX11L1";
chr1	HAVANA	transcript	11869	14409	.	+	.	gene_id "ENSG00000223972"; transcript_id "ENST00000456328";
chr1	HAVANA	exon	11869	12227	.	+	.	gene_id "ENSG00000223972"; transcript_id "ENST00000456328"; exon_number "1";
```

### GTF Columns

| Column | Description |
|--------|-------------|
| 1 | Chromosome/sequence name |
| 2 | Source (program that created) |
| 3 | Feature type (gene, exon, CDS) |
| 4 | Start position (1-based) |
| 5 | End position (inclusive) |
| 6 | Score (or `.`) |
| 7 | Strand (+, -, or .) |
| 8 | Frame (0, 1, 2, or .) |
| 9 | Attributes (key-value pairs) |

### Working with GTF/GFF Files

**Count features by type:**
```bash
cut -f3 annotations.gtf | sort | uniq -c
```

**Extract genes only:**
```bash
awk '$3=="gene"' annotations.gtf
```

**Extract gene names:**
```bash
grep "gene_name" annotations.gtf | grep -o 'gene_name "[^"]*"' | cut -d'"' -f2 | sort -u
```

**Get genes on specific chromosome:**
```bash
awk '$1=="chr1" && $3=="gene"' annotations.gtf
```

**Count genes per chromosome:**
```bash
awk '$3=="gene" {print $1}' annotations.gtf | sort | uniq -c
```

**Extract genes in specific region:**
```bash
awk '$1=="chr1" && $4>=1000000 && $5<=2000000 && $3=="gene"' annotations.gtf
```

**Find overlapping features:**
```bash
# Genes overlapping position 1500000 on chr1
awk '$1=="chr1" && $3=="gene" && $4<=1500000 && $5>=1500000' annotations.gtf
```

**Extract by gene name:**
```bash
awk '/gene_name "BRCA1"/' annotations.gtf
```
</details>

<details>
<summary>BED Format - Genomic Regions</summary>

BED format stores genomic coordinates (regions, features, etc.).

### BED Structure

**Minimum 3 columns** (up to 12 total):
```
chr1	1000	2000
chr1	5000	6000
chr2	10000	11000
```

**Standard 6-column format:**
```
chr	start	end	name	score	strand
chr1	1000	2000	region1	100	+
chr1	5000	6000	region2	200	-
```

**Features:**
- **0-based coordinates** (unlike most formats!)
- **End is exclusive** (end position not included)
- **Tab-separated**

### Working with BED Files

**Count regions:**
```bash
wc -l regions.bed
```

**Extract by chromosome:**
```bash
awk '$1=="chr1"' regions.bed
```

**Calculate region sizes:**
```bash
awk '{print $1, $2, $3, $3-$2}' regions.bed
```

**Sort BED file:**
```bash
sort -k1,1 -k2,2n regions.bed
```

**Merge overlapping regions (requires bedtools):**
```bash
bedtools merge -i sorted.bed
```
</details>

<details>
<summary>File Format Summary Table</summary>

| Format | Type | Typical Use | Compressed? |
|--------|------|-------------|-------------|
| FASTA | Text | Reference sequences, assembled genomes | Sometimes (.gz) |
| FASTQ | Text | Raw sequencing reads | Usually (.gz) |
| SAM | Text | Sequence alignments | Rarely |
| BAM | Binary | Sequence alignments (compressed SAM) | Yes (built-in) |
| VCF | Text | Genetic variants | Often (.gz) |
| BCF | Binary | Variants (compressed VCF) | Yes (built-in) |
| GTF/GFF | Text | Gene annotations | Sometimes (.gz) |
| BED | Text | Genomic coordinates | Sometimes (.gz) |
</details>

<details>
<summary>Format Conversion Tips</summary>

**FASTQ to FASTA:**
```bash
awk 'NR%4==1 {print ">"substr($0,2)} NR%4==2' reads.fastq > reads.fasta
```

**SAM to BAM:**
```bash
samtools view -b alignment.sam > alignment.bam
```

**BAM to FASTQ:**
```bash
samtools fastq alignment.bam > reads.fastq
```

**VCF to tab-delimited:**
```bash
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\n' variants.vcf > variants.txt
```

**GTF to BED:**
```bash
awk '$3=="exon" {print $1, $4-1, $5}' OFS='\t' annotations.gtf > exons.bed
```
</details>

<details>
<summary>Best Practices</summary>

### General

1. **Always compress large files** - Use gzip for text formats
2. **Check file integrity** - Use `gunzip -t` or `file` command
3. **Validate formats** - Many tools have validation options
4. **Keep consistent naming** - Use informative, systematic names
5. **Document processing steps** - Keep logs of format conversions

### File Naming

**Good:**
```
sample1_R1.fastq.gz
sample1_R2.fastq.gz
sample1.sorted.bam
sample1.sorted.bam.bai
sample1.vcf.gz
```

**Bad:**
```
file1.fq
data.txt
results_final_FINAL_v2.bam
```

### Storage

- **FASTQ**: Always compress (.gz)
- **BAM**: Keep sorted and indexed
- **VCF**: Compress and index with tabix
- **FASTA**: Reference genomes can be compressed
- **GTF/GFF**: Can compress if large
</details>

## Quick Reference

### Check File Type
```bash
file filename              # Identify file type
head filename              # View beginning
zless filename.gz          # Browse compressed file
```

### Count Records
```bash
# FASTA
grep -c ">" sequences.fasta

# FASTQ
echo $(($(zcat reads.fastq.gz | wc -l) / 4))

# BAM
samtools view -c alignment.bam

# VCF
grep -vc "^#" variants.vcf

# GTF
wc -l annotations.gtf
```

### Extract Headers
```bash
# FASTA
grep ">" sequences.fasta

# BAM
samtools view -H alignment.bam

# VCF
grep "^#" variants.vcf
```

## What's Next?

Congratulations! You've completed the Linux basics tutorial series. You now have the foundation to:

- Navigate and manage files efficiently
- Run bioinformatics programs
- Process and analyze sequence data
- Work with common file formats
- Build automated analysis pipelines

### Continue Learning

- **Practice regularly** - The more you use these tools, the better you'll get
- **Read tool documentation** - Most bioinformatics tools have excellent manuals
- **Join communities** - Biostars, SEQanswers, Reddit r/bioinformatics
- **Learn scripting** - Bash, Python, or R for automation
- **Explore advanced topics** - Job schedulers, containers, workflows

**Resources:**
- Bioinformatics tools documentation
- Server-specific guides from your administrator
- Online courses and tutorials
- Bioinformatics forums and communities

---

**Final Tip:** Keep a notebook of commands that work well for your analyses. Build your own library of one-liners and scripts!

**You're now ready to tackle real bioinformatics projects. Good luck!** 🧬🎉
