//
//  dataStack.m
//  calculator
//
//  Created by Devangi Desai on 03/10/16.
//  Copyright © 2016 Devangi Desai. All rights reserved.
//

#import "DataStack.h"

@implementation DataStack
@synthesize count;

- (id)init
{
    if( self=[super init] )
    {
        self.m_array = [[NSMutableArray alloc] init];
        count = 0;
    }
    return self;
}

- (void)push:(id)anObject
{
    [self.m_array addObject:anObject];
    count = self.m_array.count;
}

- (id)pop
{
    id obj = nil;
    if(self.m_array.count > 0)
    {
        obj = [self.m_array lastObject];
        [self.m_array removeLastObject];
        count = self.m_array.count;
    }
    return obj;
}
- (void)clear
{
    [self.m_array removeAllObjects];
    count = 0;
}

-(id)peek{
    return [[self.m_array lastObject] copy];
}
@end
