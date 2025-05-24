#!/bin/sh
set -eu

# setting cache folder
export PUB_CACHE=/tmp/dart-cache

# creating a temporary directory for the build
BUILD_DIR=/tmp/aws-lambda-dart-runtime
mkdir -p $BUILD_DIR
cp -Rp /app/* $BUILD_DIR
cd $BUILD_DIR/example
ls -l
# setup deps
dart pub get
# build the binary
dart compile exe lib/main.dart -o bootstrap
# move this back to app
mv bootstrap /app/bootstrap
