
# Quick Start Guide

The **top 20 commands** you'll use 80% of the time in bioinformatics. Bookmark this page!

## 🔐 Connecting

```bash
# Use PuTTY to connect to: your_server_address
# Username: your_username
# Password: [you won't see it as you type]
```

## 📍 Where Am I?

```bash
pwd                    # Print current directory path
whoami                 # Show your username
```

## 🗂️ Looking Around

```bash
ls                     # List files
ls -lh                 # List with details and human-readable sizes
ls -lth                # List sorted by time, newest first
```

## 🚶 Moving Around

```bash
cd directory_name      # Go into a directory
cd ..                  # Go up one level
cd ~                   # Go to your home directory
cd -                   # Go back to previous directory
```

## 📁 File Operations

```bash
mkdir new_folder       # Create directory
cp file1.txt file2.txt # Copy file
mv old.txt new.txt     # Rename or move file
rm file.txt            # Delete file (careful!)
```

## 👀 Viewing Files

```bash
head file.txt          # Show first 10 lines
tail file.txt          # Show last 10 lines
less file.txt          # Browse file (press 'q' to quit)
wc -l file.txt         # Count lines
```

## 🔍 Searching

```bash
grep "pattern" file.txt         # Search for text in file
grep -c ">" sequences.fasta     # Count sequences (count > symbols)
find . -name "*.fastq"          # Find all FASTQ files
```

## 🔗 Power Combinations

```bash
command1 | command2             # Pipe output of command1 to command2
command > output.txt            # Save output to file
grep ">" seqs.fasta | wc -l     # Count sequences in FASTA
```

## 📦 Compressed Files

```bash
gzip file.txt                   # Compress file
gunzip file.txt.gz              # Decompress file
zcat file.gz | head             # View compressed file
```

## ⚡ Essential Shortcuts

- **Tab** - Auto-complete filenames/commands
- **Ctrl+C** - Stop current command
- **Ctrl+L** - Clear screen
- **Ctrl+R** - Search command history
- **↑/↓ arrows** - Navigate command history

## 🆘 Getting Help

```bash
man command            # Manual for command
command --help         # Quick help
```

## 💡 Pro Tips

1. **Never type full filenames** - use Tab completion
2. **Use wildcards**: `*.fastq` matches all FASTQ files
3. **Be careful with `rm`** - there's no undo!
4. **Keep a terminal cheatsheet** nearby while learning
5. **Practice daily** - even 10 minutes helps

## 🧬 Common Bioinformatics Tasks

```bash
# Count sequences in FASTA
grep -c ">" sequences.fasta

# Count reads in FASTQ (divide by 4)
wc -l reads.fastq

# View first sequence in FASTA
head -n 2 sequences.fasta

# Find all BAM files in current directory and subdirectories
find . -name "*.bam"

# Extract sequence IDs from FASTA
grep ">" sequences.fasta > sequence_ids.txt

# Check file size
ls -lh bigfile.bam
```

---

**Next Steps:** Ready to dive deeper? Continue with the [full tutorial](docs/01-getting-started.md).

---
