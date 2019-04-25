//
//  RBSViewController.m
//  RBSBorderText
//
//  Created by rbbtsn0w on 04/25/2019.
//  Copyright (c) 2019 rbbtsn0w. All rights reserved.
//

#import "RBSViewController.h"
@import RBSBorderText;

@interface RBSViewController ()

@property (nonatomic, strong) RBSBorderTextLabel *tagLabel;

@end

@implementation RBSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tagLabel = [[RBSBorderTextLabel alloc] initWithFrame:CGRectZero textContainer:nil];
    self.tagLabel.numberOfLines = 2;
    [self.view addSubview:self.tagLabel];

    NSTextStorage *textStorageConfig = [self textStorageConfig];
    [self.tagLabel.textStorage replaceCharactersInRange:NSMakeRange(0, 0) withAttributedString:textStorageConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGSize resultSize = [self.tagLabel sizeThatFits:CGSizeMake(self.view.bounds.size.width, CGFLOAT_MAX)];
    self.tagLabel.frame = CGRectMake(0, 0, resultSize.width, resultSize.height);
    self.tagLabel.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
}

- (NSTextStorage *)textStorageConfig {
    
    NSString *tagString = NSLocalizedString(@"Hello Border Text!", nil);
    NSString *subTitle = @"SubTitle";
    
    NSMutableString *mString = [[NSMutableString alloc] initWithString:tagString];
    [mString insertString:@"   " atIndex:0];
    [mString appendString:@"   "];
    
    RBSBorderTextStyle *borderStyle = [[RBSBorderTextStyle alloc] init];
    borderStyle.color = [UIColor greenColor];
    borderStyle.fillColorOnBackground = YES;
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:mString
                                                            attributes:@{
                                                                         RBSBorderTextStyleAttributeName: borderStyle,
                                                                         NSForegroundColorAttributeName: [UIColor blueColor],
                                                                         NSFontAttributeName: [UIFont systemFontOfSize:18]
                                                                         }];
    
    NSAttributedString *subMString = [[NSAttributedString alloc] initWithString:subTitle
                                                                     attributes:@{
                                                                                  NSFontAttributeName: [UIFont systemFontOfSize:22],
                                                                                  NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                  }];
    [textStorage appendAttributedString:subMString];
    
    return textStorage;
}

@end
