//
//  PictureDownloadService.h
//  MyMusicLibrary
//
//  Created by yacub elmi on 3/15/15.
//  Copyright (c) 2015 Yacub Elmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceDelegate.h"

@interface PictureDownloadService : NSOperation {
    NSString *musicID;
    NSString *artistID;
    NSString *musicPictureURL;
    id<ServiceDelegate> delegate;
}
@property (nonatomic, retain) NSString *musicID;
@property (nonatomic, retain) NSString *artistID;
@property (nonatomic, retain) NSString *musicPictureURL;
@property (nonatomic, retain) id<ServiceDelegate> delegate;





@end
