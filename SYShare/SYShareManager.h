//
//  SYShareManager.h
//  simSocial
//
//  Created by aiquantong on 4/6/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SYShare_Platform)
{
    SYShare_Platform_Weixin = 0,
    SYShare_Platform_QQ = 1,
    SYShare_Platform_Weibo = 2
};

@interface SYShareManager : NSObject

+(void)weixinRegister:(NSString *)wxAppId;

+(void)QQRegister:(NSString *)qqAppId;

+(void)weiboRegister:(NSString *)weiboAppId;

+(void)enableDebug:(BOOL)isDebug;

+(void)printSharePlatformVerison;

+(void)shareTo:(SYShare_Platform)socialPlaform shareObject:(id)shareObject delegate:(id)delegate;

+(BOOL)handleOpenURL:(NSURL *)url;

@end
