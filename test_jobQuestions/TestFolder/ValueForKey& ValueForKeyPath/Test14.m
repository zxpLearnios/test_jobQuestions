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
 
 验证:
 定义一个Person类:如下
 
 @interface Person : NSObject
 {
 NSString *_name;
 int _age;
 NSString *_address;
 }
 
 @property (nonatomic, copy) NSString *name;
 
 @property (nonatomic,assign) int age;
 
 @end
 
 
 @implementation Person
 
 
 -(void)setName:(NSString *)name
 {
 NSLog(@"%s----------%@",__func__,name);
 _name = name;
 }
 
 - (void) setAge:(int)age
 {
 _age = age;
 
 NSLog(@"%s------%d",__func__,age);
 }
 
 
 - (int) age
 {
 NSLog(@"%s------%d",__func__,_age);
 return _age;
 }
 
 
 - (NSString *) name
 {
 NSLog(@"%s----------%@",__func__,_name);
 return _name;
 }
 
 @end
 测试代码
 1)验证: setValue:forKey:确实会调用-set<Key>方法
 
 Person *p = [[Person alloc] init];
 [p setValue:@"小明" forKey:@"name"];
 输出结果
 
 2015-08-15 20:56:56.975 company[1254:98490] -[Person setName:]----------小明
 2015-08-15 20:56:56.975 company[1254:98490] -[Person setAge:]------10
 2)验证:如果它的参数类型不是一个对象指针类型,但是只为nil,就会执行setNilValueForKey:方法,setNilValueForKey:方法的默认实现,是产生一个NSInvalidArgumentException的异常
 测试代码
 [p setValue:nil forKey:@"age"];
 运行结果:
 
 2015-08-15 20:59:36.111 company[1300:100841]
 *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason:
 3)可以重写这个方法setNilValueForKey:
 在Person类的实现文件中,重写setNilValueForKey:
 
 - (void) setNilValueForKey:(NSString *)key
 {
 NSLog(@"%s",__func__);
 }
 `
 再次运行,结果:
 
 2015-08-15 21:29:21.167 company[528:6226] -[Person setNilValueForKey:]
 4)验证如果方法的参数类型是NSNumber或NSValue的对应的基本类型,先把它转换为基本数据类,再执行方法,传入转换后的数据,测试代码
 Person.m 文件中:
 
 - (void) setAge:(int)age
 {
 _age = age;
 
 NSLog(@"%s------%d",__func__,age);
 }
 测试方法中
 
 [p setValue:@(10) forKey:@"age"];
 执行结果
 
 2015-08-15 21:54:23.477 company[607:15602] -[Person setAge:]------10
 5)验证如果如果没有对应的访问器方法(setter方法),如果接受者的类的+accessInstanceVariablesDirectly方法返回YES,那么就查找这个接受者的与key相匹配的实例变量(匹配模式为_<key>,_is<Key>,<key>,is<Key>):比如:key为age,只要属性存在_age,_isAge,age,isAge中的其中一个就认为匹配上了,如果找到这样的一个实例变量,并且的类型是一个对象指针类型,首先released对象上的旧值,然后把传入的新值retain后的传入的值赋值该成员变量,如果方法的参数类型是NSNumber或NSValue的对应的基本类型,先把它转换为基本数据类,再执行方法,传入转换后的数据.
 验证:+accessInstanceVariablesDirectly默认返回YES
 测试代码
 
 NSLog(@"%d",[Person accessInstanceVariablesDirectly]);
 输出结果:
 
 2015-08-15 22:05:22.646 company[782:21098] 1
 在Person类中分别使用
 
 @interface Person : NSObject
 {
 //    NSString *address;
 //    NSString *_address;
 //   注意is后面第一个字母必须大写否则会产生NSUnknownKeyException异常
 //    NSString *isAddress;
 NSString *_isAddress;
 
 }
 测试代码
 
 NSLog(@"%d",[Person accessInstanceVariablesDirectly]);
 [p setValue:@"金燕龙大厦" forKey:@"address"];
 NSString *address = [p valueForKey:@"address"];
 输出结果:
 
 2015-08-15 22:05:22.646 company[782:21098] 金燕龙大厦
 6)验证:如果访问器方法和实例变量都没有找到,执行setValue:forUndefinedKey:方法,该方法的默认实现是产生一个 NSUndefinedKeyException 类型的异常,但是我们可以重写setValue:forUndefinedKey:方法
 测试代码:
 
 [p setValue:@"美女" forKey:@"老婆"];
 结果产生一个NSUnknownKeyException:
 
 Terminating app due to uncaught exception 'NSUnknownKeyException', reason: '[<Person 0x7fd0394a4c10> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key 老婆.'
 在Person.m文件中重写 - (void)setValue:(id)value forUndefinedKey:(NSString *)key
 
 - (void)setValue:(id)value forUndefinedKey:(NSString *)key
 {
 NSLog(@"%s",__func__);
 NSLog(@"%@=%@",key,value);
 }
 再次运行程序输出结果:
 
 2015-08-15 22:14:19.866 company[885:25268] -[Person setValue:forUndefinedKey:]
 2015-08-15 22:14:19.866 company[885:25268] 老婆=美女
 
 
 */


#import "Test14.h"

@implementation Test14



-(void)doTest{
    TestModel *tm = [[TestModel alloc] init];
    // 1.  验证setValue:forKey:确实会调用-set<Key>方法
//    [tm setValue:@"问问" forKey:@"name"];
    
    // 2. 验证: 如果它的参数类型不是一个对象指针类型,但是却设置其值为nil, 就会执行setNilValueForKey:方法。setNilValueForKey: 方法的默认实现, 是产生一个NSInvalidArgumentException的异常，直接crash
//    [tm setValue:nil forKey:@"height"];
    
    // 2.1 可以重写这个方法setNilValueForKey.则 执行2会调用此法，不会crash
    
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
    [tm setValue:@"这会导致异常" forKey:@"idno"];
    // 5.1 重写 setValue:forUndefinedKey:方法。则执行5就会调用之
    
}



@end


@implementation TestModel

-(void)setName:(NSString *)name{
    _name = name;
    NSLog(@"-----------setName");
}

-(NSString *)name{
    return _name;
}

-(void)setHeight:(double)height{
    _height = height;
    NSLog(@"-----------setHeight");
}

-(double)height{
    return _height;
}

-(void)setNilValueForKey:(NSString *)key{
    NSLog(@"在TestModel里与%@相对应的属性，不能被设置为nil！", key);
}

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    NSLog(@"在TestModel里无法找到与%@相匹配的属性！", key);
}

@end



