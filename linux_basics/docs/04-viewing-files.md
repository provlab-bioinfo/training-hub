# Viewing File Contents

In bioinformatics, you'll constantly need to examine sequence files, check results, review logs, and inspect data. This tutorial covers the essential commands for viewing file contents without editing them.

## Why View Without Editing?

- **Safety**: You won't accidentally modify important data
- **Speed**: Viewing is much faster than opening an editor
- **Large files**: Some bioinformatics files are too large for regular editors
- **Quick checks**: Peek at data structure before processing

## The `cat` Command - Show Everything

`cat` stands for "concatenate" - it displays the entire contents of a file.

### Basic Usage

```bash
cat filename.txt
```

**Example:**
```bash
cat README.txt
```

Output shows the entire file contents on your screen.

### When to Use `cat`

✓ **Good for:**
- Small files (< 100 lines)
- Quick checks of file contents
- Combining with pipes (we'll cover this later)

✗ **Not good for:**
- Large files (your screen will scroll forever!)
- Files you want to browse interactively

### Useful `cat` Options

```bash
cat -n file.txt            # Show line numbers
cat -b file.txt            # Number non-empty lines only
cat -s file.txt            # Squeeze multiple blank lines into one
```

**Example with line numbers:**
```bash
cat -n sample_list.txt
```
Output:
```
     1  sample1
     2  sample2
     3  sample3
```

### Combining Multiple Files

```bash
cat file1.txt file2.txt file3.txt    # Show all files in sequence
cat *.txt                            # Show all .txt files
```

## The `head` Command - Show the Beginning

`head` displays the first lines of a file. Perfect for checking file format or seeing what your data looks like.

### Basic Usage

```bash
head filename.txt          # Show first 10 lines (default)
```

### Specify Number of Lines

```bash
head -n 20 file.txt        # Show first 20 lines
head -20 file.txt          # Shortcut - same as above
head -n 5 file.txt         # Show first 5 lines
```

### Bioinformatics Examples

**Check FASTA format:**
```bash
head sequences.fasta
```
Output:
```
>seq1 description
ATCGATCGATCGATCG
>seq2 description
GCTAGCTAGCTAGCTA
```

**Check FASTQ format:**
```bash
head -n 4 reads.fastq
```
Output:
```
@SEQ_ID
GATTTGGGGTTCAAAGCAGTATCGATCAAATAGTAAATCCATTTGTTCAACTCACAGTTT
+
!''*((((***+))%%%++)(%%%%).1***-+*''))**55CCF>>>>>>CCCCCCC65
```

**Preview VCF file:**
```bash
head -n 20 variants.vcf
```

**Check CSV/TSV structure:**
```bash
head -n 5 data.csv
```

### Multiple Files

```bash
head file1.txt file2.txt
```

Output shows filename headers:
```
==> file1.txt <==
[first 10 lines]

==> file2.txt <==
[first 10 lines]
```

## The `tail` Command - Show the End

`tail` displays the last lines of a file. Essential for checking job outputs and log files.

### Basic Usage

```bash
tail filename.txt          # Show last 10 lines (default)
```

### Specify Number of Lines

```bash
tail -n 50 file.txt        # Show last 50 lines
tail -50 file.txt          # Shortcut
tail -n 5 file.txt         # Show last 5 lines
```

### Following Files in Real-Time

This is incredibly useful for monitoring running jobs!

```bash
tail -f logfile.txt        # Follow file as it grows
```

The screen will update automatically as new lines are added. Press **Ctrl+C** to stop following.

**Example use cases:**
```bash
# Monitor alignment progress
tail -f bwa_alignment.log

# Watch job output
tail -f job_12345.out

# Monitor error logs
tail -f error.log
```

### Skip Lines from the Beginning

```bash
tail -n +5 file.txt        # Show everything EXCEPT first 4 lines
```

This is useful for skipping headers!

### Bioinformatics Examples

**Check if job finished:**
```bash
tail analysis.log
```

**See final statistics:**
```bash
tail -n 20 alignment_stats.txt
```

**Monitor running analysis:**
```bash
tail -f fastqc.log
```

**Extract data without header:**
```bash
tail -n +2 data.csv        # Skip first line (header)
```

## The `less` Command - Interactive Browsing

`less` is a powerful pager that lets you scroll through files interactively. It's the most versatile viewing tool.

### Basic Usage

```bash
less filename.txt
```

### Navigation Keys

Once in `less`:

| Key | Action |
|-----|--------|
| `Space` or `f` | Forward one page |
| `b` | Back one page |
| `↓` or `Enter` | Forward one line |
| `↑` | Back one line |
| `g` | Go to beginning of file |
| `G` | Go to end of file |
| `q` | Quit |

### Searching in `less`

| Key | Action |
|-----|--------|
| `/pattern` | Search forward for "pattern" |
| `?pattern` | Search backward for "pattern" |
| `n` | Next match |
| `N` | Previous match |

**Example workflow:**
```bash
less large_file.txt
# Press / then type "ATCG" and Enter
# Press n to find next occurrence
# Press q to quit
```

### Useful `less` Options

```bash
less -N file.txt           # Show line numbers
less -S file.txt           # Don't wrap long lines (use arrow keys)
less -i file.txt           # Case-insensitive search
less +F file.txt           # Start in follow mode (like tail -f)
```

### Why Use `less` Over Others?

✓ **Doesn't load entire file into memory** - works with huge files
✓ **Interactive searching** - find what you need quickly
✓ **Navigate freely** - forward and backward
✓ **Follow mode** - monitor growing files

### Bioinformatics Examples

**Browse large FASTA file:**
```bash
less genome.fasta
# Search for specific gene: /gene_name
# Jump to end to see file size: G
```

**Check alignment file:**
```bash
less -S alignment.sam      # -S prevents line wrapping
```

**Monitor log file:**
```bash
less +F analysis.log       # Follow mode, Ctrl+C to stop following
```

## The `more` Command - Basic Pager

`more` is an older, simpler pager. Similar to `less` but with fewer features.

```bash
more filename.txt
```

**Navigation:**
- `Space` - next page
- `Enter` - next line  
- `q` - quit

**Note:** `less` is generally preferred because it's more powerful. Think of it as: "less is more than more"!

## The `wc` Command - Count Lines, Words, Characters

`wc` stands for "word count" - it counts lines, words, and characters in a file.

### Basic Usage

```bash
wc filename.txt
```

Output:
```
  100  500  3000 filename.txt
```
This means: 100 lines, 500 words, 3000 characters

### Specific Counts

```bash
wc -l file.txt             # Count lines only
wc -w file.txt             # Count words only
wc -c file.txt             # Count bytes/characters only
wc -m file.txt             # Count characters (multibyte aware)
```

### Bioinformatics Examples

**Count sequences in FASTA:**
```bash
grep -c ">" sequences.fasta
# Or
wc -l sequences.fasta      # Then divide by 2 (header + sequence)
```

**Count reads in FASTQ:**
```bash
wc -l reads.fastq          # Divide result by 4
```

For example:
```bash
wc -l reads.fastq
# Output: 4000000 reads.fastq
# This means 4000000 / 4 = 1,000,000 reads
```

**Count samples:**
```bash
wc -l sample_list.txt
```

**Count variants:**
```bash
grep -v "^#" variants.vcf | wc -l    # Skip header lines starting with #
```

### Multiple Files

```bash
wc -l *.txt                # Count lines in all .txt files
```

Output shows counts for each file plus a total:
```
  100 file1.txt
  200 file2.txt
  300 file3.txt
  600 total
```

## Viewing Compressed Files

Many bioinformatics files are compressed (.gz). You can view them without decompressing!

### `zcat` - Cat for Compressed Files

```bash
zcat file.txt.gz           # Show entire compressed file
zcat file.txt.gz | head    # Show first 10 lines
```

### `zless` - Less for Compressed Files

```bash
zless file.txt.gz          # Browse compressed file interactively
```

All the same `less` commands work!

### `zgrep` - Grep for Compressed Files

```bash
zgrep "pattern" file.txt.gz    # Search in compressed file
```

### `zmore` - More for Compressed Files

```bash
zmore file.txt.gz
```

### Bioinformatics Examples

**View compressed FASTQ:**
```bash
zcat reads.fastq.gz | head -n 4    # First read
```

**Count reads in compressed FASTQ:**
```bash
zcat reads.fastq.gz | wc -l        # Then divide by 4
```

**Search in compressed file:**
```bash
zgrep "ATCGATCG" sequences.fasta.gz
```

**Browse large compressed file:**
```bash
zless genome.fasta.gz
```

## Comparing Files Quickly

### Show File Type

```bash
file filename              # Identify file type
```

Example:
```bash
file sequences.fasta
# Output: sequences.fasta: ASCII text
```

```bash
file reads.fastq.gz
# Output: reads.fastq.gz: gzip compressed data
```

### Show First and Last Lines

Combine `head` and `tail`:
```bash
echo "=== First 5 lines ===" && head -n 5 file.txt && echo "=== Last 5 lines ===" && tail -n 5 file.txt
```

## Practical Workflows

### Workflow 1: Quick Data Check

```bash
# Check what type of file
file data.txt

# See structure
head data.txt

# Count records
wc -l data.txt

# Look for specific pattern
grep "sample" data.txt | head
```

### Workflow 2: FASTQ Quality Check

```bash
# View first read
head -n 4 reads.fastq

# Count total reads
echo "Total reads: $(($(wc -l < reads.fastq) / 4))"

# Check read length (second line of first read)
head -n 2 reads.fastq | tail -n 1 | wc -c

# Sample random reads
head -n 400 reads.fastq    # First 100 reads
```

### Workflow 3: Monitoring Running Job

```bash
# Start monitoring log
tail -f analysis.log

# In another terminal, check progress
grep "processed" analysis.log | tail -n 1

# Check for errors
grep -i "error" analysis.log
```

### Workflow 4: FASTA File Inspection

```bash
# Count sequences
grep -c ">" sequences.fasta

# View first few sequences
head -n 10 sequences.fasta

# Find longest sequence ID
grep ">" sequences.fasta | head

# Search for specific sequence
less sequences.fasta
# Then press / and type sequence name
```

## Practice Exercises

### Exercise 1: Basic Viewing

```bash
# Create a test file
echo -e "Line 1\nLine 2\nLine 3\nLine 4\nLine 5" > test.txt

# Try different viewing commands
cat test.txt
head -n 3 test.txt
tail -n 2 test.txt
less test.txt              # Press q to quit
wc -l test.txt
```

### Exercise 2: Working with Real Data

```bash
# If you have a FASTA file
head sequences.fasta       # Check format
wc -l sequences.fasta      # Count total lines
grep -c ">" sequences.fasta # Count sequences

# Browse interactively
less sequences.fasta
# Try searching for "gene" by pressing / then typing gene
```

### Exercise 3: Monitoring Files

```bash
# Create a growing file simulation
for i in {1..100}; do echo "Line $i" >> growing.txt; sleep 1; done &

# Monitor it in real-time
tail -f growing.txt        # Press Ctrl+C to stop

# Or use less
less +F growing.txt        # Press Ctrl+C then q to quit
```

## Quick Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `cat` | Show entire file | `cat file.txt` |
| `head` | Show first lines | `head -n 20 file.txt` |
| `tail` | Show last lines | `tail -n 50 file.txt` |
| `tail -f` | Follow growing file | `tail -f log.txt` |
| `less` | Browse interactively | `less file.txt` |
| `more` | Simple pager | `more file.txt` |
| `wc -l` | Count lines | `wc -l file.txt` |
| `zcat` | View compressed file | `zcat file.gz \| head` |
| `zless` | Browse compressed file | `zless file.gz` |

## Tips and Best Practices

1. **Use `less` for large files** - it's safer and more efficient
2. **Use `head` for quick peeks** - faster than opening an editor
3. **Use `tail -f` for monitoring** - watch jobs in real-time
4. **Combine with pipes** - `cat file.txt | grep pattern`
5. **Work with compressed files directly** - no need to decompress first

## Common Mistakes

❌ **Using `cat` on huge files**
```bash
cat 100GB_file.txt         # Your terminal will freeze!
```
✓ **Use appropriate tools**
```bash
less 100GB_file.txt        # Safe - doesn't load all into memory
head 100GB_file.txt        # Just see the beginning
```

❌ **Forgetting to quit `less`**
- If you're stuck in a viewing command, press `q` to quit

❌ **Not using compressed viewing tools**
```bash
gunzip file.gz             # Wastes time and space
cat file                   # Then view
```
✓ **View directly**
```bash
zless file.gz              # View without decompressing
```

## What's Next?

Now that you can view files effectively, you're ready to learn how to search for specific content!

**[Next: Searching and Finding →](05-searching.md)**

---

**Key Takeaway:** Different viewing commands for different needs. Use `head` for quick checks, `less` for browsing, `tail -f` for monitoring, and `wc` for counting. Master these and you'll efficiently inspect any bioinformatics data!
