//
//  HappyNetApi.m
//  DuanZi
//
//  Created by sui on 2018/6/12.
//  Copyright © 2018年 sui. All rights reserved.
//

#import "HappyNetApi.h"
#import <AFNetworking.h>
@implementation HappyNetApi

+(void)getHappyDataWithType:(NSString *)type pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure
{
    NSString *url = @"";
    //获取网络数据
    if ([type isEqualToString: @"231-1"]) {
        url = [NSString stringWithFormat:@"http://route.showapi.com/%@?maxResult=%zd&num=%zd&page=%zd&showapi_appid=31728&showapi_sign=988926a227e84c1b9f8303352d3ef339",type,pageSize,pageSize,pageIndex];
    }else{
        url = [NSString stringWithFormat:@"http://route.showapi.com/%@?maxResult=%zd&page=%zd&showapi_appid=31728&showapi_sign=988926a227e84c1b9f8303352d3ef339",type,pageSize,pageIndex];
    }
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    MNLog(@"----url----%@",url);
    
    [[AFHTTPSessionManager manager] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MNLog(@"---success---%@",responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"失败");
    }];
    
    
}
@end
