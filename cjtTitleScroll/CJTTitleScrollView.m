//
//  TitleScrollView.m
//  @author 陈晋添
//
//  Created by jkc on 16/7/14.
//  Copyright © 2016年 cjt. All rights reserved.
//

#import "CJTTitleScrollView.h"

@interface CJTTitleScrollView ()

@property (nonatomic, strong) UILabel *linelabel;               //底部line
@property (nonatomic, assign) NSInteger ButtonWidth;            //按钮的宽度
@property (nonatomic, strong) NSArray *titleArr;                //标题数组

@property (nonatomic, strong) NSMutableArray *BtnArr; //形成的按钮数组
@end
@implementation CJTTitleScrollView

#pragma mark-   初始化
+ (CJTTitleScrollView *)viewWithTitleArr:(NSArray *)array {
    return  [[CJTTitleScrollView alloc] initWithTitleArr:array];;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //初始化自身
        self.showLine   =   NO;
        self.maxNumber  =   3.0;
        [self setBackgroundColor:[UIColor whiteColor]];
        self.showsHorizontalScrollIndicator = false;
    }
    return self;
}

- (instancetype)initWithTitleArr:(NSArray *)array {
    if (self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)]) {
        [self AddArrView:array];
    }
    return self;
}

#pragma mark-
/**
 *  通过标题数组进行设置头部滚动条
 *
 *  @param array 需要加入的标题
 */
- (void)AddArrView:(NSArray*)array {
    
    self.titleArr   =   [NSArray arrayWithArray:array];
    if (array.count < self.maxNumber) {
        _ButtonWidth = _LineWidth = self.bounds.size.width/array.count;
    }
    else {
        _ButtonWidth = _LineWidth = self.bounds.size.width/self.maxNumber;
    }
    
    self.linelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, _LineWidth, 2)];
    [self.linelabel setBackgroundColor:[UIColor colorWithRed:39/255.0 green:148/255.0 blue:1 alpha:1]];
    
    UILabel *line   =   [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, _LineWidth*array.count, -0.5)];
    line.backgroundColor    =   [UIColor grayColor];
    [self addSubview:line];
    self.BtnArr = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        //初始化所有btn
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*_ButtonWidth, 0, _ButtonWidth,self.frame.size.height)];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font     = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:39/255.0 green:148/255.0 blue:1 alpha:1] forState:UIControlStateSelected];
        if (i == 0) {//初始化第一个按钮
            btn.selected    =   YES;
        }
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.titleLabel.adjustsFontSizeToFitWidth    =   YES;
        
        [self addSubview:btn];
        [self.BtnArr addObject:btn];
        if (self.showLine) {
            //增加竖线
            UIView  *verLine    =   [[UIView alloc] initWithFrame:CGRectMake(i*_ButtonWidth, 8, 1, self.frame.size.height-16)];
            verLine.backgroundColor =   [UIColor lightGrayColor];
            [self addSubview:verLine];
        }
        
    }
    //根据button个数设置内部大小
    [self setContentSize:CGSizeMake(array.count*_ButtonWidth, CGRectGetHeight(self.frame))];
    [self addSubview:self.linelabel];
}

/**
 点击事件
 */
- (void)click:(UIButton*)button {
    NSInteger btnIndex = 0 ;
    for (int i=0; i<self.BtnArr.count; i++) {
        UIButton *btn   =   self.BtnArr[i];
        //获取位置
        if (button == btn) {
            btnIndex    =   i;
            btn.selected    =   YES;
        }
        else
            btn.selected    =   NO;
    }
    
    //计算获得偏移量，
    CGFloat index = btnIndex*_ButtonWidth- (self.frame.size.width-_ButtonWidth)/2;
    index = index<0?0:index;
    index = index>self.contentSize.width-CGRectGetWidth(self.frame)?self.contentSize.width-CGRectGetWidth(self.frame):index;
    
    //动画效果偏移
    [self setContentOffset:CGPointMake(index, 0) animated:YES];
    CAKeyframeAnimation *animation  =   [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    animation.values    =   @[[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.linelabel.frame), CGRectGetMaxY(self.linelabel.frame))],[NSValue valueWithCGPoint:CGPointMake(btnIndex*_ButtonWidth+_ButtonWidth/2.0, self.frame.size.height-1)]];
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode  = kCAFillModeForwards;
    animation.duration  =   0.3;
    [self.linelabel.layer addAnimation:animation forKey:nil];
    
    //动画结束后需要设置结束后的位置
    self.linelabel.frame = CGRectMake(btnIndex*_ButtonWidth+(_ButtonWidth-_LineWidth), self.frame.size.height-2, _LineWidth, 2);
    
    if (self.titleClick) {
        self.titleClick(btnIndex);
    }
    
}

/**
 刷新控件
 */
- (void)refresh {
    [self.BtnArr removeAllObjects];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    if ([self.titleArr isKindOfClass:[NSArray class]]) {
        [self AddArrView:self.titleArr];
        [self click:self.BtnArr[0]];
    }
}

//定位索引位置
- (void)setByIndex:(NSInteger)nowindex {
    UIButton *button = self.BtnArr[nowindex];
    [self click:button];
}

//设置线的长度
- (void)setLineWidth:(NSInteger)LineWidth {
    if (LineWidth > self.ButtonWidth) {
        self.LineWidth  =   self.ButtonWidth;
        return;
    }
    CGRect rect =   self.linelabel.frame;
    rect.size.width =   LineWidth;
    rect.origin.x   +=  (self.ButtonWidth-LineWidth)/2;
    [UIView animateWithDuration:0.3 animations:^{
        self.linelabel.frame    =   rect;
    }];
    _LineWidth  =   LineWidth;
}

//设置每屏最大数
- (void)setMaxNumber:(double)maxNumber {
    _maxNumber  =   maxNumber;
    [self refresh];
    
}

//设置是否显示竖线
- (void)setShowLine:(BOOL)showLine {
    _showLine   =   showLine;
    [self refresh];
    
}

@end
