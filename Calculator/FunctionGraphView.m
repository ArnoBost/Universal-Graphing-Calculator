//
//  FunctionGraphView.m
//  Calculator
//
//  Created by Arno Bost on 15.07.12.
//  Copyright (c) 2012 Cosy Apps. All rights reserved.
//

#import "FunctionGraphView.h"
#import "AxesDrawer.h"
#import "PointObject.h"

@interface FunctionGraphView ()

@property (nonatomic, strong) NSMutableArray *cacheArray; //cache array sorted by x-Value

@end

@implementation FunctionGraphView

@synthesize scale=_scale;
@synthesize origin=_origin;
@synthesize dataSource=_dataSource;
@synthesize cacheArray=_cacheArray;
@synthesize usePixelDrawing=_usePixelDrawing;

#define DEFAULT_SCALE 50.0


- (void)setNeedsDisplayGraph
{
    self.cacheArray = nil;
}


- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay];
       
        //save Scale in NSUserDefaults for current Program
        [[NSUserDefaults standardUserDefaults]
         registerDefaults:
         [[NSDictionary alloc]initWithObjectsAndKeys:
          [NSNumber numberWithFloat:scale],
          [[self.dataSource programDescription] stringByAppendingString:@"_scale"], nil]];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

- (void)setOrigin:(CGPoint)aPoint
{
    if (!((_origin.x == aPoint.x) && (_origin.y == aPoint.y))) {
        _origin = aPoint;
        [self setNeedsDisplay];

        
        //save Origin in NSUserDefaults for current Program
        [[NSUserDefaults standardUserDefaults]
         registerDefaults:
         [[NSDictionary alloc]initWithObjectsAndKeys:
          [NSNumber numberWithFloat:aPoint.x],
          [[self.dataSource programDescription] stringByAppendingString:@"_origin.x"], nil]];
        
        [[NSUserDefaults standardUserDefaults]
         registerDefaults:
         [[NSDictionary alloc]initWithObjectsAndKeys:
          [NSNumber numberWithFloat:aPoint.y],
          [[self.dataSource programDescription] stringByAppendingString:@"_origin.y"], nil]];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}


- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
    
    self.scale = [[NSUserDefaults standardUserDefaults]floatForKey:[[self.dataSource programDescription] stringByAppendingString:@"_scale"]];
    if (self.scale == 0) self.scale = DEFAULT_SCALE;
    self.backgroundColor = [UIColor clearColor];
    self.usePixelDrawing=NO;
    [self setNeedsDisplayGraph];
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        
        if (gesture.state == UIGestureRecognizerStateEnded) {
            [self setNeedsDisplayGraph];
            [self setNeedsDisplay];
        }

        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        
        if (gesture.state == UIGestureRecognizerStateEnded) {
            [self setNeedsDisplayGraph];
            [self setNeedsDisplay];
        }
        
        CGPoint translation = [gesture translationInView:self];
        CGPoint newOrigin;
        newOrigin.x = self.origin.x + translation.x;
        newOrigin.y = self.origin.y + translation.y;
        self.origin = newOrigin;
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)tripleTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self setNeedsDisplayGraph];
        [self setNeedsDisplay];
        self.origin = [gesture locationInView:self];
    }
}



- (CGFloat)valueForCoordX:(CGFloat)x
//x must be a pixel within bounds
{
    CGFloat result = 0.0;
    
    //ensure that x is within bounds
    if (x < 0) {
        x = 0.0;
    } else if (x > self.bounds.size.width * self.contentScaleFactor-1) {
        x = self.bounds.size.width * self.contentScaleFactor-1;
    }
    
    //calculate value depending on origin, ignore scale factor at this step
    result = x - (self.origin.x * self.contentScaleFactor);
    
    //math the scale
    result = result/self.scale;
    
    return result;
}

- (CGFloat)valueForCoordY:(CGFloat)y
//y must be a pixel within bounds
{
    CGFloat result = 0.0;
    
    //ensure that x is within bounds
    if (y < 0) {
        y = 0.0;
    } else if (y > self.bounds.size.height*self.contentScaleFactor-1) {
        y = self.bounds.size.height*self.contentScaleFactor-1;
    }
    
    //calculate value depending on origin, ignore scale factor at this step
    result = (self.origin.y * self.contentScaleFactor) - y;
    
    //math the scale
    result = result/self.scale;
    
    return result;
}

- (CGFloat)coordYForValue:(CGFloat)yValue
{
    CGFloat result = 0.0;
    
    //math the scale
    result = yValue * self.scale;
    
    //calculate the pixel
    result = (self.origin.y * self.contentScaleFactor) - result;
    
    return result;
}

- (CGFloat)coordXForValue:(CGFloat)xValue
{
    CGFloat result = 0.0;
    
    //math the scale
    result = xValue * self.scale;
    
    //calculate the pixel
    result = (self.origin.x * self.contentScaleFactor) + result;
    
    return result;
}


- (void)drawGraphByDots:(BOOL)dotDrawing;
// dotDrawing=YES => Pixels are drawn instead of lines
// dotDrawing=NO  => Lines are drawn instead of pixels
// self.cacheArray==nil => all x-y-pairs of graph are recalculated by dataSource delegate
// self.cacheArray!=nil => only x-y-pairs from a cache get drawn in fast mode (to speed up panning etc.)
{
    int pixelCounter;
    int cacheIndex;
    CGPoint myValuePoint;
    BOOL didRecalculate=NO;
    BOOL inPath=NO;

    int nrOfxPixelsInsideBounds = self.bounds.size.width * self.contentScaleFactor;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);


    if (!self.cacheArray) {
        self.cacheArray=[NSMutableArray arrayWithCapacity:nrOfxPixelsInsideBounds];
        
        for (pixelCounter=0; pixelCounter<nrOfxPixelsInsideBounds; pixelCounter++) {
            myValuePoint.x = [self valueForCoordX:pixelCounter];
            if ([self.dataSource hasFunctionValue:myValuePoint.x]) {
                myValuePoint.y = [self.dataSource functionValue:myValuePoint.x];
                [self.cacheArray addObject:[PointObject initWithCGPoint:myValuePoint]];
            }
        }
        didRecalculate=YES;
    }
    
    
    if (didRecalculate) {
        [[UIColor blueColor] setFill];
        [[UIColor blueColor] setStroke];
    } else {
        [[UIColor grayColor] setFill];
        [[UIColor grayColor] setStroke];
    }   
    
    
    if (self.cacheArray) {
        for (cacheIndex=0; cacheIndex<[self.cacheArray count]; cacheIndex++) {
            PointObject *myPoint = [self.cacheArray objectAtIndex:cacheIndex];
            myValuePoint.x = [myPoint.x doubleValue];
            myValuePoint.y = [myPoint.y doubleValue];
            CGFloat xPixel = [self coordXForValue:myValuePoint.x];
            CGFloat yPixel = [self coordYForValue:myValuePoint.y];
            
            if (dotDrawing) {
                if ((yPixel >= 0) && (yPixel < self.bounds.size.height * self.contentScaleFactor)) {
                    CGRect rect = CGRectMake(xPixel/self.contentScaleFactor, yPixel/self.contentScaleFactor, 1/self.contentScaleFactor, 1/self.contentScaleFactor);
                    CGContextFillRect(context, rect);
                }
            } else {
                if ((yPixel >= 0) && (yPixel < self.bounds.size.height * self.contentScaleFactor)) {
                    if (inPath) {
                        CGContextAddLineToPoint(context, xPixel/self.contentScaleFactor, yPixel/self.contentScaleFactor);
                    } else {
                        CGContextStrokePath(context);
                        CGContextBeginPath(context);
                        CGContextMoveToPoint(context, xPixel/self.contentScaleFactor, yPixel/self.contentScaleFactor);
                        inPath=YES;
                    }
                } else {
                    CGContextStrokePath(context);
                    inPath=NO;
                }
                if (cacheIndex==[self.cacheArray count]-1) {
                    CGContextStrokePath(context);
                }
            }
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    CGPoint myOrigin;
    myOrigin.x = [[NSUserDefaults standardUserDefaults]floatForKey:[[self.dataSource programDescription] stringByAppendingString:@"_origin.x"]];
    myOrigin.y = [[NSUserDefaults standardUserDefaults]floatForKey:[[self.dataSource programDescription] stringByAppendingString:@"_origin.y"]];
    if ((myOrigin.x == 0) || (myOrigin.y == 0)) {
        CGPoint midPoint;
        midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
        midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
        myOrigin = midPoint;
    }
    self.origin = myOrigin;
    
    
    //if (self.scale == 0) self.scale = DEFAULT_SCALE;

    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
    
    [self drawGraphByDots:self.usePixelDrawing];
}


@end
