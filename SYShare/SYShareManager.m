//
//  SYShareManager.m
//  simSocial
//
//  Created by aiquantong on 4/6/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "SYShareManager.h"

#import "WXApi.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import "WeiboSDK.h"

static SYShareManager *managerInstance = nil;

static NSString *s_wxAppId = nil;
static NSString *s_qqAppId = nil;

static NSString *s_weiboAppId = nil;
static NSString *s_weiboToken = nil;


static id shareDelegate = nil;

@interface SYShareManager()<TencentSessionDelegate>
{
}

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end

@implementation SYShareManager


-(instancetype)init
{
    self = [super init];
    if (self) {
        self.tencentOAuth = nil;
    }
    return self;
}

+(SYShareManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (managerInstance == nil) {
            managerInstance = [[SYShareManager alloc] init];
        }
    });
    return managerInstance;
}

+(void)weixinRegister:(NSString *)wxAppId;
{
    s_wxAppId = [wxAppId uppercaseString];
    [WXApi registerApp:wxAppId withDescription:@"demo 2.0"];
}

+(void)QQRegister:(NSString *)qqAppId;
{
    s_qqAppId = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[qqAppId integerValue]]];
    
    s_qqAppId = [s_qqAppId uppercaseString];
    
    SYShareManager *sy = [SYShareManager shareInstance];
    
    TencentOAuth *to = [[TencentOAuth alloc] initWithAppId:qqAppId andDelegate:sy];
    sy.tencentOAuth = to;
}

+(void)weiboRegister:(NSString *)weiboAppId;
{
    s_weiboAppId = [weiboAppId uppercaseString];
    [WeiboSDK registerApp:weiboAppId];
}

+(void)enableDebug:(BOOL)isDebug
{
    [WeiboSDK enableDebugMode:isDebug];
}

+(void)printSharePlatformVerison
{
    NSLog(@"weixin verison: %@", [WXApi getApiVersion]);
    NSLog(@"qq verison: %@", [TencentOAuth sdkVersion]);
    NSLog(@"weibo verison: %@", [WeiboSDK getSDKVersion]);
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin;
{
    
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled;
{
    
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork;
{
    
}

+(void)shareTo:(SYShare_Platform)socialPlaform shareObject:(id)shareObject delegate:(id)delegate
{
    switch (socialPlaform) {
        case SYShare_Platform_Weixin:
            [WXApi sendReq:shareObject];
            shareDelegate = delegate;
            break;
            
        case SYShare_Platform_QQ:
            [QQApiInterface sendReq:shareObject];
            shareDelegate = delegate;
            break;
            
        case SYShare_Platform_Weibo:{
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = @"http://www.sina.com";
            authRequest.scope = @"all";
        
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:shareObject authInfo:authRequest access_token:s_weiboToken];
            
            [WeiboSDK sendRequest:request];
            shareDelegate = delegate;
        }
            break;
            
        default:
            break;
    }
}


+(BOOL)handleOpenURL:(NSURL *)url;
{
    BOOL isRet = NO;
    NSString *urlStr = [url.scheme uppercaseString];
    
    if ([urlStr hasPrefix:s_wxAppId]) {
        isRet = [WXApi handleOpenURL:url delegate:shareDelegate];
    }else if([urlStr hasSuffix:s_qqAppId]&&[urlStr hasPrefix:@"QQ"]){
       isRet = [QQApiInterface handleOpenURL:url delegate:shareDelegate];
    }else if([urlStr hasSuffix:s_weiboAppId] && [urlStr hasPrefix:@"WB"]){
        isRet = [WeiboSDK handleOpenURL:url delegate:shareDelegate];
    }else{
    
    }
    
    return isRet;
}


/**
 *          //NSArray* permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_ADD_SHARE,nil];
 //tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"222222" andDelegate:self];
 //[tencentOAuth authorize:permissions inSafari:NO];
 */

@end



