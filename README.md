
# 安装
```sh
ionic plugin add http://git.qiyestore.com/zhuanmi/cordova-plugin-sharesdk.git \
	--variable SHARESDKAPPKEY=f2629488c78c \
	--variable QQAPPID=1105143220 \
	--variable QQAPPKEY=vBktd0sFOFLLkpLP \
	--variable WECHATAPPID=wx739a973d597b2a12 \
	--variable WECHATAPPSECRET=4eec3804ec8f4fbbed2959e8c210fc42 \
	--variable QQURLSCHEME=QQ41DF25B4 \
	--variable WBAPPKEY=4289465453 \
	--variable WBAPPSECRET=de2069dd056a313b76306ee376eecc0f \
	--variable WBREDIRECTURL=http://www.zhuanmi.cc
```

|参数|说明|
|---|---|
|SHARESDKAPPKEY|ShareSDK注册|
|QQAPPID|QQ开放平台注册|
|QQAPPKEY|QQ开放平台注册|
|QQURLSCHEME|QQ回调Scheme。例如:`QQ41DF25B4`|
|WECHATAPPID|微信开放平台注册|
|WECHATAPPSECRET|微信开放平台注册|
|WBAPPKEY|新浪微博|
|WBAPPSECRET|新浪微博|
|WBREDIRECTURL|新浪微博回调地址。必须与注册时一致|

## 卸载重新安装

```sh
ionic plugin remove com.ryanzx.cordova.plugin.sharesdk
```


# JS调用

```js
function test() {
	cordova.exec(function(result) {
		alert('分享成功');
    }, function(error) {
		alert('分享失败');
		console.debug(error)
    }, "ShareSDK", "send", ['测试分享标题','你们好啊这里是测试分享','http://cdn.qiyestore.com/openapi/upload/2015/12/25/EYZZ17L785.png','http://www.qiyestore.com']);
}
```

|参数|说明|
|---|---|
|参数1|标题|
|参数2|文字内容|
|参数3|图片URL|
|参数4|分享查看URL|
