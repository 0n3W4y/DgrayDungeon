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

	public function init( parent:Game, sprite:Sprite ):String
	{
		this._parent = parent;
		if( parent == null )
			return 'Error in UserInterface.init. Game is "$parent"';

		this._objectsOnUi = new Array();
		this._uiSprite = sprite;
		if( sprite == null )
			return 'Error in UserInterface.init. Sprite is "$sprite"';

		this._inited = true;
		return null;
	}

	public function postInit():String
	{
		if( !this._inited )
			return 'Error in userInterface.postInit. Init is FALSE';

		this._postInited = true;
		return null;
	}

	public function addUiObject( object:Dynamic ):String
	{
		var name:String = object.get( "name" );
		var sprite:Sprite = object.get( "sprite" );
		var check:Int = this._checkObjectForExist( object );
		if( check != null )
			return 'Error in UserInterface.addUiObject. Object with name: "$name" already exits.';

		this._objectsOnUi.push( object );
		this._uiSprite.addChild( sprite );
	}

	public function removeUiObject( object:String ):Array<Dynamic>
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
		var id:Int = object.get( "id" );
		for( i in 0...this._objectsOnUi.length )
		{
			if( id == this._objectsOnUi[ i ].get( "id" ) )
				this._objectsOnUi[ i ].get( "sprite" ).visible = true;
		}
	}

	public function hideUiObject( object:Dynamic ):Void
	{
		var id:Int = object.get( "id" );
		for( i in 0...this._objectsOnUi.length )
		{
			if( id == this._objectsOnUi[ i ].get( "id" ) )
				this._objectsOnUi[ i ].get( "sprite" ).visible = false;
		}
	}

	public function getUiSprite():Sprite
	{
		return this._uiSprite;
	}

	public function getUiObjects():Array<Dynamic>
	{
		return this._objectsOnUi;
	}
}