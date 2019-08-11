//
//  TestMVVM.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/5/3.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestMVVM : NSObject

@end

/*
 1. MVVM在实际使用时也有一定的问题，主要体现在两点：
 数据绑定使得 Bug 很难被调试。你看到界面异常了，有可能是你 View 的代码有 Bug，也可能是 Model 的代码有问题。数据绑定使得一个位置的 Bug 被快速传递到别的位置，要定位原始出问题的地方就变得不那么容易了。
 对于过大的项目，数据绑定需要花费更多的内存。
 
 2. 基于MVVM设计思路，ViewModel存在目的在于抽离ViewController中展示业务逻辑，而不是替代ViewController，其它视图操作业务等还是应该放在ViewController中实现。
 
 既然不负责视图操作逻辑，ViewModel中就不应该存在任何View对象，更不应该存在Push/Present等视图跳转逻辑。因此，ViewModel中绝不应该存在任何视图操作相关的代码
 
 
 3. 很简单，处理视图展示逻辑，ViewModel负责将数据业务层提供的数据转化为界面展示所需的VO。其与View一一对应，没有View就没有ViewModel。
 ViewModel和View一起组成DDD(Model-Driven Design)领域驱动架构体系中的Presentation展示层。在iOS中，数据流向可以表示为ViewModel->ViewController->View，ViewController负责连接VO及其对应的View对象    
 // model中不应该存在业务逻辑代码
 - (NSString *)sexDescription {
 return self.sex == 0 ? @"男": @"女";
 }
 
 4.
 
 
 
 */

