package;

import openfl.display.Sprite;
import openfl.display.TextField;

class GraphicsSystem
{
	private var _sprite:Sprite; // для обращения к графике окна
	private var _parent:Dynamic; // получить доступ к классу, в котором находится данный класс.
	private var _preInited:Bool = false;
	private var _inited:Bool = false;

	public function new():Void
	{

	}

	public function preInit():Array<Dynamic>
	{
		this._preInited = true;
		return [ true, null ];
	}

	public function init( sprite:Sprite ):Array<Dynamic>
	{
		this._sprite = sprite;
		if( this._sprite == null )
			return [ null, "Error in GraphicsSystem.init, sprite is NULL" ];

		this._inited = true;
		return [ true, null ];
	}

	public function update():Void
	{
		
	}

	public function changeText( text:String, position:String ):Array<Dynamic>
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
			default: return [ null, ( "Error in GraphicsSystem.changeText, bad position. Position is: " + position ) ];
		}

		var textField:TextField = this._sprite.getChildAt( 1 ).getChildAt( num );

		if( textField == null )
		{
			return [ null, ( "Error in GraphicsSystem.changeText, TextField not found at : " + num ];
		}

		textField.text = text;
		return [ true, null ];
	}

}