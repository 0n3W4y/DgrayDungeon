package;

class Traits extends Component
{
	private var _positive:Dynamic;
	private var _negative:Dynamic;
	private var _disease:Dynamic;

	private var _numOfPositive:Int = 0;
	private var _numOfNegative:Int = 0;
	private var _numOfDiseases:Int = 0;

	private var _maxNumOfPositive:Int;
	private var _maxNumOfNegative:Int;
	private var _maxNumOfDiseases:Int;


	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "traits" );
		this._maxNumOfPositive = params.maxNumOfPositive;
		this._maxNumOfNegative = params.maxNumOfNegative;
		this._maxNumOfDiseases = params.maxNumOfDiseases;
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
			case "disease":
			{
				if( this._numOfDiseases < _maxNumOfDiseases )
				{
					this._disease.push( trait );
					this._numOfDiseases++;
				}
			}
			default: trace( "Error in Traits.addTrait, can't add trait with type: " + place );
		}
	}

	public function getTrait( name:String ):Dynamic
	{
		return null;
	}
}