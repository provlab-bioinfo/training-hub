# Working with Files and Directories

Now that you can navigate the file system, it's time to learn how to create, copy, move, and delete files and directories. These are fundamental operations you'll use constantly in bioinformatics work.

## Creating Directories

### The `mkdir` Command

`mkdir` stands for "make directory" - it creates new folders.

**Basic usage:**
```bash
mkdir my_project
```

**Create multiple directories at once:**
```bash
mkdir project1 project2 project3
```

**Create nested directories:**
```bash
mkdir -p analysis/fastq_files/raw_data
```

The `-p` flag creates all parent directories if they don't exist. Without `-p`, this would fail if `analysis` or `fastq_files` didn't already exist.

### Practical Example: Project Structure

Create a typical bioinformatics project structure:

```bash
cd ~
mkdir -p my_rna_seq/raw_data
mkdir -p my_rna_seq/trimmed_data
mkdir -p my_rna_seq/alignments
mkdir -p my_rna_seq/results
mkdir -p my_rna_seq/scripts
mkdir -p my_rna_seq/logs
```

Or more efficiently:

```bash
mkdir -p my_rna_seq/{raw_data,trimmed_data,alignments,results,scripts,logs}
```

Check your work:

```bash
ls -l my_rna_seq
```

## Creating Files

### The `touch` Command

`touch` creates empty files or updates the timestamp of existing files.

```bash
touch README.txt
touch experiment_notes.txt
touch sample_list.txt
```

Create multiple files:

```bash
touch file1.txt file2.txt file3.txt
```

### Why Create Empty Files?

You might wonder why create an empty file. Common reasons:
- Placeholder for future content
- Create a file that a script expects to exist
- Test file operations before using real data

For actual content, you'll use a text editor (we'll cover this later) or redirect output from commands.

## Copying Files

### The `cp` Command

`cp` stands for "copy" - it duplicates files or directories.

**Basic syntax:**
```bash
cp source destination
```

### Copying Files

**Copy a file to the current directory with a new name:**
```bash
cp sequences.fasta sequences_backup.fasta
```

**Copy a file to another directory:**
```bash
cp sequences.fasta ~/backups/
```

**Copy a file to another directory with a new name:**
```bash
cp sequences.fasta ~/backups/sequences_2025-11-04.fasta
```

**Copy multiple files to a directory:**
```bash
cp file1.txt file2.txt file3.txt ~/Documents/
```

### Copying Directories

To copy directories, use the `-r` flag (recursive):

```bash
cp -r my_project my_project_backup
```

Without `-r`, you'll get an error when trying to copy directories.

### Useful `cp` Options

```bash
cp -i file1.txt file2.txt    # Interactive - ask before overwriting
cp -v file1.txt file2.txt    # Verbose - show what's being done
cp -u source dest            # Update - only copy if source is newer
cp -r dir1 dir2              # Recursive - copy directories
```

Combine options:

```bash
cp -riv my_project my_project_backup
```

This copies recursively, asks before overwriting, and shows progress.

### Bioinformatics Example

```bash
# Backup raw FASTQ files before processing
cp -r raw_data raw_data_backup

# Make a working copy of reference genome
cp /shared/genomes/hg38.fasta ~/my_project/reference/

# Copy results to archive location
cp -r results ~/archive/experiment_$(date +%Y%m%d)/
```

## Moving and Renaming Files

### The `mv` Command

`mv` stands for "move" - it moves files/directories OR renames them.

**Renaming (moving within same directory):**
```bash
mv old_name.txt new_name.txt
```

**Moving to another directory:**
```bash
mv file.txt ~/Documents/
```

**Moving and renaming at the same time:**
```bash
mv file.txt ~/Documents/renamed_file.txt
```

**Moving multiple files:**
```bash
mv file1.txt file2.txt file3.txt ~/Documents/
```

**Moving directories (no `-r` needed!):**
```bash
mv old_project_name new_project_name
mv my_project ~/archive/
```

### Useful `mv` Options

```bash
mv -i source dest            # Interactive - ask before overwriting
mv -v source dest            # Verbose - show what's being done
mv -n source dest            # No-clobber - don't overwrite existing files
```

### Practical Examples

**Organize FASTQ files:**
```bash
# Move all FASTQ files to raw_data directory
mv *.fastq raw_data/

# Move specific samples
mv sample1_R1.fastq sample1_R2.fastq processed/
```

**Rename with timestamp:**
```bash
mv results.txt results_2025-11-04.txt
```

**Reorganize project:**
```bash
mv old_scripts/* scripts/     # Move contents of old_scripts to scripts
```

## Deleting Files and Directories

### ⚠️ IMPORTANT WARNING ⚠️

**There is NO undo in Linux!** When you delete something, it's gone forever. There's no recycle bin or trash folder. Always double-check before deleting.

### The `rm` Command

`rm` stands for "remove" - it permanently deletes files.

**Delete a file:**
```bash
rm unwanted_file.txt
```

**Delete multiple files:**
```bash
rm file1.txt file2.txt file3.txt
```

**Delete all files of a certain type:**
```bash
rm *.tmp                     # Delete all .tmp files
rm *.bak                     # Delete all backup files
```

### Deleting Directories

**Delete an empty directory:**
```bash
rmdir empty_directory
```

**Delete a directory and all its contents:**
```bash
rm -r directory_name
```

The `-r` flag means "recursive" - it deletes everything inside.

### Safety Options for `rm`

```bash
rm -i file.txt               # Interactive - ask for confirmation
rm -I *.txt                  # Prompt once before deleting >3 files
rm -v file.txt               # Verbose - show what's deleted
```

**Recommended practice: Always use `-i` for important operations:**

```bash
rm -i important_file.txt
# Output: rm: remove regular file 'important_file.txt'? 
# Type 'y' for yes, 'n' for no
```

### Safe Deletion Workflow

Instead of deleting immediately, move files to a trash directory:

```bash
# Create a trash directory
mkdir -p ~/.trash

# Move files there instead of deleting
mv unwanted_file.txt ~/.trash/

# Periodically clean out trash
rm -ri ~/.trash/*

# Or delete old trash (files older than 30 days)
find ~/.trash -type f -mtime +30 -delete
```

### What NOT to Do

❌ **NEVER do this unless you're absolutely certain:**
```bash
rm -rf /                     # EXTREMELY DANGEROUS - deletes everything!
rm -rf ~                     # Deletes your entire home directory!
rm -rf *                     # Deletes everything in current directory!
```

The `-f` flag means "force" - it doesn't ask for confirmation. Combined with `-r` (recursive), it's very dangerous.

## Wildcards for Bulk Operations

Wildcards let you work with multiple files at once.

### Common Wildcards

**`*` - matches any characters:**
```bash
ls *.fasta                   # All FASTA files
ls sample*                   # All files starting with "sample"
ls *_R1.fastq               # All R1 FASTQ files
```

**`?` - matches single character:**
```bash
ls sample?.txt              # sample1.txt, sample2.txt, but not sample10.txt
ls sample??.txt             # sample01.txt, sample02.txt
```

**`[]` - matches any character in brackets:**
```bash
ls sample[123].txt          # sample1.txt, sample2.txt, sample3.txt
ls sample[1-5].txt          # sample1.txt through sample5.txt
ls sample[A-Z].txt          # sampleA.txt through sampleZ.txt
```

**`{}` - matches patterns in braces:**
```bash
ls sample_{1,2,3}.txt       # sample_1.txt, sample_2.txt, sample_3.txt
ls *.{fasta,fastq}          # All FASTA and FASTQ files
```

### Practical Wildcard Examples

```bash
# Copy all FASTQ files
cp *.fastq raw_data/

# Move all BAM files
mv *.bam alignments/

# Delete all temporary files
rm -i *.tmp

# Copy specific sample pairs
cp sample_{1,2,3}_R{1,2}.fastq processed/

# List large FASTA files
ls -lh *.fasta *.fa

# Move files from specific samples
mv sample[1-9]*.fastq batch1/
mv sample[1-5][0-9]*.fastq batch2/
```

## Checking Before You Act

Always verify before bulk operations:

```bash
# Check what will be affected
ls *.tmp                    # See what files match

# Then act
rm -i *.tmp                 # Delete with confirmation
```

```bash
# Preview move
ls sample*.fastq            # See what will move

# Execute
mv sample*.fastq raw_data/
```

## Practical Workflows

### Workflow 1: Setting Up a New Analysis

```bash
# Create project structure
cd ~
mkdir -p my_analysis/{data,scripts,results,logs}

# Copy data from shared location
cp /shared/data/experiment/*.fastq my_analysis/data/

# Verify
ls -lh my_analysis/data/
```

### Workflow 2: Organizing Results

```bash
# Create timestamped results directory
cd ~/my_project
mkdir -p results/run_$(date +%Y%m%d)

# Move output files
mv *.bam *.bai results/run_$(date +%Y%m%d)/

# Verify
ls -lh results/run_$(date +%Y%m%d)/
```

### Workflow 3: Archiving Old Data

```bash
# Create archive directory
mkdir -p ~/archive/2024_projects

# Move old projects (carefully!)
mv ~/old_project1 ~/archive/2024_projects/
mv ~/old_project2 ~/archive/2024_projects/

# Compress archives
cd ~/archive/2024_projects
tar -czf old_project1.tar.gz old_project1/
tar -czf old_project2.tar.gz old_project2/

# After verifying archives, remove originals
rm -r old_project1 old_project2
```

## Practice Exercises

### Exercise 1: Create Project Structure

```bash
cd ~
mkdir -p practice/test_project/{data/{raw,processed},results,scripts}
ls -R practice/test_project
```

### Exercise 2: File Operations

```bash
cd ~/practice/test_project
touch scripts/analyze.sh scripts/plot.R
touch data/raw/sample1.txt data/raw/sample2.txt
cp data/raw/sample1.txt data/processed/
mv data/raw/sample2.txt data/processed/sample2_cleaned.txt
ls -R
```

### Exercise 3: Safe Deletion

```bash
# Create test files
touch test1.txt test2.txt test3.txt
ls test*

# Try different deletion methods
rm -i test1.txt            # Interactive
ls test*

# Create trash directory and move instead
mkdir -p ~/.trash
mv test2.txt ~/.trash/
ls test* ~/.trash/

# Final deletion with confirmation
rm -i test3.txt
```

## Quick Reference

| Command | Description | Example |
|---------|-------------|---------|
| `mkdir dir` | Create directory | `mkdir my_project` |
| `mkdir -p` | Create nested directories | `mkdir -p a/b/c` |
| `touch file` | Create empty file | `touch notes.txt` |
| `cp source dest` | Copy file | `cp file1.txt file2.txt` |
| `cp -r` | Copy directory | `cp -r dir1 dir2` |
| `mv source dest` | Move/rename | `mv old.txt new.txt` |
| `rm file` | Delete file | `rm unwanted.txt` |
| `rm -r dir` | Delete directory | `rm -r old_project` |
| `rm -i` | Delete with confirmation | `rm -i file.txt` |

## Common Mistakes to Avoid

❌ **Not using `-r` for directories**
```bash
cp my_project my_backup      # Fails
```
✓ **Use recursive flag**
```bash
cp -r my_project my_backup   # Works
```

❌ **Deleting without checking**
```bash
rm *.txt                     # Deletes all .txt files!
```
✓ **Check first, then delete**
```bash
ls *.txt                     # See what will be deleted
rm -i *.txt                  # Delete with confirmation
```

❌ **Overwriting important files**
```bash
mv new_data.txt important_data.txt  # Overwrites important_data.txt!
```
✓ **Use interactive mode**
```bash
mv -i new_data.txt important_data.txt  # Asks before overwriting
```

## What's Next?

Now that you can create and organize files, you're ready to learn how to view and examine their contents!

**[Next: Viewing File Contents →](04-viewing-files.md)**

---

**Key Takeaway:** File operations are powerful but permanent. Always use `-i` for important operations, check with `ls` before bulk actions, and remember: there's no undo button in Linux!
