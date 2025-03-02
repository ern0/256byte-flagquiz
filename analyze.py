#!/usr/bin/env python3

from collections import OrderedDict

BLACK = 0
BLUE = 1
GREEN = 2
_CYAN = 3
RED = 4
_PURPLE = 5
YELLOW = 6
WHITE = 7


class Analyze():

    def __init__(self):
        self.stat = {}

    def main(self):

        self.data()
        self.dump()

    def data(self):

        self.flag("Germany", "de", BLACK, YELLOW, WHITE)
        self.flag("Italy", "it", GREEN, WHITE, RED)
        self.flag("France", "fr", BLUE, WHITE, RED)
        self.flag("Bulgaria", "bg", WHITE, GREEN, RED)
        self.flag("Ireland", "ie", GREEN, WHITE, RED)
        self.flag("Netherland", "nl", RED, WHITE, BLUE)
        self.flag("Austria", "at", RED, WHITE, RED)
        self.flag("Estonia", "es", RED, YELLOW, RED)
        self.flag("Belarus", "by", WHITE, RED, WHITE)
        self.flag("Russia", "ru", WHITE, BLUE, RED)
        self.flag("Romania", "ro", BLUE, YELLOW, RED)
        self.flag("Hungary", "hu", RED, WHITE, GREEN)
        self.flag("Lithuania", "lt", YELLOW, GREEN, RED)
        self.flag("Serbia", "rs", RED, BLUE, WHITE)
        self.flag("Estonia", "ee", BLUE, BLACK, WHITE)
        self.flag("Sierra Leone", "sl", GREEN, WHITE, BLUE)
        self.flag("Yemen", "ye", RED, WHITE, BLACK)
        self.flag("Gabon", "ga", GREEN, YELLOW, BLUE)
        self.flag("Armenia", "am", RED, BLUE, YELLOW)
        self.flag("Bolivia", "bo", RED, YELLOW, GREEN)


    def flag(self, _name, _tld, c1, c2, c3):

        c0 = 4
        self.add(c1)
        self.add(c2)
        self.add(c3)

    def add(self, color):

        if color in self.stat:
            self.stat[color] += 1
        else:
            self.stat[color] = 1

    def dump(self):

        print(self.stat)

if __name__ == "__main__":
    Analyze().main()
