# Assembly Program Analysis

## Overview

This program is a flag guessing game that shows tricolor flag patterns and asks the user to guess the corresponding Top-Level Domain (TLD) country code. The program:

1. Displays a sequence of 17 national flags as colored strips
2. Prompts the user to guess the two-letter TLD code for each flag
3. Tracks correct/incorrect answers and maintains a running score
4. Exits when all flags have been shown or when ESC is pressed

## Program Structure

### Memory Organization

- `org 100H` - Program is loaded at offset 100H (COM file format)
- Uses a simple data structure to store flag colors and correct answers
- Maintains a result buffer to track user performance

### Data Format

Each flag entry in the data section consists of 3 bytes:
- **Bytes 1-2**: A 16-bit word containing 9 bits of color information (3 bits per color strip)
- **Byte 3**: ASCII code of the second letter of the TLD

The first letter of the TLD is encoded within the color word (in the upper bits of AH register).

### Main Routine

The main program flow:
```
Initialize pointers
Clear screen
For each flag:
  - Load flag data
  - Display flag
  - Read user answer
  - Evaluate answer
  - Move to next flag
Exit
```

### Subroutines

#### `clear_screen`
Sets video mode 13h (320x200, 256 colors) via INT 10H.

#### `load_flag_data`
- Loads a word (color information) into BX
- Extracts the first letter of the TLD by shifting AH right by 1 bit
- Loads the second letter of the TLD from the third byte
- Stores the two-character TLD in the `print_tld` memory location

#### `display_flag`
Draws a tricolor flag by calling `display_strip` three times, shifting BX right by 3 bits between each call to get the next color.

#### `display_strip`
Displays a colored strip of the flag:
- Uses color code stored in BL (bits 0-2, plus bit 3 always set)
- Draws a rectangular section using INT 10H function 0Eh with character 0DBh (full block)
- Each strip is 10 characters wide and 4 characters tall

#### `read_answer`
Prompts the user and reads two characters of input:
- First character stored in CL
- Second character stored in CH
- Handles backspace for correction
- Exits program if ESC key is pressed

#### `evaluate_answer`
Compares user's input (in CX) with the correct TLD (in `print_tld`):
- Updates score counters (passed/total)
- Adds a character to the result buffer (✓ for correct, 'x' for incorrect)
- Displays the correct answer

#### `inc2`
Helper function to increment a two-digit decimal counter:
- Handles carrying to the tens digit when units digit reaches 10
- Used for both "pass" and "total" counters

### Register Usage

- **SI**: Source index pointer for flag data
- **DI**: Destination index pointer for results
- **BX**: Stores flag color information; BL used for current color
- **CX**: Used as loop counter in display routines; stores user input during answer evaluation
- **AX**: Multi-purpose; used for INT calls and data manipulation
- **DX**: Used for pointing to strings for display

## Command and ASCII Values

- **COUNT = 17**: Total number of flags in the quiz
- **BS = 8**: ASCII for Backspace
- **LF = 10**: ASCII for Line Feed
- **ESC = 27**: ASCII for Escape key

## Display Techniques

The program uses:
- INT 10H/AX=13H to set the video mode
- INT 10H/AH=0EH to output characters (with color in BL)
- INT 21H/AH=9 to display '$'-terminated strings
- INT 21H/AH=1 to read keyboard input with echo

## Data Section

The data section contains:
1. Prompt and message strings
2. A buffer for storing results (✓/x for each answer)
3. Score counters
4. Encoded flag data for 17 countries

The flag database contains encoded information for countries like tw (Taiwan), fr (France), it (Italy), etc., represented by their tricolor flags and TLD codes.
