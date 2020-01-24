package;

class Player
{
	private var _id:Int;
	private var _name:String;
	private var _deployId:Int;
	private var _moneyAmount:Int;
	private var _maxHeroSlots:Int;
	private var _heroSlots:Int;

	private var _heroStorage:Array<Hero>;

	private var _inventory:InventorySystem;


	public function new( config:Dynamic ):Void
	{
		this._id = config.id;
		this._name = config.name;
		this._deployId = config.deployId;
		this._moneyAmount = config.money;
		this._maxHeroSlots = config.maxHeroSlots;
		this._heroSlots = 0;
		this._inventory = new InventorySystem( this );
		this._heroStorage = new Array<Hero>();
	}

	public function init():String
	{
		if( this._name == null )
			return 'Error in Player.init. Name is: "$this._name"';

		if( this._id == null )
			return 'Error in Player.init. Id in: "$this._id" name: "$this._name"';

		if( this._moneyAmount < 0 )
			return 'Error in Player.init. Money amoun is: "$this._moneyAmount" id in: "$this._id" name: "$this._name"';

		if( this._maxHeroSlots < 0 )
			return 'Error in Player.init. Maximum hero slots is: "$this._maxHeroSlots " id in: "$this._id" name: "$this._name"';

		var err:String = this._inventory.init();
		if( err != null )
			return 'Error in Player.init. Id in: "$this._id" name: "$this._name"; $err';

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

	public function addHeroToStorage( hero:Hero ):Void
	{
		if( !this.checkHeroStorageForFreeSlots() )
			return;
		var name:String = hero.get( "name" );
		var id:Int = hero.get( "id" );
		var check:Int = this._checkHeroInStorage( id );
		if( check != null )
			throw 'Error in Player.addHeroToStorage. Found duplicate hero with name:"$name" id:"$id"';

		this._heroStorage.push( hero );
		this._heroSlots++;
	}

	public function removeHeroFromStorage( hero:Hero ):Array<Dynamic>
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