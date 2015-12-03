//
//  MusicTableViewController.m
//  MyMusicLibrary
//
//  Created by yacub elmi on 3/15/15.
//  Copyright (c) 2015 Yacub Elmi. All rights reserved.
//

#import "MusicTableViewController.h"
#import "MusicDetailsViewController.h"
#import "PictureDownloadService.h"
#import <QuartzCore/QuartzCore.h>

@interface MusicTableViewController ()

@end

@implementation MusicTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self setTitle:@"My Music"];
        
        // Create SearchBar for table header
        UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [vw addSubview:searchBar];
        [[self tableView] setTableHeaderView:vw];
        
        // Set up Search Bar for Uses
        [searchBar setPlaceholder:@"Music Name"];
        [searchBar setDelegate:self];
        searching = NO;
        
        // Create basic music list for testing display
        music = [NSMutableArray arrayWithCapacity:10];
        searchResults = [NSMutableArray arrayWithCapacity:10];
        
        // Set up service queue
        serviceQueue = [[NSOperationQueue alloc] init];
        [serviceQueue setMaxConcurrentOperationCount:1];
        
        // Restore saved Film list
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *yourArrayFileName = [documentDirectory stringByAppendingPathComponent:@"music.xml"];
        music = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
        if (music == nil) {
            music = [NSMutableArray arrayWithCapacity:10];
        }
        
        // Sort films
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [music sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
        
        
        //tableview animation
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionPush;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.fillMode = kCAFillModeForwards;
        transition.duration = 2.1;
        transition.subtype = kCATransitionFromBottom;
        
        [[self.tableView layer] addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
        
    }
    return self;
    
  
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)sb {
    // Set the state to be searching
    searching = YES;
    
    // Add Cancel/Done button to navigation bar
    [[self navigationItem] setRightBarButtonItem:
     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                   target:self action:@selector(searchDone:)]];
    [[self navigationItem] setLeftBarButtonItem:nil];
    
    //Force Table to reload and redraw
    [searchResults removeAllObjects];
    [[self tableView] reloadData];
    
}

- (void)searchDone:(id) sender {
    // Clear search text
    [searchBar setText:@""];
    
    // Hide the keyboard from the searchBar
    [searchBar resignFirstResponder];
    
    // remove the Cancel/Done button from the navigation bar
    [[self navigationItem] setRightBarButtonItem:nil];
    [[self navigationItem] setLeftBarButtonItem:[ self editButtonItem]];
    
    // Clear Search Results and Reset state
    searching = NO;
    [searchResults removeAllObjects];
    
    // Force table to reload and redraw
    [[self tableView] reloadData];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sb{
    // Retrieve search term from search bar
    NSString *searchTerm = [searchBar text];
    
    MusicSearchServices *service = [[MusicSearchServices alloc] init];
    [service setSearchTerm:searchTerm];
    [service setDelegate:self];
    [serviceQueue addOperation:service];
    
    // Add search term to search results
    [searchResults removeAllObjects];
    [searchResults addObject:
     [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-1", @"Searching . .", @"", nil]
                                 forKeys:[NSArray arrayWithObjects:@"id", @"name", @"artist", nil]]];
    [[self tableView] reloadData];
    
    // Hide the keyboard from the searchBar
    [searchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return searching ? [searchResults count] : [music count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Configure the cell....
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *movie = searching ? [searchResults objectAtIndex:[indexPath row]]:
    [music objectAtIndex: [indexPath row]];
    //[[cell imageView] setImage:[movie valueForKey:@"image"]];

    [[cell textLabel] setText:[movie valueForKey:@"name"]];
    [[cell detailTextLabel] setText:[[movie valueForKey:@"artist"] description]];
     [[cell imageView] setImage:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:[movie valueForKey:@"image"]]]]];
    
    
    /*NSString *path = [[NSBundle mainBundle] pathForResource:[movie objectForKey:@"#text"] ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage;*/
    
    
    
    
    return cell;
}
/*
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}*/

- (void)serviceFinished:(id)service withError:(BOOL)error {
    // Enter Service responce code
    if (!error) {
        [searchResults removeAllObjects];
        for (NSDictionary *movie in [service results]) {
            // create dictionary to store multiple values for films
            NSMutableDictionary *m_info = [[NSMutableDictionary alloc] initWithCapacity:3];
            
            //store given variables
            [m_info setValue:[movie valueForKey:@"id"] forKey:@"id"];
            [m_info setValue:[movie valueForKey:@"name"] forKey:@"name"];
            [m_info setValue:[movie valueForKey:@"artist"] forKey:@"artist"];
            [m_info setValue:[[[movie valueForKey:@"image"] valueForKey:@"#text"]objectAtIndex:2] forKey:@"image"];
            
            // Add movie info to main list
            [searchResults addObject:m_info];
        }
        
        // If there are no results found
        if ([searchResults count] ==0) {
            [searchResults addObject:
             [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"-1", @"No Results Found", @"", nil]
                                         forKey:[NSArray arrayWithObjects:@"id", @"name", @"artist", nil]]];
        }
        
        [[self tableView] reloadData];
    } else {
        [searchResults removeAllObjects];
        [searchResults addObject:
         [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"-1", @"There has been an error", @"", nil]
                                     forKeys: [NSArray arrayWithObjects:@"id", @"name", @"artist", nil]]];
        [[self tableView] reloadData];
    }
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return !searching;
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *movie = [music objectAtIndex:[indexPath row]];
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, [movie valueForKey:@"id"]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:pngFilePath]){
            [fileManager removeItemAtPath:pngFilePath error:nil];
        }
        
        [music removeObject:movie];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *yourArrayFileName = [documentDirectory stringByAppendingPathComponent:@"music.xml"];
        [music writeToFile:yourArrayFileName atomically:YES];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    //Save films list once returned to list view
    [super viewWillAppear:animated];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *yourArrayFileName = [documentDirectory stringByAppendingPathComponent:@"music.xml"];
    [music writeToFile:yourArrayFileName atomically:YES];
    
}



/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searching) {
        // use for interaction with list search
        NSDictionary *movie = [searchResults objectAtIndex:[indexPath row]];
        
        // check label for system messages
        if ([[movie valueForKey:@"id"] intValue] != -1 ) {
            
            // Add new film to list
            [music addObject:movie];
            
            // Clear search text
            [searchBar setText:@""];
            
            // Remove the cancel/done button from navigation
            [[self navigationItem] setRightBarButtonItem:nil];
            [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];

            
            // Clear Search Results and reset state
            searching= NO;
            [searchResults removeAllObjects];
            
            // Force table to reload and redraw
            [[self tableView] reloadData];
            
            // Sort music
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            [music sortUsingDescriptors: [NSArray arrayWithObjects:descriptor, nil]];
            
            // Store data
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            NSString *yourArrayFileName = [documentDirectory stringByAppendingPathComponent:@"music.xml"];
            [music writeToFile:yourArrayFileName atomically:YES];
            

            
        }
    } else {
        
        // Use for interaction with file list
        NSDictionary *musics = [music objectAtIndex:[indexPath row]];
        
        MusicDetailsViewController *vc = [[MusicDetailsViewController alloc] initWithNibName:@"MusicDetailsViewController" bundle:nil];
        [vc setMusic:musics];
        [[self navigationController]pushViewController:vc animated:YES];
        
    }
}

@end

