//
//  test_jobQuestionsTests.m
//  test_jobQuestionsTests
//
//  Created by Jingnan Zhang on 2017/3/29.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
/*
    单元测试快捷键  c+u
 setUp是每个测试方法调用前执行，tearDown是每个测试方法调用后执行。testExample是测试方法，和我们新建的没有差别。不过测试方法必须testXXX的格式，且不能有参数，不然不会识别为测试方法。测试方法的执行顺序是字典序排序。
 按快捷键Command + U进行单元测试，
 --------------------------------------------
 XCTFail(format…) 生成一个失败的测试；
 XCTAssertNil(a1, format...)为空判断，a1为空时通过，反之不通过；
 XCTAssertNotNil(a1, format…)不为空判断，a1不为空时通过，反之不通过；
 XCTAssert(expression, format...)当expression求值为TRUE时通过；
 XCTAssertTrue(expression, format...)当expression求值为TRUE时通过；
 XCTAssertFalse(expression, format...)当expression求值为False时通过；
 XCTAssertEqualObjects(a1, a2, format...)判断相等，[a1 isEqual:a2]值为TRUE时通过，其中一个不为空时，不通过；
 XCTAssertNotEqualObjects(a1, a2, format...)判断不等，[a1 isEqual:a2]值为False时通过；
 XCTAssertEqual(a1, a2, format...)判断相等（当a1和a2是 C语言标量、结构体或联合体时使用, 判断的是变量的地址，如果地址相同则返回TRUE，否则返回NO）；
 XCTAssertNotEqual(a1, a2, format...)判断不等（当a1和a2是 C语言标量、结构体或联合体时使用）；
 XCTAssertEqualWithAccuracy(a1, a2, accuracy, format...)判断相等，（double或float类型）提供一个误差范围，当在误差范围（+/-accuracy）以内相等时通过测试；
 XCTAssertNotEqualWithAccuracy(a1, a2, accuracy, format...) 判断不等，（double或float类型）提供一个误差范围，当在误差范围以内不等时通过测试；
 XCTAssertThrows(expression, format...)异常测试，当expression发生异常时通过；反之不通过；（很变态） XCTAssertThrowsSpecific(expression, specificException, format...) 异常测试，当expression发生specificException异常时通过；反之发生其他异常或不发生异常均不通过；
 XCTAssertThrowsSpecificNamed(expression, specificException, exception_name, format...)异常测试，当expression发生具体异常、具体异常名称的异常时通过测试，反之不通过；
 XCTAssertNoThrow(expression, format…)异常测试，当expression没有发生异常时通过测试；
 XCTAssertNoThrowSpecific(expression, specificException, format...)异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过；
 XCTAssertNoThrowSpecificNamed(expression, specificException, exception_name, format...)异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过
 ---------------------------------------
 在项目中很多人都不清楚到底测试用例的覆盖率是多少才合适，所以导致有的写的非常多，比如100%。不是说写的多不好，只是有些场景不需要写测试用例反倒写了 ，比如一个函数只是一个简单的变量自增操作，如果类似这样的函数都写上测试用例，会花费开发的过多时间和精力，反而得不偿失。同时也会大大增加代码量，造成逻辑混乱。因此如何拿捏好哪些需要些测试用例哪些不需要写，也是一门艺术。例如:暴漏在.h中的方法需要写测试用例， 而那些私有方法写测试用例的优先级就要低的多了
 */

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface test_jobQuestionsTests : XCTestCase
@property (nonatomic, strong) ViewController *vc;
@property (nonatomic, strong) NSArray *ary;
@end

@implementation test_jobQuestionsTests

#pragma mark - 单元测试开始前调用
- (void)setUp {
    [super setUp];
    
    self.vc = [[ViewController alloc] init];
    
    NSString *strings[3]; // c字符数组
    strings[0] = @"First";
    strings[1] = @"Second";
    strings[2] = @"Third";
    self.ary = [NSArray arrayWithObjects:strings count:2];
}

#pragma mark - 单元测试结束前调用
- (void)tearDown {
    [super tearDown];
    
    self.vc = nil;
    self.ary = nil;
}

- (void)testExample {
    // 若不相等，则会出错
    XCTAssertEqual(NO, self.vc.isForUnitTest, @"单元测试不通过！");
}

#pragma mark - 测试性能: 耗时多久
- (void)testPerformanceExample {
    
    [self measureBlock:^{
        
        
        for (int i=0; i<100; i++) {
            NSLog(@"------");
        }
        
        for (NSString *i in self.ary) {
            NSLog(@"%@", i);
        }
        
    }];
}

#pragma mark - 自己写的
-(void)testCustomFunc{

}

@end
