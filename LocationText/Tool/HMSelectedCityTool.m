//
//  HMSelectedCityTool.m
//  DianXunTong
//
//  Created by JJetGu on 15-4-16.
//  Copyright (c) 2015年 mac iko. All rights reserved.
//

#import "HMSelectedCityTool.h"

#define SelectedCityPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selectedCity.archive"]

@implementation HMSelectedCityTool

+(void)addSelectedCity:(HMCity *)city
{
    [NSKeyedArchiver archiveRootObject:city toFile:SelectedCityPath];
}

+(HMCity *)selectedCity
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:SelectedCityPath];
}

@end
