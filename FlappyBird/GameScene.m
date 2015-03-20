//
//  GameScene.m
//  FlappyBird
//
//  Created by Bryan Reymonenq on 18/03/2015.
//  Copyright (c) 2015 Fliizweb.fr. All rights reserved.
//

#import "GameScene.h"

#define SPACE_BETWEEN_TOWERS 150

@implementation GameScene {
    SKSpriteNode* _bird;
    SKSpriteNode* _logo;
    SKSpriteNode* _tapToStart;
    
    SKTexture* _foreground;
    SKTexture* _background;
    
    SKSpriteNode* _towerTop;
    SKSpriteNode* _towerBottom;
    SKTexture* _towerBottomTexture;
    SKTexture* _towerTopTexture;
}

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor whiteColor];

    //We will create two background image and play it in a infinite loop. For a much more realistic view, developers can have a stack of background images
    // Create ground
    
    _foreground = [SKTexture textureWithImageNamed:@"ground"];
    _foreground.filteringMode = SKTextureFilteringNearest;

    _background = [SKTexture textureWithImageNamed:@"background"];
    _background.filteringMode = SKTextureFilteringNearest;
    
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
    
    [self generateTowers];
    
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

-(void)generateTowers {
    NSInteger random = [self randomValueBetween:100 and:400];
    
    //TOWER BOTTOM
    SKTexture* towerBottomTexture = [SKTexture textureWithImageNamed:@"BottomTower"];
    towerBottomTexture.filteringMode = SKTextureFilteringNearest;
    SKSpriteNode *towerBottom = [SKSpriteNode spriteNodeWithTexture:towerBottomTexture];
    towerBottom.color = [SKColor redColor];
    
    towerBottom.anchorPoint = CGPointMake(0.5, 1);
    //towerBottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(towerBottom.position.x, towerBottom.position.y, towerBottom.size.width, towerBottom.size.height)];
    //towerBottom.physicsBody = [SKPhysicsBody bodyWithTexture:towerBottomTexture size:CGSizeMake(towerBottom.size.width, towerBottom.size.height)];
    towerBottom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:towerBottom.size center:CGPointMake(towerBottom.size.width * (0.5 - towerBottom.anchorPoint.x), towerBottom.size.height * (0.5 - towerBottom.anchorPoint.y))];
    
    // node.size.width * (O.5 - node.anchorpoint.x)
    

    towerBottom.physicsBody.dynamic = NO;
    towerBottom.position = CGPointMake(CGRectGetWidth(self.frame) / 1.3, _foreground.size.height + random);
    
    _towerBottom.anchorPoint = CGPointMake(0.5, 1);
    _towerBottom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_towerBottom.size center:CGPointMake(_towerBottom.size.width * (0.5 - _towerBottom.anchorPoint.x), _towerBottom.size.height * (0.5 - _towerBottom.anchorPoint.y))];
    _towerBottom.physicsBody.dynamic = NO;
    _towerBottom.position = CGPointMake(CGRectGetWidth(self.frame) / 1.3, _foreground.size.height + random);
    
    SKAction *moveTowerBottom = [SKAction moveByX:-_foreground.size.width * 2 y:0 duration:0.02 * (_foreground.size.width * 2)];
    [_towerBottom runAction:moveTowerBottom];
    
    [self addChild:_towerBottom];
    
    //TOWER TOP
    _towerTopTexture = [SKTexture textureWithImageNamed:@"TopTower"];
    _towerTopTexture.filteringMode = SKTextureFilteringNearest;
    _towerTop = [SKSpriteNode spriteNodeWithTexture:_towerTopTexture];
    
    _towerTop.anchorPoint = CGPointMake(0.5, 0);
    _towerTop.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_towerTop.size center:CGPointMake(_towerTop.size.width * (0.5 - _towerTop.anchorPoint.x), _towerTop.size.height * (0.5 - _towerTop.anchorPoint.y))];
    _towerTop.physicsBody.dynamic = NO;
    _towerTop.position = CGPointMake(CGRectGetWidth(self.frame) / 1.3, _foreground.size.height + random + SPACE_BETWEEN_TOWERS);
    
    SKAction *moveTowerTop = [SKAction moveByX:-_foreground.size.width * 2 y:0 duration:0.02 * (_foreground.size.width * 2)];
    [_towerTop runAction:moveTowerTop];
    
    [self addChild:_towerTop];
}

- (NSInteger)randomValueBetween:(NSInteger)min and:(NSInteger)max {
    return (NSInteger)(min + arc4random_uniform(max - min + 1));
}

@end
