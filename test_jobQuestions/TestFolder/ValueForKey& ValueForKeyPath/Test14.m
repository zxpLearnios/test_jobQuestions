//
//  Test14.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/18.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  KVC之-setValue:forKey:方法实现原理与验证 http://www.jianshu.com/p/d54af904967b
/*  - (void)setValue:(id)value forKey:(NSString *)key方法, 实现原理与验证功能:使用一个字符串标示符给一个对象的属性赋值.它支持普通对象和集合对象
 
 这个方法的默认实现如下:
 
 (1).首先去接收者(调用方法的那个对象)的类中查找与key相匹配的访问器方法(-set<Key>),如果找到了一个方法,就检查它参数的类型,如果它的参数类型不是一个对象指针类型,但是只为nil,就会执行setNilValueForKey:方法,setNilValueForKey:方法的默认实现,是产生一个NSInvalidArgumentException的异常,但是你可以重写这个方法.如果方法参数的类是一个对象指针类型,就会简单的执行这个方法,传入对应的参数.如果方法的参数类型是NSNumber或NSValue的对应的基本类型,先把它转换为基本数据类,再执行方法,传入转换后的数据.**
 
 (2).如果没有对应的访问器方法(setter方法),如果接受者的类的+accessInstanceVariablesDirectly方法返回YES,那么就查找这个接受者的与key相匹配的实例变量(匹配模式为_<key>,_is<Key>,<key>,is<Key>):比如:key为age,只要属性存在_age,_isAge,age,isAge中的其中一个就认为匹配上了,如果找到这样的一个实例变量,并且的类型是一个对象指针类型,首先released对象上的旧值,然后把传入的新值retain后的传入的值赋值该成员变量,如果方法的参数类型是NSNumber或NSValue的对应的基本类型,先把它转换为基本数据类,再执行方法,传入转换后的数据.
 
 (3).如果访问器方法和实例变量都没有找到,执行setValue:forUndefinedKey:方法,该方法的默认实现是产生一个 NSUndefinedKeyException 类型的异常,但是我们可以重写setValue:forUndefinedKey:方法
 */


#import "Test14.h"

@implementation Test14



-(void)doTest{
    TestModel *tm = [[TestModel alloc] init];
    // 1.  验证setValue:forKey:确实会调用-set<Key>方法
//    [tm setValue:@"问问" forKey:@"name"];
    [tm setValue:@"问问" forKeyPath:@"age"]; // name age
    NSString *name = [tm valueForKey:@"age"];
    
    // 2. 验证: 如果它的参数类型不是一个对象指针类型,但是却设置其值为nil, 就会执行setNilValueForKey:方法。setNilValueForKey: 方法的默认实现, 是产生一个NSInvalidArgumentException的异常，直接crash

    
    // 2.1 可以重写这个方法setNilValueForKey 执行2会调用此法，不会crash或不重写此法但是用@try和@catch来捕获异常也不会crash
//    @try {
//        [tm setValue:nil forKey:@"height"];
//    } @catch (NSException *exception) {
//        NSLog(@"异常的名字%@, 原因%@, 详细信息%@", exception.name, exception.reason, exception.userInfo.debugDescription);
//    } @finally {
//        NSLog(@"不管是否存在异常，都会进入@finally的");
//    }
    
    // 3. 验证 如果方法的参数类型是NSNumber 或 NSValue 的对应的基本类型, 会先把它转换为基本数据类型。再执行set<key>方法, 传入转换后的数据
    // NSNumber : NSValue : NSObject
//    [tm setValue:@(178.13) forKey:@"height"];
    
    // 4.  验证 如果没有对应的访问器方法(setter方法), 如果接受者的类的+accessInstanceVariablesDirectly方法返回YES, 那么就查找这个接受者的与key相匹配的实例变量(匹配模式为_<key>,_is<Key>,<key>,is<Key>). (比如: key为age, 只要属性存在_age,_isAge,age,isAge 中的其中一个就认为匹配上了. 如果找到这样的一个实例变量, 并且的类型是一个对象指针类型, 首先released对象上的旧值, 然后把传入的新值retain后的传入的值赋值该成员变量; 如果方法的参数类型是NSNumber或NSValue的对应的基本类型, 先把它转换为基本数据类型。再执行set<key>方法, 传入转换后的数据)
    // 验证: +accessInstanceVariablesDirectly 默认返回 YES
//     BOOL isAccessInstantVariable = [TestModel accessInstanceVariablesDirectly];
    // 验证：  如果接受者的类的+accessInstanceVariablesDirectly方法返回YES, 那么就查找这个接受者的与key相匹配的实例变量(匹配模式为_<key>,_is<Key>,<key>,is<Key>). (比如: key为age,只要属性存在_age,_isAge,age,isAge 中的其中一个就认为匹配上了）
//    [tm setValue:@"这是tag这是tag这是tag" forKey:@"tag"];
//    NSLog(@"%@", tm.isTag);
    
    // 5. 验证： 若 如果访问器方法和实例变量都没有找到,执行setValue:forUndefinedKey:方法,该方法的默认实现是产生一个 NSUndefinedKeyException 类型的异常
//    [tm setValue:@"这会导致异常" forKey:@"idno"];
    // 5.1 重写 setValue:forUndefinedKey:方法。则执行5就会调用之
    
    
    
}



@end


@implementation TestModel

// 测试setValueForkey\keyPath确实会调setkey 方法。
/// observe一个对象的属性时，必须实现observeValueForKeyPath方法否则报错：observeValueForKeyPath:ofObject:change:context: message was received but not handled
-(void)setName:(NSString *)name{
    _name = name;
    NSLog(@"-----------setName");
}

// 测试ValueForkey\keyPath确实会调相应的get方法。
-(NSString *)name{
    NSLog(@"-----------getName");
    return _name;
}


// 测试setValueForkey\keyPath确实会调setkey 方法。
-(void)setHeight:(double)height{
    _height = height;
    NSLog(@"-----------setHeight");
}

// 测试ValueForkey\keyPath确实会调相应的get方法。
-(double)height{
    NSLog(@"-----------getHeight");
    return _height;
}

//-(void)setNilValueForKey:(NSString *)key{
//    NSLog(@"在TestModel里与%@相对应的属性，不能被设置为nil！", key);
//}

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    NSLog(@"在TestModel里无法找到与%@相匹配的属性！", key);
}

@end



