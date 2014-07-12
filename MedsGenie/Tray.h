//
//  Tray.h
//  MedsGenie
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tray : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger number;
-(instancetype)initWithNumber:(NSInteger )numer name:(NSString *)name;
+(NSArray *)avaliableTrays;
@end
