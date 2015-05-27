//
//  SessionsManager.h
//  iLaunchPad
//
//  Created by sergey on 11/28/13.
//  Copyright (c) 2013 GIST. All rights reserved.
//

#import "Manager.h"

@interface SessionsManager : Manager

- (instancetype) initWithDataAtPath: (NSString *) path andFile: (NSString *) file;


@end
