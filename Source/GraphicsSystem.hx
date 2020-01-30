package;

import openfl.display.Sprite;
import openfl.text.TextField;

class GraphicsSystem
{
	private var _parent:Dynamic; // получить доступ к классу, в котором находится данный класс.
	private var _sprite:Sprite;

	public function new( parent:Dynamic ):Void
	{
		this._parent = parent;
		this._sprite = this._parent.get( "sprite" ); // копируем спрайт из  главной сущности.
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

	public function changeFirstText( text:String ):String
	{
		var abstractSprite:Dynamic = this._sprite;
		var textField:TextField = abstractSprite.getChildAt( 1 ).getChildAt( 0 );
		if( textField == null )
			return ( "Error in GraphicsSystem.changeFirstText, TextField not found" );

		textField.text = text;
		return "ok";
	}

	public function changeSecondText( text:String ):String
	{
		var abstractSprite:Dynamic = this._sprite;
		var textField:TextField = abstractSprite.getChildAt( 1 ).getChildAt( 1 ); // first getChildAt( 1 ) - sprite with textField childs.
		if( textField == null )
			return ( "Error in GraphicsSystem.changeSecondText, TextField not found" );

		textField.text = text;
		return "ok";
	}

	// PRIVATE
}