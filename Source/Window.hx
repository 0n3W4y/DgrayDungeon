package;

import openfl.display.Sprite;
import haxe.EnumTools.EnumValueTools;
import Button;

enum WindowID
{
	WindowID( _:Int );
}

enum WindowDeployID
{
	WindowDeployID( _:Int );
}

typedef WindowConfig =
{
	var ID:WindowID;
	var DeployID:WindowDeployID;
	var Name:String;
	var GraphicsSprite:Sprite;
	var AlwaysActive:Bool;
}

class Window
{
	private var _id:WindowID;
	private var _deployId:WindowDeployID;
	private var _name:String;
	private var _type:String;
	private var _isActive:Bool;
	private var _alwaysActive:Bool;

	private var _buttonChildren:Array<Button>;

	private var _graphics:GraphicsSystem;


	public inline function new( config:WindowConfig ):Void
	{
		this._type = "window";
		this._id = config.ID;
		this._name = config.Name;
		this._deployId = config.DeployID;
		this._alwaysActive = config.AlwaysActive;
		this._graphics = new GraphicsSystem({ Parent:this, GraphicsSprite:config.GraphicsSprite });
	}

	public function init( error:String ):Void
	{
		var err:String = '$error. Error in Window.init. Name "$_name" id "$_id" deploy id "$_deployId"';
		this._isActive = false; // by default status is hide;
		this._buttonChildren = new Array<Button>();

		if( this._name == null || this._name == "" )
			throw '$err. Wrong name';

		if( this._id == null )
			throw '$err. Wrong ID';

		if( this._deployId == null )
			throw '$err. Wrong Deploy ID';

		this._graphics.init( err );
	}

	public function postInit():Void
	{

	}

	public function addButton( button:Button ):Void
	{
		var name:String = button.get( "name" );
		var id:ButtonID = button.get( "id" );

		var check:Int = this._checkChildForExist( id );
		if( check != null )
			throw 'Error in Window.addButton. Found duplicate button with name: "$name"';

		this._buttonChildren.push( button );
		this.get( "sprite" ).addChild( button.get( "sprite" ));
	}

	public function removeButton( button:Button ):Button
	{
		var name:String = button.get( "name" );
		var id:ButtonID = button.get( "id" );
		var check:Int = this._checkChildForExist( id );
		if( check == null )
			throw 'Error in Window.removeButton. Button with name: "$name" not found';

		this.get( "sprite" ).removeChild( button.get( "sprite" ));
		this._buttonChildren.splice( check, 1 );
		return button;
	}

	public function changeActiveStatus():Void
	{
		if( this._isActive )
			this._isActive = false;
		else
			this._isActive = true;
	}

	public function getActiveStatus():Bool
	{
		return this._isActive;
	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "id": return this._id;
			case "deployId": return this._deployId;
			case "name": return this._name;
			case "type": return this._type;
			case "graphics": return this._graphics;
			case "sprite": return this._graphics.getSprite();
			case "isActive": return this._isActive;
			case "alwaysActive": return this._alwaysActive;
			case "buttons": return this._buttonChildren;
			default: throw 'Error in Window.get. Can not get "$value"';
		}
	}

	public function getButtonById( id:ButtonID ):Button
	{
		for( i in 0...this._buttonChildren.length )
		{
			var button:Button = this._buttonChildren[ i ];
			if( EnumValueTools.equals( id, button.get( "id" )))
				return button;
		}
		return null;
	}




	//PRIVATE


	private function _checkChildForExist( id:ButtonID ):Int
	{
		for( i in 0...this._buttonChildren.length )
		{
			var oldButtonId:ButtonID = this._buttonChildren[ i ].get( "id" );
			if( EnumValueTools.equals( oldButtonId, id ))
				return i;
		}
		return null;
	}



}
