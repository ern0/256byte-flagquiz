flagquiz.com: flagquiz.asm flagdata.inc
	nasm flagquiz.asm -o flagquiz.com

flagdata.inc: generate.py
	./generate.py > flagdata.inc
	cat flagdata.inc

clean:
	rm flagquiz.com
	rm flagdata.inc
