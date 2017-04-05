//
//  ViewController.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/29.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import "ViewController.h"
#import "TestOne.h"
#import "TestTwo.h"
#import "TestThree.h"
#import "TestFour.h"
#import "TestFive.h"
#import "TestSix.h"
#import "TestSeven.h"
#import "TestEight.h"
#import "TestNine.h"
#import "TestTen.h"
#import "Test11.h"


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)testoneAction:(UIButton *)sender {
    
    //1. TestOne作为局部变量，在初始化后调用方法1时，很快就会被释放；但若在初始化后调用方法2时，则不会被释放
    TestOne *to = [[TestOne alloc] init];
    [to doTest];
}


- (IBAction)gotoTestTwoVCAction:(UIButton *)sender {
    
    // 2.
    TestTwo *tt = [[TestTwo alloc] init];
    tt.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:tt animated:YES];
    
}


- (IBAction)testThreeAndThenAction:(UIButton *)sender {
    
    if (sender.tag == 0) { // 测试三
        TestThree *tt = [[TestThree alloc] init];
        [tt doTest];
    }else if (sender.tag == 1){ // 测试四
        TestFour *tt = [[TestFour alloc] init];
        [tt doTest];
    }else if (sender.tag == 2){ // 测试五
        TestFive *tt = [[TestFive alloc] init];
        [self.navigationController pushViewController:tt animated:YES];
    }else if (sender.tag == 3){ // 测试六
        TestSix  *tt = [[TestSix alloc] init];
        [tt doTest];
    }else if (sender.tag == 4){ // 测试七
        TestSeven  *tt = [[TestSeven alloc] initWithFrame:CGRectMake(0, 100, 300, 400)];
        [self.view addSubview:tt];
        
    }else if (sender.tag == 5){ // 测试8
        TestEight  *tt = [[TestEight alloc] initWithFrame:CGRectMake(10, 100, 100, 40)];
        [self.view addSubview:tt];
        
    }else if (sender.tag == 6){ // 测试9
        TestNine *tt = [[TestNine alloc] initWithFrame:CGRectMake(10, 100, 100, 40)];
        
        TestEight  *t8 = [[TestEight alloc] initWithFrame:tt.bounds];
        [tt addSubview:t8];
        
        [self.view addSubview:tt];
        
    }else if (sender.tag == 7){ // 测试10
        TesthitTestViewA *t = [TesthitTestViewA getSelf];
        [self.view addSubview:t];
    }else if (sender.tag == 8) {
        
        Test11 *t = [[Test11 alloc] initWithFrame:CGRectMake(50, 150, 300, 100)];
        [self.view addSubview:t];
    }else if (sender.tag == 9) {
        
    }else if (sender.tag == 10) {
        
    }else if (sender.tag == 11) {
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
