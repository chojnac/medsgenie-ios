//
//  StorageDatasource.m
//  MedsGenie
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import "StorageDatasource.h"

@interface StorageDatasource ()
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation StorageDatasource

+ (instancetype)sharedDatasource{
    static StorageDatasource *sharedDatasource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDatasource = [[self alloc] init];
    });
    return sharedDatasource;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.items = [NSMutableArray array];
        NSArray *pillNames = @[@"Red pill", @"Green pill", @"Blue pill", @"Yellow pill"];
        int i =0;
        for(Tray *tray in [Tray avaliableTrays]) {
            StorageItem *item = [[StorageItem alloc] init];
            item.tray = tray;
            item.name = [pillNames objectAtIndex:i];
            item.pillsCount = 5;
            [self.items addObject:item];
            i++;
        }
    }
    return self;
}
-(NSInteger) numerOfTrays {
    return [[Tray avaliableTrays] count];
}

-(Tray *)trayAtIndex:(NSUInteger)idx {
    return [[Tray avaliableTrays] objectAtIndex:idx];
}
-(StorageItem *)itemAtIndex:(NSUInteger)idx {
    return [_items objectAtIndex:idx];
}

-(StorageItem *)itemForTray:(Tray *)tray  {
    __block StorageItem *res = nil;
    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        StorageItem *item = obj;
        if([item.tray isEqual:tray]) {
            res = item;
            *stop = YES;
        }
    }];
    return res;
}

-(void)updateStockFromDoses:(NSArray *)doses {
    for(ScheduleItemDose *dose in doses) {
        StorageItem *item = [self itemForTray:dose.tray];
        if(item.pillsCount<dose.pillsCount) item.pillsCount = 0;
        else item.pillsCount -= dose.pillsCount;
    }
}
@end
