//
//  PointObject.m
//  Calculator
//
//  Created by Arno Bost on 24.07.12.
//  Copyright (c) 2012 Cosy Apps. All rights reserved.
//

#import "PointObject.h"

@implementation PointObject

@synthesize x=_x;
@synthesize y=_y;

- (id)init
{
    self = [super init];
    self.x = nil;
    self.y = nil;
    return self;
}


+ (PointObject *)initWithCGPoint:(CGPoint)aPoint
{
    PointObject *resultPointObject=[[PointObject alloc] init];

    resultPointObject.x = [NSNumber numberWithDouble:aPoint.x];
    resultPointObject.y = [NSNumber numberWithDouble:aPoint.y];
    
    return resultPointObject;
}


@end
