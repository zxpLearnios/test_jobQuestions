//
//  MyPageViewController.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/5/11.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import "MyPageViewController.h"
#import "MyPageChildFirstVC.h"
#import "MyPageChildSecondVC.h"
#import "MyPageChildThreeVC.h"

@interface MyPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong)  MyPageChildFirstVC *firstVC;
@property (nonatomic, strong)  MyPageChildFirstVC *secondVC;
@property (nonatomic, strong) MyPageChildFirstVC *threeVC;
@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
 
    
    self.firstVC = [[MyPageChildFirstVC alloc] init];
    self.secondVC = [[MyPageChildSecondVC alloc] init];
    self.threeVC = [[MyPageChildThreeVC alloc] init];
    
    
    
    [self setViewControllers:@[self.firstVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    if (viewController == self.firstVC) {
        
        [self setViewControllers:@[self.secondVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        return self.secondVC;
    }else if (viewController == self.secondVC) {
        
        [self setViewControllers:@[self.threeVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        return self.threeVC;
    
    }else{
        
        return nil;
//        [self setViewControllers:@[self.threeVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

@end
