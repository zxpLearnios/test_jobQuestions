//
//  test_jobQuestionsuITests.m
//  test_jobQuestionsuITests
//
//  Created by Jingnan Zhang on 2017/3/29.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
/*
 setup是每个测试方法调用前执行，tearDown是每个测试方法调用后执行。testExample是测试方法，和我们新建的没有差别。不过测试方法必须testXXX的格式，且不能有参数，不然不会识别为测试方法。测试方法的执行顺序是字典序排序。
 按快捷键Command + u进行单元测试，
 */

#import <XCTest/XCTest.h>

@interface test_jobQuestionsuITests : XCTestCase
@end

@implementation test_jobQuestionsuITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In uI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // uI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


#pragma mark - 把光标放入此法里，点击下面的红色按钮即可开始录制这个app运行情况，记录用户对uI的操作过程并自动生成代码，之后点击此法运行即可
- (void)testExample {
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    // 这里会报 Incomplete universal character name－－－－－－字符名不匹配 的错误。
    // 解决思路：在看到这个错误的时候第一想到的是中文uTF转码这个蛋疼的错误，的确问题出在了@“”之间，\u后面的转义出现了错误。至少在Xcode7.3之前，这个问题将会一直出现，在这里我们需要传入的是8字节的编码而不是4字节的编码，所以在此需要把“u”替换成小写“u”；即可测试成功。
//    [app.buttons[@"\u8fdb\u5165\u5355\u5143\u6d4b\u8bd5VC"] tap];
    [app.buttons[@"\u8fdb\u5165\u5355\u5143\u6d4b\u8bd5VC"] tap];
    
    XCUIElement *textField = [[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeTextField].element;
    [textField tap];
    [textField typeText:@"asd"];
    
    XCUIElement *button = app.buttons[@"\u767b\u5f55"];
    [button tap];
    [[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:1].buttons[@"add"] tap];
    [textField typeText:@"aaa"];
    [button tap];
    [textField typeText:@"1233214"];
    [button tap];
    
}

@end
