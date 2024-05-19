#!/bin/bash

old="$PWD"
cd ..

goopie="false"
for arg in "$@"; do
    if [ "$arg" == "/F" ]; then
        goopie="true"
        echo "Skipping export stuff (fast mode)"
    fi
done

if [ -d "$PWD/export" ]; then
    echo "found it!"
else
    cd "$old"
    if [ -d "$PWD/export" ]; then
        echo "found in old directory"
    fi
fi

if [ -f "$PWD/Project.xml" ]; then
    echo "this is a valid project!"
else
    echo "not a valid project. CD to the right directory!"
fi

if [ -d "$PWD/export" ]; then
    if [ "$goopie" == "true" ]; then
        # We skip to the build process because it's faster
        build
        exit 0
    fi
    clean
else
    build
fi

exit 0

clean() {
    echo "cleaning out exports folder (stuff can be left behind)"
    rm -rf "$PWD/export/linux/"
}

build() {
    echo "building the game"
    if [ -d "$PWD/export/linux" ]; then
        echo "this will take a few seconds to minutes, but not too much"
    else
        echo "this will take a few minutes, since there's no export folder to build on"
    fi
    haxelib run lime build linux > "$PWD/build.log"
    echo "done! the output can be found in $PWD/build.log"
}

# Start the script by calling the appropriate function
if [ "$goopie" == "true" ]; then
    build
else
    clean
    build
fi
