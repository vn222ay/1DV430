//
//  PlayerPositions.m
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-17.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#import "PlayerPositions.h"
#define kBallPositionPadding 80
#define kScorePositionPadding 200

@implementation PlayerPositions
-(id)initWithPlayerNr:(int)i onViewSize:(CGSize)viewSize {
    if (self = [super init]) {
        switch (i) {
            case 0:
                self.ballStartPoint = CGPointMake(kBallPositionPadding, kBallPositionPadding);
                self.playerArea = CGRectMake(0, 0, viewSize.width/2, viewSize.height/2);
                self.scoreLabelPoint = CGPointMake(kScorePositionPadding, kScorePositionPadding);
                self.scoreLabelAngle = 315 / 180.0 * M_PI;
                break;
            case 1:
                self.ballStartPoint = CGPointMake(kBallPositionPadding, viewSize.height-kBallPositionPadding);
                self.playerArea = CGRectMake(0, viewSize.height/2, viewSize.width/2, viewSize.height);
                self.scoreLabelPoint = CGPointMake(kScorePositionPadding, viewSize.height-kScorePositionPadding);
                self.scoreLabelAngle = 225 / 180.0 * M_PI;
                break;
            case 2:
                self.ballStartPoint = CGPointMake(viewSize.width-kBallPositionPadding, viewSize.height-kBallPositionPadding);
                self.playerArea = CGRectMake(viewSize.width/2, viewSize.height/2, viewSize.width, viewSize.height);
                self.scoreLabelPoint = CGPointMake(viewSize.width-kScorePositionPadding, viewSize.height-kScorePositionPadding);
                self.scoreLabelAngle = 135 / 180.0 * M_PI;
                break;
            case 3:
                self.ballStartPoint = CGPointMake(viewSize.width-kBallPositionPadding, kBallPositionPadding);
                self.playerArea = CGRectMake(viewSize.width/2, 0, viewSize.width, viewSize.height/2);
                self.scoreLabelPoint = CGPointMake(viewSize.width-kScorePositionPadding, kScorePositionPadding);
                self.scoreLabelAngle = 45 / 180.0 * M_PI;
                break;
            default:
                break;
        }
        
    }
    return self;
}
@end