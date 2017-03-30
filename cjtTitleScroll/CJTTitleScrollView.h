//
//  TitleScrollView.h
//  @author 陈晋添
//
//  Created by jkc on 16/7/14.
//  Copyright © 2016年 cjt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJTTitleScrollView : UIScrollView

typedef  void(^sectionTitleViewBlock)(NSInteger num);
/// 按钮点击回调
@property (nonatomic, strong) sectionTitleViewBlock titleClick;
/// 底部红线线的长度
@property (nonatomic, assign) NSInteger LineWidth;
/// 显示竖线，默认为NO
@property (nonatomic, assign) BOOL  showLine;
/// 设置同屏最多的按钮个数
@property (nonatomic, assign) double    maxNumber;

#pragma mark- method
/**
 通过标题数组返回头部滚动条
 
 @param array 标题数组
 */
+ (CJTTitleScrollView *)viewWithTitleArr:(NSArray *)array;

/**
 通过标题数组初始化头部滚动条

 @param array 标题数组
 */
- (instancetype)initWithTitleArr:(NSArray *)array;

/**
 通过设置尺寸初始化
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  通过标题数组进行设置头部滚动条
 *
 *  @param array 需要加入的标题
 */
-(void)AddArrView:(NSArray*)array;

/**
 *  定位索引位置
 *
 *  @param index 索引位置
 */
-(void)setByIndex:(NSInteger)index;

/**
 刷新控件
 */
- (void)refresh;
@end
