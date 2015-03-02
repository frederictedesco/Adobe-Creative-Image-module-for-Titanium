// This is a test harness for your module
// You should do something interesting in this harness
// to test out the module and to provide instructions
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
var label = Ti.UI.createLabel();
win.add(label);
win.open();

// TODO: write your module tests here
var photo_editor_adobe = require('com.dcode.photoeditor.adobe');
Ti.API.info("module is => " + photo_editor_adobe);

label.text = photo_editor_adobe.example();

if (Ti.Platform.name == "iphone") { {
	var actionSheet = photo_editor_adobe.createActionSheetView();
	actionSheet.showActionSheet();

	photo_editor_adobe.addEventListener('avEditorFinished',function(e){
  		alert("name is "+e.image);
	});

	photo_editor_adobe.addEventListener('avEditorCancel',function(e){
  		alert("Cancelled editing...");
	});
}

if (Ti.Platform.name == "android") {
	var proxy = photo_editor_adobe.createExample({
		message: "Creating an example Proxy",
		backgroundColor: "red",
		width: 100,
		height: 100,
		top: 100,
		left: 150
	});

	proxy.printMessage("Hello world!");
	proxy.message = "Hi world!.  It's me again.";
	proxy.printMessage("Hello world!");
	win.add(proxy);
}

