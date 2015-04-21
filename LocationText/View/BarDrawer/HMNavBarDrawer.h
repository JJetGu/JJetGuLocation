//
//  HMNavBarDrawer.h
//  LocationText
//
//  Created by JJetGu on 15-4-14.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 抽屉视图 代理协议 */
@protocol HMNavBarDrawerDelegate <NSObject>

@required
- (void)didTapButtonAtIndex:(NSString *)title;

@optional
/** 抽屉将要开始关闭 回调 */
- (void)drawerWillClose;

/** 抽屉完成关闭 回调 */
- (void)drawerDidClose;

/** 触摸背景遮罩动作 回调 */
- (void)didTapOnMask;

/** 更换按钮被点击时 */
-(void)didTapOnChangeCityView;

@end

@interface HMNavBarDrawer : UIView

@property(nonatomic, strong)NSArray *regions;
@property (nonatomic, assign) id <HMNavBarDrawerDelegate> delegate;
@property (nonatomic) BOOL isOpen;

- (id)initWithView:(UIView *)view;

/**
 * 打开抽屉
 */
- (void)openNavBarDrawer;

/**
 * 关闭抽屉
 */
- (void)closeNavBarDrawer;

@end
