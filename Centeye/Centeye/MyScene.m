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
@property (strong, nonatomic) Map *map;
@property CFTimeInterval lastTime;
@property CFTimeInterval delta;

@end


@implementation MyScene



-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */

    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [[self view] addGestureRecognizer:gestureRecognizer];
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsBody.friction = 0;
    self.physicsBody.linearDamping = 0;
    self.physicsWorld.contactDelegate = self;

    
    self.players = [[NSMutableArray alloc] init];
    self.map = [[Map alloc] initWithSize:self.view.bounds.size];
    [self addChild:self.map];
    
    Player *player1 = [[Player alloc] init];
    player1.playerArea = CGRectMake(0, 0, 300, 300);
    player1.ballStartPoint = CGPointMake(55, 55);
    [self.players addObject:player1];
    [self giveBallToPlayer:player1];
    
    Player *player2 = [[Player alloc] init];
    player2.playerArea = CGRectMake(0, self.view.bounds.size.height-300, 300, self.view.bounds.size.height);
    player2.ballStartPoint = CGPointMake(55, self.view.bounds.size.height-55);
    [self.players addObject:player2];
    [self giveBallToPlayer:player2];
}

-(void)giveBallToPlayer:(Player *)player {
    if (player.hasBalls) {
        [player consumeBall];
        SKShapeNode *ball = [self createBallWithPosition:player.ballStartPoint];
        [player activateBall:ball];
        [self addChild:player.activeBall];
    }
    else {
        NSLog(@"Inga bollar kvar");
    }
}


-(SKShapeNode *)createBallWithPosition:(CGPoint)startPoint {
    SKShapeNode *newBall = [[SKShapeNode alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, 0, 0, 30, 0.0, (2 * M_PI), NO);
    newBall.path = path;
    newBall.fillColor = [UIColor grayColor];
    newBall.name = @"ball";
    newBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:30];
    newBall.physicsBody.dynamic = YES;
    newBall.physicsBody.affectedByGravity = NO;
    newBall.position = startPoint;
    
    newBall.physicsBody.linearDamping = 0.6;
    newBall.physicsBody.restitution = 0.6;
    newBall.physicsBody.friction = 0.2;
    
    return newBall;
}

/* --- Touch Events Begin --- */

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [self convertPointFromView:touchLocation];
    //SKShapeNode *node = (SKShapeNode *)[self nodeAtPoint:touchLocation];
    
    //TODO!!! Fixa så att alla bollas släpps när de dras utanför ens område. Kanske kolla alla aktiva bollar om de är innanför, i så fall gör som vanligt, annars om utanför, släpp alla dessa. Ska bara göras när touchevent är Changed, inte Ended (?)
    for (Player *player in self.players) {
        if ([player isInArea:touchLocation]) {
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            if ([player isInArea:touchLocation] && [player hasActiveBall]) {
                player.activeBall.position = touchLocation;
            }
            else if (![player isInArea:touchLocation] && [player hasActiveBall]) {
                CGPoint velocity = [recognizer velocityInView:recognizer.view];
                [self performBallActionsForPlayer:player withVelocity:velocity];
            }
        }
        
        else if (recognizer.state == UIGestureRecognizerStateEnded && [player hasActiveBall]) {

            
            //TODO: Outside border-issue?
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            [self performBallActionsForPlayer:player withVelocity:velocity];

        }
        }
    }
}

-(void)performBallActionsForPlayer:(Player *)player withVelocity:(CGPoint)velocity {
    [self applyForce:velocity affectedNode:player.activeBall];
    [player deactivateBall];
    /*
    if ([player hasBalls]) {
        [player activateBall:[self createBall]];
        [self addChild:player.activeBall];
    }
     */
}

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:self.view];
        touchLocation = [self convertPointFromView:touchLocation];
        
        SKShapeNode *node = (SKShapeNode *)[self nodeAtPoint:touchLocation];
        
        if ([node.name isEqualToString: @"ball"]) {
            [self.touchedBalls addObject:node];
            NSLog(@"WE GOT A HIT!");
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        
        CGPoint touchLocation = [touch locationInNode:self];
        touchLocation = [self convertPointFromView:touchLocation];
        
        if (CGPathContainsPoint(self.map.restrictedArea, nil, touchLocation, false)) {
            NSLog(@"IN!");
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:self.view];
        touchLocation = [self convertPointFromView:touchLocation];
        
        SKShapeNode *node = (SKShapeNode *)[self nodeAtPoint:touchLocation];
        
        if ([node.name isEqualToString: @"ball"]) {
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            [self applyForce:velocity affectedNode:node];
            NSLog(@"WE LOST ONE!");
        }
    }
}
 --- Touch Events End --- */

- (void)applyForce:(CGPoint)velocity affectedNode:(SKNode *)node {
    [node.physicsBody applyForce:CGVectorMake(velocity.x/self.delta * node.physicsBody.mass, -velocity.y/self.delta * node.physicsBody.mass)];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    self.delta = currentTime - self.lastTime;
    self.lastTime = currentTime;
    
}

@end
    