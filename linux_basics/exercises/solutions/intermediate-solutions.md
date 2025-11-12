# Intermediate Exercise Solutions

Complete solutions for all intermediate exercises. These build on beginner skills with more complex pipelines and text processing.

---

## Exercise 1: Pipes and Redirects Solutions

### Exercise 1.1: Simple Pipes

```bash
# 1. List files and count
ls | wc -l

# 2. Display and count lines
cat genes.txt | wc -l
# More efficient:
wc -l < genes.txt

# 3. List and search
ls | grep seq

# 4. Show first 5 lines
cat genes.txt | head -5
# More efficient:
head -5 genes.txt
```

**Note:** Direct commands are often more efficient than unnecessary pipes, but pipes are useful for complex operations.

### Exercise 1.3: Counting Unique Items

```bash
# Build incrementally:

# 1. Sort genes
sort genes.txt

# 2. Remove duplicates
sort genes.txt | uniq

# 3. Count unique
sort genes.txt | uniq | wc -l

# 4. Show frequency
sort genes.txt | uniq -c

# 5. Sort by frequency (most common first)
sort genes.txt | uniq -c | sort -rn
```

### Exercise 1.4: FASTA File Analysis

```bash
# 1. Count sequences
grep -c ">" sequences.fasta

# 2. Extract IDs
grep ">" sequences.fasta

# 3. Find kinase sequences
grep "kinase" sequences.fasta

# 4. Count total nucleotides
grep -v ">" sequences.fasta | tr -d '\n' | wc -c
```

### Exercise 2.1: Simple Text Report

```bash
# Complete report generation
echo "=== Analysis Summary ===" > report.txt
echo "Date: $(date)" >> report.txt
echo "" >> report.txt
echo "Total genes: $(wc -l < genes.txt)" >> report.txt
echo "Unique genes: $(sort genes.txt | uniq | wc -l)" >> report.txt
echo "Total sequences: $(grep -c ">" sequences.fasta)" >> report.txt
echo "" >> report.txt
echo "Most common genes:" >> report.txt
sort genes.txt | uniq -c | sort -rn | head -3 >> report.txt
```

### Exercise 2.2: Log File Analysis Report

```bash
# Complete log analysis
echo "=== Log Analysis ===" > error_report.txt
echo "Analysis run: $(date)" >> error_report.txt
echo "" >> error_report.txt
echo "Total entries: $(wc -l < analysis.log)" >> error_report.txt
echo "Errors: $(grep -c ERROR analysis.log)" >> error_report.txt
echo "Warnings: $(grep -c WARNING analysis.log)" >> error_report.txt
echo "" >> error_report.txt
echo "Error details:" >> error_report.txt
grep ERROR analysis.log >> error_report.txt
echo "" >> error_report.txt
echo "Warning details:" >> error_report.txt
grep WARNING analysis.log >> error_report.txt
```

### Exercise 5.1: Sample Processing

```bash
# Extract tumor samples
grep tumor sample_list.txt > tumor_samples.txt

# Extract normal samples
grep normal sample_list.txt > normal_samples.txt

# Count each type
echo "Tumor samples: $(wc -l < tumor_samples.txt)"
echo "Normal samples: $(wc -l < normal_samples.txt)"

# Combined report
{
    echo "=== Sample Summary ==="
    echo "Total samples: $(wc -l < sample_list.txt)"
    echo "Tumor samples: $(wc -l < tumor_samples.txt)"
    echo "Normal samples: $(wc -l < normal_samples.txt)"
} > sample_summary.txt
```

### Exercise 5.2: Quality Filter

```bash
# Extract high-quality variants
awk '$6 > 30' variants.txt > high_quality.txt

# Report
echo "High quality variants: $(wc -l < high_quality.txt)"

# Count by type
echo "SNPs: $(grep -c SNP high_quality.txt)"
echo "INDELs: $(grep -c INDEL high_quality.txt)"

# Count by chromosome
echo "=== Variants per chromosome ==="
cut -f1 high_quality.txt | sort | uniq -c

# Complete analysis
{
    echo "=== Variant Quality Analysis ==="
    echo "Total variants: $(wc -l < variants.txt)"
    echo "High quality (>30): $(wc -l < high_quality.txt)"
    echo "Low quality: $(awk '$6 <= 30' variants.txt | wc -l)"
    echo ""
    echo "High quality by type:"
    echo "  SNPs: $(grep -c SNP high_quality.txt)"
    echo "  INDELs: $(grep -c INDEL high_quality.txt)"
} > variant_qc.txt
```

---

## Exercise 2: Text Processing Solutions

### Exercise 1.1: Basic Column Extraction

```bash
# 1. Gene names (column 1)
cut -f1 expression.tsv

# 2. Sample1 values (column 2)
cut -f2 expression.tsv

# 3. Columns 1 and 3
cut -f1,3 expression.tsv

# 4. Columns 2-5 (all samples)
cut -f2-5 expression.tsv
```

### Exercise 1.4: Combining cut with Pipes

```bash
# 1. Extract and sort gene names
cut -f1 expression.tsv | sort

# 2. Extract Sample1, sort numerically
cut -f2 expression.tsv | tail -n +2 | sort -n

# 3. Extract tumor sample IDs
grep tumor samples.csv | cut -d',' -f1

# 4. Count unique chromosomes
cut -f1 variants.tsv | sort -u | wc -l
```

### Exercise 2.1: Basic Sorting

```bash
# 1. Sort by gene name
sort expression.tsv

# 2. Sort by position (column 2, numeric)
sort -k2,2n variants.tsv

# 3. Sort by age
sort -t',' -k2,2n samples.csv

# 4. Reverse sort by age
sort -t',' -k2,2nr samples.csv
```

### Exercise 2.2: Multi-Column Sorting

```bash
# 1. Sort by chromosome, then position
sort -k1,1 -k2,2n variants.tsv

# 2. Sort by Status, then Age
sort -t',' -k4,4 -k2,2n samples.csv

# 3. Sort by Sample1 descending
sort -k2,2nr expression.tsv
```

### Exercise 3.2: Count Frequencies

```bash
# 1. Variants per chromosome
cut -f1 variants.tsv | sort | uniq -c

# 2. Samples by status
cut -d',' -f4 samples.csv | tail -n +2 | sort | uniq -c

# 3. Variants by type
cut -f6 variants.tsv | sort | uniq -c

# 4. Most common consequence
cut -f9 variants.tsv | sort | uniq -c | sort -rn | head -1
```

### Exercise 4.1: Case Conversion

```bash
# 1. Uppercase gene names
cut -f1 expression.tsv | tr 'a-z' 'A-Z'

# 2. Lowercase
cut -f1 expression.tsv | tr 'A-Z' 'a-z'

# 3. Uppercase sequences
grep -v ">" sequences.txt | tr 'a-z' 'A-Z'
```

### Exercise 4.2: Character Deletion

```bash
# 1. Remove all spaces
tr -d ' ' < messy_data.txt

# 2. Join sequences (remove newlines)
grep -v ">" sequences.txt | tr -d '\n'

# 3. Remove quotes
tr -d '"' < annotations.gtf

# 4. Keep only ATCG
grep -v ">" sequences.txt | tr -d '\n' | tr -cd 'ATCG'
```

### Exercise 5.2: Filtering with awk

```bash
# 1. Genes with Sample1 > 100
awk '$2 > 100' expression.tsv

# 2. Variants with quality > 0.8
awk '$5 > 0.8' variants.tsv

# 3. Tumor samples only
awk -F',' '$4=="tumor"' samples.csv

# 4. SNPs only
awk '$6=="SNP"' variants.tsv
```

### Exercise 5.3: Calculations with awk

```bash
# 1. Average of Sample1 column
awk 'NR>1 {sum+=$2; count++} END {print sum/count}' expression.tsv

# 2. Sum of Sample2 column
awk 'NR>1 {sum+=$3} END {print sum}' expression.tsv

# 3. Row-wise average (excluding header)
awk 'NR>1 {avg=($2+$3+$4+$5)/4; print $1, avg}' expression.tsv

# 4. Count rows meeting condition
awk 'NR>1 && $2>100 {count++} END {print count}' expression.tsv
```

### Exercise 5.5: Complex awk Operations

```bash
# Calculate sequence lengths
awk '/^>/ {
    if (seq) {
        print id, length(seq)
    }
    id=$0
    seq=""
}
!/^>/ {
    seq=seq $0
}
END {
    print id, length(seq)
}' sequences.txt
```

### Exercise 5.6: awk with Multiple Conditions

```bash
# 1. chr1 variants with quality > 0.7
awk '$1=="chr1" && $5>0.7' variants.tsv

# 2. Tumor samples older than 50
awk -F',' '$2>50 && $4=="tumor"' samples.csv

# 3. Count passing vs failing SNPs
awk '$6=="SNP" && $7=="PASS" {pass++} 
     $6=="SNP" && $7!="PASS" {fail++} 
     END {print "Pass:", pass, "Fail:", fail}' variants.tsv
```

### Exercise 6.1: Basic Find and Replace

```bash
# 1. Replace tumor with cancer
sed 's/tumor/cancer/' samples.csv

# 2. Replace commas with tabs
sed 's/,/\t/g' samples.csv

# 3. First occurrence vs all
sed 's/tumor/cancer/' samples.csv      # First only
sed 's/tumor/cancer/g' samples.csv     # All occurrences
```

### Exercise 6.2: Line-Specific Operations

```bash
# 1. Print line 5
sed -n '5p' expression.tsv

# 2. Print lines 3-7
sed -n '3,7p' expression.tsv

# 3. Delete first line (header)
sed '1d' expression.tsv

# 4. Delete last line
sed '$d' expression.tsv
```

### Exercise 6.3: Pattern-Based Operations

```bash
# 1. Delete lines with LOW_QUAL
sed '/LOW_QUAL/d' variants.tsv

# 2. Delete blank lines
sed '/^$/d' file.txt

# 3. Delete lines starting with #
sed '/^#/d' file.txt

# 4. Keep only PASS lines
sed '/PASS/!d' variants.tsv
```

### Exercise 7.1: Complete Analysis Pipeline

```bash
# Get top 3 expressed genes
cut -f1,2 expression.tsv | \
  tail -n +2 | \
  sort -k2,2nr | \
  head -3
```

### Exercise 7.2: Data Cleaning Pipeline

```bash
# Clean messy_data.txt
cat messy_data.txt | \
  tr -s ' ' '\t' | \
  sort -k1,1 > cleaned_data.tsv
```

### Exercise 7.3: Variant Analysis Pipeline

```bash
# High-quality missense variants by gene
awk '$5>0.7 && $9=="missense" {print $8}' variants.tsv | \
  sort | \
  uniq -c | \
  sort -rn
```

### Challenge 8.1: Create Summary Table

```bash
# Calculate min, max, average for each gene
awk 'NR>1 {
    min = $2
    max = $2
    sum = 0
    for (i=2; i<=5; i++) {
        if ($i < min) min = $i
        if ($i > max) max = $i
        sum += $i
    }
    avg = sum / 4
    printf "%-10s %8.2f %8.2f %8.2f\n", $1, min, max, avg
}' expression.tsv
```

---

## Exercise 3: Compression Solutions

### Exercise 1.1: Compressing Files

```bash
# 1. Compress data1.txt
gzip data1.txt
# File becomes data1.txt.gz, original is deleted

# 2. Check result
ls -lh data1.txt.gz

# 3. Compare sizes (need to decompress or check before)
# Before compressing, note size with: ls -lh data1.txt

# 4. Compress multiple files, keeping originals
gzip -k data2.txt sample*.txt
```

### Exercise 1.2: Compression Levels

```bash
# Create test copies
cp large_file.txt test1.txt
cp large_file.txt test6.txt
cp large_file.txt test9.txt

# Compress with different levels
time gzip -1 test1.txt    # Fast
time gzip -6 test6.txt    # Default
time gzip -9 test9.txt    # Best compression

# Compare
ls -lh test*.gz

# Results show:
# -1: Fastest, larger file
# -6: Balanced
# -9: Slowest, smallest file
```

### Exercise 2.1: Viewing Compressed Files

```bash
# Compress first
gzip reads.fastq

# 1. View without decompressing
zcat reads.fastq.gz

# 2. First 10 lines
zcat reads.fastq.gz | head -10

# 3. Last 10 lines
zcat reads.fastq.gz | tail -10

# 4. Browse interactively
zless reads.fastq.gz
```

### Exercise 2.2: Searching in Compressed Files

```bash
# 1. Search for read ID
zgrep "@read1" reads.fastq.gz

# 2. Count reads
echo $(($(zcat reads.fastq.gz | wc -l) / 4))

# 3. Search multiple files
zgrep "ATCG" *.gz

# 4. Extract with context
zgrep -A 3 "@read1" reads.fastq.gz
```

### Exercise 3.1: Creating Archives

```bash
# 1. Create tar archive
tar -cf project1.tar project1/

# 2. Create compressed archive
tar -czf project1.tar.gz project1/

# 3. Create with verbose output
tar -czvf project1_verbose.tar.gz project1/

# 4. Archive multiple directories
tar -czf projects.tar.gz project1/ project2/
```

### Exercise 3.2: Listing Archive Contents

```bash
# 1. List contents
tar -tzf project1.tar.gz

# 2. List with details
tar -tzvf project1.tar.gz

# 3. Search for specific files
tar -tzf project1.tar.gz | grep "scripts"
```

### Exercise 3.3: Extracting Archives

```bash
# 1. Extract entire archive
tar -xzf project1.tar.gz

# 2. Extract to specific directory
tar -xzf project1.tar.gz -C /tmp/

# 3. Extract specific file
tar -xzf project1.tar.gz project1/scripts/analyze.sh

# 4. Extract with verbose
tar -xzvf project1.tar.gz
```

### Exercise 4.1: Archiving Analysis Results

```bash
# Create dated archive excluding large files
tar -czf analysis_results_$(date +%Y%m%d).tar.gz \
    --exclude="*.tmp" \
    --exclude="*.bam" \
    project1/results/

# Verify
tar -tzf analysis_results_*.tar.gz | head

# Check size
ls -lh analysis_results_*.tar.gz
```

### Exercise 4.2: Compressing Sequencing Data

```bash
# Compress all FASTQ files
for file in *.fastq; do
    echo "Compressing $file..."
    gzip -v "$file"
done

# Verify integrity
for file in *.fastq.gz; do
    gunzip -t "$file" && echo "$file: OK" || echo "$file: FAILED"
done

# Report
{
    echo "=== Compression Report ==="
    echo "Date: $(date)"
    echo ""
    ls -lh *.fastq.gz
} > compression_report.txt
```

### Exercise 5.1: Working with Streaming Data

```bash
# Generate and compress
seq 1 100000 | gzip > numbers.txt.gz

# Process compressed to compressed
zcat input.fastq.gz | \
    awk 'NR%4==2 {if (length($0)>=30) print header; print; print plus; print qual}
         NR%4==1 {header=$0} NR%4==3 {plus=$0} NR%4==0 {qual=$0}' | \
    gzip > filtered.fastq.gz

# Extract subset
zcat reads.fastq.gz | head -40 | gzip > sample_reads.fastq.gz
```

---

## Exercise 4: Sequence Files Solutions

### Exercise 4.1: Basic FASTA Statistics

```bash
# 1. Count sequences
grep -c ">" sequences.fasta

# 2. Count lines
wc -l sequences.fasta

# 3. Average lines per sequence
total=$(wc -l < sequences.fasta)
seqs=$(grep -c ">" sequences.fasta)
echo "$total / $seqs" | bc

# 4. Count kinase genes
grep -c "kinase" sequences.fasta

# 5. Unique gene names
grep ">" sequences.fasta | cut -d' ' -f1 | sort -u | wc -l
```

### Exercise 4.4: Sequence Length Analysis

```bash
# Calculate length of each sequence
awk '/^>/ {
    if (seq) {
        print id, length(seq)
    }
    id=$1
    seq=""
} 
!/^>/ {
    seq=seq $0
} 
END {
    print id, length(seq)
}' sequences.fasta

# Find longest
awk '/^>/ {
    if (seq) {
        len=length(seq)
        if (len>max) {max=len; maxid=id}
    }
    id=$0
    seq=""
} 
!/^>/ {
    seq=seq $0
} 
END {
    print maxid, max
}' sequences.fasta

# Count sequences > 50bp
awk '/^>/ {
    if (seq && length(seq)>50) count++
    seq=""
} 
!/^>/ {
    seq=seq $0
} 
END {
    if (length(seq)>50) count++
    print count
}' sequences.fasta
```

### Exercise 4.6: Format Conversion

```bash
# Multi-line to single-line FASTA
awk '/^>/ {
    if (NR>1) printf("\n")
    printf("%s\n",$0)
    next
} 
{
    printf("%s",$0)
} 
END {
    printf("\n")
}' sequences.fasta > single_line.fasta
```

### Exercise 4.7: GC Content Calculation

```bash
# Calculate GC content for each sequence
awk '/^>/ {
    if (seq) {
        gc = gsub(/[GCgc]/, "", seq)
        total = length(seq) + gc
        printf "%s\t%.2f%%\n", id, (gc/total)*100
    }
    id=$1
    seq=$0
    gsub(/^>/, "", seq)
    seq=""
} 
!/^>/ {
    seq=seq $0
} 
END {
    gc = gsub(/[GCgc]/, "", seq)
    total = length(seq) + gc
    printf "%s\t%.2f%%\n", id, (gc/total)*100
}' sequences.fasta
```

### Exercise 4.11: Basic FASTQ Statistics

```bash
# 1. Count reads
echo $(($(wc -l < reads.fastq) / 4))

# 2. Verify format (check line count divisible by 4)
lines=$(wc -l < reads.fastq)
if [ $((lines % 4)) -eq 0 ]; then
    echo "Valid FASTQ format"
else
    echo "Invalid: line count not divisible by 4"
fi

# 3. Check for duplicate IDs
awk 'NR%4==1' reads.fastq | sort | uniq -d

# 4. Total bases
awk 'NR%4==2 {sum+=length($0)} END {print sum}' reads.fastq
```

### Exercise 4.12: Read Length Distribution

```bash
# 1. Extract all lengths
awk 'NR%4==2 {print length}' reads.fastq

# 2. Find min/max
awk 'NR%4==2 {
    len=length($0)
    if (NR==2) {min=len; max=len}
    if (len<min) min=len
    if (len>max) max=len
} 
END {
    print "Min:", min, "Max:", max
}' reads.fastq

# 3. Calculate average
awk 'NR%4==2 {sum+=length($0); count++} 
     END {print sum/count}' reads.fastq

# 4. Length distribution
awk 'NR%4==2 {print length}' reads.fastq | sort -n | uniq -c
```

### Exercise 4.14: FASTQ to FASTA Conversion

```bash
# Basic conversion
awk 'NR%4==1 {print ">"substr($0,2)} 
     NR%4==2' reads.fastq > reads.fasta

# Only reads > 20bp
awk 'NR%4==1 {header=$0}
     NR%4==2 {if (length($0)>20) {print ">"substr(header,2); print}}' \
     reads.fastq > long_reads.fasta

# With read length in header
awk 'NR%4==1 {header=substr($0,2)}
     NR%4==2 {print ">"header" length:"length($0); print}' \
     reads.fastq > annotated_reads.fasta
```

### Exercise 4.16: Filtering Reads by Quality

```bash
# Remove reads with N bases
awk 'NR%4==1 {header=$0}
     NR%4==2 {seq=$0}
     NR%4==3 {plus=$0}
     NR%4==0 {
         if (seq !~ /N/) {
             print header; print seq; print plus; print
         }
     }' reads.fastq > filtered.fastq

# Remove reads with low quality (!)
awk 'NR%4==1 {header=$0}
     NR%4==2 {seq=$0}
     NR%4==3 {plus=$0}
     NR%4==0 {
         if ($0 !~ /!/) {
             print header; print seq; print plus; print
         }
     }' reads.fastq > high_quality.fastq
```

---

## Common Patterns and Tips

### Pattern 1: Incremental Pipeline Building

```bash
# Always build step by step
cat file.txt                    # Step 1
cat file.txt | command1         # Step 2
cat file.txt | command1 | cmd2  # Step 3
# etc.
```

### Pattern 2: Using tee for Debugging

```bash
# Save intermediate results
cat data | \
  tee step1.txt | \
  process1 | \
  tee step2.txt | \
  process2 > final.txt
```

### Pattern 3: FASTA Processing Template

```bash
# Standard FASTA awk template
awk '/^>/ {
    if (seq) {
        # Process previous sequence
        print id, length(seq)
    }
    id=$1
    seq=""
} 
!/^>/ {
    seq=seq $0
} 
END {
    # Process last sequence
    print id, length(seq)
}' sequences.fasta
```

### Pattern 4: FASTQ Processing Template

```bash
# Standard FASTQ awk template
awk 'NR%4==1 {header=$0}
     NR%4==2 {seq=$0}
     NR%4==3 {plus=$0}
     NR%4==0 {qual=$0
         # Your filtering logic here
         if (condition) {
             print header; print seq; print plus; print qual
         }
     }' reads.fastq
```

---

## Key Takeaways

✅ **Build pipelines incrementally** - Test each step

✅ **Use appropriate tools** - cut for simple, awk for complex

✅ **Always sort before uniq** - uniq only works on adjacent lines

✅ **Work with compressed data** - Save time and space

✅ **Use awk for calculations** - More powerful than cut/grep

✅ **Test on small data first** - Before running on full datasets

✅ **Save intermediate results** - When debugging complex pipelines

✅ **Document complex commands** - Future you will thank you

---

**Solutions complete for Exercises 1-4!** 🎉
