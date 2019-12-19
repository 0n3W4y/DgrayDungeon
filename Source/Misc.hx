package;

class Misc extends Component
{
	private var _sellPrice:Int;
	private var _buyPrice:Int;
	private var _restrictionForInventory:Array<String>;
	private var _storable:Bool;
	private var _maxCapacity:Int;
	private var _currentCapacity:Int;


	public function new( parent:Entity, params:Dynamic ):Void
	{
		super( parent, "misc" );
		this._sellPrice = params.sellPrice;
		this._buyPrice = params.buyPrice;
		this._restrictionForInventory = params.resriction;
	}

	public function getSellPrice():Int
	{
		return this._sellPrice;
	}

	public function getBuyPrice():Int
	{
		return this._buyPrice;
	}

	public function getRestriction():Array<String>
	{
		return this._restrictionForInventory;
	}

	public function setSellPrice( value:Int ):Void
	{
		this._sellPrice = value;
	}

	public function setBuyPrice( value:Int ):Void
	{
		this._buyPrice = value;
	}

	public function checkRestriction( restriction:String ):Bool
	{
		if( this._restrictionForInventory == null )
			return true; // no restriction on this item

		for( i in 0...this._restrictionForInventory.length )
		{
			var restrict:String = this._restrictionForInventory[ i ];
			if( restrict == restriction ) // yes, we have that restriction on item;
				return true;
		}
		return false;
	}

	public function isStorable():Bool
	{
		return this._storable;
	}

	public function getMaxCapcity():Int
	{
		return this._maxCapacity;
	}

	public function getCurrentcapacity():Int
	{
		return this._currentCapacity;
	}

}