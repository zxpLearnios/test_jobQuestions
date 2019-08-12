//
//  TestCatagoryClass.m
//  test_jobQuestions
//
//  Created by Bavaria on 2019/8/12.
//  Copyright © 2019 Jingnan Zhang. All rights reserved.


#import "TestCatagoryClass.h"

@implementation TestCatagoryClass


-(void)doTest {
    
    
    //  分类\类目不要重写原类的方法，否则会导致原类的方法无法调用
    // 当分类NSArray+extension 和 NSArray+extension1都重写了原类NSArray的方法时会导致, 经测试发现，哪个分类先被添加先被链接与运行就先调哪个分类的方法，不会crash等，比如先创建了NSArray+extension并重写此法并运行项目，此时在创建NSArray+extension1并重写此法，这之后只会触发NSArray+extension的containsObject方法
    NSString *str = @"1";
    NSArray *ary = @[@"1"];
    
    
//    BOOL isContains = [ary containsObject:@"1"];
//    BOOL isContains = [ary containsObject:str];
    
    
    UIView *vw = [[UIView alloc] init];
    vw.backgroundColor = [UIColor redColor];
    
    
    UIView *vw1 = [[UIView alloc] init];
    vw1.backgroundColor = [UIColor redColor];

    
    NSArray *ary1 = @[vw];
    
    BOOL isContains = [ary containsObject: vw];
//    BOOL isContains = [ary containsObject: vw1];
    
}




@end
