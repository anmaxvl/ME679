//
//  SessionsManager.m
//  iLaunchPad
//
//  Created by sergey on 11/28/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import "SessionsManager.h"

@implementation SessionsManager

- (instancetype) initWithDataAtPath: (NSString *) path andFile: (NSString *) file {
    self = [super init];
    
    if (self != nil) {
        self.data = [NSMutableArray arrayWithObjects:@"Session One", @"Session Two", @"Session Three", nil];
        return self;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sessionCell"];
    cell.textLabel.text = [self.data objectAtIndex:[indexPath row]];
    return cell;
}

@end
