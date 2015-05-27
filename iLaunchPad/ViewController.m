//
//  ViewController.m
//  iLaunchPad
//
//  Created by sergey on 11/28/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // Check if the Profiles directory was created
    NSString *documentsDirectory = [self getDocumentsDirectoryPath];
    NSString *profilesPath = [documentsDirectory stringByAppendingString:@"/Profiles"];

    self.profilesManager = [[ProfilesManager alloc] initWithDataAtPath:profilesPath andFile:@"Profiles.txt"];
    self.profilesManager.viewControllerDelegate = self;
    
    self.adjustableListView.contentTable.delegate = self.profilesManager;
    self.adjustableListView.contentTable.dataSource = self.profilesManager;
    
    self.adjustableListView.isContentTableEditing = NO;
    [self.adjustableListView.contentTable registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:[NSBundle mainBundle]]
                            forCellReuseIdentifier:@"CustomTableViewCellID"];
    
    NSString *lastProfile = [self getLastProfile];
    NSLog(@"viewDidLoad lastProfile: %@", lastProfile);
    if (lastProfile != nil) {
        NSString *archivePath = [LaunchPadKeyPadCore getArchivePathForProfile:lastProfile];
        self.launchpadCore = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
        NSString *soundsDirectory = [SoundsManager getSoundsPathForProfile:lastProfile];
        self.soundsManager = [[SoundsManager alloc] initWithDataAtPath:soundsDirectory andFile:@"Sounds.txt"];
        
        self.adjustableListView.contentTable.delegate = self.soundsManager;
        self.adjustableListView.contentTable.dataSource = self.soundsManager;
        [self.adjustableListView.contentTable reloadData];
        [self.adjustableListView layoutSubviewsForSoundsList];
    }

    if (self.launchpadCore == nil) {
        self.launchpadCore = [[LaunchPadKeyPadCore alloc] initWithNumberOfKeys:12];
    }
    self.launchpadCore.soundsManager = self.soundsManager;

    [self.launchpadCore setCurrentProfile:lastProfile];
    self.launchPadView.launchpadCore = self.launchpadCore;
    [self.launchPadView registerNotifications];

    [self.launchPadView enterEditMode:NO animated:NO];
    [self.launchPadView updateKeyViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSoundListNotificationListener) name:ShowSoundList object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
}

- (void) viewDidLayoutSubviews {
    self.startUpView.frame = CGRectMake(0, 0, 320, 480);
    
    if ([self getLastProfile] != nil) {
        self.adjustableListView.frame = CGRectMake(-320, 0, 320, 480);
    }
    else {
        self.adjustableListView.frame = CGRectMake(320, 0, 320, 480);
    }

    self.launchPadView.frame = CGRectMake(320, 0, 320, 480);
    self.textFieldView.frame = CGRectMake(20, -150, 280, 120);
    self.menuView.frame = CGRectMake(0, -60, 320, 60);
    
    [self.adjustableListView layoutSubviewsForProfilesList];
    [self.adjustableListView.contentTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) showSoundListNotificationListener {
    self.adjustableListView.frame = CGRectMake(-320, 0, 320, 480);
    self.adjustableListView.contentTable.delegate = self.soundsManager;
    self.adjustableListView.contentTable.dataSource = self.soundsManager;
    
    [self.adjustableListView.contentTable reloadData];
    [self.adjustableListView layoutSubviewsForSoundsList];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:.5];
    self.adjustableListView.frame = CGRectMake(0, 0, 320, 480);
    self.launchPadView.frame = CGRectMake(320, 0, 320, 480);
    [UIView commitAnimations];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soundWasSelectedNotificationListener) name:SoundWasSelected object:nil];
}

- (void) soundWasSelectedNotificationListener {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:.5];
    self.adjustableListView.frame = CGRectMake(-320, 0, 320, 480);
    self.launchPadView.frame = CGRectMake(0, 0, 320, 480);
    [UIView commitAnimations];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SoundWasSelected object:nil];
}

- (IBAction) startButtonClickListener:(id)sender {
    NSString *lastProfile = [self getLastProfile];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (lastProfile != nil) {
        self.launchPadView.frame = CGRectMake(0, 0, 320, 480);
    }
    else {
        self.adjustableListView.frame = CGRectMake(0, 0, 320, 480);
    }
    self.startUpView.frame = CGRectMake(-320, 0, 320, 480);
    [UIView commitAnimations];
}

- (IBAction) editButtonClickListener:(id)sender {
    if ([sender tag] == 444) {
        [self.adjustableListView.contentTable setEditing:!self.adjustableListView.isContentTableEditing animated:YES];
        self.adjustableListView.isContentTableEditing = !self.adjustableListView.isContentTableEditing;
    }
    else if ([sender tag] == 777) {
        [self.launchPadView enterEditMode:YES animated:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LaunchPadEditModeEntered object:nil];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.menuView.frame = CGRectMake(0, -60, 320, 60);
        self.launchPadView.userInteractionEnabled = YES;
        [UIView commitAnimations];
    }
}

- (IBAction) backButtonClickListener:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if ([sender tag] == 568) {
        self.startUpView.frame = CGRectMake(0, 0, 320, 480);
        self.adjustableListView.frame = CGRectMake(320, 0, 320, 480);
    }
    else if ([sender tag] == 567) {
        self.adjustableListView.frame = CGRectMake(-320, 0, 320, 480);
        self.launchPadView.frame = CGRectMake(0, 0, 320, 480);
    }
    [UIView commitAnimations];
}

- (IBAction) plusButtonClickListener:(id)sender {
    self.adjustableListView.userInteractionEnabled = NO;
    [self.textFieldView.textFieldView becomeFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.textFieldView.userInteractionEnabled = YES;
    self.textFieldView.frame = CGRectMake(20, 65, 280, 120);
    [UIView commitAnimations];
}

- (IBAction) cancelButtonClickListener:(id)sender {
    if ([sender tag] == 1) {
        self.adjustableListView.userInteractionEnabled = YES;
        self.textFieldView.userInteractionEnabled = NO;
        [self.textFieldView.textFieldView resignFirstResponder];

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.textFieldView.frame = CGRectMake(20, -150, 280, 120);
        [UIView commitAnimations];
    }
    else if ([sender tag] == 555) {
        [self.launchPadView enterEditMode:NO animated:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LaunchPadEditModeExited object:nil];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.launchPadView.userInteractionEnabled = YES;
        self.menuView.frame = CGRectMake(0, -60, 320, 60);
        [UIView commitAnimations];
    }
}

- (IBAction) toggleButtonCLickListener:(id)sender {
    if ([sender tag] == 999) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.launchPadView.userInteractionEnabled = NO;
        self.menuView.frame = CGRectMake(0, 0, 320, 60);
        [UIView commitAnimations];
    }
}

- (IBAction) switchProfileButtonClickListener:(id)sender {
    self.adjustableListView.contentTable.delegate = self.profilesManager;
    self.adjustableListView.contentTable.dataSource = self.profilesManager;
    [self.adjustableListView layoutSubviewsForProfilesList];
    [self.adjustableListView.contentTable reloadData];
    
    [self.launchpadCore archive];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startSwitchProfile)];
    self.menuView.frame = CGRectMake(0, -60, 320, 60);
    [UIView commitAnimations];
}

- (void) startSwitchProfile {
    self.launchPadView.userInteractionEnabled = YES;
    [self.launchPadView enterEditMode:NO animated:NO];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:.5];
    self.adjustableListView.frame = CGRectMake(0, 0, 320, 480);
    self.launchPadView.frame = CGRectMake(320, 0, 320, 480);
    [UIView commitAnimations];
}


- (void) profileWasSelected: (NSString *) profile {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:profile forKey:LastProfileKey];
    [defaults synchronize];
    
    [self.profilesManager setCurrentProfile:profile];
    
    NSString *archivePath = [LaunchPadKeyPadCore getArchivePathForProfile:profile];
    self.launchpadCore = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    if (self.launchpadCore == nil) {
        self.launchpadCore = [[LaunchPadKeyPadCore alloc] initWithNumberOfKeys:12];
    }
    
    [self.launchpadCore setCurrentProfile:profile];
    self.launchPadView.launchpadCore = self.launchpadCore;
    [self.launchPadView registerNotifications];
    [self.launchPadView enterEditMode:NO animated:NO];
    [self.launchPadView updateKeyViews];
    
    NSString *soundsPath = [SoundsManager getSoundsPathForProfile:profile];
    self.soundsManager = [[SoundsManager alloc] initWithDataAtPath:soundsPath andFile:@"Sounds.txt"];
    self.launchpadCore.soundsManager = self.soundsManager;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.adjustableListView.frame = CGRectMake(-320, 0, 320, 480);
    self.launchPadView.frame = CGRectMake(0, 0, 320, 480);
    [UIView commitAnimations];
}

- (NSString *) getLastProfile {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastProfile = [defaults objectForKey:LastProfileKey];
    
    return lastProfile;
}

- (NSString *) getDocumentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory copy];
}

#pragma UITextFieldDelegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];

    if ([self.adjustableListView.contentTable.delegate isKindOfClass:[ProfilesManager class]] && [self.profilesManager checkNewProfileName:textField.text]) {
        [self.textFieldView.textFieldView resignFirstResponder];
        [self.profilesManager createNewProfileWithName:textField.text];

        self.adjustableListView.userInteractionEnabled = YES;
        self.textFieldView.userInteractionEnabled = NO;
        self.textFieldView.frame = CGRectMake(20, -150, 280, 120);
        
        [self.adjustableListView.contentTable reloadData];
    }
    else if ([self.adjustableListView.contentTable.delegate isKindOfClass:[SoundsManager class]]) {
        self.adjustableListView.userInteractionEnabled = YES;
        self.textFieldView.userInteractionEnabled = NO;

        self.textFieldView.frame = CGRectMake(20, -150, 280, 120);
        [self.adjustableListView.contentTable reloadData];
    }
    [UIView commitAnimations];
    return YES;
}
@end
