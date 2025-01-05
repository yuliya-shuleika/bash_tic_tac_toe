#!/bin/bash

board=(1 2 3 4 5 6 7 8 9)
file_name="game_progress.txt"
player="X"
is_new_game=true
is_against_computer = false

initialize_board() {
    for i in {0..8}; do
        board[$i]=$((i + 1))
    done 
}

save_game() {
    read -p "Do you want to save the progress? (y/n) " shouldBeSaved
    if [[ ${shouldBeSaved} == "y" ]]; then
        printf "%s " "${board[@]}" > "$file_name"

        if [[ ${is_against_computer} == "true" ]]; then 
            printf "\ntrue" >> "$file_name"
        else 
            printf "\nfalse" >> "$file_name"
        fi

        printf "\nX" >> "$file_name"

        echo "Game progress saved to $file_name."
    fi

    exit 0
}

restore_game() {
    if [[ -s $file_name ]]; then
        read -p "Do you want to restore the previous game? (y/n)" shouldBeRestored
        if [[ ${shouldBeRestored} == "y" ]]; then
            is_new_game=false
            {
                read -r -a board
                read -r is_against_computer
                read -r player
            } < "$file_name"
        else
            truncate -s 0 $file_name
        fi
    fi
}

print_board() {
    echo "${board[0]} ${board[1]} ${board[2]}"
    echo "${board[3]} ${board[4]} ${board[5]}"
    echo "${board[6]} ${board[7]} ${board[8]}" 
}

validate_cell() {
    index=$1

    if [[ $index -lt 1 || $index -gt 9 || ${board[$index-1]} == "X" || ${board[$index-1]} == "O" ]]; then
        echo "Selected cell is invalid. Please choose another one"
        return 1
    fi

    return 0
}

check_end() {
    for cell in "${board[@]}"; do
        if [[ $cell != "X" && $cell != "O" ]]; then 
            return 0
        fi
    done

    return 1
}

check_win() {
    for i in {0..2}; do
        if [[ ${board[$((i*3))]} == ${board[$((i*3+1))]} && ${board[$((i*3))]} == ${board[$((i*3+2))]} ]]; then
            echo "${board[$((i*3))]}"
            return
        fi
    done

    for i in {0..2}; do
        if [[ ${board[$i]} == ${board[$((i+3))]} && ${board[$i]} == ${board[$((i+6))]} ]]; then
            echo "${board[$i]}"
            return
        fi
    done

    if [[ (${board[0]} == ${board[4]} && ${board[4]} == ${board[8]}) || (${board[2]} == ${board[4]} && ${board[4]} == ${board[6]}) ]]; then
        echo "${board[4]}" 
        return
    fi

    return
}

minimax() {
    local depth=$1
    local isMax=$2

    result=$(check_win)
    if [[ "$result" == "X" ]]; then
        echo -10
        return
    elif [[ "$result" == "O" ]]; then
        echo 10
        return
    fi

    if ! check_end; then
        echo 0
        return
    fi

    local best
    if [ "$isMax" -eq 1 ]; then
        best=-10000
        for i in {0..8}; do
            if [[ "${board[$i]}" != "X" && "${board[$i]}" != "O" ]]; then
                board[$i]="O"
                local val
                val=$(minimax $((depth + 1)) 0)
                val=$((val)) 
                if (( val > best )); then
                    best=$val
                fi
                board[$i]=$((i + 1))
            fi
        done
    else
        best=10000
        for i in {0..8}; do
            if [[ "${board[$i]}" != "X" && "${board[$i]}" != "O" ]]; then
                board[$i]="X"
                local val
                val=$(minimax $((depth + 1)) 1)
                val=$((val))
                if (( val < best )); then
                    best=$val
                fi
                board[$i]=$((i + 1))
            fi
        done
    fi

    echo "$best"
}


find_best_move() {
    local bestVal=-1000
    local bestMove=-1
    for i in {0..8}; do
        if [[ "${board[$i]}" != "X" && "${board[$i]}" != "O" ]]; then
            board[$i]="O"
            local moveVal
            moveVal=$(minimax 0 0)
            board[$i]=$((i + 1))
            if [ "$moveVal" -gt "$bestVal" ]; then
                bestVal=$moveVal
                bestMove=$i
            fi
        fi
    done
    echo $bestMove
}

start_new_game() {
    initialize_board
    truncate -s 0 $file_name
    read -p "Do you want to play with the computer? (y/n) " is_against_computer
    if [[ $is_against_computer == "y" ]]; then
        is_against_computer=true
    else
        is_against_computer=false
    fi
    player="X"
}

restore_game
if $is_new_game; then 
    start_new_game
fi
trap save_game SIGINT SIGHUP SIGTERM

while true; do
    print_board
    
    if [[ $is_against_computer == "true" && $player == "O" ]]; then 
        echo "Computer is thinking..." 
        bestMove=$(find_best_move)
        board[$bestMove]=$player
    else 
        echo "Player ${player} please enter the cell number where you want to put ${player}"
        read -r cell
        if ! validate_cell "$cell"; then
            continue
        else
            board[$((cell-1))]=$player
        fi
    fi

    if [[ $(check_win) == "X" || $(check_win) == "O" ]]; then 
        echo "Player ${player} won."
        start_new_game
        continue
    elif ! check_end; then 
        echo "No more free cells on the board"
        start_new_game
        continue
    fi

    if [[ $player == "X" ]]; then
        player="O"
    else
        player="X"
    fi
done
