//
//  TestSendInfoVCTwo.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/5/15.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import "TestSendInfoVCTwo.h"

@interface TestSendInfoVCTwo ()

@end

@implementation TestSendInfoVCTwo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [knotiCenter addObserver:self selector:@selector(receiveNoti:) name:@"comeFromTestSendInfoVCOne_key" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [knotiCenter postNotificationName:@"comeFromTestSendInfoVCTwo_key" object:nil];
}

#pragma mark - 收到通知
-(void)receiveNoti:(NSNotification *)nofi{
    MyLog(@"收到来自TestSendInfoVCOne的通知，说明通知可以用来顺传");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    [knotiCenter removeObserver:self];
}

@end
