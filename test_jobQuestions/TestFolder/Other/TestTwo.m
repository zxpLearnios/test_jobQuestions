//
//  TestTwo.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/29.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  控制器的生命周期，加载顺序等。 --1--3--4--2的先后顺序永远不会颠倒的
//  1. 外部只TestTwo *tt = [[TestTwo alloc] init]的话，不论loadview里是否指定view，最终打印结果都为 --1 --3 --4 --2
//  2. 外部只 TestTwo *tt = [[TestTwo alloc] init]; tt.view.backgroundColor = [UIColor blueColor]; 且loadview里未指定view的话， 最终打印结果为 --1 --3 --4 --2 --3 --4; 若loadview里指定view的话，最终打印结果为 --1 --3 --4 --2。正印了loadView方法上面的4.的注释
//  3. 若外部只 TestTwo *tt = [[TestTwo alloc] init]; [self.navigationController pushViewController:tt animated:YES]; 并且loadView里未指定view时，则最终打印结果为 --1 ---3 --4 ---2--3--4--3--4---5---3--4--3--4--3--4---3--4。若loadView里指定了view时，则就是正常的打印结果  -1 --3 --4 --2 --5。 3.1 即不管如何，只要是此控制器alloc init后，外部要push之，则会由于loadView里若未指定view时，则会先调用--loadView--viewDidLoad--loadView--viewDidLoad---viewWillAppear 之后再紧接着调用--loadView--viewDidLoad（4次），因为调用loadView后立马就会再去调用viewDidLoad的； 3.2 若loadView里指定view，则最终打印结果都为 --1--3--4--2--5




#import "TestTwo.h"


@implementation TestTwo

-(instancetype)init{
    self = [super init];
    MyLog(@"------------1");
    if (self) { // 有无此句，打印顺序都不会变
        // 由于此时，控制器被初始化而他的view还未被加载完成，故使用self.view时就会调用loadview。调用self.view就相当于调用loadview。若loadView里未指定self.view = ？则之后看到的将是黑色的view。故设置背景色最好在viewdidLoad里进行
        self.view.backgroundColor = [UIColor blueColor];
    }

    MyLog(@"------------2");
    return self;
}

// 1. 不管有无此方法，都会先打印4再打印2。   2. 即使是重写了此法，若loadView里未指定self.view = ？，外部使用self.view时，也不会调用loadView。   3. 总之是先调用loadView之后紧接着就调用viewDidLoad来加载view，二者紧密相连  4. 控制器的跟视图为空且此view被访问时，就会调用loadView方法，  5. 起指定view的作用
-(void)loadView{
    // 由于这里为给view赋frame，故view.frame=CGRectZero 不管在哪里都看不到自己的view的
//    self.view = [[UIView alloc] init];
    // 这句是正确的
    self.view = [[UITableView alloc] init];
    MyLog(@"------------3");
}


// view创建完毕
-(void)viewDidLoad{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor blueColor];
    MyLog(@"------------4");
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    MyLog(@"------------5");
}

@end
