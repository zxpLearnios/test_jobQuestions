//
//  BaseTest.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/31.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import "BaseTest.h"


static BaseTest *bt = nil;
// 3. 此时声明的变量、方法  都是私有的
@interface BaseTest ()
@property (nonatomic, assign) BOOL isOld;
-(void)stopAnimate; // 一定要记着实现
@end

@implementation BaseTest


+(instancetype)shared {
    
    const char* className = object_getClassName(self);
    NSString *classStr = [NSString stringWithCString:className encoding:NSUTF8StringEncoding];
    Class class = NSClassFromString(classStr);
    if (bt == nil) {
        bt = [[class alloc]init];
    }
    return bt;
}

/*交给子类实现*/
-(void)doClassTest{
    
}


-(void)doTest{

}

-(void)startAnimate{

}

-(void)stopAnimate{

}

@end
