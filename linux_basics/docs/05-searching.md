# Searching and Finding

Finding specific content in files and locating files themselves are essential skills in bioinformatics. This tutorial covers the powerful `grep` and `find` commands that will save you countless hours.

## The `grep` Command - Search Inside Files

`grep` stands for "Global Regular Expression Print" - it searches for text patterns within files. This is one of the most useful commands you'll ever learn!

### Basic Usage

```bash
grep "pattern" filename
```

This searches for "pattern" in the file and displays matching lines.

**Example:**
```bash
grep "ATCG" sequences.fasta
```

Shows all lines containing "ATCG".

### Common `grep` Options

#### Case-Insensitive Search

```bash
grep -i "gene" annotations.txt    # Matches gene, Gene, GENE, etc.
```

#### Count Matches

```bash
grep -c "pattern" file.txt        # Shows number of matching lines
```

**Bioinformatics example:**
```bash
grep -c ">" sequences.fasta       # Count sequences (count header lines)
```

#### Show Line Numbers

```bash
grep -n "error" logfile.txt       # Shows line numbers of matches
```

Output:
```
42:Error: file not found
156:Error: invalid format
```

#### Invert Match (Show Non-Matching Lines)

```bash
grep -v "scaffold" data.txt       # Show lines NOT containing "scaffold"
```

**Example use:**
```bash
grep -v "^#" variants.vcf         # Skip header lines starting with #
```

#### Show Only Matching Part

```bash
grep -o "pattern" file.txt        # Show only the matched text, not whole line
```

#### Search Recursively in Directories

```bash
grep -r "pattern" directory/      # Search in all files in directory
grep -r "TODO" scripts/           # Find all TODO comments
```

#### Show Context Around Matches

```bash
grep -A 5 "pattern" file.txt      # Show 5 lines After match
grep -B 3 "pattern" file.txt      # Show 3 lines Before match
grep -C 2 "pattern" file.txt      # Show 2 lines of Context (before and after)
```

**Example:**
```bash
grep -A 1 ">seq1" sequences.fasta # Show header and sequence
```

#### Multiple Patterns

```bash
grep -e "pattern1" -e "pattern2" file.txt    # Match either pattern
grep "pattern1\|pattern2" file.txt           # Alternative syntax
```

#### Match Whole Words Only

```bash
grep -w "gene" file.txt           # Matches "gene" but not "geneid" or "subgene"
```

### Practical Bioinformatics Examples

**Count sequences in FASTA:**
```bash
grep -c ">" sequences.fasta
```

**Extract sequence IDs:**
```bash
grep ">" sequences.fasta
```

**Find sequences with specific motif:**
```bash
grep "TATAAA" sequences.fasta
```

**Get sequence with its header:**
```bash
grep -A 1 ">gene_of_interest" sequences.fasta
```

**Find genes on specific chromosome:**
```bash
grep "^chr1" genes.gtf            # Lines starting with chr1
```

**Count variants by type:**
```bash
grep -c "SNP" variants.vcf
grep -c "INDEL" variants.vcf
```

**Find errors in log files:**
```bash
grep -i "error" analysis.log      # Case-insensitive error search
grep -i "fail" analysis.log
```

**Extract sample names:**
```bash
grep "^sample" metadata.txt       # Lines starting with "sample"
```

**Find completed jobs:**
```bash
grep "successfully completed" job.*.log
```

**Search for gene names:**
```bash
grep -w "BRCA1" annotations.gtf   # Whole word only
```

## Search Multiple Files

### Search All Files in Current Directory

```bash
grep "pattern" *                  # Search all files
grep "pattern" *.txt              # Search all .txt files
grep "pattern" *.fasta            # Search all FASTA files
```

### Search with Filename Display

```bash
grep -H "pattern" *.txt           # Show filename with matches
grep -l "pattern" *.txt           # Show only filenames with matches
grep -L "pattern" *.txt           # Show filenames WITHOUT matches
```

**Example:**
```bash
grep -l "complete" *.log          # Which log files show completion?
```

### Recursive Search

```bash
grep -r "pattern" directory/                    # Search all files in directory tree
grep -r --include="*.py" "import" scripts/      # Only search Python files
grep -r --exclude="*.bak" "pattern" ./          # Exclude backup files
```

## Regular Expressions with `grep`

Regular expressions (regex) let you search for patterns, not just exact text.

### Basic Patterns

```bash
grep "^start" file.txt            # Lines starting with "start"
grep "end$" file.txt              # Lines ending with "end"
grep "^$" file.txt                # Empty lines
grep "^#" file.txt                # Lines starting with #
```

**Bioinformatics examples:**
```bash
grep "^>" sequences.fasta         # Sequence headers
grep "^chr[0-9]" genes.gtf        # Chromosomes 0-9
```

### Character Classes

```bash
grep "[ATCG]" file.txt            # Any of A, T, C, or G
grep "[0-9]" file.txt             # Any digit
grep "[A-Z]" file.txt             # Any uppercase letter
```

**Example:**
```bash
grep "^chr[1-9]" data.txt         # chr1 through chr9, but not chr10+
```

### Quantifiers

```bash
grep "A\{5\}" file.txt            # Exactly 5 A's
grep "A\{3,\}" file.txt           # 3 or more A's
grep "A\{2,5\}" file.txt          # Between 2 and 5 A's
grep "AT*G" file.txt              # A followed by zero or more T's, then G
```

**Example - find poly-A tail:**
```bash
grep "A\{10,\}" sequences.fasta   # Stretches of 10+ A's
```

### Extended Regular Expressions (`grep -E`)

```bash
grep -E "pattern1|pattern2" file.txt        # Either pattern (no backslash needed)
grep -E "gene(1|2|3)" file.txt              # gene1, gene2, or gene3
grep -E "[0-9]+" file.txt                   # One or more digits
```

**Bioinformatics examples:**
```bash
grep -E "chr(1|2|3|X|Y)" genes.gtf          # Specific chromosomes
grep -E "SNP|INDEL" variants.vcf            # Either variant type
grep -E "ATG[ATCG]{3}(TAA|TAG|TGA)" seq.fa  # Start codon + 3 bases + stop codon
```

## The `find` Command - Locate Files

While `grep` searches inside files, `find` searches for files themselves based on name, size, date, etc.

### Basic Usage

```bash
find /path -name "pattern"
```

**Common starting points:**
- `.` = current directory
- `~` = your home directory  
- `/` = entire system (slow!)

### Find by Name

```bash
find . -name "*.fastq"                    # All FASTQ files
find . -name "sample1*"                   # Files starting with sample1
find . -name "*results*"                  # Files containing "results"
```

**Case-insensitive search:**
```bash
find . -iname "*.FASTA"                   # Matches .fasta, .FASTA, .Fasta
```

### Find by Type

```bash
find . -type f                            # Files only
find . -type d                            # Directories only
find . -type l                            # Symbolic links only
```

**Example:**
```bash
find . -type f -name "*.bam"              # BAM files only (not directories)
```

### Find by Size

```bash
find . -size +100M                        # Files larger than 100MB
find . -size -1k                          # Files smaller than 1KB
find . -size 100M                         # Files exactly 100MB
```

Size units: `c` (bytes), `k` (KB), `M` (MB), `G` (GB)

**Examples:**
```bash
find . -size +1G -name "*.bam"            # Large BAM files
find . -size +500M -size -2G              # Files between 500MB and 2GB
find . -empty                             # Empty files
```

### Find by Time

```bash
find . -mtime -7                          # Modified in last 7 days
find . -mtime +30                         # Modified more than 30 days ago
find . -mtime 0                           # Modified today
```

**More time options:**
```bash
find . -mmin -60                          # Modified in last 60 minutes
find . -atime -7                          # Accessed in last 7 days
find . -ctime -7                          # Status changed in last 7 days
```

**Examples:**
```bash
find . -name "*.log" -mtime -1            # Log files from last 24 hours
find . -name "*.bam" -mtime +90           # Old BAM files (>90 days)
```

### Find by Permissions

```bash
find . -perm 644                          # Exact permissions
find . -perm -644                         # At least these permissions
find . -executable                        # Executable files
```

### Combining Conditions

**AND (default):**
```bash
find . -name "*.fastq" -size +1G          # FASTQ files larger than 1GB
```

**OR:**
```bash
find . -name "*.fasta" -o -name "*.fa"    # Either .fasta or .fa
```

**NOT:**
```bash
find . -name "*.txt" ! -name "*.bak.txt"  # .txt files except backups
```

**Complex example:**
```bash
find . -type f \( -name "*.bam" -o -name "*.sam" \) -size +100M
# BAM or SAM files larger than 100MB
```

### Taking Action on Found Files

#### Execute Command on Each File

```bash
find . -name "*.tmp" -delete              # Delete all .tmp files
find . -name "*.fastq" -exec wc -l {} \;  # Count lines in each FASTQ
```

The `{}` represents each found file, and `\;` ends the command.

#### Execute Command on Multiple Files at Once

```bash
find . -name "*.txt" -exec grep "pattern" {} +
```

The `+` at the end passes multiple files to the command at once (more efficient).

**Examples:**
```bash
# Compress old FASTQ files
find . -name "*.fastq" -mtime +30 -exec gzip {} \;

# Move old results to archive
find . -name "*.bam" -mtime +90 -exec mv {} archive/ \;

# List large files with details
find . -size +1G -exec ls -lh {} \;

# Count sequences in all FASTA files
find . -name "*.fasta" -exec grep -c ">" {} +
```

#### Print Results with Custom Format

```bash
find . -name "*.bam" -printf "%p\t%s\n"   # Filename and size
find . -name "*.fastq" -printf "%f\n"     # Just filename, no path
```

### Limit Search Depth

```bash
find . -maxdepth 1 -name "*.txt"          # Current directory only
find . -maxdepth 2 -name "*.fasta"        # Current dir and 1 level down
find . -mindepth 2 -name "*.bam"          # At least 2 levels deep
```

## Practical Workflows

### Workflow 1: Find and Count Sequences

```bash
# Find all FASTA files and count sequences in each
find . -name "*.fasta" -exec sh -c 'echo -n "{}:  "; grep -c ">" "$1"' _ {} \;
```

### Workflow 2: Clean Up Old Files

```bash
# Find files older than 90 days
find ~/temp -type f -mtime +90

# Review the list, then delete if sure
find ~/temp -type f -mtime +90 -delete
```

### Workflow 3: Find Large Files Taking Up Space

```bash
# Find largest files
find . -type f -size +1G -exec ls -lh {} \; | sort -k5 -h

# Or more detailed
find . -type f -printf "%s\t%p\n" | sort -n | tail -20
```

### Workflow 4: Locate Specific Sample Files

```bash
# Find all files for sample123
find . -name "*sample123*"

# Find just the FASTQ files for sample123
find . -name "*sample123*.fastq*"

# Copy them to a new location
find . -name "*sample123*" -exec cp {} sample123_analysis/ \;
```

### Workflow 5: Find Incomplete Analyses

```bash
# Find directories with BAM files but no BAI index
find . -name "*.bam" ! -exec test -e {}.bai \; -print
```

### Workflow 6: Disk Space Analysis

```bash
# Find what's taking up space
find . -type f -size +100M -exec du -h {} \; | sort -h

# Files by user
find /shared -type f -user jsmith -size +1G
```

## Combining `grep` and `find`

These commands work great together!

### Find Files Containing Text

```bash
find . -name "*.txt" -exec grep -l "pattern" {} \;
# Or more efficient:
find . -name "*.txt" -exec grep -l "pattern" {} +
```

### Search in Specific File Types

```bash
find . -name "*.gtf" -exec grep "gene_name" {} +
```

### Find and Count

```bash
# Count total occurrences across all files
find . -name "*.fasta" -exec grep -c ">" {} + | awk '{sum+=$1} END {print sum}'
```

## Advanced Examples

### Find Paired-End FASTQ Files

```bash
# Find all R1 files
find . -name "*_R1.fastq.gz"

# Check if R2 exists for each R1
find . -name "*_R1.fastq.gz" | while read r1; do
    r2="${r1/_R1/_R2}"
    [ -f "$r2" ] && echo "Pair found: $r1 and $r2" || echo "Missing R2 for: $r1"
done
```

### Find Files Modified Between Dates

```bash
# Files modified in specific date range
find . -newermt "2024-01-01" ! -newermt "2024-02-01"
```

### Find Duplicate Filenames

```bash
find . -type f -printf "%f\n" | sort | uniq -d
```

## Practice Exercises

### Exercise 1: Basic grep

```bash
# Create test file
echo -e "apple\nbanana\nAPPLE\ngrape" > fruits.txt

# Try different searches
grep "apple" fruits.txt           # Case-sensitive
grep -i "apple" fruits.txt        # Case-insensitive
grep -c "apple" fruits.txt        # Count matches
grep -v "apple" fruits.txt        # Lines without "apple"
```

### Exercise 2: grep with FASTA

If you have a FASTA file:
```bash
# Count sequences
grep -c ">" sequences.fasta

# Find specific sequence
grep -A 1 ">gene1" sequences.fasta

# Find sequences with poly-A
grep "AAAAAAA" sequences.fasta
```

### Exercise 3: Basic find

```bash
# Find all .txt files in home directory
find ~ -name "*.txt" -maxdepth 2

# Find large files
find . -size +10M

# Find recent files
find . -mtime -1
```

### Exercise 4: Combining Commands

```bash
# Find FASTQ files and count lines
find . -name "*.fastq" -exec wc -l {} \;

# Find files containing specific text
find . -name "*.txt" -exec grep -l "TODO" {} +
```

## Quick Reference

### grep Options

| Option | Description | Example |
|--------|-------------|---------|
| `-i` | Case-insensitive | `grep -i "gene" file.txt` |
| `-c` | Count matches | `grep -c ">" seqs.fasta` |
| `-n` | Show line numbers | `grep -n "error" log.txt` |
| `-v` | Invert match | `grep -v "^#" file.txt` |
| `-r` | Recursive search | `grep -r "TODO" scripts/` |
| `-l` | Files with matches | `grep -l "pattern" *.txt` |
| `-w` | Whole word | `grep -w "gene" file.txt` |
| `-A n` | n lines after | `grep -A 1 ">" seq.fasta` |
| `-B n` | n lines before | `grep -B 3 "error" log.txt` |
| `-C n` | n lines context | `grep -C 2 "pattern" file.txt` |

### find Options

| Option | Description | Example |
|--------|-------------|---------|
| `-name` | Find by name | `find . -name "*.bam"` |
| `-iname` | Case-insensitive name | `find . -iname "*.FASTA"` |
| `-type f` | Files only | `find . -type f` |
| `-type d` | Directories only | `find . -type d` |
| `-size` | Find by size | `find . -size +1G` |
| `-mtime` | Modified time | `find . -mtime -7` |
| `-exec` | Execute command | `find . -name "*.tmp" -delete` |

## Tips and Best Practices

1. **Use quotes around patterns** - prevents shell expansion
2. **Test with -print before -delete** - verify what you'll delete
3. **Start with simple patterns** - add complexity gradually
4. **Use -maxdepth** with find to limit search scope
5. **Combine grep -l with find** - for powerful file location
6. **Use grep -c for quick counts** - faster than wc
7. **Remember grep returns exit code** - 0 if found, 1 if not

## Common Mistakes

❌ **Forgetting quotes**
```bash
grep ATCG* file.txt          # Shell expands * before grep sees it
```
✓ **Use quotes**
```bash
grep "ATCG*" file.txt        # Correct
```

❌ **Recursive find without constraints**
```bash
find / -name "*.txt"         # Searches entire system (very slow!)
```
✓ **Limit scope**
```bash
find ~ -name "*.txt"         # Just your home directory
find . -maxdepth 3 -name "*.txt"  # Limit depth
```

❌ **Not testing before deleting**
```bash
find . -name "*.tmp" -delete # Immediately deletes!
```
✓ **Test first**
```bash
find . -name "*.tmp"         # Review list
find . -name "*.tmp" -delete # Then delete
```

## What's Next?

Now that you can search within files and locate files themselves, you're ready to learn how to combine commands for powerful workflows!

**[Next: Pipes and Redirects →](06-pipes-redirects.md)**

---

**Key Takeaway:** `grep` searches inside files, `find` searches for files. Master these two commands and you'll be able to locate any data quickly. They're among the most powerful tools in your Linux toolkit!
