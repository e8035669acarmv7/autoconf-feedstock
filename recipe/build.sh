#!/bin/bash

set -euxo pipefail

pushd build-aux
  cp ${BUILD_PREFIX}/share/gnuconfig/config.* .
popd

./configure --prefix=${PREFIX}        \
            --libdir=${PREFIX}/lib    \
            --build=${BUILD}          \
            --host=${HOST}            \
            PERL="${PREFIX}/bin/perl"

make -j${CPU_COUNT}
if [[ "$build_platform" == "$target_platform" ]]; then
  make check || { cat tests/testsuite.log; exit 1; }
fi
make install
