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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}


- (void)fetchData
{
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", object);
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSArray *moviesArray = [dataDictionary objectForKey:@"movies"];
        
        for (NSDictionary *mDictionary in moviesArray) {
            Movie *movie = [[Movie alloc] init];
            movie.title = [mDictionary objectForKey:@"title"];
            movie.synopsis = [mDictionary objectForKey:@"synopsis"];
            movie.thumbnailURL = [NSURL URLWithString:mDictionary[@"posters"][@"profile"]];
            NSArray *castArray = [mDictionary objectForKey:@"abridged_cast"];
            for(NSDictionary *castDictionary in castArray){
                [movie addCastMember:[castDictionary objectForKey:@"name"]];
            }
            [self.movies addObject:movie];
        }
        
        [self.tableView reloadData];
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
    cell.synopsis.text = movie.synopsis;
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
