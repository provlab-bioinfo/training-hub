# Tips and Tricks

This tutorial covers keyboard shortcuts, efficiency hacks, and productivity tips that will make you a command line power user. These techniques will save you hours of work!

## Essential Keyboard Shortcuts

### Command Line Editing

**Navigation:**
```
Ctrl+A          Go to beginning of line
Ctrl+E          Go to end of line
Ctrl+B          Move backward one character (same as ←)
Ctrl+F          Move forward one character (same as →)
Alt+B           Move backward one word
Alt+F           Move forward one word
```

**Editing:**
```
Ctrl+U          Delete from cursor to beginning of line
Ctrl+K          Delete from cursor to end of line
Ctrl+W          Delete word before cursor
Alt+D           Delete word after cursor
Ctrl+Y          Paste (yank) previously deleted text
Ctrl+T          Transpose (swap) two characters
Alt+T           Transpose two words
```

**History:**
```
Ctrl+R          Search command history (type to search, Enter to run)
Ctrl+G          Exit history search
Ctrl+P          Previous command (same as ↑)
Ctrl+N          Next command (same as ↓)
!!              Repeat last command
!$              Last argument of previous command
!^              First argument of previous command
!*              All arguments of previous command
```

**Control:**
```
Ctrl+C          Cancel current command
Ctrl+D          Exit shell (or delete character)
Ctrl+L          Clear screen (same as 'clear' command)
Ctrl+Z          Suspend current process (sends to background)
Ctrl+S          Pause output (XOFF)
Ctrl+Q          Resume output (XON)
```

### Practical Examples

**Quick fixes:**
```bash
# Made a typo at the beginning?
cd /hmoe/username/project
# Press Ctrl+A, fix typo
cd /home/username/project

# Want to add something to the end?
ls -l /long/path/to/directory
# Press Ctrl+E, add more
ls -l /long/path/to/directory | grep fastq
```

**Reuse previous arguments:**
```bash
cat very_long_filename.txt
# Now edit it - reuse filename
vim !$
# Expands to: vim very_long_filename.txt

# Run multiple commands on same file
chmod +x script.sh
./!$           # Runs ./script.sh
```

## Tab Completion

Tab completion is the #1 time-saver. Master it!

### Basic Tab Completion

**Complete commands:**
```bash
fas[Tab]           # Completes to 'fastqc' or shows options
```

**Complete filenames:**
```bash
cd /home/use[Tab]  # Completes to username
ls seq[Tab]        # Completes to sequences.fasta
```

**See all options:**
```bash
cd pro[Tab][Tab]   # Shows: project1/ project2/ protein_data/
```

### Advanced Tab Usage

**Complete with wildcards:**
```bash
ls *.fa[Tab]       # Completes all .fasta files
cat sample[Tab]    # Shows all files starting with 'sample'
```

**Complete paths:**
```bash
cd /ho[Tab]/use[Tab]/pro[Tab]
# Completes: /home/username/projects/
```

**Complete variables:**
```bash
echo $HO[Tab]      # Completes to $HOME
```

**Complete after commands:**
```bash
grep pattern [Tab][Tab]  # Shows available files
```

### Tab Completion Tips

1. **Never type full filenames** - always use Tab
2. **Press Tab twice** to see all possibilities
3. **Use it for commands** you partially remember
4. **Works with paths** - tab through directories
5. **Case sensitive** - start with correct case

## Command History

### Searching History

**Interactive search:**
```bash
Ctrl+R             # Start reverse search
# Type search term
# Press Ctrl+R again for next match
# Press Enter to execute
# Press Ctrl+G to cancel
```

**View history:**
```bash
history            # Show command history
history 20         # Show last 20 commands
history | grep fastqc  # Search history
```

**Execute from history:**
```bash
!123               # Run command #123 from history
!fa                # Run most recent command starting with 'fa'
!?pattern          # Run most recent command containing 'pattern'
!!                 # Run previous command
sudo !!            # Run previous command with sudo
```

### History Substitution

**Reuse arguments:**
```bash
ls very_long_filename.txt
cat !$             # Uses last argument: very_long_filename.txt

cp file1.txt file2.txt
vim !^             # Uses first argument: file1.txt

echo one two three
echo !*            # Uses all arguments: one two three
```

**Quick fixes:**
```bash
# Fix typo in previous command
cat flie.txt       # Oops, typo!
^flie^file         # Replaces 'flie' with 'file' and reruns
# Executes: cat file.txt
```

**Repeat with modification:**
```bash
ls *.fastq
!!:s/ls/wc -l/     # Changes 'ls' to 'wc -l'
# Executes: wc -l *.fastq
```

### History Configuration

**Avoid duplicate entries:**
```bash
export HISTCONTROL=ignoredups:erasedups
```

**Increase history size:**
```bash
export HISTSIZE=10000
export HISTFILESIZE=10000
```

**Timestamp history:**
```bash
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
history
```

**Add to ~/.bashrc for permanence:**
```bash
echo 'export HISTSIZE=10000' >> ~/.bashrc
echo 'export HISTCONTROL=ignoredups' >> ~/.bashrc
```

## Aliases - Custom Shortcuts

Aliases create shortcuts for frequently used commands.

### Creating Aliases

**Temporary (current session only):**
```bash
alias ll='ls -lh'
alias la='ls -lha'
alias ..='cd ..'
alias ...='cd ../..'
```

**Permanent (add to ~/.bashrc):**
```bash
echo "alias ll='ls -lh'" >> ~/.bashrc
source ~/.bashrc       # Reload configuration
```

### Useful Bioinformatics Aliases

```bash
# Quick navigation
alias data='cd ~/data'
alias projects='cd ~/projects'
alias scripts='cd ~/scripts'

# Common commands
alias ll='ls -lh'
alias la='ls -lha'
alias lt='ls -lth'           # Sort by time
alias count='wc -l'
alias h='history'
alias grep='grep --color=auto'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Bioinformatics shortcuts
alias countseq='grep -c ">"'
alias countreads='wc -l | awk "{print \$1/4}"'
alias fqc='fastqc -o fastqc_results'

# System monitoring
alias usage='du -sh *'
alias meminfo='free -h'
alias processes='ps aux | grep $USER'

# Git shortcuts (if you use version control)
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
```

### View and Remove Aliases

```bash
alias              # List all aliases
unalias ll         # Remove alias
\ll                # Run command without alias (bypass)
```

## Wildcards and Brace Expansion

### Wildcard Patterns

**Asterisk (*):**
```bash
ls *.fastq         # All FASTQ files
ls sample*         # Files starting with 'sample'
ls *_R1.fastq      # All R1 files
rm *.tmp           # Delete all .tmp files
```

**Question mark (?):**
```bash
ls sample?.txt     # sample1.txt, sample2.txt (single char)
ls file??.txt      # file01.txt, file02.txt (two chars)
```

**Brackets []:**
```bash
ls file[123].txt   # file1.txt, file2.txt, file3.txt
ls sample[A-Z].txt # sampleA.txt through sampleZ.txt
ls chr[1-9].fa     # chr1.fa through chr9.fa
ls *[!0-9].txt     # Files NOT ending with digit.txt
```

### Brace Expansion

**Create multiple files:**
```bash
touch file{1,2,3}.txt
# Creates: file1.txt file2.txt file3.txt

mkdir {raw,processed,results}
# Creates: raw/ processed/ results/

touch sample_{A,B,C}_{R1,R2}.fastq
# Creates: sample_A_R1.fastq, sample_A_R2.fastq, sample_B_R1.fastq, etc.
```

**Sequences:**
```bash
echo {1..10}       # 1 2 3 4 5 6 7 8 9 10
echo {01..10}      # 01 02 03 04 05 06 07 08 09 10
echo {a..z}        # a b c d ... z
echo {A..F}        # A B C D E F

# Create numbered files
touch file{001..100}.txt

# Create directory structure
mkdir -p project/{data,scripts,results}/{sample1,sample2}
```

**Combine with commands:**
```bash
# Backup multiple files at once
cp file.txt{,.bak}     # Same as: cp file.txt file.txt.bak

# Create date-stamped directories
mkdir results_{2024..2025}_{01..12}

# Process ranges
for i in {1..10}; do echo "Processing sample $i"; done
```

## Command Substitution

Execute a command and use its output in another command.

### Syntax

```bash
$(command)         # Preferred
`command`          # Old style (backticks)
```

### Examples

**Embed command output:**
```bash
echo "Today is $(date)"
echo "I am in $(pwd)"
echo "Found $(ls | wc -l) files"
```

**Use in filenames:**
```bash
# Create timestamped files
cp results.txt results_$(date +%Y%m%d).txt

# Save with date
tar -czf backup_$(date +%Y%m%d_%H%M%S).tar.gz data/
```

**Use in loops:**
```bash
# Process files from a list
for file in $(cat file_list.txt); do
    echo "Processing $file"
done

# Count sequences in all FASTA files
for file in $(find . -name "*.fasta"); do
    echo "$file: $(grep -c ">" $file) sequences"
done
```

**Calculate:**
```bash
# Count reads
reads=$(zcat reads.fastq.gz | wc -l)
echo "Total reads: $((reads / 4))"

# Check if enough space
free_space=$(df -h . | tail -1 | awk '{print $4}')
echo "Free space: $free_space"
```

## Finding Files Quickly

### The `locate` Command

`locate` is faster than `find` for finding files (uses database).

```bash
locate filename          # Find file anywhere
locate "*.fastq"         # Find all FASTQ files
locate -i FILENAME       # Case-insensitive
locate -c filename       # Count matches only
```

**Update database:**
```bash
updatedb             # Usually requires sudo
```

### Smart `find` Usage

**Quick finds:**
```bash
# Find in current directory only
find . -maxdepth 1 -name "*.txt"

# Find recently modified
find . -mtime -1     # Last 24 hours
find . -mmin -30     # Last 30 minutes

# Find by size efficiently
find . -size +100M -name "*.bam"
```

## One-Liners for Bioinformatics

### FASTA Operations

**Count sequences:**
```bash
grep -c ">" sequences.fasta
```

**Count unique sequences:**
```bash
grep -v ">" sequences.fasta | sort -u | wc -l
```

**Get sequence lengths:**
```bash
awk '/^>/ {if (seq) print length(seq); seq=""} !/^>/ {seq=seq $0} END {print length(seq)}' seqs.fasta
```

**Extract specific sequence:**
```bash
awk -v seq="seq1" '/^>/ {p=($0~seq)} p' sequences.fasta
```

**Convert to single-line format:**
```bash
awk '/^>/ {printf("\n%s\n",$0);next; } {printf("%s",$0);}END{printf("\n");}' seqs.fasta | tail -n +2
```

### FASTQ Operations

**Count reads:**
```bash
echo $(($(wc -l < reads.fastq) / 4))
# Or for compressed:
echo $(($(zcat reads.fastq.gz | wc -l) / 4))
```

**Extract first N reads:**
```bash
head -n 400 reads.fastq > first_100_reads.fastq  # 100 reads = 400 lines
```

**Convert FASTQ to FASTA:**
```bash
awk 'NR%4==1 {print ">"substr($0,2)} NR%4==2' reads.fastq > reads.fasta
```

**Check read length distribution:**
```bash
awk 'NR%4==2 {print length}' reads.fastq | sort -n | uniq -c
```

### VCF Operations

**Count variants:**
```bash
grep -v "^#" variants.vcf | wc -l
```

**Extract high-quality variants:**
```bash
awk '$1 !~ /^#/ && $6 > 30' variants.vcf
```

**Count variants by chromosome:**
```bash
grep -v "^#" variants.vcf | cut -f1 | sort | uniq -c
```

**Extract SNPs only:**
```bash
awk '$1 !~ /^#/ && length($4)==1 && length($5)==1' variants.vcf
```

### File Operations

**Rename multiple files:**
```bash
# Add prefix
for file in *.txt; do mv "$file" "prefix_$file"; done

# Change extension
for file in *.txt; do mv "$file" "${file%.txt}.tsv"; done

# Remove pattern
for file in *_old.txt; do mv "$file" "${file/_old/}"; done
```

**Compare two lists:**
```bash
# Find common items
comm -12 <(sort list1.txt) <(sort list2.txt)

# Find unique to first list
comm -23 <(sort list1.txt) <(sort list2.txt)
```

## Shell Variables and Environment

### Using Variables

**Set variables:**
```bash
SAMPLE="sample1"
THREADS=8
REF="/path/to/reference.fa"
```

**Use variables:**
```bash
echo $SAMPLE
bwa mem -t $THREADS $REF ${SAMPLE}.fastq > ${SAMPLE}.sam
```

**Export for sub-processes:**
```bash
export THREADS=8           # Available to scripts you run
```

### Environment Variables

**Common variables:**
```bash
echo $HOME             # Your home directory
echo $USER             # Your username
echo $PATH             # Command search path
echo $PWD              # Current directory
echo $OLDPWD           # Previous directory
```

**Useful in scripts:**
```bash
#!/bin/bash
OUTPUT_DIR="$HOME/results"
mkdir -p $OUTPUT_DIR
echo "Results saved to $OUTPUT_DIR"
```

## Efficient File Viewing

### Quick Checks

**See first and last lines:**
```bash
(head -5; tail -5) < file.txt
```

**Sample random lines:**
```bash
shuf -n 10 file.txt       # 10 random lines
```

**Skip header and view:**
```bash
tail -n +2 file.txt | head
```

**View specific columns only:**
```bash
cut -f1,3 file.tsv | less -S   # -S prevents line wrapping
```

## Time-Saving Tips

### 1. Use `time` to Benchmark

```bash
time long_command          # Shows how long it took
time sort large_file.txt
```

### 2. Parallel Processing (GNU Parallel)

If installed:
```bash
parallel "fastqc {} -o results/" ::: *.fastq
parallel "samtools index {}" ::: *.bam
```

### 3. Quick Backups

```bash
cp file.txt{,.bak}                    # Creates file.txt.bak
cp -r project{,_backup}               # Backup directory
```

### 4. Multi-line Commands

```bash
# Use \ to continue on next line
grep "pattern" \
     file1.txt \
     file2.txt \
     file3.txt

# Or use $( ) for readability
result=$(
    grep ">" sequences.fasta |
    wc -l
)
echo "Sequences: $result"
```

### 5. Watch Command Output

```bash
watch -n 60 "ls -lh results/"         # Update every 60 seconds
watch -n 5 "tail analysis.log"        # Monitor log file
watch "ps aux | grep username"        # Monitor processes
```

### 6. Quick Calculator

```bash
echo $((5 + 3))              # Basic math
echo $((100 * 3 / 2))        # More complex
bc <<< "scale=2; 10/3"       # Decimal division
```

### 7. Multiple Terminal Sessions

**Using screen or tmux is essential for:**
- Long-running analyses
- Multiple tasks simultaneously
- Surviving disconnections

```bash
# Start named session
screen -S analysis

# Detach: Ctrl+A, then D
# Reattach: screen -r analysis
```

## Productivity Hacks

### 1. Directory Stack

```bash
pushd /path/to/dir     # Save current dir and go to new
popd                   # Return to saved dir
dirs                   # Show directory stack
```

### 2. Last Modified File

```bash
ls -t | head -1        # Most recently modified
```

### 3. Command Line Calculation

```bash
# For reads calculation
reads=$(($(wc -l < file.fastq) / 4))
echo $reads
```

### 4. Quick File Comparison

```bash
diff <(sort file1.txt) <(sort file2.txt)
```

### 5. Monitor Disk Usage

```bash
# Watch a directory grow
watch -n 60 'du -sh results/'

# Find what's using space
du -h . | sort -h | tail -20
```

## Customizing Your Prompt

Make your prompt informative:

**Add to ~/.bashrc:**
```bash
# Show username, hostname, and current directory
export PS1='\u@\h:\w\$ '

# Add color
export PS1='\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ '

# Show git branch (if in git repo)
parse_git_branch() {
    git branch 2>/dev/null | grep '*' | sed 's/* //'
}
export PS1='\u@\h:\w$(parse_git_branch)\$ '
```

## Practice Exercises

### Exercise 1: History and Shortcuts

```bash
# List files
ls -l

# Rerun with different option (use !!)
!! | grep fastq

# Use last argument
cat very_long_filename.txt
vim !$
```

### Exercise 2: Create Aliases

```bash
# Create useful aliases
alias ll='ls -lh'
alias count='grep -c ">"'

# Test them
ll
count sequences.fasta
```

### Exercise 3: Brace Expansion

```bash
# Create project structure
mkdir -p project/{data,scripts,results}_{2024,2025}

# Create numbered samples
touch sample_{01..10}_R{1,2}.fastq

# List what you created
ls -R
```

### Exercise 4: Command Substitution

```bash
# Create dated backup
mkdir backup_$(date +%Y%m%d)

# Count and report
echo "Found $(ls *.txt | wc -l) text files"
```

**Key Takeaway:** Master keyboard shortcuts (especially Ctrl+R and Tab), use aliases for frequent commands, leverage history, and create one-liners for common tasks. These efficiency tips will save you hours every week!
