package;

import openfl.display.Sprite;
import openfl.text.TextField;

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
		var abstractSprite:Dynamic = this._sprite;
		var textField:TextField = null;
		switch( place )
		{
			case "first": textField = abstractSprite.getChildAt( 1 ).getChildAt( 0 );
			case "second": textField = abstractSprite.getChildAt( 1 ).getChildAt( 1 );
			default: throw 'Error in GraphicsSystem.setText. Can not set text on $place';
		}
		if( textField == null )
			throw ( "Error in GraphicsSystem.setText. TextField not found on $place" );

		textField.text = text;
	}

	public function getText( place:String ):String
	{
			var mainTextSprite:Dynamic = this._sprite.getChildAt( 1 ); // textsprite displayObjectContainer;
			var textField:TextField = null
			switch( place )
			{
				case "first": textField= mainTextSprite.getChildAt( 0 );
				case "second": textField= mainTextSprite.getChildAt( 1 );
				default: throw 'Error in GraphicsSysytem.getText. Can not get text at $place';
			}
			if( textField == null )
				throw 'Error in GraphicsSystem.getText. No text found on child at $place';

			return textField.text;
	}


	public inline function getSprite():Sprite
	{
		return this._sprite;
	}

	public function setPortrait( sprite:Sprite ):Void
	{
		var mainGraphicsSprite:Dynamic = this._sprite.getChildAt( 0 ); // graphics displayObjectContainer;
		// portrait for button on 3 index;
		var spriteToDelete:Sprite = mainGraphicsSprite.getChiladAt( 3 );
		mainGraphicsSprite.addChildAt( 3 );
		mainGraphicsSprite.removeChild( spriteToDelete );
		// по задумке, сначала добавляется новый спрайт с портретом, сдвигая все следующие чайлды на 1. Удаляю "пустой" портрет.
	}




	// PRIVATE
}
