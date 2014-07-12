//
//  ScheduleDatasoure.m
//  PillOMat
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import "ScheduleDatasoure.h"

@interface ScheduleDatasoure ()
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation ScheduleDatasoure

+ (instancetype)sharedDatasource{
    static ScheduleDatasoure *sharedDatasource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDatasource = [[self alloc] init];
    });
    return sharedDatasource;
}

-(NSInteger)numerOfItems {
    return [self.items count];
}

-(ScheduleItem *)itemAtIndex:(NSUInteger)idx {
    return  [self.items objectAtIndex:idx];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.items = [NSMutableArray array];

        {
            ScheduleItem *item = [ScheduleItem new];
            item.name = @"Morning pills";
            item.when = @"Everyday at 9:00AM";
            ScheduleItemDose *dose1 = [ScheduleItemDose new];
            dose1.tray = [[Tray avaliableTrays] objectAtIndex:0];
            dose1.pillsCount = 1;
            ScheduleItemDose *dose2 = [ScheduleItemDose new];
            dose2.tray = [[Tray avaliableTrays] objectAtIndex:3];
            dose2.pillsCount = 1;
            item.doses = @[dose1, dose2];
            
            [self.items addObject:item];
        }
        
        {
            ScheduleItem *item = [ScheduleItem new];
            item.name = @"Midday pills";
            item.when = @"Everyday at 12:00PM";
            ScheduleItemDose *dose1 = [ScheduleItemDose new];
            dose1.tray = [[Tray avaliableTrays] objectAtIndex:1];
            dose1.pillsCount = 1;
            item.doses = @[dose1];
            [self.items addObject:item];
        }
        
        {
            ScheduleItem *item = [ScheduleItem new];
            item.name = @"Sleep pills";
            item.when = @"Everyday at 8:00PM";
            ScheduleItemDose *dose1 = [ScheduleItemDose new];
            dose1.tray = [[Tray avaliableTrays] objectAtIndex:2];
            dose1.pillsCount = 1;
            ScheduleItemDose *dose2 = [ScheduleItemDose new];
            dose2.tray = [[Tray avaliableTrays] objectAtIndex:3];
            dose2.pillsCount = 1;
            item.doses = @[dose1, dose2];
            [self.items addObject:item];
        }
        
    }
    return self;
}
@end
