//
//  TestNine.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/5.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  测试hitTestView1
//  测试hitTestView 和TestEight结合着使用。 使超出其范围的 按钮的可点击区域仍是有效的，即其子view的可响应区域可以超出其bounds


#import "TestNine.h"


@implementation TestNine

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
    
}

/* 重写此法，将点击事件响应的view进行处理。这是最重要的方法 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    

    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    
    
    for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
//        NSLog(@"%@", subview);
        CGPoint convertedPoint = [subview convertPoint:point fromView:self];
        // 对响应事件第一个进行响应的view
        UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
        if (hitTestView) {
            return hitTestView;
        }
    }
    return nil;

}

@end



