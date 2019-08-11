//
//  TestMyExtension.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/20.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  swift 纯原生类不能使用kvc

#import <Foundation/Foundation.h>
#import "BaseTest.h"

@interface TestMyExtension : BaseTest

@end


/// 类似_key的，必须为成员变量，才在set*forKey时有效
@interface TestMyExtensionModel : NSObject {
//    NSString *isName;
//    NSString *_name;
}
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *isName;
@property (nonatomic, assign) double height;
@end


#import <objc/runtime.h>
/**字典转模型框架*/

/**基类的分类*/
@interface NSObject (category)


/**字典转模型，jsonDic须为一个字典*/
//+(id)my_objectWithJsonDictionary:(id)jsonDic;
@end

