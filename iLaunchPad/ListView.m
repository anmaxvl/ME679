//
//  ListView.m
//  iLaunchPad
//
//  Created by Max on 11/28/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import "ListView.h"

@implementation ListView

- (void) layoutSubviewsForProfilesList {
    self.backButton.userInteractionEnabled = NO;
    self.backButton.hidden = YES;
    self.backButton.tag = 568;
    self.plusButton.hidden = NO;
    self.plusButton.userInteractionEnabled = YES;
}

- (void) layoutSubviewsForSessionsList {
    self.backButton.userInteractionEnabled = YES;
    self.backButton.hidden = NO;
    self.plusButton.userInteractionEnabled = NO;
    self.plusButton.hidden = YES;
}

- (void) layoutSubviewsForSoundsList {
    self.backButton.userInteractionEnabled = YES;
    self.backButton.hidden = NO;
    self.backButton.tag = 567;
    self.plusButton.userInteractionEnabled = NO;
    self.plusButton.hidden = YES;
}

@end
