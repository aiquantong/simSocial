//
//  SYShareModel.h
//  shuiYun
//
//  Created by aiquantong on 3/15/16.
//  Copyright © 2016 quantong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    SYShare_Content_Url
}SYShare_content;


@interface SYShareModel : NSObject

@property (nonatomic, assign) SYShare_content shareContent;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIImage *image;

@end



