package;

import openfl.display.Sprite;

class UserInterface
{
	private var _parent:Game;
	private var _objectsOnUi:Array<Dynamic>; //store all sprites / bitmaps for fast remove;
	private var _uiSprite:Sprite;

	public function new( parent:Game, sprite:Sprite ):Void
	{
		this._parent = parent;
		this._uiSprite = sprite;
		this._objectsOnUi = new Array();
	}

	public function init():String
	{
		if( this._parent == null )
			return 'Error in UserInterface.init. Game is "$this._parent"';

		if( this._uiSprite == null )
			return 'Error in UserInterface.init. Sprite is "$this._uiSprite"';

		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function addUiObject( object:Dynamic, sceneId:Int ):Void
	{
		var name:String = object.get( "name" );
		var sprite:Sprite = object.get( "sprite" );
		var eventHandler:EventHandler = this._parent.getSystem( "event" );
		var check:Int = this._checkObjectForExist( object );
		if( check != null )
			throw 'Error in UserInterface.addUiObject. Object with name: "$name" already exits.';

		var alwaysActive:Bool = object.get( "alwaysActive" );
		if( !alwaysActive )
			sprite.visible = false;

		if( object.get( "type" ) == "window" )
		{
			var windowChilds:Array<Button> = object.get( "childs" );
			for( j in 0...windowChilds.length )
			{
				var button:Button = windowChilds[ j ];
				var buttonDeployId:Int = button.get( "deployId" );
				if( buttonDeployId == 4011 )
				{
					var saveGame:Dynamic = this._parent.getLastSave();
					if( saveGame == null )
						continue;
				}
				eventHandler.addEvents( windowChilds[ j ], sceneId );
			}
		}

		this._objectsOnUi.push( object );
		this._uiSprite.addChild( sprite );
	}

	public function removeUiObject( object:Dynamic, sceneId:Int ):Array<Dynamic>
	{
		var name:String = object.get( "name" );
		var sprite:Sprite = object.get( "sprite" );
		var eventHandler:EventHandler = this._parent.getSystem( "event" );
		var check:Int = this._checkObjectForExist( object );
		if( check == null )
			return [ null, 'Error in UserInterface.addUiObject. Object with name: "$name" not found.' ];

		if( object.get( "type" ) == "window" )
		{
			var windowChilds:Array<Button> = object.get( "childs" );
			for( j in 0...windowChilds.length )
			{
				var button:Button = windowChilds[ j ];
				eventHandler.removeEvents( windowChilds[ j ], sceneId );
			}
		}
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

	public function hide():Void
	{
		this._uiSprite.visible = false;
	}

	public function show():Void
	{
		this._uiSprite.visible = true;
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