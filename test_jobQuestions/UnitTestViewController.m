//
//  UnitTestViewController.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/5/10.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import "UnitTestViewController.h"

@interface UnitTestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *resultLab;

@end

@implementation UnitTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (IBAction)btnAction:(id)sender {
    if (self.textField.text.length == 0) {
        return;
    }
    if ([self.textField.text isEqual:@"aaa"]) {
     self.resultLab.text = @"验证通过";
    }else{
        
        self.resultLab.text = @"验证不通过";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
