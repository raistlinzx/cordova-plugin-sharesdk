#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

//继承CDVPlugin类
@interface ShareSDKPlugin : CDVPlugin

//接口方法， command.arguments[0]获取前端传递的参数
- (void)send:(CDVInvokedUrlCommand*)command;

@end