#!/usr/bin/env python3

import sys

class Inliner:

    def main(self):

        self.load_file(sys.argv[1])
        self.collect()

        for label in self.subs:
            print(label + ":")
            for num in self.subs[label]:
                line = self.subs[label][num]
                print("  " + str(num) + ": " + line);

    def load_file(self, filename):

        self.lines = []

        file = open(filename,'r')
        for line in file:
            self.lines.append(line.rstrip())
        file.close()

    def collect(self):

        self.num = 0
        self.subs = {}
        self.inside = None
        self.label = ""

        for self.line in self.lines:

            self.line = self.line.split(";")[0].rstrip()
            self.num += 1

            if self.line == "": continue

            is_sub = self.check_if_sub()
            is_ret = self.check_if_ret()

            if is_sub:
                self.subs[self.label] = {}

            if self.label != "":
                self.subs[self.label][self.num] = self.line

            if is_ret: self.label = ""

    def check_if_sub(self):

        is_sub = False

        if self.line[0] == ".":
            return

        if self.line[-1] == ":":
            is_sub = True
            self.label = self.line.split(":")[0]

        if self.line.strip().split(" ")[0] == "org":
            is_sub = True
            self.label = "@main"

        return is_sub

    def check_if_ret(self):

        is_ret = False

        if self.line.strip().split(" ")[0] == "ret":
            is_ret = True

        return is_ret

    def check_if_call(self):

        is_call = False

        if self.line.strip().split(" ")[0] == "call":
            is_call = True
            self.called = self.line.strip().split(" ")[1]

        return is_call

if __name__ == "__main__":
    Inliner().main()
