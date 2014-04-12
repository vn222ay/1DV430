//
//  Map.h
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-12.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Map : SKNode
@property CGPathRef restrictedArea;
-(SKNode *)initWithSize:(CGSize)rectSize;

@end
