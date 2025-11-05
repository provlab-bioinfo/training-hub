# Text Processing

Text processing is where Linux truly shines. Bioinformatics involves manipulating large text files - extracting columns, sorting data, removing duplicates, and transforming formats. This tutorial covers essential text processing tools.

## The `cut` Command - Extract Columns

`cut` extracts specific columns from files. Perfect for tabular data like TSV, CSV, and annotation files.

### Basic Usage

**Tab-separated files (default):**
```bash
cut -f1 file.tsv          # Extract column 1
cut -f1,3 file.tsv        # Extract columns 1 and 3
cut -f1-3 file.tsv        # Extract columns 1 through 3
cut -f2- file.tsv         # Extract column 2 to end
```

**CSV files (comma-separated):**
```bash
cut -d',' -f1 file.csv    # Use comma as delimiter
```

**Space-separated:**
```bash
cut -d' ' -f1 file.txt    # Use space as delimiter
```

### Bioinformatics Examples

**Extract chromosome and position from VCF:**
```bash
grep -v "^#" variants.vcf | cut -f1,2
```

**Get gene names from GTF:**
```bash
grep "gene_name" annotations.gtf | cut -f9
```

**Extract sequence IDs from FASTA:**
```bash
grep ">" sequences.fasta | cut -d' ' -f1
```

**Get sample names from file list:**
```bash
ls *.fastq | cut -d'_' -f1
```

**Extract specific columns from alignment stats:**
```bash
cut -f1,3,5 alignment_stats.txt
```

### Cut Options

```bash
cut -f1,3 file.txt        # Fields/columns
cut -c1-10 file.txt       # Characters (positions 1-10)
cut -d':' -f2 file.txt    # Custom delimiter
cut -f1 --complement      # All EXCEPT field 1
```

## The `sort` Command - Sort Lines

`sort` arranges lines in order. Essential for data organization and preparing for `uniq`.

### Basic Sorting

```bash
sort file.txt             # Alphabetical sort
sort -r file.txt          # Reverse order
sort -n file.txt          # Numeric sort (important!)
sort -u file.txt          # Sort and remove duplicates
```

### Sort by Column

```bash
sort -k2 file.txt         # Sort by column 2
sort -k2,2 file.txt       # Sort by column 2 only
sort -k1,1 -k2,2n file.txt # Sort by col 1 (text), then col 2 (numeric)
```

### Sort Options

```bash
sort -n file.txt          # Numeric sort
sort -h file.txt          # Human-readable numbers (1K, 1M, 1G)
sort -t',' -k2 file.csv   # Use comma delimiter, sort by column 2
sort -rn file.txt         # Reverse numeric sort
sort -k2nr file.txt       # Sort by column 2, numeric, reverse
```

### Bioinformatics Examples

**Sort variants by position:**
```bash
grep -v "^#" variants.vcf | sort -k1,1 -k2,2n
```

**Sort genes by chromosome:**
```bash
sort -k1,1 -k4,4n genes.gtf
```

**Find largest files:**
```bash
ls -lh | sort -k5 -h
```

**Sort by quality score (descending):**
```bash
grep -v "^#" variants.vcf | sort -k6,6nr
```

**Sort gene list alphabetically:**
```bash
sort gene_names.txt > sorted_genes.txt
```

**Sort and save:**
```bash
sort -k2,2n data.txt > sorted_data.txt
```

## The `uniq` Command - Remove Duplicates

`uniq` removes adjacent duplicate lines. **Important:** File must be sorted first!

### Basic Usage

```bash
sort file.txt | uniq              # Remove duplicates
sort file.txt | uniq -c           # Count occurrences
sort file.txt | uniq -d           # Show only duplicates
sort file.txt | uniq -u           # Show only unique lines
```

### Bioinformatics Examples

**Count unique sequences:**
```bash
grep -v ">" sequences.fasta | sort | uniq | wc -l
```

**Find duplicate sequence IDs:**
```bash
grep ">" sequences.fasta | sort | uniq -d
```

**Count samples by type:**
```bash
cut -f2 sample_info.txt | sort | uniq -c
```

**Find most common k-mer:**
```bash
grep -v ">" seqs.fasta | fold -w3 | sort | uniq -c | sort -rn | head
```

**Count variants per chromosome:**
```bash
grep -v "^#" variants.vcf | cut -f1 | sort | uniq -c
```

## The `tr` Command - Translate Characters

`tr` translates or deletes characters. Useful for format conversion.

### Basic Usage

```bash
tr 'a-z' 'A-Z'            # Lowercase to uppercase
tr 'A-Z' 'a-z'            # Uppercase to lowercase
tr -d 'character'         # Delete character
tr -s ' '                 # Squeeze repeated spaces to one
```

### Bioinformatics Examples

**Convert sequence to uppercase:**
```bash
echo "atcgatcg" | tr 'a-z' 'A-Z'
# Output: ATCGATCG
```

**Remove newlines (join sequences):**
```bash
grep -v ">" sequences.fasta | tr -d '\n'
```

**Replace spaces with tabs:**
```bash
tr ' ' '\t' < input.txt > output.tsv
```

**Remove carriage returns (DOS to Unix):**
```bash
tr -d '\r' < dos_file.txt > unix_file.txt
```

**Count nucleotides:**
```bash
cat sequence.fasta | tr -d '\n' | tr -cd 'ATCG' | wc -c
```

## The `awk` Command - Pattern Scanning and Processing

`awk` is a powerful text processing language. It processes files line by line, splitting each into fields.

### Basic Concepts

- `$0` = entire line
- `$1` = first field
- `$2` = second field, etc.
- `NR` = current line number
- `NF` = number of fields

### Basic Usage

**Print specific columns:**
```bash
awk '{print $1}' file.txt           # Print column 1
awk '{print $1, $3}' file.txt       # Print columns 1 and 3
awk '{print $1 "\t" $3}' file.txt   # Print with tab separator
```

**Print with line numbers:**
```bash
awk '{print NR, $0}' file.txt
```

**Print last column:**
```bash
awk '{print $NF}' file.txt
```

### Filtering with awk

**Print lines where column 3 > 100:**
```bash
awk '$3 > 100' file.txt
```

**Print lines where column 1 equals "chr1":**
```bash
awk '$1 == "chr1"' file.txt
```

**Print lines longer than 80 characters:**
```bash
awk 'length($0) > 80' file.txt
```

**Multiple conditions:**
```bash
awk '$3 > 100 && $5 < 200' file.txt
```

### Bioinformatics Examples

**Filter variants by quality:**
```bash
awk '$6 > 30' variants.vcf
```

**Extract chromosome 1 features:**
```bash
awk '$1 == "chr1"' annotations.gtf
```

**Calculate sequence lengths:**
```bash
awk '/^>/ {if (seq) print length(seq); seq=""} !/^>/ {seq=seq $0} END {print length(seq)}' sequences.fasta
```

**Filter by genomic region:**
```bash
awk '$1 == "chr1" && $4 > 1000000 && $5 < 2000000' genes.gtf
```

**Sum column values:**
```bash
awk '{sum += $3} END {print sum}' file.txt
```

**Calculate average:**
```bash
awk '{sum += $3; count++} END {print sum/count}' file.txt
```

**Count by category:**
```bash
awk '{count[$2]++} END {for (cat in count) print cat, count[cat]}' file.txt
```

### Custom Delimiters

**Comma-separated:**
```bash
awk -F',' '{print $1, $3}' file.csv
```

**Multiple delimiters:**
```bash
awk -F'[,;]' '{print $1}' file.txt
```

### Format Output

```bash
awk '{printf "%s\t%d\n", $1, $2}' file.txt
awk '{printf "%-20s %10d\n", $1, $2}' file.txt  # Formatted columns
```

## The `sed` Command - Stream Editor

`sed` performs text transformations on streams. Great for find-and-replace operations.

### Basic Find and Replace

```bash
sed 's/old/new/' file.txt              # Replace first occurrence per line
sed 's/old/new/g' file.txt             # Replace all occurrences
sed 's/old/new/gi' file.txt            # Case-insensitive replace
```

### In-place Editing

```bash
sed -i 's/old/new/g' file.txt          # Modify file directly (Linux)
sed -i.bak 's/old/new/g' file.txt      # Create backup first
```

### Print Specific Lines

```bash
sed -n '10p' file.txt                  # Print line 10
sed -n '10,20p' file.txt               # Print lines 10-20
sed -n '1p;$p' file.txt                # Print first and last line
```

### Delete Lines

```bash
sed '1d' file.txt                      # Delete first line
sed '1,5d' file.txt                    # Delete lines 1-5
sed '/pattern/d' file.txt              # Delete lines containing pattern
```

### Bioinformatics Examples

**Remove header lines:**
```bash
sed '/^#/d' variants.vcf
```

**Replace chromosome naming:**
```bash
sed 's/^chr//' file.txt                # Remove "chr" prefix
sed 's/^/chr/' file.txt                # Add "chr" prefix
```

**Extract sequences (remove headers):**
```bash
sed '/^>/d' sequences.fasta
```

**Replace in FASTQ quality encoding:**
```bash
sed 's/!/A/g' reads.fastq              # Example transformation
```

**Add line numbers:**
```bash
sed = file.txt | sed 'N;s/\n/\t/'
```

**Extract specific regions:**
```bash
sed -n '/START/,/END/p' file.txt
```

## Combining Tools - Powerful Pipelines

The real power comes from combining these tools:

### Example 1: Analyze Gene Distribution

```bash
# Count genes per chromosome
cut -f1 genes.gtf | sort | uniq -c | sort -rn
```

### Example 2: Extract and Sort Top Features

```bash
# Get top 10 most common features
cut -f3 annotations.gtf | sort | uniq -c | sort -rn | head -10
```

### Example 3: Process VCF Statistics

```bash
# Calculate average quality score
grep -v "^#" variants.vcf | cut -f6 | awk '{sum+=$1; count++} END {print sum/count}'
```

### Example 4: Find Duplicate Sequences

```bash
# Find and count duplicate sequences
grep -v ">" sequences.fasta | sort | uniq -cd
```

### Example 5: Create Summary Table

```bash
# Chromosome, Count, Average Position
awk '$1 !~ /^#/ {count[$1]++; sum[$1]+=$2} END {
    for (chr in count) {
        printf "%s\t%d\t%.0f\n", chr, count[chr], sum[chr]/count[chr]
    }
}' data.txt | sort -k1,1
```

### Example 6: Format Conversion

```bash
# Convert FASTQ to FASTA
awk 'NR%4==1 {print ">"substr($0,2)} NR%4==2' reads.fastq > reads.fasta
```

### Example 7: Filter and Extract

```bash
# Get high-quality SNPs from chromosome 1
awk '$1=="chr1" && $6>30 && length($4)==1 && length($5)==1' variants.vcf | cut -f1,2,4,5 > chr1_snps.txt
```

## Practical Workflows

### Workflow 1: Summarize Annotation File

```bash
#!/bin/bash
echo "=== Annotation Summary ==="
echo "Total features: $(wc -l < annotations.gtf)"
echo ""
echo "Features by type:"
cut -f3 annotations.gtf | sort | uniq -c | sort -rn
echo ""
echo "Features by chromosome:"
cut -f1 annotations.gtf | sort | uniq -c | sort -rn
```

### Workflow 2: Clean and Reformat Data

```bash
# Remove comments, extract columns, sort, save
grep -v "^#" input.txt | \
cut -f1,2,5 | \
sort -k1,1 -k2,2n | \
awk '{printf "%s\t%d\t%.2f\n", $1, $2, $3}' > output.txt
```

### Workflow 3: Create Gene List

```bash
# Extract unique gene names, sort, count
grep "gene_name" annotations.gtf | \
grep -o 'gene_name "[^"]*"' | \
cut -d'"' -f2 | \
sort -u > unique_genes.txt

echo "Total unique genes: $(wc -l < unique_genes.txt)"
```

### Workflow 4: Compare Two Sample Lists

```bash
# Find common samples
sort samples1.txt > s1_sorted.txt
sort samples2.txt > s2_sorted.txt
comm -12 s1_sorted.txt s2_sorted.txt > common_samples.txt

# Find unique to first list
comm -23 s1_sorted.txt s2_sorted.txt > unique_to_samples1.txt
```

### Workflow 5: Process FASTQ Statistics

```bash
#!/bin/bash
# Quick FASTQ statistics

FASTQ=$1

echo "FASTQ Statistics for: $FASTQ"
echo "================================"

# Count reads
LINES=$(zcat $FASTQ | wc -l)
READS=$((LINES / 4))
echo "Total reads: $READS"

# Read length distribution
echo ""
echo "Read length distribution:"
zcat $FASTQ | awk 'NR%4==2 {print length}' | sort -n | uniq -c | head -10

# Average quality score (simplified)
echo ""
echo "First 10 quality strings:"
zcat $FASTQ | awk 'NR%4==0' | head -10
```

## Quick Reference

### cut

| Command | Description |
|---------|-------------|
| `cut -f1 file` | Extract column 1 |
| `cut -f1,3 file` | Extract columns 1 and 3 |
| `cut -d',' -f2 file.csv` | CSV column 2 |

### sort

| Command | Description |
|---------|-------------|
| `sort file` | Alphabetical sort |
| `sort -n file` | Numeric sort |
| `sort -k2 file` | Sort by column 2 |
| `sort -rn file` | Reverse numeric sort |

### uniq

| Command | Description |
|---------|-------------|
| `uniq file` | Remove duplicates |
| `uniq -c file` | Count occurrences |
| `uniq -d file` | Show duplicates only |

### awk

| Pattern | Description |
|---------|-------------|
| `awk '{print $1}'` | Print column 1 |
| `awk '$3 > 100'` | Filter by column 3 |
| `awk -F','` | Use comma delimiter |
| `awk '{sum+=$1} END {print sum}'` | Sum column |

### sed

| Command | Description |
|---------|-------------|
| `sed 's/old/new/g'` | Replace text |
| `sed -n '10p'` | Print line 10 |
| `sed '/pattern/d'` | Delete matching lines |

## Tips and Best Practices

1. **Test on small data first**
   ```bash
   head -100 large_file.txt | your_command
   ```

2. **Build pipelines incrementally**
   ```bash
   cat file.txt                    # Start
   cat file.txt | cut -f1          # Add step
   cat file.txt | cut -f1 | sort   # Add another
   ```

3. **Use awk for complex operations**
   - Multiple conditions
   - Calculations
   - Formatting

4. **Remember: sort before uniq**
   ```bash
   cat file | sort | uniq          # Correct
   cat file | uniq                 # Wrong - won't work properly
   ```

5. **Save intermediate results when debugging**
   ```bash
   cat file | step1 > temp1.txt
   cat temp1.txt | step2 > temp2.txt
   ```

**Key Takeaway:** Master `cut`, `sort`, `uniq`, `awk`, and `sed` for text processing. Combine them with pipes to create powerful data processing pipelines. These tools handle most bioinformatics text manipulation tasks efficiently!
