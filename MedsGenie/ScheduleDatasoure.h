//
//  ScheduleDatasoure.h
//  MedsGenie
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleItem.h"
#import "Tray.h"

@interface ScheduleDatasoure : NSObject
+ (instancetype)sharedDatasource;
-(NSInteger)numerOfItems;
-(ScheduleItem *)itemAtIndex:(NSUInteger)idx;
@end
