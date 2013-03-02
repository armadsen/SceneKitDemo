//
//  ORSBluetoothLEScanner.h
//  DKBLE112 Demo
//
//  Created by Andrew Madsen on 1/7/13.
//  Copyright (c) 2013 Open Reel Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <CoreBluetooth/CoreBluetooth.h>
#else
#import <IOBluetooth/IOBluetooth.h>
#endif

typedef void(^ORSBluetoothLEScannerConnectionCompletionBlock)(NSError *error);

@interface ORSBluetoothLEScanner : NSObject <CBCentralManagerDelegate>

+ (id)sharedBluetoothLEScanner;

- (void)scanForDevicesAdvertisingServices:(NSArray *)services;

- (void)connectToPeripheral:(CBPeripheral *)peripheral
		withCompletionBlock:(ORSBluetoothLEScannerConnectionCompletionBlock)completionBlock;

@property (nonatomic, readonly, getter = isScanning) BOOL scanning;
@property (nonatomic, readonly, getter = isBluetoothEnabled) BOOL bluetoothEnabled;
@property (nonatomic, strong, readonly) NSSet *detectedPeripherals;

@end
