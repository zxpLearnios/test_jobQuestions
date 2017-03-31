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
        
    }else if (sender.tag == 4){ // 测试七
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
