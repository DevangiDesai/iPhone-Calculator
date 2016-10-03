//
//  dataStack.h
//  calculator
//
//  Created by Devangi Desai on 03/10/16.
//  Copyright © 2016 Devangi Desai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStack : NSObject
{
    NSUInteger count;
}

@property (nonatomic, strong) NSMutableArray* m_array;
@property (nonatomic, readonly) NSUInteger count;

- (void)push:(id)anObject;
- (id)pop;
- (void)clear;
-(id)peek;

@end
