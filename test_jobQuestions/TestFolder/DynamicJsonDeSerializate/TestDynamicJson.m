//
//  TestJson.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/18.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  后台返回动态key时的数据解析，如此之易

#import "TestDynamicJson.h"


@implementation TestDynamicJson

-(void)doTest{
    
    // 若后台返回的json里的可以有多个并且都是动态改变的，
//    NSDictionary *dynamicDic = @{@"name": @"huweiruheriughiuhgeriu"};
    NSString *jsonStr = @"{\"name\": \"huweiruheriughiuhgeriu\" }"; // 自己写的json字符串
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
     NSDictionary *dynamicDic =  (NSDictionary *)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    NSString *dynamicKey = dynamicDic.allKeys[0];
    
    

    
    
}

@end


