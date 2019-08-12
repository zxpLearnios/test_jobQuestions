//
//  UIView+UIView1.m
//  test_jobQuestions
//
//  Created by Bavaria on 2019/8/12.
//  Copyright © 2019 Jingnan Zhang. All rights reserved.
//

#import "UIView+catagory.h"

@implementation UIView (catagory)

/// 重写set get



-(void)setX:(CGFloat)x {
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    self.frame = CGRectMake(x, self.y, w, h);
}


-(void)setY:(CGFloat)y {
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    self.frame = CGRectMake(self.x, y, w, h);
}


-(CGFloat)x {
    return self.frame.origin.x;
}

-(CGFloat)y {
    return self.frame.origin.y;
}

@end
