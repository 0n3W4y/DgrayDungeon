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
		this._maxSlots = parapms.maxSlots;
		this._currentSlots = params.currentSlots;
		for( key in Reflect.fields( params.inventory ) )
		{
			var value = Reflect.getProperty( params.inventory, key );
			if( params.needToFill )
			{
				var j = 0;
				for( i in 0...params.slots )
				{
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

	public function getInventory():Array
	{
		return this._inventory;
	}

	public function setItemInSlot( item:Dynamic, slot:String ):Bool
	{
		// isStorable = true/false, maxSize = 2500; 
		// [ { { slotName: slot1, item: {}, isAvailable: true, restirction: null } } ];
	}

	public function removeItemFromSlot( item:String, slot:String ):Dynamic
	{
		
	}
}