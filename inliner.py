#!/usr/bin/env python3

import sys

class Inliner:

    def main(self):

        self.load_file(sys.argv[1])
        self.collect_subs()
        self.count_refs()
        self.render_subs()

    def load_file(self, filename):

        self.lines = []

        file = open(filename,'r')
        for line in file:
            self.lines.append(line.rstrip())
        file.close()

    def collect_subs(self):

        self.num = 0
        self.subs = {}
        self.inside = None
        self.label = ""

        for self.line in self.lines:

            self.line = self.line.split(";")[0].rstrip()
            self.num += 1

            if self.line == "": continue

            if self.label == "@main" or self.label == "":
                is_sub = self.check_if_sub()
            else:
                is_sub = False

            is_ret = self.check_if_ret()
            if self.line.strip() == "jmp exit":
                is_ret = True

            if len(self.subs) == 0:
                is_sub = True
                self.label = "@main"

            if is_sub:
                self.subs[self.label] = {}
                self.subs[self.label]["lines"] = {}
                self.subs[self.label]["refcount"] = 0

            if self.label != "":
                self.subs[self.label]["lines"][self.num] = self.line

            if is_ret: self.label = ""

    def check_if_sub(self):

        is_sub = False

        if self.line[0] == ".":
            return

        if self.line[-1] == ":":
            is_sub = True
            self.label = self.line.split(":")[0]

        return is_sub

    def check_if_ret(self):

        is_ret = False

        if self.line.strip().split(" ")[0] == "ret":
            is_ret = True

        return is_ret

    def count_refs(self):

        for self.line in self.lines:

            self.line = self.line.split(";")[0].rstrip()
            self.num += 1

            if self.line == "": continue

            if self.check_if_call():
                self.subs[self.called]["refcount"] += 1

    def check_if_call(self):

        is_call = False

        if self.line.strip().split(" ")[0] == "call":
            is_call = True
            self.called = self.line.strip().split(" ")[1]

        return is_call

    def render_subs(self):

        for label in self.subs:
            ref = self.subs[label]["refcount"]
            if ref != 1:
                self.render(label, False)

    def render(self, label, remove_ret):

        first_line = True
        for lineno in self.subs[label]["lines"]:
            refcount = self.subs[label]["refcount"]

            if label != "@main" and first_line and refcount == 1:
                first_line = False
                continue

            self.line = self.subs[label]["lines"][lineno]

            if self.check_if_call() and self.subs[self.called]["refcount"] == 1:
                print("\t; begin " + self.called)
                self.render(self.called, True)
                print("\t; end " + self.called)
            else:
                if not self.check_if_ret() or not remove_ret:
                    print(self.line)

    def check_if_ret(self):

        return self.line.strip().split(" ")[0] == "ret"

if __name__ == "__main__":
    Inliner().main()
