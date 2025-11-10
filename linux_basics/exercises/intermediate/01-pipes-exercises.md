# Intermediate Exercise 1: Pipes and Redirects

Master combining commands for powerful data processing pipelines.

## Setup

Create comprehensive practice data:

```bash
cd ~
mkdir -p pipes_practice
cd pipes_practice

# Create a sample gene list
cat > genes.txt << 'EOF'
BRCA1
TP53
EGFR
KRAS
BRCA1
MYC
TP53
BRCA2
EGFR
ALK
EOF

# Create sample FASTA
cat > sequences.fasta << 'EOF'
>gene1 kinase domain
ATCGATCGATCGATCG
>gene2 transcription factor
GCTAGCTAGCTAGCTA
>gene3 receptor
TTTTAAAACCCCGGGG
>gene4 kinase domain
ATCGATCGGGCCCAAA
EOF

# Create annotation data
cat > annotations.txt << 'EOF'
chr1	1000	2000	gene1	+
chr1	5000	6000	gene2	-
chr2	10000	11000	gene3	+
chr2	15000	16000	gene4	+
chr3	20000	21000	gene5	-
EOF

# Create sample list
cat > sample_list.txt << 'EOF'
sample001_tumor
sample002_normal
sample003_tumor
sample004_normal
sample005_tumor
sample006_normal
sample007_tumor
sample008_normal
sample009_tumor
sample010_normal
EOF

# Create log file
cat > analysis.log << 'EOF'
[INFO] Analysis started
[INFO] Loading data from sample001
[ERROR] File not found: sample001_R2.fastq
[WARNING] Low quality detected in sample002
[INFO] Processing sample003
[INFO] Processing sample004
[ERROR] Insufficient memory for sample005
[INFO] Processing sample006
[WARNING] Missing metadata for sample007
[INFO] Processing sample008
[INFO] Processing sample009
[ERROR] Pipeline failed at alignment step
[INFO] Analysis completed with errors
EOF

# Create VCF-like variant file
cat > variants.txt << 'EOF'
chr1	12345	A	G	SNP	30	PASS
chr1	23456	C	T	SNP	25	LOW_QUAL
chr2	34567	G	A	SNP	35	PASS
chr2	45678	AT	A	INDEL	40	PASS
chr3	56789	A	T	SNP	28	LOW_QUAL
chr3	67890	C	G	SNP	45	PASS
chrX	78901	G	C	SNP	32	PASS
chrX	89012	TAA	T	INDEL	38	PASS
EOF

# Create expression data
cat > expression.tsv << 'EOF'
Gene	Sample1	Sample2	Sample3
BRCA1	45.2	67.8	34.1
TP53	123.4	98.7	145.6
EGFR	234.5	189.2	267.8
KRAS	78.9	92.3	65.4
MYC	156.7	143.2	178.9
EOF

# Create various data files
mkdir -p data/{raw,processed,results}
touch data/raw/sample001.fastq
touch data/raw/sample002.fastq
touch data/raw/sample003.fastq
touch data/processed/sample001_trimmed.fastq
touch data/processed/sample002_trimmed.fastq
touch data/results/sample001_results.txt
touch data/results/sample002_results.txt
touch data/results/final_report.pdf

# Create script files
mkdir scripts
cat > scripts/align.sh << 'EOF'
#!/bin/bash
# Alignment script
echo "Running alignment..."
EOF

cat > scripts/qc.sh << 'EOF'
#!/bin/bash
# Quality control script
echo "Running QC..."
EOF
```

## Part 1: Basic Pipes

### Exercise 1.1: Simple Pipes

**Tasks:**
1. List files and count them
2. Display genes.txt and count lines
3. List files and search for "seq"
4. Show genes.txt and display first 5 lines

**Practice these:**
```bash
ls | wc -l
cat genes.txt | wc -l
ls | grep seq
cat genes.txt | head -5
```

**Question:** What's the difference between:
```bash
wc -l genes.txt
cat genes.txt | wc -l
```

### Exercise 1.2: Output Redirection

**Tasks:**
1. Save directory listing to `file_list.txt`
2. Append today's date to `file_list.txt`
3. Count genes and save result to `gene_count.txt`
4. Create a log file with timestamp

**Commands:**
```bash
ls > file_list.txt
date >> file_list.txt
wc -l genes.txt > gene_count.txt
echo "Log created at $(date)" > analysis_log.txt
```

**Challenge:** What happens if you use `>` twice on the same file?

### Exercise 1.3: Counting Unique Items

**Tasks:**
1. Sort genes.txt
2. Remove duplicates from sorted list
3. Count unique genes
4. Show frequency of each gene

**Build this pipeline step by step:**
```bash
cat genes.txt
cat genes.txt | sort
cat genes.txt | sort | uniq
cat genes.txt | sort | uniq | wc -l
cat genes.txt | sort | uniq -c
cat genes.txt | sort | uniq -c | sort -rn
```

**Question:** Why must you sort before using uniq?

### Exercise 1.4: FASTA File Analysis

**Tasks:**
1. Count sequences in sequences.fasta
2. Extract sequence IDs
3. Find sequences with "kinase"
4. Count total nucleotides (excluding headers)

**Solutions:**
```bash
grep -c ">" sequences.fasta
grep ">" sequences.fasta
grep "kinase" sequences.fasta
grep -v ">" sequences.fasta | tr -d '\n' | wc -c
```

### Exercise 1.5: Multi-Step Pipelines

**Tasks:**
1. Extract chromosome names from annotations.txt, sort, count unique
2. Get genes on chr1, extract gene names, sort
3. Count features per chromosome
4. Find genes on positive strand, sort by position

**Example:**
```bash
cut -f1 annotations.txt | sort | uniq -c
awk '$1=="chr1" {print $4}' annotations.txt | sort
cut -f1 annotations.txt | sort | uniq -c | sort -rn
awk '$5=="+" {print}' annotations.txt | sort -k2,2n
```

## Part 2: Creating Reports

### Exercise 2.1: Simple Text Report

**Task:** Create a summary report with multiple pieces of information.

**Requirements:**
```bash
echo "=== Analysis Summary ===" > report.txt
echo "Date: $(date)" >> report.txt
echo "" >> report.txt
echo "Total genes: $(wc -l < genes.txt)" >> report.txt
echo "Unique genes: $(sort genes.txt | uniq | wc -l)" >> report.txt
echo "Total sequences: $(grep -c ">" sequences.fasta)" >> report.txt
```

**Verify:** View report.txt and ensure formatting looks good.

### Exercise 2.2: Log File Analysis Report

**Task:** Analyze analysis.log and create summary.

**Requirements:**
1. Count total log entries
2. Count errors
3. Count warnings
4. List which samples had errors
5. Save to error_report.txt

**Solution framework:**
```bash
echo "=== Log Analysis ===" > error_report.txt
echo "Total entries: $(wc -l < analysis.log)" >> error_report.txt
echo "Errors: $(grep -c ERROR analysis.log)" >> error_report.txt
echo "Warnings: $(grep -c WARNING analysis.log)" >> error_report.txt
echo "" >> error_report.txt
echo "Error details:" >> error_report.txt
grep ERROR analysis.log >> error_report.txt
```

### Exercise 2.3: Variant Statistics

**Task:** Generate variant statistics from variants.txt.

**Calculate:**
1. Total variants
2. SNPs vs INDELs
3. PASS vs LOW_QUAL
4. Variants per chromosome

**Build the pipeline:**
```bash
echo "=== Variant Statistics ===" > variant_stats.txt
echo "Total variants: $(wc -l < variants.txt)" >> variant_stats.txt
echo "SNPs: $(grep -c SNP variants.txt)" >> variant_stats.txt
echo "INDELs: $(grep -c INDEL variants.txt)" >> variant_stats.txt
echo "PASS: $(grep -c PASS variants.txt)" >> variant_stats.txt
echo "" >> variant_stats.txt
echo "Variants per chromosome:" >> variant_stats.txt
cut -f1 variants.txt | sort | uniq -c | sort -rn >> variant_stats.txt
```

## Part 3: Error Handling

### Exercise 3.1: Redirecting Errors

**Tasks:**
1. Run a command that produces errors
2. Redirect errors to error.log
3. Redirect output to output.txt and errors separately
4. Redirect both to same file

**Practice:**
```bash
ls nonexistent_file 2> error.log
ls data/ > output.txt 2> error.log
ls data/ nonexistent_file &> combined.log
```

### Exercise 3.2: Suppressing Errors

**Task:** Sometimes you want to ignore errors.

**Commands:**
```bash
grep "pattern" * 2>/dev/null
find / -name "myfile.txt" 2>/dev/null
```

**When useful:** Searching directories where you don't have permissions.

## Part 4: Using tee

### Exercise 4.1: Split Output

**Tasks:**
1. Count genes, display AND save
2. Process data showing progress while saving
3. Create multi-stage pipeline with intermediate saves

**Examples:**
```bash
cat genes.txt | sort | tee sorted_genes.txt | uniq | wc -l
cat genes.txt | sort | uniq -c | tee counts.txt | sort -rn | head -3
```

**Question:** Why is `tee` useful for debugging?

### Exercise 4.2: Multiple tee Points

**Task:** Save results at multiple stages of a pipeline.

**Example:**
```bash
cat genes.txt | \
  tee step1_raw.txt | \
  sort | \
  tee step2_sorted.txt | \
  uniq -c | \
  tee step3_counted.txt | \
  sort -rn > step4_final.txt
```

**Verify:** Check each intermediate file.

## Part 5: Real-World Scenarios

### Exercise 5.1: Sample Processing

**Scenario:** Process sample_list.txt to separate tumor and normal samples.

**Tasks:**
1. Extract tumor samples
2. Extract normal samples
3. Count each type
4. Save lists to separate files

**Solution:**
```bash
grep tumor sample_list.txt > tumor_samples.txt
grep normal sample_list.txt > normal_samples.txt
echo "Tumor samples: $(wc -l < tumor_samples.txt)"
echo "Normal samples: $(wc -l < normal_samples.txt)"
```

### Exercise 5.2: Quality Filter

**Scenario:** Filter variants by quality score.

**Tasks:**
1. Extract variants with quality > 30
2. Save high-quality variants
3. Count by type (SNP/INDEL)
4. Count by chromosome

**Solution:**
```bash
awk '$6 > 30' variants.txt > high_quality.txt
echo "High quality variants: $(wc -l < high_quality.txt)"
grep -c SNP high_quality.txt
grep -c INDEL high_quality.txt
cut -f1 high_quality.txt | sort | uniq -c
```

### Exercise 5.3: Gene Expression Analysis

**Scenario:** Analyze expression.tsv data.

**Tasks:**
1. Extract gene names
2. Calculate average expression for BRCA1
3. Find gene with highest average expression
4. Create summary table

**Hints:**
```bash
cut -f1 expression.tsv | tail -n +2
awk '/BRCA1/ {print ($2+$3+$4)/3}' expression.tsv
```

### Exercise 5.4: File Organization Audit

**Scenario:** Audit data directory.

**Tasks:**
1. Count files in each subdirectory
2. List all .fastq files
3. Find which samples have processed data
4. Identify missing results files

**Solution framework:**
```bash
echo "=== Data Directory Audit ===" > audit.txt
echo "Raw files: $(find data/raw -type f | wc -l)" >> audit.txt
echo "Processed files: $(find data/processed -type f | wc -l)" >> audit.txt
echo "Results files: $(find data/results -type f | wc -l)" >> audit.txt
echo "" >> audit.txt
find data/raw -name "*.fastq" >> audit.txt
```

### Exercise 5.5: Log Parsing

**Scenario:** Extract useful information from analysis.log.

**Tasks:**
1. List all samples mentioned
2. Timeline of events (INFO messages)
3. Error summary with context
4. Identify failed samples

**Solution:**
```bash
# Extract sample numbers
grep -o 'sample[0-9]*' analysis.log | sort -u

# Timeline
grep INFO analysis.log | head -5

# Errors with context
grep -C 1 ERROR analysis.log

# Failed samples
grep ERROR analysis.log | grep -o 'sample[0-9]*' | sort -u
```

## Part 6: Advanced Pipelines

### Exercise 6.1: Complex Gene Analysis

**Task:** Comprehensive gene analysis pipeline.

**Requirements:**
1. Read genes.txt
2. Sort alphabetically
3. Remove duplicates
4. Count frequency of each gene in original list
5. Sort by frequency
6. Save top 3 to file
7. Display on screen

**Complete solution:**
```bash
sort genes.txt | uniq -c | sort -rn | tee gene_frequency.txt | head -3
```

### Exercise 6.2: Multi-File Processing

**Task:** Process all annotation-related files.

**Requirements:**
1. Combine information from multiple files
2. Cross-reference data
3. Generate unified report

**Example:**
```bash
echo "=== Combined Analysis ===" > combined_report.txt
echo "Genes in gene list: $(wc -l < genes.txt)" >> combined_report.txt
echo "Genes in annotations: $(cut -f4 annotations.txt | sort -u | wc -l)" >> combined_report.txt
echo "Common genes: $(comm -12 <(sort genes.txt | uniq) <(cut -f4 annotations.txt | sort -u) | wc -l)" >> combined_report.txt
```

### Exercise 6.3: Data Transformation

**Task:** Transform data format using pipes.

**From annotations.txt:**
```
chr1	1000	2000	gene1	+
```

**To:**
```
gene1: chr1:1000-2000 (+)
```

**Solution:**
```bash
awk '{printf "%s: %s:%s-%s (%s)\n", $4, $1, $2, $3, $5}' annotations.txt
```

## Part 7: Debugging Pipelines

### Exercise 7.1: Build Incrementally

**Practice building a complex pipeline step by step:**

```bash
# Step 1
cat genes.txt

# Step 2
cat genes.txt | sort

# Step 3
cat genes.txt | sort | uniq

# Step 4
cat genes.txt | sort | uniq -c

# Step 5
cat genes.txt | sort | uniq -c | sort -rn

# Final
cat genes.txt | sort | uniq -c | sort -rn | head -3
```

### Exercise 7.2: Using tee for Debugging

**Task:** Debug why a pipeline isn't working.

**Problematic pipeline:**
```bash
cat genes.txt | grep "BRCA" | sort | uniq -c | sort -rn > result.txt
```

**Add tee at each stage:**
```bash
cat genes.txt | \
  tee debug1.txt | \
  grep "BRCA" | \
  tee debug2.txt | \
  sort | \
  tee debug3.txt | \
  uniq -c | \
  tee debug4.txt | \
  sort -rn > result.txt
```

**Check each debug file to find where it breaks!**

## Challenge Exercises

### Challenge 8.1: Complete Analysis Pipeline

**Scenario:** Comprehensive variant analysis.

**Requirements:**
1. Filter high-quality variants (>30)
2. Separate SNPs and INDELs
3. Count by chromosome
4. Calculate statistics
5. Generate formatted report
6. Save all intermediate results

**Build this as one comprehensive pipeline!**

### Challenge 8.2: Automated QC Report

**Task:** Create automated quality control report generator.

**Requirements:**
1. Accept filename as input
2. Count records
3. Check for errors/warnings
4. Calculate statistics
5. Generate formatted report
6. Include timestamp

**Template:**
```bash
#!/bin/bash
FILE=$1

echo "=== QC Report for $FILE ===" > qc_report.txt
echo "Generated: $(date)" >> qc_report.txt
# Add your pipeline here
```

### Challenge 8.3: Multi-Sample Comparison

**Task:** Compare multiple samples.

**Requirements:**
1. Process each sample
2. Extract key statistics
3. Compare across samples
4. Identify outliers
5. Generate comparison table

## Reflection Questions

1. What's the difference between `>` and `>>`?
2. When should you use `tee`?
3. How do you redirect errors?
4. Why build pipelines incrementally?
5. What's the advantage of pipes over intermediate files?
6. When would you save intermediate results?

## Best Practices Learned

✓ **Build incrementally** - Test each step
✓ **Use tee for debugging** - See intermediate results
✓ **Save important outputs** - Don't rely only on final result
✓ **Redirect errors** - Handle them appropriately
✓ **Document complex pipelines** - Add comments
✓ **Test on small data first** - Before full dataset
✓ **Use meaningful filenames** - For saved outputs

## Quick Reference

### Redirection

| Symbol | Purpose | Example |
|--------|---------|---------|
| `>` | Redirect output (overwrite) | `ls > files.txt` |
| `>>` | Redirect output (append) | `date >> log.txt` |
| `2>` | Redirect errors | `cmd 2> error.log` |
| `&>` | Redirect both | `cmd &> all.log` |
| `\|` | Pipe to next command | `cat file \| grep pattern` |
| `\| tee` | Split output | `cmd \| tee file.txt` |

## Next Steps

Ready for text processing? Move to:
- [Text Processing Exercises](02-text-processing-exercises.md)

---

**Estimated time:** 60-90 minutes

**Key skills practiced:**
- Building command pipelines
- Output redirection
- Error handling
- Using tee effectively
- Creating reports
- Real-world data processing
- Debugging pipelines
