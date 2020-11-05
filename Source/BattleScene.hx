package;

import Scene;
import openfl.display.Sprite;

typedef BattleSceneConfig =
{
    var ID:SceneID;
    var DeployID:SceneDeployID;
    var Name:String;
    var GraphicsSprite:Sprite;
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
    private var _quest:Dynamic;


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

        this._init();
        super( sceneConfig );
    }

    private function _init():Void
    {
        var error:String = 'Error in BattleScene._init. ';
        if( this._difficulty == null )
            throw '$error Difficluty is NULL!';

        if( this._dungeonLength <= 0 || this._dungeonLength == null )
            throw '$error Dungeon length is not valid.';

        if( this._enemyEvents <= 0 || this._enemyEvents == null )
            throw '$error Enemy events is not valid.';

        if( this._quest == null )
            throw '$error Quest is NULL!!';
        
        //TODO: check all fields;
    }

}