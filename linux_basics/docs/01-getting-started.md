# Getting Started

Welcome to your first steps in the Linux command line! This guide will help you connect to our Red Hat server and run your first commands.

## What is the Command Line?

The command line (also called terminal or shell) is a text-based interface where you type commands to tell the computer what to do. While it might seem less intuitive than clicking icons, it's much more powerful for handling biological data and running bioinformatics tools.

Think of it as having a conversation with the computer using a specific language. You type a command, press Enter, and the computer responds.

## Installing and Setting Up PuTTY

Most of our users work from Windows computers and use **PuTTY** to connect to the Linux server.

### First Time Installation

1. **Download PuTTY**
   - Visit: https://www.putty.org/
   - Download the installer (putty-installer.msi)
   - Run the installer and follow the prompts

2. **Launch PuTTY**
   - Find PuTTY in your Start menu
   - You'll see the PuTTY Configuration window

### Connecting to the Server

#### Step 1: Enter Server Details

In the PuTTY Configuration window:

```
Host Name (or IP address): your_server_address
Port: 22
Connection type: SSH
```

> **Note:** Replace `your_server_address` with the actual server address provided by your administrator.

#### Step 2: Save Your Session (Recommended)

Before clicking "Open":
1. In the "Saved Sessions" field, type a name like "BioServer"
2. Click the "Save" button
3. Next time, you can just double-click "BioServer" to connect!

#### Step 3: Connect

1. Click the "Open" button
2. **First time only:** You'll see a security alert about the server's key
   - Click "Accept" or "Yes" - this is normal and safe

#### Step 4: Login

You'll see a black terminal window:

```
login as:
```

1. Type your username and press **Enter**
2. Type your password and press **Enter**

> **Important:** When typing your password, you won't see any characters (not even dots or asterisks). This is a security feature. Just type your password and press Enter.

#### Step 5: Success!

If login is successful, you'll see a welcome message and then your **prompt**:

```
[username@server ~]$
```

This is where you'll type commands. The prompt shows:
- Your username
- The server name
- Your current directory (`~` means home directory)
- `$` indicates you're ready to type a command

## PuTTY Tips and Tricks

### Copy and Paste

PuTTY works differently from most Windows applications:

- **To Copy:** Simply highlight text with your mouse - it's automatically copied!
- **To Paste:** Right-click in the PuTTY window

### Adjusting Appearance

Before connecting, you can customize PuTTY:

1. **Font Size:** Window → Appearance → Font settings
2. **Colors:** Window → Colours → (choose your color scheme)
3. **Scrollback:** Window → Lines of scrollback (increase to 10000 for more history)

### Keeping Your Connection Alive

To prevent disconnection during long periods of inactivity:

1. In PuTTY Configuration, go to: Connection
2. Set "Seconds between keepalives" to **30**
3. Check "Enable TCP keepalives"
4. Save your session

### Saving Multiple Server Connections

If you work with multiple servers:

1. Enter server details for each one
2. Give each a different name in "Saved Sessions"
3. Click "Save" for each
4. Switch between servers by loading different saved sessions

## Your First Commands

Now that you're connected, let's try some basic commands!

### Finding Out Who You Are

```bash
whoami
```

This shows your username. Simple, but useful to confirm you're logged in correctly.

**Example output:**
```
jsmith
```

### Where Am I?

```bash
pwd
```

`pwd` stands for "Print Working Directory" - it shows your current location in the file system.

**Example output:**
```
/home/jsmith
```

This means you're in your home directory.

### What Time Is It?

```bash
date
```

Shows the current date and time on the server.

**Example output:**
```
Tue Nov  4 10:30:45 MST 2025
```

### What's Around Me?

```bash
ls
```

`ls` stands for "list" - it shows files and directories in your current location.

**Example output:**
```
Documents  Downloads  projects  sequences.fasta
```

### Getting Help

Every command has a manual page:

```bash
man ls
```

This opens the manual for the `ls` command. Use:
- **Arrow keys** or **Spacebar** to scroll
- **q** to quit and return to the prompt
- **/** then type text to search

For quick help:

```bash
ls --help
```

## Understanding Command Structure

Most Linux commands follow this pattern:

```bash
command -options arguments
```

For example:

```bash
ls -l /home/jsmith
```

- `ls` is the command (list files)
- `-l` is an option (use long format)
- `/home/jsmith` is an argument (which directory to list)

### Options Explained

Options modify how a command behaves:

```bash
ls              # Basic list
ls -l           # Long format (detailed)
ls -a           # Show all files (including hidden)
ls -lh          # Long format with human-readable sizes
ls -lth         # Long format, human-readable, sorted by time
```

You can combine options:
- `ls -l -h` is the same as `ls -lh`

## Common Mistakes (We All Make Them!)

### 1. Case Sensitivity

Linux is **case sensitive**. These are all different:

```bash
MyFile.txt
myfile.txt
MYFILE.TXT
```

### 2. Spaces in Names

Spaces in filenames are tricky. If a file is named "my file.txt":

```bash
cat my file.txt          # ❌ Wrong - sees two files
cat "my file.txt"        # ✓ Correct - use quotes
cat my\ file.txt         # ✓ Correct - escape the space
```

**Best practice:** Avoid spaces in filenames. Use underscores or hyphens:
- `my_file.txt` ✓
- `my-file.txt` ✓

### 3. Typos in Commands

If you see "command not found":

```bash
lst
-bash: lst: command not found
```

You probably meant `ls`. Check your spelling!

### 4. Forgetting Permissions

Sometimes you can't edit or delete a file because of permissions. We'll cover this in [Tutorial 8](08-permissions.md).

## Practice Exercises

Try these commands to get comfortable:

1. Find your username:
   ```bash
   whoami
   ```

2. Check your current directory:
   ```bash
   pwd
   ```

3. List files in your home directory:
   ```bash
   ls
   ```

4. List files with details:
   ```bash
   ls -lh
   ```

5. Check today's date:
   ```bash
   date
   ```

6. Read the manual for the `date` command:
   ```bash
   man date
   ```
   (press `q` to exit)

## Exiting and Disconnecting

When you're done working:

```bash
exit
```

Or simply close the PuTTY window.

Your session will end, but your files and data remain safely on the server.

## Troubleshooting

### Can't Connect to Server

- Check your internet connection
- Verify the server address is correct
- Ensure Port is set to 22
- Contact your administrator if server is down

### Password Not Working

- Remember, you won't see characters as you type
- Check Caps Lock isn't on
- Try typing your password in Notepad first to verify it, then copy and paste
- Contact administrator for password reset if needed

### Connection Times Out

- Check your network isn't blocking SSH (Port 22)
- Enable keepalives in PuTTY settings
- Try connecting from a different network

### Screen Shows Gibberish

- Go to PuTTY Configuration → Window → Translation
- Set "Remote character set" to UTF-8

## What's Next?

Now that you can connect and run basic commands, you're ready to learn about:

**[Next: Navigating the File System →](02-navigation.md)**

You'll learn how to move around directories, understand the Linux file structure, and find your way around like a pro!

## Quick Reference

| Command | What It Does |
|---------|--------------|
| `whoami` | Show your username |
| `pwd` | Show current directory |
| `ls` | List files |
| `date` | Show date and time |
| `man command` | Show manual for command |
| `exit` | Logout and close connection |

---

**Remember:** Everyone was a beginner once. Take your time, and don't be afraid to experiment. You can't break the server!
