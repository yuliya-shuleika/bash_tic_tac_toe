# Tic-Tac-Toe Game (Bash Script)

This is a command-line Tic-Tac-Toe game implemented in Bash. It allows two players to play against each other, or one player to play against the computer. The game board is represented as a 3x3 grid, and players can take turns marking their moves. The game supports saving and restoring progress.

## Key Features

- **Two-player mode**: Allows two players to play against each other.
- **Game saving and restoring**: Save your game progress and restore it later.
- **Single-player mode**: Play against the computer, which uses a minimax algorithm to choose its moves.

## How to Use

1. **Clone or Download the Script:**
   Download or clone this repository to your machine.

2. **Run the Script:**
   Open a terminal and navigate to the folder containing the script. Run the script using the following command:
   ```bash
   ./tic_tac_toe.sh
   ```
3. **Gameplay:**
  - The script will prompt you whether you want to play against the computer or another player.
  - If you choose to play with the computer, the computer will make its move automatically.
  - If playing with another player, you will be asked to input the cell number where you want to place your mark ("X" or "O").
  - The game will display the current state of the board after each move.
4. **Saving and Restoring Progress:**
  - You will be prompted to save your progress at any time by pressing `Ctrl+C` or terminating the game.
  - You can also restore the previous game by choosing to load it after starting the game.
5. **Game Flow:**
  - The game continues until one player wins or the board is full (resulting in a draw).
  - After the game ends, new game immediately starts.
   
