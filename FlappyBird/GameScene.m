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
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    CGPoint _velocity;
}

-(void)didMoveToView:(SKView *)view {
    NSLog(@"Ok");
    self.backgroundColor = [SKColor whiteColor];
    //We will create two background image and play it in a infinite loop. For a much more realistic view, developers can have a stack of background images
    for (int i=0; i<2; i++)
    {
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        //background.position = CGPointMake(self.size.width/2, self.size.height/2);
        background.position = CGPointMake((i*background.size.width)+background.size.width/2, background.size.height/2);
        //background.position = CGPointZero; //In a Mac machine makes the center of the image positioned at lower left corner. Untill and unless specified this is the default position
        background.name =@"background";
        [self addChild:background];
        
        SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
        //background.position = CGPointMake(self.size.width/2, self.size.height/2);
        ground.position = CGPointMake((i*ground.size.width)+ground.size.width/2, ground.size.height/2);
        //background.position = CGPointZero; //In a Mac machine makes the center of the image positioned at lower left corner. Untill and unless specified this is the default position
        ground.name =@"ground";
        [self addChild:ground];

    }
    
    

    
    //World
    self.physicsWorld.gravity = CGVectorMake(0.0, -3);
    
    
    //BIRD
    _bird = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    
    _bird.xScale = 0.1;
    _bird.yScale = 0.1;
    _bird.physicsBody.mass = 10;
    
    _bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_bird.size.width / 2];
    _bird.physicsBody.dynamic = YES;
    _bird.physicsBody.restitution = 0.0f;
    _bird.physicsBody.friction = 0.0f;
    _bird.physicsBody.angularDamping = 0.0f;
    _bird.physicsBody.linearDamping = 0.0f;
    _bird.physicsBody.velocity = CGVectorMake(0.0, 10.0);
    
    _bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:_bird];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _bird.physicsBody.velocity = CGVectorMake(0.0, 350.0);
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if(_lastUpdateTime)
    {
        _dt = currentTime - _lastUpdateTime;
    }
    else
    {
        _dt=0;
    }
    _lastUpdateTime = currentTime;
    [self moveBackground];
    [self moveForeground];
}

-(void)moveBackground
{
    [self enumerateChildNodesWithName:@"background" usingBlock:^(SKNode *node, BOOL *stop){
        SKSpriteNode *bg  = (SKSpriteNode *)node;
        CGPoint bgVelocity = CGPointMake(-80.0, 0); //The speed at which the background image will move
        CGPoint amountToMove = CGPointMultiplyScalar (bgVelocity,_dt);
        bg.position = CGPointAdd(bg.position,amountToMove);
        if (bg.position.x <= -bg.size.width/2)
        {
            bg.position = CGPointMake(bg.position.x + (bg.size.width)*2, bg.position.y);
        }
    }];
}

-(void)moveForeground{
    [self enumerateChildNodesWithName:@"ground" usingBlock:^(SKNode *node, BOOL *stop){
        SKSpriteNode *bg  = (SKSpriteNode *)node;
        CGPoint bgVelocity = CGPointMake(-160.0, 0); //The speed at which the background image will move
        CGPoint amountToMove = CGPointMultiplyScalar (bgVelocity,_dt);
        bg.position = CGPointAdd(bg.position,amountToMove);
        if (bg.position.x <= -bg.size.width/2)
        {
            bg.position = CGPointMake(bg.position.x + (bg.size.width)*2, bg.position.y);
        }
    }];

}

CGPoint CGPointAdd(CGPoint p1, CGPoint p2)
{
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

CGPoint CGPointMultiplyScalar(CGPoint p1, CGFloat p2)
{
    return CGPointMake(p1.x *p2, p1.y*p2);
}

@end
