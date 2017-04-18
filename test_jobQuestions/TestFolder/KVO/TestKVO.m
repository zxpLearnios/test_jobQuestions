//
//  TestKVO.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/18.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  KVO这一“黑魔法”技术的实现原理
/** 1. KVO提供一种机制，指定一个被观察对象(例如A类)，当对象某个属性(例如A中的字符串name)发生更改时，对象会获得通知，并作出相应处理；【且不需要给被观察的对象添加任何额外代码，就能使用KVO机制】
 
    2. 在 MVC 设计架构下的项目，KVO机制很适合实现mode模型和view视图之间的通讯。
    例如：代码中，在模型类A创建属性数据，在控制器中创建观察者，一旦属性数据发生改变就收到观察者收到通知，通过KVO再在控制器使用回调方法处理实现视图B的更新；(本文中的应用就是这样的例子.)
    3. KVO 的实现依赖于 Objective-C 强大的 Runtime，从以上Apple 的文档可以看出苹果对于KVO机制的实现是一笔带过，而具体的细节没有过多的描述，但是我们可以通过Runtime的所提供的方法去探索
 
 
 
 */

#import "TestKVO.h"

@interface TestKVO ()
@property (nonatomic, strong) TestKVOModel *model;
@property (nonatomic, strong) UILabel *lab;
@end
@implementation TestKVO

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self doTest];
}

-(void)doTest{
    // 0.
    self.lab = [[UILabel alloc] init];
    self.lab.center = self.view.center;
    self.lab.bounds = CGRectMake(0, 0, 300, 30);
    self.lab.numberOfLines = 0;
    self.lab.textAlignment = NSTextAlignmentCenter;
    self.lab.font = [UIFont systemFontOfSize:20];
    self.lab.textColor = [UIColor redColor];
    [self.view addSubview:self.lab];
    self.lab.text = @"当模型的值改变时，此lab的值也变";
    
    
    // 1.
    self.model = [[TestKVOModel alloc] init];
    [self.model addObserver:self forKeyPath:@"phone" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil]; //name phone   若将name换位_name则会valueForUndefinedKey crash

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([object isKindOfClass:[TestKVOModel class]]) {
        NSString *newValue = change[NSKeyValueChangeNewKey];
        self.lab.text = newValue;
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSString *dateStr =  [self getDateStrFromDate:[NSDate date]];
    // 1. 使用KVC给模型的全局成员变量name赋值
//    [self.model setValue:dateStr forKeyPath:@"name"];
    
    // 2. 执行了setter方法 给模型的属性phone赋值(由于外部不可以直接.语法来访问name，故这里测试phone属性).     只要遵循 KVO 的属性设置方式，都可以触发KVO机制。这里为了避免跟KVC混淆，故意不使用KVC的。而是使用了执行setter方法改变属性值来触发KVO
    self.model.phone = dateStr;
}


-(NSString *)getDateStrFromDate:(NSDate *)date{
    @autoreleasepool {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateStr = [df stringFromDate:date];
        return dateStr;
    }
}

// KVO以及通知的注销，一般是在-(void)dealloc中编写。 至于很多小伙伴问为什么要在didReceiveMemoryWarning？因为这个例子是在书本上看到的，所以试着使用它的例子。 但小编还是推荐把注销行为放在-(void)dealloc中
-(void)dealloc{

//    [self.model removeObserver:self forKeyPath:@"name" context:nil]; // 若此属性未被监听，则系统不会给之注册监听通知，故会直接crash
    
    [self.model removeObserver:self forKeyPath:@"phone" context:nil];
}

@end


/** 下面这个必须写 */
@implementation TestKVOModel



-(void)doesNotRecognizeSelector:(SEL)aSelector{
    NSLog(@"TestKVOModel未实现%s方法", __func__);
}

@end



