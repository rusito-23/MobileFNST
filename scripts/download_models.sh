#!/bin/sh

# escape on errors
set -e

# check if we are on the right path

if [ ! -d scripts ]; then
    echo "This script should run from the repo root folder"
    exit 1
fi

# define paths
FNST=FNST/FNST
COREML_FOLDER=$FNST/Models

# create temp dir for onnx models
ONNX_FOLDER=`mktemp /tmp/fnst-onnx-models-XXXXX`
trap "rm -rf $ONNX_FOLDER" exit

# define helpful vars 
styles=(mosaic candy rain-princess udnie pointilism)

# download ONNX models
for x in ${styles[@]}; do
    wget https://github.com/onnx/models/raw/master/vision/style_transfer/fast_neural_style/model/$x-8.onnx -P $ONNX_FOLDER
done

# convert all to coreml
mkdir -p $COREML_FOLDER
for x in ${styles[@]}; do
    python scripts/convert_coreml.py $ONNX_FOLDER/$x-8.onnx $COREML_FOLDER/$x.mlmodel
done

echo "Done! Models saved into ${COREML_FOLDER} folder"
