//
//  TestManualTriggerKVOViewController.m
//  test_jobQuestions
//
//  Created by 张净南 on 2019/1/4.
//  Copyright © 2019年 Jingnan Zhang. All rights reserved.
//  如何手动触发一个kvo

/**
 但是平时我们一般不会这么干，我们都是等系统去“自动触发”。
 “自动触发”的实现原理：
 比如调用 setNow: 时，系统还会以某种方式在中间插入 wilChangeValueForKey: 、 didChangeValueForKey: 和 observeValueForKeyPath:ofObject:change:context: 的调用。
 大家可能以为这是因为 setNow: 是合成方法，有时候我们也能看到有人这么写代码:
 - (void)setNow:(NSDate *)aDate {
 [self willChangeValueForKey:@"now"]; // 没有必要
 _now = aDate;
 [self didChangeValueForKey:@"now"];// 没有必要
 }
 这完全没有必要，不要这么做，这样的话，KVO代码会被调用两次。KVO在调用存取方法之前总是调用 willChangeValueForKey: ，之后总是调用 didChangeValueForkey: 。怎么做到的呢?答案是通过 isa 混写（isa-swizzling）
 */

#import "TestManualTriggerKVOViewController.h"

@interface TestManualTriggerKVOViewController ()
@property (nonatomic, copy) NSString *name;
@end

@implementation TestManualTriggerKVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.name = @"sff";
    [self addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context: @"name_value"];
    MyLog(@"开始手动触发一个kvo");
    
    [self willChangeValueForKey:@"name"];
    MyLog(@"1");
    [self didChangeValueForKey:@"name"];
    
}

-(void)willChangeValueForKey:(NSString *)key {
    [super willChangeValueForKey:key];
}

-(void)didChangeValueForKey:(NSString *)key {
    [super didChangeValueForKey:key];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    
    
}
@end
