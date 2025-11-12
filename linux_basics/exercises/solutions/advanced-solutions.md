# Advanced Exercise Solutions

Solutions for advanced workflow exercises. These combine all skills learned in beginner and intermediate sections into complete bioinformatics pipelines.

---

## Complete Workflow Examples

### Workflow 1: RNA-Seq Quality Control Pipeline

**Goal:** Complete QC pipeline from raw FASTQ to quality report.

```bash
#!/bin/bash
# rna_seq_qc.sh - Complete RNA-Seq QC Pipeline

set -e  # Exit on error
set -u  # Exit on undefined variable

# Configuration
FASTQ_DIR="raw_data"
OUTPUT_DIR="qc_results"
LOG="qc_pipeline.log"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Start logging
echo "=== RNA-Seq QC Pipeline ===" | tee "$LOG"
echo "Started: $(date)" | tee -a "$LOG"

# Count total samples
TOTAL=$(ls $FASTQ_DIR/*.fastq.gz | wc -l)
echo "Total FASTQ files: $TOTAL" | tee -a "$LOG"

# Process each file
for fastq in $FASTQ_DIR/*.fastq.gz; do
    SAMPLE=$(basename "$fastq" .fastq.gz)
    echo "Processing $SAMPLE..." | tee -a "$LOG"
    
    # Count reads
    READS=$(zcat "$fastq" | wc -l | awk '{print $1/4}')
    echo "  Reads: $READS" | tee -a "$LOG"
    
    # Check for N bases
    N_COUNT=$(zcat "$fastq" | awk 'NR%4==2' | grep -o 'N' | wc -l)
    echo "  N bases: $N_COUNT" | tee -a "$LOG"
    
    # Average read length
    AVG_LEN=$(zcat "$fastq" | awk 'NR%4==2 {sum+=length($0); count++} END {print sum/count}')
    echo "  Avg length: $AVG_LEN" | tee -a "$LOG"
    
    # Quality check (count low quality bases)
    LOW_QUAL=$(zcat "$fastq" | awk 'NR%4==0' | grep -o '!' | wc -l)
    echo "  Low quality bases: $LOW_QUAL" | tee -a "$LOG"
    
    # Save sample report
    {
        echo "Sample: $SAMPLE"
        echo "Reads: $READS"
        echo "N bases: $N_COUNT"
        echo "Avg length: $AVG_LEN"
        echo "Low qual: $LOW_QUAL"
    } > "$OUTPUT_DIR/${SAMPLE}_report.txt"
done

# Generate summary
{
    echo "=== QC Summary ==="
    echo "Completed: $(date)"
    echo "Total samples processed: $TOTAL"
    echo ""
    echo "Individual reports saved in: $OUTPUT_DIR"
} | tee -a "$LOG"

echo "Pipeline complete!" | tee -a "$LOG"
```

---

### Workflow 2: Variant Calling QC and Filtering

**Goal:** Filter and annotate variants with comprehensive QC.

```bash
#!/bin/bash
# variant_qc_filter.sh - Variant QC and Filtering Pipeline

INPUT_VCF="raw_variants.vcf"
OUTPUT_VCF="filtered_variants.vcf"
STATS_DIR="variant_stats"

mkdir -p "$STATS_DIR"

echo "=== Variant Filtering Pipeline ==="
echo "Input: $INPUT_VCF"
echo "Output: $OUTPUT_VCF"

# Step 1: Basic statistics
echo "Calculating basic statistics..."
{
    echo "=== Raw Variant Statistics ==="
    echo "Total variants: $(grep -vc "^#" $INPUT_VCF)"
    echo "SNPs: $(awk '$1!~/^#/ && length($4)==1 && length($5)==1' $INPUT_VCF | wc -l)"
    echo "INDELs: $(awk '$1!~/^#/ && (length($4)>1 || length($5)>1)' $INPUT_VCF | wc -l)"
    echo ""
    echo "Variants per chromosome:"
    grep -v "^#" $INPUT_VCF | cut -f1 | sort | uniq -c | sort -rn
} > "$STATS_DIR/raw_stats.txt"

# Step 2: Quality filtering
echo "Filtering variants (QUAL > 30)..."
awk '$1~/^#/ || $6>30' $INPUT_VCF > temp_qual_filtered.vcf

# Step 3: Depth filtering (example: DP > 10 in INFO field)
echo "Filtering by depth..."
awk '$1~/^#/ || $0~/DP=[0-9]*/ {
    if ($1~/^#/) {print; next}
    match($0, /DP=([0-9]+)/, dp)
    if (dp[1] > 10) print
}' temp_qual_filtered.vcf > "$OUTPUT_VCF"

# Step 4: Post-filtering statistics
echo "Calculating filtered statistics..."
{
    echo "=== Filtered Variant Statistics ==="
    echo "Total variants: $(grep -vc "^#" $OUTPUT_VCF)"
    echo "SNPs: $(awk '$1!~/^#/ && length($4)==1 && length($5)==1' $OUTPUT_VCF | wc -l)"
    echo "INDELs: $(awk '$1!~/^#/ && (length($4)>1 || length($5)>1)' $OUTPUT_VCF | wc -l)"
    echo ""
    echo "Variants per chromosome:"
    grep -v "^#" $OUTPUT_VCF | cut -f1 | sort | uniq -c | sort -rn
} > "$STATS_DIR/filtered_stats.txt"

# Step 5: Quality distribution
echo "Analyzing quality distribution..."
grep -v "^#" $OUTPUT_VCF | cut -f6 | sort -n | \
    awk '{
        sum+=$1; count++; 
        vals[count]=$1
    } 
    END {
        print "Mean QUAL:", sum/count
        print "Median QUAL:", vals[int(count/2)]
        print "Min QUAL:", vals[1]
        print "Max QUAL:", vals[count]
    }' > "$STATS_DIR/quality_stats.txt"

# Step 6: Transition/Transversion ratio (for SNPs)
echo "Calculating Ti/Tv ratio..."
grep -v "^#" $OUTPUT_VCF | \
    awk 'length($4)==1 && length($5)==1 {
        if (($4=="A" && $5=="G") || ($4=="G" && $5=="A") ||
            ($4=="C" && $5=="T") || ($4=="T" && $5=="C")) {
            ti++
        } else {
            tv++
        }
    }
    END {
        print "Transitions:", ti
        print "Transversions:", tv
        print "Ti/Tv ratio:", ti/tv
    }' > "$STATS_DIR/titv_ratio.txt"

# Cleanup
rm temp_qual_filtered.vcf

echo "Pipeline complete!"
echo "Filtered VCF: $OUTPUT_VCF"
echo "Statistics in: $STATS_DIR"
```

---

### Workflow 3: Gene Expression Analysis Pipeline

**Goal:** Process expression data from raw counts to normalized values.

```bash
#!/bin/bash
# expression_analysis.sh - Gene Expression Analysis

INPUT="raw_counts.tsv"
OUTPUT_DIR="expression_results"

mkdir -p "$OUTPUT_DIR"

echo "=== Gene Expression Analysis Pipeline ==="

# Step 1: Basic statistics
echo "Calculating basic statistics..."
{
    echo "=== Raw Count Statistics ==="
    echo "Total genes: $(tail -n +2 $INPUT | wc -l)"
    echo "Total samples: $(($(head -1 $INPUT | wc -w) - 1))"
    
    # Genes with zero counts across all samples
    ZERO_GENES=$(awk 'NR>1 {
        sum=0
        for(i=2; i<=NF; i++) sum+=$i
        if(sum==0) count++
    } END {print count}' $INPUT)
    echo "Genes with zero counts: $ZERO_GENES"
} > "$OUTPUT_DIR/basic_stats.txt"

# Step 2: Filter low-count genes (sum < 10 across all samples)
echo "Filtering low-count genes..."
awk 'NR==1 {print; next}
     {
         sum=0
         for(i=2; i<=NF; i++) sum+=$i
         if(sum >= 10) print
     }' $INPUT > "$OUTPUT_DIR/filtered_counts.tsv"

echo "Filtered: $(tail -n +2 $OUTPUT_DIR/filtered_counts.tsv | wc -l) genes remain"

# Step 3: Calculate TPM normalization (simplified)
echo "Calculating normalized values..."
awk 'NR==1 {print; next}
     {
         printf "%s", $1
         for(i=2; i<=NF; i++) {
             # Simple normalization: (count/sum)*1e6
             printf "\t%.2f", ($i/10000)*1e6  # Simplified
         }
         printf "\n"
     }' "$OUTPUT_DIR/filtered_counts.tsv" > "$OUTPUT_DIR/normalized_counts.tsv"

# Step 4: Find highly expressed genes (top 10)
echo "Finding highly expressed genes..."
awk 'NR>1 {
    sum=0
    for(i=2; i<=NF; i++) sum+=$i
    avg=sum/(NF-1)
    print $1, avg
}' "$OUTPUT_DIR/normalized_counts.tsv" | \
    sort -k2,2nr | \
    head -10 > "$OUTPUT_DIR/top_expressed.txt"

# Step 5: Calculate coefficient of variation
echo "Calculating variation statistics..."
awk 'NR>1 {
    sum=0; sumsq=0; n=NF-1
    for(i=2; i<=NF; i++) {
        sum+=$i
        sumsq+=$i*$i
    }
    mean=sum/n
    variance=(sumsq/n)-(mean*mean)
    sd=sqrt(variance)
    cv=sd/mean
    print $1, mean, sd, cv
}' "$OUTPUT_DIR/normalized_counts.tsv" | \
    sort -k4,4nr | \
    head -20 > "$OUTPUT_DIR/high_variation_genes.txt"

# Step 6: Generate summary report
{
    echo "=== Expression Analysis Summary ==="
    echo "Date: $(date)"
    echo ""
    echo "Input file: $INPUT"
    echo "Raw genes: $(tail -n +2 $INPUT | wc -l)"
    echo "Filtered genes: $(tail -n +2 $OUTPUT_DIR/filtered_counts.tsv | wc -l)"
    echo ""
    echo "Top 5 most highly expressed genes:"
    head -5 "$OUTPUT_DIR/top_expressed.txt"
    echo ""
    echo "Results saved in: $OUTPUT_DIR"
} > "$OUTPUT_DIR/summary_report.txt"

echo "Analysis complete!"
cat "$OUTPUT_DIR/summary_report.txt"
```

---

### Workflow 4: Multi-Sample FASTQ Processing

**Goal:** Process multiple paired-end samples with error handling.

```bash
#!/bin/bash
# multi_sample_processor.sh - Batch FASTQ Processing

set -e
set -o pipefail

# Configuration
SAMPLE_LIST="samples.txt"
INPUT_DIR="raw_fastq"
OUTPUT_DIR="processed"
LOG_DIR="logs"
THREADS=4

# Create directories
mkdir -p "$OUTPUT_DIR" "$LOG_DIR"

# Initialize summary
SUMMARY="processing_summary.txt"
echo "=== Multi-Sample Processing Summary ===" > "$SUMMARY"
echo "Started: $(date)" >> "$SUMMARY"
echo "" >> "$SUMMARY"

SUCCESS=0
FAILED=0

# Process each sample
while read SAMPLE; do
    echo "Processing $SAMPLE..."
    
    R1="$INPUT_DIR/${SAMPLE}_R1.fastq.gz"
    R2="$INPUT_DIR/${SAMPLE}_R2.fastq.gz"
    LOG="$LOG_DIR/${SAMPLE}.log"
    
    # Check if files exist
    if [ ! -f "$R1" ] || [ ! -f "$R2" ]; then
        echo "  ERROR: Files not found for $SAMPLE" | tee -a "$SUMMARY"
        FAILED=$((FAILED + 1))
        continue
    fi
    
    # Count reads
    echo "  Counting reads..." | tee -a "$LOG"
    R1_READS=$(zcat "$R1" | wc -l | awk '{print $1/4}')
    R2_READS=$(zcat "$R2" | wc -l | awk '{print $1/4}')
    
    if [ "$R1_READS" != "$R2_READS" ]; then
        echo "  ERROR: Read counts don't match (R1: $R1_READS, R2: $R2_READS)" | tee -a "$SUMMARY"
        FAILED=$((FAILED + 1))
        continue
    fi
    
    echo "  Reads: $R1_READS" | tee -a "$LOG"
    
    # Quality filtering (simple example: remove reads with N)
    echo "  Filtering..." | tee -a "$LOG"
    
    zcat "$R1" | paste - - - - | \
        awk -F'\t' '$2 !~ /N/ {print $1"\n"$2"\n"$3"\n"$4}' | \
        gzip > "$OUTPUT_DIR/${SAMPLE}_R1_filtered.fastq.gz"
    
    zcat "$R2" | paste - - - - | \
        awk -F'\t' '$2 !~ /N/ {print $1"\n"$2"\n"$3"\n"$4}' | \
        gzip > "$OUTPUT_DIR/${SAMPLE}_R2_filtered.fastq.gz"
    
    # Count filtered reads
    FILTERED=$(zcat "$OUTPUT_DIR/${SAMPLE}_R1_filtered.fastq.gz" | wc -l | awk '{print $1/4}')
    REMOVED=$((R1_READS - FILTERED))
    PERCENT=$(echo "scale=2; ($REMOVED/$R1_READS)*100" | bc)
    
    echo "  Filtered: $FILTERED reads remain ($REMOVED removed, ${PERCENT}%)" | tee -a "$LOG"
    
    # Record in summary
    {
        echo "Sample: $SAMPLE"
        echo "  Status: SUCCESS"
        echo "  Raw reads: $R1_READS"
        echo "  Filtered reads: $FILTERED"
        echo "  Removed: $REMOVED ($PERCENT%)"
        echo ""
    } >> "$SUMMARY"
    
    SUCCESS=$((SUCCESS + 1))
    
done < "$SAMPLE_LIST"

# Final summary
{
    echo "=== Processing Complete ==="
    echo "Finished: $(date)"
    echo ""
    echo "Successful: $SUCCESS"
    echo "Failed: $FAILED"
    echo "Total: $((SUCCESS + FAILED))"
} | tee -a "$SUMMARY"

echo ""
echo "Summary saved to: $SUMMARY"
```

---

### Workflow 5: Automated Backup and Archive System

**Goal:** Create dated backups with rotation and verification.

```bash
#!/bin/bash
# backup_system.sh - Automated Backup with Rotation

set -e

# Configuration
SOURCE_DIR="$HOME/bioinformatics_data"
BACKUP_ROOT="$HOME/backups"
RETENTION_DAYS=90
DATE=$(date +%Y%m%d)
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Create backup directory structure
BACKUP_DIR="$BACKUP_ROOT/$DATE"
mkdir -p "$BACKUP_DIR"

LOG="$BACKUP_ROOT/backup.log"

echo "[$TIMESTAMP] Starting backup..." | tee -a "$LOG"

# Determine backup type (full on 1st of month, incremental otherwise)
if [ "$(date +%d)" = "01" ]; then
    BACKUP_TYPE="full"
    ARCHIVE_NAME="full_backup_$DATE.tar.gz"
else
    BACKUP_TYPE="incremental"
    ARCHIVE_NAME="incremental_backup_$DATE.tar.gz"
fi

echo "[$TIMESTAMP] Backup type: $BACKUP_TYPE" | tee -a "$LOG"

# Create backup
if [ "$BACKUP_TYPE" = "full" ]; then
    # Full backup
    tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" \
        -C "$SOURCE_DIR" . \
        2>> "$LOG"
else
    # Incremental backup (files changed in last day)
    tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" \
        -C "$SOURCE_DIR" \
        --newer-mtime="1 day ago" . \
        2>> "$LOG"
fi

# Verify archive
if tar -tzf "$BACKUP_DIR/$ARCHIVE_NAME" > /dev/null 2>&1; then
    echo "[$TIMESTAMP] Backup verified: $ARCHIVE_NAME" | tee -a "$LOG"
else
    echo "[$TIMESTAMP] ERROR: Backup verification failed!" | tee -a "$LOG"
    exit 1
fi

# Calculate size
SIZE=$(du -h "$BACKUP_DIR/$ARCHIVE_NAME" | cut -f1)
echo "[$TIMESTAMP] Backup size: $SIZE" | tee -a "$LOG"

# Generate checksum
md5sum "$BACKUP_DIR/$ARCHIVE_NAME" > "$BACKUP_DIR/$ARCHIVE_NAME.md5"
echo "[$TIMESTAMP] Checksum generated" | tee -a "$LOG"

# Rotate old backups
echo "[$TIMESTAMP] Removing backups older than $RETENTION_DAYS days..." | tee -a "$LOG"
find "$BACKUP_ROOT" -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete
find "$BACKUP_ROOT" -name "*.md5" -mtime +$RETENTION_DAYS -delete

# Cleanup empty directories
find "$BACKUP_ROOT" -type d -empty -delete

# Summary
{
    echo ""
    echo "=== Backup Summary ==="
    echo "Type: $BACKUP_TYPE"
    echo "Archive: $ARCHIVE_NAME"
    echo "Size: $SIZE"
    echo "Location: $BACKUP_DIR"
    echo ""
    echo "Current backups:"
    ls -lh "$BACKUP_ROOT"/*/*.tar.gz 2>/dev/null | tail -10
} | tee -a "$LOG"

echo "[$TIMESTAMP] Backup complete!" | tee -a "$LOG"
```

---

## Advanced Techniques

### Technique 1: Parallel Processing

```bash
#!/bin/bash
# parallel_processor.sh - Process multiple files in parallel

MAX_JOBS=4  # Number of parallel jobs

# Function to process one file
process_file() {
    local file=$1
    local output="${file%.fastq.gz}_processed.txt"
    
    echo "Processing $file..."
    
    # Simulate processing
    zcat "$file" | \
        awk 'NR%4==2 {print length}' | \
        awk '{sum+=$1; count++} END {print count, sum/count}' \
        > "$output"
    
    echo "Completed $file"
}

export -f process_file

# Process files in parallel
ls *.fastq.gz | xargs -n 1 -P $MAX_JOBS bash -c 'process_file "$@"' _
```

### Technique 2: Error Recovery

```bash
#!/bin/bash
# error_recovery.sh - Pipeline with checkpoints and recovery

set -u

CHECKPOINT_DIR="checkpoints"
mkdir -p "$CHECKPOINT_DIR"

# Function to check if step is complete
step_complete() {
    [ -f "$CHECKPOINT_DIR/$1.done" ]
}

# Function to mark step complete
mark_complete() {
    touch "$CHECKPOINT_DIR/$1.done"
}

# Step 1: Download data
if ! step_complete "download"; then
    echo "Downloading data..."
    # download commands here
    mark_complete "download"
else
    echo "Skipping download (already complete)"
fi

# Step 2: Quality control
if ! step_complete "qc"; then
    echo "Running QC..."
    # QC commands here
    mark_complete "qc"
else
    echo "Skipping QC (already complete)"
fi

# Step 3: Analysis
if ! step_complete "analysis"; then
    echo "Running analysis..."
    # analysis commands here
    mark_complete "analysis"
else
    echo "Skipping analysis (already complete)"
fi

echo "Pipeline complete!"
```

### Technique 3: Configuration Management

```bash
#!/bin/bash
# configurable_pipeline.sh - Pipeline with external configuration

CONFIG_FILE="pipeline.conf"

# Load configuration
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Error: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# Validate configuration
: ${INPUT_DIR:?"INPUT_DIR not set"}
: ${OUTPUT_DIR:?"OUTPUT_DIR not set"}
: ${THREADS:=4}  # Default to 4 if not set

echo "Configuration loaded:"
echo "  Input: $INPUT_DIR"
echo "  Output: $OUTPUT_DIR"
echo "  Threads: $THREADS"

# Run pipeline with configuration
# ... pipeline code here ...
```

**Example pipeline.conf:**
```bash
# Pipeline Configuration
INPUT_DIR="/data/raw_fastq"
OUTPUT_DIR="/data/processed"
THREADS=8
QUALITY_THRESHOLD=30
MIN_READ_LENGTH=50
```

---

## Best Practices Summary

### Script Structure
```bash
#!/bin/bash
# Script name and description
# Author and date

# Exit on error
set -e
set -u
set -o pipefail

# Configuration section
VARIABLE1="value1"
VARIABLE2="value2"

# Function definitions
function_name() {
    # Function code
}

# Main script logic
main() {
    # Main code
}

# Run main function
main "$@"
```

### Error Handling
```bash
# Check if command succeeded
if command; then
    echo "Success"
else
    echo "Failed"
    exit 1
fi

# Check file existence
if [ ! -f "file.txt" ]; then
    echo "Error: file.txt not found"
    exit 1
fi

# Trap errors
trap 'echo "Error on line $LINENO"' ERR
```

### Logging
```bash
# Function for logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOGFILE"
}

# Usage
log "Starting process..."
log "Processing $SAMPLE..."
log "Complete!"
```

---

## Key Takeaways

✅ **Use functions** for reusable code

✅ **Implement error handling** with set -e, checks, and traps

✅ **Log everything** for debugging and auditing

✅ **Use checkpoints** for long pipelines

✅ **Validate inputs** before processing

✅ **Generate summaries** for easy review

✅ **Handle edge cases** (missing files, empty data)

✅ **Make scripts configurable** with config files

✅ **Test on small data** before full runs

✅ **Document your code** with comments

---

**Advanced solutions complete!** 🎉

These workflows demonstrate production-ready bioinformatics pipelines combining all skills learned throughout the tutorial.
