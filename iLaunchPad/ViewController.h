//
//  ViewController.h
//  iLaunchPad
//
//  Created by sergey on 11/28/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProfilesManager.h"
#import "SessionsManager.h"
#import "SoundsManager.h"
#import "ListView.h"
#import "LaunchPadKeyPadView.h"
#import "LaunchPadKeyPadCore.h"
#import "TextFieldView.h"

@interface ViewController: UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *startUpView;
@property (nonatomic, strong) IBOutlet ListView *adjustableListView;
@property (nonatomic, strong) IBOutlet LaunchPadKeyPadView *launchPadView;
@property (nonatomic, strong) IBOutlet TextFieldView *textFieldView;
@property (nonatomic, strong) IBOutlet UIView *menuView;

@property (nonatomic, strong) ProfilesManager *profilesManager;
@property (nonatomic, strong) SoundsManager *soundsManager;
@property (nonatomic, strong) SessionsManager *sessionsManager;
@property (nonatomic, strong) LaunchPadKeyPadCore *launchpadCore;

- (IBAction) startButtonClickListener:(id)sender;
- (IBAction) editButtonClickListener:(id)sender;
- (IBAction) backButtonClickListener:(id)sender;
- (IBAction) plusButtonClickListener:(id)sender;
- (IBAction) cancelButtonClickListener:(id)sender;
- (IBAction) toggleButtonCLickListener:(id)sender;
- (IBAction) switchProfileButtonClickListener:(id)sender;

- (void) profileWasSelected: (NSString *) profile;

@end
