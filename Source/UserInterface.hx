package;

import openfl.display.Sprite;

class UserInterface
{
	private var _parent:Game;
	private var _objectsOnUi:Array<Dynamic>; //store all sprites / bitmaps for fast remove;
	private var _uiSprite:Sprite;

	public function new( parent:Game ):Void
	{
		this._parent = parent;
		this._objectsOnUi = new Array();
		this._uiSprite = new Sprite();
		//this.alpha = 0.0;
	}

	public function addUiObject( object:Dynamic ):Void //{ "name": name, "window": Sprite }
	{
		//{ "name": name, "window": spriteWindow };
		for( i in 0...this._objectsOnUi.length )
		{
			var oldObject:Dynamic = this._objectsOnUi[ i ];
			if( oldObject.name == object.name )
			{	
				trace( "Object with name: '" + object.name + "' already in UI" );
				return;
			}
		}
		this._objectsOnUi.push( object );
		this._uiSprite.addChild( object.window.getComponent( "graphics" ).getGraphicsInstance() );
	}

	public function removeUiObject( object:String ):Void
	{
		for( i in 0...this._objectsOnUi.length )
		{
			if( object == this._objectsOnUi[ i ].name )
			{
				this._uiSprite.removeChild( this._objectsOnUi[ i ].window.getComponent( "graphics" ).getGraphicsInstance() );
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

	public function getUiSprite():Sprite
	{
		return this._uiSprite;
	}

	public function getWindow( window:String ):Entity
	{
		for( i in 0...this._objectsOnUi.length )
		{
			var obj:Dynamic = this._objectsOnUi[ i ];
			if( obj.name == window )
				return obj.window;
		}
		trace( "Error in UserInterface.getWindow, no window with name " + window );
		return null;
	}
}