//
//  TestMyExtension.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/20.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//
/**
     1. NSJSONReadingOptions说明（三个参数为：1，2，4）
        NSJSONReadingMutableContainers(1)：返回可变容器，NSMutableDictionary或NSMutableArray。 
            如NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]; // 应用直接崩溃，因为此时未选用NSJSONReadingOptions，则返回的对象是不可变的，应该用NSDictionary来接收，不应该用NSMutableDictionary,故 [dict setObject:@"male" forKey:@"sex"]; 会直接导致崩溃,因为NSDictionary无setObject方法
 
        NSJSONReadingMutableLeaves(2)：返回的JSON对象中字符串的值为NSMutableString，目前在iOS 7上测试不好用，应该是个bug
     
        NSJSONReadingAllowFragments(4)：允许JSON字符串最外层既不是NSArray也不是NSDictionary，但必须是有效的JSON Fragment。例如使用这个选项可以解析 @“123” 这样的字符串。
 
 
 
 */

#import "TestMyExtension.h"


@interface TestMyExtension ()


@end


@implementation TestMyExtension

-(void)doTest{
    
    NSString *jsonStr = @"{\"name\": \"huweiruheriughiuhgeriu\", \"phone\": \"13244564656\", \"height\": nil }";
    // 测试字典转模型
    TestMyExtensionModel *tm = [TestMyExtensionModel my_objectWithJsonDictionary:jsonStr];
    
    
}

@end


@interface TestMyExtensionModel ()

@end

@implementation TestMyExtensionModel


@end


/**基类的分类*/
@implementation NSObject (category)

+(BOOL)isBasicNumberClass:(Class)class{
    
    NSString *clStr = NSStringFromClass(class);
    NSArray *classes = @[@"double", @"int" , @"float", @"BOOL", @"bool"];
    NSUInteger index = [classes indexOfObject:clStr];
    return !(index == NSNotFound);
}

/**字典转模型*/
+(id)my_objectWithJsonDictionary:(id)jsonDic{
    if ([jsonDic isKindOfClass:[NSString class]]) { // 因为服务器返回的都是json字符串
        
        NSString *jsonStr = (NSString *)jsonDic;
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO]; // 不允许有损转换
        
        NSError *jsonSerializateError;
        
        // 将json字符串解析后得到的对象
        id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&jsonSerializateError];
        
        return  [[[self alloc] init] setModelObjectWith:jsonObj];
        
    }else{
        return nil;
    }
}

/** 有字典\数组 来设置模型的属性*/
-(id)setModelObjectWith:(id)jsonObj{
    
    if ([jsonObj isKindOfClass:[NSDictionary class]]){
        // 由解析后得到的对象 得到 新的字典对象
        NSDictionary *newJsonObj = (NSDictionary *)jsonObj;
        
        for (int i = 0; i < newJsonObj.allKeys.count; i++) {
            
            id key = newJsonObj.allKeys[i];
            id value = newJsonObj.allValues[i];
            
            if ([key isKindOfClass:[NSString class]]){
                NSString *newKey = (NSString *)key;
                
                // KVC
                [self setValue:value forKeyPath:newKey];
            }else{ // key不是字符串
                NSLog(@"jsonObj里的key%@不是字符串", key);
            }
            
        }
        
    }else if ([jsonObj isKindOfClass:[NSArray class]]){
        
    }
    
    return self;
}


// ---------------------- 重写方法  --------------------- //

-(void)setNilValueForKey:(NSString *)key{
    NSLog(@"%@类的属性%@不能被设置为nil!", [self class], key);
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@类不存在属性%@", [self class], key);
}

@end



