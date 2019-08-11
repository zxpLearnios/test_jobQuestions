//
//  ViewController.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/29.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import "ViewController.h"
#import "TestOne.h"
#import "TestTwo.h"
#import "TestThree.h"
#import "TestFour.h"
#import "TestFive.h"
#import "TestSix.h"
#import "TestSeven.h"
#import "TestEight.h"
#import "TestNine.h"
#import "TestTen.h"
#import "Test11.h"
#import "Test12.h"
#import "TestCoreData.h"
#import "Test13.h"
#import "Test14.h"
#import "TestKVO.h"
#import "TestKVO1.h"
#import "TestKVO2.h"
#import "TestKVOObjectManager.h"
#import "TestThreeTypeBlock.h"

#import "TestDynamicJson.h"
#import "TestMyExtension.h"
#import "TestBlockReference.h"
#import "TestCellCacheMethod.h"
#import "TestCopy.h"
#import "LearnSDWebImage.h"
#import "TestMemoryDiskCache.h"
#import "TestLocalNotificate.h"

#import "TestConstPointer.h" // 指针常量、常量指针

#import "UnitTestViewController.h"
#import "MyPageViewController.h"
#import "TestSendInfoVCOne.h"
#import "TestUpdateUI.h"
#import "TestManualTriggerKVOViewController.h"

#import "TestAlgorithm.h" // 算法
#import "TestSaveData.h" // 数据存储方式
#import "TestNewKl.h" // 其他知识
#import "TestAutoReleaspool.h" // 释放池
#import <CoreFoundation/CoreFoundation.h>
#import "TestRunTimePeople.h"
#import "TestRetainCycleInBlock.h"


@interface ViewController ()
{
     __weak UIViewController *wself;
}
//@property (nonatomic, strong) NSThread *td;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *ary = @[@"1"];
    
    // 测试runtime解决数组越界等问题
    NSMutableArray *mAry = [NSMutableArray array];
    [mAry addObject:@(1)];
//    NSString *str = [mAry objectAtIndex:12];
    
    // 出了这个函数后，wself就会立即被释放 变为nil
    UIViewController *vc= [[UIViewController alloc] init];
    wself = vc;
//    [self testRunloopAndThread];
//    [self testRunloopObserver];
    
    double result = [self getresult:100];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%f", result);
    });
}

double result;
-(double)getresult:(double)num {
    if (num == 1) {
        result = 1;
    } else {
        result = [self getresult:(num - 1)] + num;
    }
    return result;
}

/*
 runloop 与 线程
 1. 每个线程都有唯一的runloop与之对应，他们的对应关系由系统自行存储在一个(未知的)字典里
 2. 主线程的runloop默认开启
 3. 子线程里默认无runloop， 即不开启runloop。只有在子线程里主动获取runloop时，这时才会创建一个runloop，此runloop会在线程销毁时被回收
 */
-(void)testRunloopAndThread {
    NSThread *td = [[NSThread alloc] initWithTarget:self selector:@selector(sAction) object:nil];
    [td start];
}

-(void)sAction {
    
    NSRunLoop *rp = [NSRunLoop currentRunLoop];
    
}


-(void)testRunloopObserver {
    CFRunLoopObserverRef rpObserverRef = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {

        // 监听main runloop的状态
        NSLog(@"当前mainRunloop的状态为：%lu", activity);
        
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), rpObserverRef, kCFRunLoopDefaultMode);
    CFRelease(rpObserverRef);
}

- (IBAction)testoneAction:(UIButton *)sender {
    
    //1. TestOne作为局部变量，在初始化后调用方法1时，很快就会被释放；但若在初始化后调用方法2时，则不会被释放
    TestOne *to = TestOne.shared; // [[TestOne alloc] init];
    [to doTest];
}


- (IBAction)gotoTestTwoVCAction:(UIButton *)sender {
    
    // 2.
    TestTwo *tt = [[TestTwo alloc] init];
    tt.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:tt animated:YES];
    
}



#pragma mark - 单元测试
- (IBAction)gotoUnitTestVC:(id)sender {
    UnitTestViewController *vc = [[UnitTestViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (IBAction)testThreeAndThenAction:(UIButton *)sender {
    
    if (sender.tag == 0) { // 测试三
        TestThree *tt = [[TestThree alloc] init];
        [tt doTest];
    }else if (sender.tag == 1){ // 测试四
        TestFour *tt = [[TestFour alloc] init];
        [tt doTest];
    }else if (sender.tag == 2){ // 测试五
        TestFive *tt = [[TestFive alloc] init];
        [self.navigationController pushViewController:tt animated:YES];
    }else if (sender.tag == 3){ // 测试六
        TestSix  *tt = [[TestSix alloc] init];
        [tt doTest];
    }else if (sender.tag == 4){ // 测试七
        TestSeven  *tt = [[TestSeven alloc] initWithFrame:CGRectMake(0, 100, 300, 400)];
        [self.view addSubview:tt];
        
    }else if (sender.tag == 5){ // 测试8
        TestEight  *tt = [[TestEight alloc] initWithFrame:CGRectMake(10, 100, 100, 40)];
        [self.view addSubview:tt];
        
    }else if (sender.tag == 6){ // 测试9
        TestNine *ttNine = [[TestNine alloc] initWithFrame:CGRectMake(10, 100, 100, 40)];
        [self.view addSubview:ttNine];
        ttNine.clipsToBounds = YES; // 存储区域的按钮此时不可见，此时一些不可见的区域依然可以响应时因为按钮的父viewttNine重写了hitTest方法（即使按钮不重写pointInside）结果也一样
        TestEight  *t8 = [[TestEight alloc] initWithFrame:CGRectMake(-10, -10, 120, 30)];
        [ttNine addSubview:t8];
        
        
    }else if (sender.tag == 7){ // 测试10
        TesthitTestViewA *t = [TesthitTestViewA getSelf];
        [self.view addSubview:t];
    }else if (sender.tag == 8) { // 11
        
        Test11 *t = [[Test11 alloc] initWithFrame:CGRectMake(50, 150, 300, 100)];
        [self.view addSubview:t];
    }else if (sender.tag == 9) { // 12
//        [Test12 getIvarListFromClass:[Student class]];
//        [Test12 getPropertyListFromClass:[Student class]];
        [Test12 noUse];
        
    }else if (sender.tag == 10) { // 13
        TestCoreData *td = [[TestCoreData alloc] init];
        [self.navigationController pushViewController:td animated:YES];
        
    }else if (sender.tag == 11) { // 14
        
        // 1.
        BaseTest *dj = [[BaseTest alloc] init];
        dj = [[TestThreeTypeBlock alloc]init];  // TestKVOObjectManager.shared; // [[TestKVOObjectManager alloc] init]; // Test13 Test14  TestDynamicJson  TestMyExtension  TestBlockReference  TestCopy  LearnSDWebImage   TestLocalNotificate  TestAlgorithm  TestSaveData  TestNewKl  TestAutoReleaspool  TestKVOObjectManager TestCopyAndStrongModifyString  TestConstPointer  TestRetainCycleInBlockA
        [dj doTest];
        
        // 1.1 类方法
//        [TestKVOObjectManager doClassTest];
        
        
        // 2.
//        UIViewController *td = [[UIViewController alloc] init];
//        td = [[TestManualTriggerKVOViewController alloc] init]; // TestKVO TestKVO1 TestKVO2  TestCellCacheMethod  TestMemoryDiskCache   MyPageViewController  TestSendInfoVCOne TestCoreData TestUpdateUI  TestKVO2
//        [self.navigationController pushViewController:td animated:YES];
        
        // 测试外部调用objc的对象方法时，发生了啥,objc_msgsend(id tagert, string methodname)
//        TestRunTimePeople *trtP = [[TestRunTimePeople alloc] init];
//        [trtP performSelector:@selector(speak)];
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
