#!/bin/bash

# Config
echo ""
echo "========== Configs =========="
if [[ -n "${infer_source_dir}" ]]; then
	echo "infer_source_dir: ${infer_source_dir}"
else
	echo "infer_source_dir: this is required"
	exit 1
fi
if [[ -n "${infer_gradle_task}" ]]; then
	echo "infer_gradle_task: ${infer_gradle_task}"
else
	echo "infer_gradle_task: this is required"
	exit 1
fi
if [[ -n "${infer_debug_mode}" ]]; then
	echo "infer_debug_mode: ${infer_debug_mode}"
else
	echo "infer_debug_mode: this is required"
	exit 1
fi
echo "============================="
echo ""

if [[ "${infer_debug_mode}" = true ]]; then
	set -e
	set -x
fi

#
# go to project folder
cd "${infer_source_dir}"

#
## Install Infer
# wget -O Dockerfile https://raw.githubusercontent.com/facebook/infer/master/docker/Dockerfile
# wget -O run.sh https://raw.githubusercontent.com/facebook/infer/master/docker/run.sh

# wget -O Dockerfile https://raw.githubusercontent.com/facebook/infer/2e5da306071e81f7daca90f788abd337a7561796/docker/Dockerfile
# wget -O run.sh https://raw.githubusercontent.com/facebook/infer/2e5da306071e81f7daca90f788abd337a7561796/docker/run.sh

# wget -O Dockerfile https://raw.githubusercontent.com/facebook/infer/v0.8.0/docker/Dockerfile
# wget -O run.sh https://raw.githubusercontent.com/facebook/infer/v0.8.0/docker/run.sh

# sh run.sh

brew update
brew install opam
opam init -y --comp=4.02.3

wget -O infer-linux64.tar.xz https://github.com/facebook/infer/releases/download/v0.8.1/infer-linux64-v0.8.1.tar.xz
tar xf infer-linux64.tar.xz
cd infer-linux64-v0.8.1/

eval $(opam config env)
opam update
opam pin add --yes --no-action infer .
opam install --deps-only infer
eval $(opam config env)

./build-infer.sh
export PATH=`pwd`/infer/bin:$PATH

#
# # Execute Infer
./gradlew clean
infer -- ./gradlew "${infer_gradle_task}"

export INFER_ANDROID_OUTPUT_FILE="$PWD/infer-out/report.json"
envman add --key INFER_ANDROID_OUTPUT_FILE --value "$PWD/infer-out/report.json"
echo ""
echo "========== Outputs =========="
echo "INFER_ANDROID_OUTPUT_FILE: ${INFER_ANDROID_OUTPUT_FILE}"
echo "============================="
echo ""

exit 0
