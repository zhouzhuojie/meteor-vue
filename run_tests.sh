#!/bin/bash

## Tiny script to copy the package into the test meteor app

DEST_PATH=./tests/packages/vue

# reset and create the package-folder
if [[ -d $DEST_PATH ]]; then
  rm -rf $DEST_PATH/lib
  rm -rf $DEST_PATH/package.js
fi
mkdir -p $DEST_PATH

cp -rf lib $DEST_PATH/lib
cp package.js $DEST_PATH/package.js

cd tests/
coffee --compile --output tests tests
laika
cd ..
