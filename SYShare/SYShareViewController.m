//
//  SYShareViewController.m
//  shuiYun
//
//  Created by aiquantong on 3/15/16.
//  Copyright © 2016 quantong. All rights reserved.
//

#import "SYShareViewController.h"

#import "WXApi.h"
#import "WXApiObject.h"
#import <MessageUI/MessageUI.h>

#import "SYShareCollectionViewCell.h"
#import "UIAlertUtil.h"

#import "SYShareManager.h"

#define SYShareCollectionMeginLeftRight 5
#define SYShareCollectionMeginTop 15
#define SYShareCollectionMeginButton 10

#define LineNum 5
#define SYShareCellWidth ([UIScreen mainScreen].bounds.size.width-SYShareCollectionMeginLeftRight*2)/LineNum - 1
#define SYShareCellHeight 90


static NSString *cellName = @"SYShareCellIdentifier";

@interface SYShareViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate,TencentLoginDelegate, WeiboSDKDelegate>
{
  TencentOAuth *tencentOAuth;
    
  MFMessageComposeViewController *messageVC;
  MFMailComposeViewController *mailVC;
  
  NSMutableArray *mtableViewArr;
  UICollectionView *mCollectionView;
}

@end


@implementation SYShareViewController

- (void)showInView:(UIViewController *)persentViewController
{
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [persentViewController presentViewController:self animated:NO completion:nil];
  } else {
    self.modalTransitionStyle = UIModalPresentationCurrentContext;
    persentViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    persentViewController.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [persentViewController presentViewController:self animated:NO completion:nil];
  }
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self initBackButton];
  
  mtableViewArr = [[NSMutableArray alloc] initWithCapacity:10];
  
    if (self.model != nil) {
        if ([WXApi isWXAppInstalled]) {
            [mtableViewArr addObject:[[NSNumber alloc] initWithInt:SYShare_WEChat_Timeline]];
            [mtableViewArr addObject:[[NSNumber alloc] initWithInt:SYShare_WEChat_Session]];
            [mtableViewArr addObject:[[NSNumber alloc] initWithInt:SYShare_WEChat_Favorite]];
        }
        
        if ([QQApiInterface isQQInstalled]) {
            [mtableViewArr addObject:[[NSNumber alloc] initWithInt:SYShare_QQ]];
            [mtableViewArr addObject:[[NSNumber alloc] initWithInt:SYShare_QZone]];
        }
        
        if ([WeiboSDK isCanShareInWeiboAPP]) {
            [mtableViewArr addObject:[[NSNumber alloc] initWithInt:SYShare_Weibo]];
        }
        
        [mtableViewArr addObject:[[NSNumber alloc] initWithInt:SYShare_sms]];
        [mtableViewArr addObject:[[NSNumber alloc] initWithInt:SYShare_mail]];
    }
  
  UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
  flowLayout.minimumInteritemSpacing = 1;
  flowLayout.minimumLineSpacing = 1;
  
  int mcollectionViewWith = [UIScreen mainScreen].bounds.size.width - 2*SYShareCollectionMeginLeftRight;
  int mcollectionVieheight = (SYShareCellHeight+1)*((int)([mtableViewArr count] + LineNum-1)/LineNum);
  CGRect mCollectionViewFrame = CGRectMake(SYShareCollectionMeginLeftRight, SYShareCollectionMeginTop, mcollectionViewWith, mcollectionVieheight);
  
  CGRect mViewFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - mcollectionVieheight - SYShareCollectionMeginTop - SYShareCollectionMeginButton, [UIScreen mainScreen].bounds.size.width, mcollectionVieheight + SYShareCollectionMeginTop + SYShareCollectionMeginButton);
  
  UIView *mView = [[UIView alloc] initWithFrame:mViewFrame];
  mView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
  [self.view addSubview:mView];
  
  mCollectionView = [[UICollectionView alloc] initWithFrame:mCollectionViewFrame collectionViewLayout:flowLayout];
  mCollectionView.delegate = self;
  mCollectionView.dataSource = self;
  mCollectionView.backgroundColor = [UIColor clearColor];
  [mView addSubview:mCollectionView];
  
  [mCollectionView registerClass:[SYShareCollectionViewCell class] forCellWithReuseIdentifier:cellName];
}


-(void) initBackButton
{
  UIButton *bt = [[UIButton alloc] initWithFrame:self.view.frame];
  bt.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
  [self.view addSubview:bt];
  [bt addTarget:self action:@selector(guestureCallBack:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)guestureCallBack:(id)sender
{
  [self.view endEditing:YES];
  [self dismissViewControllerAnimated:NO completion:NULL];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [mtableViewArr count];
}


//每个UICollectionView展示的内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  SYShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
  NSNumber *md = [mtableViewArr objectAtIndex:[indexPath row]];
  SYShare_Type sy = (SYShare_Type)md.intValue;
  [cell setModel:sy];
  
  return cell;
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return CGSizeMake(SYShareCellWidth, SYShareCellHeight);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSNumber *md = [mtableViewArr objectAtIndex:[indexPath row]];
  SYShare_Type sy = (SYShare_Type)md.intValue;
  [self doShareButtonAction:sy];
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
  return CGSizeMake(0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 1;
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}


-(void)doShareButtonAction:(SYShare_Type)shareType
{
  if(shareType == SYShare_WEChat_Timeline ||
     shareType == SYShare_WEChat_Session ||
     shareType == SYShare_WEChat_Favorite){
    [self doShareWxAction:shareType];
  }else if(shareType == SYShare_mail){
    [self doShareMailAction];
  }else if (shareType == SYShare_sms) {
    [self doShareSmsAction];
  }else if(shareType == SYShare_QQ ||
           shareType == SYShare_QZone){
      [self doShareQQ:shareType];
  }else if(shareType == SYShare_Weibo){
      [self doShareWeibo:shareType];
  }else{
    
  }
}


-(void)doShareSmsAction
{
  if ([MFMessageComposeViewController canSendText] == YES) {
    
    messageVC = [[MFMessageComposeViewController alloc] init];
    messageVC.messageComposeDelegate = self;
    
    messageVC.recipients = @[@"请选择好友"];
    messageVC.body =[NSString stringWithFormat:@"%@ -- %@ -- %@",self.model.title, self.model.content,self.model.url];
    [self presentViewController:messageVC animated:YES completion:nil];
    
  }else{
    [UIAlertUtil showAlertWithTitle:@"提示信息" message:@"此设备不支持发送短信！" persentViewController:self];
  }
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
  
  [controller dismissViewControllerAnimated:NO completion:nil];
  
  switch (result) {
    case MessageComposeResultCancelled:
    case MessageComposeResultFailed:
      [UIAlertUtil showAlertWithTitle:@"提示信息" message:@"短息发送失败！" persentViewController:self];
      break;
    case MessageComposeResultSent:
      //[UIAlertUtil showAlertWithTitle:@"提示信息" message:@"短息发送成功！" persentViewController:self];
      [self dismissViewControllerAnimated:NO completion:nil];
      break;
    default:
      break;
  }
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(void)doShareMailAction
{
  if ([MFMailComposeViewController canSendMail] == YES) {
  
    mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;
    
    [mailVC setSubject:self.model.title];
    
    //  NSArray *toRecipients = [NSArray arrayWithObject:@"donald.wong5@gmail.com"];
    //  [mailVC setToRecipients:toRecipients];
    
    // Attach an image to the email
    [mailVC setMessageBody:[NSString stringWithFormat:@"%@ %@",self.model.content, self.model.url] isHTML:NO];
    
    if (self.model.image) {
      NSData *myData = UIImageJPEGRepresentation(self.model.image, 0.5);
      [mailVC addAttachmentData:myData mimeType:@"image/png" fileName:@"icon.png"];
    }
    
    [self presentViewController:mailVC animated:YES completion:NULL];
  }else{
    [UIAlertUtil showAlertWithTitle:@"提示信息" message:@"请先配置邮箱客户端！" persentViewController:self];
  }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
  [controller dismissViewControllerAnimated:NO completion:nil];
  
  switch (result) {
    case MFMailComposeResultCancelled:
    case MFMailComposeResultSaved:
    case MFMailComposeResultFailed:
        [UIAlertUtil showAlertWithTitle:@"提示信息" message:@"邮件发送失败" persentViewController:self];
      break;
      
    case MFMailComposeResultSent:
        //[UIAlertUtil showAlertWithTitle:@"提示信息" message:@"邮件发送成功" persentViewController:self];
        [self dismissViewControllerAnimated:NO completion:nil];
      break;
      
    default:
      break;
  }

}


-(void)doShareWxAction:(SYShare_Type)shareType
{
  enum WXScene type;
  if (shareType == SYShare_WEChat_Session) {
    type = WXSceneSession;
  }else if(shareType == SYShare_WEChat_Timeline){
    type = WXSceneTimeline;
  }else if(shareType == SYShare_WEChat_Favorite){
    type = WXSceneFavorite;
  }else{
    return;
  }
  
  WXMediaMessage *message = [WXMediaMessage message];
  message.title = self.model.title;
  message.description = self.model.content;
  [message setThumbImage:self.model.image];
  
  WXWebpageObject *ext = [WXWebpageObject object];
  ext.webpageUrl = self.model.url;
  
  message.mediaObject = ext;
  
  SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
  req.bText = NO;
  req.message = message;
  req.scene = type;
  
  [SYShareManager shareTo:SYShare_Platform_Weixin shareObject:req delegate:self];
}

#pragma mark - WXApiDelegate
- (void)onResp:(id)resp {
    if ([resp isKindOfClass:[BaseResp class]]) {
        [self onWxResp:(BaseResp*)resp];
    }else if([resp isKindOfClass:[QQBaseResp class]]){
        [self onQQResp:(QQBaseResp*)resp];
    }else{
    
    }
}


- (void)onReq:(id)req {
    if ([req isKindOfClass:[BaseReq class]]) {
        [self onWxReq:(BaseReq*)req];
    }else if([req isKindOfClass:[QQBaseReq class]]){
        [self onQQReq:(QQBaseReq*)req];
    }else{
        
    }
}



- (void)onWxResp:(BaseResp *)resp {
  
  if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
    
  } else if ([resp isKindOfClass:[SendAuthResp class]]) {
    
  } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
    
  }else{
    
  }
  
  if (resp.errCode == 0) {
      [self dismissViewControllerAnimated:NO completion:NULL];
  }else{
    NSString *errMsg = [NSString stringWithFormat:@"分享失败，原因：%d", resp.errCode];
    [UIAlertUtil showAlertWithTitle:@"分享失败" message:errMsg persentViewController:self];
  }
}


- (void)onWxReq:(BaseReq *)req {
  
  if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
    
  } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
    
  } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
    
  }else{
    
  }
}


-(void)doShareQQ:(SYShare_Type)shareType
{
    NSData* data = UIImageJPEGRepresentation(self.model.image, 0.5);
    NSURL* url = [NSURL URLWithString:self.model.url];
    
    QQApiNewsObject* imgObj = [QQApiNewsObject objectWithURL:url title:self.model.title description:self.model.content previewImageData:data];

    [imgObj setTitle:self.model.title ? : @""];
    
    if (shareType == SYShare_QQ) {
        [imgObj setCflag:kQQAPICtrlFlagQQShare];
    }else if(shareType == SYShare_QZone){
        [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
    }else{
        
    }
    
    SendMessageToQQReq*req = [SendMessageToQQReq reqWithContent:imgObj];

    [SYShareManager shareTo:SYShare_Platform_QQ shareObject:req delegate:self];
}


/**
 处理来至QQ的请求
 */
- (void)onQQReq:(QQBaseReq *)req;
{
    NSLog(@"onReq");
    
}

/**
 处理来至QQ的响应
 */
- (void)onQQResp:(QQBaseResp *)resp;
{
    NSLog(@"onResp");
    if (resp.result && resp.result.intValue == 0) {
        [self dismissViewControllerAnimated:NO completion:NULL];
    }else{
        NSString *errMsg = [NSString stringWithFormat:@"分享失败，原因：%@", resp.result];
        [UIAlertUtil showAlertWithTitle:@"分享失败" message:errMsg persentViewController:self];
    }
}

-(void)doShareWeibo:(SYShare_Type)shareType
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = self.model.content;

    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = self.model.title;
    webpage.title = self.model.title;
    webpage.description = self.model.content;
    webpage.thumbnailData = UIImageJPEGRepresentation(self.model.image, 0.5);
    webpage.webpageUrl = self.model.url;
    message.mediaObject = webpage;
    [SYShareManager shareTo:SYShare_Platform_Weibo shareObject:message delegate:self];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {

    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
    
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {

    }
    else if([response isKindOfClass:WBSDKAppRecommendResponse.class])
    {
        
    }else if([response isKindOfClass:WBShareMessageToContactResponse.class])
    {
    }
    if (response.statusCode == 0) {
        [self dismissViewControllerAnimated:NO completion:NULL];
    }else{
        NSString *errMsg = [NSString stringWithFormat:@"分享失败，原因：%d", response.statusCode];
        [UIAlertUtil showAlertWithTitle:@"分享失败" message:errMsg persentViewController:self];
    }
}

@end
