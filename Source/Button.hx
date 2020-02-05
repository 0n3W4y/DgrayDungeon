package;

import openfl.display.Sprite;

enum ButtonID
{
	ButtonID( _:Int );
}

enum ButtonDeployID
{
	ButtonDeployID( _:Int );
}

typedef ButtonConfig =
{
	var ID:ButtonID;
	var DeployID:ButtonDeployID;
	var Name:String;
	var GraphicsSprite:Sprite;
}

class Button
{
	private var _id:ButtonID;
	private var _deployId:ButtonDeployID;
	private var _name:String;
	private var _type:String;
	private var _activeStatus:Bool;

	private var _graphics:GraphicsSystem;
	private var _sprite:Sprite;


	public inline function new( config:ButtonConfig ):Void
	{
		this._type = "button";
		this._id = config.ID;
		this._deployId = config.DeployID;
		this._name = config.Name;
		this._sprite = config.GraphicsSprite;
		this._graphics = new GraphicsSystem();
	}

	public function init():String
	{
		if( this._name == null || this._name == "" )
			return 'Error in Button.init. Wrong name. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';

		if( this._id == null )
			return 'Error in Button.init. Wrong ID. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';
		
		if( this._deployId == null )
			return 'Error in Button.init. Wrong Deploy ID. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';
		
		var err:String = this._graphics.init({ Parent:this, GraphicsSprite: this._sprite });
		if( err != null )
			return 'Error in Button.init. $err. Name is "$_name" id is:"$_id" deploy id is:"$_deployId"';

		this._activeStatus = false;
		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function changeActiveStatus():Void
	{
		if( this._activeStatus )
			this._activeStatus = false;
		else
			this._activeStatus = true;
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
			case "sprite": return this._sprite;
			case "activeStatus": return this._activeStatus;
			default: { throw( "Error in Button.get. Can't get " + value ); return null; };
		}
	}
}