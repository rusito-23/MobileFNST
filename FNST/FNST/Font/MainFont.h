//
//  MainFont.h
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/17/20.
//  Copyright © 2020 rusito.23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainFont : NSObject
+ (UIFont *) title;
+ (UIFont *) subtitle;
+ (UIFont *) button;
+ (UIFont *) paragraph;
+ (UIFont *) miniParagraph;
@end

NS_ASSUME_NONNULL_END
