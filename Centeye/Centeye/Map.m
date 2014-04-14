//
//  Map.m
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-12.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#import "Map.h"

@interface Map ()

@property CGSize viewSize;
@property (strong, nonatomic) NSMutableArray *playCorner;

@end

@implementation Map
@synthesize restrictedArea;

-(SKNode *)initWithSize:(CGSize)rectSize {
    if (self = [super init]) {
        self.viewSize = rectSize;
        NSLog(@"Init Player Area");
        self.playCorner = [[NSMutableArray alloc] init];
        
        SKShapeNode *playerArea = [SKShapeNode node];
        playerArea.path = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, self.viewSize.width/2, self.viewSize.height/2)].CGPath;
        playerArea.fillColor = [UIColor greenColor];
        [self.playCorner addObject:playerArea];
        
        playerArea = [SKShapeNode node];
        playerArea.path = [UIBezierPath bezierPathWithRect: CGRectMake(self.viewSize.width/2, 0, self.viewSize.width, self.viewSize.height/2)].CGPath;
        playerArea.fillColor = [UIColor yellowColor];
        [self.playCorner addObject:playerArea];
        
        playerArea = [SKShapeNode node];
        playerArea.path = [UIBezierPath bezierPathWithRect: CGRectMake(0, self.viewSize.height/2, self.viewSize.width/2, self.viewSize.height)].CGPath;
        playerArea.fillColor = [UIColor blueColor];
        [self.playCorner addObject:playerArea];
        
        playerArea = [SKShapeNode node];
        playerArea.path = [UIBezierPath bezierPathWithRect: CGRectMake(self.viewSize.width/2, self.viewSize.height/2, self.viewSize.width, self.viewSize.height)].CGPath;
        playerArea.fillColor = [UIColor orangeColor];
        [self.playCorner addObject:playerArea];
        /*
        for (SKShapeNode *shape in self.playCorner) {
            NSLog(@"s");
            [self addChild:shape];
        }
        */

        //Outer Circle
        SKShapeNode *outerCircle = [SKShapeNode node];
        outerCircle = [SKShapeNode node];
        CGPathRef outerCirclePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.viewSize.width, self.viewSize.height)].CGPath;
        outerCircle.path = outerCirclePath;
        outerCircle.fillColor = [UIColor whiteColor];
        self.restrictedArea = outerCircle.path;
        [self addChild:outerCircle];
        /*
        //Middle Circle
        SKShapeNode *middleCircle = [SKShapeNode node];
        middleCircle = [SKShapeNode node];
        middleCircle.path = [UIBezierPath bezierPathWithOvalInRect:[self circleInMiddle:200]].CGPath;
        middleCircle.fillColor = [UIColor grayColor];
        [self addChild:middleCircle];
        
        //Inner Circle
        SKShapeNode *innerCircle = [SKShapeNode node];
        innerCircle = [SKShapeNode node];
        innerCircle.path = [UIBezierPath bezierPathWithOvalInRect:[self circleInMiddle:50]].CGPath;
        innerCircle.fillColor = [UIColor blackColor];
        [self addChild:innerCircle];
        */
  
    }

    return self;
}

-(CGRect)circleInMiddle:(int)radius {
    return CGRectMake(self.viewSize.width/2-radius, self.viewSize.height/2-radius, radius*2, radius*2);
}


@end
