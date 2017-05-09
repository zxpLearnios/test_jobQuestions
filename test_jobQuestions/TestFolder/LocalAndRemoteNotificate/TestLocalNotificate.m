//
//  TestLocalNotificate.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/5/9.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
/*
 1. ios 10之后，本地通知和和远程推送合成一个类了.
 2. ios8 和ios10 收到本地通知后，调用的方法不变；ios10之后远程推送则调用UNUserNotificationCenterDelegate的方法，而ios8仍调用）

 */

#import "TestLocalNotificate.h"
#import <UserNotifications/UserNotifications.h> // ios10 新增通知框架，类似于ios8强UIWebView整合到Webkit


@interface TestLocalNotificate ()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) UILocalNotification *localNoti; // ios8
@property (nonatomic, strong) UNUserNotificationCenter *localNotiCenter; // ios8

@end
@implementation TestLocalNotificate

-(UILocalNotification *)localNoti{
    if (!_localNoti) {
        _localNoti = [[UILocalNotification alloc] init];
        _localNoti.applicationIconBadgeNumber = 1;
        _localNoti.alertTitle = @"ios8本地通知";
        _localNoti.alertBody = @"ios8有新的通知了";
        
        NSString *str = @"ios8知道了";
        NSString *newStr = str.localizedCapitalizedString;
        _localNoti.alertAction = newStr;
        
        _localNoti.fireDate  = [NSDate dateWithTimeIntervalSinceNow: 8];
        // 通知的额外信息
        _localNoti.userInfo = @{@"date": @"2017-9-0", @"scheduel": @"去开会"};
    }
    return _localNoti;
}




-(void)doTest{
    
    if (ksystemVersion >= 10) {
     
        if (!_localNotiCenter) {
            _localNotiCenter = [UNUserNotificationCenter currentNotificationCenter];
            // 设置代理
            _localNotiCenter.delegate = self;
            
            // 0. 请求获取通知权限（角标，声音，弹框）。iOS 10 使用以下方法注册，才能得到授权
            [_localNotiCenter requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    // 获取用户是否同意开启通知
                    NSLog(@"request authorization successed!");
                }
            }];
        
            // 1. 新建通知内容对象
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = @"ios10本地通知";
            content.subtitle = @"ios10本地通知子标题";
            content.body = @"ios10有新通知";
            content.sound = [UNNotificationSound defaultSound];
            content.userInfo = @{@"date": @"2017-9-0", @"scheduel": @"去开会"};
            content.badge = @(kappication.applicationIconBadgeNumber + 1);
            content.categoryIdentifier = @"com.zjn.www";
            
            
            // 1.1 附件:图片、音频、视频  须支持3Dtouch，重压之下触发. 需要注意，UNNotificationContent的附件数组虽然是一个数组，但是系统的通知模板只能展示其中的第一个附件，设置多个附件也不会有额外的效果，但是如果开发者进行通知模板UI的自定义，则此数组就可以派上用场了。
            NSURL *attachUrl = [[NSBundle mainBundle] URLForResource:@"general" withExtension:@".jpg"];
            UNNotificationAttachment *imgAttachment = [UNNotificationAttachment attachmentWithIdentifier:@"attachment-id" URL:attachUrl options:nil error:nil];
            if (attachUrl&&imgAttachment) {
                content.attachments = @[imgAttachment];
            }
            
            // 2.
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:8 repeats:NO];
            // 3.
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"self_noti_id" content:content trigger:trigger];
            
            // 4. action Category， 在收到通知后做处理
            UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"策略1行为1" options:UNNotificationActionOptionForeground];
            
            UNTextInputNotificationAction *action2 = [UNTextInputNotificationAction actionWithIdentifier:@"action2" title:@"策略1行为2" options:UNNotificationActionOptionDestructive textInputButtonTitle:@"comment" textInputPlaceholder:@"reply"];
            
            //UNNotificationCategoryOptionNone
            //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
            //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
            UNNotificationCategory *category1 = [UNNotificationCategory  categoryWithIdentifier:@"catagory_id" actions:@[action1, action2] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
            
            NSSet *actionSet = [NSSet setWithObjects:category1, nil];
            [_localNotiCenter setNotificationCategories: actionSet];
            
            // 4. 将通知加到通知中心
            [_localNotiCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error) {
                    MyLog(@"ios10注册发送通知出错%@", error);
                }
            }];
            
        }

        
    }else{
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8) {
            // 执行本地通知
            [[UIApplication sharedApplication] scheduleLocalNotification:_localNoti];
        }
    }
    
    
}


#pragma mark - UNUserNotificationCenterDelegate
// ioa10后，本地\远程通知前进行处理前, 在展示通知前再修改通知内容
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{

}
// ioa10后，本地\远程通知 调用
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
//    NSDictionary *userInfo = response.notification.request.content.userInfo;
//    
//    if ( [UIApplication sharedApplication].applicationState == UIApplicationStateActive) {// 程序在运行过程中受到推送通知
//        // TODO
//    } else { //在background状态受到推送通知
//        // TODO
//    }
//    
//    completionHandler(UIBackgroundFetchResultNewData);
    
    UNNotification *noti = response.notification;
    NSInteger badge = [noti.request.content.badge integerValue];
    
    if (badge != 0 ){
        badge -- ;
        [kappication cancelAllLocalNotifications];
        MyLog(@"ios10 收到本地通知了");
        completionHandler(UNNotificationPresentationOptionAlert);
    }else{
        
    }
    
}

@end


