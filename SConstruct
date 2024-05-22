#!/usr/bin/env python
import os
import sys

env = SConscript("godot-cpp/SConstruct")

CacheDir('./.cache')

# For reference:
# - CCFLAGS are compilation flags shared between C and C++
# - CFLAGS are for C-specific compilation flags
# - CXXFLAGS are for C++-specific compilation flags
# - CPPFLAGS are for pre-processor flags
# - CPPDEFINES are for pre-processor defines
# - LINKFLAGS are for linking flags

# tweak this if you want to use different folders, or more folders, to store your source code in.
env.Append(CPPPATH=["src/", "src/octree"])
sources = Glob("src/*.cpp")
sources += Glob("src/octree/demo.cpp")


if env["platform"] == "macos":
    library = env.SharedLibrary(
        "game/bin/terrarian_generator.{}.{}.framework/terrarian_generator.{}.{}".format(
            env["platform"], env["target"], env["platform"], env["target"]
        ),
        source=sources,
    )
else:
    library = env.SharedLibrary(
        "game/bin/terrarian_generator{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )

Default(library)
