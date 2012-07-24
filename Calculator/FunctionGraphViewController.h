//
//  FunctionGraphViewController.h
//  Calculator
//
//  Created by Arno Bost on 15.07.12.
//  Copyright (c) 2012 Cosy Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface FunctionGraphViewController : UIViewController <SplitViewBarButtonItemPresenter>

@property (nonatomic, strong) id graphProgram;

@end
