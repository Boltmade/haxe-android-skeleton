#!/bin/sh

if [ -e ./root ]; then
	if [ "$(readlink ./root)" != "/" ]; then
		echo "./root exists and does not point to /" >&2
		exit 1
	fi
else
	ln -s / ./root # Because relative paths
fi

cat haxe/build.hxml > build.hxml
SDK_DIR="$(cat *.properties | grep '^sdk\.dir=' | cut -d= -f2-)"
if [ -z "$SDK_DIR" ]; then
	SDK_DIR="$ANDROID_HOME"
fi

if [ -z "$SDK_DIR" ]; then
	echo "Could not find the Android SDK, please set ANDROID_HOME" >&2
	exit 1
fi

TARGET="$(cat *.properties | grep '^target=' | cut -d= -f2-)"
echo "-java-lib ./root$SDK_DIR/platforms/$TARGET/android.jar" >> build.hxml

cat *.properties | grep '^android\.library\.reference\.[0-9]*=' | cut -d= -f2- | while read -r LIB; do
	ls "$(echo "$LIB" | sed -e"s/\\\${sdk\\.dir}/$(echo $SDK_DIR | sed -e's/\//\\\//g')/")"/libs/*.jar | while read -r JAR; do
		echo "-java-lib $JAR" >> build.hxml
	done
done

echo "-cp bin/" >> build.hxml # For R.txt
echo "-cp haxe/" >> build.hxml

find haxe/ -name '*.hx' | while read -r HX; do
	HX="${HX#haxe/}"
	echo "${HX%.hx}" | tr / . >> build.hxml
done

echo "-java ." >> build.hxml
echo "-D no-compilation" >> build.hxml
