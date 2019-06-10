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
		var component = this.createComponent( "graphics", params.graphics );
		this.addComponentTo( component, uiObject );
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
			default: trace( "Error in EntitySystem.createComponent, component with name: '" + componentName + "' does not exist." );
		}
		return component;
	}
}