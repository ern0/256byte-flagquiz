# Program Analysis

This program is a simple quiz game that tests the user's knowledge of country code top-level domains (TLDs). The program displays a flag (represented by colored strips) and asks the user to guess the corresponding TLD. The user's input is then evaluated, and the program keeps track of the number of correct and total answers.

## Data Format

- **COUNT**: Equates to 17, representing the number of flags/TLDs in the quiz.
- **BS**: Equates to 8, representing the backspace character.
- **LF**: Equates to 10, representing the line feed character.
- **ESC**: Equates to 27, representing the escape character.
- **data**: Contains the encoded flag data and TLDs. Each flag is represented by 3 bytes:
  - The first two bytes encode the flag's colors.
  - The third byte represents the TLD's ASCII code.
- **result**: A buffer that stores the results of the user's guesses. Each result is represented by a single byte (249 for incorrect, 251 for correct).
- **num_pass**: Stores the number of correct answers in ASCII format.
- **num_total**: Stores the total number of questions in ASCII format.

## Subroutines

1. **clear_screen**:
   - Clears the screen by setting the video mode to 13H (320x200, 256 colors).

2. **load_flag_data**:
   - Loads the next flag's data from the `data` buffer.
   - The first two bytes are loaded into `BX`, and the third byte (TLD) is stored in `print_tld`.

3. **display_flag**:
   - Displays the flag by calling `display_strip` three times (one for each color strip).
   - The colors are extracted from `BX` by shifting and masking.

4. **display_strip**:
   - Displays a single color strip.
   - Uses BIOS interrupt 10H to print a block character (0EDBH) with the specified color.

5. **read_answer**:
   - Prompts the user to guess the TLD.
   - Reads two characters from the user (the TLD code).
   - If the user presses ESC, the program exits.
   - If the user presses backspace, it allows the user to correct their input.

6. **evaluate_answer**:
   - Compares the user's input with the correct TLD.
   - Updates the `result` buffer and the `num_pass` and `num_total` counters.
   - Displays the result of the guess.

7. **inc2**:
   - Increments a two-digit ASCII number (used for `num_pass` and `num_total`).
   - Handles carry-over when the number exceeds '9'.

## Register Usage

- **SI**: Source index, used to point to the current flag data in the `data` buffer.
- **DI**: Destination index, used to point to the current position in the `result` buffer.
- **AX**: General-purpose register, used for various operations including loading data and making BIOS calls.
- **BX**: Base register, used to store flag color data and as a pointer in `evaluate_answer`.
- **CX**: Counter register, used in loops and to store user input.
- **DX**: Data register, used to store addresses for string output.
- **AH**: High byte of AX, used for BIOS function calls.
- **AL**: Low byte of AX, used for storing data and making comparisons.

## Result

The program will display a series of flags, prompt the user to guess the corresponding TLD, and then evaluate the user's input. It will keep track of the number of correct answers and display the final score at the end. The user can exit the program at any time by pressing the ESC key.

```markdown
# Example Output

Guess TLD: us
? Correct!

Guess TLD: fr
? Incorrect!

...

Final Score: 12/17
```

This program is a simple yet effective way to test and improve one's knowledge of country code TLDs.
