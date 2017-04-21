//
//  TestBlockReference.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/21.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  block的循环引用问题

#import "BaseTest.h"


@interface TestBlockReference : BaseTest

@end


@interface TestBlockObject : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) void (^voidBlock)();

@end

