#!/bin/bash
# Required build variables,  adjust according to your own.
# Path to toolchain
  cco=~/kernel/android-toolchain-eabi/bin/arm-eabi-
# Path to build your kernel
  k=~/kernel/android_kernel_samsung_tuna
# Directory for the any kernel updater
  t=$k/tools/bbk
# Export betas to your dropbox
  db=~/kernel
# Clean old builds
   echo "Clean"
     rm -rf $k/out
 cd $k/arch/arm/configs/BBKconfigs
    for c in *
      do
        cd $k
# Setup output directory
       mkdir -p "out/$c"
          cp -R "$t/system" out/$c
          cp -R "$t/META-INF" out/$c
          cp -R "$t/kernel" out/$c
       mkdir -p "out/$c/system/lib/modules/"

# Sneak in variables depending on $c
# Modules dir (shouldn't need changed)
  m=$k/out/$c/system/lib/modules

# Compile Kernels
   echo ""
   echo "Compiling $c"
   echo ""

    export ARCH=arm SUBARCH=arm CROSS_COMPILE=$cco
cp $k/arch/arm/configs/BBKconfigs/$c "$k/.config"
	make clean
	make -j8 zImage
# Grab modules & zImage
   echo ""
   echo "<<>><<>>  Collecting Files <<>><<>>"
   echo ""
cp $k/arch/arm/boot/zImage out/$c/kernel/zImage

# Thanks to CVPCS for this improvement
for mo in $(find . -name "*.ko"); do
		cp "${mo}" $m
done
# Zip
 clear
   echo "<<>><<>>  Creating $c.zip  <<>><<>>"
     cd $k/out/$c/
       7z a "$c.zip"
         mv $c.zip $k/out/$c.zip
cp $k/out/$c.zip $db/$c.zip
           rm -rf $k/out/$c
# Line below for debugging purposes,  uncomment to stop script after each config is run
#read this
      done
