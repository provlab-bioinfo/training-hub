# Intermediate Exercise 4: FASTA and FASTQ Files

Master working with the most common bioinformatics file formats. Learn to manipulate, analyze, and quality-check sequence data efficiently.

## Setup

Create comprehensive sequence files for practice:

```bash
cd ~
mkdir -p sequence_practice
cd sequence_practice

# Create multi-line FASTA
cat > sequences.fasta << 'EOF'
>gene1 hypothetical protein [Homo sapiens]
ATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCG
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTA
TTTTAAAACCCCGGGGTTTTAAAACCCCGGGGTTTTAAAACCCC
>gene2 kinase domain [Homo sapiens]
GGGGCCCCAAAATTTTGGGGCCCCAAAATTTTGGGGCCCCAAAA
TTTTGGGGCCCCAAAATTTT
>gene3 DNA binding protein [Homo sapiens]
ATATATATATCGCGCGCGATATATATCGCGCGCGATATATCGCG
>gene4 membrane receptor [Homo sapiens]
AAAAAAAAAAAAAAAAAAAAAAAAAAAA
>gene5 transcription factor [Homo sapiens]
CGCGCGCGCGCGCGATATATATATATGCGCGCGCGCGCGCGCG
ATATATATATATCGCGCGCGCG
>gene6 kinase domain [Homo sapiens]
TTTTTTTTTTTTCCCCCCCCCCCCGGGGGGGGGGGGAAAAAAAAAA
>gene1 hypothetical protein duplicate [Homo sapiens]
ATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCG
>gene7 transport protein [Homo sapiens]
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTA
EOF

# Create FASTQ file
cat > reads.fastq << 'EOF'
@read1_sample1
ATCGATCGATCGATCGATCGATCGATCGATCG
+
IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
@read2_sample1
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTA
+
HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
@read3_sample1
TTTTAAAACCCCGGGGTTTTAAAACCCCGGGG
+
GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
@read4_sample1
ATCGATCGATCGATCGATCG
+
IIIIIIIIIIIIIIIIIII
@read5_sample1
NNNNNATCGATCGATCGATCGATCG
+
!!!!!!IIIIIIIIIIIIIIIIII
@read6_sample1
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTA
+
IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
@read7_sample1
ATCGATCGATCGATCGATCGATCGATCGATCGATCGATCG
+
IIIIIIHHHHHHGGGGGGFFFFFF!!!!!!!!!!!!!!
@read8_sample1
TTTTAAAACCCCGGGG
+
IIIIIIIIIIIIIIII
@read9_sample1
ATCGATCGATCG
+
HHHHHHHHHHHH
@read10_sample1
GCTAGCTAGCTAGCTAGCTAGCTA
+
IIIIIIIIIIIIIIIIIIIIIIII
EOF

# Create paired-end FASTQ files
cat > sample1_R1.fastq << 'EOF'
@read1/1
ATCGATCGATCGATCGATCG
+
IIIIIIIIIIIIIIIIIIII
@read2/1
GCTAGCTAGCTAGCTAGCTA
+
IIIIIIIIIIIIIIIIIIII
@read3/1
TTTTAAAACCCCGGGGTTTT
+
IIIIIIIIIIIIIIIIIIII
EOF

cat > sample1_R2.fastq << 'EOF'
@read1/2
CGCGCGCGCGCGCGCGCGCG
+
IIIIIIIIIIIIIIIIIIII
@read2/2
ATATATATATATATATATAT
+
IIIIIIIIIIIIIIIIIII
@read3/2
GGGGCCCCAAAATTTTGGGG
+
IIIIIIIIIIIIIIIIIIII
EOF

# Create single-line FASTA
cat > genes_single_line.fasta << 'EOF'
>gene1
ATCGATCGATCGATCG
>gene2
GCTAGCTAGCTAGCTA
>gene3
TTTTAAAACCCCGGGG
EOF

# Create contamination reference
cat > contaminants.fasta << 'EOF'
>adapter1
AGATCGGAAGAGC
>adapter2
CTGTCTCTTATAC
>phiX
GCTAGCTAGCTAGCTA
EOF
```

## Part 1: FASTA File Operations

### Exercise 4.1: Basic FASTA Statistics

**Tasks:**
1. Count total sequences in sequences.fasta
2. Count total lines
3. Calculate average lines per sequence
4. How many genes have "kinase" in their description?
5. How many unique gene names are there (ignoring duplicates)?

**Commands to explore:**
```bash
grep -c ">" sequences.fasta
wc -l sequences.fasta
grep "kinase" sequences.fasta | wc -l
grep ">" sequences.fasta | cut -d' ' -f1 | sort -u | wc -l
```

### Exercise 4.2: Extracting Sequence IDs

**Tasks:**
1. Extract all sequence IDs (just the ID, not descriptions)
2. Extract complete headers (ID + description)
3. Extract gene numbers only (gene1, gene2, etc.)
4. Save IDs to a file called sequence_ids.txt

**Hints:**
```bash
grep ">" sequences.fasta
grep ">" sequences.fasta | cut -d' ' -f1
grep ">" sequences.fasta | cut -d' ' -f1 | sed 's/>//'
```

### Exercise 4.3: Extracting Specific Sequences

**Tasks:**
1. Extract gene1 and its sequence
2. Extract all sequences with "kinase" in description
3. Extract only the sequence data for gene3 (no header)
4. Save gene2 to a separate file

**Using awk:**
```bash
# Extract specific sequence
awk '/^>gene1/ {p=1} /^>/ && !/^>gene1/ {p=0} p' sequences.fasta

# Extract with description match
awk '/kinase/ {p=1} /^>/ && !/kinase/ {p=0} p' sequences.fasta
```

### Exercise 4.4: Sequence Length Analysis

**Task:** Calculate the length of each sequence.

**Solution approach:**
```bash
awk '/^>/ {
    if (seq) print id, length(seq)
    id=$1
    seq=""
} 
!/^>/ {
    seq=seq $0
} 
END {
    print id, length(seq)
}' sequences.fasta
```

**Additional tasks:**
1. Find the longest sequence
2. Find the shortest sequence
3. Calculate average sequence length
4. Count sequences longer than 50bp

### Exercise 4.5: Duplicate Detection

**Tasks:**
1. Find duplicate sequence IDs
2. Find sequences with identical sequence data (not just IDs)
3. Count how many times gene1 appears
4. Remove duplicate sequences (keep first occurrence)

**Approach:**
```bash
# Find duplicate IDs
grep ">" sequences.fasta | sort | uniq -d

# Find duplicate sequences (extract sequences, sort, find duplicates)
grep -v ">" sequences.fasta | tr -d '\n' | fold -w 50 | sort | uniq -d
```

### Exercise 4.6: Format Conversion - Multi-line to Single-line

**Task:** Convert multi-line FASTA to single-line format.

**Why?** Easier to process with standard Unix tools.

**Solution:**
```bash
awk '/^>/ {if (NR>1) printf("\n"); printf("%s\n",$0); next} 
     {printf("%s",$0)} 
     END {printf("\n")}' sequences.fasta > single_line.fasta
```

**Verify:** Each sequence should be on one line.

### Exercise 4.7: GC Content Calculation

**Task:** Calculate GC content for each sequence.

**Approach:**
```bash
awk '/^>/ {
    if (seq) {
        gc = gsub(/[GCgc]/, "", seq)
        total = length(seq)
        printf "%s\t%.2f%%\n", id, (gc/total)*100
    }
    id=$1
    seq=""
} 
!/^>/ {
    seq=seq $0
} 
END {
    gc = gsub(/[GCgc]/, "", seq)
    total = length(seq)
    printf "%s\t%.2f%%\n", id, (gc/total)*100
}' sequences.fasta
```

**Additional tasks:**
1. Find sequences with GC content > 50%
2. Calculate average GC content across all sequences
3. Plot GC content distribution (conceptually)

### Exercise 4.8: Finding Sequence Motifs

**Tasks:**
1. Find sequences containing "ATCG" motif
2. Find sequences starting with "ATG"
3. Find sequences ending with "TAA", "TAG", or "TGA"
4. Count how many sequences contain "AAAA" (poly-A)

**Commands:**
```bash
# Find motif in sequence
awk '/^>/ {header=$0} !/^>/ {seq=seq $0} 
     /^>/ && seq ~ /ATCG/ {print prev_header; print prev_seq} 
     {prev_header=header; prev_seq=seq; seq=""}' sequences.fasta

# Simpler with grep (but searches across lines)
grep -B 1 "ATCG" sequences.fasta
```

### Exercise 4.9: Sequence Statistics Report

**Task:** Create a comprehensive FASTA report.

**Report should include:**
1. Total sequences
2. Total bases
3. Shortest sequence length
4. Longest sequence length
5. Average sequence length
6. Average GC content
7. Number of sequences with description "kinase"

**Build it step by step, then combine into one script!**

### Exercise 4.10: Filtering Sequences by Length

**Tasks:**
1. Extract sequences longer than 50bp
2. Extract sequences shorter than 30bp
3. Extract sequences between 40-60bp
4. Count sequences in each length category

**Solution framework:**
```bash
awk '/^>/ {
    if (seq && length(seq) > 50) {
        print header
        print seq
    }
    header=$0
    seq=""
} 
!/^>/ {
    seq=seq $0
} 
END {
    if (length(seq) > 50) {
        print header
        print seq
    }
}' sequences.fasta
```

## Part 2: FASTQ File Operations

### Exercise 4.11: Basic FASTQ Statistics

**Tasks:**
1. Count total reads in reads.fastq
2. Verify FASTQ format (every 4th line pattern)
3. Check if any read IDs are duplicated
4. Calculate total bases sequenced

**Commands:**
```bash
# Count reads
echo $(wc -l < reads.fastq)/4 | bc

# Extract read IDs
awk 'NR%4==1' reads.fastq

# Count total bases
awk 'NR%4==2 {sum+=length($0)} END {print sum}' reads.fastq
```

### Exercise 4.12: Read Length Distribution

**Tasks:**
1. Extract all read lengths
2. Find minimum read length
3. Find maximum read length
4. Calculate average read length
5. Count reads of each length

**Solution:**
```bash
# Get all lengths
awk 'NR%4==2 {print length}' reads.fastq

# Length distribution
awk 'NR%4==2 {print length}' reads.fastq | sort -n | uniq -c

# Average length
awk 'NR%4==2 {sum+=length($0); count++} END {print sum/count}' reads.fastq
```

### Exercise 4.13: Quality Score Analysis

**Tasks:**
1. Extract all quality strings
2. Find reads with low quality bases (! character, Q=0)
3. Calculate average quality string length (should match read length)
4. Find reads with quality dropping at the end

**Commands:**
```bash
# Extract quality lines
awk 'NR%4==0' reads.fastq

# Find reads with low quality
awk 'NR%4==0 && /!/' reads.fastq

# Count reads with N's in sequence
awk 'NR%4==2 && /N/ {count++} END {print count}' reads.fastq
```

### Exercise 4.14: FASTQ to FASTA Conversion

**Task:** Convert FASTQ to FASTA format.

**Solution:**
```bash
awk 'NR%4==1 {print ">"substr($0,2)} NR%4==2' reads.fastq > reads.fasta
```

**Verify:** Check that conversion worked correctly.

**Additional tasks:**
1. Convert only reads longer than 20bp
2. Convert and rename sequences (seq1, seq2, etc.)
3. Add read length to FASTA headers

### Exercise 4.15: Extracting Read Subsets

**Tasks:**
1. Extract first 5 reads
2. Extract last 3 reads
3. Extract every other read (reads 2, 4, 6, ...)
4. Extract reads 3, 5, and 7
5. Sample random reads

**Commands:**
```bash
# First 5 reads (20 lines)
head -20 reads.fastq

# Last 3 reads (12 lines)
tail -12 reads.fastq

# Extract specific reads
awk 'NR>=9 && NR<=12' reads.fastq  # Read 3 (lines 9-12)
```

### Exercise 4.16: Filtering Reads by Quality

**Tasks:**
1. Remove reads containing 'N' bases
2. Remove reads with low quality scores (containing '!')
3. Remove reads shorter than 20bp
4. Keep only reads with average quality > 30

**Solution for filtering N's:**
```bash
awk 'NR%4==1 {header=$0}
     NR%4==2 {seq=$0}
     NR%4==3 {plus=$0}
     NR%4==0 {qual=$0; if (seq !~ /N/) {print header; print seq; print plus; print qual}}' reads.fastq
```

### Exercise 4.17: Paired-End Read Analysis

**Tasks:**
1. Verify that R1 and R2 have same number of reads
2. Check that read IDs match between pairs
3. Extract first paired reads
4. Count properly paired reads

**Commands:**
```bash
# Count reads in each file
wc -l sample1_R1.fastq sample1_R2.fastq

# Extract read IDs and compare
awk 'NR%4==1' sample1_R1.fastq > r1_ids.txt
awk 'NR%4==1' sample1_R2.fastq > r2_ids.txt
diff r1_ids.txt r2_ids.txt
```

### Exercise 4.18: Detecting Contamination

**Task:** Check for adapter contamination or PhiX.

**Approach:**
1. Extract contaminant sequences from contaminants.fasta
2. Search for these sequences in reads
3. Count contaminated reads
4. Remove contaminated reads

**Simple contamination check:**
```bash
# Extract sequences from reads
awk 'NR%4==2' reads.fastq > read_sequences.txt

# Check for adapter
grep -c "AGATCGGAAGAGC" read_sequences.txt

# Check for PhiX
grep -c "GCTAGCTAGCTAGCTA" read_sequences.txt
```

### Exercise 4.19: Read Trimming Simulation

**Task:** Simulate quality trimming by removing low-quality ends.

**Tasks:**
1. Trim reads to first 20bp
2. Remove last 5bp from all reads
3. Trim when quality drops below threshold

**Trim to 20bp:**
```bash
awk 'NR%4==1 {print $0}
     NR%4==2 {print substr($0,1,20)}
     NR%4==3 {print $0}
     NR%4==0 {print substr($0,1,20)}' reads.fastq > trimmed.fastq
```

### Exercise 4.20: FASTQ Statistics Summary

**Task:** Create comprehensive FASTQ QC report.

**Report should include:**
1. Total reads
2. Total bases
3. Average read length
4. Min/max read length
5. Reads with N's
6. Reads with low quality
7. GC content
8. Read length distribution

**Build incrementally!**

## Part 3: Advanced Sequence Operations

### Exercise 4.21: Reverse Complement

**Task:** Generate reverse complement of sequences.

**For DNA:**
- A ↔ T
- G ↔ C
- Reverse the string

**Solution:**
```bash
# Reverse complement (simple version)
echo "ATCG" | rev | tr 'ATCG' 'TAGC'

# For FASTA file
awk '/^>/ {print; next}
     {
         # Reverse
         rev=""
         for(i=length($0); i>0; i--) rev=rev substr($0,i,1)
         # Complement
         gsub(/A/,"t",rev); gsub(/T/,"a",rev)
         gsub(/G/,"c",rev); gsub(/C/,"g",rev)
         print toupper(rev)
     }' sequences.fasta
```

### Exercise 4.22: Merging Paired-End Reads

**Task:** Conceptually merge R1 and R2 reads (just concatenate for practice).

**Tasks:**
1. Combine R1 and R2 into single FASTA
2. Rename with /1 and /2 suffixes
3. Verify proper pairing

**Solution:**
```bash
# Convert to FASTA and merge
awk 'NR%4==1 {print ">"substr($0,2)"/1"} NR%4==2' sample1_R1.fastq > merged.fasta
awk 'NR%4==1 {print ">"substr($0,2)"/2"} NR%4==2' sample1_R2.fastq >> merged.fasta
```

### Exercise 4.23: Deduplication

**Tasks:**
1. Find duplicate reads (same sequence)
2. Count duplicates
3. Remove duplicates (keep first occurrence)
4. Report deduplication statistics

**Approach:**
```bash
# Extract sequences and find duplicates
awk 'NR%4==2' reads.fastq | sort | uniq -d

# Count unique sequences
awk 'NR%4==2' reads.fastq | sort -u | wc -l
```

### Exercise 4.24: Sequence Comparison

**Tasks:**
1. Compare sequences.fasta and genes_single_line.fasta
2. Find common sequences
3. Find unique sequences in each file
4. Calculate sequence similarity

**Commands:**
```bash
# Extract sequences
grep -v ">" sequences.fasta | tr -d '\n' | fold -w 100 | sort > seq1.txt
grep -v ">" genes_single_line.fasta | sort > seq2.txt

# Find common
comm -12 seq1.txt seq2.txt

# Find unique to first file
comm -23 seq1.txt seq2.txt
```

### Exercise 4.25: Batch Processing Multiple Files

**Scenario:** You have multiple FASTQ files to process.

**Setup:**
```bash
cp reads.fastq sample2.fastq
cp reads.fastq sample3.fastq
```

**Tasks:**
1. Count reads in all files
2. Generate statistics for each
3. Compare read counts
4. Identify potential issues

**Loop through files:**
```bash
for file in *.fastq; do
    echo "Processing $file"
    reads=$(echo $(wc -l < $file)/4 | bc)
    echo "  Reads: $reads"
done
```

## Challenge Exercises

### Challenge 4.26: Complete QC Pipeline

**Task:** Create a comprehensive quality control script.

**Requirements:**
1. Accept FASTQ file as input
2. Generate statistics report
3. Identify quality issues
4. Suggest filtering thresholds
5. Save report to file

**Template:**
```bash
#!/bin/bash
FASTQ=$1

echo "=== FASTQ Quality Control Report ===" > qc_report.txt
echo "File: $FASTQ" >> qc_report.txt
echo "Date: $(date)" >> qc_report.txt
echo "" >> qc_report.txt

# Add your analysis here
```

### Challenge 4.27: Multi-Sample Analysis

**Task:** Compare multiple samples and create summary.

**Requirements:**
1. Process all FASTQ files
2. Compare read counts
3. Compare quality distributions
4. Identify outliers
5. Generate comparison table

### Challenge 4.28: Format Validator

**Task:** Create a script that validates FASTA/FASTQ format.

**Check for:**
1. Correct header format
2. Valid nucleotide characters
3. Matching lengths (FASTQ seq and qual)
4. No duplicate IDs
5. Proper line structure

## Reflection Questions

1. What's the difference between multi-line and single-line FASTA?
2. Why does FASTQ use 4 lines per read?
3. How do you calculate GC content?
4. What indicates low-quality bases in FASTQ?
5. Why remove duplicate reads?
6. What's the purpose of paired-end sequencing?
7. How do you verify FASTQ/FASTA format?

## Best Practices Learned

✓ **Validate format** before processing
✓ **Check read/sequence counts** match expectations
✓ **Monitor quality scores** for issues
✓ **Track paired-end relationships** carefully
✓ **Use appropriate tools** (awk for FASTQ, grep for FASTA)
✓ **Keep original data** - work on copies
✓ **Document processing steps** in logs
✓ **Test on small subsets** before full dataset

## Next Steps

Ready for advanced workflows? Move to:
- [Advanced Workflows](../advanced/01-workflows-exercises.md)

---

**Estimated time:** 90-120 minutes

**Key skills practiced:**
- FASTA file manipulation
- FASTQ quality assessment
- Format conversion
- Sequence filtering and analysis
- Quality control workflows
- Paired-end read handling
- Statistical analysis of sequence data
