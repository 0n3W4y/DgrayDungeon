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

		data = '{"name":null,"assets":"aoy4:pathy29:assets%2Fimages%2Facademy.pngy4:sizei409445y4:typey5:IMAGEy2:idR1y7:preloadtgoR0y31:assets%2Fimages%2Facademy_m.pngR2i413561R3R4R5R7R6tgoR0y37:assets%2Fimages%2Fbackground_game.pngR2i1897994R3R4R5R8R6tgoR0y32:assets%2Fimages%2Fblacksmith.pngR2i234186R3R4R5R9R6tgoR0y34:assets%2Fimages%2Fblacksmith_m.pngR2i238097R3R4R5R10R6tgoR0y30:assets%2Fimages%2Fbutton_b.pngR2i1941R3R4R5R11R6tgoR0y36:assets%2Fimages%2Fbutton_b_hover.pngR2i1948R3R4R5R12R6tgoR0y35:assets%2Fimages%2Fbutton_b_push.pngR2i2723R3R4R5R13R6tgoR0y30:assets%2Fimages%2Fbutton_c.pngR2i4148R3R4R5R14R6tgoR0y36:assets%2Fimages%2Fbutton_c_hover.pngR2i4148R3R4R5R15R6tgoR0y35:assets%2Fimages%2Fbutton_c_push.pngR2i4148R3R4R5R16R6tgoR0y30:assets%2Fimages%2Fbutton_d.pngR2i4829R3R4R5R17R6tgoR0y36:assets%2Fimages%2Fbutton_d_hover.pngR2i4829R3R4R5R18R6tgoR0y35:assets%2Fimages%2Fbutton_d_push.pngR2i4829R3R4R5R19R6tgoR0y40:assets%2Fimages%2FcitySceneBackround.pngR2i2043474R3R4R5R20R6tgoR0y29:assets%2Fimages%2Ffontain.pngR2i185396R3R4R5R21R6tgoR0y31:assets%2Fimages%2Ffontain_m.pngR2i194684R3R4R5R22R6tgoR0y31:assets%2Fimages%2Fgraveyard.pngR2i172698R3R4R5R23R6tgoR0y33:assets%2Fimages%2Fgraveyard_m.pngR2i176786R3R4R5R24R6tgoR0y28:assets%2Fimages%2Fhermit.pngR2i198769R3R4R5R25R6tgoR0y30:assets%2Fimages%2Fhermit_m.pngR2i207348R3R4R5R26R6tgoR0y30:assets%2Fimages%2Fhospital.pngR2i306480R3R4R5R27R6tgoR0y32:assets%2Fimages%2Fhospital_m.pngR2i321808R3R4R5R28R6tgoR0y31:assets%2Fimages%2FinnWindow.pngR2i11509R3R4R5R29R6tgoR0y41:assets%2Fimages%2FinnWindowHeroWindow.pngR2i6013R3R4R5R30R6tgoR0y30:assets%2Fimages%2Fmerchant.pngR2i396984R3R4R5R31R6tgoR0y32:assets%2Fimages%2Fmerchant_m.pngR2i399153R3R4R5R32R6tgoR0y30:assets%2Fimages%2Fquestman.pngR2i49162R3R4R5R33R6tgoR0y32:assets%2Fimages%2Fquestman_m.pngR2i43455R3R4R5R34R6tgoR0y30:assets%2Fimages%2Frecruits.pngR2i339084R3R4R5R35R6tgoR0y32:assets%2Fimages%2Frecruits_m.pngR2i339084R3R4R5R36R6tgoR0y45:assets%2Fimages%2FstartSceneButtonsWindow.pngR2i7836R3R4R5R37R6tgoR0y29:assets%2Fimages%2Fstorage.pngR2i358167R3R4R5R38R6tgoR0y31:assets%2Fimages%2Fstorage_m.pngR2i371206R3R4R5R39R6tgoR0y28:assets%2Fimages%2Ftavern.pngR2i505790R3R4R5R40R6tgoR0y30:assets%2Fimages%2Ftavern_m.pngR2i505790R3R4R5R41R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
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

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_academy_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_academy_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_background_game_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_blacksmith_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_blacksmith_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_b_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_b_hover_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_b_push_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_c_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_c_hover_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_c_push_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_d_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_d_hover_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_d_push_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_cityscenebackround_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_fontain_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_fontain_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_graveyard_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_graveyard_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_hermit_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_hermit_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_hospital_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_hospital_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_innwindow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_innwindowherowindow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_merchant_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_merchant_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_questman_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_questman_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_recruits_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_recruits_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_startscenebuttonswindow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_storage_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_storage_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_tavern_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_tavern_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:image("Assets/images/academy.png") @:noCompletion #if display private #end class __ASSET__assets_images_academy_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/academy_m.png") @:noCompletion #if display private #end class __ASSET__assets_images_academy_m_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/background_game.png") @:noCompletion #if display private #end class __ASSET__assets_images_background_game_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/blacksmith.png") @:noCompletion #if display private #end class __ASSET__assets_images_blacksmith_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/blacksmith_m.png") @:noCompletion #if display private #end class __ASSET__assets_images_blacksmith_m_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_b.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_b_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_b_hover.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_b_hover_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_b_push.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_b_push_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_c.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_c_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_c_hover.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_c_hover_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_c_push.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_c_push_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_d.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_d_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_d_hover.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_d_hover_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_d_push.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_d_push_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/citySceneBackround.png") @:noCompletion #if display private #end class __ASSET__assets_images_cityscenebackround_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/fontain.png") @:noCompletion #if display private #end class __ASSET__assets_images_fontain_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/fontain_m.png") @:noCompletion #if display private #end class __ASSET__assets_images_fontain_m_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/graveyard.png") @:noCompletion #if display private #end class __ASSET__assets_images_graveyard_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/graveyard_m.png") @:noCompletion #if display private #end class __ASSET__assets_images_graveyard_m_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/hermit.png") @:noCompletion #if display private #end class __ASSET__assets_images_hermit_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/hermit_m.png") @:noCompletion #if display private #end class __ASSET__assets_images_hermit_m_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/hospital.png") @:noCompletion #if display private #end class __ASSET__assets_images_hospital_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/hospital_m.png") @:noCompletion #if display private #end class __ASSET__assets_images_hospital_m_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/innWindow.png") @:noCompletion #if display private #end class __ASSET__assets_images_innwindow_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/innWindowHeroWindow.png") @:noCompletion #if display private #end class __ASSET__assets_images_innwindowherowindow_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/merchant.png") @:noCompletion #if display private #end class __ASSET__assets_images_merchant_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/merchant_m.png") @:noCompletion #if display private #end class __ASSET__assets_images_merchant_m_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/questman.png") @:noCompletion #if display private #end class __ASSET__assets_images_questman_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/questman_m.png") @:noCompletion #if display private #end class __ASSET__assets_images_questman_m_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/recruits.png") @:noCompletion #if display private #end class __ASSET__assets_images_recruits_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/recruits_m.png") @:noCompletion #if display private #end class __ASSET__assets_images_recruits_m_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/startSceneButtonsWindow.png") @:noCompletion #if display private #end class __ASSET__assets_images_startscenebuttonswindow_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/storage.png") @:noCompletion #if display private #end class __ASSET__assets_images_storage_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/storage_m.png") @:noCompletion #if display private #end class __ASSET__assets_images_storage_m_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/tavern.png") @:noCompletion #if display private #end class __ASSET__assets_images_tavern_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/tavern_m.png") @:noCompletion #if display private #end class __ASSET__assets_images_tavern_m_png extends lime.graphics.Image {}
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
