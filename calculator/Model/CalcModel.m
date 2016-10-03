//
//  CalcModel.m
//  calculator
//
//  Created by Devangi Desai on 03/10/16.
//  Copyright © 2016 Devangi Desai. All rights reserved.
//

#import "CalcModel.h"

@interface CalcModel()

@end

@implementation CalcModel

- (id)init
{
    self = [super init];
    if (self) {
        self.stackDouble = 0.0;
        self.stackOperator = @"";
        self.stackNumbersArray = [[NSMutableArray alloc] init];
        self.stackOperatorsArray = [[NSMutableArray alloc] init];
        self.dataIntStack = [[DataStack alloc] init];
        self.dataChStack = [[DataStack alloc] init];
    }
    return self;
}


- (double) performOperationWithNumber: (double) number_double
{
    double result = 0.0;
    
    if (self.stackNumbersArray.count > 2 && self.stackOperatorsArray.count > 1)
    {
        return [self performLongOperationWithNumber];
    }
    
    if ([self.stackOperator isEqualToString:@"+"]) {
        result = self.stackDouble + number_double;
    } else if ([self.stackOperator isEqualToString:@"-"]) {
        result = self.stackDouble - number_double;
    } else if ([self.stackOperator isEqualToString:@"*"]) {
        result = self.stackDouble * number_double;
    } else if ([self.stackOperator isEqualToString:@"/"]) {
        result = self.stackDouble / number_double;
    } else if ([self.stackOperator isEqualToString:@"%"]) {
        result = fmodf(self.stackDouble, number_double);
    } else if ([self.stackOperator isEqualToString:@"^"]) {
        result = pow(self.stackDouble, number_double);
    }
    self.stackDouble = result;
    return result;
}


- (double) performLongOperationWithNumber
{
    double result = 0.0;

//    NSString *s = @"-6-5+4*3^2^";
    NSString *s = self.longDataValue;
    NSMutableArray *tokens = [NSMutableArray array];
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];

    for (int i = 0; i < [s length]; i++) {
        [tokens addObject:[NSString stringWithFormat:@"%C", [s characterAtIndex:i]]];
    }

    for (int i = 0; i < tokens.count; i++)
    {
        NSMutableString *str = [[NSMutableString alloc] init];
        // Current token is a whitespace, skip it
        if ([tokens[i] isEqualToString:@" "])
            continue;
        
        NSLog(@"i = %d",i);
        NSLog(@"tokens[i] = %@",tokens[i]);
        
        // Current token is a number, push it to stack for numbers
        if ([tokens[i] rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        {
            // There may be more than one digits in number
            while (i < tokens.count && [tokens[i] rangeOfCharacterFromSet:notDigits].location == NSNotFound)
            {
                [str appendString:tokens[i++]];
            }
            
            NSNumber *number = [NSNumber numberWithInt:[str doubleValue]];
            [self.dataIntStack push:number];
            i--;
        }
        
        // Current token is an operator.
        else if ([tokens[i] isEqualToString:@"+"] || [tokens[i] isEqualToString:@"-"] ||
                 [tokens[i] isEqualToString:@"*"] || [tokens[i] isEqualToString:@"/"] || [tokens[i] isEqualToString:@"^"])
        {
            // While top of 'dataChStack' has same or greater precedence to current
            // token, which is an operator. Apply operator on top of 'dataChStack'
            // to top two elements in values stack
            while (self.dataChStack.count != 0 && [self hasPrecedence:tokens[i] op2:[self.dataChStack peek]])
            {
                [self.dataIntStack push:[self applyOp:[self.dataChStack pop] secondValue:[self.dataIntStack pop] firstValue:[self.dataIntStack pop]]];
            }
            
            // Push current token to 'dataChStack'.
            [self.dataChStack push:tokens[i]];
        }
        
    }
    
    // Entire expression has been parsed at this point, apply remaining
    // dataChStack to remaining values
    while (self.dataChStack.count > 0)
    {
        [self.dataIntStack push:[self applyOp:[self.dataChStack pop] secondValue:[self.dataIntStack pop] firstValue:[self.dataIntStack pop]]];
    }
    
    // Top of 'dataIntStack' contains result, return it
    result = [[self.dataIntStack pop] doubleValue];
   
    NSLog(@"result = %f",result);

    return result;
}

-(NSInteger) getOpPriority:(NSString *)op
{
    if ([op isEqualToString:@"^"])
    {
        return 3;
    }
    else if ([op isEqualToString:@"*"] || [op isEqualToString:@"/"] || [op isEqualToString:@"%"])
    {
        return 2;
    }
    else if ([op isEqualToString:@"+"] || [op isEqualToString:@"-"])
    {
        return 1;
    }
    
    return 0;
}

- (BOOL) hasPrecedence:(NSString *)op1 op2:(NSString *)op2
{
//    if (([op1 isEqualToString:@"*"] || [op1 isEqualToString:@"/"]) && ([op2 isEqualToString:@"+"] || [op2 isEqualToString:@"-"]))
//        return false;
//    else
//        return true;
    if ([self getOpPriority:op1] > [self getOpPriority:op2])
    {
        return false;
    }
        
    return true;
}

// A utility method to apply an operator 'op' on operands 'a'
// and 'b'. Return the result.
- (id) applyOp:(NSString *)op secondValue:(id)secondValue firstValue:(id)firstValue
{
    double firstVal = [firstValue doubleValue];
    double secondVal = [secondValue doubleValue];
    double res;
    if ([op isEqualToString:@"+"])
    {
        res = firstVal + secondVal;
        return [NSNumber numberWithFloat:res];
    }
    else if ([op isEqualToString:@"-"])
    {
        res = firstVal - secondVal;
        return [NSNumber numberWithFloat:res];
    }
    else if ([op isEqualToString:@"*"])
    {
        res = firstVal * secondVal;
        return [NSNumber numberWithFloat:res];
    }
    else if ([op isEqualToString:@"/"])
    {
        if (secondVal == 0)
        {
            NSLog(@"Cannot divide by zero");
        }
        else
        {
            res = firstVal / secondVal;
            return [NSNumber numberWithFloat:res];
        }
    }
    else if ([op isEqualToString:@"^"])
    {
        res = pow(firstVal, secondVal);
        return [NSNumber numberWithFloat:res];
    }
    else if ([op isEqualToString:@"%"])
    {
        res = fmodf(firstVal, secondVal);
        return [NSNumber numberWithFloat:res];
    }
    
    return 0;
}


@end
