package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.display.Bitmap;

typedef GraphicsSystemconfig =
{
	var Parent:Dynamic;
	var GraphicsSprite:Sprite;
}

class GraphicsSystem
{
	private var _parent:Dynamic; // получить доступ к классу, в котором находится данный класс.
	private var _sprite:Sprite;

	public inline function new( config:GraphicsSystemconfig ):Void
	{
		this._parent = config.Parent;
		this._sprite = config.GraphicsSprite;
	}

	public function init( error:String ):Void
	{
		var err:String = 'Error in GraphicsSystem.init';
		if( this._parent == null )
			throw ' $error. $err. Parent is null!';

		if( this._sprite == null )
			throw ' $error. $err. Sprite is null!';
	}

	public function postInit():Void
	{

	}

	public function setText( text:String, place:String ):Void
	{
		var textField:TextField = null;
		var testSprite:Dynamic = this._sprite.getChildAt( 1 );
		switch( place )
		{
			case "first": textField = testSprite.getChildAt( 0 );
			case "second": textField = testSprite.getChildAt( 1 );
			case "third": textField = testSprite.getChildAt( 2 );
			case "fourth": textField = testSprite.getChildAt( 3 );
			default: throw 'Error in GraphicsSystem.setText. Can not set text on $place';
		}
		if( textField == null )
			throw 'Error in GraphicsSystem.setText. TextField not found on $place';

		textField.text = text;
	}

	public function getText( place:String ):String
	{
		var textField:TextField = null;
		var testSprite:Dynamic = this._sprite.getChildAt( 1 ); //Text sprite;
		switch( place )
		{
			case "first": textField = testSprite.getChildAt( 0 );
			case "second": textField = testSprite.getChildAt( 1 );
			case "third": textField = testSprite.getChildAt( 2 );
			case "fourth": textField = testSprite.getChildAt( 3 );
			default: throw 'Error in GraphicsSystem.setText. Can not set text on $place';
		}
		if( textField == null )
			throw 'Error in GraphicsSystem.getText. No text found on child at $place';

		return textField.text;
	}


	public inline function getSprite():Sprite
	{
		return this._sprite;
	}

	public function addGraphics( bitmap:Bitmap ):Void
	{
		var mainGraphicsSprite:Dynamic = this._sprite.getChildAt( 0 ); // graphics displayObjectContainer;
		mainGraphicsSprite.addChild( bitmap );
	}

	public function getGraphicsAt( num:Int ):Bitmap
	{
		var mainGraphicsSprite:Dynamic = this._sprite.getChildAt( 0 ); // graphics displayObjectContainer;
		var bitmap:Bitmap = mainGraphicsSprite.getChildAt( num );
		return bitmap;
	}

	public function removeGraphicsAt ( num:Int ):Void
	{
		var mainGraphicsSprite:Dynamic = this._sprite.getChildAt( 0 ); // graphics displayObjectContainer;
		var bitmap:Bitmap = mainGraphicsSprite.getChildAt( num );
		if( bitmap == null )
			throw 'Error in GraphicsSystem.removeGraphicsAt. No bitmap at "$num"';

		mainGraphicsSprite.removeChildAt( num );
	}




	// PRIVATE
}
