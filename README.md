# Chess Game Simulation and Shell Implementation

## Overview

This project is divided into three main parts, each focusing on different aspects of operating systems and programming:

1. **Part 1: PGN File Splitter (Bash Script)**
2. **Part 2: Chess Simulator (Bash Script with Python Integration)**
3. **Part 3: Custom Shell Implementation in C**

Each part explores key concepts such as scripting, file processing, interactive command-line programs, and process management in Unix-like systems. Below is a summary of each part and its objectives.

---

## Part 1: PGN File Splitter (Bash Script)

In this part, I created a Bash script named `pgn_split.sh` to process chess games recorded in PGN (Portable Game Notation) format. The goal of the script is to split multiple chess games from a single PGN file into separate files within a specified destination directory.

### Key Features:
- **Argument Handling**: The script takes two arguments: the source PGN file and the destination directory for the split files.
- **Validation**: It checks for the correct number of arguments and verifies the existence of the source file and destination directory.
- **File Operations**: The script creates the destination directory if it doesn't exist and splits the games into individual files.
- **Example Usage**:
  ```bash
  ./pgn_split.sh source_file.pgn destination_directory

  
## Part 2: Chess Simulator (Bash Script with Python Integration)

The second part of the project involved developing a chess simulator script `chess_sim.sh`, which simulates chess games using PGN files. This script interacts with a Python script (`parse_moves.py`) that converts chess moves from PGN to UCI (Universal Chess Interface) format for easier manipulation.

### Key Features:
- **PGN Parsing**: Reads chess games from PGN files and displays the moves in the terminal.
- **Move Simulation**: Allows the user to interact with the game by moving forward, backward, jumping to the start or end, or quitting.
- **Python Integration**: Utilizes a Python script to convert PGN chess moves into UCI format.
- **User Controls**:
  - `'d'`: Move forward
  - `'a'`: Move back
  - `'w'`: Go to the start
  - `'s'`: Go to the end
  - `'q'`: Quit the simulation

### Example Usage:
```bash
  ./chess_sim.sh chess_game.pgn
```


## Part 3: Custom Shell Implementation in C

In the final part of the project, I implemented a custom shell named `myshell.c`. This shell can execute basic Unix commands like `ls`, `cat`, and `pwd`, without supporting pipes or complex commands. The shell was built using `fork()` and `exec()` to create child processes and execute commands.

### Key Features:
- **Command Execution**: Executes simple Unix commands from directories passed as arguments or from the `$PATH` variable.
- **Built-in Commands**:
  - `history`: Displays the list of commands executed in the session.
  - `cd`: Changes the current working directory.
  - `pwd`: Prints the current working directory.
  - `exit`: Exits the shell.
- **Error Handling**: The shell uses `perror()` to display errors when system calls fail.
- **Foreground Execution**: All commands are executed in the foreground, and the shell waits for them to finish.

### Example Usage:
```bash
./myshell /path/to/executables

