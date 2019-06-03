package;

class EntitySystem
{
	private var _parent:Game;
	private var _nextId:Int = 0;
	private var _config:Dynamic;

	private var _aliveEntities:Dynamic;
	private var _objectEntities:Dynamic;


	private function _createId():Int
	{
		var id = this._nextId;
		this._nextId++;
		return id;
	}

	private function _createButton( params:Dynamic, addiction:String ):Entity
	{
		var newAddiction = addiction;
		var button = new Entity();
		return button;
	}

	private function _createWindow( type:String, name:String, id:Int, params:Dynamic ):Entity
	{
		var window = new Entity( this, id, type, name );
		var component = this.createComponent( "graphics", params.graphics );
		this.addComponentTo( component, window );

		for( filed in Reflect.fields( params ) )
		{
			
		};
		
		this._objectEntities.windows.push( window );
		return window;
	}

	public function new( parent:Game, params:Dynamic ):Void
	{
		this._parent = parent;
		this._config = params;
		this._aliveEntities = 
		{ 
			"playerTeam" : new Array(),
			"enemyTeam" : new Array(),
			"neutralTeam" : new Array()
		};

		this._objectEntities = 
		{
			"windows" : new Array()
		};
	}

	public function createEntity( type:String, name:String, params:Dynamic ):Entity
	{
		var id = this._createId();
		switch( type )
		{
			case "window" : return this._createWindow( type, name, id, params );
			default: trace( "Error in EntitySystem.createEntity, can't find entity with type: " + type + "." );
		};
		return null;
	}

	public function addComponentTo( component:Component, entity:Entity ):Void
	{
		entity.setComponent( component );
	}

	public function createComponent( componentName:String, params:Dynamic ):Component
	{
		var component:Component = null;
		if( params != null )
		{

		}
		else
		{

		};
		return component;
	}
}