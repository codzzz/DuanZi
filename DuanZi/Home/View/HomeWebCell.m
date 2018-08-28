//
//  HomeWebCell.m
//  DuanZi
//
//  Created by sui on 2018/6/13.
//  Copyright © 2018年 sui. All rights reserved.
//

#import "HomeWebCell.h"
@interface HomeWebCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;

@end
@implementation HomeWebCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(HomeModel2 *)homemodel{
    _homemodel = homemodel;
    _title.text = _homemodel.title;
    [_imgview sd_setImageWithURL:[NSURL URLWithString:_homemodel.picUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _imgview.image = image;
    }];
}
@end
