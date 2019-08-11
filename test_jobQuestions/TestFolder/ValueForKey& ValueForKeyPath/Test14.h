//
//  Test14.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/18.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTest.h"

@interface Test14 : BaseTest

@end

@interface TestModel : NSObject{
    double _height; // 外部不能使用对象.height来获取之，必须通过KVC
    NSString *_name;
     NSString *_isAge; // _age 只能写成成员变量
}

//@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *isTag; // tag _tag isTag _isTag 是等价的
@end


