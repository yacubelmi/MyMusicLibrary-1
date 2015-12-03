//
//  MusicDetailsViewController.h
//  MyMusicLibrary
//
//  Created by yacub elmi on 3/15/15.
//  Copyright (c) 2015 Yacub Elmi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ServiceDelegate.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>


@interface MusicDetailsViewController  : UIViewController <ServiceDelegate> {
    NSOperationQueue *serviceQueue;
    SLComposeViewController *mySLComposerSheet;
    
}

@property (strong, nonatomic) IBOutlet UILabel *lbText;

@property (weak, nonatomic) IBOutlet UIImageView *imgFilm;
@property (weak, nonatomic) IBOutlet UILabel *txtFilmText;
@property (weak, nonatomic) IBOutlet UILabel *txtFilmYear;
//@property (weak, nonatomic) IBOutlet UITextView *txtSynopsis;
//@property (weak, nonatomic) IBOutlet UITextView *txtCast;
@property (weak, nonatomic) IBOutlet UILabel *txtReleaseDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgArtist;
@property (weak, nonatomic) IBOutlet UITextView *txtalbumurl;
@property (weak, nonatomic) IBOutlet UILabel *txtlis;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UITextView *txtSummary;
@property (nonatomic, retain) NSDictionary *music;

- (IBAction)postToFacebook:(id)sender;


@end
