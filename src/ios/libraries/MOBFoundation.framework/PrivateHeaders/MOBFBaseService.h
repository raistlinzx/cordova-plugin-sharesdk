//
//  MOBFBaseService.h
//  MOBFoundation
//
//  Created by fenghj on 15/10/28.
//  Copyright © 2015年 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  MOB基础服务
 */
@interface MOBFBaseService : NSObject

/**
 *  获取设备唯一标识
 *
 *  @param appKey  应用标识
 *  @param product 产品标识
 *  @param handler 回调处理器
 */
+ (void)getDUIDWithAppKey:(NSString *)appKey
                  product:(NSString *)product
                   result:(void(^)(NSString *duid))handler;

@end
