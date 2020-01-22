package;

import openfl.display.Sprite;

class Window
{
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _id:Int;
	private var _deployId:Int;
	private var _name:String;
	private var _type:String;
	private var _isActive:Bool;
	private var _alwaysActive:Bool;

	private var _buttonChildren:Array<Button>;

	private var _graphics:GraphicsSystem;


	public function new():Void
	{

	}

	public function init( id:Int, name:String, deployId:Int, sprite:Sprite, alwaysActive:Bool ):Void
	{
		this._type = "window";
		this._buttonChildren = new Array();
		this._isActive = false; // by default status is hide;
		this._alwaysActive = alwaysActive;

		this._id = id;
		if( Std.is( this._id, Int ) )
			throw "Error in Window.init. Id is: '" + id + "'";

		this._name = name;
		if( Std.is( this._name, String ) )
			throw "Error in Window.init. Name is: '" + name + "'";

		this._deployId = deployId;
		if( Std.is( this._deployId, Int ) )
			throw "Error in Widnow.init. DeployID is: '" + deployId + "'";

		this._graphics = new GraphicsSystem();
		var err = this._graphics.init( this, sprite );
		if( err != "ok" )
			throw "Error in Window.init. Window name: " + this._name + "; " + err;

		this._inited = true;
	}

	public function postInit():Void
	{
		if( !this._inited )
			throw "Error in Window.postInit. Init is FALSE!";

		this._postInited = true;		
	}

	public function addChild( button:Button ):Void
	{
		var name:String = button.get( "name" );
		var check:Int = this._checkChildForExist( button );
		if( check != null )
			throw 'Error in Window.addChild. Found duplicate button with name: "$name"';

		this._buttonChildren.push( button );
	}

	public function removeChild( button:Button ):Array<Dynamic>
	{
		var name:String = button.get( "name" );
		var check:Int = this._checkChildForExist( button );
		if( check == null )
			return [ null, 'Error in Window.appendChild. Button with name: "$name" not found' ];

		this._buttonChildren.splice( check, 1 );
		return [ button, null ];
	}

	public function changeActiveStatus():Void
	{
		if( this._isActive )
			this._isActive = false;
		else
			this._isActive = true;
	}

	public function getActiveStatus():Bool
	{
		return this._isActive;
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
			case "activeStatus": return this._isActive;
			case "alwaysActive": return this._alwaysActive;
			case "children": return this._buttonChildren;
			default: { throw( "Error in Window.get. Can't get " + value ); return null; };
		}
	}




	//PRIVATE


	private function _checkChildForExist( button:Button ):Int
	{
		var buttonId:Int = button.get( "id" );
		for( i in 0...this._buttonChildren.length )
		{
			var oldButton:Button = this._buttonChildren[ i ];
			var oldButtonId:Int = oldButton.get( "id" );
			if( oldButtonId == buttonId )
				return i;
		}
		return null;
	}

}