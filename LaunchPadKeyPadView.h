//
//  LaunchPadKeyBoardView.h
//  iLaunchPad
//
//  Created by Max on 11/29/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LaunchPadKeyView.h"
#import "LaunchPadKeyPadCore.h"

@interface LaunchPadKeyPadView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, readwrite, getter = isEditting) BOOL editting;
@property (nonatomic, strong) LaunchPadKeyPadCore *launchpadCore;

- (void) enterEditMode:(BOOL) mode animated:(BOOL) animated;
- (void) registerNotifications;
- (void) updateKeyViews;

@end
