//
//  TestSaveData.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/9/15.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import "TestSaveData.h"

@implementation TestSaveData

-(void)doTest{
    [self testSaveArray];
}

/**
 * 1. 数组可以直接进行归档,但里面装的东西必须遵守NSCoding协议才可
 */
-(void)testSaveArray{

    TestSaveDataModel *ml0 = [[TestSaveDataModel alloc] init];
    ml0.name = @"ml0";
    ml0.age = 10;
    TestSaveDataModel *ml1 = [[TestSaveDataModel alloc] init];
    ml1.name = @"ml1";
    TestSaveDataModel *ml2 = [[TestSaveDataModel alloc] init];
    ml2.age = 20;
    
    
    NSArray *models = @[ml0, ml1, ml2];
    
    NSString *path = [[Const documentPath] stringByAppendingString:@"models.plist"];
    BOOL isSuccess = [NSKeyedArchiver archiveRootObject:models toFile:path];
    
    if (!isSuccess) {
        MyLog(@"保存models失败！");
    }else{
        
        MyLog(@"保存models成功！");
        
        // 读取
        NSArray *newAry = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        for (TestSaveDataModel *ml in newAry) {
            MyLog(@"模型为：%@", ml.debugDescription);
        }
    }

    
    

}

@end



@implementation TestSaveDataModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    TestSaveDataModel *ml = [[TestSaveDataModel alloc] init];
    ml.name = [aDecoder decodeObjectForKey:@"name"];
    ml.age = [aDecoder decodeIntegerForKey:@"age"];
    
    return ml;
}

@end
