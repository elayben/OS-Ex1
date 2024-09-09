// Elay Ben Yehoshua 214795668
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

#define MAX_COMMANDS 100
#define MAX_COMMAND_LENGTH 100

char command_history[MAX_COMMANDS][MAX_COMMANDS];
int command_count = 0;


void add_to_history(char *command) {
    int command_length = strlen(command);
    if (command_count < MAX_COMMANDS && command_length <= 100) {

        for (int i = 0; i < command_length; i++)
        {
            command_history[command_count][i] = command[i];
        }
        command_count++;
        command_history[command_count][command_length] = '\0';
        
    }
}

void print_history() {
    for (int i = 0; i < command_count; i++) {
        printf("%s\n", command_history[i]);
    }
}

void change_directory(char *path) {
    if (chdir(path) != 0) {
        perror("chdir failed");
    }
}

void print_working_directory() {
    char cwd[100];
    //check if success
    if (getcwd(cwd, sizeof(cwd)) != NULL) {
        printf("%s\n", cwd);
    } else {
        //failed
        perror("pwd failed");
    }
}

void execute_command(char **args) {
    pid_t pid;
    int status;

    pid = fork();
    if (pid == 0) {
        // Child process
        if (execvp(args[0], args) == -1) {
            perror("execvp failed");
        }
        exit(EXIT_FAILURE);
    }  else {
        // Parent process
        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid failed");
        }
    }
}


int main(int argc, char *argv[]) {
    char command[MAX_COMMAND_LENGTH];
    char *args[MAX_COMMANDS];
    char *token;
    int i;

    while (1) {
        printf("$ ");
        fflush(stdout);

        if (fgets(command, sizeof(command), stdin) == NULL) {
            perror("fgets failed");
            continue;
        }

        command[strcspn(command, "\n")] = '\0';
        // Add command to history
        add_to_history(command);

        
        i = 0;
        token = strtok(command, " ");
        while (token != NULL) {
            args[i++] = token;
            token = strtok(NULL, " ");
        }
        args[i] = NULL;

        if (strcmp(args[0], "exit") == 0)
        {
            break;
        }
        else if (strcmp(args[0], "history") == 0)
        {
            print_history();
        }
        else if
        (strcmp(args[0], "cd") == 0)
        {
            if (args[1] == NULL)
            {
                //perror( "cd failed: missing argument\n");
            } else
            {
                change_directory(args[1]);
            }
        }
        else if (strcmp(args[0], "pwd") == 0)
        {
            print_working_directory();
        }
        else
        {
            execute_command(args);
        }
    }
    return 0;
}