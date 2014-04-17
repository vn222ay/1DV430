//
//  MapProtocol.h
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-15.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

//Dessa funktioner måste implementeras för kartor

#import <Foundation/Foundation.h>

@protocol MapProtocol <NSObject>
-(NSDictionary *)getPointAreas;
-(int)getBallSizeForMap;
-(BOOL)shouldRelease:(CGPoint)position;
-(SKShapeNode *)createBallWithPosition:(CGPoint)startPoint;
-(CGRect)areaForPlayerNr:(int)i;
-(CGPoint)startPointForPlayerNr:(int)i;
-(UIColor *)colorForPlayerNr:(int)i;
@end
