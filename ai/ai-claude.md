# Assembly Program Analysis

## Main Function

This program is a flag guessing game where the user needs to identify country TLDs (Top-Level Domains) based on displayed tricolor flags. The program shows a sequence of 17 different flags and asks the player to guess the corresponding two-letter country codes.

## Program Flow

1. Initialize pointers to data and result areas
2. Clear the screen
3. For each flag (17 total):
   - Load flag data (colors and correct TLD)
   - Display the tricolor flag
   - Read the user's two-character guess
   - Evaluate if the answer is correct
   - Update the score display
4. Exit the program when all flags are processed or if ESC is pressed

## Data Format

### Flag Data Structure
Each flag is represented by 3 bytes:
- First two bytes (word): Contains the RGB color values for the three strips of the flag
- Third byte: Contains the two ASCII characters of the correct TLD (compressed)

### Color Encoding
The flag colors are encoded in the first two bytes (16 bits):
- Each color is represented by 3 bits (8 possible colors)
- The colors are arranged from bottom to top (least significant bits represent the bottom strip)
- Colors appear to be using a 3-bit EGA/CGA-style palette with an additional intensity bit

### Result Display
The program tracks:
- Current question number (01-17)
- A visual result indicator showing X for correct answers and - for incorrect answers
- Running count of correct answers

## Subroutines

### `clear_screen`
Sets video mode 13h (320x200, 256 colors)

### `load_flag_data`
- Loads the next flag's color data into BX
- Extracts and processes the TLD data

### `display_flag`
- Calls `display_strip` three times to show each color of the tricolor flag
- Shifts BX register to get the next color for each call

### `display_strip`
- Displays a colored strip using INT 10h function 0Eh
- Each strip consists of 4 rows of 10 colored blocks

### `read_answer`
- Displays the question prompt
- Reads two keystrokes from the user (country code)
- Allows backspace for corrections
- Exits program if ESC key is pressed

### `evaluate_answer`
- Compares user input with the correct TLD
- Updates score counter if correct
- Marks the result as PASS_SIGN (X) or FAIL_SIGN (-)
- Increments the question counter

### `inc2`
- Helper function to increment a two-digit decimal counter
- Handles the carry from units to tens place

## Register Usage

- **SI**: Source Index - Points to the current flag data
- **DI**: Destination Index - Points to the current position in the result display
- **BX**: Holds the color data for the current flag
- **CX**: Used both as a loop counter and to store the user's input
- **DX**: Used for displaying strings via INT 21h
- **AX**: Used for various functions, particularly for INT calls
- **AH/AL**: Specific portions of AX used for function numbers and return values

## Memory Organization

- Program starts at offset 100h (COM file format)
- `data` section contains the encoded flag information
- `result` area holds the X/- indicators for correct/incorrect answers
- Various string constants for UI display
