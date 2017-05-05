//
//  TestKVO.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/18.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  KVO监听模型的改变

#import <UIKit/UIKit.h>

@interface TestKVO : UIViewController

@end


@class TestKVOModel;
@class TestKVO;
/**测试viewModel里有个model，有个VC。初始化时，初始化model令VC成为model的observe即可。 */
@interface TestViewModel : NSObject
/**控制器对象*/
@property (nonatomic, strong) TestKVO *vc;
/**模型对象*/
@property (nonatomic, strong) TestKVOModel *model;

+(instancetype)initWithViewController:(TestKVO *)vc;

@end



@interface TestKVOModel : NSObject
{
    NSString *isName; // name _name isName _isName 是等价的。外部不可直接访问 
}
@property (nonatomic, copy) NSString *phone; // 外部直接 kvoModel.phone = @"newVaule', 即可被监听到

@end



