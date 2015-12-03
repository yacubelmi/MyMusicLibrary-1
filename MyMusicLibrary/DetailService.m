//
//  DetailService.m
//  MyMusicLibrary
//
//  Created by yacub elmi on 3/15/15.
//  Copyright (c) 2015 Yacub Elmi. All rights reserved.
//
#import "DetailService.h"
@implementation DetailService
@synthesize musicname;
@synthesize artistname;
@synthesize delegate;
@synthesize details;


- (void)main {
    NSString *api_key = @"f06e41f0aad377a1aebfe76927318181";
    NSString *music_Id= [musicname stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *artist_Id= [artistname stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=%@&artist=%@&album=%@&format=json", api_key,artist_Id,music_Id];
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
            details = [json valueForKey:@"album"];
            [delegate serviceFinished:self withError:NO];
        }
        
    } else {
        [delegate serviceFinished:self withError:YES];
    }
}

@end

