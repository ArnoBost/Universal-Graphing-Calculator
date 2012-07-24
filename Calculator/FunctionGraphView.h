//
//  FunctionGraphView.h
//  Calculator
//
//  Created by Arno Bost on 15.07.12.
//  Copyright (c) 2012 Cosy Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FunctionGraphView;

@protocol FunctionGraphViewDataSource
- (BOOL)hasFunctionValue:(CGFloat)x;
- (CGFloat)functionValue:(CGFloat)x;
- (NSString *)programDescription;
@end


@interface FunctionGraphView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
@property (nonatomic) BOOL usePixelDrawing; //default==NO => LineDrawingMode

@property (nonatomic, weak) IBOutlet id <FunctionGraphViewDataSource> dataSource;

- (void)setNeedsDisplayGraph; //inidcate that the view has to draw a new graph

@end
