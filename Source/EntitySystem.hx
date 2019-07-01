package;

class EntitySystem
{
	private var _parent:Game;
	private var _nextId:Int = 0;
	private var _config:Dynamic;


	private function _createId():String
	{
		var id = "" + this._nextId;
		this._nextId++;
		return id ;
	}

	private function _createUiType( type:String, name:String, id:String, params:Dynamic ):Entity
	{
		var uiObject = new Entity( this, id, type, name );
		var config:Dynamic = this._config.window;
		if( type == "button" )
			config = this._config.button;

		var uiObjectConfig:Dynamic = null;
		for( obj in Reflect.fields( config ) )
		{
			if( obj == name )
			{
				uiObjectConfig = Reflect.getProperty( config, obj );
				break;
			}
		}

		for( key in Reflect.fields( uiObjectConfig ) )
		{
			var value = Reflect.getProperty( uiObjectConfig, key );
			var component = this.createComponent( key, value );
			this.addComponentTo( component, uiObject );
		}
		return uiObject;
	}

	private function _createBuilding( type:String, name:String, id:String, params:Dynamic ):Entity
	{
		var building = new Entity( this, id, type, name );
		var config:Dynamic = this._config.building;
		var buildingConfig:Dynamic = null;
		for( obj in Reflect.fields( config ) )
		{
			if( obj == name )
			{
				buildingConfig = Reflect.getProperty( config, obj );
				break;
			}
		}

		for( key in Reflect.fields( buildingConfig ) )
		{
			var value = Reflect.getProperty( buildingConfig, key );
			var component = this.createComponent( key, value );
			this.addComponentTo( component, building );
		}
		return building;
	}

	private function _createHero( type:String, name:String, id:String, params:Dynamic ):Entity
	{
		var config:Dynamic = this._config.entity.heroes;
		var traitConfig:Dynamic = this._config.trait;
		var skillConfig:Dynamic = this._config.skill;
		var heroType = params.type; // "common", "uncommon", "rare", "legendary"

		var heroConfig:Dynamic = null;
		var heroTypeConfig:Dynamic = null;
		var skill:Dynamic = null;

		for( key in Reflect.fields( config ) )
		{
			if( key == name )
			{
				heroConfig = Reflect.getProperty( config, key );
			}
		}

		for( obj in Reflect.fields( skillConfig ) )
		{
			if( obj == name )
			{
				skill = Reflect.getProperty( skillConfig, obj );
				break;
			}
		}






		return null;
	}

	public function new( parent:Game, params:Dynamic ):Void
	{
		this._parent = parent;
		this._config = params;
	}

	public function createEntity( type:String, name:String, params:Dynamic ):Entity
	{
		var id = this._createId();
		switch( type )
		{
			case "window", "button" : return this._createUiType( type, name, id, params );
			case "building" : return this._createBuilding( type, name, id, params );
			case "hero": return this._createHero( type, name, id, params );
			default: trace( "Error in EntitySystem.createEntity, can't find entity with type: " + type + "." );
		};
		return null;
	}

	public function addComponentTo( component:Component, entity:Entity ):Void
	{
		entity.addComponent( component );
	}

	public function createComponent( componentName:String, params:Dynamic ):Component
	{
		var id = this._createId();
		var component:Component = null;
		switch( componentName )
		{
			case "graphics": component = new Graphics( null, id, params );
			case "ui": component = new UI( null, id, params );
			case "name": component = new Name( null, id, params );
			case "inventory": component = new Inventory( null, id, params );
			case "skills": component = new Skills( null, id, params );
			case "stats": component = new Stats( null, id, params );
			case "traits": component = new Traits( null, id, params );
			default: trace( "Error in EntitySystem.createComponent, component with name: '" + componentName + "' does not exist." );
		}
		return component;
	}

	public function addEntityToScene( entity:Entity, scene:Scene ):Void
	{
		var type = entity.get( "type" );
		var container = null;
		switch( type )
		{
			case "window": scene.getEntities( "ui" ).windows.push( entity );
			case "button": scene.getEntities( "ui" ).buttons.push( entity );
			case "building": container = scene.getEntities( "object" ).buildings.push( entity );
			default: trace( "Error in Scene.addEntity, can't add entity with name: " + entity.get( "name" ) + ", and type: " + type + "." );
		}
	}

	public function createEntitiesForScene( scene:Scene, type:String, list:Array<String> )
	{
		var paramsContainer = Reflect.getProperty( this._config, type );
		if(  paramsContainer == null )
			trace( "Error in EntitySystem.createEntitiesForScene, can't find type: " + type + " into config container!" );
		for( i in 0...list.length )
		{	
			var object = this.createEntity( type, list[ i ], null );
			this.addEntityToScene( object, scene );
		}
	}
}