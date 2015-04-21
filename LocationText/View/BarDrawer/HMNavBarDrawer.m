//
//  HMNavBarDrawer.m
//  LocationText
//
//  Created by JJetGu on 15-4-14.
//  Copyright (c) 2015年 HM. All rights reserved.
//

#import "HMNavBarDrawer.h"
#import "HMChangeCity.h"

#define AppFrameWidth           [[UIScreen mainScreen] applicationFrame].size.width
#define CurrentVersion          [UIDevice currentDevice].systemVersion.floatValue


/** 滑动视图最大高度 */
static CGFloat const ScrollView_MaxHeight = 180.0f;

/** 抽屉视图高度 */
static CGFloat const NavBarDrawer_Height = 280.0f;

/** 抽屉视图透明度 */
static CGFloat const NavBarDrawer_Alpha = 1.0f;

/** 抽屉打开时黑色遮罩层透明度 */
static CGFloat const NavBarDrawer_MaskAlpha = 0.2f;

/** 抽屉视图打开及关闭动画的时长 */
static CGFloat const NavBarDrawer_Duration = 0.36f;


@interface HMNavBarDrawer ()<HMChangeCityDelegate>
{
    /** 背景遮罩 */
    UIControl *_mask;
}
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) HMChangeCity *changeCityView;
@end

@implementation HMNavBarDrawer

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if (self)
    {
        _isOpen = NO;
        
        //-- 遮罩层 view
        _mask = [[UIControl alloc] initWithFrame:view.bounds];
        _mask.backgroundColor = [UIColor blackColor];
        _mask.alpha = 0.0f;
        [_mask addTarget:self action:@selector(maskTapped) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_mask];
        
        self.frame = CGRectMake(0.f,
                                -NavBarDrawer_Height,
                                [[UIScreen mainScreen] applicationFrame].size.width,
                                NavBarDrawer_Height);
        
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        self.alpha = NavBarDrawer_Alpha;
        
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        self.layer.shadowRadius = 0.5f;
        self.layer.shadowOpacity = 0.8f;
        self.layer.masksToBounds = NO;
        
        [view addSubview:self];
        
        //-- 创建UIScrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        //-- 创建更换城市的View
        _changeCityView = [HMChangeCity changeCityView];
        _changeCityView.delegate = self;
        _changeCityView.backgroundView.layer.shadowColor = [UIColor grayColor].CGColor;
        _changeCityView.backgroundView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        _changeCityView.backgroundView.layer.shadowRadius = 0.3f;
        _changeCityView.backgroundView.layer.shadowOpacity = 0.3f;
        
    }
    return self;
}

-(void)setRegions:(NSArray *)regions
{
    _regions = regions;
    
    for (int i = 0; i<regions.count; i++) {
        UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cityBtn setTitleColor:[UIColor blackColor]];
        [cityBtn setBackgroundColor:[UIColor whiteColor]];
        [cityBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [cityBtn addTarget:self action:@selector(itemButtonPressed:)];
        [self.scrollView addSubview:cityBtn];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger subCount = self.scrollView.subviews.count;
    //按钮的frame
    float height = [self buttonsFrameWithCount:subCount];

    //根据区域的多少来确定相关控件的高度
    if (height > ScrollView_MaxHeight) {
        _scrollView.frame = (CGRect){{0,0},{self.width,ScrollView_MaxHeight}};
    } else {
        _scrollView.frame = (CGRect){{0,0},{self.width,height}};
    }
    _scrollView.contentSize = CGSizeMake(0, height);
    
    self.height = _scrollView.height + _changeCityView.height;
    
    _changeCityView.y = self.height - _changeCityView.height;
    [self addSubview:_changeCityView];
}

#pragma mark - 计算所有区域控件的frame
-(float)buttonsFrameWithCount:(NSUInteger)subCount
{
    float x = 20;
    float y = 10;
    float width = (self.width - x*4)/3.0;
    int heigthcount = 0;
    float count = subCount/3.0;
    int tempCount = (int)subCount/3;
    if (count>tempCount) {
        tempCount = tempCount+1;
    }
    int templConut =(int)subCount;
    int index = 0;
    int lcount = 0;
    for (int k = 0; k < tempCount; k++) {
        if (templConut>3) {
            templConut=templConut-3;
            lcount = 3;
        }else{
            lcount = templConut;
        }
        for (int l = 0; l < lcount; l++) {
            UIButton *child = self.scrollView.subviews[index];
            child.frame =  CGRectMake(0+x+(x+width)*l, y+(y+30)*heigthcount, width, 30);
            [child setTitle:_regions[index] forState:UIControlStateNormal];
            index++;
        }
        heigthcount++;
    }
    
    return  y+(y+30)*heigthcount;
}

#pragma mark - Public Methods
- (void)openNavBarDrawer
{
    [self.superview bringSubviewToFront:_mask];
    [self.superview bringSubviewToFront:self];
    
    _isOpen = YES;
    
    CGPoint centerPoint = CGPointMake((AppFrameWidth / 2), (self.height / 2.f));
    
    // 如果 7.0 以上系统则抽屉视图打开动画最终中点整体下移 64 pt
    if (CurrentVersion >= 7.0f)
    {
        centerPoint = CGPointMake((AppFrameWidth / 2), (self.height / 2.f) + 64);
    }
    
    [UIView animateWithDuration:NavBarDrawer_Duration animations:^{
        _mask.alpha = NavBarDrawer_MaskAlpha;
        self.center = centerPoint;
    }];
}

- (void)closeNavBarDrawer
{
    _isOpen = NO;
    
    [UIView animateWithDuration:NavBarDrawer_Duration
                     animations:^{
                         [self willCloseDrawer];
                         _mask.alpha = 0.f;
                         self.center = CGPointMake((AppFrameWidth / 2), -(self.height / 2.f));
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self closeActionFinished];
                         }
                     }];
}


#pragma mark - Action Methods

- (void)itemButtonPressed:(UIButton *)button
{
    if (nil != _delegate && [_delegate respondsToSelector:@selector(didTapButtonAtIndex:)])
    {
        [self closeNavBarDrawer];
        [_delegate didTapButtonAtIndex:button.currentTitle];
    }
}

- (void)willCloseDrawer
{
    if (nil != _delegate && [_delegate respondsToSelector:@selector(drawerWillClose)])
    {
        [_delegate drawerWillClose];
    }
}

- (void)closeActionFinished
{
    if (nil != _delegate && [_delegate respondsToSelector:@selector(drawerDidClose)])
    {
        [_delegate drawerDidClose];
    }
}

- (void)maskTapped
{
    [self closeNavBarDrawer];
    if (nil != _delegate && [_delegate respondsToSelector:@selector(didTapOnMask)])
    {
        [_delegate didTapOnMask];
    }
}

#pragma mark - HMChangeCityDelegate
-(void)didTapChangeButton:(HMChangeCity *)changeCity
{
    if (nil != _delegate && [_delegate respondsToSelector:@selector(didTapOnChangeCityView)])
    {
        [_delegate didTapOnChangeCityView];
    }
}

@end
