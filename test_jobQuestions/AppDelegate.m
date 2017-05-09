//
//  AppDelegate.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/3/29.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "TestSaveDataMethod.h"

@interface AppDelegate () <UIAlertViewDelegate>
@property (nonatomic, strong) UIUserNotificationSettings *localNotiSet;
@property (nonatomic, strong) UIAlertView *alert;

@end

@implementation AppDelegate

#pragma mark - 收到通知后，若程序被杀死，则点击通知进入程序会触发此法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 0. 收到通知
    UILocalNotification *localNoti = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    
    NSString *show = @"程序被杀死，收到通知后点击通知进入程序，会调用didFinishLaunchingWithOptions";
    if (!self.alert) {
        self.alert = [[UIAlertView alloc] initWithTitle:nil message:show delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    
    
    if (localNoti) {
        [self.alert show];
        MyLog(@"%@", show);
        
        // 取消本地通知
        [application cancelAllLocalNotifications];
    }
    
    // 1. 注册本地通知  >= ios8 & < ios10
    if (!self.localNotiSet) {
        self.localNotiSet = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    }
    
    [application registerUserNotificationSettings:self.localNotiSet];
    
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 运行app你会发现Save只有在你第一次运行app时候打印，如果你把app删除后再运行，也不会清除数据。
//    KeychainManager *manager = [KeychainManager shareInstance];
//    NSString *data = [manager load:@"myName"];
////    [manager delete:@"myName"]; // 删除数据
//    if (data == nil) {
//        NSLog(@"Save");
//        NSString *dataString = @"我是谁";
//        [manager save:@"myName" data:dataString];
//    }
//    NSLog(@"data = %@",data);

}


#pragma mark - 1. 收到通知，若程序在前台 或 原来在后台之后点击通知进入前台时，会调用此（ios10之后本地通知仍调用之，远程推送则调用UNUserNotificationCenterDelegate的方法）
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    NSString *showStr;
    
    if (ksystemVersion >= 10) {
        showStr = @"ios10 程序在前台或后台时，收到通知会调用didReceiveLocalNotification";
    }else{
        showStr = @"ios8 程序在前台或后台时，收到通知会调用didReceiveLocalNotification";
    }
    
    UILocalNotification *localNoti = notification;
    if (localNoti.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber -- ;
    }else{
        // 取消本地通知
        [application cancelLocalNotification:localNoti];
    }
    self.alert.message = showStr;
    [self.alert show];
    MyLog(@"%@", showStr);
}

#pragma mark - ios8 收到远程推送
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo{

}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        return;
    }else{
        [alertView removeFromSuperview];
    }
}

@end
