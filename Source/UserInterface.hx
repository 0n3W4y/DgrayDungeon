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
		//[{"name": "Window1","window":{window:entity},"textWindow":[{"name":newText.name,"sprite":textSprite}],
		//"button":[{"name":"button1","sprite":button,"text":{"name":newText.name,"sprite":textSprite}]];
		//{ "name": name, "window": spriteWindow, "textWindow": windowTextArray, "button": buttonsArray }
		this._objectsOnUi.push( object );
		this.addChild( object.window );
	}

	public function removeUiObject( object:Entity ):Void
	{
		var name = object.get( "name" );
		for( i in 0...this._objectsOnUi.length )
		{
			if( name == this._objectsOnUi[ i ].name )
			{
				this.removeChild( this._objectsOnUi[ i ].window );
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
				object.window.visible = true;
		}
	}

	public function hideUiObject( name:String ):Void
	{
		for( i in 0...this._objectsOnUi.length )
		{
			var object = this._objectsOnUi[ i ];
			if( object.name == name )
				object.window.visible = false;
		}
	}
}