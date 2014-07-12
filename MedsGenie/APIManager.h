//
//  APIManager.h
//  MedsGenie
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef  void (^APIResponseErrorBlock)(NSString *errorMessage, NSError *error);

@interface APIManager : NSObject
-(void)giveMeThePills:(NSArray *)trays success:(void (^)())success failuer:(APIResponseErrorBlock)failure ;
@end
