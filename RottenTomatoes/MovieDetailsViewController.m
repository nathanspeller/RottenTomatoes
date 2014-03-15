//
//  MovieDetailsViewController.m
//  RottenTomatoes
//
//  Created by Nathan Speller on 3/15/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "MovieDetailsViewController.h"

@interface MovieDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
