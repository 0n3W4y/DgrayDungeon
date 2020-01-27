package;

class Building
{
	private var _id:Int;
	private var _name:String;
	private var _deployId:Int;
	private var _type:String;

	private var _graphics:GraphicsSystem;

	private var _upgradeLevel:Int; // текущий уровень здания
	private var _nextUpgradeId:Int; // deployId этого здания, но уже с апгерйдом.
	private var _canUpgradeLevel:Bool; // можно ли улучшить здание.
	private var _upgradePriceMoney:Int; // количество моент необходимое для апгрейда здания.

	private var _heroContainer:Array<Hero>;
	private var _containerSlots:Int;
	private var _containerSlotsMax:Int;

	public function new( config:Dynamic ):Void
	{
		this._id = config.id;
		this._name = config.name;
		this._deployId = config.deployId;
		this._type = "building";
		this._upgradeLevel = config.upgradeLevel;
		this._nextUpgradeId = config.nextUpgradeId;
		this._canUpgradeLevel = config.canUpgradeLevel;
		this._upgradePriceMoney = config.upgradePriceMoney;
		this._containerSlots = 0;
		this._containerSlotsMax = config.containerSlotsMax;
		this._heroContainer = new Array<Hero>();
		this._graphics = new GraphicsSystem( this, config.sprite );
	}

	public function init():String
	{
		if( this._name == null )
			throw 'Error in Building.init. Name is "$._name"';
		
		if( this._id == null )
			throw 'Error in Building.init. Name is "$_name" id is:"$_id"';
		
		if( this._deployId == null )
			throw 'Error in Building.init. Name is "$_name" id is:"$_id" deploy id is:"$_deployId"';

		if( this._upgradeLevel == null || this._upgradeLevel < 1 )
			throw 'Error in Building.init. Upgrade level is not valid: "$_upgradeLevel", "$_deployId"';

		if( this._canUpgradeLevel == null )
			throw 'Error in Building.init. Can Upgrade value is not valis: "$_canUpgradeLevel", "$_deployId"';

		if( !this._canUpgradeLevel && this._nextUpgradeId == null )
			throw 'Error in Building.init. Next upgrade deploy Id is not valid: "$_nextUpgradeId", "$_deployId"';

		if( this._containerSlotsMax == null )
			throw 'Error in Building.init. Container slots maximum value is not valid: "_containerSlotsMax", "$_deployId"';
		
		var err:String = this._graphics.init();
		if( err != null )
			return 'Error in Building.init. $err; "$_deployId"';

		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function checkForFreeSlotsHeroContainer():Bool
	{
		if( this._containerSlotsMax > this._containerSlots )
			return true;

		return false;
	}

	public function addChild( hero:Hero ):Void
	{
		if( !this.checkForFreeSlotsHeroContainer() ) //защита от "дурака";
			return;

		var name:String = hero.get( "name" );
		var check:Int = this._checkHero( hero );
		if( check != null )
			throw 'Error in Building.addHero. Find duplicate hero with name: "$name"';

		this._heroContainer.push( hero );
		this._containerSlots++;
	}

	public function removeChild( hero:Hero ):Array<Dynamic>
	{
		var name:String = hero.get( "name" );
		var check:Int = this._checkHero( hero );
		if( check == null )
			throw 'Error in Building.removeHero. Hero with name: "$name" does not exist';

		this._heroContainer.splice( check, 1 );
		this._containerSlots--;
		return [ hero, null ];
	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "id": return this._id;
			case "deployId": return this._deployId;
			case "name": return this._name;
			case "type": return this._type;
			case "graphics": return this._graphics;
			case "sprite": return this._graphics.getSprite();
			case "upgradeLevel": return this._upgradeLevel;
			case "nextUpgradeId": return this._nextUpgradeId;
			case "canUpgradeLevel": return this._canUpgradeLevel;
			case "childs": return this._heroContainer;
			case "maxSlots": return this._containerSlotsMax;
			default: throw 'Error in Building.get. Can not get "$value"';
		}
	}

	//PRIVATE

	private function _checkHero( hero:Hero ):Int
	{
		var id:Int = hero.get( "id" );
		for( i in 0...this._heroContainer.length )
		{
			if( this._heroContainer[ i ].get( "id" ) == id )
				return i;
		}
		return null;
	}
}