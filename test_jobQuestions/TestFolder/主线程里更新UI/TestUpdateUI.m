//
//  TestUpdateUI.m
//  test_jobQuestions
//
//  Created by 张净南 on 2018/12/10.
//  Copyright © 2018年 Jingnan Zhang. All rights reserved.
//  为啥必须在主线程更新UI

#import "TestUpdateUI.h"

@interface TestUpdateUI()
@property (nonatomic, strong) UIView *testview;

@end

@implementation TestUpdateUI

-(void)viewDidLoad {
    self.view.backgroundColor = [UIColor grayColor];
    self.testview = [[UIView alloc]init];
    self.testview.backgroundColor = [UIColor whiteColor];
    self.testview.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:self.testview];
    
    NSLog(@"%@", [self class]);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
}

/// 在子线程更新UI，像更新已经存在的UI的背景色，title等在子线程里也立马会有效果但是此时会议欧系统提示（更新UI的操作必须在主线程）
-(void)doTest {
    [NSThread detachNewThreadWithBlock:^{
        NSLog(@"当前线程：%@", NSThread.currentThread);
        self.testview.backgroundColor = [UIColor redColor];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self doTest];
}


@end
