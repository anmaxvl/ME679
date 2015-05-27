//
//  LaunchPadKeyView.h
//  iLaunchPad
//
//  Created by Max on 11/29/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchPadKeyView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIView *superViewDelegate;

@property (nonatomic, readwrite) CGPoint origin;

@property (nonatomic, strong) IBOutlet UIImageView *micImageView;
@property (nonatomic, strong) IBOutlet UIButton *downButton;

@property (nonatomic, readwrite) BOOL registeredNotifications;

- (IBAction) downButtonOnClickListener:(id)sender;

- (void) registerNotifications;

- (void) setKeySoundPlayerInitialized: (BOOL) initialized;

- (void) registerGestureRecognizer;

- (void) setEditingMode: (BOOL) editing;
@end
