//
//  Robot.h
//  RobotWar
//
//  Created by Benjamin Encz on 29/05/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "MainScene.h"

@class Bullet;

@protocol RobotProtocol <NSObject>

- (void)scannedRobot;
- (void)hitWall;
- (void)gotHit:(Bullet*)bullet;

@end

@interface Robot : NSObject <RobotProtocol>

@property (weak, nonatomic) id<GameBoard> gameBoard;
@property (weak, nonatomic) CCNode *robotNode;
@property (copy, nonatomic) NSString *name;

- (void)turnGunLeft:(NSInteger)degree;
- (void)turnGunRight:(NSInteger)degree;
- (void)moveAhead:(NSInteger)distance;

- (void)run;

@end