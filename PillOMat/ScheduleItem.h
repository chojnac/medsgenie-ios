//
//  ScheduleItem.h
//  PillOMat
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tray.h"
#import "ScheduleItemDose.h"
@interface ScheduleItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *when;
@property (nonatomic, strong) NSArray *doses;
-(NSInteger)numerOfPills;
@end
