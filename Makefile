COUNT: flagquiz.com
	@ls -l flagquiz.com | tr -s " " | cut -d" " -f5

flagquiz.com: \
			flagquiz.asm \
			flagdata.inc \
			ai/prompt-full.txt \
			inliner.py \
			Makefile
	./inliner.py flagquiz.asm > flagquiz-inline.asm
	nasm flagquiz-inline.asm -o flagquiz.com
	#rm -f flagquiz-inline.asm

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
	rm \
		flagquiz.com
		flagdata.inc
		ai/prompt-full.txt

all: \
			clean
			flagquiz.com
			ai/prompt-full.txt
