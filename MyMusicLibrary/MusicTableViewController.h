//
//  MusicTableViewController.h
//  MyMusicLibrary
//
//  Created by yacub elmi on 3/15/15.
//  Copyright (c) 2015 Yacub Elmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceDelegate.h"
#import "MusicSearchServices.h"

@interface MusicTableViewController : UITableViewController <UISearchBarDelegate, ServiceDelegate> {
    UISearchBar *searchBar;
    
    BOOL searching;
    
    NSMutableArray *music;
    NSMutableArray *searchResults;
     NSOperationQueue *serviceQueue;
}

@end
