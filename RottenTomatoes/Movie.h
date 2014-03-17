//
//  Movie.h
//  RottenTomatoes
//
//  Created by Nathan Speller on 3/13/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSString *runtime;
@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic, strong) NSMutableArray *abridgedCast;
@property (nonatomic, strong) NSString *mpaaRating;
@property (nonatomic, assign) int audienceScore;
@property (nonatomic, assign) int criticsScore;

- (Movie *)initWithDictionary:(NSDictionary *)mDictionary;
- (NSString *)cast;

@end
