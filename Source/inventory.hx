package;

class Inventory extends Component
{
	private var _maxSlots:Int = 0; //maximum number of slots;
	private var _currentSlots:Int = 0; // current number of slots we have;
	private var _inventory:Array<Dynamic>; 
	//{ "name": "slot1", type": "slot", "item": null, "restriction": "hero", "isAvailable": false }

	private function _compareItems( itemA:Dynamic, itemB:Dynamic ):Bool
	{
		return false;
	}
	public function new( parent:Entity, params:Dynamic ):Void
	{
		super( parent, "inventory" );
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
					var newValue:Dynamic = { "name": null, "type": null, "item": null, "restriction": null, "isAvailable": null };
					for( key in Reflect.fields( value ) )
					{
						var keyValue = Reflect.getProperty( value, key );
						Reflect.setProperty( newValue, key, keyValue );
					}
					newValue.name = "slot" + i;
					if( j < this._currentSlots )
					{
						newValue.isAvailable = true;
						j++;
					}
					else
						newValue.isAvailable = false;
					this._inventory.push( newValue );
				}
				break;
			}
			else
			{
				var newValue:Dynamic = { "name": null, "type": null, "item": null, "restriction": null, "isAvailable": null };
				for( key in Reflect.fields( value ) )
				{
					var keyValue = Reflect.getProperty( value, key );
					Reflect.setProperty( newValue, key, keyValue );
				}
				this._inventory.push( newValue );
			}			
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
		else if( !value && this._currentSlots > 0 )
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

	public function setItemInSlot( newItem:Dynamic, slot:String ):Dynamic
	{
		// { "name": "slot1", type": "slot", "item": null, "restriction": "hero", "isAvailable": false }
		if ( slot == null ) // do store item in free slot or add amout of item in slot;
		{
			var stored:Bool = false;
			var freeSlot:Int = -1; // default no free slots;
			//trace( newItem.get( "name" ) + "; worked in inventory with slot = " + slot );
			for( i in 0...this._inventory.length )
			{
				var newSlot:Dynamic = this._inventory[ i ];
				var slotRestriction:String = newSlot.restriction;
				var oldItem:Entity = this._inventory[ i ].item;
				//trace( newSlot );
				if( oldItem != null )
				{
					// chek for item in inventory which can be same with new item;
					//compare it and ckech if it strable; if it storable, just + amount of items;
					// if item amount max in slot - fill it to max, then change amount for newItem and drop window with return -1;
					var compareItems:Bool = this._compareItems( oldItem, newItem );
					if ( compareItems )
					{
						//chek if storeable;
						//do ++
						//check if max amount;
						// return -1 or 1;
						// stored == true;
					}

				}
				else
				{
					if( freeSlot == -1 && this._inventory[ i ].isAvailable )
						freeSlot = i;
				}
			}
			if ( !stored )
			{
				if( freeSlot == -1 )
				{
					return 0; // error with add item in inventory;
				}
				else
				{
					this._inventory[ freeSlot ].item = newItem; // add new item in inventory to free slot;
					//trace( "Slot N " + freeSlot + "; Item with type: " + newItem.get( "type" ) );
					return 1; // no errors, all good;
				}
			}
			return 1;
		}
		else
		{
			for( i in 0...this._inventory.length )
			{
				var slotName = this._inventory[ i ].name;
				if( slotName == slot )
				{
					if( this._inventory[ i ].item == null && this._inventory[ i ].isAvailable )
					{
						this._inventory[ i ].item = newItem;
						return 1;
					}
					else
					{
						var oldItem:Dynamic = this._inventory[ i ].item;
						this._inventory[ i ].item = newItem;
						return oldItem;
					}
				}
			}
		}
		return 0;
	}

	public function removeItemFromSlot( item:Entity, slot:String ):Dynamic
	{
		var oldItem:Dynamic = null;
		if( item == null )
		{
			for( i in 0...this._inventory.length )
			{
				var slotName:String = this._inventory[ i ].name;
				if ( slotName == slot )
				{
					oldItem = this._inventory[ i ].item;
					this._inventory[ i ].item = null;
					break;
				}
			}	
		}
		else
		{
			var itemId:Int = item.get( "id" );
			for( j in 0...this._inventory.length )
			{
				if ( this._inventory[ j ].item != null )
				{
					if( itemId == this._inventory[ j ].item.get( "id" ) )
					{
						oldItem = this._inventory[ j ].item;
						this._inventory[ j ].item = null;
						break;
					}					
				}
			}
		}
		return oldItem;
		
	}

	public function changePropSlotInventory( slot:String, prop:Dynamic ):Void
	{
		var newSlot:Dynamic = null;
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
		//TODO: Check function to work;
	}

	public function getItemInSlot( slot:String ):Dynamic
	{
		var item:Dynamic = null;
		for( i in 0...this._inventory.length )
		{
			var slotName = this._inventory[ i ].name;
			if ( slotName == slot )
			{
				item = this._inventory[ i ].item;
				break;
			}
		}
		return item;
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