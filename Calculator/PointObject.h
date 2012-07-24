//
//  PointObject.h
//  Calculator
//
//  Created by Arno Bost on 24.07.12.
//  Copyright (c) 2012 Cosy Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointObject : NSObject

@property(nonatomic, strong)NSNumber *x;
@property(nonatomic, strong)NSNumber *y;

- (id)init;
+ (PointObject *)initWithCGPoint:(CGPoint)aPoint;

@end
