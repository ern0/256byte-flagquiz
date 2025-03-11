# Assembly Program Overview

## Program Description
This assembly language program is designed to display a series of flags (represented by TLDs - Top Level Domains), prompt the user to guess the TLD, evaluate the answer, and keep track of the number of correct and total answers.

## How It Works
1. **Initialize the Screen**: The program begins by clearing the screen.
2. **Load and Display Flags**: It iterates through a list of encoded TLDs, loading each one and displaying it.
3. **User Input**: The program prompts the user to guess the TLD, reads the input, and checks if the answer is correct.
4. **Evaluation**: If the answer is correct, it updates the count of correct answers.
5. **Loop**: The program continues looping through the flags until all have been processed or the user exits.

## Data Format
The program uses various data formats, specifically:
- **Counts**: Some constants like `COUNT`, `BS` (backspace), `LF` (line feed), and `ESC` (escape character) are defined.
- **Strings**: Strings for prompts and messages are defined using `db` (define byte).
- **Encoded Data**: The TLDs are stored as byte sequences in the `data` section, relying on specific encoding for retrieval.

## Subroutines
### 1. `clear_screen`
- Clears the screen using BIOS interrupt `10H`.
- Changes video mode to mode `13H`.

### 2. `load_flag_data`
- Loads flag data from the `data` buffer using `lodsw` (load word from DS).
- Shifts and retrieves the necessary bytes for display.

### 3. `display_flag`
- Displays each flag's colors in sequence using the `display_strip` subroutine, which prints color strips based on the encoded TLD.

### 4. `read_answer`
- Displays a question prompt and collects user input, allowing for backspace corrections.

### 5. `evaluate_answer`
- Compares the user's answer against the correct TLD.
- If correct, increments the pass count; otherwise, indicates a failure.

### 6. `inc2`
- A helper method that increments a count and properly formats it when surpassing double digits.

### 7. `read_key`
- Reads a single character input from the user.

## Register Usage
- `AX`, `BX`, `CX`, `DX`: Utilized for data manipulation, display control, and user input.
- `SI`, `DI`: Used for pointer arithmetic and data movement between buffers.
- `CH`, `CL`: Employed for loop control when displaying color strips.
- `AH` and `AL`: Used for interrupt calls and storing temporarily read data.

## Conclusion
This assembly program effectively manages user interaction to guess TLDs, maintains a count of attempts and successes, and utilizes system calls for screen management and input handling. It exemplifies basic programming concepts in assembly, such as loops, conditionals, and data handling.
