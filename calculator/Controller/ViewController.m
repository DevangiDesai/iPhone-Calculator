//
//  ViewController.m
//  calculator
//
//  Created by Devangi Desai on 03/10/16.
//  Copyright © 2016 Devangi Desai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *displayLabel;
@property BOOL userIsCreatingNumber;
@property BOOL lockOperatorButtons;
@property (nonatomic, strong) CalcModel* calcModel;
@property (nonatomic, strong) NSMutableString *displayValue;
@property (nonatomic, strong) NSTimer *eraseButtonTimer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.calcModel = [CalcModel new];
    self.displayValue = [NSMutableString stringWithCapacity:40];
    self.calcModel.longDataValue = @"";
    self.eraseButtonTimer = [[NSTimer alloc] init];
}

#pragma mark -----------------------------------

- (IBAction)beginErase {
    [self eraseDigit];
    self.eraseButtonTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(eraseDigit) userInfo:nil repeats:YES];
}

- (void)eraseDigit
{
    self.displayValue = [self.displayLabel.text mutableCopy];
    if (![self.displayValue isEqualToString:@""])
    {
        [self.displayValue deleteCharactersInRange:NSMakeRange([self.displayValue length]-1, 1)];
    }
    else if (self.eraseButtonTimer != nil)
    {
        [self.eraseButtonTimer invalidate];
        self.eraseButtonTimer = nil;
    }
    else
    {
        [self allClearButtonTouchUpInside:nil];
    }
    
    self.displayLabel.text = self.displayValue;
    
    if(self.displayValue == nil || self.displayValue.length ==0 || [self.displayValue isEqual:@""] || self.displayValue == NULL || [self.displayValue isEqualToString:@""])
    {
        [self allClearButtonTouchUpInside:nil];
    }
    
}

- (IBAction)endErase {
    if (self.eraseButtonTimer != nil)
        [self.eraseButtonTimer invalidate];
    self.eraseButtonTimer = nil;
}

#pragma mark Button "." pressed
- (IBAction)decimalPointButtonTouchUpInside:(UIButton *)sender
{
    if (!self.userIsCreatingNumber) {
        self.userIsCreatingNumber = YES;
        self.displayLabel.text = @"0";
    }
    NSRange range = [self.displayLabel.text rangeOfString:@"."];
    if (range.location == NSNotFound) {
        self.displayLabel.text = [self.displayLabel.text stringByAppendingString:@"."];
        self.userIsCreatingNumber = YES;
    }
    self.lockOperatorButtons = NO;
}

#pragma mark Button "=" pressed
- (IBAction)solutionButtonTouchUpInside:(UIButton *)sender
{
    if (self.calcModel.stackDouble != 0.0 && self.lockOperatorButtons == NO)
    {
        double result = [self.calcModel performOperationWithNumber:[self.displayLabel.text doubleValue]];
        if (result == INFINITY)
        {
            self.displayLabel.text = [NSString stringWithFormat:@"Error"];
        }
        else
        {
            self.displayLabel.text = [NSString stringWithFormat:@"%g", result];
        }

        self.calcModel.stackOperator = @"";
        self.calcModel.stackDouble = 0.0;
        self.userIsCreatingNumber = NO;
        self.lockOperatorButtons = NO;
        self.calcModel.longDataValue = @"";
        self.calcModel.stackOperatorsArray = [[NSMutableArray alloc] init];
        self.calcModel.stackNumbersArray = [[NSMutableArray alloc] init];
    }
}

#pragma mark Buttons "+-*/" pressed
- (IBAction)operationButtonTouchUpInside:(UIButton *)sender
{
    NSString *operation = sender.titleLabel.text;
    if ([self.displayLabel.text doubleValue] != 0)
    {
        self.displayLabel.text = [self.displayLabel.text stringByAppendingString:operation];
    }

    if (self.lockOperatorButtons == NO)
    {
        if (self.calcModel.stackDouble == 0.0)
        {
            self.calcModel.stackDouble = [self.displayLabel.text doubleValue];
        }

        self.lockOperatorButtons = YES;
        self.userIsCreatingNumber = NO;
    }
    
    self.calcModel.longDataValue = [self.calcModel.longDataValue stringByAppendingString:operation];
    [self.calcModel.stackOperatorsArray addObject:operation];
    self.calcModel.stackOperator = operation;
}


#pragma mark Buttons "0-9" pressed
- (IBAction)numberButtonTouchUpInside:(UIButton *)sender
{
    NSString *keyNumber = sender.titleLabel.text;
    if (!self.userIsCreatingNumber)
    {
        [self.calcModel.stackNumbersArray addObject:[NSNumber numberWithDouble:[keyNumber doubleValue]]];
        self.userIsCreatingNumber = YES;
        self.displayLabel.text = @"";
    }
    self.displayLabel.text = [self.displayLabel.text stringByAppendingString:keyNumber];
    self.calcModel.longDataValue = [self.calcModel.longDataValue stringByAppendingString:keyNumber];

    if ([self.displayLabel.text isEqualToString:@"00"]) {
        self.calcModel.longDataValue = [self.calcModel.longDataValue stringByAppendingString:keyNumber];
        self.displayLabel.text = self.displayLabel.text = @"0";
        self.userIsCreatingNumber = NO;
    }
    

    self.lockOperatorButtons = NO;
}

#pragma mark Button "+/-" pressed
- (IBAction)signButtonTouchUpInside:(UIButton *)sender
{
    double a = [self.displayLabel.text doubleValue];
    double new = 0.0;
    if (a >= 0.0) {
        new = - a;
        self.calcModel.longDataValue = [self.calcModel.longDataValue stringByAppendingString:@"-"];

    } else {
        new = -1 * a;
    }
    
    self.displayLabel.text = [NSString stringWithFormat:@"%g", new];
    self.lockOperatorButtons = NO;
}

#pragma mark Button "AC" pressed
- (IBAction)allClearButtonTouchUpInside:(UIButton *)sender
{
    self.displayLabel.text = @"0";
    self.calcModel.stackDouble = 0.0;
    self.calcModel.stackOperator = @"";
    self.userIsCreatingNumber = NO;
    self.lockOperatorButtons = NO;
    self.calcModel.longDataValue = @"";
    self.calcModel.stackOperatorsArray = [[NSMutableArray alloc] init];
    self.calcModel.stackNumbersArray = [[NSMutableArray alloc] init];
}

#pragma mark -----------------------------------

- (UIStatusBarStyle)preferredStatusBarStyle
{
    // A light status bar, intended for use on dark backgrounds
    return UIStatusBarStyleLightContent;
}



@end
