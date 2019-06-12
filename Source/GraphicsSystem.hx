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
	private function _createText( text:Dynamic ):TextField //text = { "text1": { text:" bal-bla", "x": 0.0, "y": 0,0 } , "text2": { text: "bla-bla-bla", "x": 0.0, "y": 0.0 } };
	{
        var txt = new TextField();

        var textFormat:TextFormat = new TextFormat();
        textFormat.font = text.font;
        textFormat.size = text.size;
        textFormat.color = text.color;

        txt.visible = text.visible;
        txt.selectable = text.selectable;
        txt.defaultTextFormat = textFormat;
        txt.text = text.text;
        txt.x = text.x;
        txt.y = text.y;

		
        return txt;
	}

	private function _createWindow( window:Entity ):Sprite
	{
		var windowGraphics = window.getComponent( "graphics" );

		var data = new Bitmap( Assets.getBitmapData( windowGraphics.getUrl( 0 ) ) );
		var sprite = new Sprite();
		sprite.addChild( data );

		var coords = windowGraphics.getCoordinates();
		sprite.x = coords.x;
		sprite.y = coords.y;

		var text = windowGraphics.getText();
		if( text != null )
		{
			for( key in Reflect.fields( text ) )
			{
				var value = Reflect.getProperty( text, key );
				var textSprite = this._createText( value );
				sprite.addChild( textSprite );
			}
			
		}
		return sprite;
	}

	private function _createButton( button:Entity ):Sprite
	{
		var sprite = new Sprite();
		var buttonGraphics = button.getComponent( "graphics" );

		var data = new Bitmap( Assets.getBitmapData( buttonGraphics.getUrl( 0 ) ) );
		var data2 = new Bitmap( Assets.getBitmapData( buttonGraphics.getUrl( 1 ) ) );
		var data3 = new Bitmap( Assets.getBitmapData( buttonGraphics.getUrl( 2 ) ) );

		data2.visible = false;
		data3.visible = false;

		sprite.addChild( data );
		sprite.addChild( data2 );
		sprite.addChild( data3 );

		var coords = buttonGraphics.getCoordinates();
		sprite.x = coords.x;
		sprite.y = coords.y;

		var text:Dynamic = buttonGraphics.getText();
		if( text != null )
		{
			for( key in Reflect.fields( text ) )
			{
				var value = Reflect.getProperty( text, key );
				var textSprite = this._createText( value );
				textSprite.height = sprite.height;
				textSprite.width = sprite.width;
				this._parent.getSystem( "event" ).addEvent( button.get( "name" ), textSprite );
				if( button.get( "name" ) == "startSceneContinueButton")
				{
					var chekButton = this._checkButton( "startSceneContinueButton" );
					if( chekButton )
					{
						//remove all events from button.
						this._parent.getSystem( "event" ).removeEvent( button.get( "name" ), textSprite, null );
						sprite.alpha = 0.5;
					}
				}
				sprite.addChild( textSprite );
			}	
		}
		return sprite;
	}

	private function _createBuilding( object:Entity ):Sprite
	{
		var sprite = new Sprite();
		var objectGraphics = object.getComponent( "graphics" );

		var data = new Bitmap( Assets.getBitmapData( objectGraphics.getUrl( 0 ) ) );
		var data2 = new Bitmap( Assets.getBitmapData( objectGraphics.getUrl( 1 ) ) );
		sprite.addChild( data );
		data2.visible = false;
		sprite.addChild( data2 );

		var coords = objectGraphics.getCoordinates();
		sprite.x = coords.x;
		sprite.y = coords.y;

		var text = objectGraphics.getText();
		if( text != null )
		{
			for( key in Reflect.fields( text ) )
			{
				var value = Reflect.getProperty( text, key );
				var textSprite = this._createText( value );
				textSprite.height = sprite.height;
				textSprite.width = sprite.width;
				textSprite.visible = false;
				//this._parent.getSystem( "event" ).addEvent( object.get( "name" ), textSprite );
				sprite.addChild( textSprite );
			}
			
		}
		return sprite;
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

		var sortFunction = function( a, b )
		{
			if( a.getComponent( "graphics" ).getQueue() > b.getComponent( "graphics" ).getQueue() )
				return 1;
			else if( a.getComponent( "graphics" ).getQueue() < b.getComponent( "graphics" ).getQueue() )
				return -1;
			else
				return 0;
		}
		buildingsList.sort( sortFunction );

		for( i in 0...buildingsList.length )
		{
			var object = buildingsList[ i ];
			var sprite = this.createObject( object );
			scene.addChild( sprite );
		}

		var sceneUiEntities:Dynamic = scene.getEntities( "ui" );
		this.createUiObject( "innWindow", sceneUiEntities );

		this._parent.getMainSprite().addChild( scene );
	}

	private function _undrawCityScene( scene:Scene ):Void
	{

	}
	

	public function new( parent:Game ):Void
	{
		_parent = parent;
	}

	public function drawScene( scene:Scene ):Void
	{
		var sceneName = scene.getName();
		switch( sceneName )
		{
			case "startScene": this._drawStartScene( scene );
			case "cityScene": this._drawCityScene( scene );
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
		var sprite:Sprite = new Sprite();
		var windows:Array<Entity> = list.windows;
		var buttons:Array<Entity> = list.buttons;
		for( i in 0...windows.length )
		{
			var window = windows[ i ];
			var windowAddiction = window.getComponent( "graphics" ).getAddiction();
			if( windowAddiction == name )
			{
				var spriteWindow = this._createWindow( window );
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
				sprite.addChild( spriteWindow );
			}
		}
		this._parent.getSystem( "ui" ).addUiObject( { "name": name, "sprite": sprite } );
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
	}

	public function showScene( scene:Scene ):Void
	{
		scene.visible = true;
	}
}