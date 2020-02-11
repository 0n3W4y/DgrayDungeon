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

	public inline function getSprite():Sprite
	{
		return this._sprite;
	}

	// PRIVATE
}
