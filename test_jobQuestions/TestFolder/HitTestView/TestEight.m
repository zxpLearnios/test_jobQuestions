//
//  TestEight.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/5.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  扩大、缩小  更改按钮的点击范围、响应区域。向x或y的正或负方向增减响应区域

/*  iOS修改button的点击范围
    一般来说，按钮的点击范围是跟按钮的大小一样的。若按钮很小时，想增大点击区域，网上通用的方法有
    ①设置btn图片setImage,然后将btn的size设置的比图片大
    ②在btn上添加一个比较大的透明btn
    但以上有问题，若btn无图片就无法设置；添加透明btn则会改变view的层级。所以此时最好的方法是重写btn的
*/

#import "TestEight.h"

@implementation TestEight

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        [self addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
// 即使是父view .clipsToBounds = YES; 它也会响应的
/**
 * 1. 更改按钮的响应区域，会使按钮的x、y方向各增、减n
 */
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect newB = self.bounds;
    // 扩大点击区域，想缩小就将负值设为正值
    newB = CGRectInset(newB, -40, -20);
    
    return CGRectContainsPoint(newB, point);
}

/**
 * 2. 更改按钮的响应区域，会使按钮的x或y的正方向或负方向改变n
 */
//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    // 只增加x正方向的区域， 其余的情况以此类推
//    CGRect newB = CGRectMake(0, 0, self.bounds.size.width + 40, self.bounds.size.height);
//    return CGRectContainsPoint(newB, point);
//}

///

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
#pragma mark - 点击按钮
-(void)btnAction:(UIButton *)sender{
    MyLog(@"点击了按钮----------------");
}

@end
