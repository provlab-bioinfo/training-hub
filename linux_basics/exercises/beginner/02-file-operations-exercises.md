
## Exercise 2: File Operations Solutions

<details> <summary> Exercise 2.1: Creating Files and Directories</summary>

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
</details>

<details> <summary> Exercise 2.2: Copying Files</summary>

```bash
# 1. Copy with new name
cp sample1.txt sample1_backup.txt

# 2. Copy to directory
cp sample2.txt experiment1/

# 3. Copy multiple files
cp sample1.txt sample2.txt sample3.txt experiment1/data/

# 4. Copy entire directory
cp -r experiment1 experiment1_copy
```
</details>

<details> <summary> Exercise 2.3: Moving and Renaming</summary>

```bash
# 1. Rename file
mv sample3.txt control.txt

# 2. Move file
mv sample1_backup.txt experiment1/data/

# 3. Create directory
mkdir archive

# 4. Move directory
mv experiment1_copy archive/

# 5. Rename directory
mv experiment1 experiment_001
```
</details>

<details> <summary> Exercise 2.4: Wildcards</summary>

```bash
# 1. Create files
touch data1.txt data2.txt data3.txt result1.csv result2.csv

# 2. List .txt files
ls *.txt

# 3. List files starting with "data"
ls data*

# 4. Copy .csv files
cp *.csv experiment_001/data/

# 5. Copy .txt to backup
mkdir backup
cp *.txt backup/
```
</details>

<details> <summary> Exercise 2.5: Safe Deletion</summary>

```bash
# 1-2. Create and delete
touch delete_me.txt
rm delete_me.txt

# 3. Try to view - file not found error
cat delete_me.txt

# 4-5. Delete multiple files
touch temp1.txt temp2.txt temp3.txt
rm temp*.txt

# 6. Delete directory
rm -r backup
```
</details>

<details> <summary> Exercise 2.6: Creating Project Structure</summary>s

```bash
# All in one command
mkdir -p rna_seq_project/{raw_data/{fastq,quality_reports},processed_data/{trimmed,aligned},results/{counts,plots},scripts,logs}

# Verify
ls -R rna_seq_project
```
</details>

<details> <summary> Exercise 2.7: Organizing Files</summary>

```bash
# 1. Create subdirectories
mkdir -p messy_dir/{scripts,data,results}

# 2-5. Move files
mv messy_dir/*.R messy_dir/scripts/
mv messy_dir/*.fastq messy_dir/data/
mv messy_dir/*.txt messy_dir/results/
mv messy_dir/*.sh messy_dir/scripts/

# 6. Verify
ls -R messy_dir/
```
</details>

<details> <summary> Exercise 2.8: Batch Operations</summary>

```bash
# 1. Create files with brace expansion
touch sample_{01..10}.txt

# 2. Create directories
mkdir sample_{01..10}

# 3. Move files - one approach
for i in {01..10}; do
    mv sample_${i}.txt sample_${i}/
done

# 4. Copy directories
cp -r sample_* backup_samples/
```
</details>

<details> <summary> Exercise 2.9: Real-World Scenario</summary>

```bash
# 1. Create structure
mkdir -p sequencing_run/sample_{A,B,C}

# 2. Files already created

# 3. Move files
mv sample_A_*.fastq sequencing_run/sample_A/
mv sample_B_*.fastq sequencing_run/sample_B/
mv sample_C_*.fastq sequencing_run/sample_C/

# 4. Create QC subdirectories
mkdir sequencing_run/sample_{A,B,C}/QC

# 5. Copy R1 files
mkdir forward_reads
cp sequencing_run/*/sample_*_R1.fastq forward_reads/
```
</details>

<details> <summary> Exercise 2.10: Error Recovery</summary>

```bash
# 1. Problem: copying file to itself does nothing or causes error

# 2. Create proper backup
cp important_data.txt important_data_backup.txt

# 3. Accidentally deleted
rm important_data.txt

# 4. Recover from backup
cp important_data_backup.txt important_data.txt

# 5. Multiple backups with timestamps
cp important_data.txt important_data_$(date +%Y%m%d_%H%M%S).txt
```
</details>
<details> <summary> Exercise 2.11: Efficient Organization (Challenge)</summary>

```bash
# Complete solution
mkdir -p analysis_project/{data/{raw,processed},scripts,results/{alignments,counts},logs}

cd analysis_project/data/raw
touch sample{1,2}_R{1,2}.fastq

cd ../../scripts
touch 01_qc.sh 02_align.sh 03_count.sh

cd ../..
```
</details>

<details> <summary> Exercise 2.12: Common Mistakes - Solutions</summary>

```bash
# Mistake 1: Better naming
cp myfile.txt myfile_backup.txt

# Mistake 2: Create directory first
mkdir -p /data/fastq
mv *.fastq /data/fastq

# Mistake 3: List first, then delete
ls -R important_data/
rm -r important_data/

# Mistake 4: Use quotes or no spaces
mkdir "my project folder"
# Or better:
mkdir my_project_folder

# Mistake 5: Add -r for directories
cp -r directory1 directory2
```
</details>

---

## Common Patterns and Tips

<details> <summary> Pattern 1: Safe File Operations</summary>
```bash
# Always check before acting
ls *.tmp                  # See what matches
rm *.tmp                  # Then delete

# Use -i for important operations
rm -i important_file.txt
mv -i source dest
```
</details>
<details> <summary> Pattern 2: Efficient Directory Creation</summary>

```bash
# Use -p for nested directories
mkdir -p project/{data,scripts,results}

# Brace expansion for multiple items
mkdir sample_{A,B,C,D,E}
```
</details>
<details> <summary> Pattern 3: Batch Renaming</summary>

```bash
# Add prefix
for file in *.txt; do
    mv "$file" "prefix_$file"
done

# Change extension
for file in *.txt; do
    mv "$file" "${file%.txt}.tsv"
done
```
</details>
<details> <summary> Pattern 4: Backup Strategy</summary>

```bash
# Simple backup
cp file.txt file.txt.bak

# Dated backup
cp file.txt file_$(date +%Y%m%d).txt

# Directory backup
cp -r project project_backup_$(date +%Y%m%d)
```
</details>

---

## Troubleshooting Common Issues

<details> <summary> Issue: Permission Denied</summary>

```bash
# Problem
mkdir /restricted/directory

# Solution
mkdir ~/my_directory  # Use your home directory
# Or if you need that location, ask administrator
```
</details>
<details> <summary> Issue: File Exists</summary>

```bash
# Problem
cp file.txt file.txt  # Error!

# Solution
cp file.txt file_copy.txt  # Different name
```
</details>
<details> <summary> Issue: Directory Not Empty</summary>

```bash
# Problem
rmdir directory  # Fails if not empty

# Solution
rm -r directory  # Remove recursively
```
</details>
<details> <summary> Issue: Spaces in Filenames</summary>

```bash
# Problem
touch my file.txt  # Creates two files: "my" and "file.txt"

# Solutions
touch "my file.txt"      # Use quotes
touch my\ file.txt       # Escape space
touch my_file.txt        # Better: use underscore
```
</details>

---

## Key Takeaways

✓ **Always check before deleting** - Use `ls` first

✓ **Use Tab completion** - Saves time and prevents typos

✓ **Name files sensibly** - No spaces, use descriptive names

✓ **Organize early** - Create good structure from the start

✓ **Make backups** - Before major operations

✓ **Use wildcards carefully** - Test with `ls` first

---

## Next Steps

Once comfortable with these solutions:
1. Practice without looking at solutions
2. Try variations of each exercise
3. Apply to your own data
4. Move to intermediate exercises

**Remember:** The goal isn't to memorize these exact commands, but to understand the patterns and problem-solving approaches!
