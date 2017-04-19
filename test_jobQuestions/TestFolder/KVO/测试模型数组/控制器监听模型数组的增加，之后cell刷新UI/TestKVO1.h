//
//  TesrKVOVC.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/19.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  KVO监听模型数组的改变：iOS默认不支持对数组的KVO, 因为普通方式监听的对象的地址的变化，而数组地址不变，而是里面的值发生了改变

#import <UIKit/UIKit.h>

@interface TestKVO1 : UITableViewController

@end


@class TestKVO1;
@class TestKVOModel1;

@interface TestViewModel1 : NSObject

/**模型数组*/
@property (nonatomic, strong) NSMutableArray<TestKVOModel1 *> *models; //
+(instancetype)initWithViewController:(TestKVO1 *)vc;

@end



@interface TestKVOModel1 : NSObject
{
    NSString *isName; // name _name isName _isName 是等价的。外部不可直接访问
}
@property (nonatomic, copy) NSString *phone;
@end

