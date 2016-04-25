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
## Install Infer
# wget -O Dockerfile https://raw.githubusercontent.com/facebook/infer/master/docker/Dockerfile
# wget -O run.sh https://raw.githubusercontent.com/facebook/infer/master/docker/run.sh

wget -O Dockerfile https://raw.githubusercontent.com/facebook/infer/v0.8.1/docker/Dockerfile
wget -O run.sh https://raw.githubusercontent.com/facebook/infer/v0.8.1/docker/run.sh
sh run.sh

#
# go to project folder
cd "${infer_source_dir}"

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
