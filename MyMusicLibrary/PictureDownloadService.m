//
//  PictureDownloadService.m
//  MyMusicLibrary
//
//  Created by yacub elmi on 3/15/15.
//  Copyright (c) 2015 Yacub Elmi. All rights reserved.
//

#import "PictureDownloadService.h"

@implementation PictureDownloadService

@synthesize musicID;
@synthesize artistID;
@synthesize musicPictureURL;
@synthesize delegate;

-(void)main {
    NSString *url = [self musicPictureURL];
    NSLog(@"Show error1: %@", url);

    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@%@.png", docDir, musicID, artistID];
    
    NSURL* aURL = [NSURL URLWithString:url];
    NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
    UIImage *music_image = [UIImage imageWithData:data];
    
    NSData *data1=[NSData dataWithData:UIImagePNGRepresentation(music_image)];
    [data1 writeToFile:pngFilePath atomically:YES];
    
    [delegate serviceFinished:self withError:NO];
    
}


@end
