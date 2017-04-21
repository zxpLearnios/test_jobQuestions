//
//  TestCellCacheCell.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/4/21.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import "TestCellCacheCell.h"

@implementation TestCellCacheCell

+(instancetype)cacheCell{
    TestCellCacheCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TestCellCacheCell" owner:nil options:nil] lastObject];
//    [cell setValue:@"reuseIdentifier" forKey:@"reuseIdentifier"];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
