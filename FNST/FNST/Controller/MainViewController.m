//
//  ViewController.m
//  FNST
//
//  Created by Igor Andruskiewitsch on 5/17/20.
//  Copyright © 2020 rusito.23. All rights reserved.
//

#import "MainViewController.h"
#import "NSString+Localized.h"
#import "MainFont.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup title
    [[self titleLabel] setFont:MainFont.title];
    [[self titleLabel] setText:@"TITLE_LABEL".localized];
}


@end
