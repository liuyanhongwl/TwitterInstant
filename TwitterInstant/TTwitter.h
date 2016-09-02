//
//  TTwitter.h
//  TwitterInstant
//
//  Created by Hong on 16/9/2.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "YYModel.h"
@class TUser;

@interface TTwitter : NSObject

@property (nonatomic, copy) NSString *twitterId;
@property (nonatomic, strong) TUser *user;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSUInteger favorite_count;
@property (nonatomic, assign) NSUInteger retweet_count;

@end
