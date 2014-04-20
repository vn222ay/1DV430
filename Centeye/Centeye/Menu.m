//
//  Menu.m
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-18.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#import "Menu.h"
#import "MyScene.h"
#import "GameSettings.h"

#define kDurationForTransition 0.3
#define kPadding 50


@interface Menu ()
@property (strong, nonatomic) UITapGestureRecognizer *gestureRecognizer;
@property (strong, nonatomic) GameSettings *gameSettings;
@end

@implementation Menu


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [[self view] addGestureRecognizer:self.gestureRecognizer];
    
    self.gameSettings = [[GameSettings alloc] init];
    
    
    [self showMainMenu];
}

-(void)showMainMenu {
    [self removeAllChildren];
    
    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"playButton"];
    playButton.name = @"playButton";
    playButton.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height-playButton.size.height/2-kPadding);
    //playButton.color = [SKColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    playButton.alpha = 0.0f;
    [self addChild:playButton];
    
    SKSpriteNode *optionsButton = [SKSpriteNode spriteNodeWithImageNamed:@"optionsButton"];
    optionsButton.name = @"optionsButton";
    optionsButton.position = CGPointMake(self.view.bounds.size.width/4, optionsButton.size.height/2+kPadding);
    //optionsButton.color = [SKColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    optionsButton.alpha = 0.0f;
    [self addChild:optionsButton];
    
    SKSpriteNode *aboutButton = [SKSpriteNode spriteNodeWithImageNamed:@"aboutButton"];
    aboutButton.name = @"aboutButton";
    aboutButton.position = CGPointMake(self.view.bounds.size.width*3/4, aboutButton.size.height/2+kPadding);
    //aboutButton.color = [SKColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    aboutButton.alpha = 0.0f;
    [self addChild:aboutButton];
    
    [self fadeInAll];
}

-(void)fadeInAll {
    SKAction *fadeIn = [SKAction fadeInWithDuration:kDurationForTransition];
    for (SKNode *node in self.children) {
        [node runAction:fadeIn];
    }
}

-(void)showPlayMenu {
    [self removeAllChildren];
    
    SKLabelNode *players2 = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue"];
    players2.name = @"2players";
    players2.text = [NSString stringWithFormat:@"2 Players"];
    players2.position = CGPointMake(self.view.bounds.size.width/4, self.view.bounds.size.height/4*3);
    players2.fontColor = [SKColor colorWithRed:0.3 green:0.3 blue:0.7 alpha:0.8];
    players2.fontSize = 50;
    players2.alpha = 0.0f;

    SKLabelNode *players3 = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue"];
    players3.name = @"3players";
    players3.text = [NSString stringWithFormat:@"3 Players"];
    players3.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4*3);
    players3.fontColor = [SKColor colorWithRed:0.3 green:0.3 blue:0.7 alpha:0.8];
    players3.fontSize = 50;
    players3.alpha = 0.0f;
    
    SKLabelNode *players4 = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue"];
    players4.name = @"4players";
    players4.text = [NSString stringWithFormat:@"4 Players"];
    players4.position = CGPointMake(self.view.bounds.size.width/4*3, self.view.bounds.size.height/4*3);
    players4.fontColor = [SKColor colorWithRed:0.3 green:0.3 blue:0.7 alpha:0.8];
    players4.fontSize = 50;
    players4.alpha = 0.0f;
    
    if (self.gameSettings.numberOfPlayers == 2) {
        players2.fontColor = [SKColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:0.9];
    }
    else if (self.gameSettings.numberOfPlayers == 3) {
        players3.fontColor = [SKColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:0.9];
    }
    else if (self.gameSettings.numberOfPlayers == 4) {
        players4.fontColor = [SKColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:0.9];
    }
    
    SKSpriteNode *aboutButton = [SKSpriteNode spriteNodeWithImageNamed:@"aboutButton"];
    aboutButton.name = @"playGameButton";
    aboutButton.position = CGPointMake(self.view.bounds.size.width*3/4, aboutButton.size.height/2+kPadding);
    aboutButton.alpha = 0.0f;
    [self addChild:aboutButton];
    
    [self addBackButton];
    
    [self addChild:players2];
    [self addChild:players3];
    [self addChild:players4];
    
    [self fadeInAll];
}

-(void)showOptionsMenu {
    [self removeAllChildren];
    
    SKLabelNode *options = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue"];
    options.name = @"scoreLabel";
    options.text = [NSString stringWithFormat:@"Options menu"];
    options.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    options.fontColor = [SKColor colorWithRed:0.3 green:0.6 blue:0.8 alpha:1.0];
    options.fontSize = 80;
    options.alpha = 0.0f;

    
    [self addBackButton];
    
    [self addChild:options];
    
    [self fadeInAll];
}

-(void)showAboutMenu {
    [self removeAllChildren];
    
    SKLabelNode *about = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue"];
    about.name = @"scoreLabel";
    about.text = [NSString stringWithFormat:@"About menu"];
    about.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    about.fontColor = [SKColor colorWithRed:0.3 green:0.6 blue:0.8 alpha:1.0];
    about.fontSize = 80;
    about.alpha = 0.0f;
    
    [self addBackButton];
    
    [self addChild:about];
    
    [self fadeInAll];
}



-(void)addBackButton {
    SKSpriteNode *backButton = [SKSpriteNode spriteNodeWithImageNamed:@"backButton"];
    backButton.name = @"backButton";
    backButton.position = CGPointMake(self.view.bounds.size.width/2, backButton.size.height/2+kPadding);
    backButton.color = [SKColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    backButton.alpha = 0.0f;
    
    [self addChild:backButton];
}

-(void)runBlock:(void (^)(void))block forNode:(SKNode *)node {
    
    SKAction *disappearAction = [SKAction fadeOutWithDuration:kDurationForTransition];
    
    SKAction *finishBlock = [SKAction runBlock:block];
    
    SKAction *removeMenu = [SKAction sequence:@[disappearAction, finishBlock]];
    [node runAction:removeMenu withKey:@"removeMenu"];
    for (SKSpriteNode *button in self.children) {
        if (![node.name isEqualToString:button.name]) {
            [button runAction:disappearAction];
        }
    }
}

- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [self convertPointFromView:touchLocation];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
        if ([node.name isEqualToString:@"playButton"] && [self insideCircleWithRadius:node.size.width/2 betweenPoint:touchLocation andPoint:node.position]) {
            NSLog(@"Play");
                
                
            [self runBlock:^() {[self showPlayMenu];} forNode:node];

                
        }
        else if ([node.name isEqualToString:@"optionsButton"] && [self insideCircleWithRadius:node.size.width/2 betweenPoint:touchLocation andPoint:node.position]) {
                
            NSLog(@"Options");
            [self runBlock:^() {[self showOptionsMenu];} forNode:node];

        }
        else if ([node.name isEqualToString:@"aboutButton"] && [self insideCircleWithRadius:node.size.width/2 betweenPoint:touchLocation andPoint:node.position]) {
                
            NSLog(@"About");
            [self runBlock:^() {[self showAboutMenu];} forNode:node];
                
        }
        else if ([node.name isEqualToString:@"backButton"] && [self insideCircleWithRadius:node.size.width/2 betweenPoint:touchLocation andPoint:node.position]) {
            NSLog(@"Back");
            [self.gameSettings saveUserDefaults];
                
            [self runBlock:^() {[self showMainMenu];} forNode:node];
 
        }
        else if ([node.name isEqualToString:@"2players"]) {
            self.gameSettings.numberOfPlayers = 2;
        }
        else if ([node.name isEqualToString:@"3players"]) {
            self.gameSettings.numberOfPlayers = 3;
        }
        else if ([node.name isEqualToString:@"4players"]) {
            self.gameSettings.numberOfPlayers = 4;
        }
        else if ([node.name isEqualToString:@"playGameButton"]) {
            NSLog(@"PlayPlayPlay");
            [self.gameSettings saveUserDefaults];
            [[self view] removeGestureRecognizer:self.gestureRecognizer];
            
            SKScene *scene = [MyScene sceneWithSize:self.view.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;

            scene.userData = [NSMutableDictionary dictionary];
            [scene.userData setObject:self.gameSettings forKey:@"gameSettings"];
            
            SKTransition *transition = [SKTransition fadeWithDuration:1]; //[SKTransition flipHorizontalWithDuration:1.0];
            [self.view presentScene:scene transition:transition];
        }
    }
}

-(BOOL)insideCircleWithRadius:(float)radius betweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2 {
    float dx = fabsf(p2.x - p1.x);
    float dy = fabsf(p2.y - p1.y);
    float distance = sqrtf(dx*dx + dy*dy);
    if (radius > distance) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
