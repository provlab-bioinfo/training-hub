# Beginner Exercise 4: Searching with grep and find

Master finding text within files (grep) and locating files themselves (find). These are essential skills for bioinformatics work.

<details><summary>Setup</summary>

Create comprehensive practice data:

```bash
cd ~
mkdir -p search_practice
cd search_practice

# Create gene annotation file
cat > annotations.txt << 'EOF'
chr1	1000	2000	BRCA1	tumor_suppressor
chr1	5000	6000	TP53	tumor_suppressor
chr2	10000	11000	EGFR	receptor_kinase
chr2	15000	16000	KRAS	oncogene
chr3	20000	21000	MYC	transcription_factor
chr3	25000	26000	PTEN	tumor_suppressor
chr4	30000	31000	AKT1	kinase
chr4	35000	36000	PIK3CA	kinase
chr5	40000	41000	BRAF	kinase
chr5	45000	46000	NRAS	oncogene
chrX	50000	51000	BRCA2	tumor_suppressor
chrY	55000	56000	SRY	transcription_factor
EOF

# Create FASTA file with multiple sequences
cat > sequences.fasta << 'EOF'
>gene1 BRCA1 breast cancer susceptibility
ATCGATCGATCGATCGATCG
GCTAGCTAGCTAGCTAGCTA
>gene2 TP53 tumor protein p53
TTTTAAAACCCCGGGG
>gene3 EGFR epidermal growth factor receptor
ATCGATCGATCG
>gene4 KRAS oncogene
GCGCGCGCATATATATCGCGCGCG
>gene5 MYC proto-oncogene
AAAAAAAAAAAATTTTTTTTTTTT
>gene6 BRCA1 breast cancer susceptibility
CCCCCCCCCCCCGGGGGGGGGGGG
EOF

# Create sample lists
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

# Create log file with errors
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

cat > scripts/analyze.py << 'EOF'
#!/usr/bin/env python
# Analysis script
print("Running analysis...")
EOF
```
</details>

## Part 1: grep - Searching Inside Files

<details><summary>Exercise 4.1: Basic grep</summary>

**Tasks:**
1. Search for "BRCA1" in annotations.txt
2. Search for "tumor_suppressor" in annotations.txt
3. Search for "chr1" in annotations.txt
4. Search for "kinase" in annotations.txt

**Basic command:**
```bash
grep "pattern" filename
```
</details>

<details><summary>Exercise 4.2: Case-Insensitive Search</summary>

**Tasks:**
1. Search for "brca1" (lowercase) in annotations.txt - what happens?
2. Now search case-insensitively for "brca1"
3. Search for "TUMOR" (any case) in annotations.txt
4. Search for "Chr" (any case) in annotations.txt

**Command:**
```bash
grep -i "pattern" filename
```

**Question:** When would case-insensitive search be useful?
</details>
<details><summary>Exercise 4.3: Counting Matches</summary>

**Tasks:**
1. Count how many genes are on chr1
2. Count tumor_suppressor genes
3. Count kinase genes
4. Count total genes (all lines in file)

**Command:**
```bash
grep -c "pattern" filename
```
</details>
<details><summary>Exercise 4.4: Showing Line Numbers</summary>

**Tasks:**
1. Find "ERROR" in analysis.log with line numbers
2. Find "PASS" in variants.txt with line numbers
3. Find "chr2" in annotations.txt with line numbers

**Command:**
```bash
grep -n "pattern" filename
```

**Why useful?** You can jump directly to those lines with an editor.
</details>
<details><summary>Exercise 4.5: Inverting Matches</summary>

**Tasks:**
1. Show all lines that DON'T contain "chr1" in annotations.txt
2. Show all samples that are NOT tumor samples in sample_list.txt
3. Show all variants that DON'T have PASS in variants.txt
4. Show all log entries that are NOT INFO messages

**Command:**
```bash
grep -v "pattern" filename
```
</details>

<details><summary>Exercise 4.6: Searching Multiple Files</summary>

**Tasks:**
1. Search for "sample" in all .txt files
2. Search for "chr" in both annotations.txt and variants.txt
3. Which files contain the word "ERROR"?
4. Which files contain "BRCA1"?

**Commands:**
```bash
grep "pattern" *.txt
grep "pattern" file1 file2
grep -l "pattern" *          # Show only filenames
```
</details>
<details><summary>Exercise 4.7: Context Around Matches</summary>

**Tasks:**
1. Find "ERROR" in analysis.log with 2 lines before and after
2. Find "BRCA1" in sequences.fasta with 1 line after (to see sequence)
3. Find "LOW_QUAL" in variants.txt with context

**Commands:**
```bash
grep -A 2 "pattern" filename    # 2 lines After
grep -B 2 "pattern" filename    # 2 lines Before
grep -C 2 "pattern" filename    # 2 lines Context (before and after)
```
</details>
<details><summary>Exercise 4.8: Whole Word Matching</summary>

**Tasks:**
1. Search for "MYC" in annotations.txt
2. Does it match "MYC" in other gene names?
3. Search for whole word "MYC" only
4. Search for exact "TP53" (not as part of longer names)

**Commands:**
```bash
grep "MYC" annotations.txt
grep -w "MYC" annotations.txt    # Whole word only
```
</details>
<details><summary>Exercise 4.9: FASTA File Searching</summary>

**Tasks:**
1. Count how many sequences are in sequences.fasta (count headers)
2. Find all sequence headers containing "BRCA"
3. Find sequences described as "oncogene"
4. Extract the header for gene3
5. Find headers AND the line after (to see start of sequence)

**Hints:**
```bash
grep -c ">" sequences.fasta
grep ">" sequences.fasta
grep "oncogene" sequences.fasta
grep -A 1 "gene3" sequences.fasta
```
</details>
<details><summary>Exercise 4.10: Log File Analysis</summary>

**Tasks:**
1. Find all ERROR messages in analysis.log
2. Count how many errors occurred
3. Find all WARNING messages
4. Find all messages about sample005
5. Show only INFO messages

**Practice:**
```bash
grep "ERROR" analysis.log
grep -c "ERROR" analysis.log
grep "WARNING" analysis.log
grep "sample005" analysis.log
grep "INFO" analysis.log
```
</details>
<details><summary>Exercise 4.11: Variant Analysis</summary>

**Tasks:**
1. Find all SNPs in variants.txt
2. Find all INDELs
3. Find variants that PASSED filters
4. Find low quality variants
5. Find variants on chrX
6. Count variants per chromosome

**Commands:**
```bash
grep "SNP" variants.txt
grep "INDEL" variants.txt
grep "PASS" variants.txt
grep "LOW_QUAL" variants.txt
grep "chrX" variants.txt
grep "chr1" variants.txt | wc -l
```
</details>

## Part 2: find - Locating Files

<details><summary>Exercise 4.12: Basic find</summary>

**Tasks:**
1. Find all files in current directory
2. Find all files in data/ directory
3. List everything recursively

**Commands:**
```bash
find .
find data/
find . -type f           # Files only
find . -type d           # Directories only
```
</details>
<details><summary>Exercise 4.13: Finding by Name</summary>

**Tasks:**
1. Find all .fastq files
2. Find all .txt files
3. Find files with "sample" in the name
4. Find files starting with "sample001"
5. Find the align.sh script

**Commands:**
```bash
find . -name "*.fastq"
find . -name "*.txt"
find . -name "*sample*"
find . -name "sample001*"
find . -name "align.sh"
```
</details>
<details><summary>Exercise 4.14: Case-Insensitive File Search</summary>

**Tasks:**
1. Find files with "SAMPLE" or "sample" in name
2. Find .SH or .sh files

**Command:**
```bash
find . -iname "*sample*"
find . -iname "*.sh"
```
</details>
<details><summary>Exercise 4.15: Finding by Type</summary>

**Tasks:**
1. Find only directories in data/
2. Find only files (not directories)
3. Count how many directories exist
4. Count how many files exist

**Commands:**
```bash
find data/ -type d
find . -type f
find . -type d | wc -l
find . -type f | wc -l
```
</details>
<details><summary>Exercise 4.16: Finding by Size</summary>

**Tasks:**
1. Find files larger than 100 bytes
2. Find empty files (size 0)
3. List all files with their sizes
4. Find the largest file

**Commands:**
```bash
find . -type f -size +100c      # +100 bytes
find . -type f -size 0          # Empty files
find . -type f -exec ls -lh {} \;
```
</details>
<details><summary>Exercise 4.17: Finding Recently Modified Files</summary>

**Tasks:**
1. Find files modified in the last 5 minutes
2. Find files modified today
3. Find files NOT modified in last 7 days

**Commands:**
```bash
find . -mmin -5                 # Last 5 minutes
find . -mtime 0                 # Today
find . -mtime +7                # More than 7 days ago
```

**Tip:** Touch a file to update its timestamp: `touch filename`
</details>
<details><summary>Exercise 4.18: Finding and Executing Commands</summary>

**Tasks:**
1. Find all .sh scripts and make them executable
2. Find all .txt files and count lines in each
3. Find all .fastq files and show their sizes
4. Find all result files and copy to a backup directory

**Commands:**
```bash
find . -name "*.sh" -exec chmod +x {} \;
find . -name "*.txt" -exec wc -l {} \;
find . -name "*.fastq" -exec ls -lh {} \;
mkdir backup
find data/results -name "*.txt" -exec cp {} backup/ \;
```
</details>
<details><summary>Exercise 4.19: Complex Find Queries</summary>

**Tasks:**
1. Find .fastq files in raw/ directory only
2. Find files that are NOT .fastq
3. Find either .txt OR .log files
4. Find .sh files that are executable

**Commands:**
```bash
find data/raw -name "*.fastq"
find . -type f ! -name "*.fastq"
find . -name "*.txt" -o -name "*.log"
find . -name "*.sh" -executable
```
</details>
<details><summary>Exercise 4.20: Combining grep and find</summary>

**Tasks:**
1. Find all .txt files containing "ERROR"
2. Find all .sh scripts containing "echo"
3. Find files in data/ containing "sample001"
4. Search for "BRCA1" in all .txt and .fasta files

**Commands:**
```bash
find . -name "*.txt" -exec grep -l "ERROR" {} \;
find . -name "*.sh" -exec grep -l "echo" {} \;
find data/ -type f -exec grep -l "sample001" {} \;
grep "BRCA1" *.txt *.fasta
```
</details>
<details><summary>Exercise 4.21: Real-World Scenario - Data Audit</summary>

**Scenario:** You need to audit your data directory.

**Tasks:**
1. How many total files in data/?
2. How many .fastq files?
3. Which directories have .txt files?
4. Find any empty files
5. Find files modified today
6. Create a report listing all files with their sizes

**Build your audit commands!**
</details>
<details><summary>Exercise 4.22: Finding Missing Samples</summary>

**Scenario:** You expect paired-end FASTQ files (R1 and R2) for each sample.

**Tasks:**
1. Find all R1.fastq files in data/raw
2. Check if corresponding R2 file exists
3. Which samples are missing their pair?

**Hint:** List R1 files, then check for R2 manually or with a script.
</details>
<details><summary>Exercise 4.23: Cleaning Up</summary>

**Tasks:**
1. Find all .tmp files (if any exist)
2. Find empty files
3. Find files older than 30 days (practice - adjust to 0 days)
4. Safely delete identified files

**Commands:**
```bash
find . -name "*.tmp"
find . -type f -size 0
find . -mtime +30
# Check list first, then:
find . -name "*.tmp" -delete
```

**⚠️ Warning:** Always verify find results before using -delete!
</details>
<details><summary>Challenge Exercise 4.24: Search Detective</summary>

**Tasks:** Answer these questions using grep and find:

1. How many tumor samples are there?
2. Which samples had errors in analysis.log?
3. How many variants PASSED quality filters?
4. Which chromosome has the most annotations?
5. Are there any BRCA genes on chromosomes other than chr1?
6. How many kinase genes are there?
7. Which files contain references to sample002?
8. How many script files exist and what languages?
</details>
<details><summary>Challenge Exercise 4.25: Create Search Reports</summary>

**Task:** Create comprehensive reports using grep and find.

**Report 1 - File Inventory:**
```bash
echo "=== File Inventory ===" > inventory.txt
echo "Date: $(date)" >> inventory.txt
echo "" >> inventory.txt
echo "Total files: $(find . -type f | wc -l)" >> inventory.txt
echo "Total directories: $(find . -type d | wc -l)" >> inventory.txt
echo "FASTQ files: $(find . -name "*.fastq" | wc -l)" >> inventory.txt
# Continue...
```

**Report 2 - Analysis Summary:**
```bash
echo "=== Analysis Summary ===" > summary.txt
echo "Total samples: $(wc -l < sample_list.txt)" >> summary.txt
echo "Tumor samples: $(grep -c tumor sample_list.txt)" >> summary.txt
echo "Errors found: $(grep -c ERROR analysis.log)" >> summary.txt
# Continue...
```
</details>
<details><summary>Exercise 4.26: Pattern Matching Practice</summary>

**Tasks:** Find these patterns:

1. Lines starting with "chr1"
2. Lines ending with "PASS"
3. Genes containing numbers (gene1, gene2, etc.)
4. Empty lines in files

**Advanced grep:**
```bash
grep "^chr1" annotations.txt        # ^ = start of line
grep "PASS$" variants.txt            # $ = end of line
grep "gene[0-9]" sequences.fasta    # [0-9] = any digit
grep "^$" filename                   # Empty lines
```
</details>
<details><summary>Exercise 4.27: Search Optimization</summary>

**Compare these approaches:**

**Approach 1:**
```bash
cat file.txt | grep "pattern"
```

**Approach 2:**
```bash
grep "pattern" file.txt
```

**Questions:**
1. Which is more efficient?
2. When might you use approach 1?
3. What's the difference in output?
</details>
<details><summary>Exercise 4.28: Troubleshooting Searches</summary>

**Fix these problematic searches:**

```bash
# Problem 1
grep BRCA1 annotations.txt           # Might match BRCA10, BRCA123, etc.
# Better:
grep -w "BRCA1" annotations.txt

# Problem 2
find . -name *.txt                   # Shell might expand * first
# Better:
find . -name "*.txt"

# Problem 3
grep -r "pattern" .                  # Searches binary files too
# Better:
grep -r "pattern" --include="*.txt" .
```
</details>

## Common Mistakes Quiz

**Identify what's wrong:**

1. `grep BRCA annotations.txt > annotations.txt`
2. `find . -name *.fastq`
3. `grep -v ""` (empty pattern)
4. `find / -name "myfile.txt"` (as regular user)
5. `grep -c ">" sequences.fasta > sequences.fasta`

## Reflection Questions

1. What's the difference between grep and find?
2. When would you use grep -l?
3. Why use quotes around patterns?
4. What's the advantage of find -exec?
5. How do you search case-insensitively?
6. What does grep -v do?
7. Why is grep -c useful?

## Best Practices Learned
- [x] **Use quotes** around search patterns
- [x] **Use -i for case-insensitive** when appropriate
- [x] **Count with grep -c** instead of piping to wc
- [x] **Test find before -delete** to avoid accidents
- [x] **Use grep -l** to find files with matches
- [x] **Combine grep and find** for powerful searches
- [x] **Use -w for whole words** to avoid partial matches
- [x] **Check file locations** before recursive searches

## Quick Reference

### grep Commands

| Task | Command |
|------|---------|
| Basic search | `grep "pattern" file` |
| Case-insensitive | `grep -i "pattern" file` |
| Count matches | `grep -c "pattern" file` |
| Line numbers | `grep -n "pattern" file` |
| Invert match | `grep -v "pattern" file` |
| Whole word | `grep -w "word" file` |
| Show context | `grep -C 2 "pattern" file` |
| Multiple files | `grep "pattern" *.txt` |

### find Commands

| Task | Command |
|------|---------|
| Find all files | `find .` |
| By name | `find . -name "*.txt"` |
| By type | `find . -type f` |
| By size | `find . -size +1M` |
| By time | `find . -mtime -7` |
| Execute command | `find . -name "*.txt" -exec wc -l {} \;` |

## Next Steps

Congratulations on completing the beginner exercises! You're now ready for:
- [Intermediate Exercises - Pipes and Redirects](../intermediate/01-pipes-exercises.md)

---

**Estimated time:** 60-90 minutes

## **Key skills practiced:**
- Using grep to search within files
- Using find to locate files
- Case-sensitive vs insensitive search
- Counting, filtering, and pattern matching
- Combining grep and find
- Real-world bioinformatics scenarios
- Creating search reports
