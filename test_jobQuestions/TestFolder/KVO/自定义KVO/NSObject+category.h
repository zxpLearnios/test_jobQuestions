//
//  NSObject+category.h
//  test_jobQuestions
//
//  Created by 张净南 on 2018/9/21.
//  Copyright © 2018年 Jingnan Zhang. All rights reserved.
// 框架缺陷： 所有要被kvo的属性都不能出现这样的形式：前缀为kvo且kvo之后的第一个字母为大写(不论kvo这三个的大小写如何)，都监听不到; 但系统的是可以监听到的

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (category)

/**
 * 添加监听
 */
- (void)ns_addObserverForKey:(NSString *)key block:(void (^)(NSDictionary *valueInfo))valueChangedBlock;
/**
 * 移除监听
 */
- (void)ns_removeObserverForKey:(NSString *)key;
/**
 *  移除所有监听
 */
- (void)ns_removeAllObserver;
@end
