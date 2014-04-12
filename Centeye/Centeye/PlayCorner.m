//
//  PlayCorner.m
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-11.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#import "PlayCorner.h"

@implementation PlayCorner

-(PlayCorner *)initWithArea:(CGRect)area color:(UIColor *)color {
    if (self = [super init]) {
        SKShapeNode *playerArea = [SKShapeNode node];
        playerArea = [SKShapeNode node];
        playerArea.path = [UIBezierPath bezierPathWithRect: area].CGPath;
        playerArea.fillColor = color;
    }
    return self;
}

@end
