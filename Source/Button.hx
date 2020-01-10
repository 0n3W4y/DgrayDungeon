package;

class Button
{
	private var _preInited:Bool = false;
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _id:Int;
	private var _deployId:Int;
	private var _name:Int;
	private var _status:String;

	private var _graphics:GraphicsSystem;
	private var _event:EventSystem;


	public function new()
	{

	}

	public function preInit():Array<Dynamic>
	{
		this._graphics = new GraphicsSystem();
		var [ bool, err ] = this._graphics.preInit();
		if( err != null )
			throw "Error in Button.preInit. " + err;

		this._event = new EventSystem();
		var [ bool, err ] = this._event.preInit();
		if( err != null )
			throw "Error in Button.preInit. " + err;

		this._inited = true;
	}

	public function init( id:Int, deployId:Int, name:String ):Array<Dynamic>
	{
		this._id = id;
		if( this._id == null )
			return [ null, "Error in Button.init. Id is: '" + id +"'" ];

		this._deployId = deployId;
		if( this._deployId == null )
			return [ null, "Error in Button.init DeployId is: '" + deployId + "'" ];

		this._name = name;
		if( name == null )
			return [ null, "Error in Button.init Name is: '" + name + "'"];
		
	}

	public function postInit():<Dynamic>
	{

	}

	public function update( time:Float ):Void
	{

	}

	public function getId():Int
	{
		return this._id;
	}

	public function getName():String
	{
		return this._string;
	}

	public function getStatus():String
	{
		return this._status;
	}

	public function getDeployId():Int
	{
		return this._deployId;
	}

	public function changeStatusTo( value:String ):Array<Dynamic>
	{
		switch( value )
		{
			case "choosen", "none": { this._status = value; return [ true, null ] }
			default: return [ null, "Error in button.changeStatusTo. Status can't be: '" + value + "'" ];
		}
	}
}