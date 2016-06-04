//
//  SYShareCollectionViewCell.h
//  tvc
//
//  Created by aiquantong on 5/25/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYShareViewController.h"

@interface SYShareCollectionViewCell : UICollectionViewCell

-(id)initWithFrame:(CGRect)frame;

-(void)setModel:(SYShare_Type)syshareType;

@end
