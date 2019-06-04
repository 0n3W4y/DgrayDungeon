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

	private function _createButton( type:String, name:String, id:String, params:Dynamic ):Entity
	{
		var button = new Entity( this, id, type, name );
		var component = this.createComponent( "graphics", params.graphics );
		this.addComponentTo( component, button );
		return button;
	}

	private function _createWindow( type:String, name:String, id:String, params:Dynamic ):Entity
	{
		var window = new Entity( this, id, type, name );
		var component = this.createComponent( "graphics", params.graphics );
		this.addComponentTo( component, window );
		return window;
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
			case "window" : return this._createWindow( type, name, id, params );
			case "button" : return this._createButton( type, name, id, params );
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