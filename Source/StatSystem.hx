package;

typedef StatConfig =
{
	var Parent:Dynamic;
	var Hp:Float;
	var Acc:Float;
	var Ddg:FLoat;
	var Block:Float;
	var Cc:Float;
	var Def:Float;
	var Dmg:Float;
	var Spd:Float;
	var Stress:Float;
	var CritDmg:Float;
}

class Stats
{
	private var _hp:Float;// Health Points;
	private var _acc:Float;// Accuricy % // choose number of damage, if acc 100% always use max damage;
	private var _ddg:Float;// Dodge %
	private var _block:Float;// block with shield;
	private var _cc:Float;// Critical Chanse
	private var _def:Float;// defense
	private var _dmg:Float;// Damage
	private var _spd:Float; // Speed
	private var _stress:Float;// stress :D
	private var _critDmg:Float;// multiply damage ( x2, x2.1 e.t.c ); //default 100 = 2x


	public function new( config:StatConfig ):Void
	{
		this._parent = config.Parent;
	}

	public function init( error:String ):Void
	{
		var err:String = '$error. Error in StatSystem.init';
		if( this._hp == null )
			throw '$err. Health points is null';

		if( this._acc == null )
			throw '$err. Accuracy is null';

		if( this._ddg == null )
			throw '$err. Dodge is null';

		if( this._block == null )
			throw '$err. Block is null';

		if( this._cc == null )
			throw '$err. Critical chanse is null';

		if( this._def == null )
			throw '$err. Defense is null';

		if( this._dmg == null )
			throw '$err. Damage is null';

		if( this._spd == null )
			throw '$err. Speed is null';

		if( this._stress == null )
			throw '$err. Stress is null';

		if( this._critDmg == null )
			throw '$err. Crititcal damage is null';
	}

	public function postInit( error:String ):Void
	{
		var err:String = '$error. Error in StatSystem.postInit';
		if( this._hp < 0 )
			throw '$err. Health points is $_hp';
	}

	public function getBaseStat( stat:String ):Float
	{
		switch( stat )
		{
			case "hp": return this._hp;
			case "acc": return this._acc;
			case "ddg": return this._ddg;
			case "block": return this._block;
			case "cc": return this._cc;
			case "def": return this._def;
			case "dmg": return this._dmg;
			case "spd": return this._spd;
			case "stress": return this._stress;
			case "critDmg": return this._critDmg;
			default:  throw 'Error in Stats.get. Ca not get $stat';
		}
	}

	public function getFullStat( stat:String ):Float
	{
			// функция, которая должна собрать всю информацию о текущих значения героя включая инвентарь, пассивные скилы + активные скилы + эффекты.
		switch ( stat )
		{
			case "hp": return this._calculateHp();
			case "acc": return this._calculateAcc();
			case "ddg": return this._calculateDdg();
			case "block": return this._calculateBlock();
			case "cc": return this._calculateCc();
			case "def": return this._calculateDef();
			case "dmg": return this._calculateDmg();
			case "spd": return this._calculateSpd();
			case "stress": return this._calculateStress();
			case "critDmg": return this._calculateCritDmg();
			default: throw 'Error in StatSystem.getFullStat. Can not get $stat';
		}
	}

	//PRIVATE

	private function _calculateHp():Float
	{

	}

	private function _calculateAcc():Float
	{

	}

	private function _calculateDdg():Float
	{

	}

	private function calculateBlock():Float
	{

	}

	private function _calculateCc():Float
	{

	}

	private function _calculateDef():Float
	{

	}

	private function _calculateDmg():Float
	{

	}

	private function _calculateSpd():Float
	{

	}

	private function _calculateStress():Float
	{

	}

	private function _calculateCritDmg():Float
	{

	}
}
