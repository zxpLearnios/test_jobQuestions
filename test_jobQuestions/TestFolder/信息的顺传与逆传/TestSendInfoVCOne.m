//
//  TestSendInfoVCOne.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/5/15.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  通知和block一样， 可以用于 顺传和逆传。但后者用于一对一的通信. 通知必须是先监听后发送才会被监听者收到

#import "TestSendInfoVCOne.h"
#import "TestSendInfoVCTwo.h"

@interface TestSendInfoVCOne ()

@end

@implementation TestSendInfoVCOne

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [knotiCenter addObserver:self selector:@selector(receiveNoti:) name:@"comeFromTestSendInfoVCTwo_key" object:nil];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [knotiCenter postNotificationName:@"comeFromTestSendInfoVCOne_key" object:nil];
}


#pragma mark - 收到通知
-(void)receiveNoti:(NSNotification *)nofi{
    MyLog(@"收到来自TestSendInfoVCTwo的通知，说明通知可以用来逆传");
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    TestSendInfoVCTwo *vc = [[TestSendInfoVCTwo alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


-(void)dealloc{
    [knotiCenter removeObserver:self];
}

@end
