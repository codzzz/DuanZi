//
//  HomeModel2.h
//  DuanZi
//
//  Created by sui on 2018/6/12.
//  Copyright © 2018年 sui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel2 : NSObject
/**
 *  id
 */
@property (nonatomic, copy) NSString *_id;
/**
 * title
 */
@property (nonatomic,copy) NSString *title;
/**
 *  发布时间
 */
@property (nonatomic, copy) NSString *ctime;
/**
 * 动图和趣图和奇闻异事img url
 */
@property (nonatomic,copy) NSString *picUrl;
/**
 *奇闻异事的跳转url
 */
@property (nonatomic,copy) NSString *url;

/**
 *  额外的属性：这个是否收藏了
 */
@property(nonatomic,assign,getter=isCollect)BOOL collect;

/**
 *  额外的属性：图片的高度
 */
@property (nonatomic, assign) CGFloat imageH;
@end
