//
//  Movie.m
//  RottenTomatoes
//
//  Created by Nathan Speller on 3/13/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (Movie *)init{
    self.abridgedCast = [[NSMutableArray alloc] init];
    return self;
}

- (void)addCastMember:(NSString *)castMember{
    [self.abridgedCast addObject:castMember];
}

- (NSString *)cast{
    return [self.abridgedCast componentsJoinedByString:@", "];
}

@end
