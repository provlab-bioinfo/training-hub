# Intermediate Exercise 3: Compression

Master working with compressed files - essential for bioinformatics where data files are huge. Learn gzip, tar, and working with compressed data directly.

## Setup

Create practice files of various types:

```bash
cd ~
mkdir -p compression_practice
cd compression_practice

# Create various text files
cat > data1.txt << 'EOF'
Sample data for compression testing
This file contains multiple lines
To demonstrate compression ratios
And practice compression commands
EOF

cat > data2.txt << 'EOF'
More sample data here
Different content to compress
Multiple files for archiving
Practice makes perfect
EOF

# Create FASTA file
cat > sequences.fasta << 'EOF'
>gene1 hypothetical protein
ATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCG
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTA
>gene2 kinase domain
GGGGCCCCAAAATTTTGGGGCCCCAAAATTTTGGGGCCCCAAAA
>gene3 DNA binding protein
ATATATATATCGCGCGCGATATATATCGCGCGCGATATATCGCG
EOF

# Create FASTQ file
cat > reads.fastq << 'EOF'
@read1
ATCGATCGATCGATCGATCGATCGATCGATCG
+
IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
@read2
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTA
+
HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
@read3
TTTTAAAACCCCGGGGTTTTAAAACCCCGGGG
+
GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
@read4
ATCGATCGATCGATCGATCG
+
IIIIIIIIIIIIIIIIIII
@read5
NNNNNATCGATCGATCGATCGATCG
+
!!!!!!IIIIIIIIIIIIIIIIII
EOF

# Create larger file for compression testing
seq 1 10000 | awk '{print "Line " $1 ": " "ATCGATCG" $1}' > large_file.txt

# Create directory structure for archiving
mkdir -p project1/{data,scripts,results}
echo "Sample data" > project1/data/sample.txt
echo "#!/bin/bash" > project1/scripts/analyze.sh
echo "Results here" > project1/results/output.txt

# Create second directory
mkdir -p project2/{raw,processed}
echo "Raw data" > project2/raw/input.txt
echo "Processed data" > project2/processed/output.txt

# Create log files
cat > analysis.log << 'EOF'
[2024-11-07 10:00:00] Analysis started
[2024-11-07 10:05:00] Processing sample001
[2024-11-07 10:10:00] Processing sample002
[2024-11-07 10:15:00] Processing sample003
[2024-11-07 10:20:00] Analysis complete
EOF

# Create multiple sample files
for i in {1..5}; do
    echo "Sample${i} data content" > sample${i}.txt
done
```

## Part 1: Basic gzip Operations

### Exercise 1.1: Compressing Files

**Tasks:**
1. Compress data1.txt
2. Check the compression result
3. Compare original and compressed sizes
4. Compress multiple files at once

**Commands:**
```bash
gzip data1.txt
ls -lh data1.txt.gz
# Original is gone! Only .gz remains

# Compress keeping original
gzip -k data2.txt
ls -lh data2.txt*

# Compress multiple files
gzip sample*.txt
```

**Questions:**
- What happens to the original file?
- How much space was saved?

### Exercise 1.2: Compression Levels

**Tasks:**
1. Create three copies of large_file.txt
2. Compress with different levels (1, 6, 9)
3. Compare sizes and times
4. Compare compression ratios

**Commands:**
```bash
cp large_file.txt test1.txt
cp large_file.txt test6.txt
cp large_file.txt test9.txt

time gzip -1 test1.txt    # Fastest, less compression
time gzip -6 test6.txt    # Default
time gzip -9 test9.txt    # Best compression, slower

ls -lh test*.gz
```

**Analysis:**
- Which is fastest?
- Which gives best compression?
- When would you use each level?

### Exercise 1.3: Decompressing Files

**Tasks:**
1. Decompress data1.txt.gz
2. Decompress keeping the .gz file
3. Decompress multiple files at once

**Commands:**
```bash
gunzip data1.txt.gz
# Now data1.txt exists, .gz is gone

gzip data1.txt          # Compress again
gunzip -k data1.txt.gz  # Decompress, keep .gz

# Decompress all
gunzip *.gz
```

### Exercise 1.4: Testing Integrity

**Tasks:**
1. Compress sequences.fasta
2. Test the compressed file
3. Verify integrity without decompressing

**Commands:**
```bash
gzip sequences.fasta
gunzip -t sequences.fasta.gz
echo $?    # 0 = success, non-zero = failure
```

**Practice:** Verify all your compressed files.

## Part 2: Working with Compressed Files

### Exercise 2.1: Viewing Compressed Files

**Tasks:**
1. Compress reads.fastq
2. View contents without decompressing
3. View first 10 lines
4. View last 10 lines
5. Browse interactively

**Commands:**
```bash
gzip reads.fastq
zcat reads.fastq.gz
zcat reads.fastq.gz | head -10
zcat reads.fastq.gz | tail -10
zless reads.fastq.gz
```

**Question:** Why use zcat instead of gunzip then cat?

### Exercise 2.2: Searching in Compressed Files

**Tasks:**
1. Search for specific read ID in compressed FASTQ
2. Count reads in compressed file
3. Search for pattern across multiple compressed files
4. Extract specific sequences

**Commands:**
```bash
zgrep "@read1" reads.fastq.gz
zcat reads.fastq.gz | wc -l    # Divide by 4 for read count
zgrep -c "pattern" *.gz
zgrep -A 3 "@read1" reads.fastq.gz
```

### Exercise 2.3: Processing Compressed Data

**Tasks:**
1. Count sequences in compressed FASTA
2. Extract sequence IDs from compressed file
3. Calculate statistics without decompressing
4. Pipe compressed data through multiple commands

**Commands:**
```bash
# Compress FASTA first (if not already)
gzip -k sequences.fasta

zgrep -c ">" sequences.fasta.gz
zgrep ">" sequences.fasta.gz | cut -d' ' -f1
zcat sequences.fasta.gz | grep -v ">" | wc -c
zcat sequences.fasta.gz | grep -v ">" | tr -d '\n' | wc -c
```

### Exercise 2.4: Comparing Compressed Files

**Tasks:**
1. Create two similar files and compress
2. Compare compressed files directly
3. Find differences

**Commands:**
```bash
echo "version 1" > file1.txt
echo "version 2" > file2.txt
gzip file1.txt file2.txt

zdiff file1.txt.gz file2.txt.gz
```

## Part 3: tar Archives

### Exercise 3.1: Creating Archives

**Tasks:**
1. Create a tar archive of project1/
2. Create a compressed tar archive (tar.gz)
3. Create archive with verbose output
4. Archive multiple directories

**Commands:**
```bash
tar -cf project1.tar project1/
tar -czf project1.tar.gz project1/
tar -czvf project1_verbose.tar.gz project1/
tar -czf projects.tar.gz project1/ project2/
```

**Flags explained:**
- `c` = create
- `z` = gzip compression
- `f` = file (must be last before filename)
- `v` = verbose

### Exercise 3.2: Listing Archive Contents

**Tasks:**
1. List contents without extracting
2. List with detailed information
3. Search for specific files in archive

**Commands:**
```bash
tar -tzf project1.tar.gz
tar -tzvf project1.tar.gz
tar -tzf project1.tar.gz | grep "scripts"
```

### Exercise 3.3: Extracting Archives

**Tasks:**
1. Extract entire archive
2. Extract to specific directory
3. Extract only specific files
4. Extract with verbose output

**Commands:**
```bash
tar -xzf project1.tar.gz
tar -xzf project1.tar.gz -C /tmp/
tar -xzf project1.tar.gz project1/scripts/analyze.sh
tar -xzvf project1.tar.gz
```

### Exercise 3.4: Updating Archives

**Tasks:**
1. Add files to existing archive
2. Update modified files
3. Verify archive integrity

**Commands:**
```bash
# Note: Can't update .tar.gz, only .tar
tar -cf archive.tar project1/
tar -rf archive.tar project2/    # Append
tar -tf archive.tar              # Verify
```

### Exercise 3.5: Archive Best Practices

**Tasks:**
1. Create dated archive
2. Archive excluding certain files
3. Preserve permissions and timestamps

**Commands:**
```bash
tar -czf backup_$(date +%Y%m%d).tar.gz project1/
tar -czf project.tar.gz --exclude="*.log" project1/
tar -czpf project.tar.gz project1/    # p = preserve permissions
```

## Part 4: Real-World Scenarios

### Exercise 4.1: Archiving Analysis Results

**Scenario:** Archive completed analysis for long-term storage.

**Tasks:**
1. Create organized archive structure
2. Include only final results (exclude intermediate)
3. Add timestamp to archive name
4. Verify archive was created correctly

**Solution:**
```bash
# Create archive
tar -czf analysis_results_$(date +%Y%m%d).tar.gz \
    --exclude="*.tmp" \
    --exclude="*.bam" \
    project1/results/

# Verify
tar -tzf analysis_results_*.tar.gz | head

# Check size
ls -lh analysis_results_*.tar.gz
```

### Exercise 4.2: Compressing Sequencing Data

**Scenario:** Compress large FASTQ files for storage.

**Tasks:**
1. Compress all FASTQ files
2. Verify compression ratios
3. Test file integrity
4. Create summary report

**Solution:**
```bash
# Compress all FASTQ files
for file in *.fastq; do
    echo "Compressing $file..."
    gzip -v "$file"
done

# Test all compressed files
for file in *.fastq.gz; do
    gunzip -t "$file" && echo "$file: OK" || echo "$file: FAILED"
done

# Report compression
ls -lh *.fastq.gz > compression_report.txt
```

### Exercise 4.3: Batch Decompression

**Scenario:** Process multiple compressed files.

**Tasks:**
1. Decompress all .gz files
2. Process decompressed files
3. Recompress when done
4. Clean up

**Solution:**
```bash
# Decompress all
gunzip *.gz

# Process (example: count lines)
for file in *.txt; do
    echo "$file: $(wc -l < $file) lines"
done

# Recompress
gzip *.txt
```

### Exercise 4.4: Transferring Data

**Scenario:** Prepare data for transfer to collaborator.

**Tasks:**
1. Archive all relevant files
2. Compress with best ratio
3. Calculate checksum for verification
4. Create transfer manifest

**Solution:**
```bash
# Create archive
tar -czf data_transfer.tar.gz project1/ project2/

# Generate checksum
md5sum data_transfer.tar.gz > data_transfer.md5

# Create manifest
cat > transfer_manifest.txt << EOF
File: data_transfer.tar.gz
Size: $(ls -lh data_transfer.tar.gz | awk '{print $5}')
Date: $(date)
MD5: $(cat data_transfer.md5)
Contents:
$(tar -tzf data_transfer.tar.gz | head -20)
...
EOF
```

### Exercise 4.5: Incremental Backups

**Scenario:** Create dated backups of project directory.

**Tasks:**
1. Create today's backup
2. Only include changed files
3. Maintain backup history
4. Automate with script

**Solution:**
```bash
#!/bin/bash
BACKUP_DIR="backups"
DATE=$(date +%Y%m%d)
mkdir -p $BACKUP_DIR

# Full backup on first of month
if [ $(date +%d) == "01" ]; then
    tar -czf $BACKUP_DIR/full_$DATE.tar.gz project1/
else
    # Incremental backup
    tar -czf $BACKUP_DIR/incremental_$DATE.tar.gz \
        --newer-mtime="1 day ago" \
        project1/
fi

echo "Backup created: $(ls -lh $BACKUP_DIR/*$DATE.tar.gz)"
```

## Part 5: Advanced Operations

### Exercise 5.1: Working with Streaming Data

**Tasks:**
1. Compress data on-the-fly
2. Pipe compressed data between commands
3. Create compressed output directly

**Commands:**
```bash
# Generate and compress in one step
seq 1 100000 | gzip > numbers.txt.gz

# Process compressed, output compressed
zcat input.fastq.gz | quality_filter | gzip > filtered.fastq.gz

# Decompress, process, compress
zcat reads.fastq.gz | head -40 | gzip > sample_reads.fastq.gz
```

### Exercise 5.2: Compression Comparison

**Task:** Compare different compression methods.

**Test with:**
- gzip (default)
- gzip -9
- bzip2
- xz

**Commands:**
```bash
# Create test copies
for i in {1..4}; do cp large_file.txt test$i.txt; done

# Test different methods
time gzip test1.txt
time gzip -9 test2.txt
time bzip2 test3.txt
time xz test4.txt

# Compare results
ls -lh test*.{gz,bz2,xz}
```

**Analysis:**
- Speed differences?
- Size differences?
- When to use each?

### Exercise 5.3: Multi-threaded Compression

**Task:** Use pigz for faster compression (if available).

**Commands:**
```bash
# Install pigz if available
# sudo yum install pigz

# Compare with gzip
time gzip -k large_file.txt
time pigz -k large_file.txt

# Check if same format
file large_file.txt.gz
```

### Exercise 5.4: Selective Extraction

**Task:** Extract only specific files from large archive.

**Commands:**
```bash
# List all files
tar -tzf projects.tar.gz

# Extract only scripts
tar -xzf projects.tar.gz --wildcards "*/scripts/*"

# Extract specific file
tar -xzf projects.tar.gz project1/data/sample.txt
```

### Exercise 5.5: Archive Verification

**Task:** Comprehensive archive verification.

**Commands:**
```bash
# Create archive with checksums
tar -czf --exclude="*.gz" -f archive.tar.gz project1/

# Verify integrity
tar -tzf archive.tar.gz > /dev/null && echo "Archive OK" || echo "Archive CORRUPTED"

# Compare archive to original
tar -df archive.tar.gz

# List differences
tar -dzf archive.tar.gz
```

## Part 6: Space Management

### Exercise 6.1: Finding Compression Candidates

**Tasks:**
1. Find large uncompressed files
2. Calculate potential space savings
3. Identify compression priorities

**Commands:**
```bash
# Find large files
find . -type f -size +1M ! -name "*.gz" -exec ls -lh {} \;

# Calculate total size
find . -type f -size +1M ! -name "*.gz" -exec ls -l {} \; | awk '{sum+=$5} END {print sum/(1024*1024) " MB"}'

# List by size
find . -type f ! -name "*.gz" -exec ls -lh {} \; | sort -k5 -h
```

### Exercise 6.2: Automated Compression Script

**Task:** Create script to compress old files automatically.

**Script:**
```bash
#!/bin/bash
# compress_old_files.sh

DAYS=30
LOG="compression_log.txt"

echo "=== Compression Run: $(date) ===" >> $LOG

find . -name "*.fastq" -mtime +$DAYS -type f | while read file; do
    echo "Compressing: $file" >> $LOG
    gzip -v "$file" 2>> $LOG
done

echo "Compression complete" >> $LOG
```

### Exercise 6.3: Cleanup Old Archives

**Tasks:**
1. Find archives older than 90 days
2. Verify they're not needed
3. Remove safely

**Commands:**
```bash
# Find old archives
find . -name "*.tar.gz" -mtime +90

# List details before removing
find . -name "*.tar.gz" -mtime +90 -exec ls -lh {} \;

# Archive of archives before deletion
find . -name "*.tar.gz" -mtime +90 -print0 | tar -czf old_archives_$(date +%Y%m%d).tar.gz --null -T -

# Then remove
find . -name "*.tar.gz" -mtime +90 -delete
```

## Challenge Exercises

### Challenge 7.1: Complete Backup System

**Task:** Create comprehensive backup script.

**Requirements:**
1. Full backup monthly
2. Incremental daily
3. Compression with integrity checks
4. Rotation (keep last 3 months)
5. Email notification (simulate with echo)
6. Log all operations

**Build the script!**

### Challenge 7.2: Data Pipeline

**Task:** Create pipeline that handles compressed data throughout.

**Requirements:**
1. Accept compressed FASTQ input
2. Process without decompressing to disk
3. Filter reads
4. Output compressed results
5. Generate statistics
6. All in one pipeline

**Example framework:**
```bash
zcat input.fastq.gz | \
    awk 'NR%4==2 {if (length($0) >= 30) print header; print $0; print plus; print qual} 
         NR%4==1 {header=$0} 
         NR%4==3 {plus=$0} 
         NR%4==0 {qual=$0}' | \
    gzip > filtered.fastq.gz
```

### Challenge 7.3: Archive Management System

**Task:** Create archive inventory and management system.

**Requirements:**
1. Catalog all archives
2. Store metadata (date, size, contents)
3. Verify integrity regularly
4. Generate reports
5. Identify duplicates

## Reflection Questions

1. When should you use gzip vs tar vs tar.gz?
2. Why work with compressed files directly?
3. What's the tradeoff between compression levels?
4. How do you verify archive integrity?
5. When should you NOT compress files?
6. What's the difference between gzip and bzip2?

## Best Practices Learned

✓ **Always compress FASTQ/FASTA** files
✓ **Use -k flag** to keep originals when testing
✓ **Test integrity** after compression
✓ **Use appropriate compression level** (speed vs size)
✓ **Archive related files together** with tar
✓ **Add timestamps** to backup archives
✓ **Verify archives** before deleting originals
✓ **Work with compressed data** directly when possible
✓ **Document archive contents** in manifest files
✓ **Automate compression** for old files

## Quick Reference

### gzip Commands

| Task | Command |
|------|---------|
| Compress | `gzip file.txt` |
| Keep original | `gzip -k file.txt` |
| Decompress | `gunzip file.gz` |
| View compressed | `zcat file.gz` |
| Search compressed | `zgrep pattern file.gz` |
| Test integrity | `gunzip -t file.gz` |
| Best compression | `gzip -9 file.txt` |

### tar Commands

| Task | Command |
|------|---------|
| Create archive | `tar -czf archive.tar.gz dir/` |
| List contents | `tar -tzf archive.tar.gz` |
| Extract | `tar -xzf archive.tar.gz` |
| Extract to dir | `tar -xzf file.tar.gz -C /path/` |
| Add to archive | `tar -rf archive.tar file` |
| Exclude pattern | `tar -czf arc.tar.gz --exclude="*.tmp" dir/` |

## Next Steps

Congratulations on completing intermediate exercises! Ready for advanced workflows:
- [Advanced Workflow Exercises](../advanced/01-workflows-exercises.md)

---

**Estimated time:** 60-90 minutes

**Key skills practiced:**
- Compressing and decompressing files
- Working with compressed data directly
- Creating and managing archives
- Space management strategies
- Automation of compression tasks
- Best practices for data storage
- Real-world backup scenarios
