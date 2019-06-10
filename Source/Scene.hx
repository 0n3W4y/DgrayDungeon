package;

import openfl.display.Sprite;
import openfl.display.Bitmap;

class Scene extends Sprite
{
	private var _parent:SceneSystem;
	private var _id:String;
	private var _name:String;

	private var _aliveEntities:Dynamic;
	private var _objectEntities:Dynamic;
	private var _uiEntities:Dynamic;

	private var _backgroundImageURL:String;
	private var _graphicsInstance:Bitmap;

	public function new( parent:SceneSystem, id:String, name:String ):Void
	{
		super();
		this._parent = parent;
		this._id = id;
		this._name = name;

		this._aliveEntities = 
		{
			"playerTeam": new Array<Entity>(),
			"enemyTeam": new Array<Entity>()
		};
		this._objectEntities = 
		{
			"buildings": new Array<Entity>(),
			"treasures": new Array<Entity>()
		};
		this._uiEntities = 
		{
			"windows": new Array<Entity>(),
			"buttons": new Array<Entity>()
		};
	}

	public function update( time:Float ):Void
	{
		trace( "update scene id: " + this._id + ", delta: " + time + "." );
	}

	public function addEntity( entity:Entity ):Void
	{
		var type = entity.get( "type" );
		switch( type )
		{
			case "window": this._uiEntities.windows.push( entity );
			case "button": this._uiEntities.buttons.push( entity );
			case "building": this._objectEntities.buildings.push( entity );
			default: trace( "Error in Scene.addEntity, can't add entity with id: " + entity.get( "id" ) + ", and type: " + type + "." );
		}
	}

	public function draw():Void //draw all scene
	{
		this._parent.getParent().getSystem( "graphics" ).drawScene( this );
	}

	public function unDraw():Void
	{
		this._parent.getParent().getSystem( "graphics" ).undrawScene( this );
	}

	public function drawUi( uiName:String ):Void
	{
		this._parent.getParent().getSystem( "graphics" ).drawSceneUi( this, uiName );
	}

	public function undrawUi( uiName:String ):Void
	{
		this._parent.getParent().getSystem( "graphics" ).undrawSceneUi( this, uiName );
	}

	public function show():Void
	{
		this._parent.getParent().getSystem( "graphics" ).showScene( this );
	}

	public function hide():Void
	{
		this._parent.getParent().getSystem( "graphics" ).hideScene( this );
	}

	public function getId():String
	{
		return this._id;
	}

	public function getParent():SceneSystem
	{
		return this._parent;
	}

	public function getName():String
	{
		return this._name;
	}

	public function getBackgroundImageURL():String
	{
		return this._backgroundImageURL;
	}

	public function setBackgroundImageURL( url:String ):Void
	{
		this._backgroundImageURL = url;
	}

	public function setGraphicsInstance( instance:Bitmap ):Void
	{
		this._graphicsInstance = instance;
	}

	public function getGraphicsInstance():Bitmap
	{
		return this._graphicsInstance;
	}

	public function getUiEntities():Dynamic
	{
		return this._uiEntities;
	}
}