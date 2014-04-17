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


@interface MyScene ()

@property (strong, nonatomic) NSMutableArray *players;
@property (strong, nonatomic) Map<MapProtocol> *map;
@property (strong, nonatomic) NSDate *lastTouchTime;
@property CFTimeInterval toNextCheck;
@property (strong, nonatomic) NSDictionary *pointAreas;

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
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsBody.friction = 0.2;
    self.physicsBody.linearDamping = 0;
    self.physicsWorld.contactDelegate = self;

    
    self.players = [[NSMutableArray alloc] init];
    self.map = [[Map alloc] initWithSize:self.view.bounds.size];
    [self addChild:self.map];
    self.pointAreas = [self.map getPointAreas];
    
    for (int i = 0; i < 4; i++) {
        Player *player = [[Player alloc] initWithColor:[self.map colorForPlayerNr:i] balls:5];
        player.playerPositions = [[PlayerPositions alloc] initWithPlayerNr:i onViewSize:self.view.bounds.size];
//        player.playerArea = [self.map areaForPlayerNr:i];
   //     player.ballStartPoint = [self.map startPointForPlayerNr:i];
        [self.players addObject:player];
        [self giveBallToPlayer:player];
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

-(BOOL)giveBallDirectly {
    return true; //TODO: Implementera något för antingen Arcade-mode eller en och en
}

-(void)performBallActionsForPlayer:(Player *)player withVelocity:(CGPoint)velocity andDelta:(CFTimeInterval)delta {
    [self applyForce:velocity affectedNode:player.activeBall withDelta:delta];
    [player deactivateBall];
    player.holdingBall = NO;
    if ([self giveBallDirectly]) {
        [self giveBallToPlayer:player];
    }
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
                [player updateDelta]; //TODO: Kanske inte todo, men simulatorn uppdaterar väldigt oregelbundet => problem i simulatorn. Funkar perfekt på paddan
                
                player.activeBall.position = touchLocation;
                if ([self.map shouldRelease:touchLocation] && player.delta > 0.01f) { // && player.delta > 0.01f TODO: Ta bort denna fulfix för att få det att flyta bättre i simulator (måste fps == 60)

                    CGPoint velocity = [self calculateVelocity:player.delta oldPoint:player.oldPosition newPoint:touchLocation];
 
                    [self performBallActionsForPlayer:player withVelocity:velocity andDelta:player.delta];
                }
                player.oldPosition = touchLocation;

            }
        }
    }
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        
        CGPoint touchLocation = [touch locationInView:self.view];
        touchLocation = [self convertPointFromView:touchLocation];

        for (Player *player in self.players) {
            if ([player isInArea:touchLocation] && [player hasActiveBall] && player.holdingBall) {
                
                if (player.delta < 0.01f || player.delta > 0.03f) { //Fulfix för att inte FPSen ska försöka hastigheten på kastet. Under 0.01f är inte rimligt
                    player.delta = 0.0165f;
                    NSLog(@"---- FIXING!");
                }
                player.activeBall.position = touchLocation;
                //[player updateDelta]; //TODO: Kanske inte todo, men simulatorn uppdaterar väldigt oregelbundet => problem i simulatorn. Funkar perfekt på paddan
                CGPoint velocity = [self calculateVelocity:player.delta oldPoint:player.oldPosition newPoint:touchLocation];
                    
                [self performBallActionsForPlayer:player withVelocity:velocity andDelta:player.delta];
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
    return false; //TODO: Implementera!
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (self.toNextCheck < currentTime) {
        /*
        if (![self giveBallDirectly]) {
            if ([self allBallsStill]) {
                //TODO: Give next player a ball
            }
        }
         */
        [self calculatePoints];
        self.toNextCheck = currentTime + 0.3;
    }
}

@end
    