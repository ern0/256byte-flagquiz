COUNT: flagquiz.com web/flagquiz.zip
	@ls -l flagquiz.com | tr -s " " | cut -d" " -f5

web/flagquiz.zip: flagquiz.com web/index.html web/dosbox.conf
	rm -f web/flagquiz.zip
	7z a web/flagquiz.zip flagquiz.com web/dosbox.conf
	7z rn web/flagquiz.zip web/dosbox.conf .jsdos/dosbox.conf
	7z l web/flagquiz.zip

flagquiz.com: \
			flagquiz.asm \
			flagdata.inc \
			ai/prompt-full.txt \
			inliner.py \
			Makefile
	./inliner.py flagquiz.asm > flagquiz-inline.asm
	nasm flagquiz-inline.asm -o flagquiz.com
	rm -f flagquiz-inline.asm

flagdata.inc: generate.py
	./generate.py > flagdata.inc
	cat flagdata.inc

ai/prompt-full.txt: \
			ai/prompt-base.txt \
			flagquiz.asm \
			flagdata.inc
	cat \
		ai/prompt-base.txt flagquiz.asm flagdata.inc \
		| cut -d';' -f1 \
		| grep -v include \
		| grep -v '^$$' \
		> ai/prompt-full.txt

clean:
	rm -f flagquiz.com
	rm -f flagdata.inc
	rm -f ai/prompt-full.txt
	rm -f web/flagquiz.zip

all: \
			clean
			flagquiz.com
			ai/prompt-full.txt
			web/flagquiz.zip
