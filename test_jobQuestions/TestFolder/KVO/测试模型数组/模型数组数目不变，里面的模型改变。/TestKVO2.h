//
//  TestKVO2.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/19.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  模型数组总数不变，改变模型数组里的数据（改变某一条数据和改变所有数据的情况完全一样）


#import <UIKit/UIKit.h>

@interface TestKVO2 : UITableViewController

@end


@class TestKVO2;
@class TestKVOModel2;

@interface TestViewModel2 : NSObject

/**模型数组*/
@property (nonatomic, strong) NSMutableArray<TestKVOModel2 *> *models; 
+(instancetype)initWithViewController:(TestKVO2 *)vc;

@end



@interface TestKVOModel2 : NSObject

@property (nonatomic, strong) NSString *phone;
@end

