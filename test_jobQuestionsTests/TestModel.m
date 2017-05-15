//
//  TestModel.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/5/11.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  自己写的测试类


#import <XCTest/XCTest.h>


@interface TestModel : XCTestCase
@property (nonatomic, strong) NSArray *ary;
@end

@implementation TestModel

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
}

#pragma mark - 可以测试某些方法的性能呢: 耗时多久
- (void)testPerformanceExample {
    
    [self measureBlock:^{
        
        
    }];
}

@end
