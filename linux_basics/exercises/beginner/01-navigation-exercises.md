# Beginner Exercise Solutions
Complete solutions for beginner exercises. Try solving on your own first!

## Exercise 1: Navigation Solutions

<details>
<summary>Exercise 1.1: Finding Your Way</summary>
   
```bash
# 1. Print current directory
pwd

# 2. List all directories
ls -d */

# 3. Navigate to project1
cd project1

# 4. Print current directory again
pwd

# 5. Go back to practice_nav
cd ..
```
</details>

<details>
<summary>Exercise 1.2: Relative and Absolute Paths</summary>
   
```bash
# 1. Navigate to project1/data (relative)
cd project1/data

# 2. Navigate to practice_nav (absolute - adjust path to yours)
cd /home/username/practice_nav
# Or
cd ~/practice_nav

# 3. Navigate to project2/analysis
cd project2/analysis

# 4. Return home
cd ~
# Or just
cd
```
</details>

<details>
<summary>Exercise 1.3: Exploring with ls</summary>

```bash
# 1. Long format
ls -l

# 2. Sorted by time
ls -lt

# 3. Human-readable sizes
ls -lh

# 4. Including hidden files
ls -a

# 5. Only directories
ls -d */
# Or
ls -l | grep ^d
```
</details>

<details>
<summary>Exercise 1.4: Quick Navigation</summary>
   
```bash
# 1. Navigate to project1/scripts
cd project1/scripts

# 2. Toggle back
cd -

# 3. Toggle forward again
cd -

# 4. Go up two levels
cd ../..

# 5. Jump directly to project2/raw_data
cd project2/raw_data
# Or from anywhere:
cd ~/practice_nav/project2/raw_data
```
</details>

<details>
<summary>Exercise 1.5: Directory Tree Navigation</summary>
   
```bash
# 1. From home, navigate to project1/data
cd ~/practice_nav/project1/data

# 2. Go to project2/analysis without using absolute path
cd ../../project2/analysis

# 3. List contents of project1/scripts without changing directory
ls ../../project1/scripts

# 4. Navigate to parent of practice_nav
cd ../../..

# 5. Return to practice_nav/project2/results
cd practice_nav/project2/results
```
</details>

<details>
<summary>Exercise 1.6: Working with Multiple Directories</summary>
   
```bash
# 1. Create bookmark using variables
PROJECT1=~/practice_nav/project1
cd $PROJECT1

# 2. Navigate between project directories
cd ~/practice_nav/project1/data
cd ~/practice_nav/project2/analysis

# 3. Use OLDPWD to go back
cd $OLDPWD

# 4. Create directory stack
pushd ~/practice_nav/project1
pushd ~/practice_nav/project2
popd
popd
```
</details>

<details>
<summary>Exercise 1.7: Real-World Scenario</summary>
   
```bash
# From project1/results:
# 1. Copy script
cp ../scripts/script_name.sh .

# 2. Check for data
ls ../data

# 3. Create figures subdirectory
mkdir figures

# 4. Navigate to project2/analysis
cd ../../project2/analysis
```
</details>

<details>
<summary>Exercise 1.8: Path Verification</summary>
   
```bash
# 1. Verify you're in the right directory
pwd
basename $(pwd)

# 2. Check if directory exists before navigating
[ -d ~/practice_nav/project1 ] && cd ~/practice_nav/project1 || echo "Directory doesn't exist"

# 3. Show full path of a relative directory
realpath ../data

# 4. Find all project directories from home
find ~/practice_nav -type d -name "project*"
```
</details>

<details>
<summary>Exercise 1.9: Troubleshooting</summary>
   
```bash
# Mistake 1: Typo
cd porject1
# Fix: Check spelling
cd project1

# Mistake 2: Case sensitivity
cd Project1/Data
# Fix: Use correct case
cd project1/data

# Mistake 3: Space in path
cd project1
# Fix: Use quotes or escape
cd "project1"
# Or
cd project1

# Mistake 4: Missing parent directory
cd practice_nav/project1
# Fix: Use proper path
cd ~/practice_nav/project1
# Or if already nearby
cd ../practice_nav/project1
```
</details>

<details>
<summary>Exercise 1.10: Advanced Navigation Techniques</summary>
   
```bash
# 1. Navigate using wildcards (if unique)
cd ~/practice_nav/proj*/data

# 2. Navigate and execute command in one line
cd ~/practice_nav/project1 && ls -l

# 3. Save current location and navigate elsewhere
SAVED_DIR=$(pwd)
cd ~/practice_nav/project2
# Later, return to saved location
cd $SAVED_DIR

# 4. Use brace expansion for multiple navigations
cd ~/practice_nav/{project1,project2}

# 5. Find and navigate to a directory
cd $(find ~/practice_nav -type d -name "scripts" | head -1)
```
</details>

## Common Navigation Shortcuts Reference

### Quick Reference:
- `cd` or `cd ~` - Go to home directory
- `cd -` - Go to previous directory
- `cd ..` - Go up one level
- `cd ../..` - Go up two levels
- `cd /` - Go to root directory
- `pwd` - Print working directory
- `ls -la` - List all files with details

### Useful Combinations:
```bash
# See where you are and what's there
pwd && ls

# Navigate and confirm
cd project1 && pwd

# Go back if navigation fails
cd project1 || cd ~

# Navigate to directory containing a file
cd $(dirname /path/to/file)
```

## Tips for Efficient Navigation

- [x] **Use Tab Completion**: Press Tab to auto-complete directory names
- [x] **Use History**: Press Up arrow to cycle through previous commands
- [x] **Create Aliases**: Add to `~/.bashrc`:
   ```bash
   alias proj1='cd ~/practice_nav/project1'
   alias proj2='cd ~/practice_nav/project2'
   ```
- [x] **Use `pushd` and `popd`**: Build a directory stack for complex navigation
- [x] **Set CDPATH**: Add frequently used parent directories to CDPATH:
   ```bash
   export CDPATH=.:~:~/practice_nav
   ```
