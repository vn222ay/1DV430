//
//  GameSettings.m
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-19.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#import "GameSettings.h"

@implementation GameSettings

-(id)init {
    if (self = [super init]) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfPlayers"] < 2 || YES) { //TODO YES bort!
            [self resetDefaults];
        }
        else {
            [self loadUserDefaults];
        }
        
    }
    return self;
}
-(void)resetDefaults {
    NSLog(@"Resetting defaults");
    self.numberOfPlayers = 4;
    self.oneByOne = NO;
    self.waitUntilStill = NO;
    self.useWalls = NO;
    self.useSizeUp = NO;
    self.balls = 3;
    [self saveUserDefaults];
}

-(void)saveUserDefaults {
    NSLog(@"Saving defaults");
    [[NSUserDefaults standardUserDefaults] setInteger:self.numberOfPlayers forKey:@"numberOfPlayers"];
    [[NSUserDefaults standardUserDefaults] setBool:self.oneByOne forKey:@"oneByOne"];
    [[NSUserDefaults standardUserDefaults] setBool:self.waitUntilStill forKey:@"waitUntilStill"];
    [[NSUserDefaults standardUserDefaults] setBool:self.useWalls forKey:@"useWalls"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.balls forKey:@"balls"];
}

-(void)loadUserDefaults {
    NSLog(@"Loading defaults");
    self.numberOfPlayers = [[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfPlayers"];
    self.oneByOne = [[NSUserDefaults standardUserDefaults] boolForKey:@"oneByOne"];
    self.waitUntilStill = [[NSUserDefaults standardUserDefaults] boolForKey:@"waitUntilStill"];
    self.useWalls = [[NSUserDefaults standardUserDefaults] boolForKey:@"useWalls"];
    self.balls = [[NSUserDefaults standardUserDefaults] integerForKey:@"balls"];
}

@end