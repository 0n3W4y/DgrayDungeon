package;

import Scene;
import openfl.display.Sprite;

typedef BattleSceneConfig =
{
    var ID:SceneID;
    var DeployID:SceneDeployID;
    var Name:String;
    var GraphicsSprite:Sprite;
    var ImagesNum:Int;
    var Difficulty:String;
    var DungeonLength:Int;
    var EnemyEvents:Int;
    var CurrentQuest:Dynamic;
}

class BattleScene extends Scene
{
    private var _difficulty:String;
    private var _dungeonLength:Int;
    private var _enemyEvents:Int;
    private var _enemyEventsRemaining:Int;
    private var _quest:Dynamic;
    private var _numOfBackgroundImages:Int;

    private var _heroesInBattle:Array<Hero>;
    private var _enemiesInBattle:Array<Enemy>;
    //private var _treasure:Array<Treasure>;



    public inline function new( config:BattleSceneConfig ):Void
    {
        var sceneConfig:SceneConfig = 
        {
            ID: config.ID,
            DeployID: config.DeployID,
            Name: config.Name,
            GraphicsSprite: config.GraphicsSprite
        };
        
        this._difficulty = config.Difficulty;
        this._dungeonLength = config.DungeonLength;
        this._enemyEvents = config.EnemyEvents;
        this._quest = config.CurrentQuest;
        this._numOfBackgroundImages = config.ImagesNum;
        this._enemyEventsRemaining = config.EnemyEvents;

        this._init();   
        super( sceneConfig );    
    }

    private function _init():Void
    {
        var error:String = 'Error in BattleScene._init. ';
        if( this._difficulty == null )
            throw '$error Difficluty is NULL!';

        if( this._dungeonLength <= 0 || this._dungeonLength == null )
            throw '$error Dungeon length is not valid. $_dungeonLength';

        if( this._enemyEvents <= 0 || this._enemyEvents == null )
            throw '$error Enemy events is not valid. $_enemyEvents';

        if( this._quest == null )
            throw '$error Quest is NULL!!';

        if( this._numOfBackgroundImages <= 1 || this._numOfBackgroundImages == null )
            throw '$error Background images are not valid number. $_numOfBackgroundImages';
        //TODO: check all fields;
    }

    public function addHeroes( heroes:Array<Hero> ):Void
    {
        this._heroesInBattle = heroes;
    }

    public function getFromBattleScene( value:String ):Dynamic
    {
        switch( value )
        {
            case "difficulty": return this._difficulty;
            case "dungeonLength": return this._dungeonLength;
            case "enemyEvents": return this._enemyEvents;
            case "enemyEventsRemaning": return this._enemyEventsRemaining;
            case "quest": return this._quest;
            case "numOfBackgroundImages": return this._numOfBackgroundImages;
            default: throw 'Error in BattleScene.getFromBattleScene. can not get "$value".';
        }
        return null;
    }

    public function getHeroesInBattle():Array<Hero>
    {
        return this._heroesInBattle;
    }

    public function getEnemiesInBattle():Array<Enemy>
    {
        return this._enemiesInBattle;
    }

}