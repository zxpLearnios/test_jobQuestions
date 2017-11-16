//
//  TestAlgorithm.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/9/5.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  测试算法

#import "TestAlgorithm.h"

@implementation TestAlgorithm


-(void)doTest{
    NSArray<NSNumber*> *ary = @[@123.22, @99.8, @2, @832, @90.7];
    
//    [self sortmAryByBubble:ary isAscend:YES];
    [self sortmAryByFast:ary left:0 right:4 isAscend:NO];
}

/**
 * 1. 冒泡法排序数组  只能对整形数排序
 * 冒泡排序（Bubble Sort），是一种计算机科学领域的较简单的排序算法。
    它重复地走访过要排序的数列，一次比较两个元素，如果他们的顺序错误就把他们交换过来。走访数 列的工作是重复地进行直到没有再需要交换，也就是说该数列已经排序完成。
    这个算法的名字由来是因为越大的元素会经由交换慢慢“浮”到数列的顶端，故名。
 */
-(void)sortmAryByBubble:(NSArray *)ary isAscend:(BOOL)isAscend{
    NSMutableArray *mAry = [NSMutableArray arrayWithArray:ary];
    
    // 总共需要比较几对相邻的数，每次比较后都会使数组的最后位置的值最大或最小
    // 由于每次比较后，都使某一个数无须再参加比较，故每次可使数组里需要参加比较的元素总数-1，
    for (int i=0; i<mAry.count-1; i++) {
        
        // 第i次时需要比较的 相邻数的次数， 从
        for (int j=0; j<mAry.count - 1 - i; j++) {
            
            
            NSNumber *leftNum = ary[j];
            NSNumber *rightNum = ary[j+1];
            
            int a, b, tmp = 0;
            
            a = [leftNum intValue];
            b = [rightNum intValue];
            
            if (isAscend) {
                // 升序
                if (a >= b) {
                    tmp = a;
                    a = b;
                    b = tmp;
                }
                
            }else{
                // 降序
                if (a <= b) {
                    tmp = a;
                    a = b;
                    b = tmp;
                }
            }
            
            // 赋值
            leftNum = @(a);
            rightNum = @(b);
            
            mAry[j] = leftNum;
            mAry[j+1] = rightNum;
            
        }
    }
    
    
    MyLog(@"排序后的数组为：%@", mAry);
}

/**
 * 2. 快速排序法: 递归版。 只能对整形数排序： OC里，只能对整型数组进行排序，否则，无法实现效果的。OC数组里存的是NSNumber对象，在转为float是会出现精度偏差
 
 *快速排序(Quicksort)是对冒泡排序的一种改进。
 * 传入起点位置、结束点位置, 里面可以有相等的数字
 * 快速排序由C. A. R. Hoare在1962年提出。它的基本思想是：通过一趟排序将要排序的数据分割成独立的两部分，其中一部分的所有数据都比另外一部分的所有数据都要小，然后再按此方法对这两部分数据分别进行快速排序，整个排序过程可以递归进行，以此达到整个数据变成有序序列。
 快速排序不是一种稳定的排序算法，也就是说，多个相同的值的相对位置也许会在算法结束时产生变动。
 */
-(void)sortmAryByFast:(NSArray<NSNumber*> *)ary left:(int)left right:(int)right  isAscend:(BOOL)isAscend{
    
    if (left >= right) {
        return;
    }
    
    NSMutableArray<NSNumber*> *mAry = [NSMutableArray arrayWithArray:ary];
    [[NSRunLoop mainRunLoop] addTimer:nil forMode:NSRunLoopCommonModes];
    int i = left;
    int j = right;
    float tmp = [mAry[i] floatValue];
    
        while (i < j) {
            if (isAscend) { // 升序
                while([(NSNumber *)mAry[j] floatValue] >= tmp && i <= j){
                    j--;
                }
                
                if(j >= i){
                    mAry[i] = mAry[j]; //比划分元小的交换到左边
                    i++;
                }
                
                while([(NSNumber *)mAry[i] floatValue] < tmp && i<j){
                    i ++;
                }
                
                if(i < j){
                    mAry[j] = mAry[i]; //比划分元大的交换到右边
                    j--;
                }
                
                MyLog(@"排序后的数组为： %@", mAry);
            }else{ // 降序
                while([(NSNumber *)mAry[j] floatValue] <= tmp && i <= j){
                    j --;
                }
                
                if(j > i){
                    mAry[i] = mAry[j]; //比划分元小的交换到左边
                    i++;
                }
                
                while([(NSNumber *)mAry[i] floatValue] > tmp && i < j){
                    i ++;
                }
                
                if(i < j){
                    mAry[j] = mAry[i]; //比划分元大的交换到右边
                    j--;
                }
                
                MyLog(@"排序后的数组为： %@", mAry);
            }
        }
    
    mAry[i] = @(tmp);
    if(left < i)
          [self sortmAryByFast:mAry left: left right: i- 1 isAscend:isAscend];
    if(i < right){
      [self sortmAryByFast:mAry left: j+1 right: right isAscend:isAscend];
    }
    
}


@end
