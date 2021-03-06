//
//  Map.h
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-12.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MapProtocol.h"

@interface Map : SKNode<MapProtocol>

@property UIBezierPath *restrictedArea;

-(SKNode *)initWithSize:(CGSize)rectSize;
-(BOOL)shouldRelease:(CGPoint)position;
-(int)getBallSizeForMap;
-(SKShapeNode *)createBallWithPosition:(CGPoint)startPoint;
-(CGRect)areaForPlayerNr:(int)i;
-(CGPoint)startPointForPlayerNr:(int)i;
-(UIColor *)colorForPlayerNr:(int)i;

@end
