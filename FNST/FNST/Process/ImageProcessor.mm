//
//  ImageProcessor.m
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/17/20.
//  Copyright © 2020 rusito.23. All rights reserved.
//

#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc_c.h>
#include <opencv2/imgproc/imgproc.hpp>

#import "UIImage+OpenCV.h"
#import "Utils.h"
#import "ImageProcessor.h"
#import "Transfer.h"

@interface ImageProcessor ()
@property(nonatomic) Transfer *transfer;
@end

static const char *kProcessorSerialQueue = "com.rusito23.image.processor.serial.queue";

@implementation ImageProcessor

#pragma mark - Threading

void dispatch_on_main(dispatch_block_t block) {
  if (block == nil) return;
  if (NSThread.isMainThread) {
    block();
  } else {
    dispatch_async(dispatch_get_main_queue(), block);
  }
}

void dispatch_on_queue(dispatch_block_t block) {
  if (block == nil) return;
  dispatch_async(dispatch_queue_create(kProcessorSerialQueue, DISPATCH_QUEUE_SERIAL), block);
}

#pragma mark - Initialization

-(id) initWithPredictor:(Transfer *)transfer {
  self = [super init];
  self.transfer = transfer;
  return self;
}

+(void) createInstanceWithModelName:(NSString*)modelName andCompletion:(void (^)(BOOL succeeded, NSError *error, id instance))completion {
  dispatch_on_queue(^{
    NSError *error;

    // create predictor
    Transfer *transfer = [[Transfer alloc] initWithModelName:modelName andError:&error];
    if (!transfer || !transfer.isValid || error) {
      NSLog(@"Failed to initiate predictor in FrameProcessor with error: %@!", error.localizedDescription);
      dispatch_on_main(^{
        completion(NO, error, nil);
      });
      return;
    }

    // create instance
    id instance = [[ImageProcessor alloc] initWithPredictor:transfer];
    dispatch_on_main(^{
      completion(YES, nil, instance);
    });
  });
}

#pragma mark - Processing

-(void) processImage:(UIImage *)image withCompletion:(void (^)(BOOL, UIImage *))completion {

  // process image
  DefineWeakSelf;
  dispatch_on_queue(^{
    DefineStrongSelf;

    // preprocess source image
    cv::Mat source = [UIImage toCvMat:image];
    CvSize size = cvSize(source.cols, source.rows);
    cv::cvtColor(source, source, CV_BGRA2BGR);
    source.convertTo(source, CV_32FC3, 1.0 / 255.0);
    cv::rotate(source, source, cv::ROTATE_90_CLOCKWISE);

    // get mask
    [self.transfer processImage:source withCompletion:^void(BOOL success, cv::Mat mask) {

      // error handling
      if (!success){
        dispatch_on_main(^{
          completion(NO, nil);
        });
        return;
      }

      mask.convertTo(mask, CV_8UC4);
      cv::resize(mask, mask, size);
      UIImage *resultImage = [UIImage fromCvMat:mask];

      // perform completion
      dispatch_on_main(^{ completion(YES, resultImage); });
    }];

  });
}



@end
