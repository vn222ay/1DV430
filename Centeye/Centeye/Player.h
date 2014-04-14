//
//  Player.h
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-11.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player : NSObject
@property (strong, nonatomic) SKShapeNode *activeBall;
@property CGRect playerArea;
@property CGPoint ballStartPoint;

//-(Player *)initWithColor:(UIColor *)color balls:(int)balls;
-(BOOL)hasActiveBall;
-(BOOL)hasBalls;
-(BOOL)isInArea:(CGPoint)point;
-(void)deactivateBall;
-(void)activateBall:(SKShapeNode *)newBall;
-(void)consumeBall;


@end
