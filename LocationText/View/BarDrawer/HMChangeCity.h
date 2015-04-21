//
//  HMChangeCity.h
//  LocationText
//
//  Created by JJetGu on 15-4-15.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMChangeCity;

@protocol HMChangeCityDelegate <NSObject>

@optional
- (void)didTapChangeButton:(HMChangeCity *)changeCity;

@end


@interface HMChangeCity : UIView

@property (nonatomic, weak)id<HMChangeCityDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UILabel *cityName;

+ (instancetype)changeCityView;

@end
