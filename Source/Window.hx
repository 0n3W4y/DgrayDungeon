package;

class Window
{
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _id:Int;
	private var _deployId:Int;
	private var _name:String;
	private var _type:String;
	private var _openCloseStatus:String; // open, close

	private var _buttonChildren:Array<Button>;

	private var _graphics:GraphicsSystem;


	public function new():Void
	{

	}

	public function init( id:Int, name:String, deployId:Int, sprite:Sprite ):String
	{
		this._type = "window";
		this._buttonChildren = new Array();
		this._openCloseStatus = "close";

		this._id = id;
		if( Std.is( this._id, Int ) )
			return "Error in Window.init. Id is: '" + id + "'";

		this._name = name;
		if( Std.is( this._name, String ) )
			return "Error in Window.init. Name is: '" + name + "'";

		this._deployId = deployId;
		if( Std.is( this._deployId, Int ) )
			return "Error in Widnow.init. DeployID is: '" + deployId + "'";

		this._graphics = new GraphicsSystem();
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

	public function appendChild( button:Button ):String
	{
		var checkButton:Array<Dynamic> = this._checkChildForExist( button );
		var oldButton:Button = checkButton[ 0 ];
		if( oldButton != null )
			return "Error in Window.appendChild. Button with name: '" + oldButton.get( "name" ) + "' already exist";

		this._buttonChildren.push( button );
		return "ok";
	}

	public function removeChild( button:Button ):Array<Dynamic>
	{
		var checkButton:Array<Dynamic> = this._checkChildForExist( button );
		var oldButton:Button = checkButton[ 0 ];
		var oldButtonIndex:Int = checkButton[ 1 ];
		if( oldButton == null )
			return [ null, "Error in Window.appendChild. Button with name: '" + buttonName + "' not exist" ];
		else
			this._buttonChildren.splice( oldButtonIndex, 1 );
		return [ oldButton, null ];
	}

	public function changeOpenCloseStatus():Void
	{
		if( this._openCloseStatus == "open" )
			this._openCloseStatus = "close";
		else
			this._openCloseStatus = "open";
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
			case "openCloseStatus": return this._openCloseStatus;
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
		return [ null, null ];
	}

}