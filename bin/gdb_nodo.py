import subprocess


def get_pc_as_int():
    try:
        return int(gdb.parse_and_eval('$rip').cast(gdb.lookup_type('int')))

    except Exception:
        return None


class GoNo(gdb.Command):
    def __init__(self):
        super(GoNo, self).__init__("no", gdb.COMMAND_STACK)

    def invoke(self, arg, from_tty):
        self.dont_repeat()
        if arg == '':
            pc = get_pc_as_int()
            if pc is None:
                raise Exception('no pc for current frame')

            loc = gdb.find_pc_line(pc)
            if loc.symtab is None or loc.line == 0:
                raise Exception('no location information for current frame')

            else:
                arg = '%s +%d' % (loc.symtab.filename, loc.line)

        subprocess.check_call('no ' + arg, shell=True)


go_no = GoNo()

