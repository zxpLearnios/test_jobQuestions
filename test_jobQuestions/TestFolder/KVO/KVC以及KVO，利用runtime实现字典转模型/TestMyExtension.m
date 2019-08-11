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

/**
 1. - (void)setValue:(id)value forKey:(NSString *)key方法,实现原理:
 (1).首先去接收者(调用方法的那个对象)的类中查找与key相匹配的访问器方法(-set<Key>),如果找到了一个方法,就检查它参数的类型,如果它的参数类型不是一个对象指针类型,但是只为nil,就会执行setNilValueForKey:方法,setNilValueForKey:方法的默认实现,是产生一个NSInvalidArgumentException的异常,但是你可以重写这个方法.如果方法参数的类是一个对象指针类型,就会简单的执行这个方法,传入对应的参数.如果方法的参数类型是NSNumber或NSValue的对应的基本类型,先把它转换为基本数据类,再执行方法,传入转换后的数据.****
 
 (2).如果没有对应的访问器方法(setter方法),如果接受者的类的+accessInstanceVariablesDirectly方法返回YES,那么就查找这个接受者的与key相匹配的实例变量(匹配模式为_<key>,_is<Key>,<key>,is<Key>):比如:key为age,只要属性存在_age,_isAge,age,isAge中的其中一个就认为匹配上了, 其中_<key>,_is<Key> 必须为成员变量，不能为属性，否则也是直接crash; 但<key>,is<Key>为属性或成员变量都可以.          如果找到这样的一个实例变量,并且的类型是一个对象指针类型,首先released对象上的旧值,然后把传入的新值retain后的传入的值赋值该成员变量,如果方法的参数类型是NSNumber或NSValue的对应的基本类型,先把它转换为基本数据类,再执行方法,传入转换后的数据.
 
 (3).如果访问器方法和实例变量都没有找到,执行setValue:forUndefinedKey:方法,该方法的默认实现是产生一个 NSUndefinedKeyException 类型的异常,但是我们可以重写setValue:forUndefinedKey:方法
 链接：https://www.jianshu.com/p/d54af904967b
 
 2.
 
 
 3. valueForKey, key为抽象的 实现过程：
  (1). 先看有无相应的getter方法，其中get方法的调用顺序为：(id)key, (id)_key, 其中(id)_isKey不会被调用若此时无相应的属性或成员变量仍会crash；
   (2).若有 则先调用之；若无，则看有无相应的属性或成员变量，有则返回此属性或成员变量的值
 
 
 */

#import "TestMyExtension.h"


@interface TestMyExtension ()


@end


@implementation TestMyExtension

-(void)doTest{
    
    NSString *jsonStr = @"{\"name\": \"huweiruheriughiuhgeriu\", \"phone\": \"13244564656\", \"height\": nil }";
    // 测试字典转模型
//    TestMyExtensionModel *tm = [TestMyExtensionModel my_objectWithJsonDictionary:jsonStr];

    TestMyExtensionModel *tm = [[TestMyExtensionModel alloc] init];
//    tm.name = @"sdfdsf";
//    [tm setValue:@"1" forKey:@"name"];
//    [tm setValue:@"2" forKey:@"_name"];
//    [tm setValue:@"3" forKey:@"isName"]; // crash 因为TestMyExtensionModel里，没有 isName,_isName,isIsName,_isIsName
    
//    [tm setValue: @(33) forKey:@"height"];
//    NSString *name1 = [tm valueForKey:@"name"];
    
//    NSString *name2 = [tm valueForKey:@"_name"];
//    NSString *name3 = [tm valueForKey:@"isName"]; // crash
//    NSString *name4 = [tm valueForKey:@"_isName"];
    
    
}



@end


@interface TestMyExtensionModel ()

@end

@implementation TestMyExtensionModel

// setValue:@"3" forKey:@"isName"] 不会crash
//-(void)setIsName:(NSString *)newValue {
//    _name = newValue;
//}

// [tm valueForKey:@"isName"] 不会crash


//-(NSString *)name {
//    return @"这是name";
//}


//-(NSString *)_name {
//    return @"这是_name";
//}

//-(NSString *)isName {
//    return @"这是isName";
//}

//-(NSString *)_isName {
//    return @"这是_isName";
//}

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

//-(void)setNilValueForKey:(NSString *)key{
//    NSLog(@"%@类的属性%@不能被设置为nil!", [self class], key);
//}
//
//-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    NSLog(@"%@类不存在属性%@", [self class], key);
//}

@end



