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

@end

@implementation Player

-(Player *)initWithColor:(UIColor *)color balls:(int)balls {
    if (self = [super init]) {
        self.color = color;
        self.balls = balls;
        self.holdingBall = NO;
        self.points = 0;
        self.usedBalls = [[NSMutableArray alloc] init];
    }
    return self;
}


-(id)init {
    if (self = [super init]) {
        self.balls = 5;
    }
    return self;
}
/*
-(CFTimeInterval)getDelta {
    return CFAbsoluteTimeGetCurrent() - self.lastTime;
}
 */

-(BOOL)hasBalls {
    if (self.balls > 0) {
        return true;
    }
    else {
        return false;
    }
}
/*
-(void)consumeBall {
    self.balls--;
}
 */

-(void)updateDelta {
    self.oldDelta = self.delta;
    CFTimeInterval currentTime = CFAbsoluteTimeGetCurrent();
    self.delta = currentTime - self.lastTime;
    self.lastTime = currentTime;
}

-(void)activateBall:(SKShapeNode *)newBall {
    if (![self hasBalls]) {
        //TODO: Kasta undantag
        NSLog(@"ERROR! -bollar");
    }
    self.balls--;
    //newBall.fillColor = self.color; //<-- TODO
    self.activeBall = newBall;
}

-(void)deactivateBall {
    [self.usedBalls addObject:self.activeBall];
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

-(void)resetPlayerWithBalls:(int)balls {
    self.balls = balls;
    self.holdingBall = NO;
    self.points = 0;
    self.usedBalls = [[NSMutableArray alloc] init];
    
}

-(void)rotatePositions:(CGPoint)newPosition {
    self.oldOldPosition = self.oldPosition;
    self.oldPosition = newPosition;
}

-(BOOL)isInArea:(CGPoint)point {
    return CGRectContainsPoint(self.playerPositions.playerArea, point);
}

@end
