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
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UIView *textContainerView;

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
    [self.backgroundPoster setImageWithURL:self.movie.posterURL];
    self.backgroundPoster.contentMode = UIViewContentModeScaleAspectFit;
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = self.textContainerView.bounds;
    l.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8].CGColor, nil];
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
