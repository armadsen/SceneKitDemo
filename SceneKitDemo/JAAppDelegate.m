//
//  JAAppDelegate.m
//  SceneKitDemo
//
//  Created by Jake Gundersen on 3/2/13.
//  Copyright (c) 2013 The Team. All rights reserved.
//

#import "JAAppDelegate.h"
#import "ORSBluetoothLEScanner.h"
#import "ORSBluetoothAccelerometerBoard.h"
#import "JASCNView.h"

@interface JAAppDelegate ()

@end

@implementation JAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
//	[self scan:nil];
}

#pragma mark - Actions

- (IBAction)scan:(id)sender;
{
	[self.scanner scanForDevicesAdvertisingServices:@[ORSBluetoothBoardAccelerometerServiceUUIDString]];
	[self.scanningInfoLabel setHidden:NO];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object == self.scanner)
	{
		if (self.scanner.isScanning)
		{
			self.scanningInfoLabel.stringValue = @"Scanning...";
		}
		else if ([self.scanner.detectedPeripherals count])
		{
			self.scanningInfoLabel.stringValue = @"Found Bluetooth board";
			CBPeripheral *peripheral = [self.scanner.detectedPeripherals anyObject];
			[self.scanner connectToPeripheral:peripheral
						  withCompletionBlock:^(NSError *error) {
							  self.accelerometer = [ORSBluetoothAccelerometerBoard boardWithPeripheral:peripheral];
						  }];
		}
		else
		{
			self.scanningInfoLabel.stringValue = @"No Bluetooth devices found";
		}
	}
	
	if (object == self.accelerometer && [keyPath isEqualToString:@"orientation"])
	{
		NSLog(@"orientation: %@", self.accelerometer.orientation);
		self.sceneView.orientation = self.accelerometer.orientation;
	}
}

#pragma mark - ORSBluetoothBoardDelegate

- (void)bluetoothBoard:(ORSBluetoothBoard *)board didEncounterError:(NSError *)error
{
	NSLog(@"Bluetooth board error: %@", error);
}

#pragma mark - Properties

@synthesize scanner = _scanner;
- (ORSBluetoothLEScanner *)scanner
{
	if (!_scanner) self.scanner = [ORSBluetoothLEScanner sharedBluetoothLEScanner];
	return _scanner;
}

- (void)setScanner:(ORSBluetoothLEScanner *)scanner
{
	if (scanner != _scanner)
	{
		[_scanner removeObserver:self forKeyPath:@"scanning"];
		_scanner = scanner;
		[_scanner addObserver:self forKeyPath:@"scanning" options:0 context:NULL];
	}
}

- (void)setAccelerometer:(ORSBluetoothAccelerometerBoard *)accelerometer
{
	if (accelerometer != _accelerometer)
	{
		[_accelerometer removeObserver:self forKeyPath:@"orientation"];
		_accelerometer = accelerometer;
		[_accelerometer addObserver:self forKeyPath:@"orientation" options:0 context:NULL];
	}
}

@end
