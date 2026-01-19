# Pipes and Redirects

Pipes and redirects are what make the Linux command line truly powerful. They let you combine simple commands to create sophisticated workflows. This is where Linux really shines for bioinformatics!

## The Big Picture

Think of Linux commands as LEGO blocks. Each command does one thing well, but you can connect them together to build complex analysis pipelines.

**The magic connectors:**
- **Pipe (`|`)** - Send output of one command to another
- **Redirect (`>`, `>>`)** - Send output to a file
- **Input (`<`)** - Read input from a file
***

<details>
<summary>Redirecting Output to Files</summary>

### The `>` Operator - Overwrite

Send command output to a file (creates new file or overwrites existing):

```bash
command > output.txt
```

**Examples:**

```bash
ls -l > file_list.txt              # Save directory listing
date > timestamp.txt               # Save current date
echo "Analysis started" > log.txt  # Write message to file
```

**Bioinformatics examples:**

```bash
# Save sequence IDs to file
grep ">" sequences.fasta > sequence_ids.txt

# Save alignment statistics
samtools flagstat alignment.bam > alignment_stats.txt

# Create sample list
ls *.fastq > sample_list.txt
```

⚠️ **Warning:** `>` overwrites the file if it exists!

```bash
echo "First line" > test.txt
echo "Second line" > test.txt      # First line is GONE!
cat test.txt
# Output: Second line
```

### The `>>` Operator - Append

Add output to the end of a file (creates file if it doesn't exist):

```bash
command >> output.txt
```

**Examples:**

```bash
echo "First line" > log.txt
echo "Second line" >> log.txt      # Adds to end
echo "Third line" >> log.txt       # Adds to end
cat log.txt
# Output:
# First line
# Second line
# Third line
```

**Bioinformatics examples:**

```bash
# Build a log file
echo "Analysis started: $(date)" > analysis.log
echo "Processing sample1..." >> analysis.log
echo "Processing sample2..." >> analysis.log
echo "Analysis complete: $(date)" >> analysis.log

# Combine results from multiple samples
for sample in sample1 sample2 sample3; do
    grep -c ">" ${sample}.fasta >> sequence_counts.txt
done

# Append statistics
samtools flagstat sample1.bam >> all_stats.txt
samtools flagstat sample2.bam >> all_stats.txt
```

### Redirecting Errors

Standard output (stdout) goes to file descriptor 1, errors (stderr) go to 2.

```bash
command > output.txt 2> error.txt          # Separate files
command > output.txt 2>&1                   # Errors to same file as output
command &> all_output.txt                   # Both to same file (shortcut)
command > output.txt 2>/dev/null            # Discard errors
```

**Example:**

```bash
# Run analysis, save output and errors separately
bwa mem ref.fa reads.fq > alignment.sam 2> bwa.log

# Save everything together
fastqc *.fastq &> fastqc_run.log

# Ignore error messages
grep "pattern" * 2>/dev/null               # Suppress "Permission denied" errors
```
</details>

<details>
<summary>The Pipe Operator `|`</summary>

A pipe takes the output of one command and sends it as input to another command.

```bash
command1 | command2
```

The output of `command1` becomes the input for `command2`.

### Basic Pipe Examples

```bash
# List files and count them
ls | wc -l

# Show processes and search for specific one
ps aux | grep python

# Display file and page through it
cat large_file.txt | less

# Sort file contents
cat unsorted.txt | sort
```

### Bioinformatics Pipe Examples

**Count sequences in FASTA:**
```bash
grep ">" sequences.fasta | wc -l
```

**Count unique sequences:**
```bash
grep -v ">" sequences.fasta | sort | uniq | wc -l
```

**Extract and sort gene names:**
```bash
grep "gene_name" annotations.gtf | cut -f9 | sort | uniq
```

**Find most common k-mer:**
```bash
grep -v ">" sequences.fasta | fold -w 3 | sort | uniq -c | sort -rn | head
```

**Count reads in FASTQ:**
```bash
cat reads.fastq | wc -l | awk '{print $1/4}'
# Or for compressed:
zcat reads.fastq.gz | wc -l | awk '{print $1/4}'
```

**Filter VCF by quality:**
```bash
grep -v "^#" variants.vcf | awk '$6 > 30' | wc -l
```

## Chaining Multiple Commands

You can chain many commands together!

```bash
command1 | command2 | command3 | command4
```

Each command processes the output of the previous one.

### Examples

**Complex sequence analysis:**
```bash
# Extract sequences, remove duplicates, count unique
grep -v ">" sequences.fasta | tr -d '\n' | fold -w 1 | sort | uniq -c | sort -rn
```

**Process gene list:**
```bash
# Extract gene names, sort, remove duplicates, save
grep "gene_name" annotations.gtf | cut -d'"' -f2 | sort | uniq > unique_genes.txt
```

**Quality filtering pipeline:**
```bash
# Filter variants, extract specific columns, count by type
grep -v "^#" variants.vcf | awk '$6 > 30' | cut -f8 | grep -o "TYPE=[^;]*" | sort | uniq -c
```

**Log analysis:**
```bash
# Find errors, count by type, show top 5
grep -i "error" *.log | cut -d':' -f2 | sort | uniq -c | sort -rn | head -5
```

**Sample processing summary:**
```bash
# List FASTQ files, extract sample names, sort, count
ls *.fastq | sed 's/_R[12].fastq//' | sort | uniq | wc -l
```
</details>

<details>
<summary>Input Redirection `<`</summary>

Send file contents as input to a command:

```bash
command < input.txt
```

This is less common than output redirection but useful in some cases.

**Examples:**

```bash
# Sort file contents
sort < unsorted.txt

# Count lines
wc -l < file.txt

# Process with multiple redirects
sort < input.txt > output.txt
```

**Equivalent to:**
```bash
sort input.txt > output.txt
```

Most commands can read from files directly, so `<` is less frequently used. It's mainly useful when a command expects stdin but you have a file.
</details>

<details>
<summary>Combining Pipes and Redirects</summary>

You can use pipes and redirects together!

```bash
command1 | command2 > output.txt
command1 < input.txt | command2 | command3 > output.txt
```

### Practical Examples

**Process and save results:**
```bash
# Count sequences and save result
grep ">" sequences.fasta | wc -l > sequence_count.txt

# Extract, sort, and save gene list
grep "gene_name" annotations.gtf | cut -d'"' -f2 | sort | uniq > genes.txt

# Complex filtering with saved output
zcat reads.fastq.gz | head -n 1000000 | grep "^@" | wc -l > read_count.txt
```

**Create summary statistics:**
```bash
# Generate alignment summary
samtools view -F 4 alignment.bam | wc -l > mapped_reads.txt
samtools view -f 4 alignment.bam | wc -l > unmapped_reads.txt
```

**Build processing logs:**
```bash
# Log each step
echo "Starting analysis: $(date)" > analysis.log
ls *.fastq | wc -l | awk '{print "Found " $1 " FASTQ files"}' >> analysis.log
grep -c ">" reference.fasta | awk '{print "Reference has " $1 " sequences"}' >> analysis.log
echo "Analysis complete: $(date)" >> analysis.log
```
</details>

<details>
<summary>The `tee` Command - Split Output</summary>

`tee` reads from stdin and writes to both stdout AND a file. It's like a T-junction in a pipe.

```bash
command | tee output.txt              # Display AND save
command | tee -a output.txt           # Display AND append
```

**Examples:**

```bash
# See results on screen AND save to file
ls -l | tee file_list.txt

# Continue pipeline while saving intermediate result
grep ">" sequences.fasta | tee sequence_ids.txt | wc -l

# Monitor and log simultaneously
tail -f analysis.log | tee -a monitoring.log
```

**Bioinformatics examples:**

```bash
# Count while saving IDs
grep ">" sequences.fasta | tee ids.txt | wc -l

# Process and save intermediate results
zcat reads.fastq.gz | tee raw_reads.fastq | quality_filter | tee filtered.fastq | aligner

# See and save statistics
samtools flagstat alignment.bam | tee stats.txt

# Log analysis with screen output
echo "Processing sample1" | tee -a analysis.log
fastqc sample1.fastq 2>&1 | tee -a analysis.log
```
</details>

<details>
<summary>Practical Workflows</summary>    

### Workflow 1: FASTA File Analysis

```bash
# Count total sequences
grep -c ">" sequences.fasta

# Count unique sequences
grep -v ">" sequences.fasta | sort | uniq | wc -l

# Get sequence length distribution
grep -v ">" sequences.fasta | awk '{print length}' | sort -n | uniq -c

# Find longest sequence
grep -v ">" sequences.fasta | awk '{print length}' | sort -rn | head -1

# Extract sequences longer than 1000bp
awk '/^>/ {if (seq) {if (length(seq) > 1000) print header "\n" seq} header=$0; seq=""} 
     !/^>/ {seq=seq $0} 
     END {if (length(seq) > 1000) print header "\n" seq}' sequences.fasta > long_seqs.fasta
```

### Workflow 2: FASTQ Quality Check

```bash
# Count total reads
echo "Total reads: $(zcat reads.fastq.gz | wc -l | awk '{print $1/4}')"

# Sample first 1000 reads
zcat reads.fastq.gz | head -n 4000 > sample_reads.fastq

# Extract quality scores and calculate mean
zcat reads.fastq.gz | awk 'NR%4==0' | head -1000 > quality_scores.txt

# Count reads by length
zcat reads.fastq.gz | awk 'NR%4==2 {print length}' | sort | uniq -c | sort -rn
```

### Workflow 3: VCF File Processing

```bash
# Count total variants (skip header)
grep -v "^#" variants.vcf | wc -l

# Count variants by chromosome
grep -v "^#" variants.vcf | cut -f1 | sort | uniq -c | sort -rn

# Extract high-quality variants
grep -v "^#" variants.vcf | awk '$6 > 30' > high_quality.vcf

# Count SNPs vs INDELs
grep -v "^#" variants.vcf | awk '{if (length($4)==1 && length($5)==1) print "SNP"; else print "INDEL"}' | sort | uniq -c

# Get variants on specific chromosome
grep -v "^#" variants.vcf | awk '$1=="chr1"' > chr1_variants.vcf
```

### Workflow 4: Gene Annotation Analysis

```bash
# Count genes per chromosome
grep "gene" annotations.gtf | cut -f1 | sort | uniq -c | sort -rn

# Extract unique gene names
grep "gene_name" annotations.gtf | grep -o 'gene_name "[^"]*"' | cut -d'"' -f2 | sort | uniq > gene_list.txt

# Count features by type
cut -f3 annotations.gtf | sort | uniq -c | sort -rn

# Extract genes in specific region
awk '$1=="chr1" && $4 > 1000000 && $5 < 2000000' annotations.gtf > region_genes.gtf
```

### Workflow 5: Log File Analysis

```bash
# Find all errors
grep -i "error" *.log | tee errors.txt

# Count errors by type
grep -i "error" *.log | sed 's/:.*//' | sort | uniq -c | sort -rn

# Extract timestamps of failures
grep -i "fail" *.log | grep -o "[0-9][0-9]:[0-9][0-9]:[0-9][0-9]"

# Summarize job completion
grep "successfully completed" *.log | wc -l | awk '{print $1 " jobs completed"}'
```

### Workflow 6: Creating Summary Reports

```bash
# Comprehensive analysis summary
{
    echo "=== Analysis Summary ==="
    echo "Date: $(date)"
    echo ""
    echo "=== Files ==="
    echo "Total FASTQ files: $(ls *.fastq.gz | wc -l)"
    echo "Total BAM files: $(ls *.bam | wc -l)"
    echo ""
    echo "=== Sequences ==="
    echo "Reference sequences: $(grep -c ">" reference.fasta)"
    echo ""
    echo "=== Disk Usage ==="
    du -sh .
} > summary_report.txt
```
</details>

<details>
<summary>Command Substitution</summary>

Use `$(command)` to insert command output into another command:

```bash
echo "There are $(ls | wc -l) files"
echo "Analysis started at $(date)"
```

**Bioinformatics examples:**

```bash
# Dynamic naming
output_file="results_$(date +%Y%m%d).txt"
echo "Saving to $output_file"

# Count in message
echo "Found $(grep -c ">" sequences.fasta) sequences"

# Use result in calculation
total_reads=$(zcat reads.fastq.gz | wc -l)
echo "Total reads: $((total_reads / 4))"

# Create dated backup
cp important_data.txt important_data_$(date +%Y%m%d).txt
```
</details>

<details>
<summary>Here Documents</summary>

Create multi-line input on the fly:

```bash
cat > file.txt << EOF
Line 1
Line 2
Line 3
EOF
```

**Example - create a script:**
```bash
cat > analyze.sh << 'EOF'
#!/bin/bash
echo "Starting analysis"
for file in *.fastq; do
    echo "Processing $file"
done
echo "Complete"
EOF
chmod +x analyze.sh
```
</details>

<details>
<summary>Process Substitution</summary>

Treat command output as a file:

```bash
diff <(sort file1.txt) <(sort file2.txt)
```

**Bioinformatics example:**

```bash
# Compare sorted gene lists
diff <(cut -f1 genes1.txt | sort) <(cut -f1 genes2.txt | sort)

# Compare sequence counts
diff <(grep -c ">" set1.fasta) <(grep -c ">" set2.fasta)
```
</details>

<details>
<summary>Best Practices</summary>    

1. **Build pipelines incrementally** - Test each step
   ```bash
   grep ">" sequences.fasta                    # Test first
   grep ">" sequences.fasta | wc -l            # Add counting
   grep ">" sequences.fasta | wc -l > count.txt # Add output
   ```

2. **Use `tee` for debugging** - See intermediate results
   ```bash
   command1 | tee step1.txt | command2 | tee step2.txt | command3
   ```

3. **Check before overwriting** - Use `>>` when appending
   ```bash
   ls results.txt          # Check if exists
   command > results.txt   # Then overwrite if desired
   ```

4. **Save important outputs** - Don't rely only on screen
   ```bash
   important_analysis | tee results.txt    # See AND save
   ```

5. **Comment complex pipelines** - Help future you
   ```bash
   # Extract genes, filter by chromosome, count unique
   grep "gene" file.gtf | awk '$1=="chr1"' | cut -f9 | sort -u | wc -l
   ```
</details>

<details>
<summary>Practice Exercises</summary>

### Exercise 1: Basic Redirects

```bash
# Create test data
echo "apple" > fruits.txt
echo "banana" >> fruits.txt
echo "cherry" >> fruits.txt

# Practice redirects
cat fruits.txt
sort fruits.txt > sorted_fruits.txt
cat sorted_fruits.txt
```

### Exercise 2: Simple Pipes

```bash
# Count files
ls | wc -l

# Sort and count unique
cat fruits.txt | sort | uniq | wc -l

# Search and count
ls -l | grep "txt" | wc -l
```

### Exercise 3: Complex Pipeline

```bash
# Create test FASTA
cat > test.fasta << EOF
>seq1
ATCGATCG
>seq2
GCTAGCTA
>seq1
ATCGATCG
>seq3
TTTTAAAA
EOF

# Count total sequences
grep -c ">" test.fasta

# Count unique sequences
grep -v ">" test.fasta | sort | uniq | wc -l

# Save results
grep ">" test.fasta | sort | uniq > unique_ids.txt
```

### Exercise 4: Using tee

```bash
# See and save simultaneously
ls -l | tee file_list.txt | wc -l

# Multi-step with tee
cat test.fasta | grep ">" | tee ids.txt | wc -l
```
</details>

***

## Quick Reference

| Operator | Description | Example |
|----------|-------------|---------|
| `>` | Redirect output (overwrite) | `ls > files.txt` |
| `>>` | Redirect output (append) | `echo "text" >> log.txt` |
| `<` | Redirect input | `sort < input.txt` |
| `\|` | Pipe output to next command | `ls \| wc -l` |
| `2>` | Redirect errors | `cmd 2> error.log` |
| `2>&1` | Errors to stdout | `cmd > out.txt 2>&1` |
| `&>` | Both stdout and stderr | `cmd &> all.log` |
| `\| tee` | Split output | `cmd \| tee file.txt` |

## Common Mistakes

❌ **Overwriting important files**
```bash
grep "pattern" data.txt > data.txt    # CORRUPTS THE FILE!
```
✓ **Use different filename**
```bash
grep "pattern" data.txt > filtered_data.txt
```

❌ **Wrong redirect order**
```bash
> output.txt cat input.txt            # Won't work
```
✓ **Correct order**
```bash
cat input.txt > output.txt            # Correct
```

❌ **Forgetting quotes in complex commands**
```bash
echo Analysis complete > log.txt     # Only "Analysis" goes to file
```
✓ **Use quotes**
```bash
echo "Analysis complete" > log.txt   # Entire message goes to file
```

***

**Key Takeaway:** Pipes and redirects are the secret sauce of Linux. They let you build powerful data processing pipelines by connecting simple commands. Master `|`, `>`, and `>>`, and you'll be able to handle complex bioinformatics workflows with ease!
