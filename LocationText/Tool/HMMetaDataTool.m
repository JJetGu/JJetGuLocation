//
//  HMMetaDataTool.m
//  LocationText
//
//  Created by JJetGu on 15-4-2.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import "HMMetaDataTool.h"
#import "HMCity.h"
#import "HMCityGroup.h"

@interface HMMetaDataTool()
{
    /** 所有的城市 */
    NSArray *_cities;
    /** 所有的城市组 */
    NSArray *_cityGroups;
}
@end

@implementation HMMetaDataTool
HMSingletonM(MetaDataTool)

- (NSArray *)cityGroups
{
    if (!_cityGroups) {
        _cityGroups = [HMCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    }
    return _cityGroups;
}

- (NSArray *)cities
{
    if (!_cities) {
        _cities = [HMCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}


- (HMCity *)cityWithName:(NSString *)name
{
    if (name.length == 0) return nil;
    
    for (HMCity *city in self.cities) {
        if ([city.name isEqualToString:name]) return city;
    }
    return nil;
}

@end
