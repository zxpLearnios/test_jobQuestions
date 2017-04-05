//
//  TestFive.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/31.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  继TestFour后测试互斥锁, 测试购票时的资源抢夺
//  @synchronized 的作用是创建一个互斥锁，保证此时没有其它线程对self对象进行修改。这个是objective-c的一个锁定令牌，防止self对象在同一时间内被其它线程访问，起到线程的保护作用。
//  使用前提：多个线程使用同一资源时
//  使用格式： @synchronized（锁对象\即多个线程都要去访问的哪个对象）{// 需要锁定的代码}， 一份代码只需要一个锁，再多也无用。
//  优点：能有效防止因多线程访问同一资源而造成的 多线程抢夺资源的数据安全性问题。
//  缺点：会消耗大量的CPU资源，故应尽量少用。
//  线程同步：多个线程在同一个线上执行，按顺序地执行。


#import "TestFive.h"

@interface TestFive ()
@property (nonatomic, strong) TestFive *ticketStoreOne;
//@property (nonatomic, strong) TestFive *ticketStoreTwo;
//@property (nonatomic, strong) TestFive *ticketStoreThree; // 测试在init里初始化时，崩溃的

@property (nonatomic, strong) NSThread *ticketStoreOneThread;
@property (nonatomic, strong) NSThread *ticketStoreTwoThread;
@property (nonatomic, strong) NSThread *ticketStoreThreeThread;

@property (nonatomic, assign) NSInteger ticketCount;
@end

@implementation TestFive

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        // 下面的任何一句，很明显都会造成死循环，因为比如self.ticketStoreOne初始化时调用此类里的init方法，此时又会对self.ticketStoreOne进行初始化，故会导致无限的对self.ticketStoreOne进行初始化
//        self.ticketStoreOne = [[TestFive alloc] init];
//        self.ticketStoreTwo = [[TestFive alloc] init];
//        self.ticketStoreThree = [[TestFive alloc] init];
        
    }
    
     // 下面的任何一句，很明显都会造成死循环，因为比如self.ticketStoreOne初始化时调用此类里的init方法，此时又会对self.ticketStoreOne进行初始化，故会导致无限的对self.ticketStoreOne进行初始化
//    self.ticketStoreOne = [[TestFive alloc] init];
//    self.ticketStoreTwo = [[TestFive alloc] init];
//    self.ticketStoreThree = [[TestFive alloc] init];
//
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.ticketCount = 100;
    
    self.ticketStoreOneThread = [[NSThread alloc] initWithTarget:self selector:@selector(sellTickets) object:nil];
    self.ticketStoreTwoThread = [[NSThread alloc] initWithTarget:self selector:@selector(sellTickets) object:nil];
    self.ticketStoreThreeThread = [[NSThread alloc] initWithTarget:self selector:@selector(sellTickets) object:nil];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.ticketStoreOneThread start];
    [self.ticketStoreTwoThread start];
    [self.ticketStoreThreeThread start];
}


#pragma mark - 卖票
-(void)sellTickets{
    
    while (1) {
        @synchronized(self) { // self在某一时间内只能由一个线程访问
        
            if (self.ticketCount > 0) {
                self.ticketCount --;
                NSLog(@"%@卖了一张票，还剩下%zd张", [NSThread currentThread].name, self.ticketCount);
            } else {
                NSLog(@"票已经卖完了");
                break;
            }
        }
    }
    
}

-(void)dealloc{
    [NSThread exit];
}


@end
