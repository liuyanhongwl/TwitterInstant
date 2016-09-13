//
//  DetailViewController.m
//  TwitterInstant
//
//  Created by Hong on 16/9/2.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "DetailViewController.h"
#import "TwitterCell.h"

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Property

- (void)setDatas:(NSArray *)datas
{
    _datas = datas;
    
    [self.tableView reloadData];
}

#pragma mark - Delegate
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwitterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TwitterCell class])];
    if (!cell) {
        cell = [[TwitterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([TwitterCell class])];
    }
    cell.viewModel = [self.datas objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

@end
