//
//  Landscape.m
//  FlappyBird
//
//  Created by Jonathan on 19/03/2015.
//  Copyright (c) 2015 Fliizweb.fr. All rights reserved.
//

#import "Landscape.h"

@implementation Landscape

- (SKNode *) createBackgroundNode {
    // 1
    // Create the node
    SKNode *backgroundNode = [SKNode node];
    
        NSString *backgroundImageName = [NSString stringWithFormat:@"background"];
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:backgroundImageName];
        // 4
        node.anchorPoint = CGPointMake(0.5f, 0.0f);
        node.position = CGPointMake(160.0f, 64.0f);
        // 5
        [backgroundNode addChild:node];
    
    
    // 6
    // Return the completed background node
    return backgroundNode;
}

@end
