package;

import openfl.display.Sprite;
import openfl.text.TextField;

class GraphicsSystem
{
	private var _parent:Dynamic; // получить доступ к классу, в котором находится данный класс.
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _sprite:Sprite;

	public function new():Void
	{

	}

	public function init( parent:Dynamic, sprite:Sprite ):String
	{
		//TODO: сделать Std.is( parent, Button ) || Std.is( parent. Window ) || e.t.c
		this._parent = parent;
		if( this._parent == null )
			return "Error in GraphicsSystem.init. Parent is NULL";

		this._sprite = sprite;
		if( this._sprite == null )
			return  "Error in GraphicsSystem.init. Sprite is NULL";		

		this._inited = true;
		return "ok";
	}

	public function postInit():String
	{
		if( !this._inited )
			return "Error in GraphicsSystem.postInit. Init is FALSE";

		this._postInited = true;
		return "ok";
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

		var textField:TextField = this._sprite.getChildAt( 1 ).getChildAt( num );
		if( textField == null )
			return ( "Error in GraphicsSystem.changeText, TextField not found at : " + position );

		textField.text = text;
		return "ok";
	}

	public function playAnimation( animation:String ):Void
	{

	}

	public function getSprite():Sprite
	{
		return this._sprite;
	}


	// PRIVATE

	private function hover():Void
	{

	}

	private function unHover():Void
	{

	}

	private function push():Void
	{

	}

	private function unPush():Void
	{

	}
}