package;
enum PlayerDeployID
{
	PlayerDeployID( _:Int );
}

typedef PlayerConfig =
{
	var ID:Game.ID;
	var DeployID:PlayerDeployID;
	var Name:String;
	var ItemStorageSlotsMax:Int;
	var MoneyAmount:Money;
}

typedef Money = Int;

class Player
{
	private var _id:Game.ID;
	private var _name:String;
	private var _deployId:PlayerDeployID;
	private var _moneyAmount:GeneratorSystem.Money;
	private var _itemStorage:Array<Item>;
	private var _itemStorageSlotsMax:Int;
	private var _itemStorageSlots:Int;


	public inline function new( config:PlayerConfig ):Void
	{
		this._id = config.ID;
		this._name = config.Name;
		this._deployId = config.DeployID;
		this._moneyAmount = config.MoneyAmount;
		this._itemStorageSlotsMax = config.ItemStorageSlotsMax;
	}

	public function init():String
	{
		if( this._name == null || this._name == "" )
			return 'Error in Player.init. Wrong name. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';
		
		if( this._id == null )
			return 'Error in Player.init. Wrong ID. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';
		
		if( this._deployId == null )
			return 'Error in Player.init. Wrong Deploy ID. Name is:"$_name" id is:"$_id" deploy id is:"$_deployId"';

		if( this._moneyAmount == null )
			return 'Error in Player.init.Wrong money amount. Name: "$_name" id: "$_id"  deploy id: "$_deployId"';

		if( this._itemStorageSlotsMax < 0 )
			return 'Error in Player.init. Wrong Maximum hero slots. Name: "$_name" id: "$_id"  deploy id: "$_deployId"';

		this._itemStorageSlots = 0;
		this._heroStorage = new Array<Hero>();
		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function checkHeroStorageForFreeSlots():Bool
	{
		if( this._heroSlots < this._maxHeroSlots )
			return true;

		return false;
	}

	public function addItemToStorage( hero:Hero ):Void
	{
		var name:String = hero.get( "name" );
		var id:Int = hero.get( "id" );
		var check:Int = this._checkHeroInStorage( id );
		if( check != null )
			throw 'Error in Player.addHeroToStorage. Found duplicate hero with name:"$name" id:"$id"';

		this._heroStorage.push( hero );
		this._heroSlots++;
	}

	public function removeItemFromStorage( hero:Hero ):Array<Dynamic>
	{
		var name:String = hero.get( "name" );
		var id:Int = hero.get( "id" );
		var check:Int = this._checkHeroInStorage( id );
		if( check == null )
			return [ null, 'Error in Player.removeHeroToStorage. Hero with name:"$name" id:"$id" does not exist' ];

		this._heroStorage.splice( check, 1 );
		this._heroSlots--;
		return [ hero, null ];
	}

	public function getHeroById( id:Int ):Array<Dynamic>
	{
		var check:Int = this._checkHeroInStorage( id );
		if( check == null )
			return [ null, 'Error in Player.getHeroById. Hero with id:"$id" does not exist' ];

		return [ this._heroStorage[ check ], null ];
	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "" :return null;
			default: throw 'Error in Player.get. Not valid value: "$value"';
		}
	}



	//PRIVATE


	private function _checkHeroInStorage( id:Int ):Int
	{
		for( i in 0...this._heroStorage.length )
		{
			if( this._heroStorage[ i ].get( "id" ) == id )
				return i;
		}
		return null;
	}
}