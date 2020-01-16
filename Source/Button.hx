package;

class Button
{
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _id:Int;
	private var _deployId:Int;
	private var _name:Int;
	private var _type:String;
	private var _chooseUnchooseStatus:String;
	private var _sprite:Sprite;

	private var _graphics:GraphicsSystem;
	private var _event:EventSystem;


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
		var err = this._graphics.init( this );
		if( err != "ok" )
			return "Error in Button.init. " + err;

		this._event = new EventSystem();
		err = this._event.init( this );
		if( err != "ok" )
			return "Error in Button.init. " + err;

		this._sprite = sprite;
		if( Std.is( this._sprite, Sprite ))
			return "Error in Button.init. Sprite is not a Sprite class ";

		this._type = "button";
		

		this._chooseUnchooseStatus = "unchoose";
		return "ok";
		
	}

	public function postInit():String
	{
		if( !this._inited )
			return "Error in Button.postInit. Init is FALSE";
		
		this._postInited = true;
		return "ok";
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
			case "event": return this._event;
			case "sprite": return this._sprite;
			case "chooseUnchooseStatus": return this._chooseUnchooseStatus;
			default: { trace( "Error in Button.get. Can't get " + value ); return null };
		}
	}
}