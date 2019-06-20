package;

class Traits extends Component
{
	private var _positive:Dynamic;
	private var _negative:Dynamic;
	private var _disease:Dynamic;

	private var _numOfPositive:Int = 0;
	private var _numOfNegative:Int = 0;
	private var _numOfDiseases:Int = 0;


	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "traits" );

	}

	public function addTrait( trait:Dynamic, place:String ):Void
	{
		switch( place )
		{
			case "positive":
			{
				if( this._numOfPositive < 5 )
				{
					this._positive.push( trait );
					this._numOfPositive++;
				}
			}
			case "negative":
			{
				if( this._numOfNegative < 5 )
				{
					this._negative.push( trait );
					this._numOfNegative++;
				}
			}
			case "disease":
			{
				if( this._numOfDiseases < 5 )
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