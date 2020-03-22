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


	public inline function new( config:ButtonConfig ):Void
	{
		this._type = "button";
		this._id = config.ID;
		this._deployId = config.DeployID;
		this._name = config.Name;
		this._graphics = new GraphicsSystem({ Parent:this, GraphicsSprite: config.GraphicsSprite });
	}

	public function init( error:String ):Void
	{
		var err:String = 'Name "$_name" id "$_id" deploy id "$_deployId"';
		this._activeStatus = false;

		if( this._name == null || this._name == "" )
			throw '$error. Wrong name. $err';

		if( this._id == null )
			throw '$error Wrong ID. $err';

		if( this._deployId == null )
			throw '$error Wrong Deploy ID. $err"';

		this._graphics.init( '$error. $err' );
	}

	public function postInit():Void
	{

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
