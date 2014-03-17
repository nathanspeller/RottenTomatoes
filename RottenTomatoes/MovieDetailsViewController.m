//
//  MovieDetailsViewController.m
//  RottenTomatoes
//
//  Created by Nathan Speller on 3/15/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import <UIImageView+AFNetworking.h>

@interface MovieDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundPoster;
@property (weak, nonatomic) IBOutlet UIView *textContainerView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *movieCast;
@property (weak, nonatomic) IBOutlet UILabel *score;

@end

@implementation MovieDetailsViewController

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
    // Do any additional setup after loading the view from its nib.
    self.movieTitle.text = self.movie.title;
    self.description.numberOfLines = 0;
    [self.description sizeToFit];
    self.description.text = self.movie.synopsis;

    self.rating.text = [NSString stringWithFormat:@"%@  %@ min.", self.movie.mpaaRating, self.movie.runtime];
    self.score.text = [NSString stringWithFormat:@"%d%%", self.movie.criticsScore];
    self.movieCast.text = self.movie.cast;
    [self.backgroundPoster setImageWithURL:self.movie.posterURL];
    self.backgroundPoster.contentMode = UIViewContentModeScaleAspectFit;
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = self.textContainerView.bounds;
    l.colors = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor, (id)[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.75].CGColor, nil];
    l.startPoint = CGPointMake(1.0f, 0.8f);
    l.endPoint = CGPointMake(1.0f, 0.0f);
    self.textContainerView.layer.mask = l;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
