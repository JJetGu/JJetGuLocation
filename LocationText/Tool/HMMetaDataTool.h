//
//  HMMetaDataTool.h
//  LocationText
//
//  Created by JJetGu on 15-4-2.
//  Copyright (c) 2015年 HM. All rights reserved.
//  管理所有的元数据

#import <Foundation/Foundation.h>
#import "HMSingleton.h"
@class HMCity;

@interface HMMetaDataTool : NSObject
HMSingletonH(MetaDataTool)

/**
 *  所有的城市
 */
@property (strong, nonatomic, readonly) NSArray *cities;
/**
 *  所有的城市组
 */
@property (strong, nonatomic, readonly) NSArray *cityGroups;

- (HMCity *)cityWithName:(NSString *)name;

@end
