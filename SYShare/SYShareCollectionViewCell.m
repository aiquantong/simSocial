//
//  SYShareCollectionViewCell.m
//  tvc
//
//  Created by aiquantong on 5/25/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "SYShareCollectionViewCell.h"

#define IconImageMarginTop 10
#define IconImageMarginWithAndHeight 50

#define TextLabelMarginTop 2
#define TextLabelMarginHeight 24


@interface SYShareCollectionViewCell()
{

}

@property (nonatomic, strong) UILabel *txtLabel;
@property (nonatomic, strong) UIImageView *iconImage;

@end

@implementation SYShareCollectionViewCell


-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.iconImage = [[UIImageView alloc] init];
    self.iconImage.frame = CGRectMake((frame.size.width - IconImageMarginWithAndHeight)/2, IconImageMarginTop, IconImageMarginWithAndHeight, IconImageMarginWithAndHeight);
    self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconImage];
    
    self.txtLabel = [[UILabel alloc] init];
    self.txtLabel.frame = CGRectMake(0, IconImageMarginTop+IconImageMarginWithAndHeight+TextLabelMarginTop, frame.size.width, TextLabelMarginHeight);
    self.txtLabel.font = [UIFont systemFontOfSize:12];
    self.txtLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.txtLabel];
    
  }
  return self;
}


-(void)setModel:(SYShare_Type)syshareType
{
  switch (syshareType) {
    case SYShare_WEChat_Session:
      self.txtLabel.text = @"微信好友";
      self.iconImage.image = [UIImage imageNamed:@"UMS_wechat_session_icon"];
      break;
      
    case SYShare_WEChat_Timeline:
      self.txtLabel.text = @"朋友圈";
      self.iconImage.image = [UIImage imageNamed:@"UMS_wechat_timeline_icon"];
      break;
      
    case SYShare_WEChat_Favorite:
      self.txtLabel.text = @"微信收藏";
      self.iconImage.image = [UIImage imageNamed:@"UMS_wechat_favorite_icon"];
      break;
      
    case SYShare_QQ:
      self.txtLabel.text = @"QQ好友";
      self.iconImage.image = [UIImage imageNamed:@"UMS_qq_icon"];
      break;
      
    case SYShare_QZone:
      self.txtLabel.text = @"QQ空间";
      self.iconImage.image = [UIImage imageNamed:@"UMS_qzone_icon"];
      break;
      
    case SYShare_Weibo:
      self.txtLabel.text = @"微博";
      self.iconImage.image = [UIImage imageNamed:@"UMS_sina_icon"];
      break;
      
    case SYShare_mail:
      self.txtLabel.text = @"邮件";
      self.iconImage.image = [UIImage imageNamed:@"UMS_email_icon"];
      break;
      
    case SYShare_sms:
      self.txtLabel.text = @"短信";
      self.iconImage.image = [UIImage imageNamed:@"UMS_sms_icon"];
      break;
      
    default:
      break;
  }
}

@end



