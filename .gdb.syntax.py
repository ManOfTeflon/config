import gdb
import sys
import time
import atexit
import threading
import subprocess

class Highlighter(object):

    def __init__(self):

        if sys.version_info[0] < 3:
            self.dirName = str(subprocess.check_output(['mktemp', '-d'])).rstrip()
        else:
            self.dirName = str(subprocess.check_output(['mktemp', '-d']), 'utf-8').rstrip()

        self.pipeName = self.dirName + "/tmp.pipe"
        subprocess.check_call(["mkfifo", self.pipeName])
        print( "Color pipe is " + self.pipeName)
        self.logger = None

        def _cleanup():
            if self.dirName:
                subprocess.Popen(['rm', '-r', self.dirName]).communicate()
                self.dirName = None

        atexit.register(_cleanup)

        current_hook = gdb.prompt_hook

        def _prompt_hook(current_prompt):

            self.logging_off()
            return current_hook(current_prompt) if current_hook else current_prompt

        gdb.prompt_hook = _prompt_hook

    def logging_on(self, lang):

        # if self.logger is not None:
        #     if self.logger.poll() is None:
        #         self.logger.terminate()
        #     self.logger.wait()
        #     self.logger = None

        self.logging_off()

        self.logger = subprocess.Popen("cat " + self.pipeName + " | c++filt | source-highlight -s %s -f esc --style-file=esc-solarized.style" % lang, shell=True)

        gdb.execute("set logging redirect on")
        gdb.execute("set logging on " + self.pipeName)

    def logging_off(self):

        if self.logger is not None:

            self.logger.terminate()
            self.logger.wait()
            self.logger = None

            gdb.execute('set logging off')
            gdb.execute('set logging redirect off')

            print("\n")
            time.sleep(0.1)

gdb.highlighter = Highlighter()

# def on_stop(event):
#     if isinstance(event, gdb.SignalEvent):
#         # Skip up out of any internal frames (i.e. assertion failures)
#         frame = gdb.selected_frame()
#         while gdb.execute("frame", to_string=True).endswith('libc.so.6\n'):
#             frame = frame.older()
#             if frame is None:
#                 break
#             frame.select()
# gdb.events.stop.connect(on_stop)

