//
//  ServiceDelegate.h
//  MyMusicLibrary
//
//  Created by yacub elmi on 3/15/15.
//  Copyright (c) 2015 Yacub Elmi. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol ServiceDelegate <NSObject>
- (void)serviceFinished:(id)service withError:(BOOL)error;

@end
