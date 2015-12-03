//
//  MusicSearchServices.m
//  MyMusicLibrary
//
//  Created by yacub elmi on 3/15/15.
//  Copyright (c) 2015 Yacub Elmi. All rights reserved.
//

#import "MusicSearchServices.h"


@implementation MusicSearchServices

@synthesize searchTerm;
@synthesize delegate;

@synthesize results;

- (void)main {
    NSString *api_key = @"f06e41f0aad377a1aebfe76927318181";
    NSString *search_term = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://ws.audioscrobbler.com/2.0/?method=album.search&album=%@&api_key=%@&format=json", search_term, api_key];
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
    
    if (responseData !=nil) {
        NSError *error = nil;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        if (error) {
            [delegate serviceFinished:self  withError:YES];
        } else {
            results = (NSArray *) [[[json valueForKey:@"results"] valueForKey:@"albummatches"] valueForKey:@"album"];
            [delegate serviceFinished:self withError:NO];
        }
        
    } else {
        [delegate serviceFinished:self withError:YES];
    }
}


@end
