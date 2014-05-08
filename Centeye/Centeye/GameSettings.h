//
//  GameSettings.h
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-19.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSettings : NSObject

@property NSInteger numberOfPlayers;
@property BOOL oneByOne;
@property BOOL waitUntilStill;
@property BOOL useWalls;
@property BOOL useSizeUp;
@property NSInteger balls;

-(void)resetDefaults;
-(void)loadUserDefaults; // <-- Private kanske? köra i init-metoden
-(void)saveUserDefaults;


@end
