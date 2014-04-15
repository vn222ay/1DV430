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
//@property CFTimeInterval lastTime;
//@property CFTimeInterval delta;
@property (strong, nonatomic) NSDate *lastTouchTime;

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
    //UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    //[[self view] addGestureRecognizer:gestureRecognizer];
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsBody.friction = 0.2;
    self.physicsBody.linearDamping = 0;
    self.physicsWorld.contactDelegate = self;

    
    self.players = [[NSMutableArray alloc] init];
    self.map = [[Map alloc] initWithSize:self.view.bounds.size];
    [self addChild:self.map];
    
    Player *player1 = [[Player alloc] initWithColor:[UIColor greenColor] balls:5];
    player1.playerArea = CGRectMake(0, 0, self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    player1.ballStartPoint = CGPointMake(55, 55);
    [self.players addObject:player1];
    [self giveBallToPlayer:player1];
    
    Player *player2 = [[Player alloc] initWithColor:[UIColor blueColor] balls:5];
    player2.playerArea = CGRectMake(0, self.view.bounds.size.height/2, self.view.bounds.size.width/2, self.view.bounds.size.height);
    player2.ballStartPoint = CGPointMake(55, self.view.bounds.size.height-55);
    [self.players addObject:player2];
    [self giveBallToPlayer:player2];
    
    Player *player3 = [[Player alloc] initWithColor:[UIColor yellowColor] balls:5];
    player3.playerArea = CGRectMake(self.view.bounds.size.width/2, 0, self.view.bounds.size.width, self.view.bounds.size.height/2);
    player3.ballStartPoint = CGPointMake(self.view.bounds.size.width-55, 55);
    [self.players addObject:player3];
    [self giveBallToPlayer:player3];
    
    
    Player *player4 = [[Player alloc] initWithColor:[UIColor orangeColor] balls:5];
    player4.playerArea = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height);
    player4.ballStartPoint = CGPointMake(self.view.bounds.size.width-55, self.view.bounds.size.height-55);
    [self.players addObject:player4];
    [self giveBallToPlayer:player4];
}

-(void)giveBallToPlayer:(Player *)player {
    if ([player hasBalls]) {
        //[player consumeBall];
        SKShapeNode *ball = [self createBallWithPosition:player.ballStartPoint];
        [player activateBall:ball];
        [self addChild:player.activeBall];
    }
    else {
        //NSLog(@"Inga bollar kvar");
    }
}


-(SKShapeNode *)createBallWithPosition:(CGPoint)startPoint {
    SKShapeNode *newBall = [[SKShapeNode alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, 0, 0, [self.map getBallSizeForMap], 0.0, (2 * M_PI), NO);
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
/*
- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [self convertPointFromView:touchLocation];
    
    for (Player *player in self.players) {
        if ([player isInArea:touchLocation]) {
            if (recognizer.state == UIGestureRecognizerStateChanged) {
                player.activeBall.position = touchLocation;
                if ([self.map shouldRelease:touchLocation]) {
                    //Fortfarande inom spelarens område men kommt in på förbjuden mark => släpp!
                    //CGPoint velocity = [recognizer velocityInView:recognizer.view];
                    CGPoint velocity = [self calculateVelocity:self.delta oldPoint:player.previousPosition newPoint:player.activeBall.position];
                    [self performBallActionsForPlayer:player withVelocity:velocity];
                }
            }
            //Touch upphört och rörd boll ska släppas (ej inne på förbjuden mark)
            else if (recognizer.state == UIGestureRecognizerStateEnded && [player hasActiveBall]) {
                //TODO: Outside border-issue?
                CGPoint velocity = [recognizer velocityInView:recognizer.view];
                [self performBallActionsForPlayer:player withVelocity:velocity];
            }
        }
 NSLog(@"%f - %f", player.previousPosition.x, player.activeBall.position.x);
        player.previousPosition = player.activeBall.position;
    }
}
*/

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
    //NSLog(@"ENDED!");
    if ([self giveBallDirectly]) {
        [self giveBallToPlayer:player];
    }
    
    //[self giveBallToPlayer:player];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        
        CGPoint touchLocation = [touch locationInView:self.view];
        touchLocation = [self convertPointFromView:touchLocation];
        
        for (Player *player in self.players) {
            
            if ([player isInArea:touchLocation] && [player hasActiveBall] && ![self.map shouldRelease:touchLocation]) {
                
                player.activeBall.position = touchLocation;
                player.holdingBall = YES;
                //NSLog(@"BEGAN!");
                
            }
        }
    }
    [self calculatePoints];
    [self checkScore];
}

-(void)calculatePoints {
    NSDictionary *pointAreas = [self.map getPointAreas];
    for (Player *player in self.players) {
        int tempPoints = 0;
        for (UIBezierPath *path in pointAreas) {
            for (SKNode *ball in player.usedBalls) {
                //if (CGPathContainsPoint(pointAreas[path], nil, ball.position, NO)) {
                if ([path containsPoint:ball.position]) {
                    //NSLog(@"%@ - %@", path, pointAreas[path]);
                    tempPoints += [pointAreas[path] intValue];
                }
            }
        }
        player.points = tempPoints;
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
                
                //NSLog(@"%f", player.delta);
                player.activeBall.position = touchLocation;
                if ([self.map shouldRelease:touchLocation] && player.delta > 0.01f) { // && player.delta > 0.01f TODO: Ta bort denna fulfix för att få det att flyta bättre i simulator (måste fps == 60)

                    CGPoint velocity = [self calculateVelocity:player.delta oldPoint:player.oldPosition newPoint:touchLocation];
 
                    [self performBallActionsForPlayer:player withVelocity:velocity andDelta:player.delta];
                    //NSLog(@"Delta: %f Old X:%f New X:%f", player.delta, player.oldPosition.x, touchLocation.x);
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
                //[player updateDelta]; //TODO: Kanske inte todo, men simulatorn uppdaterar väldigt oregelbundet => problem i simulatorn. Funkar perfekt på paddan
                CGPoint velocity = [self calculateVelocity:player.delta oldPoint:player.oldPosition newPoint:touchLocation];
                    
                [self performBallActionsForPlayer:player withVelocity:velocity andDelta:player.delta];
                //NSLog(@"Delta: %f Old X:%f New X:%f", player.delta, player.oldPosition.x, touchLocation.x);
            }
        }
    }
}

/*
-(void)updateDelta {
    CFTimeInterval currentTime = CFAbsoluteTimeGetCurrent();
    self.delta = currentTime - self.lastTime;
    self.lastTime = currentTime;
}
 */


-(CGPoint)calculateVelocity:(CFTimeInterval)delta oldPoint:(CGPoint)oldPoint newPoint:(CGPoint)newPoint {
    newPoint = [self convertPointFromView:newPoint];
    oldPoint = [self convertPointFromView:oldPoint];
    double dx = (newPoint.x-oldPoint.x)/delta;
    double dy = (newPoint.y-oldPoint.y)/delta;
    //NSLog(@"x %f y %f", dx, dy);
    return CGPointMake(dx, dy);
}
 /*--- Touch Events End --- */

- (void)applyForce:(CGPoint)velocity affectedNode:(SKNode *)node withDelta:(CFTimeInterval)delta {
    [node.physicsBody applyForce:CGVectorMake(velocity.x/delta * node.physicsBody.mass, -velocity.y/delta * node.physicsBody.mass)];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    /*
    currentTime = CFAbsoluteTimeGetCurrent();
    self.delta = currentTime - self.lastTime;
    self.lastTime = currentTime;
     */
}

@end
    