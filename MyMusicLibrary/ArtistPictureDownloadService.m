//
//  ArtistPictureDownloadService.m
//  MyMusicLibrary
//
//  Created by yacub elmi on 3/15/15.
//  Copyright (c) 2015 Yacub Elmi. All rights reserved.
//

#import "ArtistPictureDownloadService.h"

@implementation ArtistPictureDownloadService
@synthesize artistpic;
@synthesize artistPictureURL;
@synthesize delegate;

-(void)main {
    NSString *url = [self artistPictureURL];
    NSLog(@"Show error1: %@", url);
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, artistpic];
    
    NSURL* aURL = [NSURL URLWithString:url];
    NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
    UIImage *artist_image = [UIImage imageWithData:data];
    
    NSData *data1=[NSData dataWithData:UIImagePNGRepresentation(artist_image)];
    [data1 writeToFile:pngFilePath atomically:YES];
    
    [delegate serviceFinished:self withError:NO];
    
}


@end
