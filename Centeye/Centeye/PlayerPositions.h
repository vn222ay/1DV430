//
//  PlayerPositions.h
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-17.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerPositions : NSObject

@property CGPoint ballStartPoint;
@property CGRect playerArea;
@property CGPoint scoreLabelPoint;
@property CGPoint ballCountPoint;
@property CGPoint sizeUpButtonPoint;
@property double scoreLabelAngle;

-(id)initWithPlayerNr:(int)i onViewSize:(CGSize)viewSize;

@end
