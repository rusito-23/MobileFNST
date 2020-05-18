//
//  ViewController.m
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/17/20.
//  Copyright © 2020 rusito.23. All rights reserved.
//

#import "Utils.h"
#import "MainViewController.h"
#import "NSString+Localized.h"
#import "MainFont.h"
#import "ImageProcessor.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *originalImage;
@property (weak, nonatomic) IBOutlet UIImageView *transferImage;

@property (strong, nonatomic) ImageProcessor *processor;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup title
    [self.titleLabel setFont:MainFont.title];
    [self.titleLabel setText:@"TITLE_LABEL".localized];

    // setup original
    [self.originalImage setImage:[UIImage imageNamed:@"cv"]];

    // setup processor
    DefineWeakSelf;
    [ImageProcessor createInstanceWithModelName:@"candy" andCompletion: ^(BOOL succeeded, NSError *error, id instance) {
        DefineStrongSelf;
        if (error) {
            // TODO: show something!
            return;
        }
        self.processor = instance;
        [self processExample];
    }];
}

- (void) processExample {
    UIImage *example = [UIImage imageNamed:@"cv"];
    [self.processor processImage:example withCompletion:^(BOOL success, UIImage *result){
        [self.transferImage setImage:result];
    }];
}


@end
