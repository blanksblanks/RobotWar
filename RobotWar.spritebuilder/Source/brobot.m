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
    float _timeSinceLastEnemyHit;
}
int _currentRobotState = RobotStateSearch;

-(void)scannedRobot:(Robot *)robot atPosition:(CGPoint)position
{
    float angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:position];
    if (_currentRobotState == !RobotStateTurnandRun) {
        [self moveAhead:40];
        _currentRobotState = RobotStateFire;
        if (angle >= 0){
            [self turnGunRight:abs(angle)];
        } else {
            [self turnGunLeft:abs(angle)];
        }
        [self shoot];
    }
}
@end







/*- (void)run
{
    
    while (true) {
        if (_currentRobotState == RobotStateFire) {
            
            if ((self.currentTimestamp - _lastKnownPositionTimestamp) > 0.3f) {
                _currentRobotState = RobotStateSearch;
            }
            //            else if ((self.currentTimestamp - _lastKnownPositionTimestamp) > 0.3f) {
            //                    ...
            //                }
            //          ISSUE: when brobot moves his gun, the enemy is already gone :(
            //          Maybe time stamp is too long?
            else {
                CGFloat angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
                CCLOG(@"Enemy Spotted at angle: %f", angle);
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
    
    // Calculate the angle between brobot and the enemy
    float angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:position];
    
    CCLOG(@"Enemy Position: (%f, %f)", position.x, position.y);
    CCLOG(@"Enemy Spotted at Angle: %f", angle);
    
    if (_currentRobotState == !RobotStateTurnandRun){
        [self cancelActiveAction];
        [self moveAhead:70];
        _currentRobotState = RobotStateFire;
        
        if (angle >= 0){
            //  [self cancelActiveAction];
            [self turnGunRight:abs(angle)];
        } else {
            // [self cancelActiveAction];
            [self turnGunLeft:abs(angle)];
        }
        [self shoot];
    }
    
    _lastKnownPosition = position;
    _lastKnownPositionTimestamp = self.currentTimestamp;
    
    // CCLOG(@"Enemy last known position: (%f)", _lastKnownPosition);
    // CCLOG(@"Enemy last known position timestamp: (%f)", _lastKnownPositionTimestamp);
}

-(void)bulletHitEnemy:(Bullet *)bullet{
    // this for when the bullet hit enemy, shoot 2 extra
    [self turnGunRight:20];
    [self shoot];
    [self turnGunLeft:40];
    [self shoot];
    [self turnGunRight:20];
    
    _timeSinceLastEnemyHit = self.currentTimestamp;
    // CCLOG(@"Time since enemy last hit: (%f)", _timeSinceLastEnemyHit);
}

- (void)hitWall:(RobotWallHitDirection)hitDirection hitAngle:(CGFloat)hitAngle {
    if (_currentRobotState != RobotStateTurnandRun) {
        [self cancelActiveAction];
        
        // RobotState previousState  = _currentRobotState;
        _currentRobotState = RobotStateTurnandRun;
        
        // always turn to head straight away from the wall
        if (hitAngle >= 0) {
            [self turnRobotLeft:abs(hitAngle)];
        } else {
            [self turnRobotRight:abs(hitAngle)];
            
        }
        
        [self moveAhead:20];
        // ISSUE: brobot gets stuck in walls and doesn't move :/
        
        // _currentRobotState = previousState;
    }
    
}*/