//
//  HMDealsTopMenu.h
//  LocationText
//
//  Created by JJetGu on 15-4-2.
//  Copyright (c) 2015年 HM. All rights reserved.
//  团购列表顶部菜单

#import <UIKit/UIKit.h>

@interface HMDealsTopMenu : UIView
+ (instancetype)menu;

- (void)addTarget:(id)target action:(SEL)action;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@end
