//
//  MasterViewController.m
//  TwitterInstant
//
//  Created by Hong on 16/9/2.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "TwitterCellModel.h"
#import "Masonry.h"
#import "EXTScope.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "TTwitter.h"

@interface MasterViewController()

@property (nonatomic, copy) NSArray *datas;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) ACAccountType *accountType;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.title = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleExecutable"];
    
    __weak typeof(self) weakSelf = self;
    
    _searchField = [[UITextField alloc] init];
    self.searchField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.searchField];
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(weakSelf.view).offset(15);
        make.centerX.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view).offset(15);
        make.height.mas_equalTo(@44);
    }];
    
    _accountStore = [[ACAccountStore alloc] init];
    _accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    @weakify(self)
    [[[[[[[[[self requestAccessToTwitterSignal] then:^RACSignal *{
        @strongify(self)
        return self.searchField.rac_textSignal;
    }] filter:^BOOL(NSString *text) {
        @strongify(self)
        return [self isValidSearchText:text];
    }] throttle:0.5]
      flattenMap:^RACStream *(NSString *text) {
        @strongify(self)
        return [self requestForTwitterSearchWithText:text];
    }] flattenMap:^RACStream *(NSDictionary *jsonD) {
        @strongify(self)
        return [self convertDictionarySignal:jsonD];
    }] flattenMap:^RACStream *(NSArray *twitters) {
        @strongify(self)
        return [self convertViewModelSignal:twitters];
    }] deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSArray *twitterViewModels) {
        
         @strongify(self)
         DetailViewController *vc = [[DetailViewController alloc] init];
         vc.datas = twitterViewModels;
         UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
         [self.splitViewController showDetailViewController:navi sender:nil];
         
    } error:^(NSError *error) {
        NSLog(@"error : %@", error);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:tap];
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self)
        [self.view endEditing:YES];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Help

- (BOOL)isValidSearchText:(NSString *)text
{
    static NSString *preText = nil;
    if ([preText isEqualToString:text]) {
        return NO;
    }
    preText = text;
    return text.length > 3;;
}

#pragma mark - Signal

- (RACSignal *)requestAccessToTwitterSignal
{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       @strongify(self)
        
        [self.accountStore requestAccessToAccountsWithType:self.accountType options:nil completion:^(BOOL granted, NSError *error) {
            if (granted) {
                [subscriber sendNext:@(granted)];
                [subscriber sendCompleted];
            }else{
                [subscriber sendError:[NSError errorWithDomain:@"twitter-denied" code:1 userInfo:nil]];
            }
        }];
        
        return nil;
    }];
}

- (RACSignal *)requestForTwitterSearchWithText:(NSString *)text
{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
        
        NSDictionary *params = @{
                                 @"q" : text
                                 };
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
        
        NSArray *accounts = [self.accountStore accountsWithAccountType:self.accountType];
        
        if (accounts.count == 0) {
            [subscriber sendError:[NSError errorWithDomain:@"twitter-non-account" code:2 userInfo:nil]];
        }else{
            ACAccount *account = accounts.lastObject;
            [request setAccount:account];
            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (urlResponse.statusCode == 200) {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    
                    NSLog(@"json : %@", json);
                    
                    [subscriber sendNext:json];
                    [subscriber sendCompleted];
                    
                }else{
                    [subscriber sendError:[NSError errorWithDomain:@"twitter-response-error" code:3 userInfo:nil]];
                }
            }];
        }
        
        return nil;
    }];
}

- (RACSignal *)convertDictionarySignal:(NSDictionary *)jsonD
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        NSArray *statuses = [jsonD objectForKey:@"statuses"];
        NSMutableArray *results = [NSMutableArray array];
        RACSequence *sequence = [statuses rac_sequence];
        [sequence.signal subscribeNext:^(NSDictionary *tweetJson) {
            TTwitter *twitter = [TTwitter yy_modelWithJSON:tweetJson];
            if (twitter) {
                [results addObject:twitter];
            }
        } completed:^{
            [subscriber sendNext:results];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *)convertViewModelSignal:(NSArray <TTwitter *>*)twitters
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSMutableArray *results = [NSMutableArray array];
        RACSequence *sequence = [twitters rac_sequence];
        [sequence.signal subscribeNext:^(TTwitter *twitter) {
            TwitterCellModel *vm = [[TwitterCellModel alloc] initWithTwitter:twitter];
            if (vm) {
                [results addObject:vm];
            }
        } completed:^{
            [subscriber sendNext:results];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

@end
