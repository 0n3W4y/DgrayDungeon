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

	private function _sortWithQueueWindow( a:Entity, b:Entity ):Int
	{
		var aQueue = a.getComponent( "graphics" ).getQueue();
		var bQueue = b.getComponent( "graphics" ).getQueue();
		if( aQueue > bQueue )
			return 1;
		else if( aQueue < bQueue )
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
		// Sprite - > child[0] = Sprite with graphics;
		// Sprite - > child[1] = Sprite TextFields - > with queue;
		var sprite:Sprite = new Sprite();
		var graphicsSprite:Sprite = new Sprite();
		var textSprite = new Sprite();
		var windowGraphics = window.getComponent( "graphics" );
		var normalData = null;

		if( windowGraphics.getImg() != null )
		{
			normalData = new Bitmap( Assets.getBitmapData( windowGraphics.getImg().normal.url ) ); // normal -> background != null always;
			normalData.x = windowGraphics.getImg().normal.x;
			normalData.y = windowGraphics.getImg().normal.y;
			graphicsSprite.addChild( normalData );
		}
		sprite.addChild( graphicsSprite );

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
		}

		windowGraphics.setGraphicsInstance( sprite );
		return sprite;
	}

	private function _createButton( button:Entity ):Sprite
	{
		// Sprite - > child[0] = Sprite with graphics;
		// Sprite - > child[1] = Sprite TextFields - > with queue;
		var isHide:Bool = false;
		if( button.get( "name" ) == "recruitWindowHeroButtonOne" )
			isHide = true;

		var sprite:Sprite = new Sprite();
		var graphicsSprite:Sprite = new Sprite();
		var textSprite = new Sprite();
		var buttonGraphics = button.getComponent( "graphics" );

		var imageContainer:Dynamic =  buttonGraphics.getImg();

		for( key in Reflect.fields( imageContainer ) )
		{
			var value = Reflect.getProperty( imageContainer, key );
			// all keys are 1, 2, 3, 4, 5, they r have static order, so i ca use it;
			// 0 - normal, 1 - hover , 2 - pushed, ( 3 - portrait, 4 - level - for special button );
			var data:Bitmap = new Bitmap( Assets.getBitmapData( value.url ) );
			data.x = value.x;
			data.y = value.y;
			data.visible = false;
			if( key == "0" && !isHide )
				data.visible = true;

			graphicsSprite.addChild( data );
		}
		sprite.addChild( graphicsSprite );

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
			if( isHide )
				textSprite.visible = false;
			sprite.addChild( textSprite );
		}
		buttonGraphics.setGraphicsInstance( sprite );
		
		this._parent.getSystem( "event" ).addEvent( button, null );
		if( button.get( "name" ) == "gameContinue" )
		{
			var chekButton = this._checkButton( "gameContinue" );
			if( chekButton )
			{
				//remove all events from button.
				this._parent.getSystem( "event" ).removeEvent(  button, null );
				sprite.alpha = 0.5;
			}
		}
		
		return sprite;
	}

	private function _createBuilding( object:Entity ):Sprite
	{
		var sprite:Sprite = new Sprite();
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

		sprite.addChild( buildingSprite );

		var coords = objectGraphics.getCoordinates();
		sprite.x = coords.x;
		sprite.y = coords.y;

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
			if( object.get( "name" ) == "inn" )
				textSprite.alpha = 1;

			sprite.addChild( textSprite );
		}
		objectGraphics.setGraphicsInstance( sprite );
		if( object.get( "name" ) == "inn" )
			return sprite;
		this._parent.getSystem( "event" ).addEvent( object, "mCLICK" );
		this._parent.getSystem( "event" ).addEvent( object, "mOUT" );
		this._parent.getSystem( "event" ).addEvent( object, "mOVER" );
		return sprite;
	}

	private function _createUiObject( object:Entity ):Sprite
	{
		var sprite = new Sprite();
		return sprite;
	}

	private function _drawStartScene( scene:Scene ):Void
	{
		//add bacground on scene;
		var backgroundURL = scene.getBackgroundImageURL();
		var bitmap = new Bitmap( Assets.getBitmapData ( backgroundURL ) );
		scene.getSprite().addChild( bitmap );

		//add UI objects to ui;
		var sceneUiEntities:Dynamic = scene.getEntities( "ui" );
		this.createUiObject( sceneUiEntities );
		this._parent.getMainSprite().addChild( scene.getSprite() );
	}

	private function _undrawStartScene( scene:Scene ):Void
	{
		var windowsList:Array<Entity> = scene.getEntities( "ui" ).window;
		for( i in 0...windowsList.length )
		{
			this._parent.getSystem( "ui" ).removeUiObject( windowsList[ i ].get( "name" ) );
		}
		this._parent.getMainSprite().removeChild( scene.getSprite() );
	}

	private function _drawCityScene( scene:Scene ):Void
	{
		var backgroundURL = scene.getBackgroundImageURL();
		var bitmap = new Bitmap( Assets.getBitmapData ( backgroundURL ) );
		scene.getSprite().addChild( bitmap );

		var sceneObjectEntities:Dynamic = scene.getEntities( "object" );
		var buildingsList:Array<Entity> = sceneObjectEntities.building;


		for( i in 0...buildingsList.length )
		{
			var object:Entity = buildingsList[ i ];
			if( object.get( "name") == "inn" || object.get( "name") == "storage" )
				continue;
			var sprite = this.createObject( object );
			scene.getSprite().addChild( sprite );
		}

		var sceneUiEntities:Dynamic = scene.getEntities( "ui" );
		var uiSystem:UserInterface = this._parent.getSystem( "ui" );
		this.createUiObject( sceneUiEntities );

		uiSystem.hideUiObject( "citySceneMainWindow" );
		uiSystem.hideUiObject( "recruitWindow" );

		this._parent.getMainSprite().addChild( scene.getSprite() );
	}

	private function _drawchooseDungeonScene( scene:Scene ):Void
	{
		var backgroundURL = scene.getBackgroundImageURL();
		var bitmap = new Bitmap( Assets.getBitmapData ( backgroundURL ) );
		scene.getSprite().addChild( bitmap );

		var sceneUiEntities:Dynamic = scene.getEntities( "ui" );
		this.createUiObject( sceneUiEntities );
		this._parent.getMainSprite().addChild( scene.getSprite() );
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

	public function createUiObject( list:Dynamic ):Void
	{
		//TODO: rebuild function;
		var windows:Array<Entity> = list.window;
		var buttons:Array<Entity> = list.button;
		windows.sort( this._sortWithQueueWindow );
		
		for( i in 0...windows.length )
		{
			var window = windows[ i ];
			var windowName = window.get( "name" );
			var spriteWindow:Sprite = this._createWindow( window );
			for( j in 0...buttons.length )
			{
				var button = buttons[ j ];
				var buttonParent = button.getComponent( "ui" ).getParentWindow();
				if( buttonParent == windowName )
				{
					var spriteButton:Sprite = this._createButton( button );
					spriteWindow.addChild( spriteButton );
				}
			}
			this._parent.getSystem( "ui" ).addUiObject( { "name": windowName, "window": window } );
		}		
	}

	public function drawObject( object:Entity ):Void
	{
		// this function get  raw entity, and create graphics for it, add on UI, if it UI type, or just put it on activeScene sprite;
		var type:String = object.get( "type" );
		switch( type )
		{
			case "window":
			case "building":
			default: trace( "Error in GraphicsSystem.drawObject, object type: " + type + ", can't be found." );
		}
	}

	public function undrawObject( object:Entity ):Void
	{
		var type:String = object.get( "type" );
		switch( type )
		{
			case "window":
			case "building":
			default: trace( "Error in GraphicsSystem.undrawObject, object type: " + type + ", can't be found." );
		}
	}

	public function createObject( object:Entity ):Sprite
	{
		var type = object.get( "type" );
		switch( type )
		{
			case "building": return this._createBuilding( object );
			case "window": return this._createUiObject( object );
			default: trace( "Error GraphicsSystem.createObject, object type: " + type + ", can't be found." );
		}
		return null;
	}

	public function hideScene( scene:Scene ):Void
	{
		scene.getSprite().visible = false;
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
		scene.getSprite().visible = true;
	}
}