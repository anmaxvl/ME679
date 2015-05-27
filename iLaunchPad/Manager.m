//
//  Manager.m
//  iLaunchPad
//
//  Created by sergey on 11/28/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import "Manager.h"

@implementation Manager

- (instancetype) initWithDataAtPath: (NSString *) path andFile: (NSString *) file {
    NSAssert(nil, @"This is an abstract class and instances of this type cannot be created");
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


@end
