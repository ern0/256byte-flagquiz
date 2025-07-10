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


class Analyze:

    def __init__(self):

        self.stat = {}
        self.count = 0

    def main(self):

        self.flag("Hungary", "hu", RED, WHITE, GREEN)
        self.flag("Austria", "at", RED, WHITE, RED)
        self.flag("Germany", "de", BLACK, RED, YELLOW)
        self.flag("Romania", "ro", BLUE, YELLOW, RED)
        self.flag("Russia", "ru", WHITE, BLUE, RED)
        self.flag("Serbia", "rs", RED, BLUE, WHITE)
        self.flag("Belarus", "by", WHITE, RED, WHITE)
        self.flag("France", "fr", BLUE, WHITE, RED)
        self.flag("Bulgaria", "bg", WHITE, GREEN, RED)
        self.flag("Ireland", "ie", GREEN, WHITE, RED)
        self.flag("Netherlands", "nl", RED, WHITE, BLUE)
        self.flag("Lithuania", "lt", YELLOW, GREEN, RED)
        self.flag("Estonia", "ee", BLUE, BLACK, WHITE)
        self.flag("Armenia", "am", RED, BLUE, YELLOW)
        self.flag("Yemen", "ye", RED, WHITE, BLACK)
        self.flag("Gabon", "ga", GREEN, YELLOW, BLUE)
        self.flag("Sierra Leone", "sl", GREEN, WHITE, BLUE)

    def flag(self, name, tld, c1, c2, c3):

        colors = (c3 << 6) | (c2 << 3) | (c1 << 0)
        color_bit9 = (colors & 0x100) >> 8

        b1 = self.fmt(colors & 0xff)
        b2 = self.fmt(ord(tld[1]) << 1 | color_bit9)
        b3 = self.fmt(ord(tld[0]))

        sp = " " * (12 - len(b1 + b2 + b3))
        print(f"\tdb {b1}, {b2}, {b3} {sp} ; {name} (.{tld})")

    @staticmethod
    def fmt(value):

        if value < 0xa0:
            return "{0:02x}H".format(value)
        else:
            return "{0:03x}H".format(value)

if __name__ == "__main__":
    Analyze().main()
