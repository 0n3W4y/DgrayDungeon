package;

class Skills extends Component
{
	private var _active:Array<Dynamic>;
	private var _passive:Array<Dynamic>;
	private var _camping:Array<Dynamic>;

	private var _maxActiveSkills:Int = 0;
	private var _maxStaticActiveSkills:Int = 0;
	private var _currentStaticActiveSkills:Int = 0;
	private var _maxPassiveSkills:Int = 0;
	private var _maxStaticPassiveSkills:Int = 0;
	private var _currentStaticPassiveSkills:Int = 0;
	private var _maxCampingSkills:Int = 0;
	private var _maxStaticCampingSkills:Int = 0;
	private var _currentStaticCampingSkills:Int = 0;

	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "skills" );
		this._maxActiveSkills = params.maxActiveSkills;
		this._maxStaticActiveSkills = params.maxStsticActiveSkills;
		this._maxPassiveSkills = params.maxPassiveSkills;
		this._maxStaticPassiveSkills = params.maxStaticPassiveSlkills;
		this._maxCampingSkills = params.maxCampingSkills;
		this._maxStaticCampingSkills = params.maxStaticCampingSkills;
		this._active = new Array();
		this._passive = new Array();
		this._camping = new Array();


	}

	private function _setChooseActive( skill:Dynamic ):Bool
	{
		if( !skill.isStatic )
		{
			if( this._currentStaticActiveSkills < this._maxStaticActiveSkills )
			{
				skill.isStatic = true;
				this._currentStaticActiveSkills++;
				return true;
			}
		}
		else
		{
			skill.isStatic = false;
			this._currentStaticActiveSkills--;
			return true;
		}
		return false;
	}

	private function _setChoosePassive( skill:Dynamic ):Bool
	{
		if( !skill.isStatic )
		{
			if( this._currentStaticPassiveSkills < this._maxStaticPassiveSkills )
			{
				skill.isStatic = true;
				this._currentStaticPassiveSkills++;
				return true;
			}
		}
		else
		{
			skill.isStatic = false;
			this._currentStaticPassiveSkills--;
			return true;
		}
		return false;
	}

	private function _setChooseCamping( skill:Dynamic ):Bool
	{
		if( !skill.isStatic )
		{
			if( this._currentStaticCampingSkills < this._maxStaticCampingSkills )
			{
				skill.isStatic = true;
				this._currentStaticCampingSkills++;
				return true;
			}
		}
		else
		{
			skill.isStatic = false;
			this._currentStaticCampingSkills--;
			return true;
		}
		return false;
	}



	public function chooseSkill( name:String ):Bool
	{

		for( i in 0...this._active.length )
		{
			var skill:Dynamic = this._active[ i ];
			if( skill.name == name )
			{
				return this._setChooseActive( skill );
			}
		}

		for( j in 0...this._passive.length )
		{
			var skill:Dynamic = this._passive[ j ];
			if( skill.name == name )
			{
				return this._setChoosePassive( skill );
			}
		}

		for( k in 0...this._camping.length )
		{
			var skill:Dynamic = this._camping[ k ];
			if( skill.name == name )
			{
				return this._setChooseCamping( skill );
			}
		}
		return false;
	}

	public function unChooseSkill( name:String ):Void
	{
		
	}

	public function addSkill( skill:Dynamic, place:String ):Bool
	{
		switch( place )
		{
			case "active":
			{
				if( this._maxActiveSkills <= this._active.length )
				{
					this._active.push( skill );
					return true;
				}
				return false;
			} 
			case "passive": 
			{
				if( this._maxPassiveSkills <= this._passive.length )
				{
					this._passive.push( skill );
					return true;
				}
				return false;
			}
			case "camping": 
			{
				if( this._maxCampingSkills <= this._camping.length )
				{
					this._camping.push( skill );
					return true;
				}
				return false;
			}
			default: { trace( "Error in Skills.addSkill, can't add skill in place: " + place ); return false; }
		}
	}

	public function levelUpSkill( skill:String ):Void
	{
		var config:Dynamic = this._parent.get( "parent" ).getParent().getParent.getSystem( "entity" ).getConfig();

	}

	public function removeSkill( skill:String ):Dynamic
	{
		return null;
	}

	public function getSkills( type:String ):Array<Dynamic>
	{
		switch( type )
		{
			case "active": return this._active;
			case "passive": return this._passive;
			case "camping": return this._camping;
			default: { trace( "Error in Skills.getSkills, can't get array of skills with type: " + type); return null; };
		}
	}

}