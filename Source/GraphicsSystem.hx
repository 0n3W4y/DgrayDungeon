package;

import openfl.display.Sprite;
import openfl.text.TextField;

class GraphicsSystem
{
	private var _parent:Dynamic; // получить доступ к классу, в котором находится данный класс.

	private var _sprite:Sprite;

	public function new( parent:Dynamic, sprite:Sprite ):Void
	{
		this._parent = parent;
		this._sprite = sprite;
	}

	public function init():String
	{
		if( this._parent == null )
			return "Error in GraphicsSystem.init. Parent is NULL";
		
		if( this._sprite == null )
			return  "Error in GraphicsSystem.init. Sprite is NULL";

		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function changeText( text:String, position:String ):String
	{
		// sprite.getChildAt(1).getChildat( num ) - num is position of text;
		// sprite - main sprite;
		// childAt(1) - text sprite, have childs with textField.
		//TODO: Полностью переделать функцию, мне не нравится.
		var num:Int;
		switch( position )
		{
			case "first": num = 0;
			case "second": num = 1;
			case "third": num = 2;
			case "fourth": num = 3;
			case "five": num = 4;
			default: return ( "Error in GraphicsSystem.changeText, bad position. Position is: " + position );
		}
		var abstractSprite:Dynamic = this._sprite;
		var textField:TextField = abstractSprite.getChildAt( 1 ).getChildAt( num );
		if( textField == null )
			return ( "Error in GraphicsSystem.changeText, TextField not found at : " + position );

		textField.text = text;
		return "ok";
	}

	public function getSprite():Sprite
	{
		return this._sprite;
	}


	// PRIVATE
}