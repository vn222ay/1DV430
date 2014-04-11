//
//  MyScene.m
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-11.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#import "MyScene.h"

@interface MyScene ()

@property (strong, nonatomic) SKShapeNode *ballBorder;
@property (strong, nonatomic) NSMutableArray *ballsTouched;

@end


@implementation MyScene



-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        

    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    //UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [self initPlayerArea];
    //[self initPlayfield];

}

-(void)initPlayerArea {
    //Player 1
    SKShapeNode *playerArea = [SKShapeNode node];
    playerArea = [SKShapeNode node];
    playerArea.path = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, self.view.bounds.size.width/2, self.view.bounds.size.height/2)].CGPath;
    playerArea.fillColor = [UIColor greenColor];
    [self addChild:playerArea];
}

-(void)initPlayfield {
    
    //Add outer circle
    SKShapeNode *outerCircle = [SKShapeNode node];
    outerCircle = [SKShapeNode node];
    outerCircle.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)].CGPath;
    outerCircle.fillColor = [UIColor whiteColor];
    self.ballBorder = outerCircle;
    [self addChild:outerCircle];
    
    SKShapeNode *middleCircle = [SKShapeNode node];
    middleCircle = [SKShapeNode node];
    middleCircle.path = [UIBezierPath bezierPathWithOvalInRect:[self circleInMiddle:200]].CGPath;
    middleCircle.fillColor = [UIColor grayColor];
    [self addChild:middleCircle];
    
    SKShapeNode *innerCircle = [SKShapeNode node];
    innerCircle = [SKShapeNode node];
    innerCircle.path = [UIBezierPath bezierPathWithOvalInRect:[self circleInMiddle:50]].CGPath;
    innerCircle.fillColor = [UIColor blackColor];
    [self addChild:innerCircle];
}

-(CGRect)circleInMiddle:(int)radius {
    return CGRectMake(self.view.bounds.size.width/2-radius, self.view.bounds.size.height/2-radius, radius*2, radius*2);
}
/*
- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    NSLog(@"H");
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [self convertPointFromView:touchLocation];
    
    if (CGPathContainsPoint(self.ballBorder.path, nil, touchLocation, false)) {
        NSLog(@"We got something");
        return;
    }
}
 */

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        
        
        CGPoint touchLocation = [touch locationInNode:self];
        touchLocation = [self convertPointFromView:touchLocation];
        
        if (CGPathContainsPoint(self.ballBorder.path, nil, touchLocation, false)) {
            NSLog(@"IN!");
            return;
        }
        /*
         if ([self.ballBorder ])
         
         SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
         
         sprite.position = location;
         
         SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
         
         [sprite runAction:[SKAction repeatActionForever:action]];
         
         [self addChild:sprite];
         */
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        //Grab the stones here, let touchesMoved handle all other controlls (border, release etc)
    }
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
    