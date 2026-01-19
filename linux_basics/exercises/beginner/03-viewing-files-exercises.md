# Beginner Exercise 3: Viewing Files

Master the essential commands for viewing and examining file contents without editing them.
***

<details><summary> Setup</summary>

Create practice files with realistic bioinformatics data:

```bash
cd ~
mkdir -p viewing_practice
cd viewing_practice

# Create a sample gene list
cat > gene_list.txt << 'EOF'
BRCA1
TP53
EGFR
KRAS
MYC
PTEN
AKT1
PIK3CA
BRAF
NRAS
RB1
CDK4
CDKN2A
MDM2
VEGFA
EOF

# Create a sample FASTA file
cat > sequences.fasta << 'EOF'
>gene1 kinase domain [Homo sapiens]
ATCGATCGATCGATCGATCGATCGATCGATCGATCG
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTA
>gene2 transcription factor [Homo sapiens]
TTTTAAAACCCCGGGGTTTTAAAACCCCGGGG
>gene3 membrane receptor [Homo sapiens]
ATCGATCGATCG
>gene4 kinase domain [Homo sapiens]
GCGCGCGCATATATATATCGCGCGCGCGCGCGCGCG
ATATATATATATATATCGCGCGCGCGCGATATATA
>gene5 DNA binding protein [Homo sapiens]
AAAAAAAAAAAATTTTTTTTTTTTCCCCCCCCCCCCGGGGGGGGGGGG
EOF

# Create a sample log file
cat > analysis.log << 'EOF'
[2024-11-07 10:00:00] Analysis started
[2024-11-07 10:00:05] Loading reference genome
[2024-11-07 10:00:10] Reference genome loaded: hg38
[2024-11-07 10:00:15] Processing sample1.fastq
[2024-11-07 10:05:20] Sample1 processing complete
[2024-11-07 10:05:25] Processing sample2.fastq
[2024-11-07 10:10:30] Sample2 processing complete
[2024-11-07 10:10:35] Processing sample3.fastq
[2024-11-07 10:15:40] Sample3 processing complete
[2024-11-07 10:15:45] Running quality control
[2024-11-07 10:20:50] Quality control passed
[2024-11-07 10:20:55] Generating alignment statistics
[2024-11-07 10:25:00] Alignment statistics complete
[2024-11-07 10:25:05] Analysis finished successfully
[2024-11-07 10:25:10] Results saved to results/
EOF

# Create a data table
cat > expression_data.tsv << 'EOF'
Gene	Sample1	Sample2	Sample3	Sample4
BRCA1	45.2	67.8	34.1	89.3
TP53	123.4	98.7	145.6	112.3
EGFR	234.5	189.2	267.8	201.4
KRAS	78.9	92.3	65.4	88.1
MYC	156.7	143.2	178.9	165.4
EOF

# Create a large file for practice
seq 1 1000 | awk '{print "Line " $1 ": Data value " $1 * 3.14}' > large_file.txt
```
</details>

<details><summary> Exercise 3.1: Basic File Viewing with cat</summary>

**Tasks:**
1. View the entire gene_list.txt file
2. Display sequences.fasta
3. View expression_data.tsv
4. Try viewing large_file.txt - what happens?

**Questions:**
- When is `cat` appropriate to use?
- When should you avoid using `cat`?
</details>

<details><summary> Exercise 3.2: cat Options</summary>

**Tasks:**
1. Display gene_list.txt with line numbers
2. Display gene_list.txt with line numbers for non-empty lines only
3. Combine gene_list.txt and expression_data.tsv (view together)

**Commands to practice:**
```bash
cat -n gene_list.txt
cat -b gene_list.txt
cat gene_list.txt expression_data.tsv
```
</details>
<details><summary> Exercise 3.3: Viewing File Beginnings with head</summary>

**Tasks:**
1. View the first 10 lines of large_file.txt
2. View only the first 5 lines of gene_list.txt
3. View the first 3 lines of analysis.log
4. View the first 20 lines of large_file.txt
5. Check the header of expression_data.tsv

**Practice different numbers:**
```bash
head large_file.txt
head -n 5 gene_list.txt
head -5 gene_list.txt      # Shortcut
```
</details>
<details><summary> Exercise 3.4: FASTA File Inspection</summary>

**Tasks:**
1. View the first sequence in sequences.fasta (header + sequence lines)
2. How many lines do you need to see the first complete sequence?
3. View the first 3 sequences
4. What command shows you just the headers?

**Hints:**
- Count the lines per sequence
- Headers start with `>`
</details>
<details><summary> Exercise 3.5: Viewing File Endings with tail</summary>

**Tasks:**
1. View the last 10 lines of analysis.log
2. View the last 5 genes in gene_list.txt
3. View the last 20 lines of large_file.txt
4. View just the last line of analysis.log (when did analysis finish?)
5. Check the last entry in expression_data.tsv
</details>
<details><summary> Exercise 3.6: Monitoring Files with tail -f</summary>

**Tasks:**
1. Open a second terminal window or tab
2. In terminal 1: `tail -f analysis.log`
3. In terminal 2: `echo "[NEW] Adding data" >> analysis.log`
4. Watch terminal 1 update
5. Press Ctrl+C to stop following

**Practice:**
```bash
# Terminal 1
tail -f analysis.log

# Terminal 2
echo "[$(date)] New log entry" >> analysis.log
```

**Real-world usage:**
- Monitoring job progress
- Watching alignment logs
- Following pipeline execution
</details>
<details><summary> Exercise 3.7: Interactive Browsing with less</summary>

**Tasks:**
1. Open large_file.txt with less
2. Practice navigation:
   - Press Space to go forward one page
   - Press 'b' to go back one page
   - Press 'g' to go to beginning
   - Press 'G' to go to end
   - Press 'q' to quit

3. Open sequences.fasta and search:
   - Press '/' and type "kinase"
   - Press 'n' to find next match
   - Press 'N' to find previous match

**Commands:**
```bash
less large_file.txt
less sequences.fasta
```
</details>
<details><summary> Exercise 3.8: less Advanced Features</summary>

**Tasks:**
1. Open expression_data.tsv with less -S (no line wrapping)
2. Use arrow keys to scroll horizontally
3. Open gene_list.txt with less -N (show line numbers)
4. Open analysis.log and jump to line 10 (type "10g")

**Practice:**
```bash
less -S expression_data.tsv
less -N gene_list.txt
```
</details>
<details><summary> Exercise 3.9: Counting with wc</summary>

**Tasks:**
1. Count lines in gene_list.txt
2. Count words in gene_list.txt
3. Count characters in gene_list.txt
4. Count all three at once
5. Count lines in all .txt files

**Commands:**
```bash
wc -l gene_list.txt
wc -w gene_list.txt
wc -c gene_list.txt
wc gene_list.txt
wc -l *.txt
```
</details>
<details><summary> Exercise 3.10: FASTA File Analysis</summary>

**Tasks:**
1. Count how many sequences are in sequences.fasta
   - Hint: Count lines starting with `>`
2. Count total lines in the file
3. Calculate average lines per sequence
4. Count total nucleotides (excluding header lines)

**Starting points:**
```bash
grep -c ">" sequences.fasta
wc -l sequences.fasta
```
</details>
<details><summary> Exercise 3.11: Log File Analysis</summary>

**Tasks:**
1. When did the analysis start? (first line)
2. When did it finish? (last line)
3. How many log entries are there?
4. How many samples were processed?
5. Did the quality control pass?

**Use head, tail, grep, and wc:**
```bash
head -1 analysis.log
tail -1 analysis.log
wc -l analysis.log
grep "Processing sample" analysis.log
```
</details>
<details><summary> Exercise 3.12: Viewing Specific Sections</summary>

**Tasks:**
1. View lines 10-20 of large_file.txt
2. View the middle section of gene_list.txt (lines 5-10)
3. Skip the first line of expression_data.tsv (header) and view the rest

**Combining commands:**
```bash
head -20 large_file.txt | tail -11
tail -n +2 expression_data.tsv
sed -n '10,20p' large_file.txt
```
</details>
<details><summary> Exercise 3.13: File Comparison</summary>

**Tasks:**
1. Create two gene lists:
```bash
head -10 gene_list.txt > genes_set1.txt
tail -10 gene_list.txt > genes_set2.txt
```

2. View both files side by side (in separate windows/panes)
3. Count genes in each file
4. Identify which genes are in set1 vs set2
</details>
<details><summary> Exercise 3.14: Working with Compressed Files</summary>

**Tasks:**
1. Compress sequences.fasta:
```bash
gzip sequences.fasta
```

2. View the compressed file without decompressing:
```bash
zcat sequences.fasta.gz
```

3. View first 5 lines:
```bash
zcat sequences.fasta.gz | head -5
```

4. Count sequences:
```bash
zgrep -c ">" sequences.fasta.gz
```

5. Browse interactively:
```bash
zless sequences.fasta.gz
```
</details>
<details><summary> Exercise 3.15: Real-World Scenario - Quality Check</summary>

**Scenario:** You received a FASTQ file and need to do a quick quality check.

**Setup:**
```bash
cat > sample.fastq << 'EOF'
@SEQ_ID_1
GATTTGGGGTTCAAAGCAGTATCGATCAAATAGTAAATCCATTTGTTCAACTCACAGTTT
+
!''*((((***+))%%%++)(%%%%).1***-+*''))**55CCF>>>>>>CCCCCCC65
@SEQ_ID_2
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTA
+
IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
@SEQ_ID_3
ATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCG
+
HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
@SEQ_ID_4
TTTTAAAACCCCGGGGTTTTAAAACCCCGGGGTTTTAAAACCCCGGGGTTTTAAAACCCC
+
GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
EOF
```

**Tasks:**
1. View the first read (4 lines)
2. Count total reads (divide total lines by 4)
3. View the read ID format
4. Check quality score line format
5. Sample first 2 reads and last 2 reads
</details>
<details><summary> Exercise 3.16: Expression Data Inspection</summary>

**Tasks using expression_data.tsv:**
1. View the entire file
2. Count how many genes are listed
3. Check the column headers
4. View only the gene names (first column)
5. View expression values for BRCA1

**Hints:**
```bash
cat expression_data.tsv
wc -l expression_data.tsv
head -1 expression_data.tsv
cut -f1 expression_data.tsv
grep "BRCA1" expression_data.tsv
```
</details>
<details><summary> Challenge Exercise 3.17: Create a Quick QC Script</summary>

**Task:** Create a simple script that checks a file and reports:
1. File size
2. Number of lines
3. First 3 lines
4. Last 3 lines
5. Total word count

**Template:**
```bash
#!/bin/bash
FILE=$1
echo "=== File QC Report for $FILE ==="
echo "File size: $(ls -lh $FILE | awk '{print $5}')"
echo "Total lines: $(wc -l < $FILE)"
echo ""
echo "First 3 lines:"
head -3 $FILE
echo ""
echo "Last 3 lines:"
tail -3 $FILE
echo ""
echo "Word count: $(wc -w < $FILE)"
```

Save as `qc_check.sh`, make executable, and test!
</details>
<details><summary> Exercise 3.18: Viewing Multiple Files</summary>

**Tasks:**
1. View all .txt files in order
2. View with filenames as separators
3. Compare sizes of all files
4. Find the largest file

**Commands:**
```bash
cat *.txt
head *.txt                    # Shows filenames
ls -lh
ls -lh | sort -k5 -h
```
</details>
<details><summary> Exercise 3.19: Choosing the Right Tool</summary>

**For each scenario, which command would you use?**

1. Check if a file has any content
2. See the last error in a log file
3. Browse a 1GB file
4. Check format of first few sequences
5. Monitor a running job's output
6. Count sequences in a FASTA file
7. View a table with many columns

**Options:** cat, head, tail, less, wc, tail -f, zless
</details>
<details><summary> Exercise 3.20: Cleanup and Best Practices</summary>

**Tasks:**
1. Count total files created in this exercise
2. Check total disk space used
3. List all files by size
4. Remove the large_file.txt
5. Compress remaining large files

**Commands:**
```bash
ls | wc -l
du -sh .
ls -lhS
rm large_file.txt
gzip *.fasta *.log
```
</details>
<details><summary> Common Mistakes - Can You Identify Them?</summary>

**Scenario 1:**
```bash
cat huge_genome.fasta    # Terminal floods with data!
```
**What should you use instead?**

**Scenario 2:**
```bash
head sequences.fasta     # Only see one sequence
```
**Why? How many lines do you need?**

**Scenario 3:**
```bash
tail -f static_file.txt  # Nothing happens
```
**What's wrong?**

**Scenario 4:**
```bash
less file.txt.gz         # Gibberish appears
```
**What command should you use?**
</details>
<details><summary> Reflection Questions</summary>

1. What's the difference between `cat` and `less`?
2. When would you use `head` vs `tail`?
3. What's the purpose of `tail -f`?
4. Why use `less` instead of opening in an editor?
5. How do you count lines without displaying them all?
6. What's the advantage of `zless` over `gunzip` then `less`?
</details>

<details><summary> Best Practices Learned</summary>

✓ **Use `less` for large files** - Don't flood your terminal

✓ **Use `head` for quick checks** - See file format quickly

✓ **Use `tail -f` for monitoring** - Watch jobs in real-time

✓ **Use `wc -l` for counting** - Faster than viewing entire file

✓ **Use z-commands for compressed files** - Save time and space

✓ **Check file size first** - Before attempting to view

✓ **Use appropriate tool** - Match tool to task

</details>

***

## Quick Reference

| Task | Command | Example |
|------|---------|---------|
| View small file | `cat` | `cat genes.txt` |
| View large file | `less` | `less genome.fa` |
| First N lines | `head -n N` | `head -20 file.txt` |
| Last N lines | `tail -n N` | `tail -50 log.txt` |
| Monitor file | `tail -f` | `tail -f analysis.log` |
| Count lines | `wc -l` | `wc -l sequences.fa` |
| View compressed | `zless` | `zless reads.fq.gz` |
| Search while viewing | `less` then `/` | `/pattern` in less |

## Next Steps

Once comfortable with viewing files, move to:
- [Basic Searching Exercises](04-searching-exercises.md)

---

**Estimated time:** 45-60 minutes

**Key skills practiced:**
- Choosing appropriate viewing commands
- Using cat, head, tail, less
- Counting with wc
- Monitoring files
- Working with compressed files
- Quick file inspection techniques
