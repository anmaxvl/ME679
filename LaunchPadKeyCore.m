//
//  LaunchPadKeyCore.m
//  iLaunchPad
//
//  Created by Max on 11/29/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import "LaunchPadKeyCore.h"

@implementation LaunchPadKeyCore

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithBool:self.looping] forKey:@"looping"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self != nil) {
        self.looping = [[aDecoder decodeObjectForKey:@"looping"] boolValue];
        return self;
    }
    
    return nil;
}


- (instancetype) initWithLoopingMode: (BOOL) loopingMode {
    self = [super init];
    
    if (self != nil) {
        self.looping = loopingMode;
        
        return self;
    }
    return nil;
}

- (instancetype) init {
    self = [super init];
    
    if (self != nil) {
        self.looping = NO;
        return self;
    }
    return nil;
}

- (NSError *) initializePlayerWithSoundAtPath: (NSString *) path {
    //converting string to an URL
    NSURL *fileURL = [NSURL fileURLWithPath:path];
//    NSLog(@"launchpadkeycore initializeplayerwithsoundatpat fileurl %@", [fileURL description]);
    NSError *error;
    self.keySoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    if (error == nil) {
//        [self.keySoundPlayer setNumberOfLoops:-1];
        [self.keySoundPlayer prepareToPlay];
        return nil;
    }
    
    NSLog(@"launchpadkeycore keysoundplayer %@", [self.keySoundPlayer description]);
    
    NSLog(@"%@", [error description]);
    
    return error;
}

// This method starts playing sound and returns the time when the playback began
- (NSTimeInterval) play {
    //NSTimeInterval currentTime = [[NSDate alloc] timeIntervalSince1970];
    if (self.keySoundPlayer != nil) {
        if ([self.keySoundPlayer isPlaying]) {
            [self.keySoundPlayer stop];
            [self.keySoundPlayer setCurrentTime:0];
        }
        [self.keySoundPlayer play];
    }
    //return currentTime;
    return 0;
}

// This method stops playing sound and returns the time when the playback stopped
- (NSTimeInterval) stop {
//    NSTimeInterval currentTime = [[NSDate alloc] timeIntervalSince1970];
    if (self.keySoundPlayer != nil) {
        [self.keySoundPlayer stop];
        self.keySoundPlayer.currentTime = 0.0;
    }
//    return currentTime;
    return 0;
}

- (BOOL) isPlayerInitialized {
    return (self.keySoundPlayer != nil);
}

@end
