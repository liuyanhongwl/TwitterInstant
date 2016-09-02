//
//  TUser.h
//  TwitterInstant
//
//  Created by Hong on 16/9/2.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "YYModel.h"

@interface TUser : NSObject

@property (nonatomic, copy) NSString *screen_name;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *profile_image_url_https;
@property (nonatomic, copy) NSString *time_zone;

@end
