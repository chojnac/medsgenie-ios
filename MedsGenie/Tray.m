//
//  Tray.m
//  MedsGenie
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import "Tray.h"

@implementation Tray

+(NSArray *)avaliableTrays {
    static NSArray *trays;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        trays = @[
                  [[Tray alloc] initWithNumber:0 name:@"Tray 1"],
                  [[Tray alloc] initWithNumber:1 name:@"Tray 2"],
                  [[Tray alloc] initWithNumber:2 name:@"Tray 3"],
                  [[Tray alloc] initWithNumber:3 name:@"Tray 4"],
                  ];
    });
    return trays;
}


-(instancetype)initWithNumber:(NSInteger )numer name:(NSString *)name {
    self = [super init];
    if(self) {
        self.name = name;
        self.number = numer;
    }
    return self;
}


@end
