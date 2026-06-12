# HPC Cluster Job Submission Guide
### A Practical Introduction for Public Health Researchers

---

## Table of Contents

1.  Prerequisites: Before You Begin
2. [What Is This Cluster and How Does It Work?](#1-what-is-this-cluster-and-how-does-it-work)
3. [⚠️ The Golden Rule: Never Run Jobs on the Login Node](#2-️-the-golden-rule-never-run-jobs-on-the-login-node)
4. [Checking Cluster Status with `sinfo`](#3-checking-cluster-status-with-sinfo)
5. [Interactive Jobs — Working Live on a Compute Node](#4-interactive-jobs--working-live-on-a-compute-node)
6. [Batch Jobs — Submitting Work to Run in the Background](#5-batch-jobs--submitting-work-to-run-in-the-background)
7. [Managing Your Jobs: `squeue` and `scancel`](#6-managing-your-jobs-squeue-and-scancel)
8. [Inspecting Jobs in Detail with `scontrol`](#7-inspecting-jobs-in-detail-with-scontrol)
9. [Viewing Your Job History and Resource Usage with `sacct`](#8-viewing-your-job-history-and-resource-usage-with-sacct)
10. [Understanding Accounts and Allocations with `sacctmgr`](#9-understanding-accounts-and-allocations-with-sacctmgr)
11. [Quick Reference Cheat Sheet](#10-quick-reference-cheat-sheet)
12. [Common Problems and Solutions](#11-common-problems-and-solutions)

---
## 1. Prerequisites: Before You Begin

Before you can use the cluster, there are a few things that need to be set up. None of this happens automatically and you need to contact your manager to :
  * Request for Linux account on HPC system for you to log in to the cluster
  * Request for HPC cluster access

## 2. What Is This Cluster and How Does It Work?

A high-performance computing (HPC) cluster is a collection of many computers (called **nodes**) connected together so you can run analyses that are too large or slow for your laptop.

```
Your Laptop  →  Login Node (the "front door")  →  Compute Nodes (the "workers")
```

When you connect via SSH, you land on the **login node** — think of it as the reception desk of the cluster. From there, you use a system called **Slurm** to send your analysis jobs to the **compute nodes**, where the real processing happens.

**Slurm** (Simple Linux Utility for Resource Management) is the scheduler. You tell it what resources you need (CPUs, memory, time) and it finds an available compute node and runs your job there.

---

## 3. ⚠️ The Golden Rule: Never Run Jobs on the Login Node

> **Do not run computations directly on the login node.**

This is the most important rule on any HPC cluster. Here is why it matters:

- The login node is **shared by everyone** on the cluster at the same time
- Running heavy analyses there **slows it down for all users** — your colleagues included
- Long-running or memory-hungry processes on the login node **will be killed** by the system administrators without warning
- In serious cases, your account may be suspended

**What is okay on the login node:**
- Editing scripts and files (`nano`, `vim`, `code`)
- Submitting jobs to Slurm (`sbatch`, `srun`)
- Checking job status (`squeue`, `sinfo`)
- Moving or copying files
- Short commands that finish in a second or two

**What is NOT okay on the login node:**
- Running R, Python analyses directly
- Running any statistical model or simulation
- Processing large datasets
- Compiling software

If you are not sure, submit it as a job.

---

## 4. Checking Cluster Status with `sinfo`

Before submitting a job, it is helpful to know what the cluster looks like. The `sinfo` command shows you the available **partitions** (groups of compute nodes) and their current state.

```bash
sinfo
```

Example output:

```
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
vm-cpu*      up   infinite      2    mix uxaplgnmxapp[02,04]
big-ram      up   infinite      1   idle uxaplgnmxapp06
huge-ram     up   infinite      1   idle uxaplgnmxapp05
```

**What the columns mean:**

| Column | Meaning |
|--------|---------|
| `PARTITION` | A named group of nodes, often grouped by time limit or resource type |
| `AVAIL` | Whether the partition is currently accepting jobs (`up` or `down`) |
| `TIMELIMIT` | Maximum allowed run time for jobs on that partition |
| `NODES` | Number of nodes in that state |
| `STATE` | `idle` = free and waiting; `alloc` = fully in use; `mix` = partially used |

A `*` next to a partition name means it is the default — your jobs go there if you do not specify one.

To see more detail about individual nodes:

```bash
sinfo -N -l
```

---

## 5. Interactive Jobs — Working Live on a Compute Node

An **interactive job** gives you a command prompt directly on a compute node. This is useful when you are:

- Testing a new script and want to see errors immediately
- Exploring a dataset interactively in R or Python
- Troubleshooting why a batch job failed

### Starting an interactive session

```bash
srun --pty --partition=vm-cpu --cpus-per-task=2 --mem=8G --time=02:00:00 /bin/bash
```

Breaking this down:

| Option | What it does |
|--------|-------------|
| `--pty` | Gives you an interactive terminal |
| `--partition=vm-cpu` | Use the "vm-cpu" partition |
| `--cpus-per-task=2` | Request 2 CPU cores |
| `--mem=8G` | Request 8 GB of RAM |
| `--time=02:00:00` | Session will last at most 2 hours |
| `/bin/bash` | Start a bash shell |

Once the session starts, your prompt will change to show you are on a compute node, for example:

```
 [xiaolidong@uxaplgnmxapp02 ~]$
```

You can now run your analyses freely. When you are done, type `exit` to return to the login node.

> **Tip:** If you request more time or memory than you actually need, your job may wait longer in the queue. Start modest and scale up once you know your requirements.

---

## 6. Batch Jobs — Submitting Work to Run in the Background

A **batch job** is a script you submit to Slurm that runs without you watching it. This is the most common way to use a cluster — you submit your job, log off, and come back later to see the results.

### Writing a batch script

A batch script is a plain text file with two parts:
1. **Slurm directives** at the top (lines starting with `#SBATCH`) telling Slurm what resources you need
2. **The commands** you want to run

Here is a simple template:
**`my_analysis.sh`**

```
#!/bin/bash

#SBATCH --job-name=give_a_uniq_name_for_your_job      # A name to identify your job
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8                             # Number of CPU cores
#SBATCH --time=3-00:00:00                             # Max run time (D-HH:MM:SS)
#SBATCH --mem=8G                                      # Memory needed
#SBATCH --partition=vm-cpu                            # Which partition to use
#SBATCH -o slurm-%j.out                               # Where to save standard output (%j = job ID)
#SBATCH -e slurm-%j.err                               # Where to save error messages
#SBATCH --mail-user=your_email_address               
#SBATCH --mail-type==END,FAIL                         # Email me when job finishes or fails

# ---- Your commands go below this line ----

# ---------------------------------------------------------------------
echo "Current working directory: `pwd`"
echo "Starting run at: `date`"
# ---------------------------------------------------------------------

your_command_to_run_goes_here

# ---------------------------------------------------------------------
echo "Job finished with exit code $? at: `date`"
# ---------------------------------------------------------------------
```

### Submitting the batch script

```bash
sbatch my_analysis.sh
```

Slurm will respond with:

```
Submitted batch job 487312
```

That number is your **job ID** — keep it handy, you will use it to check status or cancel the job.

### A Python example

**`run_model.sh`**
```bash
#!/bin/bash
#SBATCH --job-name=cox_model
#SBATCH --partition=long
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --output=logs/cox_%j.out
#SBATCH --error=logs/cox_%j.err

module load python/3.11

cd /home/jsmith/projects/survival_study

python fit_cox_model.py --input data/cohort.csv --output results/
```

> **Tip:** Always create your `logs/` directory before submitting: `mkdir -p logs`

---

## 7. Managing Your Jobs: `squeue` and `scancel`

### Checking your job queue with `squeue`

```bash
squeue --me
```

This shows only your jobs. Example output:

```
JOBID    PARTITION  NAME          USER    ST  TIME      NODES  NODELIST
487312   short      epi_analysis  jsmith  R   0:12:34   1      node03
487398   long       cox_model     jsmith  PD  0:00:00   1      (Priority)
```

**What the columns mean:**

| Column | Meaning |
|--------|---------|
| `JOBID` | Your job's unique ID number |
| `ST` | Status: `R` = Running, `PD` = Pending (waiting), `CG` = Completing |
| `TIME` | How long the job has been running |
| `NODELIST` | Which node it is running on, or why it is waiting |

Common reasons a job is pending (`PD`):

| Reason | What it means |
|--------|---------------|
| `(Priority)` | Other jobs are ahead of yours in the queue |
| `(Resources)` | Waiting for enough CPUs/memory to become free |
| `(Dependency)` | Waiting for another job to finish first |

To see all jobs on the cluster (not just yours):

```bash
squeue
```

To refresh automatically every 5 seconds:

```bash
watch -n 5 squeue --me
```

Press `Ctrl+C` to stop watching.

### Cancelling a job with `scancel`

If you need to stop a job that is running or pending:

```bash
scancel 487312
```

To cancel all of your jobs at once:

```bash
scancel --me
```

To cancel all your pending jobs but keep running ones:

```bash
scancel --me --state=PENDING
```

---

## 8. Inspecting Jobs in Detail with `scontrol`

`scontrol` lets you look at detailed information about a job that is currently running or pending.

```bash
scontrol show job 487312
```

This produces a long block of information. The most useful fields for everyday use:

```
JobId=487312 JobName=epi_analysis
   UserId=jsmith(1001) GroupId=research(2001)
   JobState=RUNNING Reason=None
   NumNodes=1 NumCPUs=4 NumTasks=1 CPUs/Task=4
   SubmitTime=2024-03-15T09:00:00 StartTime=2024-03-15T09:02:00
   TimeLimit=02:00:00 EndTime=2024-03-15T11:02:00
   NodeList=node03
   mem=16G
   StdOut=/home/jsmith/projects/epi_study/logs/job_487312.out
   StdErr=/home/jsmith/projects/epi_study/logs/job_487312.err
```

**Useful fields explained:**

| Field | Meaning |
|-------|---------|
| `JobState` | Current state of the job |
| `StartTime` / `EndTime` | When it started and its projected end time |
| `TimeLimit` | Maximum allowed run time |
| `NodeList` | Which compute node it is running on |
| `StdOut` / `StdErr` | Where output and error messages are being written |

To see information about a node:

```bash
scontrol show node node03
```

This tells you how many CPUs and how much memory that node has, and what is currently allocated on it.

---

## 9. Viewing Your Job History and Resource Usage with `sacct`

`sacct` queries the **accounting database** — a record of all jobs you have run, including ones that have already finished. This is very useful for understanding how much memory or time your analyses actually use.

### Basic usage

```bash
# or you can put your username explicitly to replace $USER
sacct -u $USER
```

To see jobs from a specific time period:

```bash
# or you can put your username explicitly to replace $USER
sacct  -u $USER--starttime=2026-03-01 --endtime=2026-04-15
```

### Viewing resource usage

The default output is minimal. Use `--format` to choose what columns to display:

```bash
sacct -u $USER --format=JobID,JobName,State,Elapsed,CPUTime,MaxRSS,ReqMem
```

Example output:

```
JobID     JobName       State      Elapsed    CPUTime   MaxRSS   ReqMem
--------- ------------- ---------- ---------- --------- -------- -------
487312    epi_analysis  COMPLETED  00:18:42   01:14:48  6200M    16G
487398    cox_model     FAILED     00:02:05   00:16:40  2100M    32G
487400    cox_model     COMPLETED  02:44:11   21:53:28  28400M   32G
```

**Key columns:**

| Column | Meaning |
|--------|---------|
| `State` | `COMPLETED` = finished successfully; `FAILED` = exited with an error; `CANCELLED` = you or an admin cancelled it; `TIMEOUT` = ran out of time |
| `Elapsed` | Actual wall-clock time the job ran |
| `MaxRSS` | Peak memory usage — very useful for tuning future jobs |
| `ReqMem` | Memory you requested |

> **Tip:** Compare `MaxRSS` to `ReqMem`. If you requested 32G but only used 6G, you can reduce your memory request next time — your job will likely start sooner.

### Checking why a job failed

```bash
sacct -u $USER --jobs=487398 --format=JobID,State,ExitCode,DerivedExitCode
```

An `ExitCode` of `0:0` means success. Anything else indicates an error — check your `.err` log file for details.

---

## 10. Understanding Accounts and Allocations with `sacctmgr`

`sacctmgr` is an administrative tool that manages **accounts** (billing units that group users together, often by research group or grant). Most users will use it in read-only mode to understand what accounts they belong to and what resources are available.

### Seeing your account(s)

```bash
sacctmgr show user $USER withassoc
```

Example output:

```
User    Account       Partition  Share  MaxJobs  MaxSubmit
------- ------------- ---------- ------ -------- ---------
jsmith  epi_lab       short      1      100      500
jsmith  epi_lab       long       1      20       50
```

This tells you which accounts you belong to (`epi_lab`) and any limits on how many jobs you can run or submit at once.

### Viewing all accounts on the cluster

```bash
sacctmgr show accounts
```

### Viewing resource limits for your account

```bash
sacctmgr show association where user=$USER
```

> **Note:** Most users do not have permission to *change* anything with `sacctmgr` — that is an administrator task. Contact your system administrator if you need to be added to an account or if your account limits seem incorrect.

---

## 11. Quick Reference Cheat Sheet

| Task | Command |
|------|---------|
| Check cluster status | `sinfo` |
| Start an interactive session | `srun --pty --partition=short --mem=8G --time=1:00:00 /bin/bash` |
| Submit a batch job | `sbatch my_script.sh` |
| Check your running/pending jobs | `squeue --me` |
| Cancel a job | `scancel <jobid>` |
| Cancel all your jobs | `scancel --me` |
| Inspect a running job | `scontrol show job <jobid>` |
| View job history | `sacct -u $USER --starttime=2024-03-01` |
| View resource usage of past jobs | `sacct -u $USER --format=JobID,JobName,State,Elapsed,MaxRSS,ReqMem` |
| View your account associations | `sacctmgr show user $USER withassoc` |
| Watch your jobs update live | `watch -n 5 squeue --me` |

---

## 12. Common Problems and Solutions

**My job has been pending for a long time**

First check why it is waiting:
```bash
squeue --me
```
Look at the reason in the last column. If it says `(Resources)`, the cluster is busy — your job will start when enough resources free up. If you need results sooner, try requesting fewer CPUs or less memory, or use a shorter time limit, as smaller jobs often find gaps in the schedule faster.

---

**My job failed immediately**

Check the error log file specified in `--error`:
```bash
cat logs/job_487398.err
```


---

**I got an email saying my job was killed (TIMEOUT)**

Your analysis took longer than the time limit you set. Resubmit with a longer `--time` value. Use `sacct` to see how long similar jobs have taken in the past:
```bash
sacct -u $USER--format=JobID,JobName,Elapsed --starttime=2026-01-01
```

---

**I accidentally ran something heavy on the login node**

Find and stop it immediately:
```bash
top         # Look for your process using lots of CPU
kill <PID>  # Replace <PID> with the process ID shown in top
```
Then resubmit it properly as a batch or interactive job.

---

**I do not know what partitions are available or how long I can run**

```bash
sinfo -s
```
This gives a compact summary of all partitions and their time limits. Ask your system administrator if you are unsure which partition is appropriate for your work.

---

*For further help, contact your HPC support team or consult your cluster's internal documentation.*
