package;

import openfl.display.Sprite;

class Button
{
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _id:Int;
	private var _deployId:Int;
	private var _name:String;
	private var _type:String;
	private var _activeStatus:Bool;
	
	private var _events:EventSystem;
	private var _graphics:GraphicsSystem;


	public function new()
	{

	}

	public function init( id:Int, deployId:Int, name:String, sprite:Sprite ):Void
	{
		this._type = "button";

		this._id = id;
		if( Std.is( this._id, Int ) )
			throw "Error in Button.init. Id is: '" + id + "'";

		this._deployId = deployId;
		if( Std.is( this._deployId, Int ) )
			throw "Error in Button.init DeployId is: '" + deployId + "'";

		this._name = name;
		if( Std.is( this._name, String ) )
			throw "Error in Button.init Name is: '" + name + "'";

		this._graphics = new GraphicsSystem();
		this._graphics.init( this, sprite );

		this._events = new EventSystem();
		this._events.init( this );

		this._activeStatus = false;	
	}

	public function postInit():Void
	{
		if( !this._inited )
			throw "Error in Button.postInit. Init is FALSE";
		
		this._postInited = true;
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
			case "events": return this._events;
			case "activeStatus": return this._activeStatus;
			default: { throw( "Error in Button.get. Can't get " + value ); return null; };
		}
	}
}