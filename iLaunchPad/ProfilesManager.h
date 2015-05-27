//
//  ProfilesManager.h
//  iLaunchPad
//
//  Created by sergey on 11/28/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import "Manager.h"
#import "CustomTableViewCell.h"

@interface ProfilesManager : Manager

- (BOOL) checkNewProfileName: (NSString *) name;

- (BOOL) createNewProfileWithName: (NSString *) name;

- (BOOL) saveProfilesData;

@property (nonatomic, strong) NSString *currentProfile;

@end
