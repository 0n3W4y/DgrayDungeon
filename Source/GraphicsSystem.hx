package;

import openfl.display.Sprite;
import openfl.text.TextField;

class GraphicsSystem
{
	private var _parent:Dynamic; // получить доступ к классу, в котором находится данный класс.
	private var _sprite:Sprite;

	public inline function new( parent:Dynamic ):Void
	{
		this._parent = parent;
		this._sprite = this._parent.get( "sprite" );
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

	public function changeFirstText( text:String ):Void
	{
		var abstractSprite:Dynamic = this._sprite;
		var textField:TextField = abstractSprite.getChildAt( 1 ).getChildAt( 0 );
		if( textField == null )
			throw ( "Error in GraphicsSystem.changeFirstText, TextField not found" );

		textField.text = text;
	}

	public function changeSecondText( text:String ):Void
	{
		var abstractSprite:Dynamic = this._sprite;
		var textField:TextField = abstractSprite.getChildAt( 1 ).getChildAt( 1 ); // first getChildAt( 1 ) - sprite with textField childs.
		if( textField == null )
			throw ( "Error in GraphicsSystem.changeSecondText, TextField not found" );

		textField.text = text;
	}

	// PRIVATE
}