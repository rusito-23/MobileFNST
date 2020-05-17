//
//  Transfer.h
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/17/20.
//  Copyright © 2020 rusito.23. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <opencv2/core/core.hpp>

NS_ASSUME_NONNULL_BEGIN

@interface Transfer : NSObject
-(instancetype) initWithModelName:(NSString*)modelName andError:(NSError * __autoreleasing *)error;
-(BOOL) isValid;
-(void) processImage:(cv::Mat) src withCompletion:(void (^)(BOOL succeeded, cv::Mat result)) completion;
@end

NS_ASSUME_NONNULL_END
