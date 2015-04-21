//
//  HMSelectedCityTool.h
//  DianXunTong
//
//  Created by JJetGu on 15-4-16.
//  Copyright (c) 2015年 mac iko. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMCity;

@interface HMSelectedCityTool : NSObject

+ (void)addSelectedCity:(HMCity *)city;

+ (HMCity *)selectedCity;

@end
