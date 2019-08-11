//
//  TestLoadAndInitializeFunc.m
//  test_jobQuestions
//
//  Created by 张净南 on 2018/9/27.
//  Copyright © 2018年 Jingnan Zhang. All rights reserved.
//

#import "TestLoadAndInitializeFunc.h"

@implementation TestLoadAndInitializeFunc

+(void)initialize {
    
    NSLog(@"调用了TestLoadAndInitializeFunc的initialize");
}

+(void)load {
    NSLog(@"调用了TestLoadAndInitializeFunc的load");
}


@end
