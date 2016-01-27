#import "ShareSDKPlugin.h"
#import <Cordova/CDVPlugin.h>

#import <ShareSDK/ShareSDK.h>
#import <MOBFoundation/MOBFoundation.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
 
//微信SDK头文件
#import "WXApi.h"


@implementation ShareSDKPlugin
#pragma mark "API"
- (void)pluginInitialize {
    
    NSString* sharesdkAppKey = [[self.commandDelegate settings] objectForKey:@"sharesdkappkey"];
    NSString* wechatAppId = [[self.commandDelegate settings] objectForKey:@"wechatappid"];
    NSString* wechatAppSecret = [[self.commandDelegate settings] objectForKey:@"wechatappsecret"];
    NSString* qqAppId = [[self.commandDelegate settings] objectForKey:@"qqappid"];
    NSString* qqAppKey = [[self.commandDelegate settings] objectForKey:@"qqappkey"];
    if(wechatAppId && wechatAppSecret && qqAppId && qqAppKey && sharesdkAppKey){
 		/*Share SDK config*/
        [ShareSDK registerApp:sharesdkAppKey];
        
        [ShareSDK connectWeChatWithAppId:wechatAppId
                               appSecret:wechatAppSecret
                               wechatCls:[WXApi class]];

        
        //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
	    [ShareSDK connectQZoneWithAppKey:qqAppId
	                           appSecret:qqAppKey
	                   qqApiInterfaceCls:[QQApiInterface class]
	                     tencentOAuthCls:[TencentOAuth class]];
	 
	    //添加QQ应用  注册网址   http://mobile.qq.com/api/
	    [ShareSDK connectQQWithQZoneAppKey:qqAppId
	                     qqApiInterfaceCls:[QQApiInterface class]
	                       tencentOAuthCls:[TencentOAuth class]];

	     //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
   		// [ShareSDK connectSinaWeiboWithAppKey:@"568898243"     
     //    	                       appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3" 
     //           	            	 redirectUri:@"http://www.sharesdk.cn" 
     //                	         weiboSDKCls:[WeiboSDK class]];

 	}
}

- (void)send:(CDVInvokedUrlCommand*)command {
    
    // CDVPluginResult* __block pluginResult = nil;
     //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithUrl:@"http://cdn.qiyestore.com/openapi/upload/2015/12/25/EYZZ17L785.png"]
                                                title:@"测试分享哈哈哈"
                                                  url:@"http://www.qiyestore.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器

    //弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
 
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];



    // //创建弹出菜单容器
    // NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeQQ,ShareTypeQQSpace,ShareTypeWeixiFav,ShareTypeWeixiSession,ShareTypeWeixiTimeline, nil];
    // //弹出分享菜单
    // [ShareSDK oneKeyShareContent:publishContent
    //                      shareList:shareList
    //                    authOptions:nil
    //                  statusBarTips:YES
    //                         result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
 
    //                             if (state == SSResponseStateSuccess)
    //                             {
    //                                 NSLog(@"分享成功");
    //                             }
    //                             else if (state == SSResponseStateFail)
    //                             {
    //                                 NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
    //                             }
    //                         }];
}
@end

