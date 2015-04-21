//
//  HMChangeCity.m
//  LocationText
//
//  Created by JJetGu on 15-4-15.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import "HMChangeCity.h"
#import "HMCity.h"
#import "HMSelectedCityTool.h"

@implementation HMChangeCity

+(instancetype)changeCityView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HMChangeCity" owner:nil options:nil] lastObject];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
     [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [_backgroundView addGestureRecognizer:singleTapGestureRecognizer];
    
    //从系统编号中取出选中区域的名字
    self.cityName.text = [HMSelectedCityTool selectedCity].name;
    
}

- (IBAction)changeCityAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTapChangeButton:)]) {
        [self.delegate didTapChangeButton:self];
    }
}

- (void)singleTap:(UIGestureRecognizer*)gestureRecognizer
{
    _backgroundView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:
            [self recognizerStateEndedAction];
            break;
        default:
            break;
    }
}

-(void)recognizerStateEndedAction{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _backgroundView.backgroundColor = [UIColor whiteColor];
    });
    
    if ([self.delegate respondsToSelector:@selector(didTapChangeButton:)]) {
        [self.delegate didTapChangeButton:self];
    }
}
@end
