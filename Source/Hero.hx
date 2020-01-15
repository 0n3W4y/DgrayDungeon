package;

class Hero
{
	private var _preInited:Bool = false;
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _id:Int;
	private var _deployId:Int;
	private var _name:String;
	private var _type:String;
	
	public function new():Void
	{

	}

	public function preInit():Array<Dynamic>
	{
		this._preInited = true;
		return "ok";
	}

	public function init( id:Int, deployId:Int, name:String ):Array<Dynamic>
	{	
		if( !this._preInited )
			return "Error in Hero.init. Pre inited is FALSE";

		this._inited = true;
		return "ok";
	}

	public function postInit():Array<Dynamic>
	{
		if( !this._inited )
			return "Error in Hero.postInit. Inited is FALSE";
		this._postInited = true;
		return "ok";
	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "id": return this._id;
			case "deployId": return this._deployId;
			case "name": return this._name;
			case "type": return this._type;
			default: { trace( "Error in Hero.get. Can't get " + value ); return null };
		}
	}
}