//
//  LaunchPadKeyBoardCore.m
//  iLaunchPad
//
//  Created by Max on 11/29/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import "LaunchPadKeyPadCore.h"

#import "Constants.h"

@implementation LaunchPadKeyPadCore

{
    NSMutableDictionary *viewKeyRelations;
    NSMutableArray *launchpadKeys;
    NSMutableArray *assignedViewTags;
//    NSMutableArray *loopingKeys;
    int nOfAssignedPlayers;
    NSMutableDictionary *playerSoundRelations;
    NSString *currentProfile;
    
    BOOL editting;
    LaunchPadKeyView *soundToAssign;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInt:self.numberOfKeys] forKey:@"numberOfKeys"];
    [aCoder encodeObject:viewKeyRelations forKey:@"viewKeyRelations"];
    [aCoder encodeObject:launchpadKeys forKey:@"launchpadKeys"];
    [aCoder encodeObject:assignedViewTags forKey:@"assignedViewTags"];
    [aCoder encodeObject:[NSNumber numberWithInt:nOfAssignedPlayers] forKey:@"nOfAssignedPlayers"];
    [aCoder encodeObject:playerSoundRelations forKey:@"playerSoundRelations"];
    [aCoder encodeObject:currentProfile forKey:@"currentProfile"];
//    [aCoder encodeObject:loopingKeys forKey:@"loopingKeys"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"initWithCoder");
    self = [super init];
    if (self != nil) {
        self.numberOfKeys = [[aDecoder decodeObjectForKey:@"numberOfKeys"] integerValue];
        viewKeyRelations = [aDecoder decodeObjectForKey:@"viewKeyRelations"];
        launchpadKeys = [aDecoder decodeObjectForKey:@"launchpadKeys"];
        assignedViewTags = [aDecoder decodeObjectForKey:@"assignedViewTags"];
        nOfAssignedPlayers = [[aDecoder decodeObjectForKey:@"nOfAssignedPlayers"] integerValue];
        playerSoundRelations = [aDecoder decodeObjectForKey:@"playerSoundRelations"];
        currentProfile = [aDecoder decodeObjectForKey:@"currentProfile"];
//        loopingKeys = [aDecoder decodeObjectForKey:@"loopingKeys"];
        
        for (int i=0; i<self.numberOfKeys; i++) {
            NSString *keySoundPlayerKey = [NSString stringWithFormat:@"%d", i];
            if ([playerSoundRelations objectForKey:keySoundPlayerKey] != nil) {
                NSString *soundPath = [playerSoundRelations objectForKey:keySoundPlayerKey];
                NSError *error = [(LaunchPadKeyCore *)[launchpadKeys objectAtIndex:i] initializePlayerWithSoundAtPath:soundPath];
                if (error != nil) {
                    NSLog(@"%@", [error description]);
                }
            }
        }
        
//        for (int i=0; i<[loopingKeys count]; i++) {
//            int keySoundPlayerIndex = [[loopingKeys objectAtIndex:i] integerValue];
//            [[launchpadKeys objectAtIndex:keySoundPlayerIndex] setLooping:YES];
//        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchBeganNotificationListener:) name:KeyViewTouchBegan object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchEndedNotificationListener:) name:KeyViewTouchEnded object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(longTouchNotificationListener:) name:KeyViewLongPress object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setEdittingYes) name:LaunchPadEditModeEntered object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setEdittingNo) name:LaunchPadEditModeExited object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSoundListNotificationListener:) name:ShowSoundList object:nil];
        
        return self;
    }
    return nil;
}


- (instancetype) initWithNumberOfKeys:(int)numberOfKeys {
    self = [super init];
    
    if (self != nil) {
        assignedViewTags = [[NSMutableArray alloc] init];
        playerSoundRelations = [[NSMutableDictionary alloc] init];
        
        nOfAssignedPlayers = 0;
        self.numberOfKeys = numberOfKeys;
        editting = NO;
        
        // Initialize array of KeySoundPlayers
        launchpadKeys = [NSMutableArray arrayWithCapacity:self.numberOfKeys];
        for (int i = 0; i<self.numberOfKeys; i++) {
            LaunchPadKeyCore *key = [[LaunchPadKeyCore alloc] init];
            [launchpadKeys addObject:key];
        }
        
        // Initialize a dictionary which keeps the "view with a given tag" to KeySoundPlayer relation
        viewKeyRelations = [NSMutableDictionary dictionaryWithCapacity:self.numberOfKeys];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchBeganNotificationListener:) name:KeyViewTouchBegan object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchEndedNotificationListener:) name:KeyViewTouchEnded object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(longTouchNotificationListener:) name:KeyViewLongPress object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setEdittingYes) name:LaunchPadEditModeEntered object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setEdittingNo) name:LaunchPadEditModeExited object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSoundListNotificationListener:) name:ShowSoundList object:nil];
        
        return self;
    }
    
    return nil;
}

- (void) setCurrentProfile: (NSString *) profileName {
    currentProfile = [profileName copy];
}

- (NSString *) getCurrentProfile {
    return [currentProfile copy];
}

- (NSArray *) getTagsOfInitializedPlayers {
    return assignedViewTags;
}

- (void) setEdittingYes {
    editting = YES;
}

- (void) setEdittingNo {
    editting = NO;
}

- (void) showSoundListNotificationListener: (NSNotification *) notification {
    if ([[notification object] isKindOfClass:[LaunchPadKeyView class]]) {
        soundToAssign = [notification object];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soundWasSelectedNotificationListener:) name:SoundWasSelected object:nil];
        NSLog(@"LaunchPadKeyPadCore showSoundListNotificationListener");
    }
}

- (void) soundWasSelectedNotificationListener: (NSNotification *) notification {
    if ([[notification object] isKindOfClass:[NSString class]]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:SoundWasSelected object:nil];
        
        // Get the corresponding Key
        if (![self isKeyAssignedToViewWithTag:[soundToAssign tag]]) {
            [self assignKeyToViewWithTag:[soundToAssign tag]];
        }
        
        int keySoundPlayerIndex = [[viewKeyRelations objectForKey:[NSString stringWithFormat:@"%d", (int)[soundToAssign tag]]] integerValue];
        LaunchPadKeyCore *key = [launchpadKeys objectAtIndex: keySoundPlayerIndex];
        NSString *soundPath = [[self.soundsManager getSoundsDirectoryPath] stringByAppendingPathComponent:[notification object]];

        NSError *error = [key initializePlayerWithSoundAtPath:soundPath];
        
        [playerSoundRelations setObject:soundPath forKey:[NSString stringWithFormat:@"%d", keySoundPlayerIndex]];
//        NSLog(@"Launchpadkeypadcore playersoundrelations %@", [playerSoundRelations description]);

        if (![assignedViewTags containsObject:[NSNumber numberWithInt:[soundToAssign tag]]]) {
            [assignedViewTags addObject:[NSNumber numberWithInt:[soundToAssign tag]]];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:KeyWasAssigned object:nil];
        
        NSLog(@"LaunchPadKeyPadCore soundWasSelectedNotificationListener");
        if (error != nil) {
            NSLog(@"%@", [error description]);
        }
    }
}

//- (void) longTouchNotificationListener: (id) notification {
//    if ([[notification object] isKindOfClass:[LaunchPadKeyView class]]) {
//        int keySoundPlayerIndex = [[viewKeyRelations objectForKey:[NSString stringWithFormat:@"%d", (int)[soundToAssign tag]]] integerValue];
//        LaunchPadKeyCore *key = [launchpadKeys objectAtIndex:keySoundPlayerIndex];
//        if (![loopingKeys containsObject:[NSNumber numberWithInt:keySoundPlayerIndex]]) {
//            [launchpadKeys addObject:[NSNumber numberWithInt:keySoundPlayerIndex]];
//            [key setLooping:YES];
//        }
//    }
//}

- (void) touchBeganNotificationListener: (id) notification {
    if ([[notification object] isKindOfClass:[LaunchPadKeyView class]]) {
        if (![self isKeyAssignedToViewWithTag:[[notification object] tag]]) {
            [self assignKeyToViewWithTag:[[notification object]tag]];
        }
        
        LaunchPadKeyCore *key = [launchpadKeys objectAtIndex:[[viewKeyRelations objectForKey:[NSString stringWithFormat:@"%d", (int)[[notification object]tag]]] integerValue]];
        
        if (editting) {
            [self.soundsManager startRecording];
        }
        else {
            [key play];
        }
    }
}

- (void) touchEndedNotificationListener: (id) notification {
    if ([[notification object] isKindOfClass:[LaunchPadKeyView class]]) {
        int keySoundPlayerIndex = [[viewKeyRelations objectForKey:[NSString stringWithFormat:@"%d", (int)[[notification object]tag]]] integerValue];
        LaunchPadKeyCore *key = [launchpadKeys objectAtIndex: keySoundPlayerIndex];

        if (editting) {
            [self.soundsManager stopRecording];
            NSString *recordedSoundPath = self.soundsManager.lastSoundSavedPath;
            if ([key initializePlayerWithSoundAtPath:recordedSoundPath] == nil) {
                [playerSoundRelations setObject:recordedSoundPath forKey:[NSString stringWithFormat:@"%d", keySoundPlayerIndex]];
//                NSLog(@"launchpadkeycore playersoundrelations%@", [playerSoundRelations description]);

                if (![assignedViewTags containsObject:[NSNumber numberWithInt:[[notification object] tag]]]) {
                    [assignedViewTags addObject:[NSNumber numberWithInt:[[notification object] tag]]];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:KeyWasAssigned object:nil];
                NSLog(@"Player Initialized");
            };
        }
//        else {
//            [key stop];
//        }
    }
}

- (BOOL) isKeyAssignedToViewWithTag: (NSInteger) tag {
    if ([viewKeyRelations objectForKey:[NSString stringWithFormat:@"%d", (int)tag]] == nil) {
        return NO;
    }
    return  YES;
}

// This method assigns a KeySoundPlayer with a given tag as a string key and the index of a KeySoundPlayer as an Integer object
- (void) assignKeyToViewWithTag: (NSInteger) tag {
    NSString *stringTagKey = [NSString stringWithFormat:@"%d", (int)tag];
    // Check if a KeySoundPlayer was already assigned to a view with a given tag
    if ([viewKeyRelations objectForKey:stringTagKey] == nil) {
        // If there is no player assigned, then do so
        [viewKeyRelations setObject:[NSNumber numberWithInt:nOfAssignedPlayers] forKey:stringTagKey];
        nOfAssignedPlayers++;
    }
}

- (void) setKeyForViewWithTag: (NSInteger) tag looping: (BOOL) looping {
    NSInteger index = [[viewKeyRelations objectForKey:[NSString stringWithFormat:@"%d",(int) tag]] integerValue];
    LaunchPadKeyCore *launchPadKey = [launchpadKeys objectAtIndex:index];
    [launchPadKey setLooping:looping];
}

- (void) archive {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *sessionsPath = [documentsDirectory stringByAppendingPathComponent:@"Sessions"];
    NSString *archivePath = [sessionsPath stringByAppendingPathComponent:currentProfile];
    
    [[NSFileManager defaultManager] createFileAtPath:archivePath contents:nil attributes:nil];
    [NSKeyedArchiver archiveRootObject:self toFile:archivePath];
    
    NSLog(@"archive for profile: %@", currentProfile);
}

+ (NSString *) getArchivePathForProfile: (NSString *) profileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *sessionsPath = [documentsDirectory stringByAppendingPathComponent:@"Sessions"];
    NSString *archivePath = [sessionsPath stringByAppendingPathComponent:profileName];
    return [archivePath copy];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
