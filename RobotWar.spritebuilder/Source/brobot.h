//
//  brobot.h
//  RobotWar
//
//  Created by Dat Do on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Robot.h"

@interface brobot : Robot

@end


//Linear targeting
//double absoluteBearing = getHeadingRadians() + e.getBearingRadians();
//setTurnGunRightRadians(Utils.normalRelativeAngle(absoluteBearing -
//getGunHeadingRadians() + (e.getVelocity() * Math.sin(e.getHeadingRadians() - absoluteBearing) / 13.0)));
//setFire(3.0);