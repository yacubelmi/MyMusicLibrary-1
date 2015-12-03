//
//  MusicDetailsViewController.m
//  MyMusicLibrary
//
//  Created by yacub elmi on 3/15/15.
//  Copyright (c) 2015 Yacub Elmi. All rights reserved.
//

#import "MusicDetailsViewController.h"
#import "DetailService.h"
#import "ArtistInfo.h"
#import "PictureDownloadService.h"
#import "ArtistPictureDownloadService.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "QuartzCore/CALayer.h"

@interface MusicDetailsViewController ()

@end

@implementation MusicDetailsViewController


@synthesize imgFilm;
@synthesize imgArtist;
@synthesize txtFilmText;
@synthesize txtFilmYear;
//@synthesize txtSynopsis;
//@synthesize txtCast;
@synthesize music;
@synthesize txtReleaseDate;
@synthesize txtSummary;
@synthesize txtlis;
@synthesize count;
@synthesize txtalbumurl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshMusicDetails)]];
    }
    return self;
  
    
}




-(void)refreshMusicDetails {
    DetailService *service = [[DetailService alloc] init];
    [service setArtistname:[[[self music] valueForKey:@"artist"] description]];
    [service setMusicname:[[self music] valueForKey:@"name"]];
    [serviceQueue addOperation:service];
    
    ArtistInfo *aservice = [[ArtistInfo alloc] init];
    [aservice setArtistinfo:[[[self music] valueForKey:@"artist"] description]];
    [serviceQueue addOperation:aservice];
    
    
}
- (void)serviceFinished:(id)service withError:(BOOL)error {
    


    
    if (!error) {
        
        if ([service class]==[DetailService class]) {
        
        NSDictionary *m = [service details];
        [[self music] setValue:[m valueForKey:@"name"] forKey:@"name"];
        [[self music] setValue:[m valueForKey:@"artist"] forKey:@"artist"];
        [[self music] setValue:[m valueForKey:@"releasedate"] forKey:@"releasedate"];
        [[self music] setValue:[m valueForKey:@"listeners"] forKey:@"listeners"];
        [[self music] setValue:[m valueForKey:@"playcount"] forKey:@"playcount"];
              [[self music] setValue:[m valueForKey:@"url"] forKey:@"url"];
        
        //Download and Cache profile picture
        PictureDownloadService *service = [[PictureDownloadService alloc] init];
        [service setDelegate:self];
        [service setMusicID:[[self music] valueForKey:@"name"]];
        [service setArtistID:[[[self music] valueForKey:@"artist"] description]];
        [service setMusicPictureURL:[[[m valueForKey:@"image"] valueForKey:@"#text"] objectAtIndex:3]];
        [serviceQueue addOperation:service];
       
        //NSLog(@"Show url_Img_FULL: %@",m);
        [self performSelectorOnMainThread:@selector(refreshView) withObject:nil waitUntilDone:YES];
    } else {
        [self performSelectorOnMainThread:@selector(refreshView) withObject:nil waitUntilDone:YES];
    }
        if ([service class]==[ArtistInfo class]) {
            NSDictionary *m = [service details];
            [[self music] setValue:[[m valueForKey:@"bio"] valueForKey:@"summary"]  forKey:@"summary"];
            
            ArtistPictureDownloadService *service = [[ArtistPictureDownloadService alloc] init];
            [service setDelegate:self];
            [service setArtistpic:[[[self music] valueForKey:@"artist"] description]];
            [service setArtistPictureURL:[[[m valueForKey:@"image"] valueForKey:@"#text"] objectAtIndex:3]];
            [serviceQueue addOperation:service];


            [self performSelectorOnMainThread:@selector(refreshView) withObject:nil waitUntilDone:YES];

        } else {
            [self performSelectorOnMainThread:@selector(refreshView) withObject:nil waitUntilDone:YES];

        }
        
    }
}
- (void)refreshView {
    
   

    
    if ([self music] != nil) {
        [txtFilmText setText:[[self music] valueForKey:@"name"]];
        [txtFilmYear setText:[[[self music] valueForKey:@"artist"] description]];
        [txtReleaseDate setText:[[[self music] valueForKey:@"releasedate"] description]];
        [txtlis setText:[[[self music] valueForKey:@"listeners"] description]];
        [count setText:[[[self music] valueForKey:@"playcount"] description]];
        [txtalbumurl setText:[[[self music] valueForKey:@"url"] description]];
        [txtSummary setText:[[[self music] valueForKey:@"summary"] description]];


        
        //check if image is downloaded
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@%@.png", docDir, [[self music] valueForKey:@"name"], [[self music] valueForKey:@"artist"]];
        NSLog(@"Show url_Img_FULL2: %@", pngFilePath);

        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:pngFilePath]){
            UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngFilePath]];
            [imgFilm setImage:pic];
            NSLog(@"Show url_Img_FULL: %@",pngFilePath);
        }

    } else {
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, [[self music] valueForKey:@"artist"] ];
        NSLog(@"Show url_Img_FULL2: %@", pngFilePath);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:pngFilePath]){
            UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngFilePath]];
            [imgArtist setImage:pic];
        }
    }
    
    
    //check if artist image shows
    NSString *docDir1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath1 = [NSString stringWithFormat:@"%@/%@.png", docDir1, [[self music] valueForKey:@"artist"] ];
    NSLog(@"Show url_Img_FULL2: %@", pngFilePath1);
    
    NSFileManager *fileManager1 = [NSFileManager defaultManager];
    if ([fileManager1 fileExistsAtPath:pngFilePath1]){
        UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngFilePath1]];
        [imgArtist setImage:pic];
    }
    
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
}

void MyDrawWithShadows (CGContextRef myContext, // 1
                        CGFloat wd, CGFloat ht)
{
    CGSize          myShadowOffset = CGSizeMake (-15,  20);// 2
    CGFloat           myColorValues[] = {1, 0, 0, .6};// 3
    CGColorRef      myColor;// 4
    CGColorSpaceRef myColorSpace;// 5
    
    CGContextSaveGState(myContext);// 6
    
    CGContextSetShadow (myContext, myShadowOffset, 5); // 7
    // Your drawing code here// 8
    CGContextSetRGBFillColor (myContext, 0, 1, 0, 1);
    CGContextFillRect (myContext, CGRectMake (wd/3 + 75, ht/2 , wd/4, ht/4));
    
    myColorSpace = CGColorSpaceCreateDeviceRGB ();// 9
    myColor = CGColorCreate (myColorSpace, myColorValues);// 10
    CGContextSetShadowWithColor (myContext, myShadowOffset, 5, myColor);// 11
    // Your drawing code here// 12
    CGContextSetRGBFillColor (myContext, 0, 0, 1, 1);
    CGContextFillRect (myContext, CGRectMake (wd/3-75,ht/2-100,wd/4,ht/4));
    
    CGColorRelease (myColor);// 13
    CGColorSpaceRelease (myColorSpace); // 14
    
    CGContextRestoreGState(myContext);// 15
}


- (void)viewWillAppear:(BOOL)animated{
    
  
    
    
    if ([self music] !=nil){
        [self setTitle:[[self music]valueForKey:@"name"]];
        [txtFilmText setText:[[self music] valueForKey:@"name"]];
        [txtFilmYear setText:[[[self music] valueForKey:@"artist"]description]];
        
        [txtReleaseDate setText:[[[self music] valueForKey:@"releasedate"]description]];
        [txtlis setText:[[self music] valueForKey:@"listeners"]];
        [count setText:[[self music] valueForKey:@"playcount"]];
        [txtalbumurl setText:[[self music] valueForKey:@"url"]];
        
        //Artist info web sevuces
        [txtSummary setText:[[[[self music] valueForKey:@"bio"] valueForKey:@"summary"] description]];

        [txtSummary setText:@""];
        
        //Artist Details Animation
        
        [_lbText setAlpha:0.0];
        [_lbText setCenter:CGPointMake(95, 85)];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:1];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationWillStartSelector:@selector(start)];
        
        [_lbText setAlpha:1.0];
        [_lbText setCenter:CGPointMake(180,85 )];
        
        
        [UIView commitAnimations];
       
        
        //Images Animation
        
        //Track Image
        
        [imgFilm setAlpha:0.0];
        [imgFilm setCenter:CGPointMake(97, 200)];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:1];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        
        [imgFilm setAlpha:1.0];
        [imgFilm setCenter:CGPointMake(97,200 )];
        
        
        [UIView commitAnimations];
        
        
        //Artist Image
        
        
        [imgArtist setAlpha:0.0];
        [imgArtist setCenter:CGPointMake(80, 390)];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:1];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        
        [imgArtist setAlpha:1.0];
        [imgArtist setCenter:CGPointMake(80,410 )];
        
        
        [UIView commitAnimations];
        
        
        //Details Animation
        
        [txtSummary setAlpha:0.0];
        [txtSummary setCenter:CGPointMake(230, 410)];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:1];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        
        [txtSummary setAlpha:1.0];
        [txtSummary setCenter:CGPointMake(230,410 )];
        
        
        [UIView commitAnimations];
        
        [txtFilmYear setAlpha:0.0];
        [txtFilmYear setCenter:CGPointMake(240, 340)];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:1];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        
        [txtFilmYear setAlpha:1.0];
        [txtFilmYear setCenter:CGPointMake(240,340 )];
        
        
        [UIView commitAnimations];
        
        
        //imagefilm shadow effect
        imgFilm.layer.shadowColor = [UIColor purpleColor].CGColor;
        imgFilm.layer.shadowOffset = CGSizeMake(4, 4);
        imgFilm.layer.shadowOpacity = 0.5;
        imgFilm.layer.shadowRadius = 0.9;
        imgFilm.clipsToBounds = NO;
        
        //imageArtist shadow effect
        imgArtist.layer.shadowColor = [UIColor purpleColor].CGColor;
        imgArtist.layer.shadowOffset = CGSizeMake(4, 3);
        imgArtist.layer.shadowOpacity = 0.9;
        imgArtist.layer.shadowRadius = 1.0;
        imgArtist.clipsToBounds = NO;
        
        
        //ServiceQue
        serviceQueue = [[NSOperationQueue alloc] init];
        [serviceQueue setMaxConcurrentOperationCount:1];
        
        ArtistInfo *aservice = [[ArtistInfo alloc] init];
        [aservice setArtistinfo:[[[self music] valueForKey:@"artist"] description]];
        [aservice setDelegate:self];
        [serviceQueue addOperation:aservice];
        
        DetailService *service = [[DetailService alloc]init];
        [service setMusicname:[[self music] valueForKey:@"name"]];
        [service setArtistname:[[[self music] valueForKey:@"artist"] description]];
        [service setDelegate:self];
        [serviceQueue addOperation:service];
        
        
        
        //check if album image is downloaded
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@%@.png", docDir, [[self music] valueForKey:@"name"], [[self music] valueForKey:@"artist"]];
        NSLog(@"Show url_Img_FULL2: %@", pngFilePath);

        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:pngFilePath]){
            UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngFilePath]];
            [imgFilm setImage:pic];
        } else {
            DetailService *service = [[DetailService alloc]init];
            [service setMusicname:[[self music] valueForKey:@"name"]];
            [service setArtistname:[[[self music] valueForKey:@"artist"] description]];
            [service setDelegate:self];
            [serviceQueue addOperation:service];
             // NSLog(@"Show error1: %@", artistservice);
        }
        
        
        
        
        //check if image is downloaded
        NSString *docDir2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSString *pngFilePath2 = [NSString stringWithFormat:@"%@/%@%@.png", docDir2, [[self music] valueForKey:@"name"], [[self music] valueForKey:@"artist"]];
        NSLog(@"Show url_Img_FULL2: %@", pngFilePath2);
        
        NSFileManager *fileManager2 = [NSFileManager defaultManager];
        if ([fileManager2 fileExistsAtPath:pngFilePath]){
            UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngFilePath]];
            [imgFilm setImage:pic];
            NSLog(@"Show url_Img_FULL: %@",pngFilePath);
        }
        
        //check if artist image shows
        NSString *docDir1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath1 = [NSString stringWithFormat:@"%@/%@.png", docDir1, [[self music] valueForKey:@"artist"] ];
        NSLog(@"Show url_Img_FULL2: %@", pngFilePath);
        
        NSFileManager *fileManager1 = [NSFileManager defaultManager];
        if ([fileManager1 fileExistsAtPath:pngFilePath1]){
            UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngFilePath1]];
            [imgArtist setImage:pic];
        }
        
    }
    
    if ([self music] != nil) {
        [txtFilmText setText:[[self music] valueForKey:@"name"]];
        [txtFilmYear setText:[[[self music] valueForKey:@"artist"] description]];
        [txtReleaseDate setText:[[[self music] valueForKey:@"releasedate"] description]];
        [txtlis setText:[[[self music] valueForKey:@"listeners"] description]];
        [count setText:[[[self music] valueForKey:@"playcount"] description]];
        [txtalbumurl setText:[[[self music] valueForKey:@"url"] description]];
        [txtSummary setText:[[[self music] valueForKey:@"summary"] description]];
        
        
        
        //check if image is downloaded
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@%@.png", docDir, [[self music] valueForKey:@"name"], [[self music] valueForKey:@"artist"]];
        NSLog(@"Show url_Img_FULL2: %@", pngFilePath);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:pngFilePath]){
            UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngFilePath]];
            [imgFilm setImage:pic];
            NSLog(@"Show url_Img_FULL: %@",pngFilePath);
        }
        
    } else {
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, [[self music] valueForKey:@"artist"] ];
        NSLog(@"Show url_Img_FULL2: %@", pngFilePath);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:pngFilePath]){
            UIImage *pic = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngFilePath]];
            [imgArtist setImage:pic];
        }
    }
    
    
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)postToFacebook:(id)sender {
    /*if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"First post from my iPhone app"];
        [self presentViewController:controller animated:YES completion:Nil];
    }*/
    
    UIActionSheet *share = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:@"Tweet It!",@"Facebook It!", nil];
    
    [share showInView:self.view];
    
    
    //[button setImage:hoverImage forState:UIControlStateHighlighted];
    
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        // Twitter
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweet setInitialText:@"Hey Check Out This Awsome App !"];
            [tweet setCompletionHandler:^(SLComposeViewControllerResult result)
             {
                 if (result == SLComposeViewControllerResultCancelled)
                 {
                     NSLog(@"The user cancelled.");
                 }
                 else if (result == SLComposeViewControllerResultDone)
                 {
                     NSLog(@"The user sent the tweet");
                 }
             }];
            [self presentViewController:tweet animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter"
                                                            message:@"Twitter integration is not available.  A Twitter account must be set up on your device."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        if  (buttonIndex==1) {
            
            // Facebook
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [tweet setInitialText:@"Hey Check Out This Awsome App !"];
                [tweet setCompletionHandler:^(SLComposeViewControllerResult result)
                 {
                     if (result == SLComposeViewControllerResultCancelled)
                     {
                         NSLog(@"The user cancelled.");
                     }
                     else if (result == SLComposeViewControllerResultDone)
                     {
                         NSLog(@"The user posted to Facebook");
                     }
                 }];
                [self presentViewController:tweet animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook"
                                                                message:@"Facebook integration is not available.  A Facebook account must be set up on your device."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }            }
            
        }
        
    }



@end
