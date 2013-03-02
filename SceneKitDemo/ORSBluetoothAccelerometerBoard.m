//
//  ORSBluetoothAccelerometerViewController.m
//  DKBLE112 Demo
//
//  Created by Andrew Madsen on 1/8/13.
//  Copyright (c) 2013 Open Reel Software. All rights reserved.
//

#import "ORSBluetoothAccelerometerBoard.h"

@interface ORSBluetoothAccelerometerOrientation ()

@property (nonatomic, readwrite) float x;
@property (nonatomic, readwrite) float y;
@property (nonatomic, readwrite) float z;

@end

@interface ORSBluetoothAccelerometerBoard ()

@property (nonatomic, strong, readwrite) ORSBluetoothAccelerometerOrientation *orientation;

@end

@implementation ORSBluetoothAccelerometerBoard

+ (CBUUID *)serviceUUID
{
	return [CBUUID UUIDWithString:ORSBluetoothBoardAccelerometerServiceUUIDString];
}

+ (NSArray *)characteristicUUIDs
{
	return @[[CBUUID UUIDWithString:ORSBluetoothBoardAccelerometerXCharacteristicUUIDString],
			 [CBUUID UUIDWithString:ORSBluetoothBoardAccelerometerYCharacteristicUUIDString],
			 [CBUUID UUIDWithString:ORSBluetoothBoardAccelerometerZCharacteristicUUIDString]];
}

+ (BOOL)shouldPollForCharacteristic:(CBCharacteristic *)characteristic;
{
	return YES;
}

- (void)receivedNewData:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic
{
	//NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, data, characteristic);
	
	if ([data length] < 2) return;
	
	int16_t value = *((int16_t *)[data bytes]);
	double accelerationInTermsOfG = 9.8 * ((double)value / 3900.0);
	
	if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:ORSBluetoothBoardAccelerometerXCharacteristicUUIDString]])
	{
		ORSBluetoothAccelerometerOrientation *orientation = [self.orientation copy];
		orientation.x = accelerationInTermsOfG;
		self.orientation = orientation;
	}
	else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:ORSBluetoothBoardAccelerometerYCharacteristicUUIDString]])
	{
		ORSBluetoothAccelerometerOrientation *orientation = [self.orientation copy];
		orientation.y = accelerationInTermsOfG;
		self.orientation = orientation;
	}
	else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:ORSBluetoothBoardAccelerometerZCharacteristicUUIDString]])
	{
		ORSBluetoothAccelerometerOrientation *orientation = [self.orientation copy];
		orientation.z = accelerationInTermsOfG;
		self.orientation = orientation;
	}
}

#pragma mark - Properties

- (ORSBluetoothAccelerometerOrientation *)orientation
{
	if (!_orientation) self.orientation = [[ORSBluetoothAccelerometerOrientation alloc] init];
	return _orientation;
}

@end


@implementation ORSBluetoothAccelerometerOrientation

- (id)copyWithZone:(NSZone *)zone
{
	ORSBluetoothAccelerometerOrientation *result = [[ORSBluetoothAccelerometerOrientation alloc] init];
	result.x = self.x;
	result.y = self.y;
	result.z = self.z;
	return result;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"x: %.3f y: %.3f z: %.3f", self.x, self.y, self.z];
}

@end