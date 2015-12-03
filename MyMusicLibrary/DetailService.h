//
//  DetailService.h
//  MyMusicLibrary
//
//  Created by yacub elmi on 3/15/15.
//  Copyright (c) 2015 Yacub Elmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceDelegate.h"


@interface DetailService : NSOperation {
    NSString *musicname;
    NSString *artistname;
    id<ServiceDelegate> delegate;
    
    NSDictionary *details;
}

@property (nonatomic,retain) NSString *musicname;
@property (nonatomic,retain) NSString *artistname;
@property (nonatomic, retain) id<ServiceDelegate> delegate;

@property (nonatomic, retain) NSDictionary *details;


@end