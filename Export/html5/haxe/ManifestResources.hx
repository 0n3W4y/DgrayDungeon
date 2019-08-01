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

		data = '{"name":null,"assets":"aoy4:pathy29:assets%2Fimages%2Facademy.pngy4:sizei250184y4:typey5:IMAGEy2:idR1y7:preloadtgoR0y31:assets%2Fimages%2Facademy_m.pngR2i254647R3R4R5R7R6tgoR0y37:assets%2Fimages%2Fbackground_game.pngR2i1897994R3R4R5R8R6tgoR0y38:assets%2Fimages%2FbackToCityButton.pngR2i2360R3R4R5R9R6tgoR0y44:assets%2Fimages%2FbackToCityButton_hover.pngR2i501R3R4R5R10R6tgoR0y43:assets%2Fimages%2FbackToCityButton_push.pngR2i2634R3R4R5R11R6tgoR0y32:assets%2Fimages%2Fblacksmith.pngR2i137197R3R4R5R12R6tgoR0y34:assets%2Fimages%2Fblacksmith_m.pngR2i137556R3R4R5R13R6tgoR0y30:assets%2Fimages%2Fbutton_a.pngR2i2360R3R4R5R14R6tgoR0y36:assets%2Fimages%2Fbutton_a_hover.pngR2i501R3R4R5R15R6tgoR0y35:assets%2Fimages%2Fbutton_a_push.pngR2i2634R3R4R5R16R6tgoR0y30:assets%2Fimages%2Fbutton_b.pngR2i1941R3R4R5R17R6tgoR0y36:assets%2Fimages%2Fbutton_b_hover.pngR2i1948R3R4R5R18R6tgoR0y35:assets%2Fimages%2Fbutton_b_push.pngR2i2723R3R4R5R19R6tgoR0y30:assets%2Fimages%2Fbutton_c.pngR2i6120R3R4R5R20R6tgoR0y36:assets%2Fimages%2Fbutton_c_hover.pngR2i5436R3R4R5R21R6tgoR0y35:assets%2Fimages%2Fbutton_c_push.pngR2i6444R3R4R5R22R6tgoR0y30:assets%2Fimages%2Fbutton_d.pngR2i6033R3R4R5R23R6tgoR0y38:assets%2Fimages%2Fbutton_dungeon_a.pngR2i6209R3R4R5R24R6tgoR0y45:assets%2Fimages%2Fbutton_dungeon_a_choose.pngR2i8373R3R4R5R25R6tgoR0y38:assets%2Fimages%2Fbutton_dungeon_b.pngR2i6209R3R4R5R26R6tgoR0y45:assets%2Fimages%2Fbutton_dungeon_b_choose.pngR2i8373R3R4R5R27R6tgoR0y38:assets%2Fimages%2Fbutton_dungeon_c.pngR2i6209R3R4R5R28R6tgoR0y45:assets%2Fimages%2Fbutton_dungeon_c_choose.pngR2i8373R3R4R5R29R6tgoR0y36:assets%2Fimages%2Fbutton_d_hover.pngR2i5542R3R4R5R30R6tgoR0y35:assets%2Fimages%2Fbutton_d_push.pngR2i6462R3R4R5R31R6tgoR0y43:assets%2Fimages%2FchooseDungeonSceneOne.pngR2i818784R3R4R5R32R6tgoR0y40:assets%2Fimages%2FcitySceneBackround.pngR2i2131903R3R4R5R33R6tgoR0y41:assets%2Fimages%2FcitySceneMainWindow.pngR2i25010R3R4R5R34R6tgoR0y51:assets%2Fimages%2FcitySceneMainWindowExitButton.pngR2i1353R3R4R5R35R6tgoR0y56:assets%2Fimages%2FcitySceneMainWindowExitButton_push.pngR2i1674R3R4R5R36R6tgoR0y49:assets%2Fimages%2FdungeonSceneHeroesToDungeon.pngR2i14631R3R4R5R37R6tgoR0y35:assets%2Fimages%2FdungeonWindow.pngR2i1960R3R4R5R38R6tgoR0y29:assets%2Fimages%2Ffontain.pngR2i86429R3R4R5R39R6tgoR0y31:assets%2Fimages%2Ffontain_m.pngR2i91633R3R4R5R40R6tgoR0y31:assets%2Fimages%2Fgraveyard.pngR2i43609R3R4R5R41R6tgoR0y33:assets%2Fimages%2Fgraveyard_m.pngR2i46711R3R4R5R42R6tgoR0y28:assets%2Fimages%2Fhermit.pngR2i127275R3R4R5R43R6tgoR0y30:assets%2Fimages%2Fhermit_m.pngR2i131909R3R4R5R44R6tgoR0y30:assets%2Fimages%2Fhospital.pngR2i173889R3R4R5R45R6tgoR0y32:assets%2Fimages%2Fhospital_m.pngR2i187422R3R4R5R46R6tgoR0y31:assets%2Fimages%2FinnWindow.pngR2i21440R3R4R5R47R6tgoR0y41:assets%2Fimages%2FinnWindowHeroWindow.pngR2i38355R3R4R5R48R6tgoR0y30:assets%2Fimages%2Fmerchant.pngR2i173333R3R4R5R49R6tgoR0y32:assets%2Fimages%2Fmerchant_m.pngR2i175571R3R4R5R50R6tgoR0y37:assets%2Fimages%2FpanelCityWindow.pngR2i17902R3R4R5R51R6tgoR0y30:assets%2Fimages%2Fquestman.pngR2i17934R3R4R5R52R6tgoR0y32:assets%2Fimages%2Fquestman_m.pngR2i18588R3R4R5R53R6tgoR0y39:assets%2Fimages%2Frecruitherowindow.pngR2i16110R3R4R5R54R6tgoR0y44:assets%2Fimages%2FrecruitherowindowLevel.pngR2i3707R3R4R5R55R6tgoR0y46:assets%2Fimages%2FrecruitherowindowPicture.pngR2i773R3R4R5R56R6tgoR0y30:assets%2Fimages%2Frecruits.pngR2i223501R3R4R5R57R6tgoR0y32:assets%2Fimages%2Frecruits_m.pngR2i234504R3R4R5R58R6tgoR0y35:assets%2Fimages%2FrecruitWindow.pngR2i118515R3R4R5R59R6tgoR0y45:assets%2Fimages%2FstartSceneButtonsWindow.pngR2i7836R3R4R5R60R6tgoR0y29:assets%2Fimages%2Fstorage.pngR2i207220R3R4R5R61R6tgoR0y31:assets%2Fimages%2Fstorage_m.pngR2i216808R3R4R5R62R6tgoR0y28:assets%2Fimages%2Ftavern.pngR2i271014R3R4R5R63R6tgoR0y30:assets%2Fimages%2Ftavern_m.pngR2i269613R3R4R5R64R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
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
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_backtocitybutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_backtocitybutton_hover_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_backtocitybutton_push_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_blacksmith_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_blacksmith_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_a_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_a_hover_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_a_push_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_b_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_b_hover_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_b_push_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_c_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_c_hover_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_c_push_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_d_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_dungeon_a_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_dungeon_a_choose_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_dungeon_b_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_dungeon_b_choose_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_dungeon_c_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_dungeon_c_choose_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_d_hover_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_button_d_push_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_choosedungeonsceneone_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_cityscenebackround_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_cityscenemainwindow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_cityscenemainwindowexitbutton_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_cityscenemainwindowexitbutton_push_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_dungeonsceneheroestodungeon_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_dungeonwindow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
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
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_panelcitywindow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_questman_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_questman_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_recruitherowindow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_recruitherowindowlevel_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_recruitherowindowpicture_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_recruits_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_recruits_m_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_recruitwindow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
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
@:keep @:image("Assets/images/backToCityButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_backtocitybutton_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/backToCityButton_hover.png") @:noCompletion #if display private #end class __ASSET__assets_images_backtocitybutton_hover_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/backToCityButton_push.png") @:noCompletion #if display private #end class __ASSET__assets_images_backtocitybutton_push_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/blacksmith.png") @:noCompletion #if display private #end class __ASSET__assets_images_blacksmith_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/blacksmith_m.png") @:noCompletion #if display private #end class __ASSET__assets_images_blacksmith_m_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_a.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_a_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_a_hover.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_a_hover_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_a_push.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_a_push_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_b.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_b_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_b_hover.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_b_hover_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_b_push.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_b_push_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_c.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_c_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_c_hover.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_c_hover_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_c_push.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_c_push_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_d.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_d_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_dungeon_a.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_dungeon_a_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_dungeon_a_choose.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_dungeon_a_choose_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_dungeon_b.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_dungeon_b_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_dungeon_b_choose.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_dungeon_b_choose_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_dungeon_c.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_dungeon_c_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_dungeon_c_choose.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_dungeon_c_choose_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_d_hover.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_d_hover_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/button_d_push.png") @:noCompletion #if display private #end class __ASSET__assets_images_button_d_push_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/chooseDungeonSceneOne.png") @:noCompletion #if display private #end class __ASSET__assets_images_choosedungeonsceneone_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/citySceneBackround.png") @:noCompletion #if display private #end class __ASSET__assets_images_cityscenebackround_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/citySceneMainWindow.png") @:noCompletion #if display private #end class __ASSET__assets_images_cityscenemainwindow_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/citySceneMainWindowExitButton.png") @:noCompletion #if display private #end class __ASSET__assets_images_cityscenemainwindowexitbutton_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/citySceneMainWindowExitButton_push.png") @:noCompletion #if display private #end class __ASSET__assets_images_cityscenemainwindowexitbutton_push_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/dungeonSceneHeroesToDungeon.png") @:noCompletion #if display private #end class __ASSET__assets_images_dungeonsceneheroestodungeon_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/dungeonWindow.png") @:noCompletion #if display private #end class __ASSET__assets_images_dungeonwindow_png extends lime.graphics.Image {}
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
@:keep @:image("Assets/images/panelCityWindow.png") @:noCompletion #if display private #end class __ASSET__assets_images_panelcitywindow_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/questman.png") @:noCompletion #if display private #end class __ASSET__assets_images_questman_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/questman_m.png") @:noCompletion #if display private #end class __ASSET__assets_images_questman_m_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/recruitherowindow.png") @:noCompletion #if display private #end class __ASSET__assets_images_recruitherowindow_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/recruitherowindowLevel.png") @:noCompletion #if display private #end class __ASSET__assets_images_recruitherowindowlevel_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/recruitherowindowPicture.png") @:noCompletion #if display private #end class __ASSET__assets_images_recruitherowindowpicture_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/recruits.png") @:noCompletion #if display private #end class __ASSET__assets_images_recruits_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/recruits_m.png") @:noCompletion #if display private #end class __ASSET__assets_images_recruits_m_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/recruitWindow.png") @:noCompletion #if display private #end class __ASSET__assets_images_recruitwindow_png extends lime.graphics.Image {}
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
