//
//  HMCity.m
//  LocationText
//
//  Created by JJetGu on 15-4-2.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import "HMCity.h"
#import "HMRegion.h"

@implementation HMCity

MJCodingImplementation

- (NSDictionary *)objectClassInArray
{
    return @{@"regions" : [HMRegion class]};
}

@end
