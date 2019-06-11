package;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.text.TextFormat;
import openfl.text.TextField;

class UserInterface extends Sprite
{
	private var _parent:Game;
	private var _objectsOnUi:Array<Dynamic>; //store all sprites / bitmaps for fast remove;


	private function _createText( text:Dynamic ):Sprite //text = { "text1": { text:" bal-bla", "x": 0.0, "y": 0,0 } , "text2": { text: "bla-bla-bla", "x": 0.0, "y": 0.0 } };
	{
		var textFormat:TextFormat = new TextFormat("Verdana", 28, 0xffffff, true);
		var sp:Sprite = new Sprite();
        var txt = new TextField();

        txt.visible = true; 
        txt.selectable = false; 
        //txt1.width = 30;    
        //txt1.height = 30;
        //txt.autoSize = TextFieldAutoSize.CENTER;
        txt.defaultTextFormat = textFormat;

        txt.text = text.text;
        sp.addChild( txt );
        sp.x = text.x;
        sp.y = text.y;
		
        return sp;
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
		return sprite;

	}


	public function new( parent:Game ):Void
	{
		super();
		this._parent = parent;
		this._objectsOnUi = [];
		//this.alpha = 0.0;
	}

	

	

	public function createUiObject( name:String, list:Dynamic ):Void
	{
		var windows:Array<Entity> = list.windows;
		trace( windows );
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
					if( buttonAddiction = name )
					{
						var spriteButton = this._createButton( button );
						spriteWindow.addChild( spriteButton );
					}
				}
			}
		}
	}

	public function removeUiObject( object:Entity ):Void
	{
		var sprite = object.getComponent( "graphics" ).getGraphicsInstance();
		this.removeChild( sprite );
	}

	public function showUiObject( object:Entity ):Void
	{
		object.getComponent( "graphics" ).getGraphicsInstance().visible = true;
	}

	public function hideUiObject( object:Entity ):Void
	{
		object.getComponent( "graphics" ).getGraphicsInstance().visible = false;
	}
}