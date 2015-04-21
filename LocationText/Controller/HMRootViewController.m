//
//  HMRootViewController.m
//  LocationText
//
//  Created by JJetGu on 15-4-2.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import "HMRootViewController.h"
#import "HMDealsTopMenu.h"
#import "HMCitiesViewController.h"
#import "HMCity.h"
#import "HMRegion.h"
#import "HMNavBarDrawer.h"
#import "HMSelectedCityTool.h"

@interface HMRootViewController ()<HMNavBarDrawerDelegate>
/** 区域菜单 */
@property (weak, nonatomic) HMDealsTopMenu *regionMenu;
/** 选中的城市 */
@property (nonatomic, strong) HMCity *selectedCity;
/** 区域下拉菜单 */
@property (strong, nonatomic) HMNavBarDrawer *drawerView;

@end

@implementation HMRootViewController

-(HMNavBarDrawer *)drawerView
{
    if (!_drawerView) {
        self.drawerView = [[HMNavBarDrawer alloc]initWithView:self.view];
        self.drawerView.delegate = self;
        if ([HMSelectedCityTool selectedCity] !=nil) {
            NSArray *regions = [HMSelectedCityTool selectedCity].regions;
            //当前选中城市的区域名字
            NSMutableArray *regionsStr = [NSMutableArray array];
            for (HMRegion *region in regions) {
                [regionsStr addObject:region.name];
            }
            self.drawerView.regions = regionsStr;
        }
    }
    return _drawerView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.drawerView = nil;
    
    //没有选择城市时，直接进入到城市选择页面
    if ([HMSelectedCityTool selectedCity].name == nil) {
        HMCitiesViewController *citiesVc = [[HMCitiesViewController alloc] init];
        citiesVc.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:citiesVc animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 监听通知
    [self setupNotifications];

    // 设置导航栏左边的内容
    [self setupNavLeft];
    
    
}

#pragma mark - 通知处理
/** 监听通知 */
- (void)setupNotifications
{
    HMAddObsver(cityDidSelect:, HMCityDidSelectNotification);
}

- (void)dealloc
{
    HMRemoveObsver;
}

- (void)cityDidSelect:(NSNotification *)note
{
    // 取出通知中的数据
    self.selectedCity = note.userInfo[HMSelectedCity];
    //写入沙盒
    [HMSelectedCityTool addSelectedCity:self.selectedCity];
    //显示当前选中的城市名字
    self.regionMenu.titleLabel.text = [NSString stringWithFormat:@"%@ - 全部", self.selectedCity.name];
    self.regionMenu.subtitleLabel.text = nil;
    // 加载最新的数据
    [self loadNewDeals];
}

#pragma mark - 刷新数据
-(void)loadNewDeals
{
    
}


#pragma mark - 设置导航栏
/**
 *  设置导航栏左边的内容
 */
- (void)setupNavLeft
{
    HMDealsTopMenu *regionMenu = [HMDealsTopMenu menu];
    [regionMenu addTarget:self action:@selector(regionMenuClick)];
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc] initWithCustomView:regionMenu];
    self.regionMenu = regionMenu;
    
    self.navigationItem.leftBarButtonItem = regionItem;
    
    //显示当前选中的城市名字以及区域
    self.regionMenu.titleLabel.text = [HMSelectedCityTool selectedCity].name;
    self.regionMenu.subtitleLabel.text = [self selectedRegionFromeUserDefault];
}

/** 区域菜单 */
- (void)regionMenuClick
{
    // 下拉抽屉如果是关，则开
    if (self.drawerView.isOpen){
        [self.drawerView closeNavBarDrawer];
    } else {
        [self.drawerView openNavBarDrawer];
    }
}

#pragma mark - HMNavBarDrawerDelegate
-(void)didTapButtonAtIndex:(NSString *)title
{
    NSLog(@"按钮_%@_被点击",title);
    self.regionMenu.titleLabel.text = [HMSelectedCityTool selectedCity].name;
    
    [self saveToUserDefaultWithSelectedRegion:title];
    self.regionMenu.subtitleLabel.text = [self selectedRegionFromeUserDefault];
}

-(void)didTapOnChangeCityView
{
    NSLog(@"推送到选择城市页面");
    
    //关闭下拉抽屉
    [self.drawerView closeNavBarDrawer];
    
    //推送到选择城市页面
    HMCitiesViewController *citiesVc = [[HMCitiesViewController alloc] init];
    citiesVc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:citiesVc animated:YES completion:nil];
}

#pragma mark - 保存选择的区域到系统编号
/** 存入当前的区域*/
-(void)saveToUserDefaultWithSelectedRegion:(NSString *)selectedRegion{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:selectedRegion forKey:HMKSelectedCityName];
    [user synchronize];
}

/** 从系统编号取出当前的区域*/
-(NSString *)selectedRegionFromeUserDefault
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *regionName = [user objectForKey:HMKSelectedCityName];
    return regionName;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
