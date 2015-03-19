//
//  GameScene.m
//  FlappyBird
//
//  Created by Bryan Reymonenq on 18/03/2015.
//  Copyright (c) 2015 Fliizweb.fr. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    SKSpriteNode* _bird;
    SKSpriteNode* _logo;
    SKSpriteNode* _tapToStart;
    SKTexture* _foreground;
    SKTexture* _background;
}

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor whiteColor];

    //We will create two background image and play it in a infinite loop. For a much more realistic view, developers can have a stack of background images
    // Create ground
    
    _foreground = [SKTexture textureWithImageNamed:@"ground"];
    _foreground.filteringMode = SKTextureFilteringNearest;


    _background = [SKTexture textureWithImageNamed:@"background"];
    _background.filteringMode = SKTextureFilteringNearest;
    
    // Foreground
    SKAction *moveForeGround = [SKAction moveByX:-_foreground.size.width * 2 y:0 duration:0.02 * _foreground.size.width * 2];
    SKAction *resetMoveForeground = [SKAction moveByX:_foreground.size.width * 2 y:0 duration:0];
    SKAction *repeatForeverForeground = [SKAction repeatActionForever:[SKAction sequence:@[moveForeGround, resetMoveForeground]]];
    for (int i = 0; i < 2 + self.frame.size.width / (_foreground.size.width * 2) ; ++i) {
        SKSpriteNode* fore = [SKSpriteNode spriteNodeWithTexture:_foreground];
        fore.position = CGPointMake(i * fore.size.width, fore.size.height / 2);
        [fore runAction:repeatForeverForeground];
        [self addChild:fore];
    }

    // Background
    SKAction *moveBackGround = [SKAction moveByX:-_background.size.width * 2 y:0 duration:0.1 * _background.size.width * 2 ];
    SKAction *resetMoveBackground = [SKAction moveByX:_background.size.width * 2 y:0 duration:0];
    SKAction *repeatForeverBackground = [SKAction repeatActionForever:[SKAction sequence:@[moveBackGround, resetMoveBackground]]];
    for (int i = 0; i < 2 + self.frame.size.width / (_background.size.width * 2) ; ++i) {
        SKSpriteNode* back = [SKSpriteNode spriteNodeWithTexture:_background];
        back.position = CGPointMake(i * back.size.width, back.size.height / 2);
        back.zPosition = -20;
        [back runAction:repeatForeverBackground];
        [self addChild:back];
    }
    


    //World
    self.physicsWorld.gravity = CGVectorMake(0.0, -3);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, _foreground.size.height, self.frame.size.width, self.frame.size.height - _foreground.size.height)];
    
    ///Initialisation du "Tap to Start" & du "logo"
    _tapToStart = [SKSpriteNode spriteNodeWithImageNamed:@"TapToStart"];
    _tapToStart.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - (_tapToStart.frame.size.height + 20));
    [self addChild:_tapToStart];
    
    _logo = [SKSpriteNode spriteNodeWithImageNamed:@"Logo"];
    _logo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + (_logo.frame.size.height + 20));
    [self addChild:_logo];
    
    //Initialisation du BIRD
    _bird = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    
    _bird.xScale = 0.1;
    _bird.yScale = 0.1;
    _bird.physicsBody.mass = 10;
    
    _bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_bird.size.width / 2];
    _bird.physicsBody.dynamic = NO;
    _bird.physicsBody.restitution = 0.0f;
    _bird.physicsBody.friction = 0.0f;
    _bird.physicsBody.angularDamping = 0.0f;
    _bird.physicsBody.linearDamping = 0.0f;
    _bird.physicsBody.velocity = CGVectorMake(0.0, 10.0);
    
    _bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));

    [self addChild:_bird];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //TAP POUR LANCER LE JEU
    if(!_bird.physicsBody.dynamic) {
        //Suppression du node pour lancer le jeu
        [_tapToStart removeFromParent];
        [_logo removeFromParent];
        
        //On réactive la dynamique du node pour l'oiseau
        _bird.physicsBody.dynamic = YES;
        
        //On lui fait faire un saut au premier Tap
        _bird.physicsBody.velocity = CGVectorMake(0.0, 350.0);
        
        //On sort de la fonction
        return;
    }
    
    //A partir du deuxieme tap ce code est executé.
    _bird.physicsBody.velocity = CGVectorMake(0.0, 350.0);
}

-(void)update:(CFTimeInterval)currentTime {

}

@end
