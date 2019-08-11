//
//  TestSaveData.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/9/15.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTest.h"


@interface TestSaveData : BaseTest 

@end



@interface TestSaveDataModel : NSObject <NSCoding>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
@end
