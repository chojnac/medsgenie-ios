//
//  StorageDatasource.h
//  PillOMat
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StorageItem.h"
#import "ScheduleItemDose.h"

@interface StorageDatasource : NSObject
+ (instancetype)sharedDatasource;
-(NSInteger) numerOfTrays;
-(Tray *)trayAtIndex:(NSUInteger)idx;
-(StorageItem *)itemAtIndex:(NSUInteger)idx;
-(StorageItem *)itemForTray:(Tray *)tray;
-(void)updateStockFromDoses:(NSArray *)doses;
@end
