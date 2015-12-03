//
//  ArtistPictureDownloadService.h
//  MyMusicLibrary
//
//  Created by yacub elmi on 3/15/15.
//  Copyright (c) 2015 Yacub Elmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceDelegate.h"


@interface ArtistPictureDownloadService :NSOperation {
    NSString *artistpic;
    NSString *artistPictureURL;
    id<ServiceDelegate> delegate;
}
@property (nonatomic, retain) NSString *artistpic;
@property (nonatomic, retain) NSString *artistPictureURL;
@property (nonatomic, retain) id<ServiceDelegate> delegate;


@end
