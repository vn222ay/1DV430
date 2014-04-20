//
//  MyScene.m
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-11.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#import "MyScene.h"
#import "Player.h"
#import "Map.h"
#import "GameSettings.h"


@interface MyScene ()

@property (strong, nonatomic) NSMutableArray *players;
@property (strong, nonatomic) Map<MapProtocol> *map;
@property (strong, nonatomic) NSDate *lastTouchTime;
@property CFTimeInterval toNextCheck;
@property (strong, nonatomic) NSDictionary *pointAreas;
@property int nextPlayerId;
@property BOOL newBallAway;
@property BOOL gameOverNow;
@property (strong, nonatomic) GameSettings *gameSettings;

@end


@implementation MyScene



-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */

    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    self.lastTouchTime = [NSDate date];
    self.gameSettings = [self.userData objectForKey:@"gameSettings"];
    
    if (self.gameSettings.useWalls) {
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
    }
    
    //NSLog(@"%@", [self.userData objectForKey:@"gameSettings"]);
    
    //self.physicsBody.friction = 0.2;
    //self.physicsBody.linearDamping = 0;
    //self.physicsBody.restitution = 0.1;
    //self.physicsWorld.contactDelegate = self;
    

    
    self.players = [[NSMutableArray alloc] init];
    self.map = [[Map alloc] initWithSize:self.view.bounds.size];
    [self addChild:self.map];
    self.pointAreas = [self.map getPointAreas];
    self.gameOverNow = NO;
    self.toNextCheck = 0;
    
    self.nextPlayerId = 0;
    self.newBallAway = NO;
    
    for (int i = 0; i < self.gameSettings.numberOfPlayers; i++) {
        if (self.gameSettings.numberOfPlayers == 2 && i == 1) {
            //Specialare för att ge spelare nummer 2 position diagonalt mot 1'an
            i = 2;
        }
        Player *player = [[Player alloc] initWithColor:[self.map colorForPlayerNr:i] balls:(int)self.gameSettings.balls];
        player.playerPositions = [[PlayerPositions alloc] initWithPlayerNr:i onViewSize:self.view.bounds.size];
//        player.playerArea = [self.map areaForPlayerNr:i];
   //     player.ballStartPoint = [self.map startPointForPlayerNr:i];
        [self.players addObject:player];
        if (!self.gameSettings.oneByOne) {
            [self giveBallToPlayer:player];
        }
    }
    if (self.gameSettings.oneByOne) {
        [self giveNextPlayerBall];
    }
    [self initPlayerScores];

}

-(void)initPlayerScores {
    for (Player *player in self.players) {
        SKLabelNode *scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"Optima-ExtraBlack"];
        scoreLabel.name = @"scoreLabel";
        scoreLabel.text = [NSString stringWithFormat:@"%d", player.points];
        scoreLabel.position = player.playerPositions.scoreLabelPoint;
        scoreLabel.fontColor = [SKColor colorWithRed:0.3 green:0.3 blue:0.7 alpha:0.8];
        scoreLabel.fontSize = 40;
        scoreLabel.zPosition = 5;
        //self.infoLabel.hidden = NO;
        scoreLabel.zRotation = player.playerPositions.scoreLabelAngle;
        player.scoreLabel = scoreLabel;
        [self addChild:scoreLabel];
    }
}

-(void)giveBallToPlayer:(Player *)player {
    if ([player hasBalls]) {

        SKShapeNode *ball = [self.map createBallWithPosition:player.playerPositions.ballStartPoint];
        [player activateBall:ball];
        [self addChild:player.activeBall];
    }
    else {
        //Inga bollar kvar
    }
}


-(void)checkScore {
    for (Player *player in self.players) {
        NSLog(@"%i", player.points);
    }
}
/*
-(BOOL)giveBallDirectly {
    return !self.gameSettings.oneByOne;
}
 */

-(void)performBallActionsForPlayer:(Player *)player withVelocity:(CGPoint)velocity andDelta:(CFTimeInterval)delta {
    [self applyForce:velocity affectedNode:player.activeBall withDelta:delta];
    [player deactivateBall];
    player.holdingBall = NO;
    if (!self.gameSettings.oneByOne) {
        [self giveBallToPlayer:player];
    }
    else if (!self.gameSettings.waitUntilStill) {
        [self giveNextPlayerBall];
    }
    self.newBallAway = YES;
    if ([self noMoreBalls]) {
        self.gameOverNow = YES;
    }
}

-(BOOL)noMoreBalls {
    for (Player *player in self.players) {
        if ([player hasBalls] || [player hasActiveBall]) {
            return NO;
        }
    }
                NSLog(@"YES!");
    return YES;
}

-(void)calculatePoints {
    for (Player *player in self.players) {
        int tempPoints = 0;
        for (UIBezierPath *path in self.pointAreas) {
            for (SKNode *ball in player.usedBalls) {
                if ([path containsPoint:ball.position]) {
                    tempPoints += [self.pointAreas[path] intValue];
                }
            }
        }
        int oldScore = player.points;
        player.points = tempPoints;
        player.scoreLabel.text = [NSString stringWithFormat:@"%d", tempPoints];
        if (oldScore != tempPoints) {
            SKAction *sizeUp = [SKAction scaleTo:1.5 duration:0.3];
            SKAction *sizeDown = [SKAction scaleTo:1 duration:0.3];
            
            SKAction *statusUpdate = [SKAction sequence:@[sizeUp, sizeDown]];
            [player.scoreLabel runAction:statusUpdate withKey:@"newScore"];
        }

    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        
        CGPoint touchLocation = [touch locationInView:self.view];
        touchLocation = [self convertPointFromView:touchLocation];
        
        for (Player *player in self.players) {
            
            if ([player isInArea:touchLocation] && [player hasActiveBall] && ![self.map shouldRelease:touchLocation]) {
                
                player.activeBall.position = touchLocation;
                player.activeBall.physicsBody.dynamic = YES;
                player.activeBall.physicsBody.velocity = CGVectorMake(0, 0);
                [player.activeBall removeAllActions];
                player.holdingBall = YES;
            }
            
        }
    }
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        
        CGPoint touchLocation = [touch locationInView:self.view];
        touchLocation = [self convertPointFromView:touchLocation];
        CGPoint oldLocation = [touch previousLocationInView:self.view];
        oldLocation = [self convertPointFromView:oldLocation];
        
        for (Player *player in self.players) {
            
            if ([player isInArea:touchLocation] && [player hasActiveBall] && player.holdingBall) {
                [player updateDelta];
                
                player.activeBall.position = touchLocation;
                if ([self.map shouldRelease:touchLocation]) { //Fix för temporära FPS-drop (dock ej under 30 FPS)
                    CFTimeInterval delta = player.delta;
                    CGPoint oldPosition = player.oldPosition;
                
                    if (delta < 0.01f || delta > 0.03f) { //FPS-problem, ska funka på temp. 30 FPS
                        delta = player.delta + player.oldDelta;
                        if (delta < 0.014) {
                            NSLog(@"[TouchesMoved] Big problem!");
                            continue;
                        }
                        oldPosition = player.oldOldPosition;
                        NSLog(@"[TouchesMoved] low FPS detected (%f %f)", player.delta, player.oldDelta);
                    }

                    CGPoint velocity = [self calculateVelocity:delta oldPoint:oldPosition newPoint:touchLocation];
                    [self performBallActionsForPlayer:player withVelocity:velocity andDelta:delta];
                    
                }
                [player rotatePositions:touchLocation];
            }
        }
    }
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        
        CGPoint touchLocation = [touch locationInView:self.view];
        touchLocation = [self convertPointFromView:touchLocation];

        for (Player *player in self.players) {
            if ([player isInArea:touchLocation] && [player hasActiveBall] && player.holdingBall && ![self.map shouldRelease:touchLocation]) {
                NSLog(@"Go back!");
                SKAction *returnAction = [SKAction moveTo:player.playerPositions.ballStartPoint duration:0.5];
                returnAction.timingMode = SKActionTimingEaseInEaseOut;
                [player.activeBall removeAllActions];
                [player.activeBall runAction:returnAction withKey:@"return"];
                /*
                [player updateDelta];
                CFTimeInterval delta = player.delta;
                CGPoint oldPosition = player.oldPosition;
                if (player.delta < 0.01f || player.delta > 0.03f) { //Fix för temporära FPS-drop (dock ej under 30 FPS)
                    delta = player.delta + player.oldDelta;
                    if (delta < 0.014) {
                        NSLog(@"[TouchesEnded] Big problem!");
                        continue;
                    }
                    oldPosition = player.oldOldPosition;
                    NSLog(@"[TouchesEnded] low FPS detected (%f %f)", player.delta, player.oldDelta);
                }
                player.activeBall.position = touchLocation;
                //[player updateDelta]; //TODO: Kanske inte todo, men simulatorn uppdaterar väldigt oregelbundet => problem i simulatorn. Funkar perfekt på paddan
                CGPoint velocity = [self calculateVelocity:delta oldPoint:oldPosition newPoint:touchLocation];
                    
                [self performBallActionsForPlayer:player withVelocity:velocity andDelta:delta];
                NSLog(@"%f", player.delta);
                 */
            }
        }
    }
}

-(CGPoint)calculateVelocity:(CFTimeInterval)delta oldPoint:(CGPoint)oldPoint newPoint:(CGPoint)newPoint {
    newPoint = [self convertPointFromView:newPoint];
    oldPoint = [self convertPointFromView:oldPoint];
    double dx = (newPoint.x-oldPoint.x)/delta;
    double dy = (newPoint.y-oldPoint.y)/delta;
    return CGPointMake(dx, dy);
}


- (void)applyForce:(CGPoint)velocity affectedNode:(SKNode *)node withDelta:(CFTimeInterval)delta {
    [node.physicsBody applyForce:CGVectorMake(velocity.x/delta * node.physicsBody.mass, -velocity.y/delta * node.physicsBody.mass)];
}

-(BOOL)allBallsStill {
    for (SKNode *node in self.children) {
        if ([node.name isEqualToString:@"ball"]) {
            if (!CGRectContainsPoint(self.view.bounds, node.position)) {
                [node removeFromParent];
                //NSLog(@"---REMOVE!");
            }
            else if (fabsf(node.physicsBody.velocity.dx) > 0 || fabsf(node.physicsBody.velocity.dy) > 0) {
                if (fabsf(node.physicsBody.velocity.dx) < 1.0f && fabsf(node.physicsBody.velocity.dy) < 1.0f) {
                    node.physicsBody.velocity = CGVectorMake(0, 0);
                }
                //NSLog(@"%f - %f", fabsf(node.physicsBody.velocity.dx), fabsf(node.physicsBody.velocity.dy));
                return NO;
            }
        }
    }
    return YES;
}

-(void)giveNextPlayerBall {
    if (self.nextPlayerId >= [self.players count]) {
        self.nextPlayerId = 0;
    }
    if ([[self.players objectAtIndex:self.nextPlayerId] hasBalls]) {
    
        [self giveBallToPlayer:[self.players objectAtIndex:self.nextPlayerId]];
    
        self.nextPlayerId++;
    }
    /*
    else {
        self.gameOverNow = YES;
    }
     */
}

-(void)gameOver {
    int bestPlayerIndex = 0;
    int maxPoints = 0;
    for (int i = 0; i < [self.players count]; i++) {
        Player *p = [self.players objectAtIndex:i];
        if (p.points > maxPoints) {
            bestPlayerIndex = i;
            maxPoints = p.points;
        }
    }
    
    SKLabelNode *gameOverLabel = [[SKLabelNode alloc] initWithFontNamed:@"Optima-ExtraBlack"];
    gameOverLabel.name = @"scoreLabel";
    gameOverLabel.text = [NSString stringWithFormat:@"Game Over! Player %d won!", bestPlayerIndex + 1];
    gameOverLabel.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    gameOverLabel.fontColor = [SKColor colorWithRed:0.3 green:0.3 blue:0.7 alpha:0.8];
    gameOverLabel.fontSize = 80;
    gameOverLabel.zPosition = 8;
    //self.infoLabel.hidden = NO;
    [self addChild:gameOverLabel];

}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (self.toNextCheck < currentTime) {
        
        if (self.gameSettings.oneByOne && self.gameSettings.waitUntilStill && self.newBallAway) {
            if ([self allBallsStill]) {
                NSLog(@"UTFODRING AV BOLLAR!");
                self.newBallAway = NO;
                [self giveNextPlayerBall];
            }
            
        }
        [self calculatePoints];
        self.toNextCheck = currentTime + 0.5;
        
        if (self.gameOverNow) {
            //NSLog(@"Soon!");
            if ([self allBallsStill]) {
                [self gameOver];
                self.toNextCheck = currentTime + 1000;
            }
        }
        

    }
}

@end
    