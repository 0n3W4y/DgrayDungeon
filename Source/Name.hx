package;

class Name extends Component
{
	private var _name:String;
	private var _surname:String;
	private var _rank:String;
	private var _type:String;


	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "name" );
		this._name = params.name;
		this._surname = prarms.surname;
		this._rank = params.rank;
		this._type = params.type;
	}

	public function get( type:String ):String
	{
		switch( type )
		{
			case "name": return this._name;
			case "surname": return this._surname;
			case "rank": return this._rank;
			case "type": return this._type;
			default: trace( "Error in Name.get, type of get can't be: " + type );
		}
	}

	public function set( type:String, value:String ):Void
	{
		switch( type )
		{
			case "name": this._name = value;
			case "surname": this._surname = value;
			case "rank": this._rank = value;
			case "type": this._type = value;
			default: trace( "Error in Name.set, type of get can't be: " + type );
		}
	}
}