#!/usr/bin/env bash
set -euo pipefail
cd "${BUILD_WORKSPACE_DIRECTORY:?Run with bazel run //:release}"

bazel coverage "$@" //:all_tests --combined_report=lcov
mkdir -p coverage
cp -f bazel-out/_coverage/_coverage_report.dat coverage/lcov.dat
printf 'Coverage: %s/coverage/lcov.dat\n' "$PWD"

# Lint clean classes and package without coverage instrumentation.
bazel build "$@" //:app //:composition //:entrypoint //:all_tests //:app_bin_deploy.jar --config=lint --nocollect_code_coverage
