package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;
import flash.text.TextField;
import openfl.display.SimpleButton;

class UserInterface extends Sprite
{
	private var _parent:Game;
	private var _objectsOnUi:Dynamic; //store all sprites / bitmaps for fast remove;


	private function _createText( text:Dynamic ):TextField //text = { "text1": { text:" bal-bla", "x": 0.0, "y": 0,0 } , "text2": { text: "bla-bla-bla", "x": 0.0, "y": 0.0 } };
	{
		var textField = new TextField();
		return textField;
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
		
		var exitGameButtonTextFormat:TextFormat = new TextFormat("Verdana", 28, 0xffffff, true);
        exitGameButtonTextFormat.align = TextFormatAlign.CENTER;

        var exitGameButtonText = new TextField();
        exitGameButtonText.width = 180;
        exitGameButtonText.height = 40;
        exitGameButtonText.defaultTextFormat = exitGameButtonTextFormat;
        exitGameButtonText.text = "Exit";
        exitGameButtonText.selectable = false;
        addChild(exitGameButtonText);

         exitGameButtonText.addEventListener( MouseEvent.CLICK, onClickExitButton );
         exitGameButtonText.addEventListener( MouseEvent.MOUSE_OVER, mouseOverExitButton );
         exitGameButtonText.addEventListener( MouseEvent.MOUSE_OUT, mouseOutExitButton );

        exitGameButtonText.x = (Lib.current.stage.stageWidth - exitGameButtonText.width) / 2 + 400;
        exitGameButtonText.y = (Lib.current.stage.stageHeight - exitGameButtonText.height) / 2 + 300;
        */
	}


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
		var buttonGraphics = button.getComponent( "graphics" );

		var data = new Bitmap( Assets.getBitmapData( buttonGraphics.getUrl( 0 ) ) );
		var data2 = new Bitmap( Assets.getBitmapData( buttonGraphics.getUrl( 1 ) ) );

		var newButton = new SimpleButton(data, data, data2, data2 );
		var sprite = new Sprite();

		// function to check buttons when it added to UI;
		if ( button.get( "name" ) == "continueButton" )
			newButton.enabled = false;

		var coords = buttonGraphics.getCoordinates();
		sprite.x = coords.x;
		sprite.y = coords.y;
		this._parent.getSystem( "event" ).addEvent( button.get( "name" ), sprite );

		buttonGraphics.setGraphicsInstance( sprite );
		sprite.addChild( newButton );
		this.addChild( sprite );
	}

	public function addWindow( window:Entity ):Void
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
			var textSprite = this._createText( text );
			sprite.addChild( textSprite );
		}

		windowGraphics.setGraphicsInstance( sprite );
		this.addChild( sprite );
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