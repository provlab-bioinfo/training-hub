# Running Programs

This tutorial covers how to execute programs, scripts, and bioinformatics tools on the command line. You'll learn how to run jobs in the foreground and background, monitor running processes, and manage long-running analyses.

## Running Commands and Programs

<details>
<summary>Basic Execution</summary>

**Run a command:**
```bash
command_name
```

**Run with arguments:**
```bash
command_name argument1 argument2
```

**Examples:**
```bash
ls
fastqc sample.fastq
bwa mem reference.fa reads.fastq
```
</details>

<details>
<summary>Running Scripts</summary>

Scripts are files containing commands. Common types in bioinformatics:
- Bash scripts (`.sh`)
- Python scripts (`.py`)
- R scripts (`.R`)
- Perl scripts (`.pl`)

**Method 1: Direct execution (if script has execute permission)**
```bash
./script.sh
./analyze.py
./process_data.R
```

**Method 2: Specify interpreter**
```bash
bash script.sh
python analyze.py
Rscript process_data.R
perl filter.pl
```

**Method 3: Using 'source' (for shell scripts)**
```bash
source script.sh
# Or shorthand:
. script.sh
```
</details>

<details>
<summary>Making Scripts Executable</summary>

Before running with `./`, make script executable:

```bash
chmod +x script.sh
./script.sh
```

**Creating a simple script:**
```bash
cat > hello.sh << 'EOF'
#!/bin/bash
echo "Hello from script!"
echo "Current directory: $(pwd)"
EOF

chmod +x hello.sh
./hello.sh
```
</details>

<details>
<summary>The Shebang Line</summary>

The first line of a script specifies the interpreter:

```bash
#!/bin/bash          # Bash script
#!/usr/bin/env python   # Python script
#!/usr/bin/env Rscript # R script
#!/usr/bin/perl      # Perl script
```

**Example bash script:**
```bash
#!/bin/bash
# This is a comment
echo "Processing samples..."
for file in *.fastq; do
    echo "Processing $file"
done
```
</details>

## Foreground vs Background Execution

<details>
<summary>Foreground (Default)</summary>

When you run a command normally, it runs in the foreground:
- Terminal is blocked until command finishes
- You see output directly
- Can stop with Ctrl+C

```bash
long_analysis.sh     # Terminal blocked until done
```
</details>

<details>
<summary>Background Execution with `&`</summary>

Add `&` at the end to run in background:
- Terminal remains usable
- Command continues running
- Output may still appear (unless redirected)

```bash
long_analysis.sh &
```

**Example:**
```bash
# Run alignment in background
bwa mem reference.fa reads.fastq > alignment.sam &
echo "Alignment running in background"
# You can continue working
```

**Redirect output to prevent terminal clutter:**
```bash
long_analysis.sh > output.log 2>&1 &
```
</details>

<details>
<summary>Job Control Commands</summary>

**List background jobs:**
```bash
jobs
```

Output shows:
```
[1]+  Running   long_analysis.sh &
[2]-  Running   another_job.sh &
```

**Bring job to foreground:**
```bash
fg              # Bring most recent job to foreground
fg %1           # Bring job [1] to foreground
```

**Send job to background:**
```bash
# First, pause current job with Ctrl+Z
# Then send to background:
bg
```

**Example workflow:**
```bash
# Start a job
long_process

# Oops, forgot to background it!
# Press Ctrl+Z to pause
[1]+  Stopped   long_process

# Send to background
bg
[1]+ long_process &

# Continue working while it runs
jobs
```
</details>

## The `nohup` Command - Persistent Jobs

<details>
<summary>`nohup` (no hang up) keeps programs running even after you log out.</summary>

**Basic usage:**
```bash
nohup command &
```

**Example:**
```bash
nohup long_analysis.sh &
```

Output goes to `nohup.out` by default.

**Redirect output:**
```bash
nohup long_analysis.sh > analysis.log 2>&1 &
```

**Why use nohup:**
- Long analyses that take hours or days
- Prevent job termination if connection drops
- Can log out and check results later

**Best practice for long jobs:**
```bash
nohup bash -c 'command1 && command2 && command3' > job.log 2>&1 &
echo $! > job.pid  # Save process ID for later
```
</details>

## Monitoring Running Processes

<details>
<summary>The `ps` Command</summary>

`ps` shows running processes.

**Show your processes:**
```bash
ps
```

**Show all processes with details:**
```bash
ps aux
```

**Find specific process:**
```bash
ps aux | grep python
ps aux | grep username
```

**Common ps options:**
```bash
ps -u username      # Processes by specific user
ps -ef              # Full format listing
ps aux --sort=-%mem # Sort by memory usage
ps aux --sort=-%cpu # Sort by CPU usage
```

**Example - find your running analyses:**
```bash
ps aux | grep $USER | grep -E 'bwa|fastqc|python'
```
</details>

<details>
<summary>The `top` Command</summary>

`top` shows real-time process information.

```bash
top
```

**While in top:**
- Press `q` to quit
- Press `M` to sort by memory
- Press `P` to sort by CPU
- Press `k` to kill a process (enter PID)
- Press `u` then username to filter by user

**Better alternative - htop (if available):**
```bash
htop
```

More user-friendly with color coding and mouse support.
</details>

<details>
<summary>The `pgrep` Command</summary>

Find process IDs by name:

```bash
pgrep python        # All Python processes
pgrep -u username   # All processes by user
pgrep -l bwa        # Show name and PID
```

**Example:**
```bash
# Find and kill all Python processes
pgrep -l python
kill $(pgrep python)
```
</details>

## Killing Processes

<details>
<summary>The `kill` Command</summary>

**Basic syntax:**
```bash
kill PID
```

**Find PID first:**
```bash
ps aux | grep process_name
# Or
pgrep process_name
```

**Kill process:**
```bash
kill 12345          # Graceful termination (SIGTERM)
```

**Force kill if needed:**
```bash
kill -9 12345       # Force kill (SIGKILL)
```

**Kill by name:**
```bash
pkill process_name
pkill -9 process_name    # Force kill
```
</details>

<details>
<summary>Common Kill Signals</summary>

```bash
kill -TERM PID      # Default: graceful shutdown (15)
kill -KILL PID      # Force kill, can't be ignored (9)
kill -HUP PID       # Hang up (1)
kill -STOP PID      # Pause process (19)
kill -CONT PID      # Resume paused process (18)
```

**Example workflow:**
```bash
# Try graceful kill first
kill 12345

# Wait a few seconds
sleep 5

# If still running, force kill
kill -9 12345
```
</details>

<details>
<summary>Killing Multiple Processes</summary>

**Kill all processes matching pattern:**
```bash
pkill -f "pattern"
killall process_name
```

**Example - kill all your Python scripts:**
```bash
pkill -u $USER python
```
</details>

## Checking Process Status

<details>
<summary>Check if Process is Running</summary>

```bash
ps -p PID           # Check specific PID
pgrep process_name  # Find PIDs by name
```

**Example:**
```bash
# Check if job is still running
if ps -p 12345 > /dev/null; then
    echo "Process is running"
else
    echo "Process has finished"
fi
```
</details>

<details>
<summary>Monitor Process Resource Usage</summary>

```bash
# CPU and memory for specific process
top -p PID

# Detailed process info
ps -p PID -o pid,ppid,cmd,%mem,%cpu
```
</details>

## Running Bioinformatics Tools

<details>
<summary>Typical Workflow</summary>

```bash
# 1. Check if tool is available
which fastqc
fastqc --version

# 2. Run tool with appropriate options
fastqc sample.fastq -o output_dir/

# 3. For long jobs, use nohup and background
nohup fastqc *.fastq -o fastqc_results/ > fastqc.log 2>&1 &

# 4. Save job PID
echo $! > fastqc.pid

# 5. Monitor progress
tail -f fastqc.log

# 6. Check if still running
cat fastqc.pid
ps -p $(cat fastqc.pid)
```
</details>

<details>
<summary>Running Multiple Samples</summary>

**Sequential processing:**
```bash
for sample in sample1 sample2 sample3; do
    echo "Processing $sample"
    bwa mem reference.fa ${sample}.fastq > ${sample}.sam
done
```

**Parallel processing (simple):**
```bash
bwa mem ref.fa sample1.fastq > sample1.sam &
bwa mem ref.fa sample2.fastq > sample2.sam &
bwa mem ref.fa sample3.fastq > sample3.sam &
wait    # Wait for all background jobs to finish
```

**With logging:**
```bash
for sample in sample1 sample2 sample3; do
    echo "Starting $sample at $(date)"
    nohup process_sample.sh $sample > ${sample}.log 2>&1 &
done
```
</details>

## Screen and Tmux - Terminal Multiplexers

For long-running jobs, consider using screen or tmux. These allow you to:
- Detach and reattach to sessions
- Keep jobs running if connection drops
- Organize multiple tasks in windows

<details>
<summary>Basic Screen Usage</summary>

**Start screen session:**
```bash
screen -S analysis_session
```

**Run your commands:**
```bash
long_running_analysis.sh
```

**Detach (press keys):**
```
Ctrl+A, then D
```

**List sessions:**
```bash
screen -ls
```

**Reattach:**
```bash
screen -r analysis_session
```

**Kill session:**
```bash
screen -X -S analysis_session quit
```
</details>

<details>
<summary>Basic Tmux Usage</summary>

**Start tmux session:**
```bash
tmux new -s analysis
```

**Detach (press keys):**
```
Ctrl+B, then D
```

**List sessions:**
```bash
tmux ls
```

**Reattach:**
```bash
tmux attach -t analysis
```

**Kill session:**
```bash
tmux kill-session -t analysis
```
</details>

## Best Practices for Running Jobs

### 1. Test First with Small Data

```bash
# Test with subset before full run
head -n 40000 large.fastq > test.fastq
your_tool test.fastq

# If successful, run full analysis
nohup your_tool large.fastq > analysis.log 2>&1 &
```

### 2. Log Everything

```bash
# Include timestamps
echo "Started at $(date)" > analysis.log
nohup your_analysis.sh >> analysis.log 2>&1 &
```

### 3. Save Process IDs

```bash
nohup long_job.sh &
echo $! > job.pid

# Later, check if running:
ps -p $(cat job.pid)
```

### 4. Redirect Output Properly

```bash
# Good: separate output and errors
command > output.txt 2> error.txt &

# Good: combine into one log
command > combined.log 2>&1 &

# Bad: background without redirect
command &    # Output clutters terminal
```

### 5. Use Error Handling in Scripts

```bash
#!/bin/bash
set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Catch errors in pipes

echo "Starting analysis"
step1.sh || { echo "Step 1 failed"; exit 1; }
step2.sh || { echo "Step 2 failed"; exit 1; }
echo "Analysis complete"
```

### 6. Check Resources Before Running

```bash
# Check available memory
free -h

# Check disk space
df -h

# Check CPU usage
top -b -n 1 | head -20
```
***

<details>
<summary>Example Workflows</summary>

### Workflow 1: Quality Control Pipeline

```bash
#!/bin/bash
# QC pipeline for multiple samples

LOG="qc_pipeline.log"
echo "QC Pipeline started: $(date)" > $LOG

for sample in sample1 sample2 sample3; do
    echo "Processing $sample" | tee -a $LOG
    
    # Run FastQC
    fastqc ${sample}.fastq.gz -o fastqc_results/ 2>&1 | tee -a $LOG
    
    if [ $? -eq 0 ]; then
        echo "$sample: FastQC completed successfully" | tee -a $LOG
    else
        echo "$sample: FastQC failed!" | tee -a $LOG
    fi
done

echo "Pipeline completed: $(date)" | tee -a $LOG
```

### Workflow 2: Long-Running Alignment

```bash
#!/bin/bash
# Run alignment in background with monitoring

SAMPLE="sample1"
REFERENCE="reference.fa"
THREADS=8

# Start alignment
nohup bwa mem -t $THREADS $REFERENCE ${SAMPLE}_R1.fastq ${SAMPLE}_R2.fastq > ${SAMPLE}.sam 2> ${SAMPLE}_bwa.log &

# Save PID
BWA_PID=$!
echo $BWA_PID > bwa.pid
echo "BWA started with PID: $BWA_PID"

# Monitor progress
echo "Monitoring alignment progress..."
tail -f ${SAMPLE}_bwa.log &
TAIL_PID=$!

# Wait for alignment to complete
wait $BWA_PID

# Stop monitoring
kill $TAIL_PID 2>/dev/null

echo "Alignment complete!"
```

### Workflow 3: Batch Processing with Status Tracking

```bash
#!/bin/bash
# Process multiple samples and track status

SAMPLES="sample1 sample2 sample3 sample4"
STATUS_FILE="processing_status.txt"

echo "Sample,Status,Start,End" > $STATUS_FILE

for sample in $SAMPLES; do
    START=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$sample,Running,$START," >> $STATUS_FILE
    
    # Run analysis
    if process_sample.sh $sample > ${sample}.log 2>&1; then
        END=$(date +"%Y-%m-%d %H:%M:%S")
        sed -i "s/$sample,Running/$sample,Complete/" $STATUS_FILE
        sed -i "s/$sample,Complete,$START,/$sample,Complete,$START,$END/" $STATUS_FILE
    else
        END=$(date +"%Y-%m-%d %H:%M:%S")
        sed -i "s/$sample,Running/$sample,Failed/" $STATUS_FILE
        sed -i "s/$sample,Failed,$START,/$sample,Failed,$START,$END/" $STATUS_FILE
    fi
done

# Show summary
echo "Processing Summary:"
cat $STATUS_FILE
```
</details>

<details>
<summary>Troubleshooting</summary>

### Problem: Command Not Found

```bash
command_name
# -bash: command_name: command not found
```

**Solutions:**
```bash
# Check if installed
which command_name

# Find where it is
find /usr -name command_name 2>/dev/null

# May need to load module
module load command_name

# Or add to PATH
export PATH=$PATH:/path/to/program
```

### Problem: Script Not Executable

```bash
./script.sh
# -bash: ./script.sh: Permission denied
```

**Solution:**
```bash
chmod +x script.sh
./script.sh
```

### Problem: Job Killed Unexpectedly

**Check:**
```bash
# Was it out of memory?
dmesg | grep -i kill

# Check system logs
tail /var/log/messages  # May need sudo
```

**Prevention:**
```bash
# Monitor memory usage
while true; do
    ps -p $PID -o %mem,rss
    sleep 60
done > memory_usage.log &
```

### Problem: Job Stops When Disconnected

**Solution: Use nohup or screen/tmux**
```bash
# Instead of:
long_job.sh

# Use:
nohup long_job.sh &
# Or run in screen/tmux session
```
</details>

*** 
## Quick Reference

### Running Programs

| Command | Description |
|---------|-------------|
| `./script.sh` | Run executable script |
| `bash script.sh` | Run with bash |
| `command &` | Run in background |
| `nohup command &` | Run persistent background job |
| `jobs` | List background jobs |
| `fg` | Bring job to foreground |
| `bg` | Send job to background |

### Process Management

| Command | Description |
|---------|-------------|
| `ps aux` | Show all processes |
| `ps aux \| grep user` | Find user's processes |
| `top` | Monitor processes |
| `pgrep name` | Find process by name |
| `kill PID` | Terminate process |
| `kill -9 PID` | Force kill process |
| `pkill name` | Kill by name |

### Useful Variables

| Variable | Description |
|----------|-------------|
| `$!` | PID of last background job |
| `$?` | Exit status of last command |
| `$$` | Current shell PID |

---

**Key Takeaway:** Use `&` for quick background jobs, `nohup` for long-running analyses, and screen/tmux for persistent sessions. Always redirect output to log files, monitor resource usage, and test with small datasets first!
