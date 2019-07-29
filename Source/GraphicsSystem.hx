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


	private function _sortWithQueueText( a, b ):Int
	{
		if( a.queue > b.queue )
			return 1;
		else if( a.queue < b.queue )
			return -1;
		else
			return 0;
	}

	private function _checkButton( name:String ):Bool
	{	
		// there is the function, we need to check button click and other's function to enable it or disable;
		switch( name )
		{
			case "gameContinue": return true;
			default: return false;
		}
	}
	private function _createText( text:Dynamic ):TextField
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
		var sprite = new Sprite();
		var textSprite = new Sprite();
		var windowGraphics = window.getComponent( "graphics" );

		var normalData = new Bitmap( Assets.getBitmapData( windowGraphics.getImg().normal.url ) ); // normal -> background != null always;
		normalData.x = windowGraphics.getImg().normal.x;
		normalData.y = windowGraphics.getImg().normal.y;
		sprite.addChild( normalData );

		var coords = windowGraphics.getCoordinates();
		sprite.x = coords.x;
		sprite.y = coords.y;

		var text = window.getComponent( "graphics" ).getText();
		if( text != null )
		{
			var textArray:Array<Dynamic> = new Array();
			for( key in Reflect.fields( text ) )
			{
				var value = Reflect.getProperty( text, key );
				textArray.push( { "name": key, "value": value } );		
			}
			textArray.sort( this._sortWithQueueText );
			for( i in 0...textArray.length )
			{
				var textField = this._createText( textArray[ i ].value );
				textSprite.addChild( textField );
			}
			sprite.addChild( textSprite );
			windowGraphics.setTextInstance( textSprite );
		}

		windowGraphics.setGraphicsInstance( sprite );
		return sprite;
	}

	private function _createButton( button:Entity ):Sprite
	{
		var sprite:Sprite = new Sprite();
		var textSprite = new Sprite();
		var buttonGraphics = button.getComponent( "graphics" );

		var dataNormal = new Bitmap( Assets.getBitmapData( buttonGraphics.getImg().normal.url ) );
		var dataHover = new Bitmap( Assets.getBitmapData( buttonGraphics.getImg().hover.url ) );
		var dataPush = new Bitmap( Assets.getBitmapData( buttonGraphics.getImg().pushed.url ) );

		dataNormal.x = buttonGraphics.getImg().normal.x;
		dataNormal.y = buttonGraphics.getImg().normal.y;

		dataHover.x = buttonGraphics.getImg().hover.x;
		dataHover.y = buttonGraphics.getImg().hover.y;

		dataPush.x = buttonGraphics.getImg().pushed.x;
		dataPush.y = buttonGraphics.getImg().pushed.y;

		dataNormal.visible = true;
		dataHover.visible = false;
		dataPush.visible = false;

		sprite.addChild( dataNormal );
		sprite.addChild( dataHover );
		sprite.addChild( dataPush );

		var coords = buttonGraphics.getCoordinates();
		sprite.x = coords.x;
		sprite.y = coords.y;

		var text:Dynamic = buttonGraphics.getText();
		if( text != null )
		{
			var textArray:Array<Dynamic> = new Array();
			for( key in Reflect.fields( text ) )
			{
				var value = Reflect.getProperty( text, key );
				textArray.push( { "name": key, "value": value } );
			}
			textArray.sort( this._sortWithQueueText );

			for( i in 0...textArray.length )
			{
				var newText = textArray[ i ];
				var textField = this._createText( newText.value );
				textSprite.addChild( textField );
			}

			sprite.addChild( textSprite );
		}
		
		this._parent.getSystem( "event" ).addEvent( button.get( "name" ), sprite );
		if( button.get( "name" ) == "gameContinue" )
		{
			var chekButton = this._checkButton( "gameContinue" );
			if( chekButton )
			{
				//remove all events from button.
				this._parent.getSystem( "event" ).removeEvent( button.get( "name" ), sprite, null );
				sprite.alpha = 0.5;
			}
		}			
		return sprite;
	}

	private function _createBuilding( object:Entity ):Sprite
	{
		if( object.get( "name" ) == "inn" )
			return null;

		var buildingSprite:Sprite = new Sprite();
		var textSprite:Sprite = new Sprite();
		var objectGraphics:Dynamic = object.getComponent( "graphics" );

		var normalData = new Bitmap( Assets.getBitmapData( objectGraphics.getImg().normal.url ) );
		var hoverData = new Bitmap( Assets.getBitmapData( objectGraphics.getImg().hover.url ) );

		normalData.visible = true;
		hoverData.visible = false;

		normalData.x = objectGraphics.getImg().normal.x;
		normalData.y = objectGraphics.getImg().normal.y;

		hoverData.x = objectGraphics.getImg().hover.x;
		hoverData.y = objectGraphics.getImg().hover.y;

		buildingSprite.addChild( normalData );
		buildingSprite.addChild( hoverData );

		var coords = objectGraphics.getCoordinates();
		buildingSprite.x = coords.x;
		buildingSprite.y = coords.y;

		var text = objectGraphics.getText();
		if( text != null )
		{
			var textArray:Array<Dynamic> = new Array();
			for( key in Reflect.fields( text ) )
			{
				var value = Reflect.getProperty( text, key );
				textArray.push( { "name": key, "value": value } );
			}

			textArray.sort( this._sortWithQueueText );
			for( i in 0...textArray.length )
			{
				var textField = this._createText( textArray[ i ].value );
				textSprite.addChild( textField );
			}

			textSprite.alpha = 0;
			objectGraphics.setTextInstance( textSprite );
			this._parent.getSystem( "event" ).addEvent( object.get( "name" ), object );
		}
		objectGraphics.setGraphicsInstance( buildingSprite );
		return buildingSprite;
	}

	private function _drawStartScene( scene:Scene ):Void
	{
		//add bacground on scene;
		var backgroundURL = scene.getBackgroundImageURL();
		var bitmap = new Bitmap( Assets.getBitmapData ( backgroundURL ) );
		scene.addChild( bitmap );

		//add UI objects to ui;
		var sceneUiEntities:Dynamic = scene.getEntities( "ui" );
		this.createUiObject( "startSceneWindow", sceneUiEntities );
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
			var window = windows[ i ];
			var windowName = window.get( "name" );
			if( windowName == name )
			{
				var spriteWindow:Sprite = this._createWindow( window );

				for( j in 0...buttons.length )
				{
					var button = buttons[ j ];
					var buttonAddiction = button.getComponent( "graphics" ).getAddiction();
					if( buttonAddiction == name )
					{
						var spriteButton = this._createButton( button );
						spriteWindow.addChild( spriteButton );
					}
				}
				this._parent.getSystem( "ui" ).addUiObject( { "name": name, "window": window } );
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