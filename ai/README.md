# AI Analysis

I wanted to see if AI could handle the
analysis of an assembly program.

## The prompt

The AIs were fed with the program without comments,
with data included, using the same prompt.

> Explain this program,
its main function,
program flow,
data format,
subroutines,
register usage.
Provide the result in .md file.

## The results

I've asked AIs to provide the result in markdown format,
so these are what they produced, without any change:

- [OpenAI ChatGPT](ai-chatgpt.md) - https://openai.com/
- [DeepSeek](ai-deepseek.md) - https://chat.deepseek.com/
- [Claude 3.7 Sonnet](ai-claude.md) - https://claude.ai/
- [MS CoPilot](ai-copilot.md) - https://copilot.microsoft.com/
- [Gemini 2.0](ai-gemini.md) - https://gemini.google.com/

They did a pretty good job, except data explanation,
but some further chat to guide them to the right answer.
I didn't do that,
my goal was to see what they could do on their own.

## What the AIs have missed

This is what AIs couldn't figure out:

> A colour is stored in 3 bits, a flag requires 3 colours.
The first byte contains 8 bits of the colours,
the remaining 1 bit is
stored in the lower bit of the second byte.
The 2nd byte is shifted one byte to the right
and the 3rd byte are the TLD,
in reverse order.
