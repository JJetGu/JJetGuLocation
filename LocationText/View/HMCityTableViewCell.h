//
//  HMCityTableViewCell.h
//  LocationText
//
//  Created by JJetGu on 15-4-13.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMCityTableViewCell;

@protocol HMCityTableViewCellDelegate <NSObject>

@optional
-(void)cityTableViewCell:(HMCityTableViewCell *)cityTableViewCell didClickLocationBtnTitle:(NSString *)title;
-(void)cityTableViewCell:(HMCityTableViewCell *)cityTableViewCell didClickBtnTitle:(NSString *)title;
@end

@interface HMCityTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *cityNames;
@property (nonatomic, weak) id<HMCityTableViewCellDelegate>delegate;

@end
