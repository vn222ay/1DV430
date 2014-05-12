//
//  Player.h
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-11.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PlayerPositions.h"

@interface Player : NSObject
@property (strong, nonatomic) SKNode *activeBall;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property int balls;

//@property CGRect playerArea;
//@property CGPoint ballStartPoint;
@property CGPoint oldPosition;
@property CGPoint oldOldPosition;

@property CFTimeInterval delta;
@property CFTimeInterval oldDelta;
@property CFTimeInterval lastTime;
@property BOOL holdingBall;
@property (strong, nonatomic) NSMutableArray *usedBalls;
@property int points;
@property int oldPoints;
@property (strong, nonatomic) PlayerPositions *playerPositions;

-(Player *)initWithColor:(UIColor *)color balls:(int)balls;
-(BOOL)hasActiveBall;
-(BOOL)hasBalls;
-(BOOL)isInArea:(CGPoint)point;
-(void)deactivateBall;
-(void)activateBall:(SKShapeNode *)newBall;
-(void)updateDelta;
-(void)setPoints:(int)newPoints;
-(void)rotatePositions:(CGPoint)oldPosition;
-(void)resetPlayerWithBalls:(int)balls;

@end
