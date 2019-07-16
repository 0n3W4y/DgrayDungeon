package;

class Inventory extends Component
{
	private var _maxSlots:Int = 0;
	private var _currentSlots:Int = 0;
	private var _inventory:Array<Dynamic>;

	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "inventory" );
		this._inventory = new Array();
		this._maxSlots = params.maxSlots;
		this._currentSlots = params.currentSlots;
		for( key in Reflect.fields( params.inventory ) )
		{
			var value = Reflect.getProperty( params.inventory, key );
			if( params.needToFill )
			{
				var j = 0;
				for( i in 0...params.maxSlots )
				{
					value.name = "slot" + i;
					if( j < this._currentSlots )
					{
						value.isAvailable = true;
						j++;
					}
					else
						value.isAvailable = false;
					this._inventory.push( value );
				}
				break;
			}

			this._inventory.push( value );
		}		

	}

	public function changeAvailableSlot ( slot:String, value:Bool ):Void
	{
		if( this._currentSlots < this._maxSlots && value )
		{
			for( i in 0...this._inventory.length )
			{
				var slotName = this._inventory[ i ].name;
				if( slotName == slot )
				{
					this._inventory[ i ].isAvailable = true;
					this._currentSlots++;
					break;
				}
			}
		}
		else if( !value && this._currentSlots > 0 );
		{
			for( i in 0...this._inventory.length )
			{
				var slotName = this._inventory[ i ].name;
				if( slotName == slot )
				{
					this._inventory[ i ].isAvailable = false;
					this._currentSlots--;
					break;
				}
			}
		}
		
	}

	public function getInventory():Array<Dynamic>
	{
		return this._inventory;
	}

	public function setItemInSlot( item:Dynamic, slot:String ):Bool
	{
		// { "name": "slot1", type": "slot", "item": null, "restriction": "hero", "isAvailable": false, "isStorable": false, "maxSize": null, "currentSize": null }

		for( i in 0...this._inventory.length )
		{
			var slotName = this._inventory[ i ].name;
			if( slotName == slot )
			{
				if( this._inventory[ i ].item == null )
				{
					this._inventory[ i ].item = item;
					return true;
				}
			}
			else if( slot == null && this._inventory[ i ].item == null )
			{
				this._inventory[ i ].item = item;
				return true;
			}
		}
		return false;
		//TODO: Storable items in storable slot; this function must change 'isStorable' to true, do MaxSize and change current size;
	}

	public function removeItemFromSlot( slot:String ):Dynamic
	{
		var item:Dynamic = null;
		for( i in 0...this._inventory.length )
		{
			var slotName = this._inventory[ i ].name;
			if ( slotName == slot )
			{
				item = this._inventory[ i ].item;
				this._inventory.item = null;
				break;
			}
		}
		return item;
	}

	public function changePropSlotInventory( slot:String, prop:Dynamic ):Void
	{
		var newSlot:Dyanmic = null;
		for( i in 0...this._inventory.length )
		{
			if( this._inventory[ i ].name == slot )
				newSlot = this._inventory[ i ];
		}
		//DANGEROUS sensetive function;
		for( key in Reflect.fields( prop ) )
		{
			var value = Reflect.getProperty( prop, key );
			Reflect.setProperty( newSlot, key, value );
		}
	}

	public function getCurrentSlots():Int
	{
		return this._currentSlots;
	}

	public function setCurrentSlots( value:Int ):Void
	{
		this._currentSlots = value;
	}

	public function getMaxSlots():Int
	{
		return this._maxSlots;
	}

	public function setmaxSlots( value:Int ):Void
	{
		this._maxSlots = value;
	}
}