package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.events.MouseEvent;

typedef EventHandlerConfig =
{
	var Parent:Game;
}


class EventHandler
{
	private var _parent:Game;
	private var _listeners:Array<Dynamic>;

	public inline function new( config:EventHandlerConfig ):Void
	{
		this._parent = config.Parent;
	}

	public function init( error:String ):Void
	{
		var err:String = 'Error in EventHandler.init';
		if( this._parent == null )
			throw '$error. $err. Parent is null';

		this._listeners = new Array<Dynamic>();
	}

	public function postInit():Void
	{

	}

	public function addEvents( object:Dynamic ):Void
	{
		var name:String = object.get( "name" );
		var check:Int = this._checkListenerIfExist( object );
		if( check != null )
			throw 'Error in EventHandler._addEventsToButton. Object with name: "$name" already in listeners';

		this._addEvents( object );
		this._listeners.push( object );
	}

	public function removeEvents( object:Dynamic ):Void
	{
		var name:String = object.get( "name" );
		var check:Int = this._checkListenerIfExist( object );

		var sprite:Sprite = object.get( "sprite" ); // Проверяю, есть ли на кнопке какой-либо эвент( так я решил проблему с кнопкой continue xD );
		if( !sprite.hasEventListener( "click" ) )
			return;

		if( check == null )
			throw 'Error in EventHandler.removeEvent. Object with name: "$name" does not exist';

		this._removeEvents( object );
		this._listeners.splice( check, 1 );
	}

	// PRIVATE

	private function _removeEvents( object:Dynamic ):Void
	{
		var type:String = object.get( "type" );
		switch( type )
		{
			case "button":  this._removeEventsFromButton( object );
			case "hero": this._addEventsToHero( object );
			case "enemy": this._addEventsToEnemy( object );
			case "item": this._addEventsToItem( object );
			case "building": this._addEventsToBuilding( object );
			default: throw 'Error in EventHandler._removeEvent. No events found for type "$type"';
		}
	}

	private function _addEvents( object:Dynamic ):Void
	{
		var type:String = object.get( "type" );

		switch( type )
		{
			case "button":  this._addEventsToButton( object );
			case "hero": this._addEventsToHero( object );
			case "enemy": this._addEventsToEnemy( object );
			case "item": this._addEventsToItem( object );
			case "building": this._addEventsToBuilding( object );
			default: throw 'Error in EventHandler._addEvent. No events found for type "$type"';
		}
	}

	private function _addEventsToButton( object:Dynamic ):Void
	{
		// click будем разбирать по имени кнопки.
		var name:String = object.get( "name" );
		var sprite:Sprite = object.get( "sprite" );

		this._addStandartButtonEvents( sprite ); // Добавляем стандартные ивенты как hover, unhover, push, unpush.

		switch( name )
		{
			case "gameStart": sprite.addEventListener( MouseEvent.CLICK, this._clickStartGame );
			case "gameContinue": sprite.addEventListener( MouseEvent.CLICK, this._clickContinueGame );
			case "gameOptions": sprite.addEventListener( MouseEvent.CLICK, this._clickOptionsGame );
			case "innUp": {};
			case "innDown": {};
			default: throw 'Error in EventHandler._addEventsToButton. No event for button with name "$name"';
		}
	}

	private function _removeEventsFromButton( object:Dynamic ):Void
	{
		//hasEventListener (type:String):Bool
		var name:String = object.get( "name" );
		var sprite:Sprite = object.get( "sprite" );

		this._removeStandartButtonEvents( sprite ); // Убираем стандартные ивенты как hover, unhover, push, unpush.

		switch( name )
		{
			case "gameStart": sprite.removeEventListener( MouseEvent.CLICK, this._clickStartGame );
			case "gameContinue": sprite.removeEventListener( MouseEvent.CLICK, this._clickContinueGame );
			case "gameOptions": sprite.removeEventListener( MouseEvent.CLICK, this._clickOptionsGame );
			case "innUp": {};
			case "innDown": {};
			default: throw 'Error in EventHandler._addEventsToButton. No event for button with name "$name"';
		}
	}

	private function _addEventsToHero( object:Dynamic ):Void
	{

	}

	private function _addEventsToItem( object:Dynamic ):Void
	{

	}

	private function _addEventsToEnemy( object:Dynamic ):Void
	{

	}

	private function _addEventsToBuilding( object:Dynamic ):Void
	{
		var name:String = object.get( "name" );
		var sprite:Sprite = object.get( "sprite" );
		this._addStandartBuildingEvents( sprite );
		switch( name )
		{
			case "recruits": sprite.addEventListener( MouseEvent.CLICK, this._clickRecruitsBuilding );
			default:
		}
	}

	private function _removeEventsFromBuilding( object:Dynamic ):Void
	{
		var name:String = object.get( "name" );
		var sprite:Sprite = object.get( "sprite" );
		this._removeStandartBuildingEvents( sprite );
		switch( name )
		{
			case "recruits": sprite.removeEventListener( MouseEvent.CLICK, this._clickRecruitsBuilding );
			default:
		}
	}

	private function _checkListenerIfExist( object:Dynamic ):Int
	{
		var type:String = object.get( "type" );
		for( i in 0...this._listeners.length )
		{
			if( this._listeners[ i ].get( "type" ) != type )
				continue;

			if( haxe.EnumTools.EnumValueTools.equals( this._listeners[ i ].get( "id" ), object.get( "id" )))
				return i;
		}
		return null;
	}

	private function _clickStartGame( e:MouseEvent ):Void
	{
		//TODO: create cityscene, switch active scene, draw new scene, undraw old scene;
		var sceneSystem:SceneSystem = this._parent.getSystem( "scene" );
		var player:Player = this._parent.createPlayer( 100 , "test player" );

		var scene:Scene = sceneSystem.createScene( 1001 );
		sceneSystem.prepareScene( scene );
		sceneSystem.changeSceneTo( scene );
	}

	private function _clickContinueGame( e:MouseEvent ):Void
	{

	}

	private function _clickOptionsGame( e:MouseEvent ):Void
	{

	}

	private function _clickRecruitsBuilding( e:MouseEvent ):Void
	{
		//TODO: click window to open ( mainCityWindow + recruitWindow );
	}

	private function _hover( e:MouseEvent ):Void
	{
		var sprite:Dynamic = e.currentTarget;
		var graphicSprite:Sprite = sprite.getChildAt( 0 );
		graphicSprite.getChildAt( 1 ).visible = true;
	}

	private function _unhover( e:MouseEvent ):Void
	{
		var sprite:Dynamic = e.currentTarget;
		var graphicSprite:Sprite = sprite.getChildAt( 0 );
		graphicSprite.getChildAt( 1 ).visible = false;
		graphicSprite.getChildAt( 2 ).visible = false;
	}

	private function _push( e:MouseEvent ):Void
	{
		var sprite:Dynamic = e.currentTarget;
		var graphicSprite:Sprite = sprite.getChildAt( 0 );
		graphicSprite.getChildAt( 2 ).visible = true;
	}

	private function _unpush( e:MouseEvent ):Void
	{
		var sprite:Dynamic = e.currentTarget;
		var graphicSprite:Sprite = sprite.getChildAt( 0 );
		graphicSprite.getChildAt( 2 ).visible = false;
	}

	private function _hoverBuilding( e:MouseEvent ):Void
	{
		var sprite:Dynamic = e.currentTarget;
		var graphicsSprite:Sprite = sprite.getChildAt( 0 );
		graphicSprite.getChildAt( 1 ).visible = true;
		var textSprite:Sprite = sprite.getChildAt( 1 );
		textSprite.getChildAt( 0 ).visible = true;
	}

	private function _unhoverBuilding( e:MouseEvent ):Void
	{
		var sprite:Dynamic = e.currentTarget;
		var graphicsSprite:Sprite = sprite.getChildAt( 0 );
		graphicSprite.getChildAt( 1 ).visible = false;
		var textSprite:Sprite = sprite.getChildAt( 1 );
		textSprite.getChildAt( 0 ).visible = false;
	}

	private function _addStandartButtonEvents( sprite:Sprite ):Void
	{
		sprite.addEventListener( MouseEvent.MOUSE_OUT, this._unhover );
		sprite.addEventListener( MouseEvent.MOUSE_OVER, this._hover );
		sprite.addEventListener( MouseEvent.MOUSE_UP, this._unpush );
		sprite.addEventListener( MouseEvent.MOUSE_DOWN, this._push );
	}

	private function _removeStandartButtonEvents( sprite:Sprite ):Void
	{
		sprite.removeEventListener( MouseEvent.MOUSE_OUT, this._unhover );
		sprite.removeEventListener( MouseEvent.MOUSE_OVER, this._hover );
		sprite.removeEventListener( MouseEvent.MOUSE_UP, this._unpush );
		sprite.removeEventListener( MouseEvent.MOUSE_DOWN, this._push );
	}

	private function _addStandartBuildingEvents( sprite:Sprite ):Void
	{
		sprite.addEventListener( MouseEvent.MOUSE_OVER, this._hoverBuilding );
		sprite.addEventListener( MouseEvent.MOUSE_OUT, this._unhoverBuilding );
	}

	private function _removeStandartBuildingEvents( sprite:Sprite ):Void
	{
		sprite.removeEventListener( MouseEvent.MOUSE_OVER, this._hoverBuilding );
		sprite.removeEventListener( MouseEvent.MOUSE_OUT, this._unhoverBuilding );
	}
}
