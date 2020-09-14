package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;

import Window;

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
		var type:String = object.get( "type" );
		var check:Int = this._checkListenerIfExist( object );
		if( check != null )
			throw 'Error in EventHandler.addEvents. Object with name: "$name" already in listeners';

		switch ( type )
		{
			case "button": this._addButtonEvents( object );
			case "building": this._addBuildingEvents( object );
			default: throw 'Error in EventHandler.AddEvents. No events for "$type"';
		}
		this._listeners.push( object );
	}

	public function removeEvents( object:Dynamic ):Void
	{
		var name:String = object.get( "name" );
		var type:String = object.get( "type" );
		var check:Int = this._checkListenerIfExist( object );
		if( check == null )
			throw 'Error in EventHandler.removeEvents. Can not find "$name" in listeners';

		switch ( type )
		{
			case "button": this._removeButtonEvents( object );
			case "building": this._removeBuildingEvents( object );
			default: throw 'Error in EventHandler.AddEvents. No events for "$type"';
		}
		this._listeners.splice( check, 1 );
	}





	// PRIVATE



	private function _clickButton( e:MouseEvent ):Void
	{
		var sprite:DataSprite = e.currentTarget;
		var id:Button.ButtonID = sprite.sId;
		var name:String = sprite.sName;
		var state:State = this._parent.getSystem( "state" );
		switch( name )
		{
			case "gameStart": state.startGame();
			case "gameContinue": state.continueGame();
			case "gameOptions": state.optionsGame();
			case "innUp": state.innHeroListUp();
			case "innDown": state.innHeroListDown();
			case "gameStartJourney": state.startJourney();
			case "recruitHeroButton": state.recruitHero();
			case "citySceneMainWindowClose": state.closeWindow( 3001 );
			case "choosenHeroToDungeon": state.unchooseHeroToDungeon( id );
			case "chooseDungeonBackToCityButton": state.backToCitySceneFromChooseDungeon();
			case "recruitHeroButtonWhite",
				"recruitHeroButtonBlue",
				"recruitHeroButtonGreen",
				"recruitHeroButtonOrange": this._chooseUnchooseButton( e );
			case "innWindowHeroButtonOrange",
				"innWindowHeroButtonBlue",
				"innWindowHeroButtonWhite",
				"innWindowHeroButtonGreen": this._chooseUnchooseButton( e );
			case "warningWindowOk": state.closeWindow( 3100 );
			case "storageButton": state.openWindow( 3013 );
			case "blackSmithWindowUpgradeItemButton":
			case "blackSmithWindowUpgradeBuildingButton":
			case "merchantWindowUpgradeBuildingButton":
			case "storageWindowWeaponButton":
			case "storageWindowArmorButton":
			case "storageWindowAcessory1Button":
			case "storageWindowAcessory2Button":
			case "showItemsMerchantWindowFromMerchant":
			case "showItemsMerchantWindowFromStorage":
			case "storageListUp":
			case "storageListDown":
			default: throw 'Error in EventHandler._addEventsToButton. No event for button with name "$name"';
		}
	}

	private function _clickBuilding( e:MouseEvent ):Void
	{
		var sprite:DataSprite = e.currentTarget;
		var id:Building.BuildingID = sprite.sId;
		var name:String = sprite.sName;
		var state:State = this._parent.getSystem( "state" );
		switch( name )
		{
			//TODO: Доделать default  и другие case;
			case "recruits": state.openWindow( 3002 );
			case "hospital": state.openWindow( 3016 );
			case "tavern": state.openWindow( 3014 );
			case "blacksmith": state.openWindow( 3012 );
			case "merchant": state.openWindow( 3011 );
			case "graveyard": state.openWindow( 3017 );
			case "academy": state.openWindow( 3018 );
			case "hermit": state.openWindow( 3019 );
			case "questman": {};
			case "fontain": {};
			case "inn":{};
			case "storage": state.openWindow( 3013 );
			default: throw 'Error in EventHandler._addEventsToBuilding. No events for $name';
		}
	}






	private function _hoverButton( e:MouseEvent ):Void
	{
		var sprite:Dynamic = e.currentTarget;
		var graphicsSprite:Sprite = sprite.getChildAt( 0 );
		graphicsSprite.getChildAt( 1 ).visible = true;
	}

	private function _unhoverButton( e:MouseEvent ):Void
	{
		var sprite:Dynamic = e.currentTarget;
		var name:String = sprite.sName;
		var graphicsSprite:Sprite = sprite.getChildAt( 0 );
		graphicsSprite.getChildAt( 1 ).visible = false;
		if( name == "recruitHeroButtonWhite" || name == "recruitHeroButtonGreen" || name == "recruitHeroButtonBlue" || name == "recruitHeroButtonOrange"
			|| name == "innWindowHeroButtonOrange" || name == "innWindowHeroButtonBlue" || name == "innWindowHeroButtonGreen" || name == "innWindowHeroButtonWhite" )
			return;

		graphicsSprite.getChildAt( 2 ).visible = false;
	}

	private function _pushButton( e:MouseEvent ):Void
	{
		var sprite:Dynamic = e.currentTarget;
		var graphicsSprite:Sprite = sprite.getChildAt( 0 );
		graphicsSprite.getChildAt( 2 ).visible = true;
	}

	private function _unpushButton( e:MouseEvent ):Void
	{
		var sprite:Dynamic = e.currentTarget;
		var graphicsSprite:Sprite = sprite.getChildAt( 0 );
		graphicsSprite.getChildAt( 2 ).visible = false;
	}

	private function _chooseUnchooseButton( e:MouseEvent ):Void
	{
		var sprite:Dynamic = e.currentTarget;
		var graphicsSprite:Sprite = sprite.getChildAt( 0 );
		var state:State = this._parent.getSystem( "state" );
		if( graphicsSprite.getChildAt( 2 ).visible )
		{
			graphicsSprite.getChildAt( 2 ).visible = false;
			state.unchooseButton( sprite.sName, sprite.sId );
		}
		else
		{
			graphicsSprite.getChildAt( 2 ).visible = true;
			state.chooseButton( sprite.sName, sprite.sId );
		}
	}

	private function _hoverBuilding( e:MouseEvent ):Void
	{
		var sprite:Dynamic = e.currentTarget;
		var graphicsSprite:Sprite = sprite.getChildAt( 0 );
		graphicsSprite.getChildAt( 1 ).visible = true;
		var textSprite:Sprite = sprite.getChildAt( 1 );
		textSprite.visible = true;
	}

	private function _unhoverBuilding( e:MouseEvent ):Void
	{
		var sprite:Dynamic = e.currentTarget;
		var graphicsSprite:Sprite = sprite.getChildAt( 0 );
		graphicsSprite.getChildAt( 1 ).visible = false;
		var textSprite:Sprite = sprite.getChildAt( 1 );
		textSprite.visible = false;
	}

	private function _addButtonEvents( object:Button ):Void
	{
		var buttonDeployId:Button.ButtonDeployID = object.get( "deployId" );
		var events:Array<String> = this._parent.getSystem( "deploy" ).getButton( buttonDeployId ).events;
		var sprite:Sprite = object.get( "sprite" );
		for( i in 0...events.length )
		{
			var event:String = events[ i ];
			switch( event )
			{
				case "up": sprite.addEventListener( MouseEvent.MOUSE_UP, this._unpushButton );
				case "down": sprite.addEventListener( MouseEvent.MOUSE_DOWN, this._pushButton );
				case "out": sprite.addEventListener( MouseEvent.MOUSE_OUT, this._unhoverButton );
				case "over": sprite.addEventListener( MouseEvent.MOUSE_OVER, this._hoverButton );
				case "click": sprite.addEventListener( MouseEvent.CLICK, this._clickButton );
				default: throw 'Error in EventHandler._addButtonEvents. No Event found for "$event"';
			}
		}
	}

	private function _removeButtonEvents( object:Button ):Void
	{
		var buttonDeployId:Button.ButtonDeployID = object.get( "deployId" );
		var events:Array<String> = this._parent.getSystem( "deploy" ).getButton( buttonDeployId ).events;
		var sprite:Sprite = object.get( "sprite" );
		for( i in 0...events.length )
		{
			var event:String = events[ i ];
			switch( event )
			{
				case "up": sprite.removeEventListener( MouseEvent.MOUSE_UP, this._unpushButton );
				case "down": sprite.removeEventListener( MouseEvent.MOUSE_DOWN, this._pushButton );
				case "out": sprite.removeEventListener( MouseEvent.MOUSE_OUT, this._unhoverButton );
				case "over": sprite.removeEventListener( MouseEvent.MOUSE_OVER, this._hoverButton );
				case "click": sprite.removeEventListener( MouseEvent.CLICK, this._clickButton );
				default: throw 'Error in EventHandler._removeButtonEvents. No Event found for "$event"';
			}
		}
	}

	private function _addBuildingEvents( object:Building ):Void
	{
		var buildingDeployId:Building.BuildingDeployID = object.get( "deployId" );
		var events:Array<String> = this._parent.getSystem( "deploy" ).getBuilding( buildingDeployId ).events;
		var sprite:Sprite = object.get( "sprite" );
		for( i in 0...events.length )
		{
			var event:String = events[ i ];
			switch( event )
			{
				//case "up": sprite.addEventListener( MouseEvent.MOUSE_UP, this._unpushBuilding );
				//case "down": sprite.addEventListener( MouseEvent.MOUSE_DOWN, this._pushBuilding );
				case "out": sprite.addEventListener( MouseEvent.MOUSE_OUT, this._unhoverBuilding );
				case "over": sprite.addEventListener( MouseEvent.MOUSE_OVER, this._hoverBuilding );
				case "click": sprite.addEventListener( MouseEvent.CLICK, this._clickBuilding );
				default: throw 'Error in EventHandler._addBuildingEvents. No Event found for "$event"';
			}
		}
	}

	private function _removeBuildingEvents( object:Building ):Void
	{
		var buildingDeployId:Building.BuildingDeployID = object.get( "deployId" );
		var events:Array<String> = this._parent.getSystem( "deploy" ).getBuilding( buildingDeployId ).events;
		var sprite:Sprite = object.get( "sprite" );
		for( i in 0...events.length )
		{
			var event:String = events[ i ];
			switch( event )
			{
				//case "up": sprite.removeEventListener( MouseEvent.MOUSE_UP, this._unpushBuilding );
				//case "down": sprite.removeEventListener( MouseEvent.MOUSE_DOWN, this._pushBuilding );
				case "out": sprite.removeEventListener( MouseEvent.MOUSE_OUT, this._unhoverBuilding );
				case "over": sprite.removeEventListener( MouseEvent.MOUSE_OVER, this._hoverBuilding );
				case "click": sprite.removeEventListener( MouseEvent.CLICK, this._clickBuilding );
				default: throw 'Error in EventHandler._removeBuildingEvents. No Event found for "$event"';
			}
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
}
