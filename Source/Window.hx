package;

import openfl.display.Sprite;

class Window
{
	private var _id:GeneratorSystem.ID;
	private var _deployId:GeneratorSystem.DeployID;
	private var _name:GeneratorSystem.Name;
	private var _type:String;
	private var _isActive:Bool;
	private var _alwaysActive:Bool;

	private var _buttonChildren:Array<Button>;

	private var _graphics:GraphicsSystem;


	public function new( config:GeneratorSystem.WindowConfig ):Void
	{
		this._type = "window";
		this._id = config.ID;
		this._name = config.Name;
		this._deployId = config.DeployID;	
		this._alwaysActive = config.AlwaysActive;	
		this._graphics = new GraphicsSystem( this, config.Sprite );
		this._buttonChildren = new Array<Button>();
		this._isActive = false; // by default status is hide;
	}

	public function init():String
	{
		if( !Std.is( this._name, String ) || this._name == null )
			return 'Error in Window.init. Name is:"$this._name"';

		if( !Std.is( this._id, Int ) || this._id == null )
			return 'Error in Window.init. Id is:"$this._id" name:"$this._name"';
		
		if( !Std.is( this._deployId, Int ) || this._deployId == null )
			return 'Error in Window.init. Name is:"$this._name" id is:"$this._id" deploy id is:"$this._deployId"';

		var err:String = this._graphics.init();
		if( err != null )
			return 'Error in Window.init. Name is:"$this._name" id is:"$this._id" deploy id is:"$this._deployId"; $err';

		return null;
	}

	public function postInit():String
	{
		return null;	
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
			case "childs": return this._buttonChildren;
			default: throw 'Error in Window.get. Can not get "$value"';
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