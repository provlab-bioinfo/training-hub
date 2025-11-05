# Exercises

Hands-on practice exercises to reinforce your Linux command line skills. Work through these systematically to build confidence and competence.

## How to Use These Exercises

1. **Start with beginner exercises** - Even if you have some experience
2. **Do exercises in order** - They build on each other
3. **Try without looking at solutions** - Struggle is part of learning
4. **Check solutions afterward** - See alternative approaches
5. **Repeat challenging exercises** - Practice makes perfect
6. **Adapt exercises to your data** - Apply to real bioinformatics files

## Exercise Structure

### Beginner Exercises
- Basic navigation and file operations
- Viewing and searching files
- Simple text processing
- **Time estimate:** 2-3 hours total

### Intermediate Exercises
- Complex pipelines
- Text processing with awk/sed
- Working with real bioinformatics data
- **Time estimate:** 3-4 hours total

### Advanced Exercises
- Multi-step workflows
- Automation and scripting
- Performance optimization
- **Time estimate:** 4-6 hours total

## Getting Started

### Setup Practice Environment

Run this script to create a practice environment:

```bash
# Navigate to your home directory
cd ~

# Create exercise directory
mkdir -p linux_exercises
cd linux_exercises

# Create subdirectories
mkdir -p data/{raw,processed} scripts results logs

# Create some test files
echo "Ready to practice!" > README.txt
```

### Download Sample Data

If sample data files are provided in the repository:

```bash
# Copy sample data to your exercise directory
cp -r ../sample-data/* data/raw/
```

## Exercise Files

### Beginner Level
- [Navigation Exercises](beginner/01-navigation-exercises.md)
- [File Operations Exercises](beginner/02-file-operations-exercises.md)
- [Viewing Files Exercises](beginner/03-viewing-files-exercises.md)
- [Basic Searching Exercises](beginner/04-searching-exercises.md)

### Intermediate Level
- [Pipes and Redirects Exercises](intermediate/01-pipes-exercises.md)
- [Text Processing Exercises](intermediate/02-text-processing-exercises.md)
- [Compression Exercises](intermediate/03-compression-exercises.md)
- [FASTA/FASTQ Exercises](intermediate/04-sequence-files-exercises.md)

### Advanced Level
- [Complete Workflow Exercises](advanced/01-workflows-exercises.md)
- [Automation Exercises](advanced/02-automation-exercises.md)
- [Real Data Analysis](advanced/03-real-data-exercises.md)

## Solutions

Solutions are provided in the `solutions/` directory:
- [Beginner Solutions](solutions/beginner-solutions.md)
- [Intermediate Solutions](solutions/intermediate-solutions.md)
- [Advanced Solutions](solutions/advanced-solutions.md)

## Tips for Success

1. **Work in a test directory** - Don't practice on important data
2. **Use Tab completion** - Build the muscle memory
3. **Make mistakes** - That's how you learn
4. **Try multiple approaches** - There's usually more than one way
5. **Take notes** - Record commands that work well for you
6. **Ask for help** - Use man pages, search online, ask colleagues

## Progress Tracking

Mark your progress:

**Beginner:**
- [ ] Navigation (01)
- [ ] File Operations (02)
- [ ] Viewing Files (03)
- [ ] Basic Searching (04)

**Intermediate:**
- [ ] Pipes and Redirects (01)
- [ ] Text Processing (02)
- [ ] Compression (03)
- [ ] Sequence Files (04)

**Advanced:**
- [ ] Workflows (01)
- [ ] Automation (02)
- [ ] Real Data (03)

## Additional Practice

Once you complete these exercises:

1. **Apply to your research data** - Real problems are the best practice
2. **Create your own challenges** - Based on your needs
3. **Help others** - Teaching reinforces learning
4. **Contribute exercises** - Submit your own via pull request

## Getting Help

If you're stuck:
1. Review the relevant tutorial section
2. Check the man page: `man command`
3. Search online: "linux [your question]"
4. Ask in forums: Biostars, Unix StackExchange
5. Consult your system administrator

## Next Steps

After completing all exercises:
- Explore specialized bioinformatics tools
- Learn shell scripting for automation
- Study workflow management systems
- Practice with your own research data

---

**Remember:** The goal isn't to memorize commands, but to develop problem-solving skills and know where to look for help. Good luck! 🚀
