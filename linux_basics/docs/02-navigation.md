# Navigating the File System

Understanding how to move around the Linux file system is fundamental to working efficiently. Think of it like learning to navigate a building - once you know how, you can find anything!

## Understanding the Linux File System

The Linux file system is organized like an upside-down tree:

```
/                          (root - top of the tree)
├── home/                  (user home directories)
│   ├── jsmith/           (your home directory)
│   │   ├── Documents/
│   │   ├── projects/
│   │   └── data/
│   └── mjones/           (another user)
├── usr/                   (programs and applications)
├── etc/                   (configuration files)
├── tmp/                   (temporary files)
└── var/                   (variable data, logs)
```

### Key Concepts

**Root Directory (`/`)**: The very top of the file system. Everything lives under root.

**Home Directory (`~`)**: Your personal folder, usually `/home/username`. This is where you'll do most of your work.

**Current Directory (`.`)**: Wherever you are right now.

**Parent Directory (`..`)**: One level up from where you are.

## The `ls` Command - Looking Around

Before moving somewhere, it helps to see what's available.

### Basic Usage

```bash
ls
```

Shows files and directories in your current location.

**Example output:**
```
Documents  Downloads  projects  sequences.fasta  README.txt
```

### Useful Options

```bash
ls -l                      # Long format - shows details
```

**Example output:**
```
drwxr-xr-x 2 jsmith bioinf   4096 Nov  4 10:30 Documents
-rw-r--r-- 1 jsmith bioinf  12345 Nov  3 14:22 sequences.fasta
```

Breaking down the long format:
- `d` = directory, `-` = file
- `rwxr-xr-x` = permissions (we'll cover this later)
- `jsmith` = owner
- `4096` = size in bytes
- `Nov 4 10:30` = last modified date/time
- `Documents` = name

```bash
ls -lh                     # Human-readable file sizes
```

**Example output:**
```
drwxr-xr-x 2 jsmith bioinf  4.0K Nov  4 10:30 Documents
-rw-r--r-- 1 jsmith bioinf   12K Nov  3 14:22 sequences.fasta
-rw-r--r-- 1 jsmith bioinf  2.3G Nov  2 09:15 genome.fasta
```

Now sizes show as KB, MB, GB!

```bash
ls -a                      # Show all files, including hidden
```

Hidden files start with `.` (like `.bashrc`, `.ssh`)

```bash
ls -lth                    # Long format, human-readable, sorted by time
```

This is particularly useful for finding your most recent files!

```bash
ls -R                      # Recursive - show subdirectories too
```

### Listing Specific Directories

You don't have to be in a directory to list it:

```bash
ls /home/jsmith/Documents
ls ~/projects
ls ..
```

## The `cd` Command - Moving Around

`cd` stands for "change directory" - this is how you move through the file system.

### Basic Navigation

```bash
cd Documents               # Go into Documents folder
```

```bash
cd /home/jsmith/projects   # Go to specific full path
```

```bash
cd ~                       # Go to your home directory
```

```bash
cd                         # Also goes to home (shortcut!)
```

```bash
cd ..                      # Go up one level
```

```bash
cd ../..                   # Go up two levels
```

```bash
cd -                       # Go back to previous directory
```

This last one is super useful! Like "back" button in a browser.

### Practical Examples

Let's say you're in `/home/jsmith` and want to navigate to a project:

```bash
pwd                        # Check where you are
# Output: /home/jsmith

cd projects                # Go into projects
pwd                        # Check again
# Output: /home/jsmith/projects

cd rna_seq_analysis        # Go deeper
pwd
# Output: /home/jsmith/projects/rna_seq_analysis

cd                         # Quick way back home
pwd
# Output: /home/jsmith
```

### Absolute vs Relative Paths

**Absolute path**: Starts from root (`/`)
```bash
cd /home/jsmith/projects/rna_seq
```
Works from anywhere!

**Relative path**: Starts from your current location
```bash
cd projects/rna_seq        # Only works if 'projects' is in current directory
cd ../other_project        # Go up one level, then into other_project
```

## Using Tab Completion

Here's a secret that will save you TONS of time: **Tab completion**!

### How It Works

Start typing a filename or directory, then press **Tab**:

```bash
cd Doc[Tab]                # Autocompletes to 'Documents'
cd projects/rna[Tab]       # Autocompletes to 'rna_seq_analysis'
```

If multiple options exist, press **Tab twice** to see all possibilities:

```bash
cd pro[Tab][Tab]
# Shows: projects/ protein_data/
```

This prevents typos and speeds up your work dramatically!

## The `tree` Command (If Available)

If installed on your server, `tree` shows directory structure visually:

```bash
tree
```

**Example output:**
```
.
├── Documents
│   ├── paper.pdf
│   └── notes.txt
├── projects
│   ├── rna_seq
│   │   ├── data
│   │   └── results
│   └── genome_assembly
└── sequences.fasta
```

Limit depth to avoid overwhelming output:

```bash
tree -L 2                  # Show only 2 levels deep
tree -d                    # Show only directories
```

## Finding Your Way

### When You're Lost

```bash
pwd                        # Where am I?
ls                         # What's here?
cd ~                       # Go back to safety (home)
```

### Creating a Mental Map

As you work, you'll develop common paths:

```bash
# Typical workflow
cd ~                       # Start at home
cd projects               # Enter projects
ls                        # See what projects exist
cd current_project        # Enter the one you're working on
```

## Practice Exercises

### Exercise 1: Basic Navigation

Try this navigation sequence:

```bash
cd ~                       # Start at home
pwd                        # Confirm location
ls                         # See what's here
cd /                       # Go to root
ls                         # Look around root
cd ~                       # Back to home
```

### Exercise 2: Relative Navigation

Create a practice structure:

```bash
cd ~
mkdir -p practice/level1/level2/level3
cd practice
pwd                        # You're in ~/practice
cd level1
pwd                        # You're in ~/practice/level1
cd ..
pwd                        # Back in ~/practice
cd level1/level2/level3
pwd                        # You're deep in the structure
cd ../../..
pwd                        # Back in ~/practice
```

### Exercise 3: Tab Completion

```bash
cd ~
cd Do[Tab]                 # Should complete to Documents
cd ~/pr[Tab]               # Try to complete to projects
```

### Exercise 4: Listing Options

```bash
cd ~
ls                         # Basic list
ls -l                      # Long format
ls -lh                     # Human-readable sizes
ls -lth                    # Sorted by time
ls -a                      # Show hidden files
```

## Common Patterns in Bioinformatics

Most bioinformatics projects follow similar structures:

```
project/
├── raw_data/             # Original, untouched data
├── scripts/              # Your analysis scripts
├── results/              # Output from analyses
│   ├── fastqc/
│   ├── alignments/
│   └── variants/
├── logs/                 # Log files from jobs
└── README.txt            # Project documentation
```

You'll often navigate like:

```bash
cd ~/projects/my_project
cd raw_data                # Look at input
cd ../results              # Check output
cd ../scripts              # Edit scripts
```

## Tips and Tricks

### 1. Use `cd -` to Toggle

When working between two directories:

```bash
cd ~/projects/rna_seq/results
cd ~/reference_genomes
cd -                       # Back to results
cd -                       # Back to genomes
```

### 2. Stack Your `cd` Commands

```bash
cd data && ls -lh         # Change and list in one line
```

### 3. Check Before You Go

```bash
ls projects/rna_seq       # See what's there before entering
cd projects/rna_seq       # Now go there
```

### 4. Use Full Paths for Scripts

In scripts, use full paths to avoid confusion:

```bash
cd /home/jsmith/projects/experiment1/data
```

Not:
```bash
cd ../../../data          # Which data?
```

## Quick Reference

| Command | Description | Example |
|---------|-------------|---------|
| `pwd` | Show current directory | `pwd` |
| `ls` | List files | `ls -lh` |
| `cd directory` | Change to directory | `cd projects` |
| `cd ~` or `cd` | Go to home | `cd ~` |
| `cd ..` | Go up one level | `cd ..` |
| `cd -` | Go to previous directory | `cd -` |
| `cd /path` | Go to absolute path | `cd /home/jsmith` |
| Tab | Autocomplete | `cd Doc[Tab]` |
| Tab Tab | Show options | `cd pr[Tab][Tab]` |

## Common Mistakes

❌ **Forgetting where you are**
```bash
cd data                    # But you're not in the right parent directory!
```
✓ **Always check first**
```bash
pwd                        # Check location
cd ~/projects/experiment1/data  # Use full path
```

❌ **Using spaces without quotes**
```bash
cd My Documents            # Won't work
```
✓ **Use quotes or avoid spaces**
```bash
cd "My Documents"          # Works
cd My\ Documents           # Also works
cd My_Documents            # Better - no spaces needed
```

## What's Next?

Now that you can navigate confidently, you're ready to create, copy, and organize files!

**[Next: Working with Files and Directories →](03-file-operations.md)**

---

**Key Takeaway:** Navigation is like walking through a building. `pwd` tells you where you are, `ls` shows what's around you, and `cd` moves you to a new location. Master these three commands and you'll never be lost!
