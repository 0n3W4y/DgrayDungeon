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
	private var _chooseUnchooseStatus:String;
	private var _events:Array<String>;

	private var _graphics:GraphicsSystem;


	public function new()
	{

	}

	public function init( id:Int, deployId:Int, name:String, sprite:Sprite ):String
	{
		this._id = id;
		if( Std.is( this._id, Int ) )
			return "Error in Button.init. Id is: '" + id + "'";

		this._deployId = deployId;
		if( Std.is( this._deployId, Int ) )
			return "Error in Button.init DeployId is: '" + deployId + "'";

		this._name = name;
		if( Std.is( this._name, String ) )
			return "Error in Button.init Name is: '" + name + "'";

		this._graphics = new GraphicsSystem();
		var err = this._graphics.init( this, sprite );
		if( err != "ok" )
			return "Error in Button.init. " + err;

		this._type = "button";
		this._events = new Array<String>();

		this._chooseUnchooseStatus = "unchoose";
		return null;
		
	}

	public function postInit():String
	{
		if( !this._inited )
			return "Error in Button.postInit. Init is FALSE";
		
		this._postInited = true;
		return null;
	}

	public function changeChooseUnchooseStatus():Void
	{
		if( this._chooseUnchooseStatus == "choose" )
			this._chooseUnchooseStatus = "unchoose";
		else
			this._chooseUnchooseStatus = "choose";
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
			case "chooseUnchooseStatus": return this._chooseUnchooseStatus;
			default: { trace( "Error in Button.get. Can't get " + value ); return null; };
		}
	}

	public function addEvent( eventName:String ):String
	{
		var checkEvent:Int = this._checkEvent( eventName );
		if( checkEvent != null )
			return 'Error in Button.removeEvent. Button already have event with name: "$eventName"';
		this._events.push( eventName );
	}

	public function removeEvent( eventName:String ):String
	{
		var checkEvent:Int = this._checkEvent( eventName );
		if( checkEvent == null )
			return 'Error in Button.removeEvent. Button have not event with name: "$eventName"';
		
		this._events.splice( checkEvent, 1 );
		return null;			
	}


	// PRIVATE


	private function _checkEvent( eventName:String ):Int
	{
		for( i in 0...this._events.length )
		{
			if( this._events[ i ] == eventName )
			{
				return i;
			}
		}
		return null
	}
}