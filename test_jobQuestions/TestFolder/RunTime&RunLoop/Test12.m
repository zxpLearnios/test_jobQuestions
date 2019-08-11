//
//  Test12.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/10.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  运行时  参考http://www.jianshu.com/p/59992507f875
// http header请求头  NSBlockOperation
// 网络请求  NSURLConnection  NSURLSession
/*
 
 1. 当operation有多个任务的时候会自动分配多个线程并发执行, 如果只有一个任务，会自动在主线程同步执行     2. iOS开发之网络错误分层处理，参考http://blog.csdn.net/moxi_wang/article/details/52638752   3. 使用URLSession的对象，调用其对象方法使用URLRequest来进行请求、上传、下载
 4. URLSession的设置：
 4.1 默认会话（Default Sessions）使用了持久的磁盘缓存，并且将证书存入用户的钥匙串中。
 4.2 临时会话（Ephemeral Session）没有向磁盘中存入任何数据，与该会话相关的证书、缓存等都会存在RAM中。因此当你的App临时会话无效时，证书以及缓存等数据就会被清除掉。
 4.3 后台会话（Background sessions）除了使用一个单独的线程来处理会话之外，与默认会话类似。不过要使用后台会话要有一些限制条件，比如会话必须提供事件交付的代理方法、只有HTTP和HTTPS协议支持后台会话、总是伴随着重定向。
 【仅仅在上传文件时才支持后台会话，当你上传二进制对象或者数据流时是不支持后台会话的。】
 当App进入后台时，后台传输就会被初始化。（需要注意的是iOS8和OS X 10.10之前的版本中后台会话是不支持数据任务（data task）的）。
 
 
 1. Objective-C是一门简单的语言，95%是C。只是在语言层面上加了些关键字和语法。真正让Objective-C如此强大的是它的运行时。它很小但却很强大。它的核心是消息分发。
 2. 大多数面向对象的语言里有 classes 和 objects 的概念。Objects通过Classes生成。但是在Objective-C中，classes本身也是objects，也可以处理消息，这也是为什么会有类方法和实例方法。具体来说，Objective-C中的Object是一个结构体(struct)，第一个成员是isa，指向自己的class。这是在objc/objc.h中定义的。
 3.  运行时能干什么？
    NSString *myString = [stringclass stringWithString:@"Hello World"];
    3.1 为什么要这么做呢？直接使用Class不是更方便？通常情况下是，但有些场景下这个方法会很有用。首先，可以得知是否存在某个class，NSClassFromString 会返回nil，如果运行时不存在该class的话。
 
    3.2 另一个使用场景是根据不同的输入返回不同的class或method。比如你在解析一些数据，每个数据项都有要解析的字符串以及自身的类型（String，Number，Array）。你可以在一个方法里搞定这些，也可以使用多个方法。其中一个方法是获取type，然后使用if来调用匹配的方法。另一种是根据type来生成一个selector，然后调用之。以下是两种实现方式：
     - (void)parseObject:(id)object {
     for (id data in object) {
     if ([[data type] isEqualToString:@"String"]) {
     [self parseString:[data value]];
     } else if ([[data type] isEqualToString:@"Number"]) {
     [self parseNumber:[data value]];
     } else if ([[data type] isEqualToString:@"Array"]) {
     [self parseArray:[data value]];
     }
     }
     }
     - (void)parseObjectDynamic:(id)object {
     for (id data in object) {
     [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"parse%@:", [data type]]) withObject:[data value]];
     }
     }
     - (void)parseString:(NSString *)aString {}
     - (void)parseNumber:(NSString *)aNumber {}
     - (void)parseArray:(NSString *)aArray {}
 
 
   3.3. Method Swizzling
     之前我们讲过，方法由两个部分组成。Selector相当于一个方法的id；IMP是方法的实现。这样分开的一个便利之处是selector和IMP之间的对应关系可以被改变。比如一个 IMP 可以有多个 selectors 指向它。
     
     而 Method Swizzling 可以交换两个方法的实现。或许你会问“什么情况下会需要这个呢？”。我们先来看下Objective-C中，两种扩展class的途径。首先是 subclassing。你可以重写某个方法，调用父类的实现，这也意味着你必须使用这个subclass的实例，但如果继承了某个Cocoa class，而Cocoa又返回了原先的class(比如 NSArray)。这种情况下，你会想添加一个方法到NSArray，也就是使用Category。99%的情况下这是OK的，但如果你重写了某个方法，就没有机会再调用原先的实现了。
     
     Method Swizzling 可以搞定这个问题。你可以重写某个方法而不用继承，同时还可以调用原先的实现。通常的做法是在category中添加一个方法(当然也可以是一个全新的class)。可以通过method_exchangeImplementations这个运行时方法来交换实现。来看一个demo，这个demo演示了如何重写addObject:方法来纪录每一个新添加的对象。
     
     #import  <objc/runtime.h>
     
     @interface NSMutableArray (LoggingAddObject)
     - (void)logAddObject:(id)aObject;
     @end
     
     @implementation NSMutableArray (LoggingAddObject)
     
     + (void)load {
     Method addobject = class_getInstanceMethod(self, @selector(addObject:));
     Method logAddobject = class_getInstanceMethod(self, @selector(logAddObject:));
     method_exchangeImplementations(addObject, logAddObject);
     
     }
     
     - (void)logAddObject:(id)aobject {
     [self logAddObject:aObject];
     NSLog(@"Added object %@ to array %@", aObject, self);
     }
     
     @end
     我们把方法交换放到了load中，这个方法只会被调用一次，而且是运行时载入。如果指向临时用一下，可以放到别的地方。注意到一个很明显的递归调用logAddObject:。这也是Method Swizzling容易把我们搞混的地方，因为我们已经交换了方法的实现，所以其实调用的是addObject:
 
 
 
 4. 动态语言调用一个没有的方法时，编译阶段也不不会报错,但程序一运行时便直接抛出异常闪退
 
 --------------------------  runloop ---------------------------- 
 不知道大家有没有想过这个问题，一个应用开始运行以后放在那里，如果不对它进行任何操作，这个应用就像静止了一样，不会自发的有任何动作发生，但是如果我们点击界面上的一个按钮，这个时候就会有对应的按钮响应事件发生。给我们的感觉就像应用一直处于随时待命的状态，在没人操作的时候它一直在休息，在让它干活的时候，它就能立刻响应。其实，这就是run loop的功劳。
 
 */

#import "Test12.h"
#import "NSString+category.h" // 测试runtime在分类里为系统原类新加属性


@implementation Test12

/**
 * 1.获取对象的所有属性。不管在哪个位置声明不管什么修饰，都能获取到。
 */
+(NSArray *)getIvarListFromClass:(Class)cl{

    NSMutableArray *ary = [NSMutableArray array];
    
    // 成员变量的数量
    unsigned int outCount = 0;
    
    // 2.
    Ivar *ivars =  class_copyIvarList(cl, &outCount);
    // 遍历所有的成员变量
    for (int i = 0; i<outCount; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        
        
        // 获得成员变量的名字
        NSString *propertyName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        NSLog(@"成员变量----%@", propertyName);
        
        [ary addObject:propertyName];
    }
    
     // 如果函数名中包含了copy\new\retain\create等字眼，那么这个函数返回的数据就需要手动释放
    free(ivars);
    
    return ary;
}

/**
 *  2. 当然此刻获取的只包括成员属性，也就是那些有setter或者getter方法的成员变量
 */
+(NSArray *)getPropertyListFromClass:(Class)cl{
    
    NSMutableArray *ary = [NSMutableArray array];
    // 成员变量的数量
    unsigned int outCount = 0;
    objc_property_t *propertyList = class_copyPropertyList(cl, &outCount);
    for (int i=0; i<outCount; i++) {
        // 得到属性的名字，C字符串
        const char *cPropertyName = property_getName(propertyList[i]);
        NSString *propertyName = [NSString stringWithCString:cPropertyName encoding:NSUTF8StringEncoding];
        NSLog(@"属性----%@", propertyName);
        // 将C字符串转换为OC，在加入数组
        [ary addObject:propertyName];
    }
    
    return ary;
}

/**
 * 3. 获取类名
 */
+(NSString *)getClassName:(Class)cl{
    const char *clName = class_getName(cl);
    NSString *name = [NSString stringWithCString:clName encoding:NSUTF8StringEncoding];
    return name;
}



/**
 * 4. 获取类的实例方法
 */
+(NSArray *)getInstanceMethodListFromClass:(Class)cl{
//    class_copyMethodList(<#__unsafe_unretained Class cls#>, <#unsigned int *outCount#>)
//    NSInvocationOperation *ip = [NSInvocationOperation alloc] initWithTarget:<#(nonnull id)#> selector:<#(nonnull SEL)#> object:<#(nullable id)#>];
    return @"";
}

/**
 * 5.获取类的类方法
 */
+(NSArray *)getClassMethodListFromClass:(Class)cl{
    return @"";
}

+(void)getRequestByURLConnection{
    
    //  get请求：例如从服务器读取静态图片、或查询数据等. 协议头+主机地址+接口名称+?+参数1&参数2&参数3
    NSString *getPath = @"http://www.xx.cn/login?name=000&pwd=123";
    NSURL *url = [[NSURL alloc] initWithString:getPath];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLResponse *response;
    NSError *error;
    // 同步请求
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (data) {
        
    }else{
    
    }
    
    //  异步请求
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
     [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
         
         NSError *jsonError;
         if (data) {
             NSDictionary *mainDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
             
             
         }else{
         
         }
         
     }];
}

+(void)postRequestByURLConnection{

    //  post请求：例如提交表单、下载、上传
    NSString *postPath = @"http://www.xx.cn/login";
    NSURL *url = [[NSURL alloc] initWithString:postPath];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    request.cachePolicy = ; // 缓存类型
    request.HTTPMethod = @"post";
    NSError *jsonError;
    NSDictionary *params = @{@"name": @"", @"pwd": @""};
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&jsonError];
    
    // http的header
    request.allHTTPHeaderFields = @{@"Host": @"value", @"content-type": @"text/json"};
    NSURLResponse *response;
    NSError *error;
    // 同步请求
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (data) {
        
    }else{
        
    }
    
    //  异步请求
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    // 也可以设置代理，在代理方法里获取请求的结果
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSError *jsonError;
        if (data) {
            NSDictionary *mainDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            
            
        }else{
            
        }
        
    }];

    /*
     请求头：
     Host: 目标服务器的网络地址
     Accept: 让服务端知道客户端所能接收的数据类型，如text/html /
     Content-Type: body中的数据类型，如application/json; charset=UTF-8
     Content-Length: body的长度，如果body为空则该字段值为0。该字段一般在POST请求中才会有。
     Accept-Language: 客户端的语言环境，如zh-cn
     Accept-Encoding: 客户端支持的数据压缩格式，如gzip
     User-Agent: 客户端的软件环境，我们可以更改该字段为自己客户端的名字，比如QQ music v1.11，比如浏览器Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/600.8.9 (KHTML, like Gecko) Maxthon/4.5.2
     Connection: keep-alive，该字段是从HTTP 1.1才开始有的，用来告诉服务端这是一个持久连接，“请服务端不要在发出响应后立即断开TCP连接”。关于该字段的更多解释将在后面的HTTP版本简介中展开。
     POST请求的body请求体也有可能是空的，因此POST中Content-Length也有可能为0
     
     Cookie: 记录 用户保存在本地的用户数据，如果有会被自动附上
     */
    
}


+(void)requestByURL{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURL *url = [[NSURL alloc] initWithString:@""];
    NSURLSessionDataTask *task =  [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 处理请求结果
        
    }];
    
    [task resume];
    
}

// NSInvocationOperation 和 NSBlockOperation
+(void)noUse{
    // 1. NSInvocationOperation
//    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"value1" forKey:@"key1"];
//    // NSInvocationOperation与 NSBlockOperation是一样的，默认是在主线程上执行的，并且是同步的
//    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operationSelector:) object:dict];
//    NSLog(@"start before");
    
//    [op start];
    
    
    // 2. NSBlockOperation
    // 在主线程上同步执行
//    NSBlockOperation *op  = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"BlockOperation 1 begin");
//        sleep(2);  // 加个睡眠模仿耗时操作
//        NSLog(@"BlockOperation 1 currentThread = %@", [NSThread currentThread]);
//        NSLog(@"BlockOperation 1 mainThread    = %@", [NSThread mainThread]);
//        NSLog(@"BlockOperation 1 end");
//    }];
//    
//    // 异步执行的，并且会开辟新的线程
//    [op addExecutionBlock:^{
//        NSLog(@"BlockOperation 2 begin");
//        sleep(10);
//        NSLog(@"BlockOperation 2 currentThread = %@", [NSThread currentThread]);
//        NSLog(@"BlockOperation 2 mainThread    = %@", [NSThread mainThread]);
//        NSLog(@"BlockOperation 2 end");
//    }];
//    
////    [op addExecutionBlock:^{
////        NSLog(@"BlockOperation 3 begin");
////        sleep(10);
////        NSLog(@"BlockOperation 3 currentThread = %@", [NSThread currentThread]);
////        NSLog(@"BlockOperation 3 mainThread    = %@", [NSThread mainThread]);
////        NSLog(@"BlockOperation 3 end");
////    }];
////    
////    NSLog(@"start before");
//    
//    // 不管用上面哪种，此句必须
//    [op start];
    
    // 对于这两个 Operation ，如果仅使用同步执行操作，那么并没有多大的区别，一个是使用 selector 回调并可以传递参数进去，一个是使用 Block ，可根据实际情况选择。 但是如果想要使用多线程异步操作，则应该选择 NSBlockOperation，不过注意只有通过addExecutionBlock添加的操作才是多线程异步操作。
    // 3.  NSOperation 无用，使用时，都是用NSBlockOperation的，来进行异步操作
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    queue.name = @"custom_queue";
//    
//    NSOperation *oprate = [[NSOperation alloc] init];
    
    // 4. 测试runtime通过分类为原类新加属性
//    NSString *str = @"sssddd";
//    str.type = @"runtime利用分类为系统原类新加属性";
//    
//    NSLog(@"%@", str.type);
    
    Student *stu = [[Student alloc] init];
    stu.dynamicname = @"234534";
    
}


@end


@interface Student (){
    @public NSString *height; // 不会被2获取到
}
@property (nonatomic, strong) NSString *part;
@end

@implementation Student

-(NSString *)getStudentName{
    return @"name";
}

-(NSString *)getStudentAge{
    return @"age";
}

+(instancetype)initWithType{
    return [[Student alloc] init];
}

@end


@implementation Student (TestDynomic)

@end
