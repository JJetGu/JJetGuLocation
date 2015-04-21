//
//  HMRegion.m
//  LocationText
//
//  Created by JJetGu on 15-4-2.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import "HMRegion.h"

@implementation HMRegion

MJCodingImplementation

- (NSString *)title
{
    return self.name;
}

- (NSArray *)subtitles
{
    return self.subregions;
}
@end
