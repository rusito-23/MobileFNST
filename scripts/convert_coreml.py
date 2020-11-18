import sys
from onnx_coreml import convert
import coremltools


if __name__ == '__main__':
    # convert
    coremlmodel = convert(
        sys.argv[1],
        image_input_names=['input1'],
        image_output_names=['output1'],
        minimum_ios_deployment_target='12'
    )

    # save
    coremlmodel.save(sys.argv[2])
