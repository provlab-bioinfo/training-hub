# Sample Data

This directory contains sample datasets for practicing Linux commands and bioinformatics workflows. All data is synthetic/simulated for educational purposes.

## 📁 Directory Structure

```
sample-data/
├── README.md                 # This file
├── setup.sh                  # Script to generate all sample data
├── fasta/                    # FASTA sequence files
├── fastq/                    # FASTQ sequencing reads
├── vcf/                      # Variant call format files
├── gtf/                      # Gene annotation files
├── expression/               # Gene expression data
├── metadata/                 # Sample metadata tables
└── logs/                     # Example log files
```

## 🚀 Quick Setup

Generate all sample data files:

```bash
cd sample-data
bash setup.sh
```

This creates ~50MB of practice data including:
- FASTA sequences
- FASTQ reads (compressed)
- VCF variants
- GTF annotations
- Expression matrices
- Sample metadata
- Analysis logs

## 📊 Dataset Descriptions

### FASTA Files (`fasta/`)

**human_genes.fasta** (50 human genes)
- Sequences from 100-5000 bp
- Includes gene descriptions
- Multi-line format

**contaminants.fasta** (Common contaminants)
- Adapter sequences
- PhiX control
- Vector sequences

**small_genome.fasta** (Minimal genome)
- 10 chromosomes
- 1000 bp each
- Good for quick tests

### FASTQ Files (`fastq/`)

**sample1_R1.fastq.gz** and **sample1_R2.fastq.gz**
- Paired-end reads
- 10,000 reads per file
- 150 bp read length
- Phred+33 quality encoding
- Some reads with low quality
- Some with N bases

**sample2_R1.fastq.gz** and **sample2_R2.fastq.gz**
- Similar to sample1
- Different sequences
- For comparison exercises

**sample3_single.fastq.gz**
- Single-end reads
- 5,000 reads
- Variable read lengths (50-200 bp)

### VCF Files (`vcf/`)

**variants.vcf**
- 1,000 variants
- SNPs and INDELs
- Multiple chromosomes
- Quality scores
- PASS/FAIL filters
- Typical INFO and FORMAT fields

**high_quality.vcf**
- Subset of variants.vcf
- Only PASS variants
- QUAL > 30

### GTF Files (`gtf/`)

**annotations.gtf**
- 100 genes
- Multiple transcripts per gene
- Exon annotations
- Gene names and IDs
- Standard GTF format

**subset.gtf**
- 20 genes
- Simplified annotations
- Good for quick tests

### Expression Data (`expression/`)

**counts.tsv**
- 500 genes × 12 samples
- Raw count data
- Tab-separated values
- 4 conditions × 3 replicates

**normalized.tsv**
- TPM normalized values
- Same genes/samples as counts.tsv

**metadata.csv**
- Sample information
- Condition, replicate, batch
- QC metrics

### Metadata (`metadata/`)

**samples.csv**
- Sample IDs
- Patient info (age, gender)
- Tissue type
- Batch information

**experiments.tsv**
- Experiment metadata
- Dates, protocols
- QC flags

### Log Files (`logs/`)

**analysis.log**
- Typical analysis pipeline output
- Timestamps
- INFO/WARNING/ERROR messages
- Sample processing records

**qc_report.log**
- Quality control results
- Read counts
- Quality metrics

## 📖 Usage Examples

### Basic Operations

```bash
# Count sequences in FASTA
grep -c ">" fasta/human_genes.fasta

# Count reads in FASTQ
echo $(($(zcat fastq/sample1_R1.fastq.gz | wc -l) / 4))

# Count variants in VCF
grep -vc "^#" vcf/variants.vcf

# View first few lines
head fasta/human_genes.fasta
zhead fastq/sample1_R1.fastq.gz | head
head vcf/variants.vcf
```

### Searching Operations

```bash
# Find specific gene in FASTA
grep "BRCA2" fasta/human_genes.fasta

# Search for adapter sequences in FASTQ
zgrep "AGATCGGAAGAGC" fastq/*.fastq.gz

# Find high-quality variants
awk '$6>40' vcf/variants.vcf

# Extract gene names from GTF
grep "gene_name" gtf/annotations.gtf | grep -o 'gene_name "[^"]*"' | cut -d'"' -f2
```

### Text Processing

```bash
# Calculate GC content of FASTA sequences
grep -v ">" fasta/human_genes.fasta | \
  tr -d '\n' | \
  awk '{gc=gsub(/[GC]/,""); at=gsub(/[AT]/,""); print "GC%:", (gc/(gc+at))*100}'

# Count variants per chromosome
grep -v "^#" vcf/variants.vcf | cut -f1 | sort | uniq -c

# Extract top expressed genes
sort -k2,2nr expression/normalized.tsv | head -10

# Analyze sample metadata
cut -d',' -f4 metadata/samples.csv | tail -n +2 | sort | uniq -c
```

### Pipelines

```bash
# Quality filter FASTQ reads
zcat fastq/sample1_R1.fastq.gz | \
  paste - - - - | \
  awk -F'\t' '$2 !~ /N/ {print $1"\n"$2"\n"$3"\n"$4}' | \
  gzip > filtered_sample1.fastq.gz

# Extract high-quality SNPs from specific chromosome
awk '$1=="chr1" && $6>30 && length($4)==1 && length($5)==1' vcf/variants.vcf

# Count reads per sample from log
grep "reads processed" logs/analysis.log | \
  awk '{print $2, $4}' | \
  sort -k2,2nr
```

## 🎓 Practice Exercises

Use this data to practice exercises from the tutorials:

1. **Beginner (Navigation & File Ops):**
   - Navigate through directories
   - Create organized analysis structure
   - Copy and organize sample files

2. **Beginner (Viewing & Searching):**
   - View different file formats
   - Count sequences and variants
   - Search for specific patterns

3. **Intermediate (Pipes & Text Processing):**
   - Build analysis pipelines
   - Extract and transform data
   - Generate summary statistics

4. **Intermediate (Sequence Files):**
   - FASTA/FASTQ manipulation
   - Quality assessment
   - Format conversions

## 📊 Dataset Statistics

After running setup.sh:

```
FASTA Files:
- human_genes.fasta: 50 genes, ~125 KB
- contaminants.fasta: 4 sequences, ~1 KB
- small_genome.fasta: 3 chromosomes, ~1 KB

FASTQ Files (compressed):
- sample1: 20,000 reads (R1+R2), ~2 MB
- sample2: 20,000 reads (R1+R2), ~2 MB  
- sample3: 5,000 reads (single), ~500 KB

VCF Files:
- variants.vcf: 1,000 variants, ~150 KB
- high_quality.vcf: ~600 variants, ~90 KB

GTF Files:
- annotations.gtf: 100 genes, ~50 KB
- subset.gtf: 20 genes, ~10 KB

Expression Data:
- counts.tsv: 500 genes × 12 samples, ~250 KB
- normalized.tsv: 500 genes × 12 samples, ~300 KB
- metadata.csv: 12 samples, ~1 KB

Total: ~6-8 MB (after compression)
```

## 🔧 Customization

To generate larger datasets, modify setup.sh:

```bash
# In setup.sh, change these values:

# More FASTQ reads
for i in {1..50000}; do  # Was 10000

# More genes in FASTA
for i in {6..200}; do    # Was 50

# More variants in VCF
for i in {1..10000}; do  # Was 1000

# More genes in expression data
for i in {1..2000}; do   # Was 500
```

## ⚠️ Notes

- All data is **synthetic/simulated** for educational purposes
- Sequences are randomly generated (not real biological sequences)
- Quality scores are simplified (not reflecting real sequencer output)
- Use only for learning Linux commands, not for biological analysis
- File sizes are kept small for quick setup and Git compatibility

## 🤝 Contributing

To add new sample datasets:

1. Add generation code to setup.sh
2. Document the dataset in this README
3. Keep files small (< 1 MB each if possible)
4. Use realistic formats and structures
5. Test with relevant exercises

## 📚 Related Files

- See `../exercises/` for practice exercises using this data
- See `../docs/` for tutorials on processing these file types
- See `../exercises/solutions/` for example analyses

## 🐛 Troubleshooting

**setup.sh fails:**
- Check bash is available: `bash --version`
- Check disk space: `df -h .`
- Check write permissions: `ls -ld .`

**FASTQ generation is slow:**
- Reduce number of reads in setup.sh
- Or download pre-generated data (if provided)

**Files too large for Git:**
- Already compressed where possible
- Consider using Git LFS for fastq.gz files
- Or exclude from repository (document download location)

---

**Ready to start learning?** Run `bash setup.sh` and begin practicing!
