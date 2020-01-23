package;

import openfl.display.Sprite;

class Button
{
	private var _id:Int;
	private var _deployId:Int;
	private var _name:String;
	private var _type:String;
	private var _activeStatus:Bool;

	private var _graphics:GraphicsSystem;


	public function new( config:Dynamic ):Void
	{
		this._type = "button";
		this._id = config.id;
		this._deployId = config.deployId;
		this._name = config.name;
		this._graphics = new GraphicsSystem(  this, config.sprite );
		this._activeStatus = false;
	}

	public function init():String
	{
		if( this._name == null )
			throw 'Error in Button.init. Name is "$this._name"';
		
		if( this._id == null )
			throw 'Error in Button.init. Name is "$this._name" id is:"$this._id"';
		
		if( this._deployId == null )
			throw 'Error in Button.init. Name is "$this._name" id is:"$this._id" deploy id is:"$this._deployId"';
		
		var err:String = this._graphics.init();
		if( err != null )
			return 'Error in Button.init.';

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