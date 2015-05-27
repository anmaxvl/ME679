//
//  ProfilesManager.m
//  iLaunchPad
//
//  Created by sergey on 11/28/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import "ProfilesManager.h"
#import "ViewController.h"
#import "Constants.h"

@implementation ProfilesManager

- (instancetype) initWithDataAtPath: (NSString *) path andFile: (NSString *) file {
    self = [super init];
    
    
    if (self != nil) {
        NSString *postfix = [NSString stringWithFormat:@"/%@", file];
        NSString *fullFilePath = [path stringByAppendingString:postfix];
        self.data = [[NSMutableArray alloc] init];
        [self readDataFromFileAtPath:fullFilePath];
        return self;
    }
    
    return nil;
}

- (void) readDataFromFileAtPath: (NSString *) path {
    NSString *fileData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *linesInFile = [fileData componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *firstLine = [linesInFile objectAtIndex:0];
    
    int numberOfProfiles = [firstLine integerValue];
    
    for (int i=0; i<numberOfProfiles; i++) {
        if ([[linesInFile objectAtIndex:i+1] length]>0) {
            [self.data addObject:[linesInFile objectAtIndex:i+1]];
        }
    }
}

- (BOOL) checkNewProfileName: (NSString *) name {
    for (int i=0; i<[self.data count]; i++) {
        if ([[[self.data objectAtIndex:i] lowercaseString] isEqualToString:[name lowercaseString]]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL) createNewProfileWithName: (NSString *) name {
    // Generate full path for Profiles directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *profilesDirectory = [documentsDirectory stringByAppendingPathComponent:@"Profiles"];
    NSString *newProfileDirectory = [profilesDirectory stringByAppendingPathComponent:name];
    
    // Check if the directory already exists, if not create one
    if (![[NSFileManager defaultManager] fileExistsAtPath:newProfileDirectory]) {
        NSError *error;
        // Create the directory at a given path
        [[NSFileManager defaultManager] createDirectoryAtPath:newProfileDirectory withIntermediateDirectories:NO attributes:nil error:&error];
        if (error == nil) {
            // If no error occured while creating add the new profile name to the profile names
            [self.data addObject:name];
            [self.data sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            NSLog(@"createnewprofilewithname %@", [self.data description]);
            
            // Update the profile list in the text file
            [self saveProfilesData];
            
            // Create Sounds directory
            NSString *soundsDirectory = [newProfileDirectory stringByAppendingPathComponent:@"Sounds"];
            [[NSFileManager defaultManager] createDirectoryAtPath:soundsDirectory withIntermediateDirectories:NO attributes:Nil error:&error];
            if (error == nil) {
                // Check if the Sounds directory was created
                if ([[NSFileManager defaultManager] fileExistsAtPath:soundsDirectory]) {
                    NSString *soundsListFile = [soundsDirectory stringByAppendingString:@"/Sounds.txt"];
                    // Save sound list in the Sounds directory
                    if (![[NSFileManager defaultManager] fileExistsAtPath:soundsListFile]) {
                        NSString *fileContent = @"0\n";
                        const char *utfString = [fileContent UTF8String];
                        NSData *fileData = [NSData dataWithBytes:utfString length:strlen(utfString)];
                        [[NSFileManager defaultManager] createFileAtPath:soundsListFile contents:fileData attributes:nil];
                    }
                }
                return YES;
            }
            NSLog(@"%@", [error description]);
        }
        else {
            NSLog(@"%@", [error description]);
        }
    }
    return NO;
}

- (BOOL) saveProfilesData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *profilesFile = [documentDirectory stringByAppendingString:@"/Profiles/Profiles.txt"];

    NSString *stringToSave = [NSString stringWithFormat:@"%d\n", [self.data count]];
    
    for (int i=0; i<[self.data count]; i++) {
        stringToSave = [stringToSave stringByAppendingFormat:@"%@\n", [self.data objectAtIndex:i]];
    }
    
    const char *utf8StringToSave = [stringToSave UTF8String];
    
    NSData *dataToSave = [NSData dataWithBytes:utf8StringToSave length:strlen(utf8StringToSave)];
    
    [dataToSave writeToFile:profilesFile atomically:YES];
    return YES;
}

- (void) deleteProfile: (NSString *) profileName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:LastProfileKey] isEqualToString:profileName]) {
        [defaults removeObjectForKey:LastProfileKey];
        [defaults synchronize];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *profilesPath = [documentsDirectory stringByAppendingString:@"/Profiles"];
    NSString *profileToDelete = [profilesPath stringByAppendingPathComponent:profileName];
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:profileToDelete error:&error];
    
    if (error!=nil) {
        NSLog(@"%@", [error description]);
    }
    
    NSString *sessionsPath = [documentsDirectory stringByAppendingFormat:@"/Sessions/%@", profileName];
    [[NSFileManager defaultManager] removeItemAtPath:sessionsPath error:&error];
    
    if (error != nil) {
        NSLog(@"%@", [error description]);
    }
    
}

#pragma UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCellID"];
    cell.customTextLabel.text = [self.data objectAtIndex:[indexPath row]];
    cell.playButton.userInteractionEnabled = NO;
    cell.playButton.hidden = YES;
    return cell;
}

- (void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView reloadData];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteProfile:[self.data objectAtIndex:[indexPath row]]];
        [self.data removeObjectAtIndex:[indexPath row]];
        NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
        [self saveProfilesData];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *profileChosen = [self.data objectAtIndex:[indexPath row]];
    [(ViewController*) self.viewControllerDelegate profileWasSelected:profileChosen];
}

@end
