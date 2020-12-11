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
    var TreasureEvents:Int;
    var TrapEvents:Int;
    var CurrentQuest:Dynamic;
}

class BattleScene extends Scene
{
    private var _difficulty:String;
    private var _dungeonLength:Int;
    private var _enemyEvents:Int;
    private var _treasureEvents:Int;
    private var _trapEvents:Int;
    private var _quest:Dynamic;
    private var _numOfBackgroundImages:Int;
    private var _generatedMap:Array<Int>;
    private var _playerCurrentPosition:Int;

    private var _heroesInBattle:Array<Hero>;
    private var _enemiesInBattle:Array<Enemy>;



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
        this._treasureEvents = config.TreasureEvents;
        this._trapEvents = config.TrapEvents;
        this._quest = config.CurrentQuest;
        this._numOfBackgroundImages = config.ImagesNum;
        this._generatedMap = new Array<Int>();

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

        if( this._treasureEvents <= 0 || this._treasureEvents == null )
            throw '$error Treasure events is not valid. $_treasureEvents';

        if( this._trapEvents <= 0 || this._trapEvents == null )
            throw '$error Traps events is not valid. $_trapEvents';

        if( this._quest == null )
            throw '$error Quest is NULL!!';

        if( this._numOfBackgroundImages <= 1 || this._numOfBackgroundImages == null )
            throw '$error Background images are not valid number. $_numOfBackgroundImages';

        if(( this._enemyEvents + this._treasureEvents + this._trapEvents ) >= Math.floor( this._dungeonLength / 3 ))
            throw '$error Map events more than dungeon length!!!! ';
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
            case "trapEvents": return this._trapEvents;
            case "playerCurrentPosition": return this._playerCurrentPosition;
            case "generatedMap": return this._generatedMap;
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

    public function generate():Void
    {
        var dungeonLength:Int = this._dungeonLength - 1; // starting array with 0;
        this._generatedMap = [ for( i in 0...dungeonLength ) 0 ];
        

        this._generateEventsOnGeneratedMap( "enemy" );
        this._generateEventsOnGeneratedMap( "treasure" );
        this._generateEventsOnGeneratedMap( "trap" );

    }

    public function move( direction:String ):Void
    {
        //TODO: move left or right, so triggered function will be chage curretn position, and change graphicsSprite;
        // get array of graphics ( length ? ) find random index, get sprite child with that index, get width of current, put x with that width; y = 0; always;
        // 
    }



    public function getEventFromNextPosition( direction:String ):Int
    {
        var currentPosition:Int = this._playerCurrentPosition;
        switch( direction )
        {
            case "left": currentPosition -1;
            case "right": currentPosition +1;
            default: 'Error in BattleScene.getEventFromNextPosition Can not get event from "$direction" position!';
        }

        if( currentPosition < 0 || currentPosition >= this._generatedMap.length )
            return -1;

        return this._generatedMap[ currentPosition ];
    }

    public function canMoveToNextPosition( direction:String ):Bool
    {
        var currentPosition:Int = this._playerCurrentPosition;
        switch( direction )
        {
            case "left": currentPosition -1;
            case "right": currentPosition +1;
            default: 'Error in BattleScene.canMoveToNextPosition Can not check "$direction" position!';
        }

        if( currentPosition < 0 || currentPosition >= this._generatedMap.length )
            return false;
        else
            return true;
    }

    public function moveToTheNextPosition( direction:String ):Void
    {
        if( this.canMoveToNextPosition( direction ) )
        {
            switch( direction )
            {
                case "left": this._playerCurrentPosition--;
                case "right": this._playerCurrentPosition++;
                default: 'Error in BattleScene. Can not move to "$direction" position!';
            }
        }
    }




    //PRIVATE

    private function _generateEventsOnGeneratedMap( event:String ):Void
    {
        var events:Int = 0;
        var eventNumber:Int = 0;
        switch( event )
        {
            case "enemy": events = this._enemyEvents; eventNumber = 1;
            case "treasure": events = this._treasureEvents; eventNumber = 2;
            case "trap": events = this._trapEvents; eventNumber = 3;
            default: throw 'Error in battleScene._generateEventsOnGeneratedMap. Can not generate event with name:"$event"';
        }

        while( events > 0 )
        {
            var randomIndex:Int = Math.floor( 1 + Math.random() * ( this._generatedMap.length - 2 )); // 2 baceuse -1 and -1; last sector will be exit;
            if(  this._generatedMap[ randomIndex ] == 0 )
            {
                this._generatedMap[ randomIndex ] = eventNumber; // enemy event == 1;
                events--;
            }
        }
    }

}