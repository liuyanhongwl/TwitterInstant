//
//  TwitterCell.m
//  TwitterInstant
//
//  Created by Hong on 16/9/2.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "TwitterCell.h"
#import "TwitterCellModel.h"
#import "Masonry.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


static CGFloat const margin_l = 15.0;
static CGFloat const margin_m = 10.0;
static CGFloat const margin_s = 5.0;
static CGFloat const avatar_size = 24.0;

@interface TwitterCell ()

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *screenName;
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, strong) UIButton *retweet;
@property (nonatomic, strong) UIButton *like;

@end

@implementation TwitterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupViews];
        
        [self bindViewModel];
        
    }
    return self;
}

- (void)setupViews
{
    __weak typeof (self) weakSelf = self;
    
    _avatar = [[UIImageView alloc] init];
    [self.contentView addSubview:self.avatar];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(weakSelf.contentView).offset(margin_m);
        make.top.mas_equalTo(weakSelf.contentView).offset(margin_m);
        make.width.mas_equalTo(weakSelf.avatar.mas_height);
        make.width.mas_equalTo(@(avatar_size));
    }];
    
    _name = [[UILabel alloc] init];
    [self.contentView addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(weakSelf.avatar.mas_trailing).offset(margin_s);
        make.top.mas_equalTo(weakSelf.avatar);
    }];
    
    _screenName = [[UILabel alloc] init];
    [self.contentView addSubview:self.screenName];
    [self.screenName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(weakSelf.name.mas_trailing).offset(margin_s);
        make.centerY.mas_equalTo(weakSelf.name);
    }];
    
    _text = [[UILabel alloc] init];
    self.text.numberOfLines = 0;
    [self.contentView addSubview:self.text];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(weakSelf.name);
        make.trailing.mas_lessThanOrEqualTo(weakSelf.contentView).offset(margin_m);
        make.top.mas_equalTo(weakSelf.name.mas_bottom).offset(margin_s);
    }];
    
    _retweet = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.retweet];
    [self.retweet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(weakSelf.name);
        make.top.mas_equalTo(weakSelf.text.mas_bottom).offset(margin_s);
    }];
    
    _like = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.like];
    [self.like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(weakSelf.retweet.mas_trailing).offset(margin_s);
        make.centerY.mas_equalTo(weakSelf.retweet);
    }];
}

- (void)bindViewModel
{
    RAC(self.avatar, image) = [self.viewModel signalForLoadImage];
    
    @weakify(self)
    
    [RACObserve(self, viewModel.like) subscribeNext:^(NSString *like) {
        @strongify(self)
        [self.like setTitle:like forState:UIControlStateNormal];
    }];
    
    [RACObserve(self, viewModel.retweet) subscribeNext:^(NSString *retweet) {
        @strongify(self)
        [self.retweet setTitle:retweet forState:UIControlStateNormal];
    }];
}

- (void)setViewModel:(TwitterCellModel *)viewModel
{
    _viewModel = viewModel;
    
    self.name.text = self.viewModel.name;
    self.screenName.text = self.viewModel.screenName;
    self.text.text = self.viewModel.text;
}

@end
