//
//  NSString+category.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/6.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import "NSString+category.h"


@implementation NSString (category)


static  char const typeKey = 'c';

// 给type属性提供getter和setter方法，必须实现，否则会报'NSInvalidArgumentException', reason: '-[__NSCFConstantString setType:]: unrecognized selector sent to instance 0x101074900' First throw call stack:

-(NSString *)type{
    // 根据此key 获取与之关联的属性
    return objc_getAssociatedObject(self, &typeKey);
}

- (void)setType:(NSString *)type{
    
    // 为self新加属性type，并将typeKey设置为与此属性相关的key。以便，以后由此key获取此属性
    objc_setAssociatedObject(self, &typeKey, type,OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
