//
//  SoundsManager.m
//  iLaunchPad
//
//  Created by sergey on 11/28/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import "SoundsManager.h"

#import "Constants.h"

@implementation SoundsManager

{
    NSString *soundsDirectoryPath;
}

- (instancetype) initWithDataAtPath: (NSString *) path andFile: (NSString *) file {
    self = [super init];
    
    if (self != nil) {
        // Save Sounds Directory path in an instance variable
        soundsDirectoryPath = path;

        // Initialize SoundRecorder
        NSString *tempSoundFilePath = [path stringByAppendingPathComponent:@"temp.caf"];
        NSURL *tempSoundFileURL = [NSURL fileURLWithPath:tempSoundFilePath];
        
        NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithFloat: 44100.0],            AVEncoderBitRateKey,
                                        [NSNumber numberWithInt: 1],                    AVNumberOfChannelsKey,
                                        [NSNumber numberWithInt: 16],                   AVLinearPCMBitDepthKey,
                                        [NSNumber numberWithBool: NO],                  AVLinearPCMIsBigEndianKey,
                                        [NSNumber numberWithBool: NO],                  AVLinearPCMIsFloatKey,
                                        [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                        nil];

        NSError *error;
        self.recorder = [[AVAudioRecorder alloc] initWithURL:tempSoundFileURL settings:recordSettings error:&error];
        if (error != nil) {
            NSLog(@"%@", [error description]);
        }
        else {
            self.recorder.delegate = self;
            self.recorder.meteringEnabled = YES;
            [self.recorder prepareToRecord];
        }
        
        // Initialize Player
        
        // Read data from file
        self.data = [[NSMutableArray alloc] init];
        NSString *soundsPath = [soundsDirectoryPath stringByAppendingPathComponent:@"Sounds.txt"];
        [self readDataFromFileAtPath:soundsPath];

        return self;
    }
    
    return nil;
}

- (void) readDataFromFileAtPath: (NSString *) path {
    NSString *fileData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *linesInFile = [fileData componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *firstLine = [linesInFile objectAtIndex:0];
    
    NSInteger numberOfSounds = [firstLine integerValue];
    
    for (int i=0; i<numberOfSounds; i++) {
        if ([[linesInFile objectAtIndex:i+1] length]>0) {
            [self.data addObject:[linesInFile objectAtIndex:i+1]];
        }
    }
}

- (void) createNewSoundWithName: (NSString *) soundName {
    NSString *recordedSoundPath = [soundsDirectoryPath stringByAppendingPathComponent:@"temp.caf"];
    NSString *destinationSoundPath = [soundsDirectoryPath stringByAppendingPathComponent:soundName];

    NSLog(@"createNewSoundWithName");
    if ([[NSFileManager defaultManager] isReadableFileAtPath:recordedSoundPath]) {
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:recordedSoundPath toPath:destinationSoundPath error:&error];
        if (error == nil) {
            self.lastSoundSavedPath = destinationSoundPath;
            [self.data addObject:soundName];
            [self saveSoundsData];
            NSLog(@"fileSavedOK");
        }
    }
}

- (void) startRecording {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    NSLog(@"StartRecording");
    if (!self.recorder.recording) {
        [self.recorder record];
    }
}

- (void) stopRecording {
    [self.recorder stop];

    NSDate *date = [NSDate date];
    NSString *soundName = [[[[date description] stringByReplacingOccurrencesOfString:@":" withString:@"-"] substringToIndex:19] stringByAppendingString:@".caf"];
    
    [self createNewSoundWithName: soundName];

    NSLog(@"StopRecording");
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
}

- (void) saveSoundsData {
    NSString *soundsFilePath = [soundsDirectoryPath stringByAppendingPathComponent:@"Sounds.txt"];
    
    NSString *stringToSave = [NSString stringWithFormat:@"%lu\n", (unsigned long)[self.data count]];
    
    for (int i=0; i<[self.data count]; i++) {
        stringToSave = [stringToSave stringByAppendingFormat:@"%@\n", [self.data objectAtIndex:i]];
    }
    
    const char *utf8StringToSave = [stringToSave UTF8String];
    
    NSData *dataToSave = [NSData dataWithBytes:utf8StringToSave length:strlen(utf8StringToSave)];
    
    [dataToSave writeToFile:soundsFilePath atomically:YES];
}

- (NSString *) getSoundsDirectoryPath {
    return soundsDirectoryPath;
}

- (void) playButtonClickListener: (id) sender {
    NSString *soundPath = [[self getSoundsDirectoryPath] stringByAppendingPathComponent:[self.data objectAtIndex:[sender tag]]];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    if (error == nil) {
        [self.player play];
    }
    else {
        NSLog(@"%@", [error description]);
    }
}

#pragma UITableViewDelegate/UITableViewDataSource

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.lastSoundPicked = [self.data objectAtIndex:[indexPath row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:SoundWasSelected object:self.lastSoundPicked];
}

- (void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView reloadData];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *fileToRemove = [soundsDirectoryPath stringByAppendingPathComponent:[self.data objectAtIndex:[indexPath row]]];
        [[NSFileManager defaultManager] removeItemAtPath:fileToRemove error:nil];

        [self.data removeObjectAtIndex:[indexPath row]];
        NSArray *rowIndexPaths = [NSArray arrayWithObjects:indexPath, nil];
        [tableView deleteRowsAtIndexPaths:rowIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
        [self saveSoundsData];
//        [tableView reloadData];
        NSLog(@"filetoremove %@", fileToRemove);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCellID"];
    cell.playButton.hidden = NO;
    cell.playButton.userInteractionEnabled = YES;
    cell.playButton.tag = [indexPath row];
    [cell.playButton addTarget:self action:@selector(playButtonClickListener:) forControlEvents:UIControlEventTouchUpInside];
    cell.customTextLabel.text = [self.data objectAtIndex:[indexPath row]];
    return cell;
}

+ (NSString *) getSoundsPathForProfile: (NSString *) profileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *soundsDirectory = [documentsDirectory stringByAppendingFormat:@"/Profiles/%@/Sounds", profileName];
    return soundsDirectory;
}

#pragma AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"FinishedRecording");
}

@end
