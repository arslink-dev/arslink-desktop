#!/bin/bash
set -e

rm -rf $DEST
mkdir -p $DEST

#### copy golang => .app ####
source "$(dirname "$0")/extract_core_artifact.sh"

mv deployment/$DEST_SUFFIX/* $GITHUB_WORKSPACE/build/ArsLink.app/Contents/MacOS

#### deploy qt & Dylib runtime => .app ####
pushd $GITHUB_WORKSPACE/build
macdeployqt ArsLink.app -verbose=3
popd

codesign --force --deep --sign - $GITHUB_WORKSPACE/build/ArsLink.app

dsymutil $GITHUB_WORKSPACE/build/ArsLink.app/Contents/MacOS/ArsLink
strip -S $GITHUB_WORKSPACE/build/ArsLink.app/Contents/MacOS/ArsLink

mv $GITHUB_WORKSPACE/build/ArsLink.app $DEST
