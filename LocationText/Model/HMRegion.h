//
//  HMRegion.h
//  LocationText
//
//  Created by JJetGu on 15-4-2.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMRegion : NSObject<NSCoding>
/** 区域名称 */
@property (copy, nonatomic) NSString *name;
/** 子区域 */
@property (strong, nonatomic) NSArray *subregions;
@end
