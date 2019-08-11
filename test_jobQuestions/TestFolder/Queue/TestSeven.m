//
//  TestSeven.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/1.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  UIGraphicsGetCurrentContext绘图

#import "TestSeven.h"

@implementation TestSeven


/**
 *  外部[[TestSeven alloc] initWithFrame:rect];时不会调用此法，则颜色设置无用
 */
-(instancetype)init{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

/**
 *  外部[[TestSeven alloc] init];时不会调用此法，则颜色设置无用
 */
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self doDrawRects];
}

-(void)doDrawRects{
    
      CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);  // 相当于设置线的颜色

    CGContextSetLineWidth(ctx, 1);
    
    
    CGContextAddRect(ctx,  CGRectMake(0, 0, 100, 100));

//    CGContextStrokeRect(ctx, CGRectMake(0, 0, 100, 100));
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, 100, 100));

    
    CGContextMoveToPoint(ctx, 50, 0);
    // 知在添加线后，绘图会自动移至上次结束的点
    CGContextAddLineToPoint(ctx, 0, 50);
    CGContextAddLineToPoint(ctx, 100, 50);
    
    // 这两句，哪个在前面，就只执行；后面的那个不会被执行
//    CGContextStrokePath(ctx);
    
//    CGContextSetFillColorWithColor(ctx,  [UIColor purpleColor].CGColor);
//    CGContextFillPath(ctx);
    

}

@end
