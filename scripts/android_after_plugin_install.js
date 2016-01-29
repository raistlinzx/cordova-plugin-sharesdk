
module.exports = function(context) {

	var cordova_util = context.requireCordovaModule("cordova-lib/src/cordova/util"),
    	ConfigParser = context.requireCordovaModule('cordova-common').ConfigParser,
    	fs = context.requireCordovaModule('fs');
    
    var xml = cordova_util.projectConfig(context.opts.projectRoot);
    var cfg = new ConfigParser(xml);

 	var packageName = cfg.packageName();
 	
 	var wxapiPath = context.opts.projectRoot + '/platforms/android/src/' + packageName.replace(/\./g, '/') + '/wxapi';
 	var WXEntryActivityPath = context.opts.projectRoot + '/plugins/com.ryanzx.cordova.plugin.sharesdk/src/android/WXEntryActivity.java';

 	fs.readFile(WXEntryActivityPath, 'utf8', function(err, data) {
 		if(err) throw err;
 		var result = data.replace(/PACKAGENAME/g, packageName);
 		fs.exists(wxapiPath, function(exists) {
 			if(!exists) fs.mkdir(wxapiPath);
 			
 			fs.exists(WXEntryActivityPath, function(fexists)	{
 				if(fexists) console.log(WXEntryActivityPath + ' is exists, Not be replaced.');
 				else {
 					fs.writeFile(WXEntryActivityPath, result, 'utf8', function(err) {
						if(err) throw err;
					});
 				}
 			});
 			
 		});
 		
 	});

}

