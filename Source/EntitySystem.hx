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
		for( key in Reflect.fields( params ) )
		{
			var value = Reflect.getProperty( params, key );
			var component = this.createComponent( key, value );
			this.addComponentTo( component, uiObject );
		}
		return uiObject;
	}

	private function _createBuilding( type:String, name:String, id:String, params:Dynamic ):Entity
	{
		var building = new Entity( this, id, type, name );
		for( key in Reflect.fields( params ) )
		{
			var value = Reflect.getProperty( params, key );
			var component = this.createComponent( key, value );
			this.addComponentTo( component, building );
		}
		return building;
	}

	private function _createHero( type:String, name:String, id:String, params:Dynamic ):Entity
	{

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
			var params = Reflect.getProperty( paramsContainer, list[ i ] );
			if( params == null )
				trace( "Error in EntitySystem.createEntitiesForScene, can't find name: " + list[ i ] + " into config container with type: " + type + "." );
			var object = this.createEntity( type, list[ i ], params );
			this.addEntityToScene( object, scene );
		}
	}
}