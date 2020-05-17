#!/bin/sh

# define paths
MODELS=models
ONNX=$MODELS/onnx
TF=$MODELS/tf
TFLITE=$MODELS/tflite

# define helpful vars 
styles=(mosaic candy rain-princess udnie pointilism)

# download ONNX models
if [ ! -d $ONNX ]; then
    mkdir -p $ONNX
    for x in ${styles[@]}; do
        wget https://github.com/onnx/models/raw/master/vision/style_transfer/fast_neural_style/model/$x-9.onnx -P $ONNX
    done
fi

# convert all to tf 
if [ ! -d $TF ]; then
    mkdir -p $TF
    for x in ${styles[@]}; do
        onnx-tf convert -i $ONNX/$x-9.onnx -o $TF/$x.pb
    done
fi

# convert all to tflite 
if [ ! -d $TFLITE ]; then
    mkdir -p $TFLITE
    for x in ${styles[@]}; do
        tflite_convert \
            --output_file=$TFLITE/$x.tflite \
            --graph_def_file=$TF/$x.pb \
            --input_arrays='input1' \
            --output_arrays='output1'
    done
fi
