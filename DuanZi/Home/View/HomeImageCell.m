//
//  HomeImageCell.m
//  DuanZi
//
//  Created by sui on 2018/6/13.
//  Copyright © 2018年 sui. All rights reserved.
//

#import "HomeImageCell.h"
@interface HomeImageCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;

@property (weak, nonatomic) IBOutlet UIButton *btncollect;
@property (weak, nonatomic) IBOutlet UILabel *labeltime;
@property (weak, nonatomic) IBOutlet UILabel *btnsave;


@end
@implementation HomeImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setHomemodel:(HomeModel *)homemodel{
    _homemodel = homemodel;
    _title.text = _homemodel.title;
    [_imgview sd_setImageWithURL:[NSURL URLWithString:_homemodel.img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _imgview.image = image;
    }];
    _labeltime.text = [_homemodel.ct componentsSeparatedByString:@" "][0];
}
- (IBAction)saveToPhoto:(id)sender{
    UIImageWriteToSavedPhotosAlbum(_imgview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [MyProgressHUD showToast:@"保存成功"];
    }else{
        [MyProgressHUD showToast:@"保存失败"];
    }
}

@end
