//
//  NSMutableArray+category.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/10.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  利用此法可以

#import "NSMutableArray+category.h"

@implementation NSMutableArray (category)

/*只会调用一次，因为NSObject有load方法*/
+ (void)load {
#if DEBUG
    Method addObject = class_getInstanceMethod(self, @selector(addObject:)); //class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:)); //class_getInstanceMethod(self, @selector(addObject:));
    Method logAddObject = class_getInstanceMethod(self, @selector(logAddObject:));
    method_exchangeImplementations(addObject, logAddObject);
    
#endif
}

// 既保留了原来的方法，又使此法和原法一样的效果
- (void)logAddObject:(id)aObject {
    // 这里不会导致递归死，因为在load里已将logAddObject方法替换为了NSMutableArray原有的addObject方法了，即此时执行的相当于是在执行addObject
    [self logAddObject:aObject];
    NSLog(@"Added object %@ to array %@", aObject, self);
}

@end
