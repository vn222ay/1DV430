//
//  Map.m
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-12.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#define kBallRadius 30
#define kMiddlePoints 1
#define kInnerPoints 4

#import "Map.h"

@interface Map ()

@property CGSize viewSize;
@property (strong, nonatomic) NSMutableArray *playCorner;
@property (strong, nonatomic) NSMutableDictionary *pointAreas;

@end

@implementation Map
@synthesize restrictedArea;

-(SKNode *)initWithSize:(CGSize)rectSize {
    if (self = [super init]) {
        self.viewSize = rectSize;
        self.pointAreas = [[NSMutableDictionary alloc] init];
        
        int middleCircleRadius = self.viewSize.height/4;
        int innerCircleRadius = self.viewSize.height/10;
        
        [self.pointAreas setObject:[NSNumber numberWithInt:kMiddlePoints] forKey:[UIBezierPath bezierPathWithOvalInRect:[self circleInMiddle:middleCircleRadius+kBallRadius]]];
        [self.pointAreas setObject:[NSNumber numberWithInt:kInnerPoints] forKey:[UIBezierPath bezierPathWithOvalInRect:[self circleInMiddle:innerCircleRadius+kBallRadius]]];
        
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
        
        for (SKShapeNode *shape in self.playCorner) {
            [self addChild:shape];
        }
        

        //Outer Circle
        SKShapeNode *outerCircle = [SKShapeNode node];
        outerCircle = [SKShapeNode node];
        CGPathRef outerCirclePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.viewSize.width, self.viewSize.height)].CGPath;
        outerCircle.path = outerCirclePath;
        outerCircle.fillColor = [UIColor whiteColor];
        self.restrictedArea = outerCircle.path;
        
        [self addChild:outerCircle];

        //Middle Circle
        SKShapeNode *middleCircle = [SKShapeNode node];
        middleCircle = [SKShapeNode node];
        middleCircle.path = [UIBezierPath bezierPathWithOvalInRect:[self circleInMiddle:middleCircleRadius]].CGPath;
        middleCircle.fillColor = [UIColor grayColor];
        
        //[self.pointAreas setObject:(id)middleCircle.path forKey:[NSNumber numberWithInt:2]];
        
        [self addChild:middleCircle];
        
        //Inner Circle
        SKShapeNode *innerCircle = [SKShapeNode node];
        innerCircle = [SKShapeNode node];
        innerCircle.path = [UIBezierPath bezierPathWithOvalInRect:[self circleInMiddle:innerCircleRadius]].CGPath;
        innerCircle.fillColor = [UIColor blackColor];
        
        //[self.pointAreas setObject:(id)innerCircle.path forKey:[NSNumber numberWithInt:5]];
        
        [self addChild:innerCircle];
   
        
        
        //Test
        
        //CGPathRef tapTargetPath = CGPathCreateCopyByStrokingPath(middleCircle.path, NULL, 30, kCGLineCapRound, kCGLineJoinRound, 30);
        //SKShapeNode *test = [SKShapeNode node];
        //test = [SKShapeNode node];
        //test.path = tapTargetPath;
        //test.fillColor = [UIColor greenColor];
        
        //[self.pointAreas setObject:[NSNumber numberWithInt:5] forKey:[UIBezierPath bezierPathWithOvalInRect:[self circleInMiddle:200]]];
        
        //[self addChild:test];
        //[self addChild:innerCircle];
    }

    return self;
}

-(int)getBallSizeForMap {
    return kBallRadius;
}

-(NSDictionary *)getPointAreas {
    return self.pointAreas;
}

-(BOOL)shouldRelease:(CGPoint)position {
    return CGPathContainsPoint(self.restrictedArea, nil, position, NO);
}

-(CGRect)circleInMiddle:(int)radius {
    return CGRectMake(self.viewSize.width/2-radius, self.viewSize.height/2-radius, radius*2, radius*2);
}


@end
