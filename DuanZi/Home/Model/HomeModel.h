//
//  HomeModel.h
//  DuanZi
//
//  Created by sui on 2018/6/12.
//  Copyright © 2018年 sui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HomeModel : NSObject
/**
 *  id
 */
@property (nonatomic, copy) NSString *_id;
/**
 * text
 */
@property (nonatomic,copy) NSString *text;
/**
 * title
 */
@property (nonatomic,copy) NSString *title;
/**
 *  发布时间
 */
@property (nonatomic, copy) NSString *ct;
/**
 *  类型
 */
@property (nonatomic, copy) NSString *type;
/**
 * 动图和趣图和奇闻异事img url
 */
@property (nonatomic,copy) NSString *img;
/**
 *奇闻异事的跳转url
 */
@property (nonatomic,copy) NSString *picUrl;

/**
 *  额外的属性：这个是否收藏了
 */
@property(nonatomic,assign,getter=isCollect)BOOL collect;

/**
 *  额外的属性：图片的高度
 */
@property (nonatomic, assign) CGFloat imageH;

@end
