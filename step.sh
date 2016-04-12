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
if [[ -n "${infer_debug_mode}" ]]; then
	echo "infer_debug_mode: ${infer_debug_mode}"
fi
echo "============================="
echo ""

if [[ "${infer_debug_mode}" = true ]]; then
	set -x
fi
#
# go to project folder
cd "${infer_source_dir}"

#
# # Execute Infer
./gradlew clean
infer -- ./gradlew assemble

exit 0
