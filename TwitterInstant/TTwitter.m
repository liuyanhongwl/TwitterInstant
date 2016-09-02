//
//  TTwitter.m
//  TwitterInstant
//
//  Created by Hong on 16/9/2.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "TTwitter.h"

@implementation TTwitter

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"twitterId" : @"id"
             };
}

@end
