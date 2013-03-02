//
//  JASCNView.h
//  SceneKitDemo
//
//  Created by Jake Gundersen on 3/2/13.
//  Copyright (c) 2013 The Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SceneKit/SceneKit.h>

@class ORSBluetoothAccelerometerOrientation;

@interface JASCNView : SCNView

@property (nonatomic, strong) ORSBluetoothAccelerometerOrientation *orientation;

@end
