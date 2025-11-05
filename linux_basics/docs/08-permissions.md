# File Permissions

Understanding file permissions is crucial for working safely on shared Linux servers. Permissions control who can read, modify, or execute your files. This tutorial explains Linux permissions and how to manage them.

## Why Permissions Matter

On a shared server:
- **Protect your data** - Prevent others from accidentally (or intentionally) modifying your files
- **Share selectively** - Control who can access your results
- **Run scripts** - Make analysis scripts executable
- **Collaborate safely** - Work with colleagues while maintaining data integrity

## Understanding Permission Basics

Every file and directory has three sets of permissions for three types of users:

1. **Owner (u)** - The user who owns the file (usually you)
2. **Group (g)** - Users who are in the same group
3. **Others (o)** - Everyone else on the system

Each set has three permission types:
- **Read (r)** - View file contents or list directory contents
- **Write (w)** - Modify file or create/delete files in directory
- **Execute (x)** - Run file as program or enter directory

## Viewing Permissions

Use `ls -l` to see permissions:

```bash
ls -l
```

**Example output:**
```
-rw-r--r-- 1 jsmith bioinf  1234 Nov  4 10:30 data.txt
drwxr-xr-x 2 jsmith bioinf  4096 Nov  3 14:22 scripts
-rwxr-xr-x 1 jsmith bioinf   256 Nov  2 09:15 analyze.sh
```

### Breaking Down Permission String

```
-rw-r--r--
│││││││││└─── Others can read
││││││││└──── Others can't write
│││││││└───── Others can't execute
││││││└────── Group can read
│││││└─────── Group can't write
││││└──────── Group can't execute
│││└───────── Owner can read
││└────────── Owner can write
│└─────────── Owner can't execute
└──────────── File type (- = file, d = directory, l = link)
```

### Common Permission Patterns

```bash
-rw-r--r--    # Standard file: owner can edit, others can only read
-rw-------    # Private file: only owner can read and write
-rwxr-xr-x    # Executable script: everyone can run, only owner can modify
drwxr-xr-x    # Standard directory: everyone can enter and list
drwx------    # Private directory: only owner can access
```

### Real Examples

```bash
ls -l sequences.fasta
# -rw-r--r-- 1 jsmith bioinf 10485760 Nov  4 10:30 sequences.fasta
# Owner: read+write
# Group: read only
# Others: read only

ls -l scripts/analyze.sh
# -rwxr-xr-x 1 jsmith bioinf 2048 Nov  3 14:22 analyze.sh
# Owner: read+write+execute
# Group: read+execute
# Others: read+execute

ls -l private_data/
# drwx------ 2 jsmith bioinf 4096 Nov  2 09:15 private_data
# Owner: full access
# Group: no access
# Others: no access
```

## The `chmod` Command - Change Permissions

`chmod` (change mode) modifies file permissions.

### Symbolic Method (Easy to Remember)

**Basic syntax:**
```bash
chmod [who][+/-/=][permissions] filename
```

**Who:**
- `u` - user (owner)
- `g` - group
- `o` - others
- `a` - all (same as ugo)

**Operators:**
- `+` - add permission
- `-` - remove permission
- `=` - set exact permission

**Permissions:**
- `r` - read
- `w` - write
- `x` - execute

### Common `chmod` Examples

**Make script executable:**
```bash
chmod +x script.sh              # Add execute for everyone
chmod u+x script.sh             # Add execute for owner only
```

**Remove write permission:**
```bash
chmod -w data.txt               # Remove write for everyone
chmod go-w data.txt             # Remove write for group and others
```

**Make file private:**
```bash
chmod go-rwx private.txt        # Remove all permissions from group and others
chmod 600 private.txt           # Same thing, numeric method
```

**Set specific permissions:**
```bash
chmod u=rwx,g=rx,o=r file.txt  # Owner: rwx, Group: rx, Others: r
```

**Make directory accessible:**
```bash
chmod +x directory              # Allow entering directory
```

### Bioinformatics Examples

**Make analysis script executable:**
```bash
chmod +x run_analysis.sh
./run_analysis.sh               # Now you can run it
```

**Protect raw data from accidental modification:**
```bash
chmod -w raw_data/*.fastq.gz    # Remove write permission
```

**Share results with group:**
```bash
chmod g+r results/*.txt         # Group can read results
```

**Private research data:**
```bash
chmod 700 confidential_data/    # Only you can access
```

**Collaborative project:**
```bash
chmod 775 shared_project/       # Owner and group can modify, others can read
```

## Numeric (Octal) Method

Permissions can be represented as three-digit numbers. This is faster once you learn it.

### Understanding the Numbers

Each permission has a value:
- `r` (read) = 4
- `w` (write) = 2
- `x` (execute) = 1

Add them up for each user type:

```
7 = rwx (4+2+1)
6 = rw- (4+2)
5 = r-x (4+1)
4 = r-- (4)
3 = -wx (2+1)
2 = -w- (2)
1 = --x (1)
0 = --- (no permissions)
```

### Common Numeric Permissions

```bash
chmod 644 file.txt      # rw-r--r-- (standard file)
chmod 755 script.sh     # rwxr-xr-x (executable script)
chmod 600 private.txt   # rw------- (private file)
chmod 700 private_dir/  # rwx------ (private directory)
chmod 775 shared_dir/   # rwxrwxr-x (group-writable)
chmod 777 file.txt      # rwxrwxrwx (everyone can do everything - RARELY needed!)
```

### Breaking Down Examples

**chmod 644 file.txt**
```
6 (owner)   = 4+2   = rw-
4 (group)   = 4     = r--
4 (others)  = 4     = r--
Result: -rw-r--r--
```

**chmod 755 script.sh**
```
7 (owner)   = 4+2+1 = rwx
5 (group)   = 4+1   = r-x
5 (others)  = 4+1   = r-x
Result: -rwxr-xr-x
```

**chmod 700 private/**
```
7 (owner)   = 4+2+1 = rwx
0 (group)   = 0     = ---
0 (others)  = 0     = ---
Result: drwx------
```

## Recursive Permission Changes

Use `-R` to change permissions recursively (for directories and all contents):

```bash
chmod -R 755 directory/         # Change directory and everything inside
chmod -R g+r project/           # Give group read access to all files
```

**Examples:**

```bash
# Make all scripts executable
chmod -R +x scripts/

# Remove write access from archived data
chmod -R -w archive/

# Set standard permissions on project
chmod -R 755 my_project/
```

**⚠️ Warning:** Be careful with recursive changes - test on a copy first!

## Directory Permissions Explained

Directory permissions work differently:

- **Read (r)** - Can list contents (ls)
- **Write (w)** - Can create/delete files in directory
- **Execute (x)** - Can enter directory (cd) and access files

**Important:** You need execute permission to access files in a directory, even if you can read the directory!

```bash
# Directory with read but no execute
chmod 644 test_dir/
ls test_dir/           # Works - can list
cd test_dir/           # Fails - can't enter
cat test_dir/file.txt  # Fails - can't access files

# Directory with execute but no read
chmod 711 test_dir/
ls test_dir/           # Fails - can't list
cd test_dir/           # Works - can enter
cat test_dir/file.txt  # Works if you know filename
```

**Standard directory permissions:**
```bash
chmod 755 directory/   # Standard: owner full, others can read/enter
chmod 700 directory/   # Private: only owner can access
chmod 775 directory/   # Shared: owner and group can modify
```

## Common Permission Scenarios

### Scenario 1: Sharing Data with Collaborators

```bash
# Create shared directory
mkdir shared_results
chmod 775 shared_results/

# Add results (group can read)
cp results.txt shared_results/
chmod 664 shared_results/results.txt

# Verify
ls -l shared_results/
```

### Scenario 2: Protecting Raw Data

```bash
# Prevent accidental modification
chmod 444 raw_data/*.fastq.gz    # Read-only for everyone
# Or
chmod -w raw_data/*.fastq.gz     # Remove write permission
```

### Scenario 3: Creating Executable Scripts

```bash
# Create script
cat > analyze.sh << 'EOF'
#!/bin/bash
echo "Running analysis..."
# Analysis commands here
EOF

# Make executable
chmod +x analyze.sh

# Run it
./analyze.sh
```

### Scenario 4: Private Analysis Results

```bash
# Create private directory
mkdir confidential_results
chmod 700 confidential_results/

# Only you can access
ls -ld confidential_results/
# drwx------ ... confidential_results/
```

### Scenario 5: Shared Project with Version Control

```bash
# Set up shared project directory
mkdir -p /shared/project_name
chmod 775 /shared/project_name

# Create subdirectories
mkdir /shared/project_name/{data,scripts,results}
chmod 775 /shared/project_name/*

# Set default permissions for new files
# (This requires setting umask, covered in advanced topics)
```

## The `umask` Command

`umask` sets default permissions for newly created files and directories.

**View current umask:**
```bash
umask
# Output: 0022
```

**Common umask values:**
```
0022 - Default: files 644, directories 755
0077 - Private: files 600, directories 700
0002 - Group-friendly: files 664, directories 775
```

**Set umask:**
```bash
umask 0022    # Temporary for this session
```

To make permanent, add to `~/.bashrc`:
```bash
echo "umask 0022" >> ~/.bashrc
```

## Special Permissions

### Sticky Bit

The sticky bit (t) on a directory means only the file owner can delete files, even if others have write permission.

```bash
chmod +t directory/     # Add sticky bit
chmod 1777 directory/   # Numeric: 1 = sticky bit
```

**Example:**
```bash
ls -ld /tmp
# drwxrwxrwt ... /tmp
# Notice the 't' at the end - sticky bit
```

This is why in `/tmp`, you can't delete other users' files even though the directory is world-writable.

### SetUID and SetGID

Less common in bioinformatics, but good to know:

```bash
chmod u+s file    # SetUID: runs with owner's permissions
chmod g+s file    # SetGID: runs with group's permissions
```

These are typically only needed for system administration.

## Checking Permissions

### View Your File Permissions

```bash
ls -l myfile.txt
stat myfile.txt          # Detailed information
```

### Check Directory Permissions

```bash
ls -ld directory/        # -d shows directory itself, not contents
```

### Check Effective Permissions

```bash
# See what groups you're in
groups

# See detailed info about file
stat filename

# Test if you can read a file
test -r filename && echo "Can read" || echo "Cannot read"

# Test if you can write
test -w filename && echo "Can write" || echo "Cannot write"

# Test if you can execute
test -x filename && echo "Can execute" || echo "Cannot execute"
```

## Troubleshooting Permission Issues

### "Permission Denied" Errors

**Problem: Can't run script**
```bash
./analyze.sh
# bash: ./analyze.sh: Permission denied
```
**Solution:**
```bash
chmod +x analyze.sh
./analyze.sh
```

**Problem: Can't modify file**
```bash
echo "data" > results.txt
# bash: results.txt: Permission denied
```
**Solution:**
```bash
ls -l results.txt        # Check permissions
chmod u+w results.txt    # Add write permission
```

**Problem: Can't enter directory**
```bash
cd project/
# bash: cd: project/: Permission denied
```
**Solution:**
```bash
ls -ld project/          # Check directory permissions
chmod u+x project/       # Add execute permission
```

**Problem: Can't delete file**
```bash
rm file.txt
# rm: cannot remove 'file.txt': Permission denied
```
**Solution:**
```bash
# Check if file is write-protected
ls -l file.txt
chmod u+w file.txt       # Add write permission to file
# Or check directory permissions
ls -ld .                 # Need write permission on directory
```

## Best Practices

1. **Default file permissions: 644**
   ```bash
   chmod 644 *.txt *.csv
   ```

2. **Default directory permissions: 755**
   ```bash
   chmod 755 */
   ```

3. **Executable scripts: 755**
   ```bash
   chmod 755 *.sh *.py *.R
   ```

4. **Private data: 600 or 700**
   ```bash
   chmod 600 sensitive_data.txt
   chmod 700 private_directory/
   ```

5. **Protect raw data from modification**
   ```bash
   chmod -w raw_data/*
   ```

6. **Test permissions before sharing**
   ```bash
   ls -l file_to_share.txt
   ```

7. **Use groups for collaboration**
   ```bash
   chmod 664 shared_data.txt   # Group can read and write
   chmod 775 shared_directory/ # Group can modify
   ```

8. **Never use 777 unless absolutely necessary**
   ```bash
   # chmod 777 file.txt  # ❌ Security risk!
   # Use specific permissions instead
   ```

## Practice Exercises

### Exercise 1: Basic Permission Changes

```bash
# Create test file
echo "test data" > test.txt

# View permissions
ls -l test.txt

# Make read-only
chmod 444 test.txt

# Try to modify (should fail)
echo "more data" >> test.txt

# Restore write permission
chmod 644 test.txt

# Now modify (should work)
echo "more data" >> test.txt
```

### Exercise 2: Script Permissions

```bash
# Create script
cat > hello.sh << 'EOF'
#!/bin/bash
echo "Hello, World!"
EOF

# Try to run (should fail)
./hello.sh

# Make executable
chmod +x hello.sh

# Run successfully
./hello.sh
```

### Exercise 3: Directory Permissions

```bash
# Create test directory
mkdir test_dir
touch test_dir/file.txt

# Remove execute permission
chmod 644 test_dir/

# Try to access (should fail)
cd test_dir/

# Restore permissions
chmod 755 test_dir/

# Now access works
cd test_dir/
```

### Exercise 4: Numeric Permissions

```bash
# Create test file
touch perm_test.txt

# Try different permissions
chmod 600 perm_test.txt    # Private
ls -l perm_test.txt

chmod 644 perm_test.txt    # Standard
ls -l perm_test.txt

chmod 755 perm_test.txt    # Executable
ls -l perm_test.txt
```

## Quick Reference

### Symbolic Method

| Command | Result | Description |
|---------|--------|-------------|
| `chmod +x file` | Add execute for all | Make executable |
| `chmod u+x file` | Add execute for owner | Owner can execute |
| `chmod g+w file` | Add write for group | Group can modify |
| `chmod o-r file` | Remove read from others | Others can't read |
| `chmod a+r file` | Add read for all | Everyone can read |

### Numeric Method

| Number | Permission | Common Use |
|--------|------------|------------|
| 644 | rw-r--r-- | Standard file |
| 755 | rwxr-xr-x | Script/directory |
| 600 | rw------- | Private file |
| 700 | rwx------ | Private directory |
| 664 | rw-rw-r-- | Group-editable file |
| 775 | rwxrwxr-x | Shared directory |

### Permission Meanings

**For Files:**
- **r** - Can read file contents
- **w** - Can modify file contents
- **x** - Can execute file as program

**For Directories:**
- **r** - Can list directory contents
- **w** - Can create/delete files
- **x** - Can enter directory and access files

## Common Mistakes

❌ **Using 777 unnecessarily**
```bash
chmod 777 file.txt    # Security risk - everyone can do everything
```
✓ **Use specific permissions**
```bash
chmod 755 file.txt    # Appropriate for most cases
```

❌ **Forgetting execute on directories**
```bash
chmod 644 directory/  # Can't enter directory!
```
✓ **Directories need execute**
```bash
chmod 755 directory/  # Can enter and list
```

❌ **Recursive changes without thinking**
```bash
chmod -R 777 /        # ❌ NEVER DO THIS!
```
✓ **Be specific and careful**
```bash
chmod -R 755 my_project/  # Only affect your project
```

**Key Takeaway:** Permissions control who can read, modify, and execute your files. Use `chmod 644` for data files, `chmod 755` for scripts and directories, and `chmod 700` for private data. Understanding permissions keeps your data safe on shared servers!
