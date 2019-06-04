package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;
import flash.text.TextField;

class UserInterface extends Sprite
{
	private var _parent:Game;
	private var _objectsOnUi:Dynamic; //store all sprites / bitmaps for fast remove;


	public function new( parent:Game ):Void
	{
		super();
		this._parent = parent;
		this._objectsOnUi = 
		{
			"widnows": new Array<Dynamic>(),
			"buttons": new Array<Dynamic>()
		};
		//this.alpha = 0.0;
	}

	public function addButton( button:Entity ):Void
	{
		var data = new Bitmap( Assets.getBitmapData( button.getComponent( "graphics" ).getUrl( 0 ) ) );
		var sprite = new Sprite();
		sprite.addChild( data );

		var coords = button.getComponent( "graphics" ).getCoordinates();
		sprite.x = coords.x;
		sprite.y = coords.y;
		this._parent.getSystem( "event" ).addEventListener( sprite, "MOUSE_CLIKC" );
		this._parent.getSystem( "event" ).addEventListener( sprite, "MOUSE_UP" );
		this._parent.getSystem( "event" ).addEventListener( sprite, "MOUSE_DOWN" );
		addChild( sprite );
	}

	public function addWindow( window:Entity ):Void
	{
		var data = new Bitmap( Assets.getBitmapData( window.getComponent( "graphics" ).getUrl( 0 ) ) );
		var sprite = new Sprite();
		sprite.addChild( data );

		var coords = window.getComponent( "graphics" ).getCoordinates();
		sprite.x = coords.x;
		sprite.y = coords.y;
		addChild( sprite );
	}

	public function addText( text:Dynamic ):Void //text = { "text1": { text:" bal-bla", "x": 0.0, "y": 0,0 } , "text2": { text: "bla-bla-bla", "x": 0.0, "y": 0.0 } };
	{

		/*
		var sp:Sprite = new Sprite();
        txt1 = new TextField();
            
        sp.graphics.drawRect    (0, 0, 30, 30);
        sp.x = i * 30 + 120 + i * 2; 
        sp.y = Main.maxHeight - 75;
            
        txt1.visible = true; 
        txt1.selectable    = false; 
        txt1.width     = 30;    
        txt1.height = 30;
        txt1.autoSize = TextFieldAutoSize.CENTER;
        txt1.textColor = 0xfcc0fc;
        txt1.text = tabConcat[i];
        sp.addChild    (txt1);
        addChild(sp);
		*/
	}

	public function removeWindow( window:Entity ):Void
	{

	}

	public function removeButton( window:Entity ):Void
	{

	}
}