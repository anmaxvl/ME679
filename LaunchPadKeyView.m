//
//  LaunchPadKeyView.m
//  iLaunchPad
//
//  Created by Max on 11/29/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import "LaunchPadKeyView.h"
#import "LaunchPadKeyPadView.h"

#import "Constants.h"

@implementation LaunchPadKeyView

{
    BOOL addedToObservers;
    BOOL playerInitialized;
    BOOL editModeActive;
    BOOL loopingKey;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"LaunchPadKeyView initWithFrame");
    }
    return self;
}

- (void) registerNotifications {
    self.registeredNotifications = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredEditModeNotificationListener) name:LaunchPadEditModeEntered object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitedEditModeNotificationListener) name:LaunchPadEditModeExited object:nil];
}

- (void) enteredEditModeNotificationListener {
    editModeActive = YES;
    self.multipleTouchEnabled = NO;
    self.exclusiveTouch = YES;
    self.userInteractionEnabled = YES;
}

- (void) exitedEditModeNotificationListener {
    editModeActive = NO;
    self.multipleTouchEnabled = YES;
    self.exclusiveTouch = NO;
    self.userInteractionEnabled = NO;
}

- (void) setEditingMode: (BOOL) editing {
    editModeActive = editing;
}

- (IBAction) downButtonOnClickListener:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowSoundList object:self];
}

- (void) setKeySoundPlayerInitialized: (BOOL) initialized {
    if (initialized) {
        self.backgroundColor = [UIColor greenColor];
    }
    else {
        self.backgroundColor = [UIColor redColor];
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.origin = self.frame.origin;
    
    self.frame = CGRectMake(self.frame.origin.x + 2, self.frame.origin.y + 2, self.frame.size.width - 4, self.frame.size.height - 4);

    // Post a notification that the view touch began
    [[NSNotificationCenter defaultCenter] postNotificationName:KeyViewTouchBegan object:self];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.frame = CGRectMake(self.origin.x, self.origin.y, 106, 115);

    [[NSNotificationCenter defaultCenter] postNotificationName:KeyViewTouchEnded object:self];
    NSLog(@"touchesCancelled");
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.frame = CGRectMake(self.origin.x, self.origin.y, 106, 115);
    
    // Post a notification that the view touch ended
    [[NSNotificationCenter defaultCenter] postNotificationName:KeyViewTouchEnded object:self];
}

- (void) registerGestureRecognizer {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerDetected:)];
    longPressGestureRecognizer.delegate = self;
    [self addGestureRecognizer:longPressGestureRecognizer];
}

- (void) longPressGestureRecognizerDetected: (UILongPressGestureRecognizer *) gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KeyViewLongPress object:self];
        loopingKey = YES;
        self.backgroundColor = [UIColor purpleColor];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return (editModeActive == NO);
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
