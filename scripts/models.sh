#!/bin/sh

# define paths
MODELS=models
ONNX=$MODELS/onnx
COREML=$MODELS/coreml

# define helpful vars 
styles=(mosaic candy rain-princess udnie pointilism)

# download ONNX models
if [ ! -d $ONNX ]; then
    mkdir -p $ONNX
    for x in ${styles[@]}; do
        wget https://github.com/onnx/models/raw/master/vision/style_transfer/fast_neural_style/model/$x-8.onnx -P $ONNX
    done
fi

# convert all to coreml
if [ ! -d $COREML ]; then
    mkdir -p $COREML
    for x in ${styles[@]}; do
        python scripts/convert_coreml.py $ONNX/$x-8.onnx $COREML/$x.mlmodel
    done
fi
