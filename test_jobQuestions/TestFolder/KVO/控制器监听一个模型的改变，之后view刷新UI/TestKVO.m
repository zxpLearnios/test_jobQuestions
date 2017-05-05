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
 
 
    
 4. KVO 的实现依赖于 Objective-C 强大的 Runtime【可参考：Runtime的几个小例子】 ，从以上Apple 的文档可以看出苹果对于KVO机制的实现是一笔带过，而具体的细节没有过多的描述，但是我们可以通过Runtime的所提供的方法去探索，关于KVO机制的底层实现原理。
 
     4.1 基本的原理：
     
     当观察某对象A时，KVO机制动态创建一个对象A当前类的子类，并为这个新的子类重写了被观察属性keyPath的setter 方法。setter 方法随后负责通知观察对象属性的改变状况。
     
     深入剖析：
     
     Apple 使用了 isa 混写（isa-swizzling）来实现 KVO 。当观察对象A时，KVO机制动态创建一个新的名为： NSKVONotifying_A的新类，该类继承自对象A的本类，且KVO为NSKVONotifying_A重写观察属性的setter 方法，setter 方法会负责在调用原 setter 方法之前和之后，通知所有观察对象属性值的更改情况。
     
     （备注： isa 混写（isa-swizzling）isa：is a kind of ； swizzling：混合，搅合；）
     
     ①NSKVONotifying_A类剖析：在这个过程，被观察对象的 isa 指针从指向原来的A类，被KVO机制修改为指向系统新创建的子类 NSKVONotifying_A类，来实现当前类属性值改变的监听；
     
     所以当我们从应用层面上看来，完全没有意识到有新的类出现，这是系统“隐瞒”了对KVO的底层实现过程，让我们误以为还是原来的类。但是此时如果我们创建一个新的名为“NSKVONotifying_A”的类()，就会发现系统运行到注册KVO的那段代码时程序就崩溃，因为系统在注册监听的时候动态创建了名为NSKVONotifying_A的中间类，并指向这个中间类了。
     
     （isa 指针的作用：每个对象都有isa 指针，指向该对象的类，它告诉 Runtime 系统这个对象的类是什么。所以对象注册为被观察者时，isa指针指向新子类，那么这个被观察的对象就神奇地变成新子类的对象（或实例）了。） 因而在该对象上对 setter 的调用就会调用已重写的 setter，从而激活键值通知机制。
     
     —>我猜，这也是KVO回调机制，为什么都俗称KVO技术为黑魔法的原因之一吧：内部神秘、外观简洁。
     
     ②子类setter方法剖析：KVO的键值观察通知依赖于 NSObject 的两个方法:willChangeValueForKey:和 didChangevlueForKey:，在存取数值的前后分别调用2个方法：
     
     被观察属性发生改变之前，willChangeValueForKey:被调用，通知系统该 keyPath 的属性值即将变更；当改变发生后， didChangeValueForKey: 被调用，通知系统该 keyPath 的属性值已经变更；之后， observeValueForKey:ofObject:change:context: 也会被调用。且重写观察属性的setter 方法这种继承方式的注入是在运行时而不是编译时实现的。
     
     KVO为子类的观察者属性重写调用存取方法的工作原理在代码中相当于：
     
     -(void)setName:(NSString *)newName
     {
     [self willChangeValueForKey:@"name"];    //KVO在调用存取方法之前总调用
     [super setValue:newName forKey:@"name"]; //调用父类的存取方法
     [self didChangeValueForKey:@"name"];     //KVO在调用存取方法之后总调用
     }
     
    4.2 特点：
    观察者观察的是属性，只有遵循 KVO 变更属性值的方式才会执行KVO的回调方法，例如是否执行了setter方法、或者是否使用了KVC赋值。如果赋值没有通过setter方法或者KVC，而是直接修改属性对应的成员变量，例如：仅调用_name = @"newName"，这时是不会触发kvo机制，更加不会调用回调方法的。 所以使用KVO机制的前提是遵循 KVO 的属性设置方式来变更属性值
 
 */


#import "TestKVO.h"


@interface TestKVO ()
@property (nonatomic, strong) TestKVOModel *model;
@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, strong) TestViewModel *viewModel;
@end

@implementation TestKVO

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    self.viewModel = [TestViewModel initWithViewController:self];
    
    // 1.
//    [self doTest];
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
    
    // 在Viewmodle时也是好用的
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
//    self.model.phone = dateStr;
    
    // 3. 测试viewModel
//    [self.viewModel.model setValue:dateStr forKey:@"name"];
    self.viewModel.model.phone = dateStr;
    
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
    
//    [self.model removeObserver:self forKeyPath:@"phone" context:nil];
}

@end



@implementation TestViewModel

-(TestKVOModel *)model{
    if (!_model) {
        _model = [[TestKVOModel alloc] init];
    }
    return _model;
}

+(instancetype)initWithViewController:(TestKVO *)vc{
    TestViewModel *viewModel = [[TestViewModel alloc] init];
    viewModel.vc = vc;
    
    // 1/ 注册监听
    [viewModel.model addObserver:vc forKeyPath:@"phone" options:NSKeyValueObservingOptionNew context:nil]; // name phone
    
    return viewModel;
}

// 移除监听, 或写在控制器里
- (void)dealloc
{
//    [self removeObserver:self.vc forKeyPath:@"models"];
}

@end


/** 下面这个必须写 */
@implementation TestKVOModel



-(void)doesNotRecognizeSelector:(SEL)aSelector{
    NSLog(@"TestKVOModel未实现%s方法", __func__);
}

@end



