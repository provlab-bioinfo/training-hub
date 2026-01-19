# Working with Compressed Files

In bioinformatics, you'll work with compressed files constantly. Sequence data files can be enormous, so compression is essential to save disk space and transfer data efficiently. This tutorial covers everything you need to know about compressed files in Linux.

## Why Compression Matters in Bioinformatics

**Typical compression ratios:**
- FASTQ files: 3-5x smaller when compressed
- FASTA files: 4-6x smaller when compressed
- SAM files: 5-10x smaller when compressed to BAM

**Example:**
```
reads.fastq          10 GB
reads.fastq.gz        2 GB    (80% space saved!)
```

This saves disk space, backup time, and network transfer time.

***

<details>
<summary>The `gzip` Format</summary>

`gzip` is the most common compression format in bioinformatics. Files typically have `.gz` extension.

### Compressing Files with `gzip`

**Basic compression:**
```bash
gzip filename.txt
```

This creates `filename.txt.gz` and **deletes the original file**.

**Keep the original file:**
```bash
gzip -k filename.txt
```

Now you have both `filename.txt` and `filename.txt.gz`.

**Compress multiple files:**
```bash
gzip file1.txt file2.txt file3.txt
```

**Compress with specific compression level:**
```bash
gzip -1 file.txt        # Fastest compression, larger file (1-9)
gzip -9 file.txt        # Best compression, slower (default is -6)
gzip -6 file.txt        # Default compression
```

**Check compression ratio:**
```bash
gzip -v file.txt        # Verbose - shows compression percentage
```

**Bioinformatics examples:**
```bash
# Compress FASTQ files
gzip reads_R1.fastq reads_R2.fastq

# Compress with best compression for archival
gzip -9 old_results.txt

# Compress keeping originals (for testing)
gzip -k sample.fasta

# Compress all FASTQ files
gzip *.fastq
```

### Decompressing Files with `gunzip`

**Basic decompression:**
```bash
gunzip filename.txt.gz
```

This creates `filename.txt` and **deletes the compressed file**.

**Keep the compressed file:**
```bash
gunzip -k filename.txt.gz
```

**Decompress multiple files:**
```bash
gunzip *.gz
```

**Test integrity without decompressing:**
```bash
gunzip -t filename.txt.gz
```

**Bioinformatics examples:**
```bash
# Decompress FASTQ for analysis
gunzip reads.fastq.gz

# Decompress keeping archive
gunzip -k reference.fasta.gz

# Test file integrity
gunzip -t important_data.txt.gz
```
</details>

<details>
<summary>Viewing Compressed Files WITHOUT Decompressing</summary>

This is incredibly useful! You can work with compressed files directly without wasting time and space decompressing them.

### `zcat` - View Compressed Files

```bash
zcat file.txt.gz        # Display entire file
```

**Examples:**
```bash
# View compressed file
zcat sequences.fasta.gz

# View first 10 lines
zcat reads.fastq.gz | head

# View last 20 lines
zcat logfile.txt.gz | tail -20

# Count lines
zcat reads.fastq.gz | wc -l

# Combine with other commands
zcat sequences.fasta.gz | grep ">" | wc -l
```

### `zless` and `zmore` - Browse Compressed Files

```bash
zless file.txt.gz       # Browse interactively (like less)
zmore file.txt.gz       # Browse page by page (like more)
```

All the same navigation keys work as in `less`:
- Space: next page
- b: previous page
- /pattern: search
- q: quit

**Examples:**
```bash
# Browse large compressed FASTA
zless genome.fasta.gz

# Search in compressed file
zless annotations.gtf.gz
# Then press / and type "gene_name"
```

### `zgrep` - Search in Compressed Files

```bash
zgrep "pattern" file.txt.gz
```

All `grep` options work with `zgrep`!

**Examples:**
```bash
# Count sequences in compressed FASTA
zgrep -c ">" sequences.fasta.gz

# Search for specific gene
zgrep "BRCA1" annotations.gtf.gz

# Case-insensitive search
zgrep -i "error" logfile.txt.gz

# Search multiple compressed files
zgrep "pattern" *.gz

# Show context
zgrep -A 1 ">seq1" sequences.fasta.gz
```

### `zdiff` - Compare Compressed Files

```bash
zdiff file1.txt.gz file2.txt.gz
```

Compares two compressed files without decompressing them.

## Working with FASTQ.gz Files

FASTQ files are almost always compressed. Here's how to work with them efficiently:

### Count Reads

```bash
# Count reads (divide lines by 4)
zcat reads.fastq.gz | wc -l
# Then divide result by 4

# Or do calculation directly
echo $(zcat reads.fastq.gz | wc -l)/4 | bc
```

### View First/Last Reads

```bash
# First read
zcat reads.fastq.gz | head -n 4

# First 10 reads
zcat reads.fastq.gz | head -n 40

# Last read
zcat reads.fastq.gz | tail -n 4
```

### Extract Specific Reads

```bash
# Extract reads containing specific sequence
zcat reads.fastq.gz | grep -A 3 "ATCGATCG" > matching_reads.fastq

# Extract first 1000 reads for testing
zcat reads.fastq.gz | head -n 4000 > subset.fastq
```

### Convert FASTQ to FASTA

```bash
zcat reads.fastq.gz | paste - - - - | cut -f1,2 | sed 's/@/>/' | tr '\t' '\n' > reads.fasta
```

### Check Read Quality

```bash
# Extract quality lines
zcat reads.fastq.gz | awk 'NR%4==0' | head -1000

# Check read lengths
zcat reads.fastq.gz | awk 'NR%4==2 {print length}' | sort | uniq -c
```
</details>

<details>
<summary>The `tar` Command - Archive Multiple Files</summary>

`tar` (tape archive) bundles multiple files into a single archive. Often combined with compression.

### Common `tar` Operations

**Create compressed archive:**
```bash
tar -czf archive.tar.gz directory/
```

**Extract compressed archive:**
```bash
tar -xzf archive.tar.gz
```

**List contents without extracting:**
```bash
tar -tzf archive.tar.gz
```

**Extract to specific directory:**
```bash
tar -xzf archive.tar.gz -C /path/to/destination/
```

### Understanding `tar` Options

```bash
c - Create archive
x - Extract archive
t - List contents
z - Use gzip compression
j - Use bzip2 compression
f - File name follows
v - Verbose (show progress)
```

**Common combinations:**
```bash
tar -czf   # Create gzip archive
tar -xzf   # Extract gzip archive
tar -cjf   # Create bzip2 archive (better compression, slower)
tar -xjf   # Extract bzip2 archive
tar -czvf  # Create with verbose output
```

### Bioinformatics Examples with `tar`

**Archive project directory:**
```bash
tar -czf project_backup.tar.gz my_project/
```

**Archive with timestamp:**
```bash
tar -czf results_$(date +%Y%m%d).tar.gz results/
```

**Archive multiple directories:**
```bash
tar -czf analysis.tar.gz raw_data/ processed_data/ results/
```

**Extract specific files:**
```bash
tar -xzf archive.tar.gz file1.txt file2.txt
```

**Extract files matching pattern:**
```bash
tar -xzf archive.tar.gz --wildcards "*.fasta"
```

**View contents before extracting:**
```bash
tar -tzf archive.tar.gz | less
```

**Exclude files from archive:**
```bash
tar -czf backup.tar.gz --exclude="*.bam" project/
```

**Archive and verify:**
```bash
tar -czf archive.tar.gz data/
tar -tzf archive.tar.gz    # Verify contents
```
</details>

<details>
<summary>Other Compression Tools</summary>

### `bzip2` - Better Compression, Slower

```bash
bzip2 file.txt              # Compress (creates file.txt.bz2)
bunzip2 file.txt.bz2        # Decompress
bzcat file.txt.bz2          # View without decompressing
bzgrep "pattern" file.bz2   # Search in compressed file
```

**When to use:**
- Long-term storage (better compression than gzip)
- When compression ratio matters more than speed

### `xz` - Best Compression, Slowest

```bash
xz file.txt                 # Compress (creates file.txt.xz)
unxz file.txt.xz            # Decompress
xzcat file.txt.xz           # View without decompressing
```

**When to use:**
- Archival storage
- Maximum compression needed

### Compression Format Comparison

| Format | Speed | Compression | Common Use |
|--------|-------|-------------|------------|
| gzip (.gz) | Fast | Good | Most common, standard for FASTQ |
| bzip2 (.bz2) | Medium | Better | Long-term storage |
| xz (.xz) | Slow | Best | Archival, maximum compression |

</details>

<details>
<summary>Practical Workflows</summary>

### Workflow 1: Archive Old Analysis

```bash
# Create timestamped archive
tar -czf old_analysis_$(date +%Y%m%d).tar.gz old_project/

# Verify archive
tar -tzf old_analysis_*.tar.gz | head

# Check archive size
ls -lh old_analysis_*.tar.gz

# Remove original if verified
rm -r old_project/
```

### Workflow 2: Transfer Compressed Data

```bash
# Compress before transfer
tar -czf data_transfer.tar.gz raw_data/

# Transfer (example with scp)
# scp data_transfer.tar.gz user@server:/destination/

# On receiving end, extract
tar -xzf data_transfer.tar.gz
```

### Workflow 3: Process Compressed FASTQ

```bash
# Count reads
reads=$(zcat reads.fastq.gz | wc -l)
echo "Total reads: $((reads / 4))"

# Quality filter and compress output
zcat reads.fastq.gz | quality_filter | gzip > filtered.fastq.gz

# Extract subset for testing
zcat reads.fastq.gz | head -n 40000 | gzip > subset.fastq.gz
```

### Workflow 4: Batch Compression

```bash
# Compress all FASTQ files
for file in *.fastq; do
    echo "Compressing $file"
    gzip "$file"
done

# Or simpler
gzip *.fastq

# Compress with progress indicator
for file in *.fastq; do
    echo "Compressing $file..."
    gzip -v "$file"
done
```

### Workflow 5: Archive by Date

```bash
# Archive files older than 90 days
find . -name "*.bam" -mtime +90 -print0 | tar -czf old_bams_$(date +%Y%m%d).tar.gz --null -T -

# List what will be archived
find . -name "*.bam" -mtime +90
```

### Workflow 6: Verify Compressed Files

```bash
# Test all compressed files
for file in *.gz; do
    echo "Testing $file"
    gunzip -t "$file" && echo "OK" || echo "CORRUPT"
done

# Find corrupt files
find . -name "*.gz" -exec gunzip -t {} \; -print 2>&1 | grep -B1 "unexpected end"
```
</details>

<details>
<summary>Space-Saving Strategies</summary>

### Check Compression Savings

```bash
# Before compression
ls -lh data/

# Compress and check
gzip -rv data/

# See savings
du -sh data/
```

### Find Uncompressed Files

```bash
# Find large uncompressed FASTQ files
find . -name "*.fastq" ! -name "*.gz" -size +100M

# Compress them
find . -name "*.fastq" ! -name "*.gz" -exec gzip {} \;
```

### Check Disk Usage

```bash
# Current directory size
du -sh .

# Size by subdirectory
du -sh */

# Find largest files
find . -type f -exec du -h {} + | sort -rh | head -20

# Find large compressed files
find . -name "*.gz" -size +1G -exec ls -lh {} \;
```
</details>

<details>
<summary>Compression Best Practices</summary>

1. **Always compress FASTQ files** - They're huge and compress well
   ```bash
   gzip *.fastq
   ```

2. **Work with compressed files directly** - Don't decompress unnecessarily
   ```bash
   zcat reads.fastq.gz | analysis_tool
   ```

3. **Test before deleting originals**
   ```bash
   gzip -k important.txt    # Keep original
   gunzip -t important.txt.gz  # Test integrity
   rm important.txt         # Delete original if OK
   ```

4. **Archive old data** - Save space on active storage
   ```bash
   tar -czf old_project.tar.gz old_project/
   ```

5. **Document compression settings** - For reproducibility
   ```bash
   # Save compression info
   echo "gzip -9" > compression_method.txt
   ```

6. **Use appropriate compression for use case:**
   - **Active analysis:** gzip (fast, good compression)
   - **Long-term storage:** bzip2 or xz (better compression)
   - **Quick testing:** lower compression level (gzip -1)

</details>

<details>
<summary>Practice Exercises</summary>

### Exercise 1: Basic Compression

```bash
# Create test file
echo "This is a test file" > test.txt

# Compress it
gzip test.txt

# Verify compressed file exists
ls test.txt.gz

# View without decompressing
zcat test.txt.gz

# Decompress
gunzip test.txt.gz
```

### Exercise 2: Working with Compressed Data

```bash
# Create test FASTA
cat > seqs.fasta << EOF
>seq1
ATCGATCG
>seq2
GCTAGCTA
EOF

# Compress
gzip seqs.fasta

# Count sequences without decompressing
zgrep -c ">" seqs.fasta.gz

# View with zless
zless seqs.fasta.gz
```

### Exercise 3: Archive Practice

```bash
# Create test directory structure
mkdir -p test_project/{data,results,scripts}
touch test_project/data/file1.txt
touch test_project/results/output.txt

# Create archive
tar -czf test_backup.tar.gz test_project/

# List contents
tar -tzf test_backup.tar.gz

# Extract
tar -xzf test_backup.tar.gz
```

### Exercise 4: Batch Compression

```bash
# Create multiple test files
for i in {1..5}; do
    echo "File $i content" > file$i.txt
done

# Compress all
gzip file*.txt

# List compressed files
ls -lh file*.gz

# Decompress all
gunzip file*.gz
```
</details>

***

## Quick Reference

### gzip Commands

| Command | Description |
|---------|-------------|
| `gzip file` | Compress file |
| `gzip -k file` | Compress keeping original |
| `gzip -9 file` | Maximum compression |
| `gunzip file.gz` | Decompress |
| `gunzip -t file.gz` | Test integrity |
| `zcat file.gz` | View compressed file |
| `zless file.gz` | Browse compressed file |
| `zgrep pattern file.gz` | Search compressed file |

### tar Commands

| Command | Description |
|---------|-------------|
| `tar -czf archive.tar.gz dir/` | Create compressed archive |
| `tar -xzf archive.tar.gz` | Extract archive |
| `tar -tzf archive.tar.gz` | List contents |
| `tar -xzf file.tar.gz -C dir/` | Extract to directory |
| `tar -czf arch.tar.gz --exclude="*.bam" dir/` | Exclude pattern |

## Common Mistakes

❌ **Decompressing when not needed**
```bash
gunzip large_file.fastq.gz    # Wastes time and space
cat large_file.fastq | tool   # Then use
```
✓ **Work with compressed files**
```bash
zcat large_file.fastq.gz | tool    # Direct processing
```

❌ **Forgetting files are deleted after compression**
```bash
gzip important.txt    # Original is gone!
```
✓ **Keep originals when needed**
```bash
gzip -k important.txt    # Original preserved
```

❌ **Wrong tar options order**
```bash
tar -zxf dir/ archive.tar.gz    # Wrong
```
✓ **Correct order**
```bash
tar -xzf archive.tar.gz    # Correct
```

❌ **Compressing already compressed files**
```bash
gzip file.fastq.gz    # Wastes time, no benefit
```
✓ **Check extension first**
```bash
file file.fastq.gz    # Check if already compressed
```
---

**Key Takeaway:** In bioinformatics, compression is essential. Use `gzip` for active data, work with compressed files directly using `zcat`/`zgrep`/`zless`, and use `tar` to archive entire projects. This saves enormous amounts of disk space and time!
