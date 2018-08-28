//
//  MNGankBaseCell.h
//  GankMM
//
//  Created by 马宁 on 16/5/10.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GankModel;
@class HomeModel;
@class HomeModel2;
@interface MNGankBaseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnCollect;

@property(nonatomic,strong) GankModel *gankModel;
@property(nonatomic,strong) HomeModel *homeModel;
@property(nonatomic,strong) HomeModel2 *homeModel2;
@end
