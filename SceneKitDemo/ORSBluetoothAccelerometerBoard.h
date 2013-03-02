//
//  ORSBluetoothAccelerometerViewController.h
//  DKBLE112 Demo
//
//  Created by Andrew Madsen on 1/8/13.
//  Copyright (c) 2013 Open Reel Software. All rights reserved.
//

#import "ORSBluetoothBoard.h"

@interface ORSBluetoothAccelerometerOrientation : NSObject <NSCopying>

@property (nonatomic, readonly) float x;
@property (nonatomic, readonly) float y;
@property (nonatomic, readonly) float z;

@end

@interface ORSBluetoothAccelerometerBoard : ORSBluetoothBoard

@property (nonatomic, strong, readonly) ORSBluetoothAccelerometerOrientation *orientation;

@end
