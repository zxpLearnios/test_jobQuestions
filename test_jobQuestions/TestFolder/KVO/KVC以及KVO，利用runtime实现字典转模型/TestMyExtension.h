//
//  TestMyExtension.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/20.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTest.h"

@interface TestMyExtension : BaseTest

@end



@interface TestMyExtensionModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) double height;
@end


#import <objc/runtime.h>
/**字典转模型框架*/

/**基类的分类*/
@interface NSObject (category)


/**字典转模型，jsonDic须为一个字典*/
//+(id)my_objectWithJsonDictionary:(id)jsonDic;
@end

