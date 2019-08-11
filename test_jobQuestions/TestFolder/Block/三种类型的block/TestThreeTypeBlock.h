//
//  TestThreeTypeBlock.h
//  test_jobQuestions
//
//  Created by 张净南 on 2019/1/14.
//  Copyright © 2019年 Jingnan Zhang. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "BaseTest.h"


static NSString *staticString = @"[][";
typedef NSString *(^TTTBlock)(NSString *param);
@interface TestThreeTypeBlock : BaseTest

@property (nonatomic, copy) TTTBlock blcok;
@end
