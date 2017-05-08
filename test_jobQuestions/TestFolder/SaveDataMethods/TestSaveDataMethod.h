//
//  TestSaveDataMethod.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/5/3.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  存储数据，比如删除应用后，再次安装同一个应用后，会自动带出用户名和密码，就需要用到此种存储方式

#import "BaseTest.h"

@interface TestSaveDataMethod : BaseTest
@end

/**
 1. 剪切版: 
    剪切版主要分为以下两种
    UIPasteboardNameGeneral和UIPasteboardNameFind
    两种都是系统级的可以在应用删除后仍然保留数据
    开发中我们常常使用UIPasteboard的Find UIPasteboard来保存一些用户删除应用后需要保留的数据如UUID，用户名，密码等
    注意： 在用户使用产品过程中我们发现，当用户在隐私里面关闭限制广告跟踪，然后用户删除应用的同时，剪切版的数据会被清空（也有可能因为硬盘容量紧张也回清除）
 */
@interface PasteBoard : NSObject

+ (NSString *) uuidCreateNewUDID;
@end

/**
 2. 钥匙串keychain :  iOS的keychain服务提供了一种安全的保存私密信息（密码，序列号，证书等）的方式。每个ios程序都有一个独立的keychain存储。从ios 3.0开始，跨程序分享keychain变得可行。
 下面就使用keychain来实现存取用户名和密码。
 苹果已经有现成的类封装好了keychain, KeychainItemWrapper.h和 KeychainItemWrapper.m文件,可以在GenericKeychain实例里找到。
 */
@interface KeychainManager : NSObject

+(KeychainManager *)shareInstance;

/**根据字典存储对象到钥匙串*/
- (void)save:(NSString *)service data:(id)data;

/**根据字典读取钥匙串里的对象*/
- (id)load:(NSString *)service;

/**删除钥匙串里的数据*/
- (void)delete:(NSString *)service;

@end
