package;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;


class GraphicsSystem
{
	private var _parent:Game;

	private function _checkButton( name:String ):Bool
	{	
		// there is the function, we need to check button click and other's function to enable it or disable;
		switch( name )
		{
			case "startSceneContinueButton": return true;
			default: return false;
		}
	}
	private function _createText( text:Dynamic ):TextField
	//text = { "text1": { text:" bal-bla", "x": 0.0, "y": 0,0 } , "text2": { text: "bla-bla-bla", "x": 0.0, "y": 0.0 } }; 
	{
        var txt = new TextField();

        var textFormat:TextFormat = new TextFormat();
        textFormat.font = text.font;
        textFormat.size = text.size;
        textFormat.color = text.color;
        textFormat.align = TextFormatAlign.CENTER;

        txt.defaultTextFormat = textFormat;
        txt.visible = text.visible;
        txt.selectable = text.selectable;
        txt.text = text.text;
        txt.width = text.width;
        txt.height = text.height;

        txt.x = text.x;
        txt.y = text.y;
        return txt;
	}

	private function _createWindow( window:Entity ):Sprite
	{
		var windowGraphics = window.getComponent( "graphics" );

		var data = new Bitmap( Assets.getBitmapData( windowGraphics.getUrl( 0 ) ) );
		window.addChild( data );

		var coords = windowGraphics.getCoordinates();
		window.x = coords.x;
		window.y = coords.y;

		return window;
	}

	private function _createButton( button:Entity ):Sprite
	{
		var buttonGraphics = button.getComponent( "graphics" );

		var data = new Bitmap( Assets.getBitmapData( buttonGraphics.getUrl( 0 ) ) );
		var data2 = new Bitmap( Assets.getBitmapData( buttonGraphics.getUrl( 1 ) ) );
		var data3 = new Bitmap( Assets.getBitmapData( buttonGraphics.getUrl( 2 ) ) );

		data2.visible = false;
		data3.visible = false;

		button.addChild( data );
		button.addChild( data2 );
		button.addChild( data3 );

		var coords = buttonGraphics.getCoordinates();
		button.x = coords.x;
		button.y = coords.y;

		
		this._parent.getSystem( "event" ).addEvent( button.get( "name" ), button );
		if( button.get( "name" ) == "startSceneContinueButton" )
		{
			var chekButton = this._checkButton( "startSceneContinueButton" );
			if( chekButton )
			{
				//remove all events from button.
				this._parent.getSystem( "event" ).removeEvent( button.get( "name" ), button, null );
				button.alpha = 0.5;
			}
		}			
		return button;
	}

	private function _createBuilding( object:Entity ):Sprite
	{
		if( object.get( "name" ) == "inn" )
			return object;
		var objectGraphics = object.getComponent( "graphics" );

		var data = new Bitmap( Assets.getBitmapData( objectGraphics.getUrl( 0 ) ) );
		var data2 = new Bitmap( Assets.getBitmapData( objectGraphics.getUrl( 1 ) ) );
		object.addChild( data );
		data2.visible = false;
		object.addChild( data2 );

		var coords = objectGraphics.getCoordinates();
		object.x = coords.x;
		object.y = coords.y;

		var text = objectGraphics.getText();
		if( text != null )
		{
			var textSp = new Sprite();
			var textArray:Array<Dynamic> = new Array();
			for( key in Reflect.fields( text ) )
			{
				var value = Reflect.getProperty( text, key );
				textArray.push( { "name": key, "value": value } );
			}
			textArray.sort( this._sortWithQueueText );

			for( i in 0...textArray.length )
			{
				var textSprite = this._createText( textArray[ i ].value );
				textSp.addChild( textSprite );
			}
			textSp.alpha = 0;
			this._parent.getSystem( "event" ).addEvent( object.get( "name" ), object );
			object.addChild( textSp );
		}
		return object;
	}

	private function _drawStartScene( scene:Scene ):Void
	{
		//add bacground on scene;
		var backgroundURL = scene.getBackgroundImageURL();
		var bitmap = new Bitmap( Assets.getBitmapData ( backgroundURL ) );
		scene.addChild( bitmap );

		//add UI objects to ui;
		var sceneUiEntities:Dynamic = scene.getEntities( "ui" );
		this.createUiObject( "startSceneButtonsWindow", sceneUiEntities );
		this._parent.getMainSprite().addChild( scene );
	}

	private function _undrawStartScene( scene:Scene ):Void
	{
		var windowsList:Array<Entity> = scene.getEntities( "ui" ).windows;
		for( i in 0...windowsList.length )
		{
			var window = windowsList[ i ];
			this._parent.getSystem( "ui" ).removeUiObject( window );
		}
		this._parent.getMainSprite().removeChild( scene );
	}

	private function _drawCityScene( scene:Scene ):Void
	{
		var backgroundURL = scene.getBackgroundImageURL();
		var bitmap = new Bitmap( Assets.getBitmapData ( backgroundURL ) );
		scene.addChild( bitmap );

		var sceneObjectEntities:Dynamic = scene.getEntities( "object" );
		var buildingsList:Array<Entity> = sceneObjectEntities.buildings;

		buildingsList.sort( this._sortWithQueueEntity );

		for( i in 0...buildingsList.length )
		{
			var object = buildingsList[ i ];
			var sprite = this.createObject( object );
			scene.addChild( sprite );
		}

		var sceneUiEntities:Dynamic = scene.getEntities( "ui" );
		//here we create only that window, whom see all time;
		this.createUiObject( "innWindow", sceneUiEntities );
		this.createUiObject( "panelCityWindow", sceneUiEntities );
		this.createUiObject( "citySceneMainWindow", sceneUiEntities );
		this._parent.getSystem( "ui" ).hideUiObject( "citySceneMainWindow" );


		this._parent.getMainSprite().addChild( scene );
	}

	private function _drawchooseDungeonScene( scene:Scene ):Void
	{
		var backgroundURL = scene.getBackgroundImageURL();
		var bitmap = new Bitmap( Assets.getBitmapData ( backgroundURL ) );
		scene.addChild( bitmap );

		var sceneUiEntities:Dynamic = scene.getEntities( "ui" );
		this.createUiObject( "dungeon1", sceneUiEntities );
		this.createUiObject( "chooseHeroToDungeonWindow", sceneUiEntities );
		this._parent.getMainSprite().addChild( scene );
	}

	private function _undrawCityScene( scene:Scene ):Void
	{

	}

	private function _sortWithQueueEntity( a, b ):Int
	{
		if( a.getComponent( "graphics" ).getQueue() > b.getComponent( "graphics" ).getQueue() )
			return 1;
		else if( a.getComponent( "graphics" ).getQueue() < b.getComponent( "graphics" ).getQueue() )
			return -1;
		else
			return 0;
	}

	private function _sortWithQueueText( a, b ):Int
	{
		if( a.queue > b.queue )
			return 1;
		else if( a.queue < b.queue )
			return -1;
		else
			return 0;
	}
	

	public function new( parent:Game ):Void
	{
		this._parent = parent;
	}

	public function drawScene( scene:Scene ):Void
	{
		var sceneName = scene.getName();
		switch( sceneName )
		{
			case "startScene": this._drawStartScene( scene );
			case "cityScene": this._drawCityScene( scene );
			case "chooseDungeonScene": this._drawchooseDungeonScene( scene );
			default: trace( "Can't draw scene with name: " + sceneName + "." );
		}
	}

	public function undrawScene( scene: Scene ):Void
	{
		var sceneName = scene.getName();
		switch( sceneName )
		{
			case "startScene": this._undrawStartScene( scene );
			case "cityScene": this._undrawCityScene( scene );
			default: trace( "Can't sraw scene with name: " + sceneName + "." );
		}
	}

	public function createUiObject( name:String, list:Dynamic ):Void
	{
		//TODO: rebuild function;
		//[{"name": "Window1","window":{window:entity},"text":[{"text1":{text}}],"button":[{"button1":{button1},"text":{text}]];
		var windows:Array<Entity> = list.windows;
		var buttons:Array<Entity> = list.buttons;
		
		for( i in 0...windows.length )
		{
			var windowTextArray:Dynamic = new Array();
			var buttonsArray:Dynamic = new Array();
			var buttonsTextArray:Dynamic = new Array();

			var window = windows[ i ];
			var windowName = window.get( "name" );
			if( windowName == name )
			{
				var spriteWindow:Sprite = this._createWindow( window );
				var text = window.getComponent( "graphics" ).getText();
				if( text != null )
				{
					var textArray:Array<Dynamic> = new Array();
					var ts:Sprite = new Sprite();
					for( key in Reflect.fields( text ) )
					{
						var value = Reflect.getProperty( text, key );
						textArray.push( { "name": key, "value": value } );				
					}
					textArray.sort( this._sortWithQueueText );
					for( i in 0...textArray.length )
					{
						var newText = textArray[ i ];
						var textSprite = this._createText( newText.value );
						ts.addChild( textSprite );
						windowTextArray.push( { "name": newText.name, "sprite": textSprite } );
					}
					spriteWindow.addChild( ts );	
				}

				for( j in 0...buttons.length )
				{
					var button = buttons[ j ];
					var buttonAddiction = button.getComponent( "graphics" ).getAddiction();
					if( buttonAddiction == name )
					{
						var spriteButton = this._createButton( button );
						var text:Dynamic = button.getComponent( "graphics" ).getText();
						if( text != null )
						{
							var textArray:Array<Dynamic> = new Array();
							var ts:Sprite = new Sprite();
							for( key in Reflect.fields( text ) )
							{
								var value = Reflect.getProperty( text, key );
								textArray.push( { "name": key, "value": value } );
							}
							textArray.sort( this._sortWithQueueText );
							for( i in 0...textArray.length )
							{
								var newText = textArray[ i ];
								var textSprite = this._createText( newText.value );
								ts.addChild( textSprite );
								buttonsTextArray.push( { "name": newText.name, "sprite": textSprite } );
							}
							button.addChild( ts );
							var bName:String = button.get( "name" );
							buttonsArray.push( { "name": bName, "sprite": button, "text": buttonsTextArray } );
							buttonsTextArray = new Array();
						}
						spriteWindow.addChild( spriteButton );
					}
				}
				this._parent.getSystem( "ui" ).addUiObject( { "name": name, "window": spriteWindow, "textWindow": windowTextArray, "button": buttonsArray } );
			}
		}		
	}

	public function createObject( object:Entity ):Sprite
	{
		var type = object.get( "type" );
		switch( type )
		{
			case "building": return this._createBuilding( object );
			default: trace( "Error GraphicsSystem.createObject, object type: " + type + ", can't be found." );
		}
		return null;
	}

	public function hideScene( scene:Scene ):Void
	{
		scene.visible = false;
		var list:Dynamic = scene.getEntities( "ui" );
		var windows:Array<Entity> = list.windows;
		for( i in 0...windows.length )
		{
			var name = windows[ i ].get( "name" );
			this._parent.getSystem( "ui" ).hideUiObject( name );
		}
	}

	public function showScene( scene:Scene ):Void
	{
		scene.visible = true;
	}
}