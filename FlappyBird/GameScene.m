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
}

-(void)didMoveToView:(SKView *)view {
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
    
    _bird.position = CGPointMake(CGRectGetWidth(self.frame), CGRectGetMidY(self.frame));
    [self addChild:_bird];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _bird.physicsBody.velocity = CGVectorMake(0.0, 350.0);
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
