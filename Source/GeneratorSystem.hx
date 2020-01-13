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

	public function preInit( parent:Game ):String
	{
		this._netxId = 0;
		this._parent = parent;
		if( this._parent == null )
			return  "Error in GeneratorSystem.preInit. Parent is NULL";

		this._preInited = true;
		return "ok";
	}

	public function init( sceneDeploy:Map<Int, Dynamic>, buildingDeploy:Map<Int, Dynamic>, windowDeploy:Map<Int, Dynamic>, buttonDeploy:Map<Int, Dynamic>, heroDeploy:Map<Int, Dynamic>, itemDeploy:Map<Int, Dynamic> ):String
	{
		if( !this._preInited )
			return "Error in GeneratorSystem.init. PreInit function failed!!!";

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

	}

	public function generateHero():Array<Dynamic>
	{

	}

	public function generateBuilding():Array<Dynamic>
	{

	}

	public function generateItem():Array<Dynamic>
	{

	}

	public function generateScene():Array<Dynamic>
	{

	}

	public function generateWindow( name:String, deployId:Int ):Array<Dynamic>
	{

	}

	public function generateButton():Array<Dynamic>
	{

	}

	private function createId():Int
	{
		var result:Int = this._nextId;
		this._nextId++;
		return result;
	}

}