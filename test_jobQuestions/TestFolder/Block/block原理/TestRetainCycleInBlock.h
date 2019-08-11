//
//  TestRetainCycleInBlock.h
//  test_jobQuestions
//
//  Created by 张净南 on 2019/1/2.
//  Copyright © 2019年 Jingnan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTest.h"

typedef void(^PrintBlock)(void);
@interface TestRetainCycleInBlock : NSObject

@end


@interface TestRetainCycleInBlockA: BaseTest
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) PrintBlock block;
@end
