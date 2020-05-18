//
//  Constants.h
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/17/20.
//  Copyright © 2020 rusito.23. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Constants_h
#define Constants_h

#define SIZE 224
#define CHANNELS 3
#define BATCH_SIZE 1

static NSArray<NSNumber *> *INPUT_SHAPE = @[@BATCH_SIZE, @CHANNELS, @SIZE, @SIZE];
static NSArray<NSNumber *> *OUTPUT_SHAPE = @[@BATCH_SIZE, @CHANNELS, @SIZE, @SIZE];

static const NSUInteger INPUT_LEN = SIZE * SIZE * CHANNELS;
static const NSUInteger OUTPUT_LEN = SIZE * SIZE * CHANNELS;

#endif /* Constants_h */
