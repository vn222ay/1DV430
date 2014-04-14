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
/*
-(Player *)initWithColor:(UIColor *)color balls:(int)balls {
    if (self = [super init]) {
        self.color = color;
        self.balls = balls;
    }
    return self;
}
 */

-(id)init {
    if (self = [super init]) {
        self.balls = 5;
    }
    return self;
}

-(BOOL)hasBalls {
    if (self.balls > 0) {
        return true;
    }
    else {
        return false;
    }
}

-(void)consumeBall {
    self.balls--;
}

-(void)activateBall:(SKShapeNode *)newBall {
    if (![self hasBalls]) {
        //TODO: Kasta undantag
        NSLog(@"ERROR! -bollar");
    }
    self.balls--;
    self.activeBall = newBall;
}

-(void)deactivateBall {
    self.activeBall = nil;
}

-(BOOL)hasActiveBall {
    if (self.activeBall) {
        return true;
    }
    else {
        return false;
    }
}



-(BOOL)isInArea:(CGPoint)point {
    return CGRectContainsPoint(self.playerArea, point);
}

@end
