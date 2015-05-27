//
//  AppDelegate.m
//  iLaunchPad
//
//  Created by sergey on 11/28/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Hide statusbar on the device
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    // Check if the Profiles directory was created, if not create it and create a text file which will keep the information
    // about existing profiles
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Check if the Profiles directory was created
    NSString *profilesPath = [documentsDirectory stringByAppendingString:@"/Profiles"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:profilesPath]) {
        NSError *error;
        //Creating Profiles Directory in the Application "Documents" directory
        [[NSFileManager defaultManager] createDirectoryAtPath:profilesPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error];
    }
    
    // Create Profiles.txt which will keep the number of profiles created as well as the name list, each name written on a new line
    if ([[NSFileManager defaultManager] fileExistsAtPath:profilesPath]) {
        NSString *profilesListFile = [documentsDirectory stringByAppendingString:@"/Profiles/Profiles.txt"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:profilesListFile]) {
            NSString *fileContent = @"0\n";
            const char *utfString = [fileContent UTF8String];
            NSData *fileData = [NSData dataWithBytes:utfString length:strlen(utfString)];
            [[NSFileManager defaultManager] createFileAtPath:profilesListFile contents:fileData attributes:nil];
        }
    }
    
    NSString *sessionsPath = [documentsDirectory stringByAppendingString:@"/Sessions"];
    
    // Check if Sessions directory was created
    if (![[NSFileManager defaultManager] fileExistsAtPath:sessionsPath]) {
        NSError *error;
        //Creating Sessions Directory in the Application "Documents" directory
        [[NSFileManager defaultManager] createDirectoryAtPath:sessionsPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error];
    }

    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
