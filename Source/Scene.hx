package;

import openfl.display.Sprite;

class Scene
{
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _id:Int;
	private var _deployId:Int;
	private var _type:String;
	private var _name:String;
	private var _isDrawed:String;

	private var _aliveEntities:Dynamic;
	private var _objectEntities:Dynamic;
	private var _uiEntities:Dynamic;

	private var _graphics:GraphicsSystem;
	

	public function new():Void
	{

	}

	public function init( id:Int, name:String, deployId:Int, sprite:Sprite ):String
	{
		this._aliveEntities = 
		{
			"hero": new Array<Hero>(),
			"enemy": new Array()
		};
		this._objectEntities = 
		{
			"building": new Array<Building>(),
			"treasure": new Array()
		};
		this._uiEntities = 
		{
			"window": new Array<Window>()
		};

		this._type = "scene";

		this._id = id;
		if( !Std.is( id, Int ) )
			return 'Error in Scene.init. Id is "$id"';

		this._name = name;
		if( !Std.is( name, String ) )
			return 'Error in Scene.init. Name is "$name"';

		this._deployId = deployId;
		if( !Std.is( deployId, Int ) )
			return 'Error in Scene.init. deploy id is "$deployId"';

		this._graphics = new GraphicsSystem();
		var err:String = this._graphics.init( this, sprite );
		if( err != 'ok' )
			return 'Error in Scene.init. $err';

		this._isDrawed = "undrawed"; // Параметр для того, что бы понять, нужно ли отрисовывать сцену и все ее childs или она уже отрисована но скрыта.
		this._inited = true;
		return null;
	}

	public function postInit():String
	{
		if( !this._inited )
			return "Error in Scene.postInit. Init is FALSE";

		this._postInited= true;
		return null;
	}

	public function update( time:Float ):Void
	{
		// update all Entities;
	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "name": return this._name;
			case "id": return this._id;
			case "deployId": return this._deployId;
			case "type": return this._type;
			case "graphics": return this._graphics;
			case "sprite": return this._graphics.getSprite();
			case "drawed": return this._isDrawed;
			default: { trace( 'Error in Scene.get. No getter for "$value"' ); return null; }
		}
	}

	public function getChilds( type:String ):Dynamic
	{
		switch( type )
		{
			case "ui": return this._uiEntities;
			case "alive": return this._aliveEntities;
			case "object": return this._objectEntities;
			default: return "Error in Scene.getEntites, can't get array with type: " + type + "." ;
		}
	}

	public function addChild( object:Dynamic ):String
	{
		var container:Array<Dynamic> = null;
		var type:String = object.get( "type" );
		var name:String = object.get( "name" );

		var check:Int = this._checkChildForExist( object );
		if( check != null ) // проверяем на наличие объекта на сцене.
			return 'Error in Scene.addChild. Found dublicate object with type: "$type" and name "$name"';

		switch( type )
		{
			case "window": container = this._uiEntities.window;
			default: return 'Error in Scene.addChild. Can not add child with type: "$type" and name "$name"';
		}
		container.push( object );
		return null;
	}

	public function removeChild( object:Dynamic ):Array<Dynamic>
	{
		var container:Array<Dynamic> = null;
		var type:String = object.get( "type" );
		var name:String = object.get( "name" );

		switch( type )
		{
			case "window": container = this._objectEntities.window;
			default: { return [ null, 'Error in Scene.removeChild. No type found for type: "$type"' ]; }
		}

		var check:Int = this._checkChildForExist( object );
		if( check == null )
			return [ null, 'Error in Scene.removeChild. Scene does not have object with type: "$type" and name: "$name"' ];		

		container.splice( check, 1 );
		return [ object, null ];
	}

	public function changeDrawStatus( value:String ):Void
	{
		if( value != "drawed" || value != "undrawed" )
			throw 'Error in Scene.changeDrawSatatus. Value is not valid: "$value"';

		if( this._isDrawed == value )
			throw 'Error in Scene.changeDrawStatus. Is Drawed already "$value"';

		this._isDrawed = value;
	}

	//PRIVATE

	private function _checkChildForExist( object:Dynamic ):Int
	{
		var type:String = object.get( "type" );
		var name:String = object.get( "name" );
		var id:Int = object.get( "id" );
		var container:Array<Dynamic> = null;
		switch( type )
		{
			case "window": container = this._objectEntities.window;
			default: return null;
		}

		for( i in 0...container.length )
		{
			if( id == container[ i ].get( "id" ) )
				return i;
		}

		return null;
	}
}