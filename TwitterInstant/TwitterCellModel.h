//
//  TwitterCellModel.h
//  TwitterInstant
//
//  Created by Hong on 16/9/2.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTwitter;
@class RACSignal;

@interface TwitterCellModel : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *screenName;
@property (nonatomic, copy, readonly) NSString *imageUrl;
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, copy) NSString *retweet;
@property (nonatomic, copy) NSString *like;

- (instancetype)initWithTwitter:(TTwitter *)twitter;

- (RACSignal *)signalForLoadImage;

@end
