//
//  TestSaveDataMethod.m
//  test_jobQuestions
//
//  Created by Jingnan Zhang on 2017/5/3.
//  Copyright © 2017年 Jingnan Zhang. All rights reserved.
//  在开发过程中我们有时候在用户删除时候保存一些信息在用户下次安装应用时候使用，这个时候我们可以使用剪切版UIPasteboard的FindUIPasteboard和钥匙串keychain的使用

#import "TestSaveDataMethod.h"



@interface TestSaveDataMethod ()

@end
@implementation TestSaveDataMethod

-(void)doTest{
    
    NSString *openudid = [PasteBoard uuidCreateNewUDID];
//    NSString *checkOpenUDID = [openudid stringByAppendingFormat:kOpenUDIDAdd, nil];
//    
//    //先把UDID存入字典
//    NSMutableDictionary *localDict = [NSMutableDictionary dictionaryWithCapacity:2];
//    [localDict setObject:openudid forKey:kOpenUDIDKey];
//    [localDict setObject:[checkOpenUDID md5] forKey:kCheckOpenUDIDKey];
//    
//    // 同步数据到剪切板
//    UIPasteboard *slotPB = [UIPasteboard pasteboardWithName:kOpenUDIDPB create:YES];
//    // 设置为永久保存
//    [slotPB setPersistent:YES];
//    //把字典存入剪切版
//    [slotPB setData:[NSKeyedArchiver archivedDataWithRootObject:localDict] forPasteboardType:kOpenUDIDDict];
  
}

@end

/** 1. 剪切板 */
@implementation PasteBoard


+ (NSString *) uuidCreateNewUDID {
    NSString * _openUDID = nil;
    
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    const char *cStr = CFStringGetCStringPtr(cfstring, CFStringGetFastestEncoding(cfstring));
    unsigned char result[16];
//    CC_MD5();
//    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    CFRelease(uuid);
    
    _openUDID = [NSString stringWithFormat:
                 @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08x",
                 result[0], result[1], result[2], result[3],
                 result[4], result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11],
                 result[12], result[13], result[14], result[15],
                 (unsigned int)(arc4random() % NSUIntegerMax)];
    
    CFRelease(cfstring);
    return _openUDID;
}


@end


/** 2. 钥匙串 */
@implementation KeychainManager

+(KeychainManager *)shareInstance{
    static KeychainManager *keychainManager = nil;
    if (keychainManager == nil){
        keychainManager = [[KeychainManager alloc] init];
    }
    return keychainManager;
}

- (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword, (id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock, (id)kSecAttrAccessible,
            nil];
}

- (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

- (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    
    if (keyData){
        CFRelease(keyData);
    }
    return ret;
}

- (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end
