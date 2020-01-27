package;

import openfl.display.Sprite;

class Scene
{
	private var _inited:Bool;
	private var _postInited:Bool;

	private var _id:Int;
	private var _deployId:Int;
	private var _type:String;
	private var _name:String;

	private var _isPrepared:String;

	private var _aliveEntities:Dynamic;
	private var _objectEntities:Dynamic;
	private var _uiEntities:Dynamic;

	private var _graphics:GraphicsSystem;
	

	public function new( config:Dynamic ):Void
	{
		this._type = "scene";
		this._id = config.id;
		this._name = config.name;
		this._deployId = config.deployId;
		this._graphics = new GraphicsSystem( this, config.sprite );
		this._isPrepared = "unprepared"; // Подготовлена сцена дял отображения или нет.
		this._inited = false;
		this._postInited = false;

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
	}

	public function init( ):String
	{	
		if( this._id == null )
			return 'Error in Scene.init. Id is "$this._id"';

		
		if( this._name == null )
			return 'Error in Scene.init. Name is "$this._name"';

		
		if( this._deployId == null )
			return 'Error in Scene.init. deploy id is "$this._deployId"';
		
		var err:String = this._graphics.init();
		if( err != null )
			return 'Error in Scene.init. $err';

		if( this._objectEntities == null || this._objectEntities.building == null || this._objectEntities.treasure == null )
			return 'Error in Scene.init. Object array in null, or subobject is null';

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
			case "prepared": return this._isPrepared;
			default: { throw( 'Error in Scene.get. No getter for "$value"' ); return null; }
		}
	}

	public function getChilds( type:String ):Dynamic
	{
		switch( type )
		{
			case "ui": return this._uiEntities;
			case "window": return this._uiEntities.window;
			case "alive": return this._aliveEntities;
			case "hero": return this._aliveEntities.hero;
			case "object": return this._objectEntities;
			case "building": return this._objectEntities.building;
			default: throw "Error in Scene.getEntites, can't get array with type: " + type + "." ;
		}
	}

	public function addChild( object:Dynamic ):Void
	{
		var container:Array<Dynamic> = null;
		var type:String = object.get( "type" );
		var name:String = object.get( "name" );

		var check:Int = this._checkChildForExist( object );
		if( check != null ) // проверяем на наличие объекта на сцене.
			throw 'Error in Scene.addChild. Found dublicate object with type: "$type" and name "$name"';

		switch( type )
		{
			case "window": container = this._uiEntities.window;
			case "building": container = this._objectEntities.building;
			default: throw 'Error in Scene.addChild. Can not add child with type: "$type" and name "$name"';
		}
		container.push( object );
	}

	public function removeChild( object:Dynamic ):Array<Dynamic>
	{
		var container:Array<Dynamic> = null;
		var type:String = object.get( "type" );
		var name:String = object.get( "name" );

		switch( type )
		{
			case "window": container = this._uiEntities.window;
			case "building": container = this._objectEntities.building;
			default: { return [ null, 'Error in Scene.removeChild. No type found for type: "$type"' ]; }
		}

		var check:Int = this._checkChildForExist( object );
		if( check == null )
			return [ null, 'Error in Scene.removeChild. Scene does not have object with type: "$type" and name: "$name"' ];		

		container.splice( check, 1 );
		return [ object, null ];
	}

	public function changePrepareStatus( value:String ):Void
	{
		if( value != "unprepared" && value != "prepared" )
			throw 'Error in Scene.changePrepareSatatus. Value is not valid: "$value"';

		if( this._isPrepared == value )
			throw 'Error in Scene.changePrepareStatus. Is drawed already "$value"';

		this._isPrepared = value;
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
			case "window": container = this._uiEntities.window;
			case "building": container = this._objectEntities.building;
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