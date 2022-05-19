# TODO 
# Auto-remove comments, auto-preobfuscate, auto-test* if possible

import os.path 
from os import mkdir

buildFile = open('sentiment.lua', 'r')
buildLines = buildFile.readlines()

lineCount = 0
commentCount = 0

lines = []

for line in buildLines:
    lineCount += 1
    if(line.startswith("--")):
        commentCount += 1
    else:
        lines.append(line)

print("{*} Removed ", commentCount, " comments!")


if(os.path.exists("build")):
    print("{*} Writing to ./build/compiled.lua")
else:
    print("{*} Creating build folder")
    mkdir("build")
    print("{*} Writing to ./build/compiled.lua")

compiledFile = open("build/compiled.lua", 'x')
compiledFile.writelines(lines)