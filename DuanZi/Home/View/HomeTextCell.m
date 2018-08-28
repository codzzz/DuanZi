//
//  HomeTextCell.m
//  DuanZi
//
//  Created by sui on 2018/6/13.
//  Copyright © 2018年 sui. All rights reserved.
//

#import "HomeTextCell.h"
#import "MNGankDao.h"
@interface HomeTextCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet UIButton *btncollect;
@property (weak, nonatomic) IBOutlet UILabel *labeltime;
@property (weak, nonatomic) IBOutlet UIButton *btncopy;


@end
@implementation HomeTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x =5;
    frame.size.height -= 2;
    frame.size.width -= 2;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setHomemodel:(HomeModel *)homemodel{
    _homemodel = homemodel;
    _title.text = [_homemodel.title stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    _content.text = [_homemodel.text stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    _labeltime.text = [_homemodel.ct componentsSeparatedByString:@" "][0];
    if (_homemodel.collect) {
        [_btncollect setSelected:YES];
    }else{
        [_btncollect setSelected:NO];
    }
}
- (IBAction)changeCollectState:(id)sender{
    if (_homemodel.collect) {
        MNLog(@"取消收藏");
        BOOL result = [MNGankDao deleteOne:_homemodel._id];
        if(result){
            [_btncollect setSelected:NO];
            _homemodel.collect = NO;
            [MyProgressHUD showToast:@"取消收藏成功"];
        }else{
            [MyProgressHUD showToast:@"取消收藏失败"];
        }
    }else{
        MNLog(@"收藏");
        //插入数据库
        BOOL result = [MNGankDao save:_homemodel];
        if(result){
            [_btncollect setSelected:YES];
            _homemodel.collect = YES;
            [MyProgressHUD showToast:@"收藏成功"];
        }else{
            [MyProgressHUD showToast:@"收藏失败"];
        }
    }
}
- (IBAction)copyText:(id)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.persistent = YES;
    NSString *text = _content.text;
    [pasteboard setString:text];
    [MyProgressHUD showToast:@"复制成功"];
}
@end
