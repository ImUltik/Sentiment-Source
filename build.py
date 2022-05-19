# TODO 
# auto-preobfuscate, auto-test* if possible

import os.path 
from os import mkdir
from re import findall, sub

buildFile = open('sentiment.lua', 'r')
buildLines = buildFile.read()

lineCount = len(findall("\n", buildLines))
commentCount = len(findall("--.*", buildLines))

buildLines = sub("--.*\n", "", buildLines)

print("{*} Removed ", commentCount, " comments!")
print("{*} Writing ", lineCount, " lines!")


if(os.path.exists("build")):
    print("{*} Writing to ./build/compiled.lua")
else:
    print("{*} Creating build folder")
    mkdir("build")
    print("{*} Writing to ./build/compiled.lua")

compiledFile = open("build/compiled.lua", 'w')
compiledFile.write(buildLines)