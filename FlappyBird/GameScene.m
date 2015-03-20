//
//  GameScene.m
//  FlappyBird
//
//  Created by Bryan Reymonenq on 18/03/2015.
//  Copyright (c) 2015 Fliizweb.fr. All rights reserved.
//

#import "GameScene.h"

#define GRAVITY_X 0.0
#define GRAVITY_Y -5.0
#define SPACE_BETWEEN_TOWERS 150
#define BIRD_JUMP 350
#define TOWER_GAP_MIN 50
#define TOWER_GAP_MAX 400

@implementation GameScene {
    SKSpriteNode*   _bird;
    SKSpriteNode*   _logo;
    SKSpriteNode*   _tapToStart;
    
    SKTexture*      _foreground;
    SKTexture*      _background;
    
    SKSpriteNode* _towerTop;
    SKSpriteNode* _towerBottom;
    SKTexture* _towerBottomTexture;
    SKTexture* _towerTopTexture;
    SKAction*       _moveTowers;
    
    _Bool isCollision;
}

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor whiteColor];    //We will create two background image and play it in a infinite loop. For a much more realistic view, developers can have a stack of background images
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
    
    //TOWERS
    _towerTopTexture = [SKTexture textureWithImageNamed:@"TopTower"];
    _towerTopTexture.filteringMode = SKTextureFilteringNearest;
    _towerBottomTexture = [SKTexture textureWithImageNamed:@"BottomTower"];
    _towerBottomTexture.filteringMode = SKTextureFilteringNearest;
    
    CGFloat moveTowersDirection = _foreground.size.width * 2;
    SKAction* moveTowers = [SKAction moveByX:-moveTowersDirection y:0 duration:0.02 * moveTowersDirection];
    SKAction* removeTowers = [SKAction removeFromParent];
    _moveTowers = [SKAction sequence:@[moveTowers, removeTowers]];
    
    SKAction* generateTowers = [SKAction performSelector:@selector(generateTowers) onTarget:self];
    SKAction* delay = [SKAction waitForDuration:4.0];
    SKAction* generateAndDelay = [SKAction sequence:@[generateTowers, delay]];
    SKAction* generateAndDelayForever = [SKAction repeatActionForever:generateAndDelay];
    [self runAction:generateAndDelayForever];
    
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
    self.physicsWorld.gravity = CGVectorMake(GRAVITY_X, GRAVITY_Y);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, _foreground.size.height, self.frame.size.width, self.frame.size.height - _foreground.size.height)];
    
    self.physicsBody.categoryBitMask = towerCategory;
    self.physicsBody.contactTestBitMask = birdCategory;
    self.physicsBody.collisionBitMask = 0;
    self.physicsWorld.contactDelegate = self;
    
    
    
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
    _bird.physicsBody.mass = 50;
    
    _bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_bird.size.width / 2];
    _bird.physicsBody.dynamic = NO;
    _bird.physicsBody.restitution = 0.0f;
    _bird.physicsBody.friction = 0.0f;
    _bird.physicsBody.angularDamping = 0.0f;
    _bird.physicsBody.linearDamping = 0.0f;
    _bird.physicsBody.velocity = CGVectorMake(0.0, 10.0);
    
    _bird.physicsBody.categoryBitMask = birdCategory;
    _bird.physicsBody.contactTestBitMask = towerCategory;
    
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
        _bird.physicsBody.velocity = CGVectorMake(0.0, BIRD_JUMP);
        
        //On sort de la fonction
        return;
    }
    
    if(isCollision == NO){
        //A partir du deuxieme tap ce code est executé.
        _bird.physicsBody.velocity = CGVectorMake(0.0, 350.0);
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
}

-(void)generateTowers {
    NSInteger random = [self randomValueBetween:TOWER_GAP_MIN and:TOWER_GAP_MAX];
    
    SKNode* towers = [SKNode node];
    
    //TOWER TOP
    SKSpriteNode* towerTop = [SKSpriteNode spriteNodeWithTexture:_towerTopTexture];
    
    towerTop.anchorPoint = CGPointMake(0.5, 0);
    towerTop.xScale = 2.0;
    towerTop.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:towerTop.size center:CGPointMake(towerTop.size.width * (0.5 - towerTop.anchorPoint.x), towerTop.size.height * (0.5 - towerTop.anchorPoint.y))];
    towerTop.physicsBody.dynamic = NO;
    towerTop.position = CGPointMake(CGRectGetWidth(self.frame) / 1.3, _foreground.size.height + random + SPACE_BETWEEN_TOWERS);
    
    [towers addChild:towerTop];
    
    
    //TOWER BOTTOM
    SKSpriteNode* towerBottom = [SKSpriteNode spriteNodeWithTexture:_towerBottomTexture];
    
    towerBottom.anchorPoint = CGPointMake(0.5, 1);
    towerBottom.xScale = 2.0;
    towerBottom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:towerBottom.size center:CGPointMake(towerBottom.size.width * (0.5 - towerBottom.anchorPoint.x), towerBottom.size.height * (0.5 - towerBottom.anchorPoint.y))];
    towerBottom.physicsBody.dynamic = NO;
    towerBottom.position = CGPointMake(CGRectGetWidth(self.frame) / 1.3, _foreground.size.height + random);
    
    [towers addChild:towerBottom];
    
    
    //INVISIBLE BLOCK TO INCREMENT SCORE
    SKSpriteNode* invisibleBlock = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(towerBottom.size.width, SPACE_BETWEEN_TOWERS)];
    
    invisibleBlock.anchorPoint = CGPointMake(0, 0);
    invisibleBlock.xScale = 1.0;
    invisibleBlock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:invisibleBlock.size center:CGPointMake(invisibleBlock.size.width * (0.5 - invisibleBlock.anchorPoint.x), invisibleBlock.size.height * (0.5 - invisibleBlock.anchorPoint.y))];
    invisibleBlock.physicsBody.dynamic = NO;
    invisibleBlock.position = CGPointMake(CGRectGetWidth(self.frame) / 1.3 + towerTop.size.width / 2, towerBottom.position.y);
    
    [towers addChild:invisibleBlock];
    
    //RUN ACTION
    [towers runAction:_moveTowers];
    
    [self addChild:towers];
}

-(void)removeTowers {
    [_towerTop removeFromParent];
    [_towerBottom removeFromParent];
}

- (NSInteger)randomValueBetween:(NSInteger)min and:(NSInteger)max {
    return (NSInteger)(min + arc4random_uniform(max - min + 1));
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"contact detected");
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    isCollision = true;
    _bird.physicsBody.mass = 10;
    self.scene.view.paused = NO;
    
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    //Your first body is the block, secondbody is the player.
    //Implement relevant code here.
    
}

-(bool) collisionIsTrue{
    return isCollision;
}

@end
