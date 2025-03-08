flagquiz.com: flagquiz.asm flagdata.inc ai/prompt.txt
	nasm flagquiz.asm -o flagquiz.com

flagdata.inc: generate.py
	./generate.py > flagdata.inc
	cat flagdata.inc

ai.txt: flagquiz.asm flagdata.inc
	echo \
		"Explain this program line by line, " \
		"explain data format, subroutines, register usage. " \
		"Provide the result in .md file, "\
		"insert ~ character at the beginning of each line." \
		> ai/prompt.txt
	cat \
		flagquiz.asm flagdata.inc \
		| cut -d';' -f1 \
		| grep -v include \
		| grep -v '^$$' \
		>> ai/prompt.txt

clean:
	rm flagquiz.com
	rm flagdata.inc
	rm ai.txt
