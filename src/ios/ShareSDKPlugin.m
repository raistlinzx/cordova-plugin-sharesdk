#import "ShareSDKPlugin.h"
#import <Cordova/CDVPlugin.h>

#import <ShareSDK/ShareSDK.h>
#import <MOBFoundation/MOBFoundation.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
 
//微信SDK头文件
#import "WXApi.h"

//新浪微博
#import "WeiboSDK.h"


@implementation ShareSDKPlugin
#pragma mark "API"
- (void)pluginInitialize {
    
    NSString* sharesdkAppKey = [[self.commandDelegate settings] objectForKey:@"sharesdkappkey"];
    NSString* wechatAppId = [[self.commandDelegate settings] objectForKey:@"wechatappid"];
    NSString* wechatAppSecret = [[self.commandDelegate settings] objectForKey:@"wechatappsecret"];
    NSString* qqAppId = [[self.commandDelegate settings] objectForKey:@"qqappid"];
    NSString* qqAppKey = [[self.commandDelegate settings] objectForKey:@"qqappkey"];
    NSString* wbAppKey = [[self.commandDelegate settings] objectForKey:@"wbappkey"];
    NSString* wbAppSecret = [[self.commandDelegate settings] objectForKey:@"wbappsecret"];
    NSString* wbRedirectUrl = [[self.commandDelegate settings] objectForKey:@"wbredirecturl"];

    if(wechatAppId && wechatAppSecret && qqAppId && qqAppKey && wbAppKey && wbAppSecret && wbRedirectUrl && sharesdkAppKey){
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
        [ShareSDK connectSinaWeiboWithAppKey:wbAppKey
                                   appSecret:wbAppSecret
                                 redirectUri:wbRedirectUrl
                                 weiboSDKCls:[WeiboSDK class]];

    }
}

- (void)share:(CDVInvokedUrlCommand*)command {
    
    NSString* title = [command.arguments objectAtIndex:0];
    NSString* text = [command.arguments objectAtIndex:1];
    NSString* imageUrl = [command.arguments objectAtIndex:2];
    NSString* url = [command.arguments objectAtIndex:3];

    // CDVPluginResult* __block pluginResult = nil;
     //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content: text
                                       defaultContent: text
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title: title
                                                  url: url
                                          description: text
                                            mediaType:SSPublishContentMediaTypeNews];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                CDVPluginResult* pluginResult = nil;
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"success"];
                                    
                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]]];
                                    
                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                }
                                else if (state == SSResponseStateCancel)
                                {
                                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"cancel"];
                                    
                                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                                }
                            }];


}


- (void)handleOpenURL:(NSNotification*)notification
{
    // override to handle urls sent to your app
    // register your url schemes in your App-Info.plist
    NSURL* url = [notification object];
    if ([url isKindOfClass:[NSURL class]]) {
        /* Do your thing! */
        NSLog([NSString stringWithFormat:@"%@", url]);
        [ShareSDK handleOpenURL:url wxDelegate:self];
    }
}

@end

