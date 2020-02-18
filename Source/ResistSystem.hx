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
	private var _resistDesease:Float;
	private var _resistDebuff:Float;
	private var _resistMove:Float;
	private var _resistFire:Float;
	private var _resistCold:Float;

  public function new( config:ResistConfig ):Void
  {
    this._resistStun = config.Stun;
    this._resistPoison = config.Poison;
    this._resistBleed = config.Bleed;
    this._resistDesease = config.Desease;
    this._resistDebuff = config.Debuff;
    this._resistMove = config.Move;
    this._resistFire = config.Fire;
    this._resistCold = config.Cold;
  }

  public function init( error:String ):Void
  {

  }

  public function postInit( error:String ):Void
  {

  }

  public function get( resist:String ):Float
  {
    switch( resist )
    {
      case "stun": return this._resistStun;
			case "poison": return this._resistPoison;
			case "bleed": return this._resistBleed;
			case "disease": return this._resistDesease;
			case "debuff": return this._resistDebuff;
			case "move": return this._resistMove;
			case "fire": return this._resistFire;
      case "cold": return this._resistCold;
      default: throw 'Error in ResistSystem.get. No resist $resist was found';
    }
  }
}
