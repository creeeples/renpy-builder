#!/bin/sh

sdk_name=renpy-$1-sdk
echo "Downloading RenPy SDK v(${sdk_name})..."
wget -q https://www.renpy.org/dl/$1/${sdk_name}.tar.bz2
clear

echo "Downloaded SDK version (${sdk_name})."
echo "Setting up the specified SDK (${sdk_name})..."
tar -xf ./${sdk_name}.tar.bz2
rm ./${sdk_name}.tar.bz2
mv ./${sdk_name} ../renpy

# Download and install Ren'Py Android Packaging Tool (RAPT)
echo "Downloading Ren'Py Android Packaging Tool (RAPT)..."
wget -q https://www.renpy.org/dl/$1/renpy-$1-sdk-rapt.tar.bz2
echo "Installing Ren'Py Android Packaging Tool (RAPT)..."
tar -xf ./renpy-$1-sdk-rapt.tar.bz2 -C ../renpy/
rm ./renpy-$1-sdk-rapt.tar.bz2

case $3 in
    pc|mac|linux|market|web|android)
        COMMAND="../renpy/renpy.sh ../renpy/launcher distribute --package $3 $2"
        ;;
    *)
        COMMAND="../renpy/renpy.sh ../renpy/launcher distribute $2"
        ;;
esac

echo "Building the project at $2..."
if $COMMAND; then
    built_dir=$(ls | grep '\-dists')
    echo ::set-output name=dir::$built_dir
    echo ::set-output name=version::${built_dir%'-dists'}
else
    return 1
fi
