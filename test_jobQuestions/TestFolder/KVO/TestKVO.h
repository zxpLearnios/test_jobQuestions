//
//  TestKVO.h
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/18.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestKVO : UIViewController

@end

@interface TestKVOModel : NSObject
{
    NSString *isName; // name _name isName _isName 是等价的。外部不可直接访问
}
@property (nonatomic, copy) NSString *phone;

@end

