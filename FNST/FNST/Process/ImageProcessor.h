//
//  ImageProcessor.h
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/17/20.
//  Copyright © 2020 rusito.23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageProcessor : NSObject
+(void) createInstanceWithModelName:(NSString*)modelName andCompletion:(void (^)(BOOL succeeded, NSError *error, id instance))completion;
-(void) processImage:(UIImage*)image withCompletion:(void (^)(BOOL success, UIImage *result))completion;
@end

NS_ASSUME_NONNULL_END
