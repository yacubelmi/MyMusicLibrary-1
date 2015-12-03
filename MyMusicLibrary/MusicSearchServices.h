//
//  MusicSearchServices.h
//  MyMusicLibrary
//
//  Created by yacub elmi on 3/15/15.
//  Copyright (c) 2015 Yacub Elmi. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ServiceDelegate.h"




@interface MusicSearchServices : NSOperation {
    NSString *searchTerm;
    id<ServiceDelegate> delegate;
    
    NSArray *results;
}

@property (nonatomic, retain) NSString *searchTerm;
@property (nonatomic, retain) id<ServiceDelegate> delegate;

@property (nonatomic, retain) NSArray *results;

@end
