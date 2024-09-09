#!/bin/bash
# Elay Ben Yehoshua 214795668
# display the chess board
display_board() {
  local -n board_ref=$1
  echo "  a b c d e f g h"
  for ((i=8; i>=1; i--)); do
    row=$((i-1))
    echo -n "$i "
    for ((j=0; j<8; j++)); do
      echo -n "${board_ref[$row,$j]} "
    done
    echo "$i"
  done
  echo "  a b c d e f g h"
}

# init the board
init_board() {
  local -n board_ref=$1
  board_ref=(
    [0,0]=R [0,1]=N [0,2]=B [0,3]=Q [0,4]=K [0,5]=B [0,6]=N [0,7]=R
    [1,0]=P [1,1]=P [1,2]=P [1,3]=P [1,4]=P [1,5]=P [1,6]=P [1,7]=P
    [2,0]=. [2,1]=. [2,2]=. [2,3]=. [2,4]=. [2,5]=. [2,6]=. [2,7]=.
    [3,0]=. [3,1]=. [3,2]=. [3,3]=. [3,4]=. [3,5]=. [3,6]=. [3,7]=.
    [4,0]=. [4,1]=. [4,2]=. [4,3]=. [4,4]=. [4,5]=. [4,6]=. [4,7]=.
    [5,0]=. [5,1]=. [5,2]=. [5,3]=. [5,4]=. [5,5]=. [5,6]=. [5,7]=.
    [6,0]=p [6,1]=p [6,2]=p [6,3]=p [6,4]=p [6,5]=p [6,6]=p [6,7]=p
    [7,0]=r [7,1]=n [7,2]=b [7,3]=q [7,4]=k [7,5]=b [7,6]=n [7,7]=r
  )
}

parse_metadata() {
  local file=$1
  echo "Metadata from PGN file:"
  grep -E '\[.*\]' "$file"
  echo
}

apply_move() {
  local -n board_ref=$1
  local move=$2
  local from_col=$(( $(printf "%d" "'${move:0:1}") - 97 ))
  local from_row=$(( ${move:1:1} ))
  local to_col=$(( $(printf "%d" "'${move:2:1}") - 97 ))
  local to_row=$(( ${move:3:1} ))
  from_row=$((from_row-1))
  to_row=$((to_row-1))



  piece=${board_ref[$from_row,$from_col]}
  if [ ${#move} -eq 5 ]; then
    # Handle promotion
    promotion=${move:4:1}
    piece=${promotion^}
  fi

  board_ref[$to_row,$to_col]=$piece
  board_ref[$from_row,$from_col]='.'
}

# Check if PGN file exists
if [ ! -f "$1" ]; then
  echo "File does not exist: $1"
  exit 1
fi

# Init variables
declare -A board
init_board board
moves=()
current_move=0


moves=$(python3 parse_moves.py "$(grep -vE '^\[|^\s*$' "$1" | tr '\n' ' ')")


IFS=' ' read -r -a moves_array <<< "$moves"


parse_metadata "$1"

shouldprint=1


while true; do
  if [ $shouldprint -eq 1 ]; then
    echo "Move $current_move/${#moves_array[@]}"
    display_board board
  fi
  shouldprint=1
  read -p "Press 'd' to move forward, 'a' to move back, 'w' to go to the start, 's' to go to the end, 'q' to quit:" key
  echo "Press 'd' to move forward, 'a' to move back, 'w' to go to the start, 's' to go to the end, 'q' to quit:"
  case $key in
    d)
      if [ $current_move -lt ${#moves_array[@]} ]; then
        apply_move board "${moves_array[$current_move]}"
        ((current_move++))
      else
        shouldprint=0
        echo "No more moves available."
      fi
      ;;
    a)
      if [ $current_move -gt 0 ]; then
        init_board board
        for ((i=0; i<current_move-1; i++)); do
          apply_move board "${moves_array[$i]}"
        done
        ((current_move--))
      fi
      ;;
    w)
      init_board board
      current_move=0
      ;;
    s)
      init_board board
      for move in "${moves_array[@]}"; do
        apply_move board "$move"
      done
      current_move=${#moves_array[@]}
      ;;
    q)
      echo "Exiting."
      echo "End of game."
      break
      ;;
    *)
        shouldprint=0
      echo "Invalid key pressed: ${key}"
      ;;
  esac
done
