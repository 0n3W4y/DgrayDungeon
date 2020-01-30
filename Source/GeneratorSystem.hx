package;

import Player;
import Window;
import Button;
import Hero;
import Building;
import Scene;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.text.TextFormatAlign;


class GeneratorSystem
{
	private var _nextId:Int;
	private var _parent:Game;

	private var _itemDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _windowDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _buttonDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _heroDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _buildingDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _sceneDeploy:Map<Int, Dynamic>; // Map [id]: {};
	private var _playerDeploy:Map<Int, Dynamic>;

	//private var _heroNames:Dynamic; // { "m": [ "Alex"], "w": [ "Stella" ]};
	//private var _heroSurnames:Dynamic; // [ "Goldrich", "Duckman" ];


	public inline function new( config:Dynamic ):Void
	{
		this._nextId = 0;
		this._parent = config.parent;
		this._sceneDeploy = config.sceneDeploy;
		this._buildingDeploy = config.buildingDeploy;
		this._windowDeploy = config.windowDeploy;
		this._buttonDeploy = config.buttonDeploy;
		this._heroDeploy = config.heroDeploy;
		this._itemDeploy = config.itemDeploy;
		this._playerDeploy = config.playerDeploy;
	}

	public function init():String
	{		
		if( this._parent == null )
			return  'Error in GeneratorSystem.init. Parent is:"$this._parent"';
		
		if( this._sceneDeploy == null || !this._sceneDeploy.exists( 1000 ) )
			return 'Error in GeneratorSystem.init. Scene deploy is not valid';
		
		
		if( this._buildingDeploy == null )
			return 'Error in GeneratorSystem.init. Building deploy is not valid';
		
		
		if( this._windowDeploy == null )
			return 'Error in GeneratorSystem.init. Window deploy is not valid';
		
		
		if( this._buttonDeploy == null )
			return 'Error in GeneratorSystem.init. Button deploy is not valid';
		
		
		if( this._heroDeploy == null )
			return 'Error in GeneratorSystem.init. Hero deploy is not valid';
		
		
		if( this._itemDeploy == null )
			return 'Error in GeneratorSystem.init. Item deploy is not valid';
		
		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function createBuilding( deployId:Int ):Array<Dynamic>
	{
		var config = this._buildingDeploy.get( deployId );
		if( config == null )
			return [ null, "Error in GeneratorSystem.createBuilding. Deploy ID: '" + deployId + "' doesn't exist in BuildingDeploy data" ];

		var id:ID = this._createId();
		var sprite:Sprite = new Sprite();
		var graphicsSprite:Sprite = this._createGraphicsSprite( config );
		sprite.addChild( graphicsSprite );
		var textSprite:Sprite = this._createTextSprite( config );
		sprite.addChild( textSprite );

		var buildingConfig:BuildingConfig =
		{
			ID: id,
			DeployID: DeployID( config.deployId ),
			Name: config.name,
			GraphicsSprite: sprite,
			UpgradeLevel: config.upgradeLevel,
			NextUpgradeId: config.nextUpgradeId,
			CanUpgradeLevel: config.canUpgradeLevel,
			UpgradePrice: { Amount: config.moneyAmount },
			HeroStorageSlotsMax: config.heroStorageSlotsMax

		};
		var building:Building = new Building( buildingConfig );
		var err:String = building.init();
		if( err !=null )
			return [ null, 'Error in GeneratorSystem.createBuilding. $err' ];

		
		return [ building, null ];
	}

	public function generateHeroesForBuildingRecruits( building ):Void
	{
		var slots:Int = building.get( "maxSlots" );
		var upgradeLevel:Int = building.get( "upgradeLevel" );
		var heroRares:Array<String>;
		switch( upgradeLevel )
		{
			case 1: heroRares = [ "uncommon" ];
			case 2: heroRares = [ "uncommon", "common"  ];
			case 3: heroRares = [ "uncommon", "common", "rare" ];
			case 4: heroRares = [ "uncommon", "common", "rare", "legendary" ];
			default: throw 'Error in GeneratorSystem.generateHeroesForBuildingRecruits. UpgradeLevel for building "Recruits" is wrong!';
		}
		for( i in 0...slots )
		{
			var index:Int = Math.floor( Math.random() * heroRares.length );
			var heroRarity:String = heroRares[ index ];
			var createHero:Array<Dynamic> = this.generateHero( "random", heroRarity );
			var err:String = createHero[ 1 ];
			var hero:Hero = createHero[ 0 ];
			if( err != null )
				throw 'Error in GeneratorSystem.generateHeroesForBuildingRecruits. $err';

			building.addChild( hero ); // Никакой проверки.
		}
	}

}