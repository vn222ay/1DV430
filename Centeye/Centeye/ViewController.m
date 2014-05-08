//
//  ViewController.m
//  Centeye
//
//  Created by Viktor Nilsson on 2014-04-11.
//  Copyright (c) 2014 Viktor Nilsson. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "Menu.h"

@interface ViewController ()

@property BOOL loaded;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews
{
    if (!self.loaded) {
        
        // Undvik att den laddas på nytt när orientation ändras
        [super viewWillLayoutSubviews];

        SKView * skView = (SKView *)self.view;
    
        //TODO Ta bort
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
     
        // Skapan scenen
        SKScene * scene = [Menu sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
    
        // Presentera Scenen
        [skView presentScene:scene];
        self.loaded = YES;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
