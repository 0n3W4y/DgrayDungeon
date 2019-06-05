package;


import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

		}

		if (rootPath == null) {

			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif console
			rootPath = lime.system.System.applicationDirectory;
			#elseif (winrt)
			rootPath = "./";
			#elseif (sys && windows && !cs)
			rootPath = FileSystem.absolutePath (haxe.io.Path.directory (#if (haxe_ver >= 3.3) Sys.programPath () #else Sys.executablePath () #end)) + "/";
			#else
			rootPath = "";
			#end

		}

		Assets.defaultRootPath = rootPath;

		#if (openfl && !flash && !display)
		
		#end

		var data, manifest, library;

		#if kha

		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);

		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");

		#else

		data = '{"name":null,"assets":"aoy4:pathy30:assets%2FauthorsGameButton.pngy4:sizei22092y4:typey5:IMAGEy2:idR1y7:preloadtgoR0y32:assets%2FauthorsGameButton_p.pngR2i22582R3R4R5R7R6tgoR0y28:assets%2Fbackground_game.pngR2i1897994R3R4R5R8R6tgoR0y21:assets%2Fbutton_a.pngR2i1941R3R4R5R9R6tgoR0y28:assets%2Fbutton_a_pushed.pngR2i2723R3R4R5R10R6tgoR0y31:assets%2FcontinueGameButton.pngR2i20523R3R4R5R11R6tgoR0y33:assets%2FcontinueGameButton_p.pngR2i21263R3R4R5R12R6tgoR0y30:assets%2FoptionsGameButton.pngR2i21835R3R4R5R13R6tgoR0y32:assets%2FoptionsGameButton_p.pngR2i22337R3R4R5R14R6tgoR0y28:assets%2FstartGameButton.pngR2i24067R3R4R5R15R6tgoR0y30:assets%2FstartGameButton_p.pngR2i24386R3R4R5R16R6tgoR0y36:assets%2FstartSceneButtonsWindow.pngR2i7836R3R4R5R17R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

		#end

	}


}


#if kha

null

#else

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_authorsgamebutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_authorsgamebutton_p_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_background_game_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_button_a_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_button_a_pushed_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_continuegamebutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_continuegamebutton_p_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_optionsgamebutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_optionsgamebutton_p_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_startgamebutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_startgamebutton_p_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_startscenebuttonswindow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:image("Assets/authorsGameButton.png") @:noCompletion #if display private #end class __ASSET__assets_authorsgamebutton_png extends lime.graphics.Image {}
@:keep @:image("Assets/authorsGameButton_p.png") @:noCompletion #if display private #end class __ASSET__assets_authorsgamebutton_p_png extends lime.graphics.Image {}
@:keep @:image("Assets/background_game.png") @:noCompletion #if display private #end class __ASSET__assets_background_game_png extends lime.graphics.Image {}
@:keep @:image("Assets/button_a.png") @:noCompletion #if display private #end class __ASSET__assets_button_a_png extends lime.graphics.Image {}
@:keep @:image("Assets/button_a_pushed.png") @:noCompletion #if display private #end class __ASSET__assets_button_a_pushed_png extends lime.graphics.Image {}
@:keep @:image("Assets/continueGameButton.png") @:noCompletion #if display private #end class __ASSET__assets_continuegamebutton_png extends lime.graphics.Image {}
@:keep @:image("Assets/continueGameButton_p.png") @:noCompletion #if display private #end class __ASSET__assets_continuegamebutton_p_png extends lime.graphics.Image {}
@:keep @:image("Assets/optionsGameButton.png") @:noCompletion #if display private #end class __ASSET__assets_optionsgamebutton_png extends lime.graphics.Image {}
@:keep @:image("Assets/optionsGameButton_p.png") @:noCompletion #if display private #end class __ASSET__assets_optionsgamebutton_p_png extends lime.graphics.Image {}
@:keep @:image("Assets/startGameButton.png") @:noCompletion #if display private #end class __ASSET__assets_startgamebutton_png extends lime.graphics.Image {}
@:keep @:image("Assets/startGameButton_p.png") @:noCompletion #if display private #end class __ASSET__assets_startgamebutton_p_png extends lime.graphics.Image {}
@:keep @:image("Assets/startSceneButtonsWindow.png") @:noCompletion #if display private #end class __ASSET__assets_startscenebuttonswindow_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else



#end

#if (openfl && !flash)

#if html5

#else

#end

#end
#end

#end
