//
//  LaunchPadKeyBoardView.m
//  iLaunchPad
//
//  Created by Max on 11/29/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import "LaunchPadKeyPadView.h"
#import "Constants.h"

@implementation LaunchPadKeyPadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void) registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateKeyViews) name:KeyWasAssigned object:nil];
}

- (void) updateKeyViews {
    NSArray *initializedTags = [self.launchpadCore getTagsOfInitializedPlayers];
    NSLog(@"updatekeyviews initializedtags %@", [initializedTags description]);
    
    for (int i=0; i<12; i++) {
        [(LaunchPadKeyView *)[self viewWithTag:100 + i] setKeySoundPlayerInitialized:NO];
    }
    
    for (int i=0; i<[initializedTags count]; i++) {
        NSInteger tTag = [[initializedTags objectAtIndex:i] integerValue];
        [(LaunchPadKeyView *)[self viewWithTag:tTag] setKeySoundPlayerInitialized:YES];
    }
}

- (void) enterEditMode:(BOOL) mode animated:(BOOL) animated {
    self.editting = mode;
    self.multipleTouchEnabled = mode;
    
    NSArray *initializedTags = [self.launchpadCore getTagsOfInitializedPlayers];
    NSLog(@"updatekeyviews initializedtags %@", [initializedTags description]);
    
    for (int i=0; i<12; i++) {
        [(LaunchPadKeyView *)[self viewWithTag:100+i] setKeySoundPlayerInitialized:NO];
    }
    
    for (int i=0; i<[initializedTags count]; i++) {
        NSInteger tTag = [[initializedTags objectAtIndex:i] integerValue];
        [(LaunchPadKeyView *)[self viewWithTag:tTag] setKeySoundPlayerInitialized:YES];
    }

    if (!mode) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:.3];
        for (int i=0; i<12; i++) {
            LaunchPadKeyView *keyView = (LaunchPadKeyView *)[self viewWithTag:100 + i];
            keyView.micImageView.alpha = 0;
            keyView.downButton.userInteractionEnabled = NO;
            keyView.downButton.alpha = 0;
            [keyView setEditingMode:mode];
            if (!keyView.registeredNotifications) {
                [keyView registeredNotifications];
//                [keyView registerGestureRecognizer];
            }
        }
        [UIView commitAnimations];
    }
    else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:.3];
        for (int i=0; i<12; i++) {
            LaunchPadKeyView *keyView = (LaunchPadKeyView *)[self viewWithTag:100 + i];
            keyView.micImageView.alpha = .2;
            keyView.downButton.userInteractionEnabled = YES;
            keyView.downButton.alpha = 1;
            [keyView setEditingMode:mode];
            if (!keyView.registeredNotifications) {
                [keyView registeredNotifications];
//                [keyView registerGestureRecognizer];
            }
        }
        [UIView commitAnimations];
    }
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
