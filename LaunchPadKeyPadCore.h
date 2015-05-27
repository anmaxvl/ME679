//
//  LaunchPadKeyBoardCore.h
//  iLaunchPad
//
//  Created by Max on 11/29/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LaunchPadKeyCore.h"
#import "LaunchPadKeyView.h"
#import "SoundsManager.h"

@interface LaunchPadKeyPadCore : NSObject<NSCoding>

// Properties

@property (nonatomic, strong) SoundsManager *soundsManager;
@property (nonatomic, readwrite) int numberOfKeys;


// Methods
- (instancetype) initWithNumberOfKeys:(int) numberOfKeys;

- (void) assignKeyToViewWithTag: (NSInteger) tag;
- (void) setKeyForViewWithTag: (NSInteger) tag looping: (BOOL) looping;

//- (void) playKeyForViewWithTag: (NSInteger) tag;
//- (void) stopKeyForViewWithTag: (NSInteger) tag;

- (NSArray *) getTagsOfInitializedPlayers;

- (void) setCurrentProfile: (NSString *) profileName;
- (NSString *) getCurrentProfile;

- (void) archive;

+ (NSString *) getArchivePathForProfile: (NSString *) profileName;

@end
