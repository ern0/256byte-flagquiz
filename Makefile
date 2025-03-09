flagquiz.com: flagquiz.asm flagdata.inc ai/prompt-full.txt
	./inline.py flagquiz.asm > /tmp/flagquiz-inline.asm
	nasm /tmp/flagquiz-inline.asm -o flagquiz.com
	rm -f /tmp/flagquiz-inline.asm

flagdata.inc: generate.py
	./generate.py > flagdata.inc
	cat flagdata.inc

ai/prompt-full.txt: ai/prompt-base.txt flagquiz.asm flagdata.inc
	cat \
		ai/prompt-base.txt flagquiz.asm flagdata.inc \
		| cut -d';' -f1 \
		| grep -v include \
		| grep -v '^$$' \
		> ai/prompt-full.txt

clean:
	rm flagquiz.com
	rm flagdata.inc
	rm ai/prompt-full.txt

all: clean flagquiz.com ai/prompt-full.txt
