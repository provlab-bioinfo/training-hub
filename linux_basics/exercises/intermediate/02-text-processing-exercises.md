# Intermediate Exercise 2: Text Processing

Master cut, sort, uniq, tr, awk, and sed for powerful text manipulation. These tools are essential for bioinformatics data processing.

## Setup

Create comprehensive practice files:

```bash
cd ~
mkdir -p text_processing
cd text_processing

# Create gene expression data
cat > expression.tsv << 'EOF'
Gene	Sample1	Sample2	Sample3	Sample4	Average
BRCA1	45.2	67.8	34.1	89.3	59.1
TP53	123.4	98.7	145.6	112.3	120.0
EGFR	234.5	189.2	267.8	201.4	223.2
KRAS	78.9	92.3	65.4	88.1	81.2
MYC	156.7	143.2	178.9	165.4	161.1
PTEN	67.3	54.8	71.2	63.9	64.3
AKT1	89.4	95.6	87.2	91.8	91.0
PIK3CA	112.5	108.9	115.3	110.7	111.9
EOF

# Create variant annotation
cat > variants.tsv << 'EOF'
chr1	12345	A	G	0.75	SNP	PASS	BRCA1	missense
chr1	23456	C	T	0.45	SNP	LOW_QUAL	TP53	synonymous
chr2	34567	G	A	0.82	SNP	PASS	EGFR	missense
chr2	45678	AT	A	0.91	INDEL	PASS	KRAS	frameshift
chr3	56789	A	T	0.28	SNP	LOW_QUAL	MYC	intronic
chr3	67890	C	G	0.95	SNP	PASS	PTEN	missense
chrX	78901	G	C	0.67	SNP	PASS	BRCA2	missense
chrX	89012	TAA	T	0.88	INDEL	PASS	EGFR	inframe
EOF

# Create sample metadata
cat > samples.csv << 'EOF'
SampleID,Age,Gender,Status,Batch
sample001,45,M,tumor,A
sample002,52,F,normal,A
sample003,38,M,tumor,B
sample004,61,F,normal,A
sample005,47,M,tumor,B
sample006,55,F,tumor,A
sample007,42,M,normal,B
sample008,58,F,tumor,B
sample009,39,M,normal,A
sample010,63,F,tumor,B
EOF

# Create GTF-like annotation
cat > annotations.gtf << 'EOF'
chr1	source	gene	1000	5000	.	+	.	gene_id "ENSG001"; gene_name "BRCA1"; gene_type "protein_coding";
chr1	source	transcript	1000	5000	.	+	.	gene_id "ENSG001"; transcript_id "ENST001"; gene_name "BRCA1";
chr1	source	exon	1000	1500	.	+	.	gene_id "ENSG001"; transcript_id "ENST001"; exon_number "1";
chr1	source	exon	2000	2500	.	+	.	gene_id "ENSG001"; transcript_id "ENST001"; exon_number "2";
chr2	source	gene	10000	15000	.	-	.	gene_id "ENSG002"; gene_name "TP53"; gene_type "protein_coding";
chr2	source	transcript	10000	15000	.	-	.	gene_id "ENSG002"; transcript_id "ENST002"; gene_name "TP53";
chrX	source	gene	20000	25000	.	+	.	gene_id "ENSG003"; gene_name "EGFR"; gene_type "protein_coding";
EOF

# Create log file with mixed content
cat > analysis.log << 'EOF'
2024-11-07 10:00:00 [INFO] Starting analysis
2024-11-07 10:05:15 [INFO] Processing sample001 - 1234567 reads
2024-11-07 10:10:30 [WARNING] Low quality detected: sample002
2024-11-07 10:15:45 [ERROR] File not found: sample003_R2.fastq
2024-11-07 10:20:00 [INFO] Processing sample004 - 2345678 reads
2024-11-07 10:25:15 [INFO] Processing sample005 - 3456789 reads
2024-11-07 10:30:30 [ERROR] Alignment failed for sample006
2024-11-07 10:35:45 [INFO] Processing sample007 - 4567890 reads
2024-11-07 10:40:00 [WARNING] High duplication rate: sample008
2024-11-07 10:45:15 [INFO] Analysis complete
EOF

# Create sequence data
cat > sequences.txt << 'EOF'
>seq1|gene1|length:45
ATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCG
>seq2|gene2|length:30
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGC
>seq3|gene3|length:20
TTTTAAAACCCCGGGGTTTT
>seq4|gene4|length:50
ATCGATCGGGCCCAAATTTGGGCCCAAATTTGGGCCCAAATTTGGGCCC
EOF

# Create messy data file
cat > messy_data.txt << 'EOF'
gene1   45.2   67.8    34.1
gene2  123.4  98.7   145.6
gene3    234.5    189.2  267.8
gene4 78.9  92.3   65.4
EOF
```

## Part 1: The cut Command

### Exercise 1.1: Basic Column Extraction

**Tasks:**
1. Extract just gene names from expression.tsv (column 1)
2. Extract Sample1 values (column 2)
3. Extract columns 1 and 3 together
4. Extract columns 2-5 (all samples)

**Commands:**
```bash
cut -f1 expression.tsv
cut -f2 expression.tsv
cut -f1,3 expression.tsv
cut -f2-5 expression.tsv
```

### Exercise 1.2: Working with Different Delimiters

**Tasks:**
1. Extract SampleID from samples.csv (comma-separated)
2. Extract Age and Status (columns 2 and 4)
3. Extract everything except Gender (column 3)

**Commands:**
```bash
cut -d',' -f1 samples.csv
cut -d',' -f2,4 samples.csv
cut -d',' -f1,2,4,5 samples.csv
```

### Exercise 1.3: Character-Based Cutting

**Tasks:**
1. Extract first 10 characters from each line in sequences.txt
2. Extract characters 5-15
3. Extract chromosome from variants.tsv (first 4 characters)

**Commands:**
```bash
cut -c1-10 sequences.txt
cut -c5-15 sequences.txt
cut -c1-4 variants.tsv
```

### Exercise 1.4: Combining cut with Pipes

**Tasks:**
1. Extract gene names and sort them
2. Extract Sample1 values, sort numerically
3. Extract SampleIDs for tumor samples only
4. Count unique chromosomes in variants

**Solutions:**
```bash
cut -f1 expression.tsv | sort
cut -f2 expression.tsv | tail -n +2 | sort -n
grep tumor samples.csv | cut -d',' -f1
cut -f1 variants.tsv | sort -u | wc -l
```

## Part 2: The sort Command

### Exercise 2.1: Basic Sorting

**Tasks:**
1. Sort expression.tsv by gene name (alphabetically)
2. Sort variants.tsv by position (numerically)
3. Sort samples.csv by age
4. Reverse sort by age (oldest first)

**Commands:**
```bash
sort expression.tsv
sort -k2,2n variants.tsv
sort -t',' -k2,2n samples.csv
sort -t',' -k2,2nr samples.csv
```

### Exercise 2.2: Multi-Column Sorting

**Tasks:**
1. Sort variants by chromosome, then by position
2. Sort samples by Status, then by Age
3. Sort expression by Sample1 values (descending)

**Commands:**
```bash
sort -k1,1 -k2,2n variants.tsv
sort -t',' -k4,4 -k2,2n samples.csv
sort -k2,2nr expression.tsv
```

### Exercise 2.3: Human-Readable Sorting

**Tasks:**
1. Create a file size list and sort
2. Sort by file sizes (human-readable format)

**Commands:**
```bash
ls -lh > sizes.txt
sort -k5,5h sizes.txt
```

### Exercise 2.4: Unique Sorting

**Tasks:**
1. Get unique gene names from expression.tsv
2. Get unique chromosomes from variants.tsv (sorted)
3. Get unique sample statuses from samples.csv

**Commands:**
```bash
cut -f1 expression.tsv | sort -u
cut -f1 variants.tsv | sort -u
cut -d',' -f4 samples.csv | sort -u
```

## Part 3: The uniq Command

### Exercise 3.1: Finding Duplicates

**Tasks:**
1. Create a test file with duplicates:
```bash
cat > test_duplicates.txt << 'EOF'
gene1
gene2
gene1
gene3
gene2
gene1
EOF
```

2. Remove duplicates (after sorting)
3. Count occurrences of each
4. Show only duplicates
5. Show only unique items

**Commands:**
```bash
sort test_duplicates.txt | uniq
sort test_duplicates.txt | uniq -c
sort test_duplicates.txt | uniq -d
sort test_duplicates.txt | uniq -u
```

### Exercise 3.2: Count Frequencies

**Tasks:**
1. Count how many variants per chromosome
2. Count samples by status (tumor/normal)
3. Count variants by type (SNP/INDEL)
4. Find most common variant consequence

**Solutions:**
```bash
cut -f1 variants.tsv | sort | uniq -c
cut -d',' -f4 samples.csv | tail -n +2 | sort | uniq -c
cut -f6 variants.tsv | tail -n +1 | sort | uniq -c
cut -f9 variants.tsv | tail -n +1 | sort | uniq -c | sort -rn
```

### Exercise 3.3: Identifying Unique vs Repeated

**Tasks:**
1. Find genes that appear only once in annotations.gtf
2. Find chromosomes with multiple features
3. Identify singleton vs repeated entries

**Approach:**
```bash
grep -o 'gene_name "[^"]*"' annotations.gtf | cut -d'"' -f2 | sort | uniq -c
```

## Part 4: The tr Command

### Exercise 4.1: Case Conversion

**Tasks:**
1. Convert all gene names to uppercase
2. Convert all gene names to lowercase
3. Convert sequences to uppercase

**Commands:**
```bash
cut -f1 expression.tsv | tr 'a-z' 'A-Z'
cut -f1 expression.tsv | tr 'A-Z' 'a-z'
grep -v ">" sequences.txt | tr 'a-z' 'A-Z'
```

### Exercise 4.2: Character Deletion

**Tasks:**
1. Remove all spaces from messy_data.txt
2. Remove newlines to join sequences
3. Remove quote characters from GTF file
4. Remove all non-ATCG characters from sequences

**Commands:**
```bash
tr -d ' ' < messy_data.txt
grep -v ">" sequences.txt | tr -d '\n'
tr -d '"' < annotations.gtf
grep -v ">" sequences.txt | tr -d '\n' | tr -cd 'ATCG'
```

### Exercise 4.3: Character Replacement

**Tasks:**
1. Replace spaces with tabs in messy_data.txt
2. Replace commas with tabs in samples.csv
3. Replace colons with underscores in sequences.txt

**Commands:**
```bash
tr ' ' '\t' < messy_data.txt
tr ',' '\t' < samples.csv
tr ':' '_' < sequences.txt
```

### Exercise 4.4: Squeeze Repeated Characters

**Tasks:**
1. Squeeze multiple spaces to single space
2. Remove blank lines (squeeze multiple newlines)

**Commands:**
```bash
tr -s ' ' < messy_data.txt
tr -s '\n' < file_with_blank_lines.txt
```

## Part 5: The awk Command

### Exercise 5.1: Print Specific Columns

**Tasks:**
1. Print gene names from expression.tsv
2. Print gene and Sample1 value
3. Print with custom separator
4. Print last column

**Commands:**
```bash
awk '{print $1}' expression.tsv
awk '{print $1, $2}' expression.tsv
awk '{print $1 "\t" $2}' expression.tsv
awk '{print $NF}' expression.tsv
```

### Exercise 5.2: Filtering with awk

**Tasks:**
1. Print genes with Sample1 > 100
2. Print variants with quality > 0.8
3. Print tumor samples only
4. Print SNPs only from variants

**Commands:**
```bash
awk '$2 > 100' expression.tsv
awk '$5 > 0.8' variants.tsv
awk -F',' '$4=="tumor"' samples.csv
awk '$6=="SNP"' variants.tsv
```

### Exercise 5.3: Calculations with awk

**Tasks:**
1. Calculate average of Sample1 column
2. Sum all values in Sample2 column
3. Calculate row-wise average
4. Count rows meeting condition

**Commands:**
```bash
awk '{sum+=$2; count++} END {print sum/count}' expression.tsv
awk '{sum+=$3} END {print sum}' expression.tsv
awk '{print $1, ($2+$3+$4+$5)/4}' expression.tsv
awk '$2 > 100 {count++} END {print count}' expression.tsv
```

### Exercise 5.4: Pattern Matching

**Tasks:**
1. Print lines containing "BRCA"
2. Print lines where column 1 matches pattern
3. Print lines NOT containing pattern
4. Case-insensitive matching

**Commands:**
```bash
awk '/BRCA/' expression.tsv
awk '$1 ~ /BRCA/' expression.tsv
awk '$1 !~ /BRCA/' expression.tsv
awk 'tolower($0) ~ /brca/' expression.tsv
```

### Exercise 5.5: Complex awk Operations

**Task:** Calculate length of each sequence in sequences.txt

**Solution:**
```bash
awk '/^>/ {
    if (seq) print id, length(seq)
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

**Tasks:**
1. Find variants on chr1 with quality > 0.7
2. Find tumor samples older than 50
3. Count passing SNPs vs failing SNPs

**Commands:**
```bash
awk '$1=="chr1" && $5>0.7' variants.tsv
awk -F',' '$2>50 && $4=="tumor"' samples.csv
awk '$6=="SNP" && $7=="PASS" {pass++} $6=="SNP" && $7!="PASS" {fail++} END {print "Pass:", pass, "Fail:", fail}' variants.tsv
```

### Exercise 5.7: Formatted Output

**Tasks:**
1. Print gene and expression with formatting
2. Create aligned columns
3. Add custom headers

**Commands:**
```bash
awk '{printf "%-10s %8.2f\n", $1, $2}' expression.tsv
awk 'BEGIN {print "Gene\tExpression"} {printf "%-10s %8.2f\n", $1, $2}' expression.tsv
```

## Part 6: The sed Command

### Exercise 6.1: Basic Find and Replace

**Tasks:**
1. Replace "tumor" with "cancer" in samples.csv
2. Replace all commas with tabs
3. Replace first occurrence only vs all occurrences

**Commands:**
```bash
sed 's/tumor/cancer/' samples.csv
sed 's/,/\t/g' samples.csv
sed 's/tumor/cancer/' samples.csv    # First only
sed 's/tumor/cancer/g' samples.csv   # All
```

### Exercise 6.2: Line-Specific Operations

**Tasks:**
1. Print line 5 of expression.tsv
2. Print lines 3-7
3. Delete first line (header)
4. Delete last line

**Commands:**
```bash
sed -n '5p' expression.tsv
sed -n '3,7p' expression.tsv
sed '1d' expression.tsv
sed '$d' expression.tsv
```

### Exercise 6.3: Pattern-Based Operations

**Tasks:**
1. Delete lines containing "LOW_QUAL"
2. Delete blank lines
3. Delete lines starting with "#"
4. Keep only lines containing "PASS"

**Commands:**
```bash
sed '/LOW_QUAL/d' variants.tsv
sed '/^$/d' file.txt
sed '/^#/d' file.txt
sed '/PASS/!d' variants.tsv
```

### Exercise 6.4: In-Place Editing

**Tasks:**
1. Replace text and save to new file
2. Edit file in-place (careful!)
3. Edit in-place with backup

**Commands:**
```bash
sed 's/tumor/cancer/g' samples.csv > samples_new.csv
sed -i 's/tumor/cancer/g' samples.csv
sed -i.bak 's/tumor/cancer/g' samples.csv
```

### Exercise 6.5: Advanced Substitutions

**Tasks:**
1. Remove "chr" prefix from chromosomes
2. Add "chr" prefix if missing
3. Extract fields using sed
4. Complex pattern replacement

**Commands:**
```bash
sed 's/^chr//' variants.tsv
sed 's/^/chr/' chromosomes.txt
sed 's/.*gene_name "\([^"]*\)".*/\1/' annotations.gtf
```

## Part 7: Combining Tools

### Exercise 7.1: Complete Analysis Pipeline

**Task:** Analyze expression data comprehensively.

**Pipeline:**
```bash
# Get top 3 expressed genes
cut -f1,2 expression.tsv | \
  tail -n +2 | \
  sort -k2,2nr | \
  head -3
```

### Exercise 7.2: Data Cleaning Pipeline

**Task:** Clean messy_data.txt

**Pipeline:**
```bash
# Remove extra spaces, convert to tabs, sort
cat messy_data.txt | \
  tr -s ' ' '\t' | \
  sort -k1,1 > cleaned_data.tsv
```

### Exercise 7.3: Variant Analysis Pipeline

**Task:** Extract and analyze high-quality variants.

**Pipeline:**
```bash
# Get high-quality missense variants, count by gene
awk '$5>0.7 && $9=="missense" {print $8}' variants.tsv | \
  sort | \
  uniq -c | \
  sort -rn
```

### Exercise 7.4: GTF Processing

**Task:** Extract gene information from GTF.

**Pipeline:**
```bash
# Extract gene names and positions
awk '$3=="gene" {print $1, $4, $5}' annotations.gtf | \
  sed 's/gene_name "\([^"]*\)".*/\1/' | \
  sort -k1,1 -k2,2n
```

### Exercise 7.5: Log File Analysis

**Task:** Comprehensive log analysis.

**Pipeline:**
```bash
# Extract samples with errors, count reads processed
grep ERROR analysis.log | \
  sed 's/.*sample\([0-9]*\).*/\1/' | \
  sort -u > error_samples.txt

grep "reads" analysis.log | \
  awk '{sum+=$NF} END {print "Total reads:", sum}'
```

## Challenge Exercises

### Challenge 8.1: Create Summary Table

**Task:** Create a summary table of expression data.

**Output format:**
```
Gene    Min     Max     Average
BRCA1   34.1    89.3    59.1
...
```

**Hint:** Use awk to calculate min, max, average for each row.

### Challenge 8.2: Variant Classification

**Task:** Classify variants by multiple criteria.

**Requirements:**
1. Separate by chromosome
2. Filter by quality (>0.7)
3. Group by consequence type
4. Count each category
5. Generate formatted report

### Challenge 8.3: Sample Matching

**Task:** Cross-reference sample metadata with analysis results.

**Requirements:**
1. Extract sample IDs from logs
2. Match with metadata
3. Identify missing samples
4. Generate match report

### Challenge 8.4: Format Converter

**Task:** Convert between file formats.

**Convert expression.tsv to CSV format with specific columns:**
- Gene name
- Average expression
- Maximum expression
- Sample count

**Build the pipeline!**

### Challenge 8.5: Data Validation

**Task:** Validate data files for common issues.

**Check for:**
1. Consistent column counts
2. Numeric values in numeric columns
3. Valid values in categorical columns
4. No missing data
5. Generate validation report

## Reflection Questions

1. When should you use cut vs awk?
2. Why must data be sorted before using uniq?
3. What's the difference between tr and sed?
4. When is awk more powerful than other tools?
5. How do you debug complex pipelines?
6. What's the advantage of sed over simple replace?

## Best Practices Learned

✓ **Use cut for simple column extraction**
✓ **Use awk for complex operations**
✓ **Always sort before uniq**
✓ **Test sed patterns before in-place editing**
✓ **Build pipelines incrementally**
✓ **Preserve original data**
✓ **Document complex awk scripts**
✓ **Use appropriate tool for the job**

## Quick Reference

### cut
| Task | Command |
|------|---------|
| Extract column | `cut -f1 file.tsv` |
| Multiple columns | `cut -f1,3 file.tsv` |
| Range | `cut -f2-5 file.tsv` |
| CSV | `cut -d',' -f1 file.csv` |

### sort
| Task | Command |
|------|---------|
| Alphabetical | `sort file.txt` |
| Numeric | `sort -n file.txt` |
| By column | `sort -k2,2n file.txt` |
| Reverse | `sort -r file.txt` |
| Unique | `sort -u file.txt` |

### awk
| Task | Command |
|------|---------|
| Print column | `awk '{print $1}' file` |
| Filter | `awk '$2>100' file` |
| Sum column | `awk '{sum+=$1} END {print sum}' file` |
| CSV | `awk -F',' '{print $1}' file.csv` |

### sed
| Task | Command |
|------|---------|
| Replace | `sed 's/old/new/' file` |
| Replace all | `sed 's/old/new/g' file` |
| Delete line | `sed '5d' file` |
| Print line | `sed -n '5p' file` |

## Next Steps

Ready for compression? Move to:
- [Compression Exercises](03-compression-exercises.md)

---

**Estimated time:** 90-120 minutes

**Key skills practiced:**
- Column extraction with cut
- Sorting and deduplication
- Text transformation with tr
- Pattern matching with awk
- Find and replace with sed
- Building complex pipelines
- Real-world data processing
