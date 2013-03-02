//
//  ORSBluetoothBoardViewController.m
//  DKBLE112 Demo
//
//  Created by Andrew Madsen on 1/8/13.
//  Copyright (c) 2013 Open Reel Software. All rights reserved.
//

#import "ORSBluetoothBoard.h"

NSString * const ORSBluetoothBoardPeripheralUUIDString = @"FC9A330F-B21B-2C24-94CA-910CE5B61F40";

NSString * const ORSBluetoothBoardCableReplacementType = @"ORSBluetoothBoardCableReplacementType";
NSString * const ORSBluetoothBoardCableReplacementServiceUUIDString = @"0bd51666-e7cb-469b-8e4d-2742f1ba77cc";
NSString * const ORSBluetoothBoardCableReplacementCharacteristicUUIDString = @"e7add780-b042-4876-aae1-112855353cc1";

NSString * const ORSBluetoothBoardAccelerometerType = @"ORSBluetoothBoardAccelerometerType";
NSString * const ORSBluetoothBoardAccelerometerServiceUUIDString = @"6d480f49-91d3-4a18-be29-0d27f4109c23";
NSString * const ORSBluetoothBoardAccelerometerXCharacteristicUUIDString = @"11c3876c-9bda-42cc-a30b-1be83c8059d3";
NSString * const ORSBluetoothBoardAccelerometerYCharacteristicUUIDString = @"7c55527b-4027-42ae-ae6d-6d1309e5d97e";
NSString * const ORSBluetoothBoardAccelerometerZCharacteristicUUIDString = @"f1fa1ce8-cbcc-4401-8428-ae947bd512ae";

@interface ORSBluetoothBoard ()

@property (nonatomic, copy, readwrite) NSArray *characteristics;

@end

@implementation ORSBluetoothBoard

+ (instancetype)boardWithPeripheral:(CBPeripheral *)peripheral;
{
	if (!peripheral) return nil;
	ORSBluetoothBoard *result = [[self alloc] init];
	result.bluetoothPeripheral = peripheral;
	[result startDiscovery];
	return result;
}

- (void)sendData:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic;
{
	[self.bluetoothPeripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark - Private

- (void)startDiscovery
{
	if (!self.bluetoothPeripheral) return;
	
	CBUUID *serviceUUID = [[self class] serviceUUID];
	[self.bluetoothPeripheral discoverServices:@[serviceUUID]];
}

- (void)informDelegateOfError:(NSError *)error
{
	if (![self.delegate respondsToSelector:@selector(bluetoothBoard:didEncounterError:)]) return;
	[self.delegate bluetoothBoard:self didEncounterError:error];
}

#pragma mark - For Subclasses

+ (CBUUID *)serviceUUID
{
	return nil;
}

+ (NSArray *)characteristicUUIDs
{
	return @[];
}

+ (BOOL)shouldPollForCharacteristic:(CBCharacteristic *)characteristic;
{
	return NO;
}

- (void)receivedNewData:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic
{
	
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, peripheral, error);
	if (error) return [self informDelegateOfError:error];
	
	CBUUID *serviceUUID = [[self class] serviceUUID];
	NSIndexSet *matchingServiceIndexes = [peripheral.services indexesOfObjectsPassingTest:^BOOL(CBService *service, NSUInteger idx, BOOL *stop) {
		return [service.UUID isEqual:serviceUUID];
	}];
	if (![matchingServiceIndexes count]) return;
	
	CBService *service = [[peripheral.services objectsAtIndexes:matchingServiceIndexes] lastObject];
	[self.bluetoothPeripheral discoverCharacteristics:[[self class] characteristicUUIDs] forService:service];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
	NSLog(@"%s %@ %@ %@", __PRETTY_FUNCTION__, peripheral, service, error);
	if (error) return [self informDelegateOfError:error];
	
	NSArray *characteristicUUIDs = [[self class] characteristicUUIDs];
	NSIndexSet *matchingCharacteristicIndexes = [service.characteristics indexesOfObjectsPassingTest:^BOOL(CBCharacteristic *characteristic, NSUInteger idx, BOOL *stop) {
		return [characteristicUUIDs containsObject:characteristic.UUID];
	}];
	if (![matchingCharacteristicIndexes count]) return;
	
	self.characteristics = [service.characteristics objectsAtIndexes:matchingCharacteristicIndexes];
	for (CBCharacteristic *characteristic in self.characteristics)
	{
		if ([[self class] shouldPollForCharacteristic:characteristic])
		{
			[peripheral readValueForCharacteristic:characteristic];
		}
		else
		{
			[peripheral setNotifyValue:YES forCharacteristic:characteristic];
		}
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	//NSLog(@"%s %@ %@ %@", __PRETTY_FUNCTION__, peripheral, characteristic, error);
	if (error) return [self informDelegateOfError:error];
	
	//NSLog(@"New value for characteristic: %@", characteristic.value);
	[self receivedNewData:characteristic.value forCharacteristic:characteristic];
	
	if ([[self class] shouldPollForCharacteristic:characteristic])
	{
		[peripheral performSelector:@selector(readValueForCharacteristic:) withObject:characteristic afterDelay:0.01];
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	NSLog(@"%s %@ %@ %@", __PRETTY_FUNCTION__, peripheral, characteristic, error);
	if (error) return [self informDelegateOfError:error];
}

#pragma mark - Properties

- (void)setBluetoothPeripheral:(CBPeripheral *)peripheral
{
	if (peripheral != _bluetoothPeripheral)
	{
		_bluetoothPeripheral.delegate = nil;
		_bluetoothPeripheral = peripheral;
		_bluetoothPeripheral.delegate = self;
	}
}

@end
