//
//  CalcModel.h
//  calculator
//
//  Created by Devangi Desai on 03/10/16.
//  Copyright © 2016 Devangi Desai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStack.h"

@interface CalcModel : NSObject

// Contains the last operator
@property double stackDouble;

// Contains the last operation (+,-,*,/)
@property (nonatomic, strong) NSString* stackOperator;

// Contains all stack numbers
@property (nonatomic, strong) NSMutableArray* stackNumbersArray;

// Contains all stack operators
@property (nonatomic, strong) NSMutableArray* stackOperatorsArray;

@property (nonatomic, strong) NSString *longDataValue;

@property (nonatomic, strong) DataStack* dataIntStack;
@property (nonatomic, strong) DataStack* dataChStack;


- (double) performOperationWithNumber: (double) number_double;


@end
