//
//  TwitterCellModel.m
//  TwitterInstant
//
//  Created by Hong on 16/9/2.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "TwitterCellModel.h"
#import "TTwitter.h"
#import "TUser.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UIKit/UIImage.h>

@implementation TwitterCellModel

- (instancetype)initWithTwitter:(TTwitter *)twitter
{
    self = [super init];
    if (self) {
        _name = [twitter.user.name copy];
        _screenName = [twitter.user.screen_name copy];
        _imageUrl = [twitter.user.profile_image_url_https copy];
        _text = [twitter.text copy];
        _retweet = [@"retweet" stringByAppendingString:twitter.retweet_count > 0 ? [NSString stringWithFormat:@"%ld", twitter.retweet_count] : @""];
        _like = [@"like" stringByAppendingString:twitter.favorite_count > 0 ? [NSString stringWithFormat:@"%ld", twitter.favorite_count] : @""];
        
    }
    return self;
}

- (RACSignal *)signalForLoadImage
{
    @weakify(self)
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        @strongify(self)
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        [subscriber sendNext:image];
        [subscriber sendCompleted];
        
        return nil;
    }] subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]];
}

@end
