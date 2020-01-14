package;

import openfl.display.Sprite;
import openfl.display.TextField;

class GraphicsSystem
{
	private var _sprite:Sprite; // для обращения к графике сущности
	private var _parent:Dynamic; // получить доступ к классу, в котором находится данный класс.
	private var _preInited:Bool = false;
	private var _inited:Bool = false;

	public function new():Void
	{

	}

	public function preInit():String
	{
		this._preInited = true;
		return "ok";
	}

	public function init( sprite:Sprite ):String
	{
		if( !this._preInited )
			return "Error in GraphicsSystem.init. Is not PREINITED!";
		this._sprite = sprite;
		if( this._sprite == null )
			return  "Error in GraphicsSystem.init, sprite is NULL";

		this._inited = true;
		return "ok";
	}

	public function postInit():String
	{
		if( !this.inited )
			return "Error in GraphicsSystem.postInit. In not INITED!";
		this._postInited = true;
		return "ok";
	}

	public function update():Void
	{
		
	}

	public function changeText( text:String, position:String ):String
	{
		// sprite.getChildAt(1).getChildat( num ) - num is position of text;
		// sprite - main sprite;
		// childAt(1) - text sprite, have childs with textField.

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
		{
			return ( "Error in GraphicsSystem.changeText, TextField not found at : " + num );
		}

		textField.text = text;
		return "ok";
	}

}