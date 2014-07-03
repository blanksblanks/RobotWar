//
//  brobot.m
//  RobotWar
//
//  Created by Dat Do on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "brobot.h"
typedef NS_ENUM(NSInteger, RobotState)
{
    RobotStateDefault,
    RobotStateAim,
    RobotStateSearch,
    RobotStateFire,
    RobotStateTurnandRun,
    RobotStateRevenge,
};
@implementation brobot
{
    RobotState _currentRobotState;
}
- (void)run
{
    while (true) {
    if (_currentRobotState == RobotStateFire) {
        [self shoot];
    }
    }
}
-(void)scannedRobot:(Robot*)robot atPosition:(CGPoint)position{
    [self moveAhead:70];
    _currentRobotState = RobotStateFire;
    CGFloat angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:position];
    if (angle >= 0){
        [self turnGunRight:abs(angle)];
    } else {
    [self turnGunLeft:abs(angle)];
    }
    [self shoot];
}
-(void)bulletHitEnemy:(Bullet *)bullet{
    
}

@end
