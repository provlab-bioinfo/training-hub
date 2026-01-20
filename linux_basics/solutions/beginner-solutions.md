</details># Beginner Exercise Solutions

Complete solutions for all beginner exercises. Try solving on your own first!

---

## Exercise 1: Navigation Solutions

### Exercise 1.1: Finding Your Way

```bash
# 1. Print current directory
pwd

# 2. List all directories
ls -d */
# Or
ls -l | grep ^d

# 3. Navigate to project1
cd project1

# 4. Print current directory again
pwd

# 5. Go back to practice_nav
cd ..
```

### Exercise 1.2: Relative and Absolute Paths

```bash
# 1. Navigate to project1/data (relative)
cd project1/data

# 2. Navigate to practice_nav (absolute - adjust to your path)
cd /home/username/practice_nav
# Or
cd ~/practice_nav

# 3. Navigate to project2/analysis (relative from current location)
cd ../../project2/analysis

# 4. Return home
cd ~
# Or just
cd
```

### Exercise 1.4: Quick Navigation

```bash
# 1. Navigate to project1/scripts
cd project1/scripts

# 2. Toggle back
cd -

# 3. Toggle forward again
cd -

# 4. Go up two levels
cd ../..

# 5. Jump directly to project2/raw_data
cd ~/practice_nav/project2/raw_data
```

### Exercise 1.7: Real-World Scenario

```bash
# Starting from project1/results:

# 1. Copy script from project1/scripts
cp ../scripts/script_name.sh .

# 2. Check for data
ls ../data/

# 3. Create figures subdirectory
mkdir figures

# 4. Navigate to project2/analysis
cd ../../project2/analysis
```

---

## Exercise 2: File Operations Solutions

### Exercise 2.1: Creating Files and Directories

```bash
# 1. Create directory
mkdir experiment1

# 2. Create three empty files
touch sample1.txt sample2.txt sample3.txt

# 3. Create nested directories
mkdir -p experiment1/data/raw

# 4. Create file in nested directory
touch experiment1/data/raw/reads.fastq

# 5. Verify
ls -R
```

### Exercise 2.6: Creating Project Structure

```bash
# All in one command using brace expansion
mkdir -p rna_seq_project/{raw_data/{fastq,quality_reports},processed_data/{trimmed,aligned},results/{counts,plots},scripts,logs}

# Verify
ls -R rna_seq_project/
```

### Exercise 2.7: Organizing Files

```bash
# Setup already done in exercise

# 1. Create subdirectories
mkdir -p messy_dir/{scripts,data,results}

# 2. Move R files
mv messy_dir/*.R messy_dir/scripts/

# 3. Move FASTQ files
mv messy_dir/*.fastq messy_dir/data/

# 4. Move txt files
mv messy_dir/*.txt messy_dir/results/

# 5. Move sh files
mv messy_dir/*.sh messy_dir/scripts/

# 6. Verify
ls -R messy_dir/
```

### Exercise 2.8: Batch Operations

```bash
# 1. Create files with brace expansion
touch sample_{01..10}.txt

# 2. Create directories
mkdir sample_{01..10}

# 3. Move files to directories (using loop)
for i in {01..10}; do
    mv sample_${i}.txt sample_${i}/
done

# 4. Copy directories to backup
mkdir backup_samples
cp -r sample_* backup_samples/
```

### Exercise 2.9: Real-World Scenario

```bash
# 1. Create structure
mkdir -p sequencing_run/sample_{A,B,C}

# 2. Create FASTQ files
touch sample_A_R{1,2}.fastq sample_B_R{1,2}.fastq sample_C_R{1,2}.fastq

# 3. Move files to appropriate directories
mv sample_A_*.fastq sequencing_run/sample_A/
mv sample_B_*.fastq sequencing_run/sample_B/
mv sample_C_*.fastq sequencing_run/sample_C/

# 4. Create QC subdirectories
mkdir sequencing_run/sample_{A,B,C}/QC

# 5. Copy R1 files
mkdir forward_reads
cp sequencing_run/*/sample_*_R1.fastq forward_reads/
```

---

## Exercise 3: Viewing Files Solutions

### Exercise 3.1: Basic File Viewing with cat

```bash
# 1. View gene_list.txt
cat gene_list.txt

# 2. Display sequences.fasta
cat sequences.fasta

# 3. View expression_data.tsv
cat expression_data.tsv

# 4. Try large_file.txt
cat large_file.txt
# Fills screen! Use less instead for large files
```

### Exercise 3.3: Viewing File Beginnings with head

```bash
# 1. First 10 lines
head large_file.txt

# 2. First 5 lines
head -n 5 gene_list.txt
# Or shortcut:
head -5 gene_list.txt

# 3. First 3 lines of log
head -n 3 analysis.log

# 4. First 20 lines
head -n 20 large_file.txt

# 5. Check header
head -1 expression_data.tsv
```

### Exercise 3.4: FASTA File Inspection

```bash
# 1. View first sequence (need header + sequence lines)
head -3 sequences.fasta

# 2. Lines needed: depends on sequence (usually 2-4 lines)

# 3. First 3 sequences (estimate ~10 lines)
head -10 sequences.fasta

# 4. Just headers
grep ">" sequences.fasta
```

### Exercise 3.5: Viewing File Endings with tail

```bash
# 1. Last 10 lines
tail analysis.log

# 2. Last 5 genes
tail -5 gene_list.txt

# 3. Last 20 lines
tail -20 large_file.txt

# 4. Just last line (when analysis finished)
tail -1 analysis.log

# 5. Last entry in expression data
tail -1 expression_data.tsv
```

### Exercise 3.10: FASTA File Analysis

```bash
# 1. Count sequences (count headers starting with >)
grep -c ">" sequences.fasta

# 2. Count total lines
wc -l sequences.fasta

# 3. Calculate average lines per sequence
total_lines=$(wc -l < sequences.fasta)
num_sequences=$(grep -c ">" sequences.fasta)
echo "$total_lines / $num_sequences" | bc

# 4. Count total nucleotides
grep -v ">" sequences.fasta | tr -d '\n' | wc -c
```

### Exercise 3.11: Log File Analysis

```bash
# 1. When analysis started
head -1 analysis.log

# 2. When it finished
tail -1 analysis.log

# 3. Number of log entries
wc -l analysis.log

# 4. Samples processed
grep "Processing sample" analysis.log | wc -l

# 5. Did QC pass?
grep "Quality control" analysis.log
```

### Exercise 3.14: Working with Compressed Files

```bash
# 1. Compress
gzip sequences.fasta

# 2. View without decompressing
zcat sequences.fasta.gz

# 3. First 5 lines
zcat sequences.fasta.gz | head -5

# 4. Count sequences
zgrep -c ">" sequences.fasta.gz

# 5. Browse interactively
zless sequences.fasta.gz
# Press q to quit
```

### Exercise 3.15: FASTQ Quality Check

```bash
# 1. View first read (4 lines)
head -4 sample.fastq

# 2. Count total reads
echo $(wc -l < sample.fastq)/4 | bc

# 3. Read ID format
awk 'NR%4==1' sample.fastq | head -1

# 4. Quality score format
awk 'NR%4==0' sample.fastq | head -1

# 5. First and last 2 reads
(head -8; tail -8) < sample.fastq
```

---

## Exercise 4: Searching Solutions

### Exercise 4.1: Basic grep

```bash
# 1. Search for BRCA1
grep "BRCA1" annotations.txt

# 2. Search for tumor_suppressor
grep "tumor_suppressor" annotations.txt

# 3. Search for chr1
grep "chr1" annotations.txt

# 4. Search for kinase
grep "kinase" annotations.txt
```

### Exercise 4.2: Case-Insensitive Search

```bash
# 1. Search lowercase brca1 (no matches)
grep "brca1" annotations.txt

# 2. Case-insensitive search
grep -i "brca1" annotations.txt

# 3. Search TUMOR (any case)
grep -i "TUMOR" annotations.txt

# 4. Search Chr
grep -i "Chr" annotations.txt
```

### Exercise 4.3: Counting Matches

```bash
# 1. Count genes on chr1
grep -c "chr1" annotations.txt

# 2. Count tumor_suppressor genes
grep -c "tumor_suppressor" annotations.txt

# 3. Count kinase genes
grep -c "kinase" annotations.txt

# 4. Count total genes
wc -l annotations.txt
```

### Exercise 4.5: Inverting Matches

```bash
# 1. Lines without chr1
grep -v "chr1" annotations.txt

# 2. Samples that are NOT tumor
grep -v "tumor" sample_list.txt

# 3. Variants without PASS
grep -v "PASS" variants.txt

# 4. Log entries not INFO
grep -v "INFO" analysis.log
```

### Exercise 4.9: FASTA File Searching

```bash
# 1. Count sequences
grep -c ">" sequences.fasta

# 2. Headers with BRCA
grep "BRCA" sequences.fasta

# 3. Sequences with oncogene
grep "oncogene" sequences.fasta

# 4. Extract gene3 header
grep "gene3" sequences.fasta

# 5. Header and sequence
grep -A 1 "gene3" sequences.fasta
```

### Exercise 4.10: Log File Analysis

```bash
# 1. Find all errors
grep "ERROR" analysis.log

# 2. Count errors
grep -c "ERROR" analysis.log

# 3. Find warnings
grep "WARNING" analysis.log

# 4. Messages about sample005
grep "sample005" analysis.log

# 5. Only INFO messages
grep "INFO" analysis.log
```

### Exercise 4.11: Variant Analysis

```bash
# 1. Find SNPs
grep "SNP" variants.txt

# 2. Find INDELs
grep "INDEL" variants.txt

# 3. PASS variants
grep "PASS" variants.txt

# 4. Low quality
grep "LOW_QUAL" variants.txt

# 5. chrX variants
grep "chrX" variants.txt

# 6. Count per chromosome
grep "chr1" variants.txt | wc -l
grep "chr2" variants.txt | wc -l
# etc.
```

### Exercise 4.13: Finding by Name

```bash
# 1. Find all .fastq files
find . -name "*.fastq"

# 2. Find all .txt files
find . -name "*.txt"

# 3. Files with "sample" in name
find . -name "*sample*"

# 4. Files starting with sample001
find . -name "sample001*"

# 5. Find align.sh
find . -name "align.sh"
```

### Exercise 4.15: Finding by Type

```bash
# 1. Only directories in data/
find data/ -type d

# 2. Only files
find . -type f

# 3. Count directories
find . -type d | wc -l

# 4. Count files
find . -type f | wc -l
```

### Exercise 4.18: Finding and Executing

```bash
# 1. Make scripts executable
find . -name "*.sh" -exec chmod +x {} \;

# 2. Count lines in txt files
find . -name "*.txt" -exec wc -l {} \;

# 3. Show sizes of fastq files
find . -name "*.fastq" -exec ls -lh {} \;

# 4. Copy results to backup
mkdir backup
find data/results -name "*.txt" -exec cp {} backup/ \;
```

### Exercise 4.20: Combining grep and find

```bash
# 1. Find .txt files containing ERROR
find . -name "*.txt" -exec grep -l "ERROR" {} \;

# 2. Find scripts containing echo
find . -name "*.sh" -exec grep -l "echo" {} \;

# 3. Files in data/ containing sample001
find data/ -type f -exec grep -l "sample001" {} \;

# 4. Search for BRCA1 in multiple formats
grep "BRCA1" *.txt *.fasta 2>/dev/null
```

### Exercise 4.24: Search Detective

```bash
# 1. Tumor samples count
grep -c "tumor" sample_list.txt

# 2. Samples with errors
grep "ERROR" analysis.log | grep -o "sample[0-9]*" | sort -u

# 3. PASS variants
grep -c "PASS" variants.txt

# 4. Chromosome with most annotations
cut -f1 annotations.txt | sort | uniq -c | sort -rn | head -1

# 5. BRCA genes on other chromosomes
grep "BRCA" annotations.txt | grep -v "chr1"

# 6. Kinase gene count
grep -c "kinase" annotations.txt

# 7. Files containing sample002
find . -type f -exec grep -l "sample002" {} \;

# 8. Script count and languages
find scripts/ -type f | wc -l
ls scripts/*.sh scripts/*.py 2>/dev/null | wc -l
```

---

## Common Patterns and Best Practices

### Pattern 1: Safe File Operations

```bash
# Always check before acting
ls *.tmp                  # See what matches
rm -i *.tmp              # Delete with confirmation

# Use -i for important operations
rm -i important_file.txt
mv -i source dest
cp -i file1 file2
```

### Pattern 2: Efficient Navigation

```bash
# Use cd - to toggle between directories
cd ~/projects/analysis
cd ~/reference_data
cd -                      # Back to analysis
cd -                      # Back to reference_data

# Use pushd/popd for directory stack
pushd ~/data
pushd ~/scripts
popd                      # Returns to previous
```

### Pattern 3: Quick File Checks

```bash
# Check file before processing
file data.txt             # Determine file type
head -5 data.txt          # Quick preview
wc -l data.txt           # Count records
ls -lh data.txt          # Check size
```

### Pattern 4: Searching Efficiently

```bash
# Build grep searches incrementally
grep "pattern" file.txt
grep -i "pattern" file.txt
grep -i "pattern" file.txt | wc -l
grep -i "pattern" file.txt | sort | uniq

# Combine find and grep
find . -name "*.txt" -exec grep -l "pattern" {} \;
```

### Pattern 5: Working with Sequences

```bash
# FASTA quick checks
grep -c ">" sequences.fasta                    # Count sequences
grep ">" sequences.fasta | head -5             # First IDs
grep -v ">" sequences.fasta | tr -d '\n' | wc -c  # Total bases

# FASTQ quick checks
echo $(wc -l < reads.fastq)/4 | bc            # Count reads
head -4 reads.fastq                           # First read
awk 'NR%4==2' reads.fastq | head | wc -c     # Check read length
```

---

## Troubleshooting Common Issues

### Issue 1: Permission Denied

```bash
# Problem
cd /restricted/directory
# Solution: Use accessible directories or ask admin

# Problem
rm protected_file.txt
# Solution: Check permissions
ls -l protected_file.txt
chmod u+w protected_file.txt  # Add write permission
```

### Issue 2: File Not Found

```bash
# Problem
cat myfile.txt
# bash: myfile.txt: No such file or directory

# Solutions
pwd                      # Confirm location
ls                       # See what files exist
find . -name "myfile.txt"  # Search for file
```

### Issue 3: Command Not Found

```bash
# Problem
fastqc sample.fastq
# bash: fastqc: command not found

# Solutions
which fastqc            # Check if installed
module avail            # Check available modules
module load fastqc      # Load module if available
```

### Issue 4: Spaces in Filenames

```bash
# Problem
touch my file.txt       # Creates two files!

# Solutions
touch "my file.txt"     # Use quotes
touch my\ file.txt      # Escape space
touch my_file.txt       # Better: use underscore
```

### Issue 5: Wildcard Surprises

```bash
# Problem
rm *.txt               # Deletes ALL .txt files!

# Solution
ls *.txt               # Check what matches FIRST
rm -i *.txt            # Use interactive mode
```

---

## Quick Reference Summary

### Navigation
```bash
pwd                    # Where am I?
cd directory          # Go to directory
cd ..                 # Go up one level
cd ~                  # Go home
cd -                  # Go to previous directory
ls -lh                # List with details
```

### File Operations
```bash
mkdir dir             # Create directory
mkdir -p a/b/c        # Create nested directories
touch file.txt        # Create empty file
cp source dest        # Copy
cp -r dir1 dir2       # Copy directory
mv source dest        # Move/rename
rm file               # Delete file
rm -r dir             # Delete directory
rm -i file            # Delete with confirmation
```

### Viewing Files
```bash
cat file.txt          # Show entire file
head -n 10 file       # First 10 lines
tail -n 10 file       # Last 10 lines
less file             # Browse interactively
wc -l file            # Count lines
```

### Searching
```bash
grep "pattern" file   # Search in file
grep -i "pattern"     # Case-insensitive
grep -c "pattern"     # Count matches
grep -v "pattern"     # Invert match
grep -n "pattern"     # Show line numbers
find . -name "*.txt"  # Find files
find . -type d        # Find directories
```

---

## Key Takeaways

✅ **Navigation**: Use `pwd`, `cd`, `ls` - always know where you are

✅ **File Operations**: Use `-r` for directories, `-i` for safety

✅ **Viewing**: Match tool to task (cat for small, less for large)

✅ **Searching**: `grep` searches IN files, `find` searches FOR files

✅ **Tab Completion**: Your best friend - use it constantly

✅ **Safety First**: Check before deleting, use `-i` flag

✅ **Wildcards**: Powerful but dangerous - test with `ls` first

✅ **Practice**: The more you use these commands, the more natural they become

---

## Next Steps

Once you've mastered these beginner skills:

1. **Practice on real data** - Apply to your research files
2. **Move to intermediate exercises** - Pipes, text processing
3. **Create your own challenges** - Based on your work needs
4. **Help others** - Teaching reinforces learning
5. **Build your command library** - Keep notes of useful commands

**Remember:** Everyone was a beginner once. Keep practicing, and these commands will become second nature!

---

**Solutions complete for Exercises 1-4!** 🎉
