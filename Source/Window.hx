package;

import openfl.display.Sprite;

enum WindowDeployID
{
	WindowDeployID( _:Int );
}

typedef WindowConfig =
{
	var ID:GeneratorSystem.ID;
	var DeployID:WindowDeployID;
	var Name:String;
	var GraphicsSprite:Sprite;
	var AlwaysActive:Bool;
}

class Window
{
	private var _id:GeneratorSystem.ID;
	private var _deployId:WindowDeployID;
	private var _name:String;
	private var _type:String;
	private var _isActive:Bool;
	private var _alwaysActive:Bool;

	private var _buttonChildren:Array<Button>;

	private var _graphics:GraphicsSystem;


	public function new( config:WindowConfig ):Void
	{
		this._type = "window";
		this._id = config.ID;
		this._name = config.Name;
		this._deployId = config.DeployID;	
		this._alwaysActive = config.AlwaysActive;	
		this._graphics = new GraphicsSystem( this, config.GraphicsSprite );
		this._buttonChildren = new Array<Button>();
		this._isActive = false; // by default status is hide;
	}

	public function init():String
	{
		if( this._name == null || this._name == "" )
			return 'Error in Window.init. Wrong name. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';

		if( this._id == null )
			return 'Error in Window.init. Wrong ID. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';
		
		if( this._deployId == null )
			return 'Error in Window.init. Wrong Deploy ID. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';

		var err:String = this._graphics.init();
		if( err != null )
			return 'Error in Window.init. $err. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';

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