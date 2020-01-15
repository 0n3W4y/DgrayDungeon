package;

class Window
{
	private var _preInited:Bool = false;
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _id:Int;
	private var _deployId:Int;
	private var _name:String;
	private var _type:String;
	private var _status:String; // opened, closed

	private var _buttonChildren:Array<Button>;

	private var _graphics:GraphicsSystem;


	public function new():Void
	{

	}

	public function preInit():String
	{
		this._graphics = new GraphicsSystem();
		var err = this._graphics.preInit();
		if( err != null )
			throw "Error in Button.preInit. " + err;

		this._type = "window";
		this._buttonChildren = new Array();
		this._status = "close";
		this._preInited = true;
		return "ok";
	}

	public function init( id:Int, name:String, deployId:Int, sprite:Sprite ):String
	{
		if( !this._preInited )
			return "Error in Window.init. Pre inited is FALSE";

		this._id = id;
		if( this._id == null )
			return "Error in Window.init. Id is NULL";

		this._name = name;
		if( this._name == null )
			return "Error in Window.init. Name is NULL";

		this._deployId = deployId;
		if( this._deployId == null )
			return "Error in Widnow.init. DeployID is NULL";

		var err = this._graphics.init( this, sprite );
		if( err != "ok" )
			return "Error in Window.init. Window name: " + this._name + "; " + err;

		this._inited = true;
		return "ok";
	}

	public function postInit():String
	{
		if( !this._inited )
			return "Error in Window.postInit. Init is FALSE!";

		this._postInited = true;
		return "ok";
		
	}

	public function update( time:Float ):Void
	{
		for( i in 0...this._buttonChildren.length )
		{
			this._buttonChildren[ i ].update( time );
		}
	}

	public function appendChild( button:Button ):Array<Dynamic>
	{
		var checkButton:Array<Dynamic> = this._checkChildForExist( button );
		var oldButton:Button = checkButton[ 0 ];
		if( oldButton != null )
			return [ null, "Error in Window.appendChild. Button with name: '" + oldButton.getName() + "' already exist" ];

		this._buttonChildren.push( button );
		return [ true, null ];
	}

	public function removeChild( button:Button ):Array<Dynamic>
	{
		var checkButton:Array<Dynamic> = this._checkChildForExist( button );
		var oldButton:Button = checkButton[ 0 ];
		var oldButtonIndex:Int = checkButton[ 1 ];
		if( oldButton != null )
			return [ null, "Error in Window.appendChild. Button with name: '" + buttonName + "' not exist" ];
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
			default: { trace( "Error in Window.get. Can't get " + value ); return null };
		}
	}




	//PRIVATE


	private function _checkChildForExist( button:Button ):Array<Dynamic>
	{
		var buttonId:String = button.getId();
		for( i in 0...this._buttonChildren.length )
		{
			var oldButton:Button = this._buttonChildren[ i ];
			var oldButtonId:Int = oldButton.getId();
			if( oldButtonId == buttonId )
				return [ oldButton, i ];
		}
		return null;
	}

}