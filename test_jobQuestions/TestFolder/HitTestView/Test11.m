//
//  Test11.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/5.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  测试hitTestView3  子view超出父view或点击父view时，交由特定的子view去响应事件
//  UIscroller如何在 2个子view的间隙进行滚动
//  系统默认的：只要摁住UIScrollView后，手不松开（即使是离开了UIScrollView、即使是离开了UIScrollView的父view），一直拖动都是有效的，除非手离开屏幕，

#import "Test11.h"

@interface Test11 ()
@property (nonatomic, strong) UIScrollView *sc;
@end

@implementation Test11

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        [self doThing];
        
    }
    return self;
}

// 让UIScrollView的frame小于自己的bounds
-(void)doThing{
    self.sc = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 30, self.bounds.size.width - 60, self.bounds.size.height - 60)];
    [self addSubview:self.sc];
    
    
    for (int i=0; i<3; i++) {
        
        NSString *name = [NSString stringWithFormat:@"%d",i];
        UIImage *img = [UIImage imageNamed:name];
        UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
        
        CGFloat x = 40 + i*140;
        imgV.frame = CGRectMake(x, 0, 140, self.sc.bounds.size.height);
        
        [self.sc addSubview:imgV];
    }

    self.sc.contentSize = CGSizeMake(200 * 3, 0);
}

// 重写此法,
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *hitTestView = [super hitTest:point withEvent:event];
    if (hitTestView) {
        hitTestView = self.sc; // 当点击自己的而非子view的区域时，将此事件主动交由特定的子view去处理。
    }
    return hitTestView;
}

@end
