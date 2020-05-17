//
//  Constants.h
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/17/20.
//  Copyright © 2020 rusito.23. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define SIZE 224
#define CHANNELS 3
#define BATCH_SIZE 1

#define INPUT_SHAPE @[@BATCH_SIZE, @SIZE, @SIZE, @CHANNELS]
#define INPUT_LEN SIZE * SIZE * CHANNELS

#define OUTPUT_SHAPE @[@BATCH_SIZE, @SIZE, @SIZE, @CHANNELS]
#define OUTPUT_LEN SIZE * SIZE * CHANNELS

// #define INPUT_SIZE cvSize(128, 128)
#define RES_SHAPE {64, 64}

#endif /* Constants_h */
