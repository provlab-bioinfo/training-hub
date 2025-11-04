# Linux Command Cheatsheet for Bioinformatics

Quick reference for essential commands. Print this out and keep it near your desk!

## Navigation

| Command | Description | Example |
|---------|-------------|---------|
| `pwd` | Print current directory | `pwd` |
| `ls` | List files | `ls -lh` |
| `cd` | Change directory | `cd /path/to/dir` |
| `cd ~` | Go to home directory | `cd ~` |
| `cd ..` | Go up one level | `cd ..` |
| `cd -` | Go to previous directory | `cd -` |

## File Operations

| Command | Description | Example |
|---------|-------------|---------|
| `mkdir` | Create directory | `mkdir my_project` |
| `touch` | Create empty file | `touch file.txt` |
| `cp` | Copy file | `cp file1.txt file2.txt` |
| `cp -r` | Copy directory | `cp -r dir1 dir2` |
| `mv` | Move/rename | `mv old.txt new.txt` |
| `rm` | Delete file | `rm file.txt` |
| `rm -r` | Delete directory | `rm -r directory` |
| `rm -i` | Delete with confirmation | `rm -i file.txt` |

## Viewing Files

| Command | Description | Example |
|---------|-------------|---------|
| `cat` | Show entire file | `cat file.txt` |
| `head` | Show first lines | `head -n 20 file.txt` |
| `tail` | Show last lines | `tail -n 50 file.txt` |
| `less` | Browse file (q to quit) | `less large_file.txt` |
| `wc -l` | Count lines | `wc -l file.txt` |

## Searching

| Command | Description | Example |
|---------|-------------|---------|
| `grep` | Search in file | `grep "pattern" file.txt` |
| `grep -i` | Case-insensitive search | `grep -i "gene" file.txt` |
| `grep -c` | Count matches | `grep -c ">" seqs.fasta` |
| `grep -v` | Invert match | `grep -v "scaffold" file.txt` |
| `find` | Find files | `find . -name "*.fastq"` |

## Pipes & Redirects

| Symbol | Description | Example |
|--------|-------------|---------|
| `\|` | Pipe output to next command | `cat file \| grep "text"` |
| `>` | Redirect output (overwrite) | `ls > files.txt` |
| `>>` | Append output | `echo "log" >> log.txt` |
| `<` | Input from file | `sort < input.txt` |

## Compression

| Command | Description | Example |
|---------|-------------|---------|
| `gzip` | Compress file | `gzip file.txt` |
| `gunzip` | Decompress | `gunzip file.txt.gz` |
| `tar -czf` | Create compressed archive | `tar -czf archive.tar.gz dir/` |
| `tar -xzf` | Extract archive | `tar -xzf archive.tar.gz` |
| `zcat` | View compressed file | `zcat file.gz \| head` |
| `zgrep` | Search compressed file | `zgrep "pattern" file.gz` |

## Text Processing

| Command | Description | Example |
|---------|-------------|---------|
| `cut` | Extract columns | `cut -f1,3 data.tsv` |
| `sort` | Sort lines | `sort -k2 file.txt` |
| `uniq` | Remove duplicates | `sort file \| uniq` |
| `wc` | Count lines/words | `wc -l file.txt` |
| `tr` | Translate characters | `tr 'a-z' 'A-Z'` |

## Permissions

| Command | Description | Example |
|---------|-------------|---------|
| `chmod +x` | Make executable | `chmod +x script.sh` |
| `chmod 755` | rwx for owner, rx for others | `chmod 755 script.sh` |
| `chmod 644` | rw for owner, r for others | `chmod 644 file.txt` |

## Process Management

| Command | Description | Example |
|---------|-------------|---------|
| `command &` | Run in background | `long_job.sh &` |
| `nohup` | Keep running after logout | `nohup job.sh &` |
| `jobs` | List background jobs | `jobs` |
| `ps aux` | Show all processes | `ps aux \| grep username` |
| `top` | Monitor processes | `top` |
| `kill` | Stop process | `kill 12345` |
| `Ctrl+C` | Stop current command | |
| `Ctrl+Z` | Pause current command | |

## Wildcards

| Symbol | Meaning | Example |
|--------|---------|---------|
| `*` | Any characters | `*.fastq` |
| `?` | Single character | `file?.txt` |
| `[abc]` | Any of a, b, or c | `file[123].txt` |
| `{A,B}` | A or B | `sample_{1,2}.txt` |

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Tab` | Auto-complete |
| `Tab Tab` | Show all options |
| `Ctrl+C` | Cancel command |
| `Ctrl+L` | Clear screen |
| `Ctrl+A` | Go to start of line |
| `Ctrl+E` | Go to end of line |
| `Ctrl+U` | Delete to start |
| `Ctrl+K` | Delete to end |
| `Ctrl+R` | Search history |
| `↑/↓` | Previous/next command |

## Bioinformatics Specifics

### FASTA Files
```bash
# Count sequences
grep -c ">" sequences.fasta

# Extract sequence IDs
grep ">" sequences.fasta

# Get first sequence
head -n 2 sequences.fasta

# Search for sequence containing motif
grep -A 1 "ATCGATCG" sequences.fasta
```

### FASTQ Files
```bash
# Count reads (divide total lines by 4)
echo $(cat file.fastq | wc -l)/4 | bc

# Or for compressed
echo $(zcat file.fastq.gz | wc -l)/4 | bc

# View first read
head -n 4 file.fastq

# Check quality encoding
head -n 400 file.fastq | awk 'NR%4==0'
```

### File Size Checks
```bash
# Check size of files
ls -lh *.bam

# Find large files (>1GB)
find . -size +1G

# Disk usage of directory
du -sh directory_name

# Available disk space
df -h
```

### Common Pipelines
```bash
# Count unique sequences
grep -v ">" seqs.fasta | sort | uniq | wc -l

# Extract column from TSV and count unique
cut -f3 data.tsv | sort | uniq -c

# Find files modified today
find . -name "*.bam" -mtime 0

# Monitor log file in real-time
tail -f logfile.txt
```

## Getting Help

```bash
man command              # Full manual
command --help          # Quick help
info command            # Detailed info
```

## PuTTY Specific

- **Copy:** Highlight text (auto-copies)
- **Paste:** Right-click
- **Save session:** Session → Save
- **Scroll back:** Use scrollbar or Shift+PgUp/PgDn

---

💡 **Remember:** Practice makes perfect! Keep this cheatsheet handy and refer to it often.

