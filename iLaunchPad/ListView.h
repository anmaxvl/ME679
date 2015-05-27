//
//  ListView.h
//  iLaunchPad
//
//  Created by Max on 11/28/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
#import "ProfilesManager.h"
#import "SessionsManager.h"
#import "SoundsManager.h"

@interface ListView : UIView

@property (nonatomic, strong) IBOutlet UITableView *contentTable;
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) IBOutlet UIButton *editButton;
@property (nonatomic, strong) IBOutlet UIButton *plusButton;

@property (nonatomic, readwrite) BOOL isContentTableEditing;

- (void) layoutSubviewsForProfilesList;
- (void) layoutSubviewsForSessionsList;
- (void) layoutSubviewsForSoundsList;

@end
