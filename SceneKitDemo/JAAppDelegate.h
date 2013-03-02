//
//  JAAppDelegate.h
//  SceneKitDemo
//
//  Created by Jake Gundersen on 3/2/13.
//  Copyright (c) 2013 The Team. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ORSBluetoothAccelerometerBoard.h"

@class JASCNView;
@class ORSBluetoothLEScanner;

@interface JAAppDelegate : NSObject <NSApplicationDelegate, ORSBluetoothBoardDelegate>

- (IBAction)scan:(id)sender;

@property (nonatomic, strong) ORSBluetoothLEScanner *scanner;
@property (nonatomic, strong) ORSBluetoothAccelerometerBoard *accelerometer;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet JASCNView *sceneView;
@property (assign) IBOutlet NSTextField *scanningInfoLabel;

@end
