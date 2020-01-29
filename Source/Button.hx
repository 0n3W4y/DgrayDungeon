package;

import openfl.display.Sprite;

enum ButtonDeployID
{
	ButtonDeployID( _:Int );
}

typedef ButtonConfig =
{
	var ID:Game.ID;
	var DeployID:ButtonDeployID;
	var Name:String;
	var GraphicsSprite:Sprite;
}

class Button
{
	private var _id:Game.ID;
	private var _deployId:ButtonDeployID;
	private var _name:String;
	private var _type:String;
	private var _activeStatus:Bool;

	private var _graphics:GraphicsSystem;


	public inline function new( config:ButtonConfig ):Void
	{
		this._type = "button";
		this._id = config.ID;
		this._deployId = config.DeployID;
		this._name = config.Name;
		this._graphics = new GraphicsSystem( this, config.GraphicsSprite );
	}

	public function init():String
	{
		if( this._name == null || this._name == "" )
			return 'Error in Button.init. Wrong name. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';

		if( this._id == null )
			return 'Error in Button.init. Wrong ID. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';
		
		if( this._deployId == null )
			return 'Error in Button.init. Wrong Deploy ID. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';
		
		var err:String = this._graphics.init();
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
			case "sprite": return this._graphics.getSprite();
			case "activeStatus": return this._activeStatus;
			default: { throw( "Error in Button.get. Can't get " + value ); return null; };
		}
	}
}