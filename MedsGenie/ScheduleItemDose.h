//
//  ScheduleItemDose.h
//  PillOMat
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tray.h"
@interface ScheduleItemDose : NSObject
@property (nonatomic, strong) Tray *tray;
@property (nonatomic) NSUInteger pillsCount;
@end
