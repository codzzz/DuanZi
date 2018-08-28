//
//  HappyNetApi.h
//  DuanZi
//
//  Created by sui on 2018/6/12.
//  Copyright © 2018年 sui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HappyNetApi : NSObject
/**
 *  获取Happy数据接口
 *
 *  @param type      数据类型：341-1 | 341-2 | 341-3 | 231-1
 *  @param pageSize  请求个数
 *  @param pageIndex 第几页
 */
+(void)getHappyDataWithType:(NSString *)type pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex success:(void(^)(NSDictionary *dict))success failure:(void(^)(NSString *text))failure;

@end
