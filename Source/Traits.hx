package;

class Traits extends Component
{
	private var _positive:Array<Dynamic>; 
	private var _negative:Array<Dynamic>;

	private var _numOfPositive:Int = 0;
	private var _numOfNegative:Int = 0;
	private var _numOfPositiveStatic:Int = 0;
	private var _numOfNegativeStatic:Int = 0;

	private var _maxNumOfPositive:Int;
	private var _maxNumOfNegative:Int;
	private var _maxNumOfPositiveStatic:Int;
	private var _maxNumOfNegativeStatic:Int;



	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "traits" );
		this._maxNumOfPositive = params.maxNumOfPositive;
		this._maxNumOfNegative = params.maxNumOfNegative;
		this._maxNumOfPositiveStatic = params.maxNumOfPositiveStatic;
		this._maxNumOfNegativeStatic = params.maxNumOfNegativeStatic;
		this._positive = new Array();
		this._negative = new Array();
	}

	public function addTrait( trait:Dynamic, place:String ):Void
	{
		switch( place )
		{
			case "positive":
			{
				if( this._numOfPositive < _maxNumOfPositive )
				{
					this._positive.push( trait );
					this._numOfPositive++;
				}
			}
			case "negative":
			{
				if( this._numOfNegative < _maxNumOfNegative )
				{
					this._negative.push( trait );
					this._numOfNegative++;
				}
			}
			default: trace( "Error in Traits.addTrait, can't add trait with type: " + place );
		}
	}

	public function removeTrait( trait:String ):Void
	{
		//no check;
		for( i in 0...this._positive.length )
		{
			var newTrait = this._positive[ i ];
			if( newTrait.name == trait )
			{
				this._positive.splice( i, 1 );
				this._numOfPositive--;
				return;
			};
		};
		for( j in 0...this._negative.length )
		{
			var newTrait = this._negative[ j ];
			if( newTrait.name == trait )
			{
				this._negative.splice( j, 1 );
				this._numOfNegative--;
				return;
			};
		};
	}

	public function getTrait( name:String ):Dynamic
	{
		return null;
	}

	public function getPositiveTraits():Array<Dynamic>
	{
		return this._positive;
	}

	public function getNegativeTraits():Array<Dynamic>
	{
		return this._negative;
	}

	public function setStaticTrait( trait:String )
	{
		for( i in 0...this._positive.length )
		{
			var newTrait = this._positive[ i ];
			if( newTrait.name == trait )
			{
				newTrait.traitStatic = true;
				return;
			};
		};
		for( j in 0...this._negative.length )
		{
			var newTrait = this._negative[ j ];
			if( newTrait.name == trait )
			{
				newTrait.traitStatic = true;
				return;
			};
		};
	}
}