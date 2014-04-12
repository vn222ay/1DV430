//
//  Player.m
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-11.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#import "Player.h"
@interface Player ()

//@property (strong, nonatomic) NSMutableArray *balls;
@property (strong, nonatomic) UIColor *color;
@property int balls;


@end

@implementation Player

-(Player *)initWithColor:(UIColor *)color balls:(int)balls {
    if (self = [super init]) {
        self.color = color;
        self.balls = balls;
    }
    return self;
}

@end
