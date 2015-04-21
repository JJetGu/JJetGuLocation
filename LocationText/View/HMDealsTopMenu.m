//
//  HMDealsTopMenu.m
//  LocationText
//
//  Created by JJetGu on 15-4-2.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import "HMDealsTopMenu.h"

@interface HMDealsTopMenu()
@end

@implementation HMDealsTopMenu

+ (instancetype)menu
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HMDealsTopMenu" owner:nil options:nil] lastObject];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
#warning 禁止默认的拉伸现象
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self.imageButton addTarget:target action:action];
}
@end
