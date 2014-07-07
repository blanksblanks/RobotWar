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
    int actionIndex;
}

int _currentRobotState = RobotStateSearch;
int i = 0;

- (void)run {
    actionIndex = 0;
    while (true) {
        while (_currentRobotState == RobotStateFire) {
            [self performNextFiringAction];
        }
        
        while (_currentRobotState == RobotStateSearch) {
            [self turnGunLeft:40];
            [self shoot];
            [self performNextSearchingAction];
        }
        
        while (_currentRobotState == RobotStateDefault) {
            [self performNextDefaultAction];
        }
    }
}

- (void)performNextDefaultAction {
    switch (actionIndex%1) {
        case 0:
            [self turnGunRight:10];
            [self shoot];
            [self moveAhead:100];
            CCLOG(@"Hi!");
            break;
    }
    actionIndex++;
}

- (void) performNextFiringAction {
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

- (void)performNextSearchingAction {
    switch (actionIndex%4) {
        case 0:
            [self moveAhead:50];
            [self shoot];
            break;
            
        case 1:
            [self turnRobotLeft:20];
            [self shoot];
            break;
            
        case 2:
            [self moveAhead:50];
            [self shoot];
            break;
            
        case 3:
            [self turnRobotRight:20];
            [self shoot];

            break;
    }
    actionIndex++;
}

-(void)scannedRobot:(Robot *)robot atPosition:(CGPoint)position
{
    if (_currentRobotState == !RobotStateFire){
    [self cancelActiveAction];
        [self moveAhead:70];
        CGFloat angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
        CCLOG(@"Enemy Spotted at angle: %f", angle);
        if (angle >= 0) {
            [self turnGunRight:abs(angle)];
        } else {
            [self turnGunLeft:abs(angle)];
        }
        _currentRobotState = RobotStateFire;
        _lastKnownPosition = position;
        _lastKnownPositionTimestamp = self.currentTimestamp;
    }
}

-(void)bulletHitEnemy:(Bullet *)bullet{
    [self cancelActiveAction];
    _timeSinceLastEnemyHit = self.currentTimestamp;
    [self shoot];
    _currentRobotState = RobotStateFire;
}

-(void)gotHit{
    if (_currentRobotState == !RobotStateTurnandRun) {
    [self cancelActiveAction];
    _currentRobotState = RobotStateTurnandRun;
    } else {
        [self moveAhead:200];
        _currentRobotState = RobotStateSearch;
   }
}

- (void)hitWall:(RobotWallHitDirection)hitDirection hitAngle:(CGFloat)angle {
    if (_currentRobotState != RobotStateTurnandRun) {
        [self cancelActiveAction];
        
        previousState = _currentRobotState;
        _currentRobotState = RobotStateTurnandRun;
        
        // always turn to head straight away from the wall
        if (angle >= 0) {
            [self turnRobotLeft:abs(abs(angle)-90)];
        } else {
            [self turnRobotRight:abs(abs(angle)-90)];
        }
        
        [self moveAhead:20];
        
        _currentRobotState = previousState;
    }
}

@end







/*-(void)run
 {
 while (true) {
 if (_currentRobotState == RobotStateFire){
 if ((self.currentTimestamp - _lastKnownPositionTimestamp) > 1.f) {
 _currentRobotState = RobotStateSearch;
 }
 else {
 [self shoot];
 }
 
 }
 if (_currentRobotState == RobotStateSearch){
 i++;
 while (i<10) {
 [self turnGunLeft:40];
 [self shoot];
 }if (i == 10) {
 _currentRobotState = RobotStateDefault;
 }
 }
 if (_currentRobotState == RobotStateDefault){
 [self moveAhead:35];
 i--;
 if (i == 0) {
 _currentRobotState = RobotStateSearch;
 }
 
 }
 if (_currentRobotState == RobotStateTurnandRun){
 [self moveAhead:70];
 [self turnRobotRight:45];
 [self moveAhead:50];
 _currentRobotState = RobotStateSearch;
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