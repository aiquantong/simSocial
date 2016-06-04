# simSocial
simSocial是开源快速接入地方分享平台的sdk 功能库。
##接入步骤
1，配置第三方的appid
   - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [SYShareManager weixinRegister:@"wxd930ea5d5a258f4f"];
    
    [SYShareManager QQRegister:@"222222"];
    
    [SYShareManager weiboRegister:@"2045436852"];

    return YES;
}

2, 配置来第三方平台的请求回调
  - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL isRet = [SYShareManager handleOpenURL:url];

    return isRet;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isRet = [SYShareManager handleOpenURL:url];


    return isRet;
}

3， 添加uri schame

  ![image](https://github.com/aiquantong/simSocial/blob/master/Screen%20Shot%202016-06-04%20at%201.28.45%20PM.png)
  


