package;

import openfl.display.Sprite;

class UserInterface extends Sprite
{
	private var _parent:Game;
	private var _objectsOnUi:Array<Dynamic>; //store all sprites / bitmaps for fast remove;

	public function new( parent:Game ):Void
	{
		super();
		this._parent = parent;
		this._objectsOnUi = new Array();
		//this.alpha = 0.0;
	}

	public function addUiObject( object:Dynamic ):Void //{ "name": name, "sprite": sprite }
	{
		this._objectsOnUi.push( object );
		this.addChild( object.sprite );
	}

	public function removeUiObject( object:Entity ):Void
	{
		var name = object.get( "name" );
		for( i in 0...this._objectsOnUi.length )
		{
			if( name == this._objectsOnUi[ i ].name )
			{
				this.removeChild( this._objectsOnUi[ i ].sprite );
				this._objectsOnUi.splice( i, 1 );
			}
		}
		
	}

	public function showUiObject( name:String ):Void
	{
		for( i in 0...this._objectsOnUi.length )
		{
			var object = this._objectsOnUi[ i ];
			if( object.name == name )
				object.sprite.visible = true;
		}
	}

	public function hideUiObject( name:String ):Void
	{
		for( i in 0...this._objectsOnUi.length )
		{
			var object = this._objectsOnUi[ i ];
			if( object.name == name )
				object.sprite.visible = false;
		}
	}
}