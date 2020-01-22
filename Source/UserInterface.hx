package;

import openfl.display.Sprite;

class UserInterface
{
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _parent:Game;
	private var _objectsOnUi:Array<Dynamic>; //store all sprites / bitmaps for fast remove;
	private var _uiSprite:Sprite;

	public function new():Void
	{

	}

	public function init( parent:Game, sprite:Sprite ):Void
	{
		this._parent = parent;
		if( parent == null )
			throw 'Error in UserInterface.init. Game is "$parent"';

		this._objectsOnUi = new Array();
		this._uiSprite = sprite;
		if( sprite == null )
			throw 'Error in UserInterface.init. Sprite is "$sprite"';

		this._inited = true;
	}

	public function postInit():Void
	{
		if( !this._inited )
			throw 'Error in userInterface.postInit. Init is FALSE';

		this._postInited = true;
	}

	public function addUiObject( object:Dynamic ):Void
	{
		var name:String = object.get( "name" );
		var sprite:Sprite = object.get( "sprite" );
		var check:Int = this._checkObjectForExist( object );
		if( check != null )
			throw 'Error in UserInterface.addUiObject. Object with name: "$name" already exits.';

		var alwaysActive:Bool = object.get( "alwaysActive" );
		if( !alwaysActive )
			sprite.visible = false;
		
		this._objectsOnUi.push( object );
		this._uiSprite.addChild( sprite );
	}

	public function removeUiObject( object:Dynamic ):Array<Dynamic>
	{
		var name:String = object.get( "name" );
		var sprite:Sprite = object.get( "sprite" );
		var check:Int = this._checkObjectForExist( object );
		if( check == null )
			return [ null, 'Error in UserInterface.addUiObject. Object with name: "$name" not found.' ];

		this._objectsOnUi.splice( check, 1 );
		this._uiSprite.removeChild( sprite );
		return [ object, null ];	
	}

	public function showUiObject( object:Dynamic ):Void
	{
		var name:String = object.get( "name" );
		var check:Int = this._checkObjectForExist( object );
		if( check == null )
			throw 'Error in UserInterface.showUiObject. Object with name: "$name" does not exist.';	

		this._objectsOnUi[ check ].get( "sprite" ).visible = true;
		object.changeActiveStatus();
	}

	public function hideUiObject( object:Dynamic ):Void
	{
		var name:String = object.get( "name" );
		var check:Int = this._checkObjectForExist( object );
		if( check == null )
			throw 'Error in UserInterface.hideUiObject. Object with name: "$name" does not exist.';	

		this._objectsOnUi[ check ].get( "sprite" ).visible = false;
		object.changeActiveStatus();
	}

	public function getUiSprite():Sprite
	{
		return this._uiSprite;
	}

	public function getUiObjects():Array<Dynamic>
	{
		return this._objectsOnUi;
	}

	//PRIVATE

	private function _checkObjectForExist( object:Dynamic ):Int
	{
		var id:Int = object.get( "id" );
		for( i in 0...this._objectsOnUi.length )
		{
			if( this._objectsOnUi[ i ].get( "id" ) == id )
				return i;
		}
		return null;
	}
}