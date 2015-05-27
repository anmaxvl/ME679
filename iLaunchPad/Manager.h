//
//  Manager.h
//  iLaunchPad
//
//  Created by sergey on 11/28/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Manager : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UIViewController *viewControllerDelegate;

- (instancetype) initWithDataAtPath: (NSString *) path andFile: (NSString *) file;

@end
