//
//  XXXX.h
//  test_jobQuestions
//
//  Created by 张净南 on 2019/1/14.
//  Copyright © 2019年 Jingnan Zhang. All rights reserved.
//

NSString *globalStr = @"124df";

//NSString *(^TTTGlobalBlock)(NSString *p) = ^(NSString *p) {
//    return p;
//};

void (^TTTGlobalBlock)(NSString *p) = ^(NSString *p) {
    NSLog(@"---------%@", p);
};

