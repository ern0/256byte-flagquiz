# Assembly Flag Guessing Game Analysis

## Program Overview

This program is a flag guessing game written in x86 assembly language. The player is shown a series of 17 tricolor flags and must guess the correct two-letter Top-Level Domain (TLD) country code for each flag.

## How It Works

The program displays tricolor flags one by one, prompts the user to guess the corresponding country code (TLD), and keeps track of correct answers. Each flag is represented by three colored horizontal strips.

## Program Flow

1. Initialize the screen and counters
2. Enter the main loop that processes each flag
3. For each flag:
   - Load the flag data (colors and TLD)
   - Display the tricolor flag
   - Read and check the user's answer
4. Continue until all 17 flags are processed or user exits
5. Exit the program

## Data Format

The data for each flag is stored as 3 bytes:
- First byte (16 bits): Contains the color information for all three strips
  - Each strip's color is encoded in 3 bits (values 0-7)
  - The bits are shifted after each strip is displayed
- Third byte: Contains the two ASCII characters of the country's TLD

Example: `db 0a0H, 0cbH, 64H`
- `0a0H, 0cbH`: Color information for the three strips
- `64H`: ASCII "d" (TLD is likely "de" for Germany)

## Subroutines

### `clear_screen`
- Sets video mode 13h (320x200, 256 colors)
- Used to prepare the display for drawing flags

### `load_data`
- Loads the next flag's data from memory
- Moves color information to BX register
- Prepares the TLD characters for comparison

### `display_flag`
- Controls the display of the three colored strips
- Uses CX as a counter to process each strip

### `display_strip`
- Draws a single colored strip of the flag
- Uses the color value in BL (lowest 3 bits plus bit 3)
- Draws characters using BIOS interrupt 10h

### `read_answer`
- Prompts the user to enter a two-letter TLD
- Handles keyboard input including backspace
- Compares the answer with the correct TLD
- Updates the score if the answer is correct

### `read_key`
- Reads a single keystroke from the keyboard
- Supports exiting the program via ESC key (27)

## Register Usage

- **SI**: Source Index, points to current data being processed
- **BP**: Base Pointer, tracks the number of flags processed/answered
- **BX**: Holds color information for the current flag
  - BL: Current strip color (3 bits + bit 3)
  - BH: Used for video operations
- **CX**: Counter for loops
  - CH: Used for vertical strip drawing
  - CL: Used for horizontal strip drawing
- **DI**: Destination Index, used when storing TLD
- **AX**: Accumulator, multiple uses
  - Used for BIOS/DOS calls
  - Used for character display
- **DX**: Data register
  - Used for storing string addresses for DOS output

## Memory Structures

- **`print_tld`**: Storage for the correct two-letter TLD
- **`result`**: Array storing the result indicators (correct/incorrect)
- **`num`**: Counter showing current score (format "00/17")
- **`data`**: Array of 3-byte structures for all 17 flags

## Technical Details

- The program runs in 16-bit real mode
- It uses BIOS interrupt 10h for video output
- It uses DOS interrupt 21h for keyboard input and string output
- The tricolor flags are drawn using ASCII block characters (code 219, ▀)
- The program is designed to be assembled and run as a COM file (starts at offset 100h)
