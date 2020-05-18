    //
    //  Transfer.m
    //  FNST
    //
    //  Created by Igor Andruskiewitsch on 5/17/20.
    //  Copyright © 2020 rusito.23. All rights reserved.
    //

#include "Transfer.h"
#include "Constants.h"
#include "Messages.h"
#include <TensorFlowLiteObjC/TFLTensorFlowLite.h>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc_c.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <math.h>

#pragma mark - Properties

@interface Transfer ()
@property(nonatomic) TFLInterpreter *interpreter;
@end

static NSString *const kModelType = @"tflite";

@implementation Transfer

#pragma mark - Initialization

- (instancetype) initWithModelName:(NSString*)modelName andError:(NSError * __autoreleasing *)error {
    self = [super init];

    // interpreter options (CPU with 2 threads)
    TFLInterpreterOptions *options = [[TFLInterpreterOptions alloc] init];
    options.numberOfThreads = 2;

    // initialization
    NSBundle *currentBundle = [NSBundle bundleForClass:[Transfer class]];
    NSString *modelPath = [currentBundle pathForResource:modelName ofType:kModelType];
    self.interpreter = [[TFLInterpreter alloc] initWithModelPath:modelPath error:error];

    NSError *err;

    // reshape input tensor
    if (![self.interpreter resizeInputTensorAtIndex:0 toShape:INPUT_SHAPE error:&err]) {
        NSLog(kTransferError, @"Reshape input tensor", err.localizedDescription);
        return nil;
    }

    // reshape output tensor
    if (![self.interpreter resizeInputTensorAtIndex:0 toShape:OUTPUT_SHAPE error:&err]) {
        NSLog(kTransferError, @"Reshape output tensor", err.localizedDescription);
        return nil;
    }

    // alloc all tensors
    if (![self.interpreter allocateTensorsWithError:&err]) {
        NSLog(kTransferError, @"Allocate all tensors", err.localizedDescription);
        return nil;
    }

    return self;
}

- (BOOL) isValid {
    return self.interpreter != nil;
}

#pragma mark - Predict

- (void) processImage:(cv::Mat)src withCompletion:(void (^)(BOOL, cv::Mat))completion {

    NSError *error;

    // check if interpreter is available
    if (self.interpreter == nil) {
        NSLog(kTransferError, @"Check interpreter", @"Interpreter is nil");
        completion(NO, cv::Mat());
        return;
    }

    // create input tensor
    TFLTensor *inputTensor = [self.interpreter inputTensorAtIndex:0 error:&error];
    if (inputTensor == nil || error != nil) {
        NSLog(kTransferError, @"Create input tensor", error.localizedDescription);
        completion(NO, cv::Mat());
        return;
    }

    // create input tensor data
    NSMutableData *inputData = [NSMutableData dataWithBytes:src.data length:(sizeof(float)*INPUT_LEN)];
    if (![inputTensor copyData:inputData error:&error]) {
        NSLog(kTransferError, @"Create input tensor data", error.localizedDescription);
        completion(NO, cv::Mat());
        return;
    }

    // invoke
    if (![self.interpreter invokeWithError:&error]) {
        NSLog(kTransferError, @"Invoke interpreter", error.localizedDescription);
        completion(NO, cv::Mat());
        return;
    }

    // get output tensor
    TFLTensor *outputTensor = [self.interpreter outputTensorAtIndex:0 error:&error];
    if (outputTensor == nil || error != nil) {
        NSLog(kTransferError, @"Get output tensor", error.localizedDescription);
        completion(NO, cv::Mat());
        return;
    }

    // get output data
    NSData *outputData = [outputTensor dataWithError:&error];
    if (outputData == nil || error != nil) {
        NSLog(kTransferError, @"Get output data", error.localizedDescription);
        completion(NO, cv::Mat());
        return;
    }

    // convert output data to resulting Mat
    float *o = (float*)malloc(OUTPUT_LEN * sizeof(float));
    [outputData getBytes:o length:(sizeof(float)*OUTPUT_LEN)];

    // transpose
    float *transposed = (float*)malloc(OUTPUT_LEN * sizeof(float));
    int j = 0;
    for (int i = 0; i < SIZE; i++) {
        transposed[j] = o[i];
        transposed[j++] = o[i + SIZE];
        transposed[++j] = o[i + 2*SIZE];
    }

    cv::Mat result(SIZE, SIZE, CV_32FC3, transposed);
    free(o); free(transposed);


    NSLog(kTransferSuccess);
    completion(YES, result);
}

@end
