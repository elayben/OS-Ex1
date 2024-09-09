#!/bin/bash
# Elay Ben Yehoshua 214795668
print_usage_and_exit() {
    echo "Usage: $0 <source_pgn_file> <destination_directory>"
    exit 1
}

print_file_not_exist_and_exit() {
    echo "Error: File '$src_file' does not exist."
    exit 1
}

create_directory_if_not_exist() {
    mkdir -p "$dest_dir"
    echo "Created directory '$dest_dir'."
}

src_file="$1"
dest_dir="$2"

# Check number of args
if [[ "$#" -ne 2 ]]; then
    print_usage_and_exit
fi

# Check if the source file exists
if [[ ! -e "$src_file" ]]; then
    print_file_not_exist_and_exit
fi

# Check if the destination directory exists, create if not
if [[ ! -d "$dest_dir" ]]; then
    create_directory_if_not_exist
fi

# Split the PGN file
game_count=0
game_content=""
game_started=0

while IFS= read -r line; do
    # start of a new game
    if [[ $line =~ ^\[Event\ .*\] ]]; then
        if [ $game_started -eq 1 ]; then
            ((game_count++))
            echo "$game_content" > "$dest_dir/$(basename "$src_file" .pgn)_$game_count.pgn"
            echo "Saved game to $dest_dir/$(basename "$src_file" .pgn)_$game_count.pgn"
        fi
        game_content="$line"$'\n'
        game_started=1
    else
        game_content+="$line"$'\n'
    fi
done < "$src_file"

# Save the last game if it exists
if [ $game_started -eq 1 ]; then
    ((game_count++))
    echo "$game_content" > "$dest_dir/$(basename "$src_file" .pgn)_$game_count.pgn"
    echo "Saved game to $dest_dir/$(basename "$src_file" .pgn)_$game_count.pgn"
fi

echo "All games have been split and saved to '$dest_dir'."
