//
//  StorageItem.h
//  MedsGenie
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tray.h"
#import "ScheduleItemDose.h"

@interface StorageItem : NSObject
@property (nonatomic, strong) Tray *tray;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSUInteger pillsCount;
@end
