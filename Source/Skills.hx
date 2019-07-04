package;

class Skills extends Component
{
	private var _active:Array<Dynamic>;
	private var _passive:Array<Dynamic>;
	private var _camping:Array<Dynamic>;

	private var _maxActiveSkills:Int = 0;
	private var _maxStaticActiveSkills:Int = 0;
	private var _maxPassiveSkills:Int = 0;
	private var _maxStaticPassiveSkills:Int = 0;

	private var _choosenActiveSkills:Int = 0;
	private var _choosenPassiveSkills:Int = 0;

	public function new( parent:Entity, id:String, params:Dynamic ):Void
	{
		super( parent, id, "skills" );
		this._maxActiveSkills = params.maxActiveSkills;
		this._maxStaticActiveSkills = params.maxStsticActiveSkills;
		this._maxPassiveSkills = params.maxPassiveSkills;
		this._maxStaticPassiveSkills = params.maxStaticPassiveSlkills;
		this._active = new Array();
		this._passive = new Array();
		this._camping = new Array();


	}

	public function setSkillChoose( name:String, value:Bool ):Void
	{
		if( value )
		{
			if( this._choosenActiveSkills < this._maxActiveSkills )
			{
				for( i in 0...this._active.length )
				{
					var skill:Dynamic = this._active[ i ];
					if( skill.name == name )
					{
						skill.isChoosen = value;
						this._choosenActiveSkills++;
					}
				}
			}

			if( this._choosenPassiveSkills < this._maxPassiveSkills )
			{
				for( j in 0...this._passive.length )
				{
					var skill:Dynamic = this._passive[ j ];
					if( skill.name == name )
					{
						skill.isChoosen = value;
						this._choosenPassiveSkills++;
					}
				}
			}			
		}
		else 
		{
			for( i in 0...this._active.length )
			{
				var skill:Dynamic = this._active[ i ];
				if( skill.name == name )
				{
					skill.isChoosen = value;
					this._choosenActiveSkills--;
				}
			}
			for( j in 0...this._passive.length )
			{
				var skill:Dynamic = this._passive[ j ];
				if( skill.name == name )
				{
					skill.isChoosen = value;
					this._choosenPassiveSkills--;
				}
			}
		}		
	}

	public function unChooseSkill( name:String ):Void
	{
		
	}

	public function addSkill( skill:Dynamic, palce:String ):Void
	{

	}

	public function removeSkill( skill:String ):Dynamic
	{
		return null;
	}

}