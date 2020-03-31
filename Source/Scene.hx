package;

import openfl.display.Sprite;
import Building;

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
	private var _sceneForFastSwitch:SceneID;
	private var _isDrawed:Bool;

	private var _graphics:GraphicsSystem;
	private var _sprite:Sprite;

	private var _building:Array<Building>;
	private var _hero:Array<Hero>;


	public inline function new( config:SceneConfig ):Void
	{
		this._type = "scene";
		this._id = config.ID;
		this._name = config.Name;
		this._deployId = config.DeployID;
		this._sprite = config.GraphicsSprite;
		this._graphics = new GraphicsSystem({ Parent:this, GraphicsSprite:this._sprite });
	}

	public function init( error:String ):Void
	{
		var err:String = 'Name "$_name" id "$_id" deploy id "$_deployId"';
		this._isPrepared = "unprepared"; // По умолчанию, сцена не готова.
		this._sceneForFastSwitch = null;
		this._isDrawed = false;
		this._building = new Array<Building>();
		this._hero = new Array<Hero>();

		if( this._name == null || this._name == "" )
			throw '$error. Wrong name. $err';

		if( this._id == null )
			throw '$error Wrong ID. $err';

		if( this._deployId == null  )
			throw '$error Wrong Deploy ID. $err';

		this._graphics.init( (error + err) );
	}

	public function postInit():Void
	{

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
			case "isDrawed": return this._isDrawed;
			case "sceneForFastSwitch": return this._sceneForFastSwitch;
			default: throw 'Error in Scene.get. No getter for "$value"';
		}
	}

	public function setSceneForFastSwitch( id:SceneID ):Void
	{
		this._sceneForFastSwitch = id;
	}

	public function setDrawed( bool:Bool ):Void
	{
		if( this._isDrawed == bool )
			throw 'Error in Scene.setDrawed. Can not change is drawed to "$bool"';

		this._isDrawed = bool;
	}

	public function getChilds( type:String ):Dynamic
	{
		switch( type )
		{
			case "hero": return this._hero;
			case "building": return this._building;
			default: throw "Error in Scene.getEntites, can't get array with type: " + type + "." ;
		}
	}

	public function addChild( object:Dynamic ):Void
	{
		var type:String = object.get( "type" );
		var name:String = object.get( "name" );

		var check:Int = this._checkChildForExist( object );
		if( check != null ) // проверяем на наличие объекта на сцене.
			throw 'Error in Scene.addChild. Found dublicate object type: "$type" and name "$name"';

		switch( type )
		{
			case "building": this._building.push( object );
			case "hero": this._hero.push( object );
			default: throw 'Error in Scene.addChild. Can not add child type: "$type" and name "$name"';
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
			case "hero": this._hero.splice( check, 1 );
			default: return [ null, 'Error in Scene.removeChild. No type found for type: "$type"' ];
		}

		return [ object, null ];
	}

	public function getBuildingByDeployId( id:Int ):Building
	{
		var deployId:BuildingDeployID = BuildingDeployID( id );
		var check:Int = this._findBuilding( deployId );
		if( check == null )
			throw 'Error in Scene.getBuildingByDeployId. Can not find building with deploy id $id';

		return this._building[ check ];
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
			case "hero": container = this._hero;
			default: return null;
		}

		for( i in 0...container.length )
		{
			if( haxe.EnumTools.EnumValueTools.equals( object.get( "id" ), container[ i ].get( "id" )))
				return i;
		}

		return null;
	}

	private function _findBuilding( deployId:BuildingDeployID ):Int
	{
		for( i in 0...this._building.length )
		{
			if(	haxe.EnumTools.EnumValueTools.equals( this._building[ i ].get( "deployId" ), deployId ))
				return i;
		}

		return null;
	}

}
