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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.movies = [[NSMutableArray alloc] init];
    self.title = @"Movies";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0]];
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:0.800 blue:0.400 alpha:1.000];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
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
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self fetchData];
    [refreshControl endRefreshing];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)fetchData
{
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
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
            [CRToastManager showNotificationWithOptions:options completionBlock:^{}];
        } else {
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@", object);
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *moviesArray = [dataDictionary objectForKey:@"movies"];
            [self.movies removeAllObjects];
            for (NSDictionary *mDictionary in moviesArray) {
                Movie *movie = [[Movie alloc] initWithDictionary:mDictionary];
                [self.movies addObject:movie];
            }
            [self.tableView reloadData];
        }
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.movies count];
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
    cell.criticsScore.text = [NSString stringWithFormat:@"%d%%", movie.criticsScore];
    cell.abridgedCast.text = movie.cast;
    cell.rating.text = movie.mpaaRating;
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 60, 90)];
    [img setImageWithURL:movie.thumbnailURL];
    [cell addSubview:img];
    
    cell.separatorInset = UIEdgeInsetsZero;
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.1 green:0.10 blue:0.1 alpha:1.0];
    cell.selectedBackgroundView = bgColorView;
    
    UIView* scoreBarContainer = [[UIView alloc]initWithFrame:CGRectMake(89, 66, 215, 1)];
    scoreBarContainer.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    [cell addSubview:scoreBarContainer];
    
    UIView* score = [[UIView alloc]initWithFrame:CGRectMake(89, 66, (2.15*movie.criticsScore), 1)];
    UIColor *barColor = (movie.criticsScore < 70) ? [UIColor colorWithRed:0.8 green:0.2 blue:0.3 alpha:1.0] : [UIColor colorWithRed:0.3 green:0.5 blue:0.2 alpha:1.0];
    score.backgroundColor = barColor;
    [cell addSubview:score];
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];

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
