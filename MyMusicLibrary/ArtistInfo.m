//
//  ArtistInfo.m
//  MyMusicLibrary
//
//  Created by yacub elmi on 3/15/15.
//  Copyright (c) 2015 Yacub Elmi. All rights reserved.
//
#import "ArtistInfo.h"



@implementation ArtistInfo
@synthesize artistinfo;
@synthesize delegate;
@synthesize details;

- (void)main {
    NSString *api_key = @"f06e41f0aad377a1aebfe76927318181";
    NSString *artist_Name= [artistinfo stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=%@&api_key=%@&format=json",artist_Name,api_key];
    NSLog(@"artticinfo %@",url);
    NSLog(@"%@", url);
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
    
    if (responseData !=nil) {
        NSError *error = nil;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        if (error) {
            [delegate serviceFinished:self  withError:YES];
        } else {
            details = [json valueForKey:@"artist"];
            [delegate serviceFinished:self withError:NO];
        }
        
    } else {
        [delegate serviceFinished:self withError:YES];
    }
}
@end
