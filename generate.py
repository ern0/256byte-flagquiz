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

        if False:
            self.order_and_print("color")
            self.order_and_print("diff")
            self.order_and_print("d1")
            self.order_and_print("d2")
            self.order_and_print("d3")

        print(f"\t; flag data")
        self.gen()

    def gen(self):

        self.flag("Germany", "de", BLACK, RED, YELLOW)
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

    def flag(self, name, tld, c1, c2, c3):

        self.flag_print(name, tld, c1, c2, c3)
        self.flag_stat(name, tld, c1, c2, c3)
        self.count += 1

    def flag_print(self, name, tld, c1, c2, c3):

        colors = (c3 << 6) | (c2 << 3) | (c1 << 0)

        color_bit = (colors & 0x100) >> 8
        b1 = self.fmt(ord(tld[0]) << 1 | color_bit)
        b2 = self.fmt(colors & 0xff)
        b3 = self.fmt(ord(tld[1]))

        sp = " " * (12 - len(b1 + b2 + b3))
        print(f"\tdb {b1}, {b2}, {b3} {sp} ; {name} (.{tld})")

    @staticmethod
    def fmt(value):

        if value < 0xa0:
            return "{0:02x}H".format(value)
        else:
            return "{0:03x}H".format(value)

    def flag_stat(self, name, tld, c1, c2, c3):

        c0 = 4
        self.add_value("color", c1)
        self.add_value("color", c2)
        self.add_value("color", c3)

        d1 = c1 - c0
        if d1 < 0: d1 += 8
        self.add_value("diff", d1)
        self.add_value("d1", d1)

        d2 = c2 - c1
        if d2 < 0: d2 += 8
        self.add_value("diff", d2)
        self.add_value("d2", d2)

        d3 = c3 - c2
        if d3 < 0: d3 += 8
        self.add_value("diff", d3)
        self.add_value("d3", d3)

    def add_value(self, token, value):

        if token not in self.stat:
            self.stat[token] = {}

        if value not in self.stat[token]:
            self.stat[token][value] = 0

        self.stat[token][value] += 1

    def order_and_print(self, token):

        print("--",token,"--")
        ordered_array = sorted(self.stat[token].items(), key=lambda item: -item[1])
        for (key, value) in ordered_array:
            print( str(key).rjust(4) + ":", str(value).rjust(4) )

if __name__ == "__main__":
    Analyze().main()
