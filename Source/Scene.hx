package;

import openfl.display.Sprite;
import Window;

enum SceneID
{
	SceneID( _:Int );
}

enum SceneDeployID
{
	SceneDeployID( _:Int );
}

typedef SceneConfig =
{
	var ID:SceneID;
	var DeployID:SceneDeployID;
	var Name:String;
	var GraphicsSprite:Sprite;
}

class Scene
{
	private var _id:SceneID;
	private var _deployId:SceneDeployID;
	private var _type:String;
	private var _name:String;

	private var _isPrepared:String;

	private var _graphics:GraphicsSystem;
	private var _sprite:Sprite;

	private var _building:Array<Building>;
	

	public inline function new( config:SceneConfig ):Void
	{
		this._type = "scene";
		this._id = config.ID;
		this._name = config.Name;
		this._deployId = config.DeployID;
		this._sprite = config.GraphicsSprite;
		this._graphics = new GraphicsSystem();
	}

	public function init():String
	{	
		if( this._name == null || this._name == "" )
			return 'Error in Scene.init. Wrong name. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';

		if( this._id == null )
			return 'Error in Scene.init. Wrong ID. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';
		
		if( this._deployId == null  )
			return 'Error in Scene.init. Wrong Deploy ID. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';
		
		var err:String = this._graphics.init({ Parent:this, GraphicsSprite:this._sprite });
		if( err != null )
			return 'Error in Scene.init. $err. Name is "$_name" id is:"$_id" deploy id is:"$_deployId"';

		this._isPrepared = "unprepared"; // По умолчанию, сцена не готова.
		this._building = new Array<Building>();

		return null;
	}

	public function postInit():String
	{
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
			case "sprite": return this._sprite;
			case "prepared": return this._isPrepared;
			default: { throw( 'Error in Scene.get. No getter for "$value"' ); return null; }
		}
	}

	public function getChilds( type:String ):Dynamic
	{
		switch( type )
		{
			case "alive": return this._aliveEntities;
			case "hero": return this._aliveEntities.hero;
			case "object": return this._objectEntities;
			case "building": return this._objectEntities.building;
			default: throw "Error in Scene.getEntites, can't get array with type: " + type + "." ;
		}
	}

	public function addChild( object:Dynamic ):Void
	{
		var type:String = object.get( "type" );
		var name:String = object.get( "name" );

		var check:Int = this._checkChildForExist( object );
		if( check != null ) // проверяем на наличие объекта на сцене.
			throw 'Error in Scene.addChild. Found dublicate object with type: "$type" and name "$name"';

		switch( type )
		{
			case "building": container = this._building.push( object );
			default: throw 'Error in Scene.addChild. Can not add child with type: "$type" and name "$name"';
		}
	}

	public function removeChild( object:Dynamic ):Array<Dynamic>
	{
		var type:String = object.get( "type" );
		var name:String = object.get( "name" );

		var check:Int = this._checkChildForExist( object );
		if( check == null )
			return [ null, 'Error in Scene.removeChild. Scene does not have object with type: "$type" and name: "$name"' ];	

		switch( type )
		{
			case "building": this._building.splice( check, 1 );
			default: return [ null, 'Error in Scene.removeChild. No type found for type: "$type"' ];
		}

		return [ object, null ];
	}

	public function changePrepareStatus( value:String ):Void
	{
		if( value != "unprepared" && value != "prepared" )
			throw 'Error in Scene.changePrepareSatatus. Value is not valid: "$value"';

		if( this._isPrepared == value )
			throw 'Error in Scene.changePrepareStatus. Prepare status already "$value"';

		this._isPrepared = value;
	}

	//PRIVATE

	private function _checkChildForExist( object:Dynamic ):Int
	{
		var type:String = object.get( "type" );
		var name:String = object.get( "name" );
		var container:Array<Dynamic> = null;
		switch( type )
		{
			case "building": container = this._building;
			default: return null;
		}

		for( i in 0...container.length )
		{
			if( haxe.EnumTools.EnumValueTools.equals( object.get( "id" ), container[ i ].get( "id" )))
				return i;
		}

		return null;
	}

}