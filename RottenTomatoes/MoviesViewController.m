//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by Nathan Speller on 3/13/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieDetailsViewController.h"
#import <UIImageView+AFNetworking.h>
#import "MovieCell.h"
#import "Movie.h"
#import "MBProgressHUD.h"
#import "CRToast.h"

@interface MoviesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *movies;

@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.tableView reloadData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.movies = [[NSMutableArray alloc] init];
    self.title = @"Movies";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self fetchData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self fetchData];
    [refreshControl endRefreshing];
}


- (void)fetchData
{
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSDictionary *options = @{
                                      kCRToastTextKey : @"Network Error!",
                                      kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                      kCRToastBackgroundColorKey : [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0],
                                      kCRToastTimeIntervalKey : @10.0,
                                      kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                      kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop)
                                      };
            [CRToastManager showNotificationWithOptions:options
                                        completionBlock:^{
//                                            NSLog(@"Completed");
                                        }];
        } else {
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@", object);
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSArray *moviesArray = [dataDictionary objectForKey:@"movies"];
            
            for (NSDictionary *mDictionary in moviesArray) {
                Movie *movie = [[Movie alloc] init];
                movie.title = [mDictionary objectForKey:@"title"];
                movie.synopsis = [mDictionary objectForKey:@"synopsis"];
                movie.thumbnailURL = [NSURL URLWithString:mDictionary[@"posters"][@"profile"]];
                movie.posterURL = [NSURL URLWithString:mDictionary[@"posters"][@"original"]];
                movie.mpaaRating = [mDictionary objectForKey:@"mpaa_rating"];
                movie.audienceScore = [mDictionary[@"ratings"][@"audience_score"] integerValue];
                movie.criticsScore = [mDictionary[@"ratings"][@"critics_score"] integerValue];
                NSArray *castArray = [mDictionary objectForKey:@"abridged_cast"];
                for(NSDictionary *castDictionary in castArray){
                    [movie addCastMember:[castDictionary objectForKey:@"name"]];
                }
                [self.movies addObject:movie];
            }
            
            [self.tableView reloadData];
            
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.movies count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MovieCell";
    
    MovieCell *cell = (MovieCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MovieCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Movie *movie = [self.movies objectAtIndex:indexPath.row];
    
    cell.movieTitle.text = movie.title;
    cell.criticsScore.text = [NSString stringWithFormat:@"%d", movie.criticsScore];
    cell.audienceScore.text = [NSString stringWithFormat:@"%d", movie.audienceScore];
    cell.abridgedCast.text = movie.cast;
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 60, 90)];
    [img setImageWithURL:movie.thumbnailURL];
    [cell addSubview:img];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieDetailsViewController *vc = [[MovieDetailsViewController alloc] init];
    vc.movie = [self.movies objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0;
}

@end
