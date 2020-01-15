package;

class Button
{
	private var _preInited:Bool = false;
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _id:Int;
	private var _deployId:Int;
	private var _name:Int;
	private var _type:String;
	private var _status:String;

	private var _graphics:GraphicsSystem;
	private var _event:EventSystem;


	public function new()
	{

	}

	public function preInit():String
	{
		this._graphics = new GraphicsSystem();
		var err = this._graphics.preInit();
		if( err != "ok" )
			return "Error in Button.preInit. " + err;

		this._event = new EventSystem();
		err = this._event.preInit();
		if( err != "ok" )
			return "Error in Button.preInit. " + err;

		this._preInited = true;
		return "ok";
	}

	public function init( id:Int, deployId:Int, name:String ):String
	{
		if( !this._preInited )
			return "Error in Button.init. Pre init is FALSE";

		this._id = id;
		if( this._id == null )
			return "Error in Button.init. Id is NULL";

		this._deployId = deployId;
		if( this._deployId == null )
			return "Error in Button.init DeployId is NULL";

		this._name = name;
		if( name == null )
			return "Error in Button.init Name is NULL";
		
	}

	public function postInit():String
	{
		if( !this._inited )
			return "Error in Button.postInit. Init is FALSE";
		
		this._postInited = true;
		return "ok";
	}

	public function changeStatusTo( value:String ):String
	{
		switch( value )
		{
			case "choose", "none": { this._status = value; return "ok"; }
			default: return "Error in button.changeStatusTo. Status can't be: '" + value + "'";
		}
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
			case "sprite": return this._graphics.getSprite();
			default: { trace( "Error in Button.get. Can't get " + value ); return null };
		}
	}
}