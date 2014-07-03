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
    CGPoint _lastKnownPosition;
    CGFloat _lastKnownPositionTimestamp;
    RobotState previousState;
}

- (void)run
{
    while (true) {
        if (_currentRobotState == RobotStateFire) {
            
            if ((self.currentTimestamp - _lastKnownPositionTimestamp) > 1.f) {
                _currentRobotState = RobotStateSearch;
            } else {
                CGFloat angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
                if (angle >= 0) {
                    [self turnGunRight:abs(angle)];
                } else {
                    [self turnGunLeft:abs(angle)];
                }
                [self shoot];
            }
        }
            if (_currentRobotState == RobotStateSearch) {
            [self moveAhead:50];
            [self turnRobotLeft:20];
            [self moveAhead:50];
            [self turnRobotRight:20];
        }
    }
}
-(void)scannedRobot:(Robot*)robot atPosition:(CGPoint)position{
    if (_currentRobotState == !RobotStateTurnandRun){
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
    _lastKnownPosition = position;
    _lastKnownPositionTimestamp = self.currentTimestamp;
}
-(void)bulletHitEnemy:(Bullet *)bullet{
    [self turnGunRight:20];
    [self shoot];
    [self turnGunLeft:40];
    [self shoot];
    [self turnGunRight:20];
}
- (void)hitWall:(RobotWallHitDirection)hitDirection hitAngle:(CGFloat)hitAngle {
    if (_currentRobotState != RobotStateTurnandRun) {
        [self cancelActiveAction];
        
  
        _currentRobotState = RobotStateTurnandRun;
        
        // always turn to head straight away from the wall
        if (hitAngle >= 0) {
            [self turnRobotLeft:abs(hitAngle)];
        } else {
            [self turnRobotRight:abs(hitAngle)];
            
        }
        
        [self moveAhead:20];
        
        _currentRobotState = previousState;
    }
}
@end
