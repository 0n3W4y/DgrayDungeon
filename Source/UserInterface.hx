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
		//{ "name": name, "window": spriteWindow };
		this._objectsOnUi.push( object );
		this.addChild( object.window.getComponent( "graphics" ).getGraphicsInstance() );
	}

	public function removeUiObject( object:Entity ):Void
	{
		var name = object.get( "name" );
		for( i in 0...this._objectsOnUi.length )
		{
			if( name == this._objectsOnUi[ i ].name )
			{
				this.removeChild( this._objectsOnUi[ i ].window.getComponent( "graphics" ).getGraphicsInstance() );
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
			{
				var sprite:Sprite = object.window.getComponent( "graphics" ).getGraphicsInstance();
				sprite.visible = true;
			}
		}
	}

	public function hideUiObject( name:String ):Void
	{
		for( i in 0...this._objectsOnUi.length )
		{
			var object = this._objectsOnUi[ i ];
			if( object.name == name )
			{
				var sprite:Sprite = object.window.getComponent( "graphics" ).getGraphicsInstance();
				sprite.visible = false;
			}
		}
	}
}