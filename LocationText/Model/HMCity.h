//
//  HMCity.h
//  LocationText
//
//  Created by JJetGu on 15-4-2.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMCity : NSObject<NSCoding>

/** 城市名称 */
@property (copy, nonatomic) NSString *name;
/** 区域 */
@property (strong, nonatomic) NSArray *regions;
/** 拼音 beijing */
@property (copy, nonatomic) NSString *pinYin;
/** 拼音首字母 bj */
@property (copy, nonatomic) NSString *pinYinHead;

@end
