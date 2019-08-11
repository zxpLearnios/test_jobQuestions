//
//  TestCellCacheMethod.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/21.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
/*
    重⽤原理:当滚动列表时,部分UITableViewCell会移出窗口,UITableView会将窗口外的UITableViewCell放入一个对象池中,等待重用。当UITableView要求dataSource返回 UITableViewCell时,dataSource会先查看这个对象池,如果池中有未使用的UITableViewCell,dataSource则会用新的数据来配置这个UITableViewCell,然后返回给 UITableView,重新显示到窗口中,从而避免创建新对象 。这样可以让创建的cell的数量维持在很低的水平，如果一个窗口中只能显示5个cell，那么cell重用之后，最多只需要创建6个cell就够了。
 */

#import "TestCellCacheMethod.h"
#import "TestCellCacheCell.h"


static  NSString const * _Nonnull cellId = @"TestCellCacheCell";
@implementation TestCellCacheMethod {
    NSInteger count;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    // 正好可以显示10行
    self.tableView.rowHeight = kheight / 10;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // 1.
    
    // 2.  会这届将cell加入缓存池，在cellForRow里可以直接从缓存池里拿来用
//    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    // 3.
    
}

-(void)doTest{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

//// 1.
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    TestCellCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//
//    if (!cell) {
//        NSLog(@"cell为空 ---- %ld", count ++);
//        // 1. 此法不会缓存任何cell
////        cell = [TestCellCacheCell cacheCell];
//        
//    }
//    return cell;
//}

// 2.
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    TestCellCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
//    
//    if (!cell) { // cell会这届从缓存池里取
//        NSLog(@"cell为空 ---- %ld", count ++);
//    }
//    return cell;
//}

// 3.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestCellCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    
    if (!cell) { // cell会这届从缓存池里取
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellId];
        NSLog(@"cell为空 ---- %ld", count ++);
//        cell = [TestCellCacheCell cacheCell];
    }
    return cell;
}

@end



