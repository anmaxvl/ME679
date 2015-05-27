//
//  LaunchPadKeyCore.h
//  iLaunchPad
//
//  Created by Max on 11/29/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LaunchPadKeyCore : NSObject<NSCoding>

// Properties

@property (nonatomic, getter = isLoopingKey, readwrite) BOOL looping;
@property (nonatomic, strong) AVAudioPlayer *keySoundPlayer;

// Initializers
- (instancetype) initWithLoopingMode: (BOOL) loopingMode;
- (instancetype) init;

// Player Methods

// This method initializes the AVAudioPlayer with sound at a given path
- (NSError *) initializePlayerWithSoundAtPath: (NSString *) path;
// This method starts playing sound and returns the time when the playback began
- (NSTimeInterval) play;
// This method stops playing sound and returns the time when the playback stopped
- (NSTimeInterval) stop;

- (BOOL) isPlayerInitialized;

@end
