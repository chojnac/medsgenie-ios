//
//  ScheduleItem.m
//  MedsGenie
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import "ScheduleItem.h"

@implementation ScheduleItem
-(NSInteger)numerOfPills {
    NSInteger count = 0;
    for(ScheduleItemDose *dose in self.doses) {
        count += dose.pillsCount;
    }
    return count;
}
@end
