//
//  Test13.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/17.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTest.h"


@interface Test13 : BaseTest

@end



@class DogModel;
@interface TestKVCModel : NSObject{
    double height; // 外部不能使用对象.height来获取之，必须通过KVC
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) DogModel *dog;
@property (nonatomic, strong) NSArray<DogModel *> *dogs;

@end



@interface DogModel : NSObject{
    double weight; // 外部不能使用对象.height来获取之，必须通过KVC
}
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, assign) int age;

@end
