//
//  ORSBluetoothBoardViewController.h
//  DKBLE112 Demo
//
//  Created by Andrew Madsen on 1/8/13.
//  Copyright (c) 2013 Open Reel Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <CoreBluetooth/CoreBluetooth.h>
#else
#import <IOBluetooth/IOBluetooth.h>
#endif

extern NSString * const ORSBluetoothBoardPeripheralUUIDString;

extern NSString * const ORSBluetoothBoardCableReplacementType;
extern NSString * const ORSBluetoothBoardCableReplacementServiceUUIDString;
extern NSString * const ORSBluetoothBoardCableReplacementCharacteristicUUIDString;

extern NSString * const ORSBluetoothBoardAccelerometerType;
extern NSString * const ORSBluetoothBoardAccelerometerServiceUUIDString;
extern NSString * const ORSBluetoothBoardAccelerometerXCharacteristicUUIDString;
extern NSString * const ORSBluetoothBoardAccelerometerYCharacteristicUUIDString;
extern NSString * const ORSBluetoothBoardAccelerometerZCharacteristicUUIDString;

@protocol ORSBluetoothBoardDelegate;

@interface ORSBluetoothBoard : NSObject <CBPeripheralDelegate>

+ (instancetype)boardWithPeripheral:(CBPeripheral *)peripheral;

- (void)sendData:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic;

@property (nonatomic, weak) id<ORSBluetoothBoardDelegate>delegate;
@property (nonatomic, strong) CBPeripheral *bluetoothPeripheral;
@property (nonatomic, copy, readonly) NSArray *characteristics;

// For subclasses to override

+ (CBUUID *)serviceUUID;
+ (NSArray *)characteristicUUIDs;
+ (BOOL)shouldPollForCharacteristic:(CBCharacteristic *)characteristic;

- (void)receivedNewData:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic;

@end

@protocol ORSBluetoothBoardDelegate <NSObject>

- (void)bluetoothBoard:(ORSBluetoothBoard *)board didEncounterError:(NSError *)error;

@end