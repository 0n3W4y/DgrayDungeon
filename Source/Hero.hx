package;

enum HeroID
{
	HeroID( _:Int );
}

enum HeroDeployID
{
	HeroDeployID( _:Int );
}


class Hero
{
	private var _inited:Bool = false;
	private var _postInited:Bool = false;

	private var _id:HeroID;
	private var _deployId:HeroDeployID;
	private var _name:String;
	private var _type:String;

	private var _armorSlot:Item;
	private var _weaponSlot:Item;
	private var _acessory1Slot:Item;
	private var _acessory2Slot:Item;
	
	public function new():Void
	{
		this._type = "hero";
		this._id = null;
		this._deployId = null;
		this._name = null;
	}

	public function init():String
	{	
		
		if( this._id == null )
			throw 'Error in Hero.init. Name "$_name", id "$_id", deploy id "$_deployId"';

		
		if( this._deployId == null )
			throw 'Error in Hero.init. Name "$_name", id "$_id", deploy id "$_deployId"';

		
		if( this._name == null )
			throw 'Error in Hero.init. Name "$_name", id "$_id", deploy id "$_deployId"';

		return null;
	}

	public function postInit():String
	{
		return null;
	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "id": return this._id;
			case "deployId": return this._deployId;
			case "name": return this._name;
			case "type": return this._type;
			default: throw 'Error in Hero.get. Can not get $value';
		}
	}

	public function addItemInSlot( item:Item, slot:String ):Void
	{
		switch( slot )
		{
			case "armor":
			{
				if( this._armorSlot != null )
					throw 'Error in Error in Hero.addItemToSlot. In "$slot" already have an item';

				this._armorSlot = item;
			}
			case "weapon":
			{
				if( this._weaponSlot != null )
					throw 'Error in Error in Hero.addItemToSlot. In "$slot" already have an item';
				this._addItemToWeaponSlot( item );
			}
			case "acessory1":
			{
				if( this._acessory1Slot != null )
					throw 'Error in Error in Hero.addItemToSlot. In "$slot" already have an item';
				this._addItemToAcessory1Slot( item );
			}
			case "acessory2":
			{
				if( this._acessory2Slot != null )
					throw 'Error in Error in Hero.addItemToSlot. In "$slot" already have an item';
				this._addItemToAcessory2Slot( item );
			}
			default: throw 'Error in Hero.addItemToSlot. No slot found for "$slot"';
		}
	}

	public function removeItemFromSlot( slot:String ):Item
	{
		switch( slot )
		{
			case "armor": return this._removeItemToArmorSlot();
			case "weapon": return this._removeItemToWeaponSlot();
			case "acessory1": return this._removeItemToAcessory1Slot();
			case "acessory2": return this._removeItemToAcessory2Slot();
			default: throw 'Error in Hero.removeItemFromSlot. No slot found for "$slot"';
		}
	}

	public function getItemFromSlot( slot:String ):Item
	{
		switch( slot )
		{
			case "armor": return this._armorSlot;
			case "weapon": return this._weaponSlot;
			case "acessory1": return this._acessory1Slot;
			case "acessory2": return this._acessory2Slot;
			default: throw 'Error in Hero.getItemFromSlot. No slot found for "$slot"';
		}
	}


	//PRIVATE


}