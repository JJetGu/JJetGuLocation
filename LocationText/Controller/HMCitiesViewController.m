//
//  HMCitiesViewController.m
//  LocationText
//
//  Created by JJetGu on 15-4-2.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import "HMCitiesViewController.h"
#import "HMCityGroup.h"
#import "HMCity.h"
#import "HMCitySearchViewController.h"
#import "HMCityTableViewCell.h"

#import "HMRegion.h"
#import "HMMetaDataTool.h"
#import "HMSelectedCityTool.h"

#import <CoreLocation/CLLocationManagerDelegate.h>
#import "AFNetworking.h"

/** 城市定位失败提示 */
#define LocationFaileString @"定位失败，请点击加载"
/** 城市定位中提示 */
#define LocationingString @"定位..."

#define BAIDU_GEO_API @"http://api.map.baidu.com/geocoder"

@interface HMCitiesViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, HMCityTableViewCellDelegate,CLLocationManagerDelegate>
{
    NSMutableArray *_newCityGroups;
    NSMutableArray *_newTitleArray;
    NSArray *_locationCity;
}

@property (weak, nonatomic) IBOutlet UITableView *cityTableView;

- (IBAction)coverClick;
@property (weak, nonatomic) IBOutlet UIButton *cover;
- (IBAction)close;
/** 导航栏顶部的间距约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarTopLc;

/** 城市组数据 */
@property (strong, nonatomic) NSArray *cityGroups;
/** 城市搜索结果界面 */
@property (nonatomic, weak) HMCitySearchViewController *citySearchVc;
/** 定位 */
@property (nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation HMCitiesViewController

#pragma --mark 只加载一次
- (HMCitySearchViewController *)citySearchVc
{
    if (_citySearchVc == nil) {
        HMCitySearchViewController *citySearchVc = [[HMCitySearchViewController alloc] init];
        [self addChildViewController:citySearchVc];
        self.citySearchVc = citySearchVc;
    }
    return _citySearchVc;
}

- (NSArray *)cityGroups
{
    if (!_cityGroups) {
        self.cityGroups = [HMMetaDataTool sharedMetaDataTool].cityGroups;
    }
    return _cityGroups;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //城市名字
    NSMutableArray *tempCityGroups = [NSMutableArray array];
    _newCityGroups = [NSMutableArray arrayWithObjects:@"定位城市",@"最近访问城市", nil];
    for (HMCityGroup *group in self.cityGroups) {
        [tempCityGroups addObject:group];
    }
    [_newCityGroups addObjectsFromArray:tempCityGroups];
    //NSLog(@"%lu",(unsigned long)_newCityGroups.count);
    
    //tableView的索引
    _newTitleArray = [NSMutableArray arrayWithObjects:@"#",@"$", nil];
    [_newTitleArray addObjectsFromArray:[self.cityGroups valueForKeyPath:@"title"]];
    //NSLog(@"%lu",(unsigned long)_newTitleArray.count);
    
    //创建定位
    self.locationManager =[[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    //定位数组初始化
    _locationCity = [NSArray arrayWithObject:LocationingString];
}

- (IBAction)close {
    if ([HMSelectedCityTool selectedCity].name == nil) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择城市" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (self.isBeingDismissed) return;
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    [searchBar setShowsCancelButton:NO animated:YES];
    // 让整体向下挪动
    self.navBarTopLc.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        // 让遮盖慢慢消失
        self.cover.alpha = 0.0;
    }];
    
    searchBar.text = nil;
    // 移除城市搜索结果界面
    [self.citySearchVc.view removeFromSuperview];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    [searchBar setShowsCancelButton:YES animated:YES];
    // 让整体向上挪动
    self.navBarTopLc.constant = -62;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        // 让遮盖慢慢出来
        self.cover.alpha = 0.6;
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
}

/** 搜索框的文字发生改变的时候调用 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //当输入为空时移除
    [self.citySearchVc.view removeFromSuperview];
    
    if (searchText.length > 0) {
        [self.view addSubview:self.citySearchVc.view];
        
        //使用第三方autolayout把searchView显示到恰当的位置
        [self.citySearchVc.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.citySearchVc.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:searchBar];
        
        // 传递搜索条件
        self.citySearchVc.searchText = searchText;
    }
}

#pragma mark - 让控制器在formSheet情况下也能正常退出键盘
- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (IBAction)coverClick {
    [self.view endEditing:YES];
}

#pragma mark - 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _newCityGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section ==1 || section ==2) {
        return 1;
    }
    HMCityGroup *group = _newCityGroups[section];
    return group.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section ==2) {
        
        static NSString *myCityID = @"myCity";
        HMCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCityID];
        if (cell == nil) {
            cell = [[HMCityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCityID];
            cell.delegate = self;
        }
        if (indexPath.section == 0) {
            //定位城市
            cell.cityNames = _locationCity;
            
        } else if (indexPath.section == 1) {
            //最近访问城市
            cell.cityNames = [self cityNamesFromeUserDefault];
        } else {
            HMCityGroup *group = _newCityGroups[indexPath.section];
            cell.cityNames = group.cities;
        }
        return cell;
    } else {
        static NSString *cityID = @"city";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cityID];
        }
        HMCityGroup *group = _newCityGroups[indexPath.section];
        [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
        cell.textLabel.text = group.cities[indexPath.row];
        return cell;
    }
}

#pragma mark - 代理方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section ==1) {
        return _newCityGroups[section];
    }
    HMCityGroup *group = _newCityGroups[section];
    return group.title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _newTitleArray;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 54;
    } else if(indexPath.section == 2){
        return 210;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!(indexPath.section == 0 || indexPath.section == 1 || indexPath.section ==2)) {
        HMCityGroup *group = _newCityGroups[indexPath.section];
        NSString *cityName = group.cities[indexPath.row];
        HMCity *city = [[HMMetaDataTool sharedMetaDataTool] cityWithName:cityName];
        
        // 发出通知
        [self postNotificationWithCity:city];
    }
}

#pragma mark - 发出选中城市名字通知
-(void)postNotificationWithCity:(HMCity *)city
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //保存最近选中城市
    [self saveCityNameToUserDefault:city];
    
    [HMNotificationCenter postNotificationName:HMCityDidSelectNotification object:nil userInfo:@{HMSelectedCity : city}];
}


#pragma mark - HMCityTableViewCellDelegate
-(void)cityTableViewCell:(HMCityTableViewCell *)cityTableViewCell didClickLocationBtnTitle:(NSString *)title
{
    NSLog(@"定位城市：%@",title);
    if ([title isEqualToString:LocationFaileString] || [title isEqualToString:LocationingString]) {
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
        //刷新tableView
        _locationCity = @[LocationingString];
        [_cityTableView reloadData];
    } else {
        HMCity *city = [[HMMetaDataTool sharedMetaDataTool] cityWithName:title];
        // 发出通知
        [self postNotificationWithCity:city];
    }
}

-(void)cityTableViewCell:(HMCityTableViewCell *)cityTableViewCell didClickBtnTitle:(NSString *)title
{
    //NSLog(@"%@",title);
    HMCity *city = [[HMMetaDataTool sharedMetaDataTool] cityWithName:title];
    // 发出通知
    [self postNotificationWithCity:city];
}


#pragma mark ---CLLocationManagerDelegate---
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //刷新tableView
    _locationCity = [NSArray arrayWithObject:LocationFaileString];
    [_cityTableView reloadData];
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = manager.location;
    
    // 1.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"output"] = @"json";
    params[@"location"] = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
    
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr GET:BAIDU_GEO_API parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        if (dic) {
            if ([dic[@"status"] isEqualToString:@"OK"]) {
                NSString *cityName = dic[@"result"][@"addressComponent"][@"city"];
                //刷新tableView
                if ([cityName containsString:@"市"]) {
                    cityName = [cityName substringToIndex:cityName.length-1];
                }
                _locationCity = @[cityName];
                [_cityTableView reloadData];
                
                [self.locationManager stopUpdatingLocation];
                return;
            }
        }
        //刷新tableView
        _locationCity = [NSArray arrayWithObject:LocationFaileString];
        [_cityTableView reloadData];
        [self.locationManager stopUpdatingLocation];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.locationManager stopUpdatingLocation];
        //刷新tableView
        _locationCity = [NSArray arrayWithObject:LocationFaileString];
        [_cityTableView reloadData];
    }];
}


#pragma mark - 保存最近访问城市的名字
-(void)saveCityNameToUserDefault:(HMCity *)city
{
    NSMutableArray *cityNames = [self cityNamesFromeUserDefault];
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObject:city.name];
    [tempArray addObjectsFromArray:cityNames];
    cityNames = tempArray;
    for (int i = 1; i<cityNames.count; i++) {
        if ([cityNames[i] isEqualToString:city.name]) {
            [cityNames removeObject:cityNames[i]];
            [cityNames insertObject:city.name atIndex:0];
        }
    }
    if (cityNames.count > 3) {
        [cityNames removeLastObject];
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:cityNames forKey:HMKCityName];
    [user synchronize];
}

-(NSMutableArray *)cityNamesFromeUserDefault
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray *cityNames = [user objectForKey:HMKCityName];
    if (cityNames ==nil) {
        cityNames = [NSMutableArray array];
    }
    return cityNames;
}
@end
