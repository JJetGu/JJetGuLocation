//
//  HMCityTableViewCell.m
//  LocationText
//
//  Created by JJetGu on 15-4-13.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import "HMCityTableViewCell.h"

#define kCityButtonWidth 64
#define kCityButtonHeight 34

#define kCityButtonTopMargin 10
#define kCityButtonMargin 16

@implementation HMCityTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (int i = 0; i<11; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [btn setTitleColor:[UIColor blackColor]];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [self.contentView addSubview:btn];

        }
        
    }
    return self;
}

-(void)setCityNames:(NSArray *)cityNames
{
    _cityNames = cityNames;
    NSUInteger buttonCount = cityNames.count;
    NSUInteger subCount = self.contentView.subviews.count;
    
    for (int i = 0; i<subCount; i++) {
        UIButton *child = self.contentView.subviews[i];
        //只有一个城市名
        if (buttonCount ==1) {
            if (i== 0) {
                CGFloat cityButtonWidth = [self sizeString:cityNames[0] widthWithFont:[UIFont systemFontOfSize:12]];
                child.frame = CGRectMake(kCityButtonMargin, kCityButtonTopMargin, cityButtonWidth+33, kCityButtonHeight);
                [child addTarget:self action:@selector(locationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [child setTitle:cityNames[0] forState:UIControlStateNormal];
                
            } else {
                child.hidden = YES;
            }
            
        } else {
            if (i < cityNames.count) {
                int divide = (buttonCount == 4) ? 2 : 3;
                // 列数
                int column = i%divide;
                // 行数
                int row = i/divide;
                // 很据列数和行数算出x、y
                int childX = column * (kCityButtonWidth + kCityButtonMargin);
                int childY = row * (kCityButtonHeight + kCityButtonMargin);
                child.frame = CGRectMake(childX + kCityButtonMargin, childY + kCityButtonTopMargin, kCityButtonWidth, kCityButtonHeight);
                [child setTitle:cityNames[i] forState:UIControlStateNormal];
                [child addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                child.hidden = YES;
            }
            
        }
    }
    [self layoutIfNeeded];
}

-(void)locationBtnClick:(UIButton *)btn
{
    // NSLog(@"定位城市：%@",btn.currentTitle);
    if ([self.delegate respondsToSelector:@selector(cityTableViewCell:didClickLocationBtnTitle:)]) {
        [self.delegate cityTableViewCell:self didClickLocationBtnTitle:btn.currentTitle];
    }
}

- (void)selectedBtnClick:(UIButton *)btn
{
   // NSLog(@"%@",btn.currentTitle);
    if ([self.delegate respondsToSelector:@selector(cityTableViewCell:didClickBtnTitle:)]) {
        [self.delegate cityTableViewCell:self didClickBtnTitle:btn.currentTitle];
    }
}

-(CGFloat)sizeString:(NSString *)str widthWithFont:(UIFont *)font
{
    CGSize size;
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    size = [str sizeWithAttributes:@{NSFontAttributeName:font}];
#else
    size = [str sizeWithFont:font];
#endif
    return size.width;
}

@end
