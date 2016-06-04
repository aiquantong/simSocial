//
//  SYShareViewController.h
//  shuiYun
//
//  Created by aiquantong on 3/15/16.
//  Copyright © 2016 quantong. All rights reserved.
//

#import "SYShareModel.h"
#import <UIKit/UIKit.h>
#import "WXApi.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "libWeiboSDK/WeiboSDK.h"


typedef NS_ENUM(NSInteger, SYShare_Type) {
  SYShare_WEChat_Session = 0,
  SYShare_WEChat_Timeline = 1,
  SYShare_WEChat_Favorite = 2,
  SYShare_QQ = 3,
  SYShare_QZone = 4,
  SYShare_Weibo = 5,
  SYShare_mail = 6,
  SYShare_sms = 7
};

@interface SYShareViewController : UIViewController<WXApiDelegate, QQApiInterfaceDelegate>

@property (nonatomic, strong) SYShareModel *model;

- (void)showInView:(UIViewController *)persentViewController;
@end
