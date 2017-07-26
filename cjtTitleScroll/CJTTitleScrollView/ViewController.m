//
//  ViewController.m
//  cjtTitleScroll
//
//  Created by 陈晋添 on 2016/11/18.
//  Copyright © 2016年 陈晋添. All rights reserved.
//

#import "ViewController.h"
#import "CJTTitleScrollView.h"

@interface ViewController ()
{
    CJTTitleScrollView  *title;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    title  =   [CJTTitleScrollView viewWithTitleArr:@[@"默认",@"修改线长度",@"修改出现竖线",@"修改每屏数量"]];
    title   =   [[CJTTitleScrollView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
    [title AddArrView:@[@"默认",@"修改线长度",@"修改出现竖线",@"修改每屏数量"]];
    __weak  typeof(title)   weaktitle   =   title;
    
    
    title.titleClick    =   ^(NSInteger index) {
        switch (index) {
            case 0:
                break;
            case 1:
                weaktitle.LineWidth =  50;
                break;
            case 2:
                //weaktitle.showLine  =   !weaktitle.showLine;
                break;
            case 3:
                //weaktitle.maxNumber =   2;
                break;
            default:
                break;
        }
    };
    
    [self.view addSubview:title];
}
- (IBAction)touch:(id)sender {
    
    title.showLine = !title.showLine;
}



@end
