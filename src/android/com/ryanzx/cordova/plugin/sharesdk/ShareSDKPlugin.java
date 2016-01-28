package com.ryanzx.cordova.plugin.sharesdk;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.content.Context;

import cn.sharesdk.onekeyshare.OnekeyShare;
import cn.sharesdk.framework.ShareSDK;
import java.util.HashMap;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import android.content.pm.PackageManager;
import android.content.pm.PackageInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager.NameNotFoundException;



public class ShareSDKPlugin extends CordovaPlugin implements PlatformActionListener {

    private static CallbackContext callbackContext=null;

    private Context context;
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("share")) {
            String title = args.getString(0);
            String text = args.getString(1);
            String imageUrl = args.getString(2);
            String url = args.getString(3);
            this.callbackContext = callbackContext;
            this.context = this.cordova.getActivity().getApplicationContext();
            this.share(title, text, imageUrl, url, callbackContext);
            return true;
        }
        return false;
    }


    private void share(String title, String text, String imageUrl, String url, CallbackContext callbackContext) {
        if (title != null && title.length() > 0
            && text != null && text.length() > 0
            && imageUrl != null && imageUrl.length() > 0
            && url != null && url.length() > 0
            ) {

            ShareSDK.initSDK(context);
            OnekeyShare oks = new OnekeyShare();
            //关闭sso授权
            oks.disableSSOWhenAuthorize(); 
             
            // 分享时Notification的图标和文字  2.5.9以后的版本不调用此方法
            //oks.setNotification(R.drawable.ic_launcher, getString(R.string.app_name));
            // title标题，印象笔记、邮箱、信息、微信、人人网和QQ空间使用
            oks.setTitle(title);
            // titleUrl是标题的网络链接，仅在人人网和QQ空间使用
            oks.setTitleUrl(url);
            // text是分享文本，所有平台都需要这个字段
            oks.setText(text);
             // imagePath是图片的本地路径，Linked-In以外的平台都支持此参数
             // oks.setImagePath("/sdcard/test.jpg");//确保SDcard下面存在此张图片
            oks.setImageUrl(imageUrl);
            // url仅在微信（包括好友和朋友圈）中使用
            oks.setUrl(url);
            // comment是我对这条分享的评论，仅在人人网和QQ空间使用
            // oks.setComment("我是测试评论文本");
            // site是分享此内容的网站名称，仅在QQ空间使用
            String siteName = "";
            try {
                PackageManager packageManager = this.cordova.getActivity().getPackageManager();
                ApplicationInfo ai = packageManager.getApplicationInfo(this.cordova.getActivity().getPackageName(), 0);
                CharSequence al = packageManager.getApplicationLabel(ai);
                siteName = (String) al;
            } catch(NameNotFoundException nnfe) {
                callbackContext.error("no sitename");
            }
            oks.setSite(siteName);
            // siteUrl是分享此内容的网站地址，仅在QQ空间使用
            oks.setSiteUrl(url);
            oks.setCallback(this);
            // 启动分享GUI
            oks.show(context);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }


    public void onComplete(Platform platform, int action,
            HashMap<String, Object> res) {
        callbackContext.success("success");
    }

    public void onError(Platform platform, int action, Throwable t) {
        t.printStackTrace();
        callbackContext.error(t.getMessage());
        // 分享失败的统计
        ShareSDK.logDemoEvent(4, platform);
    }

    public void onCancel(Platform platform, int action) {
        
        callbackContext.error("cancel");
        // 分享失败的统计
        ShareSDK.logDemoEvent(5, platform);
    }
}