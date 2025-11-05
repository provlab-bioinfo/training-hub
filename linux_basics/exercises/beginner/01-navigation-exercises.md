# Beginner Exercise Solutions

Complete solutions for beginner exercises. Try solving on your own first!

## Exercise 1: Navigation Solutions

### Exercise 1.1: Finding Your Way

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

### Exercise 1.2: Relative and Absolute Paths

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

### Exercise 1.3: Exploring with ls

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

### Exercise 1.4: Quick Navigation

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

### Exercise 1.7: Real-World Scenario

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

### Exercise 1.9: Troubleshooting

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
cd project 1
# Fix: Use quotes or escape
cd "project 1"
# Or
cd project\ 1
```
