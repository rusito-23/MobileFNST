//
//  MainFont.m
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/17/20.
//  Copyright © 2020 rusito.23. All rights reserved.
//

#import "MainFont.h"

static NSString  * _Nonnull const NAME = @"AppleSDGothicNeo-Regular";
static const CGFloat titleSize = 46.0;
static const CGFloat subtitleSize = 32.0;
static const CGFloat paragraphSize = 23.0;
static const CGFloat miniParagraphSize = 17.0;
static const CGFloat buttonSize = 23.0;

@implementation MainFont

+ (UIFont *) font:(CGFloat) size {
    UIFont *font = [UIFont fontWithName:NAME size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

+ (UIFont *) title {
    return [MainFont font:titleSize];
}

+ (UIFont *) subtitle {
    return [MainFont font:subtitleSize];
}

+ (UIFont *) button {
    return [MainFont font:buttonSize];
}

+ (UIFont *) paragraph {
    return [MainFont font:paragraphSize];
}

+ (UIFont *) miniParagraph {
    return [MainFont font:miniParagraphSize];
}

@end
