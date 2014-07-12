//
//  APIManager.m
//  MedsGenie
//
//  Created by Wojciech Chojnacki on 12.07.2014.
//  Copyright (c) 2014 Orta Systems. All rights reserved.
//

#import "APIManager.h"

#import <AFNetworking/AFNetworking.h>
@implementation APIManager

/**
 *  One pill from tray number
 *
 *  @param trays
 */
-(void)giveMeThePills:(NSArray *)trays success:(void (^)())success failuer:(APIResponseErrorBlock)failure {
    NSURL *url = [NSURL URLWithString:@"https://api.spark.io/v1/devices"];
    url = [url URLByAppendingPathComponent:SPARK_CORE_ID];
    url = [url URLByAppendingPathComponent:@"serve"];
    NSLog(@"url: %@", url);
    NSMutableString *str = [[NSMutableString alloc] init];
    for(NSNumber *n in trays) {
        if([str length]>0) [str appendString:@","];
        [str appendString:[NSString stringWithFormat:@"%i", [n integerValue]]];
    }
    NSDictionary *params = @ {@"access_token" :API_SECRET, @"args" :str };
    NSLog(@"pills from trays: %@",str);
    
    NSError *err = nil;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:[url absoluteString]
                                                                                parameters:params
                                                                                     error:&err];

    if(err) {
        if(failure) failure(nil, err);
        return;
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success) success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(operation.response.statusCode==401) {
            if(failure) failure(@"Invalid username or password", nil);
            return;
        }
        if(failure) failure(nil, error);
    }];
    
    [op start];
}
@end
