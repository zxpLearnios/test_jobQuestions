//
//  TestCopyAndStrongModifyString.m
//  test_jobQuestions
//
//  Created by 张净南 on 2018/9/25.
//  Copyright © 2018年 Jingnan Zhang. All rights reserved.
//

#import "TestCopyAndStrongModifyString.h"

/// 一个内部类
@interface TestObject: NSObject
@property (nonatomic, copy) NSString *name;
@end
@implementation TestObject
@end


@implementation TestCopyAndStrongModifyString


-(void)doTest {
    
    // 1. 无论是strong还是copy修饰name，此时，obj.name不会随str改变而变;
    //    NSString *str = @"123";
    //    TestObject *obj = [[TestObject alloc] init];
    //    obj.name = str;
    //    str = @"333";
    
    // 2. strong修饰name时，obj.name会随str改变而变；但copy修饰时，则不会随str改变而变
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"123"];
    TestObject *obj = [[TestObject alloc] init];
    obj.name = str;
    [str appendString:@"ee"];
    

}

@end
