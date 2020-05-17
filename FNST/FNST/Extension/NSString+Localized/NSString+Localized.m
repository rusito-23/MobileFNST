//
//  NSString+Localized.m
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/17/20.
//  Copyright © 2020 rusito.23. All rights reserved.
//

#import "NSString+Localized.h"


@implementation NSString (Localized)

-(NSString *) localized {
    return NSLocalizedString(self, nil);
}

@end
