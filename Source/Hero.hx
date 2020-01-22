package;

class Hero
{
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _id:Int;
	private var _deployId:Int;
	private var _name:String;
	private var _type:String;
	
	public function new():Void
	{

	}

	public function init( id:Int, deployId:Int, name:String ):Void
	{	
		this._type = "hero";
		this._id = id;
		if( id == null )
			throw 'Error in Hero.init. Id is: "$id"';

		this._deployId = deployId;
		if( deployId == null )
			throw 'Error in Hero.init. Deploy ID is: "$deployId"';

		this._name = name;
		if( name == null )
			throw 'Error in Hero.init. Name is: "$name"';

		this._inited = true;
	}

	public function postInit():Void
	{
		if( !this._inited )
			throw "Error in Hero.postInit. Inited is FALSE";

		this._postInited = true;
	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "id": return this._id;
			case "deployId": return this._deployId;
			case "name": return this._name;
			case "type": return this._type;
			default: { throw( "Error in Hero.get. Can't get " + value ); return null; };
		}
	}
}