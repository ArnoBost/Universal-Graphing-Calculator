//
//  FunctionGraphViewController.m
//  Calculator
//
//  Created by Arno Bost on 15.07.12.
//  Copyright (c) 2012 Cosy Apps. All rights reserved.
//

#import "FunctionGraphViewController.h"
#import "FunctionGraphView.h"
#import "CalculatorBrain.h"

@interface FunctionGraphViewController () <FunctionGraphViewDataSource>
@property (weak, nonatomic) IBOutlet FunctionGraphView *graphView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *titleItem;
@property (weak, nonatomic) IBOutlet UISwitch *pixelModeSwitch;
@property (weak, nonatomic) IBOutlet UIButton *pixelModeButton;


@end

@implementation FunctionGraphViewController
@synthesize toolbar = _toolbar;

@synthesize graphProgram=_graphProgram;
@synthesize graphView=_graphView;

@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;   // implementation of SplitViewBarButtonItemPresenter protocol
@synthesize titleItem=_titleItem;
@synthesize pixelModeSwitch = _pixelModeSwitch;
@synthesize pixelModeButton = _pixelModeButton;

- (id)titleItem
{
    if (!_titleItem) {
        _titleItem = [[UIBarButtonItem alloc] initWithTitle:[self programDescription] style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return _titleItem;
}


// START CODE MODIFIED AFTER LECTURE

// Puts the splitViewBarButton in our toolbar (and/or removes the old one).
// Must be called when our splitViewBarButtonItem property changes
//  (and also after our view has been loaded from the storyboard (viewDidLoad)).

- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
    }
}

- (void)handleTitleItem
{
    
    if (self.splitViewController) {
        UIBarButtonItem *oldTitleItem = self.titleItem;
        self.titleItem=nil;
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        
        if ([toolbarItems containsObject:oldTitleItem]) {
            if (self.titleItem){
                int index = [toolbarItems indexOfObject:oldTitleItem];
                [toolbarItems replaceObjectAtIndex:index withObject:self.titleItem];
            }
        } else {
            [toolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
            if (self.titleItem) [toolbarItems addObject:self.titleItem];
            [toolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
        }
        
        self.toolbar.items = toolbarItems;
    }
}

// viewDidLoad is callled after this view controller has been fully instantiated
//  and its outlets have all been hooked up.

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self handleSplitViewBarButtonItem:self.splitViewBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self handleTitleItem];
}

// END CODE MODIFIED AFTER LECTURE

- (void)setGraphProgram:(id)graphProgram
{
    _graphProgram = graphProgram;
   
    if (self.splitViewController) {
        [self handleTitleItem];
    } else {
        self.navigationItem.title=self.programDescription;
    }

    [self.graphView setNeedsDisplayGraph];
    [self.graphView setNeedsDisplay];
}

- (void)setGraphView:(FunctionGraphView *)graphView
{
    _graphView = graphView;
    
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    
    UITapGestureRecognizer *myTripleTapGR=[[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTap:)];
    myTripleTapGR.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:myTripleTapGR];
    
    self.graphView.dataSource = self;
    self.graphView.usePixelDrawing = self.pixelModeSwitch.on;
}

- (BOOL)hasFunctionValue:(CGFloat)x
{
    if (!self.graphProgram) {
        return NO;
    } else if (![self.graphProgram lastObject]) {
        return NO;
    }
    
    id programResult = [CalculatorBrain runProgram:self.graphProgram usingVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:x], @"x", nil]];
    return ([programResult isKindOfClass:[NSNumber class]]);   
}

- (CGFloat)functionValue:(CGFloat)x
{
    CGFloat result=0;
    
    id programResult = [CalculatorBrain runProgram:self.graphProgram usingVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:x], @"x", nil]];
    if ([programResult isKindOfClass:[NSNumber class]]) {
        result = [(NSNumber *)programResult floatValue];
    }
    
    return result;
}

- (NSString *)programDescription
{
    if (!self.graphProgram) {
        return @"No program to display";
    } else if (![self.graphProgram lastObject]) {
        return @"No program to display";
    }
    
    NSString *helpString = [CalculatorBrain descriptionOfProgram:self.graphProgram];
    if ([helpString isEqualToString:@""]) {
        helpString = @"f(x) = 0";
    } else {
        helpString = [@"f(x) = " stringByAppendingString:helpString];
    }
    
    NSRange range=[helpString rangeOfString:@", "];
    if (range.location != NSNotFound) {
        helpString = [helpString substringToIndex:range.location];
    }
    
    return helpString;
}

- (IBAction)actionDrawModeSwitched:(UISwitch *)sender {
    self.graphView.usePixelDrawing = self.pixelModeSwitch.on;
    if (self.pixelModeSwitch.on) {
        [self.pixelModeButton setTitleColor:[UIColor blueColor] forState:UIControlStateDisabled];
    } else {
        [self.pixelModeButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    }
    [self.graphView setNeedsDisplayGraph];
    [self.graphView setNeedsDisplay];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.graphView setNeedsDisplayGraph];
    [self.graphView setNeedsDisplay];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


- (void)viewDidUnload {
    [self setGraphView:nil];
    [self setToolbar:nil];
    [self setPixelModeSwitch:nil];
    [self setPixelModeButton:nil];
    [super viewDidUnload];
}
@end
