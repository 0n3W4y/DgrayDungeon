package;

class GeneratorSystem
{
	private var _preInited:Bool = false;
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _nextId:Int;
	private var _parent:Game;

	private var _itemDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _windowDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _buttonDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _heroDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _buildingDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _sceneDeploy:Map<Int, Dynamic>; // Map [id]: {};

	private var _heroNames:Dynamic; // { "m": [ "Alex"], "w": [ "Stella" ]};
	private var _heroSurnames:Dynamic; // [ "Goldrich", "Duckman" ];


	public function new()
	{

	}

	public function preInit():String
	{
		this._nextId = 0;
		this._preInited = true;
		return "ok";
	}

	public function init( parent:Game, sceneDeploy:Map<Int, Dynamic>, buildingDeploy:Map<Int, Dynamic>, windowDeploy:Map<Int, Dynamic>, buttonDeploy:Map<Int, Dynamic>, heroDeploy:Map<Int, Dynamic>, itemDeploy:Map<Int, Dynamic> ):String
	{
		if( !this._preInited )
			return "Error in GeneratorSystem.init. Pre init is FALSE";

		this._parent = parent;
		if( this._parent == null )
			return  "Error in GeneratorSystem.preInit. Parent is NULL";
		
		//TODO: == null && !this.sceneDeploy.exist( 1000 ); // проверка на наличие нужного DeployId в этом объекте

		this._sceneDeploy = sceneDeploy;
		if( this._sceneDeploy == null )
			return "Error in GeneratorSystem.init. SceneDeploy is NULL";
		
		this._buildingDeploy = buildingDeploy;
		if( this._sceneDeploy == null )
			return "Error in GeneratorSystem.init. BuildingDeploy is NULL";
		
		this._windowDeploy = windowDeploy;
		if( this._sceneDeploy == null )
			return "Error in GeneratorSystem.init. WindowDeploy is NULL";
		
		this._buttonDeploy = buttonDeploy;
		if( this._sceneDeploy == null )
			return "Error in GeneratorSystem.init. ButtonDeploy is NULL";
		
		this._heroDeploy = heroDeploy;
		if( this._sceneDeploy == null )
			return "Error in GeneratorSystem.init. HeroDeploy is NULL";
		
		this._itemDeploy = itemDeploy;
		if( this._sceneDeploy == null )
			return "Error in GeneratorSystem.init. ItemDeploy is NULL";
		
		this._inited = true;
		return "ok";
	}

	public function postInit():String
	{
		if( !this._inited )
			return "Error in GeneratorSystem.postInit. Init is FALSE";

		this._postInited = true;
		return "ok";
	}

	public function generateHero( deployId:Int ):Array<Dynamic>
	{
		return [];
	}

	public function generateBuilding( deployId:Int ):Array<Dynamic>
	{
		return [];
	}

	public function generateItem( deployId:Int ):Array<Dynamic>
	{
		return [];
	}

	public function generateScene( deployId:Int ):Array<Dynamic>
	{
		return [];
	}

	public function generateWindow( deployId:Int ):Array<Dynamic>
	{
		var config:Dynamic = this._windowDeploy.get( deployId );
		if( config == null )
			return [ null, "Error in GeneratorSystem.generateWindow. Deploy ID: '" + deployId + "' doesn't exist in WindowDeploy data" ];

		var window:Window = new Window();
		var id:Int = this._createId();
		var windowSprite:Sprite = new Sprite();
		var graphicsSprite:Sprite = new Sprite();
		var textSprite:Sprite = new Sprite();

		"name": "dungeonOne",
		"deployId": 3005,
		"x": 700.0,
		"y": 400.0,
		"imageURL": "assets/images/dungeonWindow.png",
		"imageX": 0.0,
		"imageY": 0.0,
		"firstText": "The real path of truth",
		"firstTextSize": 22,
		"firstTextColor": "0xffffff",
		"firstTextHeight": 20,
		"firstTextWidth": 250,
		"firstTextX": 15.0,
		"firstTextY": 10.0,
		"firstTextAlign": "center"
		return [];
	}

	public function generateButton( deployId:Int ):Array<Dynamic>
	{
		return [];
	}





	// PRIVATE

	private function _createId():Int
	{
		var result:Int = this._nextId;
		this._nextId++;
		return result;
	}

}