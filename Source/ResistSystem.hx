package;

typedef ResistConfig =
{
  var Stun:Float;
  var Posion:Float;
  var Bleed:Float;
  var Desease:Float;
  var Debuff:Float;
  var Move:FLoat;
  var Fire:Float;
  var Cold:Float;
}

class ResistSystem
{
  private var _resistStun:Float;
	private var _resistPoison:Float;
	private var _resistBleed:Float;
	private var _resistDisease:Float;
	private var _resistDebuff:Float;
	private var _resistMove:Float;
	private var _resistFire:Float;
	private var _resistCold:Float;

  public inline function new( config:ResistConfig ):Void
  {
    this._resistStun = config.Stun;
    this._resistPoison = config.Poison;
    this._resistBleed = config.Bleed;
    this._resistDisease = config.Desease;
    this._resistDebuff = config.Debuff;
    this._resistMove = config.Move;
    this._resistFire = config.Fire;
    this._resistCold = config.Cold;
  }

  public function init( error:String ):Void
  {
    var err:String = '$error. Error in ResistSystem.init';
    if( this._resistStun == null )
      throw '$err. Resist Stun is null';

    if( this._resistPoison == null )
      throw '$$err. Resist Posion is null';

    if( this._resistBleed == null )
      throw '$err. Resist Bleed is null';

    if( this._resistDisease == null )
      throw '$err. Resist Disease is null';

    if( this._resistDebuff == null )
      throw '$err. Resist Debuff is null';

    if( this._resistMove == null )
      throw '$err. Resist Move is null';

    if( this._resistFire == null )
      throw '$err. Resist Fire is null';

    if( this._resistCold == null )
      throw '$err. Resist Cold is null';
  }

  public function postInit( error:String ):Void
  {
    var err:String = '$error. Error in ResistSystem.postInit';
    if( this._resistStun < 0 )
      throw '$err. Resist stun is $_resistStun';
  }

  public function getBaseResist( resist:String ):Float
  {
    switch( resist )
    {
      case "stun": return this._resistStun;
			case "poison": return this._resistPoison;
			case "bleed": return this._resistBleed;
			case "disease": return this._resistDisease;
			case "debuff": return this._resistDebuff;
			case "move": return this._resistMove;
			case "fire": return this._resistFire;
      case "cold": return this._resistCold;
      default: throw 'Error in ResistSystem.getBaseResist. Can not get $resist';
    }
  }

  public function getFullResist( resist:String ):Float
  {
      switch( resist )
      {
        case "stun": return this._calculateStun();
        case "poison": return this._calculatePosion();
  			case "bleed": return this._calculateBleed();
  			case "disease": return this._calculateDisease();
  			case "debuff": return this._calculateDebuff();
  			case "move": return this._calculateMove();
  			case "fire": return this._calculateFire();
        case "cold": return this._calculateCold();
        default: throw 'Error in ResistSystem.getFullResist. Can not get $resist';
      }
  }


  //PRIVATE

  private function _calculateStun():Float
  {

  }

  private function _calculatePosion():Float
  {

  }

  private function _calculateBleed():Float
  {

  }

  private function _calculateDisease():Float
  {

  }

  private function _calculateDebuff():Float
  {

  }

  private function _calculateMove():Float
  {

  }

  private function _calculateFire():Float
  {

  }

  private function _calculateCold():Float
  {

  }
}
