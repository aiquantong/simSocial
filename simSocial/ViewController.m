//
//  ViewController.m
//  simSocial
//
//  Created by aiquantong on 3/6/2016.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "ViewController.h"

#import "SYShareModel.h"
#import "SYShareViewController.h"

#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onshare:(id)sender
{
    SYShareModel *ml = [[SYShareModel alloc] init];
    ml.title = @"test";
    ml.content = @"teste1111111";
    ml.image = [UIImage imageNamed:@"UMS_wechat_session_icon"];
    ml.url = @"http://www.qq.com";
    
    SYShareViewController *shareViewController = [[SYShareViewController alloc] init];
    shareViewController.model = ml;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.sYShareVC = shareViewController;
    
    UIViewController *rootController = appDelegate.window.rootViewController;
    
    [shareViewController showInView:rootController];
}


-(IBAction)weixinLogin:(id)sender
{

}

-(IBAction)QQLogin:(id)sender
{
    
}

-(IBAction)weiboLogin:(id)sender
{
    
}


@end
