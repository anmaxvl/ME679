//
//  SoundsManager.h
//  iLaunchPad
//
//  Created by sergey on 11/28/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import "Manager.h"
#import "CustomTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface SoundsManager : Manager<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSString *lastSoundSavedPath;
@property (nonatomic, strong) NSString *lastSoundPicked;

- (void) createNewSoundWithName: (NSString *) soundName;

- (void) startRecording;
- (void) stopRecording;

- (void) saveSoundsData;

- (NSString *) getSoundsDirectoryPath;

+ (NSString *) getSoundsPathForProfile: (NSString *) profileName;

@end
