//
//  ORSBluetoothLEScanner.m
//  DKBLE112 Demo
//
//  Created by Andrew Madsen on 1/7/13.
//  Copyright (c) 2013 Open Reel Software. All rights reserved.
//

#import "ORSBluetoothLEScanner.h"

static ORSBluetoothLEScanner *sharedBluetoothLEScanner;

@interface ORSBluetoothLEScanner ()

@property (nonatomic, readwrite, getter = isScanning) BOOL scanning;
@property (nonatomic, readwrite, getter = isBluetoothEnabled) BOOL bluetoothEnabled;
@property (nonatomic, copy) NSMutableSet *internalDetectedPeripherals;
- (void)addInternalDetectedPeripheral:(id)anInternalDetectedPeripheral;
- (void)removeInternalDetectedPeripheral:(id)anInternalDetectedPeripheral;

@property (nonatomic, strong) CBCentralManager *centralManager;

@property (nonatomic, strong) CBPeripheral *connectingPeripheral;
@property (nonatomic, copy) ORSBluetoothLEScannerConnectionCompletionBlock connectCompletionBlock;

@end

@implementation ORSBluetoothLEScanner

+ (id)sharedBluetoothLEScanner;
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedBluetoothLEScanner = [[self alloc] init];
	});
	
	return sharedBluetoothLEScanner;	
}

- (id)init
{
    self = [super init];
    if (self)
	{
		self.internalDetectedPeripherals = [[NSMutableSet alloc] init];
		self.bluetoothEnabled = self.centralManager.state == CBCentralManagerStatePoweredOn;
    }
    return self;
}

- (void)scanForDevicesAdvertisingServices:(NSArray *)services;
{
	[[self mutableSetValueForKey:@"internalDetectedPeripherals"] removeAllObjects];
	
	[self.centralManager scanForPeripheralsWithServices:services options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO}];
	self.scanning = YES;
	
	// Stop scanning after 5 seconds
	[self performSelector:@selector(stopScanning) withObject:nil afterDelay:5.0];
}

- (void)connectToPeripheral:(CBPeripheral *)peripheral
		withCompletionBlock:(ORSBluetoothLEScannerConnectionCompletionBlock)completionBlock;
{
	self.connectingPeripheral = peripheral;
	self.connectCompletionBlock = completionBlock;
	[self.centralManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey : @YES}];
}

- (void)stopScanning
{
	[self.centralManager stopScan];
	self.scanning = NO;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
	NSLog(@"%s %ld", __PRETTY_FUNCTION__, central.state);
	if (central.state == CBCentralManagerStatePoweredOn) self.bluetoothEnabled = YES;
	if (central.state == CBCentralManagerStatePoweredOff) self.bluetoothEnabled = NO;
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)newPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
	NSLog(@"%s %@ %@ %@", __PRETTY_FUNCTION__, newPeripheral, advertisementData, RSSI);
	NSString *UUIDString = CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, newPeripheral.UUID));
	NSSet *existingPeripherals = [self.internalDetectedPeripherals objectsPassingTest:^BOOL(CBPeripheral *eachPeripheral, BOOL *stop) {
		NSString *eachUUIDString = CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, eachPeripheral.UUID));
		return [eachUUIDString isEqualToString:UUIDString];
	}];
	NSMutableSet *mutableInternalPeripherals = [self mutableSetValueForKey:@"internalDetectedPeripherals"];
	for (CBPeripheral *peripheral in existingPeripherals) { [mutableInternalPeripherals removeObject:peripheral]; }
	[self addInternalDetectedPeripheral:newPeripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	if (self.connectingPeripheral != peripheral) return;
	if (self.connectCompletionBlock) self.connectCompletionBlock(nil);
	self.connectingPeripheral = nil;
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	NSLog(@"Unable to connect to Bluetooth peripheral %@: %@", peripheral, error);
	if (self.connectCompletionBlock) self.connectCompletionBlock(error);
	self.connectingPeripheral = nil;
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, peripheral, error);
}

#pragma mark - Properties

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"detectedPeripherals"])
	{
		keyPaths = [keyPaths setByAddingObject:@"internalDetectedPeripherals"];
	}
	
	return keyPaths;
}

@synthesize internalDetectedPeripherals = _internalDetectedPeripherals;

- (void)setInternalDetectedPeripherals:(NSMutableSet *)pers
{
	if (pers != _internalDetectedPeripherals)
	{
		_internalDetectedPeripherals = [pers mutableCopy];
	}
}

- (void)addInternalDetectedPeripheral:(CBPeripheral *)internalDetectedPeripheral
{
	id internalPers = self.internalDetectedPeripherals;
    [internalPers addObject:internalDetectedPeripheral];
}

- (void)removeInternalDetectedPeripheral:(CBPeripheral *)internalDetectedPeripheral
{
    [self.internalDetectedPeripherals removeObject:internalDetectedPeripheral];
}

- (NSSet *)detectedPeripherals
{
	return [self.internalDetectedPeripherals copy];
}

- (CBCentralManager *)centralManager
{
	if (!_centralManager)
	{
		_centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
	}
	return _centralManager;
}

@end
