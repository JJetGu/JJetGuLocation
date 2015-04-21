//
//  HMCitySearchViewController.m
//  LocationText
//
//  Created by JJetGu on 15-4-2.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import "HMCitySearchViewController.h"
#import "HMCity.h"

@interface HMCitySearchViewController ()
@property (nonatomic, strong) NSArray *resultCities;
@end

@implementation HMCitySearchViewController

- (void)setSearchText:(NSString *)searchText
{
    _searchText = [searchText copy];
    
    // 根据搜索条件进行过滤
    NSArray *allCities = [HMMetaDataTool sharedMetaDataTool].cities;
    
    // 将搜索条件转为小写
    NSString *lowerSearchText = searchText.lowercaseString;
    
//    NSPredicate * 预言\过滤器\谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name.lowercaseString contains %@ or pinYin.lowercaseString contains %@ or pinYinHead.lowercaseString contains %@", lowerSearchText, lowerSearchText, lowerSearchText];
    self.resultCities = [allCities filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    HMCity *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}

#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共有%lu个搜索结果", (unsigned long)self.resultCities.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 发出通知
    HMCity *city = self.resultCities[indexPath.row];
    [HMNotificationCenter postNotificationName:HMCityDidSelectNotification object:nil userInfo:@{HMSelectedCity : city}];
}
@end
