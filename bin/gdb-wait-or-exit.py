import gdb, subprocess

try:
    success = (subprocess.check_output("flock build.lock cat build.lock", shell=True).strip() == '0')
except:
    success = False

if not success:
    print("Build failure: " + str(success))
    gdb.execute('q')

