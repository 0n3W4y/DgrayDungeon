package;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;
import openfl.events.Event;
import openfl.text.TextField;


class EventSystem
{
	// Try TODO: world event function on game sprite. 
	private var _parent:Game;
	private var _eventListeners:Array<Dynamic>;

	private function _addStartSceneButton( name:String, object:Sprite ):Void
	{
		var arrayOfEvents:Array<Dynamic> = new Array();

		object.addEventListener( MouseEvent.CLICK, this._eventMouseClick );
		arrayOfEvents.push( { "event": MouseEvent.CLICK, "eventFunction": this._eventMouseClick } );

		object.addEventListener( MouseEvent.MOUSE_OVER, this._eventMouseOver );
		arrayOfEvents.push( { "event": MouseEvent.MOUSE_OVER , "eventFunction": this._eventMouseOver } );

		object.addEventListener( MouseEvent.MOUSE_OUT, this._eventMouseOut );
		arrayOfEvents.push( { "event": MouseEvent.MOUSE_OUT , "eventFunction": this._eventMouseOut} );

		object.addEventListener( MouseEvent.MOUSE_DOWN, this._eventMouseDown );
		arrayOfEvents.push( { "event": MouseEvent.MOUSE_DOWN , "eventFunction": this._eventMouseDown } );

		object.addEventListener( MouseEvent.MOUSE_UP, this._eventMouseUp );
		arrayOfEvents.push( { "event": MouseEvent.MOUSE_UP , "eventFunction": this._eventMouseUp} );

		var listener = { "name": name, "events": arrayOfEvents };
		this._eventListeners.push( listener );	
	}

	private function _addCitySceneBuildings( name:String, object:Sprite ):Void
	{
		var arrayOfEvents:Array<Dynamic> = new Array();

		object.addEventListener( MouseEvent.CLICK, this._eventMouseClick );
		arrayOfEvents.push( { "event": MouseEvent.CLICK, "eventFunction": this._eventMouseClick} );

		object.addEventListener( MouseEvent.MOUSE_OVER, this._eventMouseOver );
		arrayOfEvents.push( { "event": MouseEvent.MOUSE_OVER, "eventFunction": this._eventMouseOver } );

		object.addEventListener( MouseEvent.MOUSE_OUT, this._eventMouseOut );
		arrayOfEvents.push( { "event": MouseEvent.MOUSE_OUT, "eventFunction": this._eventMouseOut } );

		var listener = { "name": name, "events": arrayOfEvents };
		this._eventListeners.push( listener );
	}

	private function _eventMouseClick( e:MouseEvent ):Void
	{
		var obj:Dynamic = e.target;
		if( Std.is( e.target, TextField ) )
		{
			if( obj.parent.parent.get( "type" ) == "button" )
			{
				switch( obj.parent.parent.get( "name" ) )
				{
					case "startSceneAuthorsButton": trace( "Authors button pushed." );
					case "startSceneOptionsButton": trace( "Options button pushed." );
					case "startSceneStartButton": 
					{
						//check for load file
						var newScene = this._parent.getSystem( "scene" ).createScene( "cityScene" );
						this._parent.getSystem( "scene" ).doActiveScene( newScene );
					}
					case "startSceneContinueButton": trace( "Continue button pushed" );
					case "citySceneStartJourneyButton": 
					{
						var sceneSystem:SceneSystem = this._parent.getSystem( "scene" );
						var activeScene = sceneSystem.getActiveScene();
						var name = activeScene.getName();
						if ( name == "cityScene" )
						{
							var dungeonScene = sceneSystem.getScene( "chooseDungeonScene" );
							if( dungeonScene == null )
								dungeonScene = sceneSystem.createScene( "chooseDungeonScene" );

							dungeonScene.draw();
							sceneSystem.switchScene( dungeonScene );
							this._parent.getSystem( "ui" ).showUiObject( "innWindow" );
							this._parent.getSystem( "ui" ).showUiObject( "panelCityWindow" );
						}
						else
						{
							//check full stack heroes, check choosen dungeon, check if total LVL heroes are lower then dungeon needed, confirm;
							trace( " we go to fight... TODO." );
						}
					}
					default: trace( "Click this: " + obj.parent.parent.get( "name" ) );
				}
			}			
		}
		else
		{
			if( obj.get( "type" ) == "button" )
			{
				switch ( obj.get( "name" ) ) 
				{
					case "startSceneAuthorsButton": trace( "Authors button pushed." );
					case "startSceneOptionsButton": trace( "Options button pushed." );
					case "startSceneStartButton": 
					{
						//check for load file
						var newScene = this._parent.getSystem( "scene" ).createScene( "cityScene" );
						this._parent.getSystem( "scene" ).doActiveScene( newScene );
					}
					case "startSceneContinueButton": trace( "Continue button pushed" );
					case "citySceneStartJourneyButton": 
					{
						var sceneSystem:SceneSystem = this._parent.getSystem( "scene" );
						var activeScene = sceneSystem.getActiveScene();
						var name = activeScene.getName();
						if ( name == "cityScene" )
						{
							var dungeonScene = sceneSystem.getScene( "chooseDungeonScene" );
							if( dungeonScene == null )
								dungeonScene = sceneSystem.createScene( "chooseDungeonScene" );

							dungeonScene.draw();
							sceneSystem.switchScene( dungeonScene );
							this._parent.getSystem( "ui" ).showUiObject( "innWindow" );
							this._parent.getSystem( "ui" ).showUiObject( "panelCityWindow" );
						}
						else
						{
							//check full stack heroes, check choosen dungeon, check if total LVL heroes are lower then dungeon needed, confirm;
							trace( " we go to fight... TODO." );
						}
						
					}
					default: trace( "Click this: " + obj.get( "name" ) );
				}
			}
		}	
	}

	private function _eventMouseOver( e:MouseEvent ):Void
	{
		var sprite:Sprite = e.target;
		if( Std.is( sprite, TextField ) )
		{
			var obj:Dynamic = sprite.parent;
			if( obj.parent.get( "type" ) == "building" )
			{
				sprite.parent.parent.getChildAt( 1 ).visible = true; // new image;
				sprite.parent.parent.getChildAt( 2 ).alpha = 1; // text
			}
			else
			{
				sprite.parent.parent.getChildAt( 1 ).visible = true;
			}			
		}
		else
		{
			var obj:Dynamic = e.target;
			if( obj.get( "type" ) == "building" )
			{
				sprite.getChildAt( 1 ).visible = true; // new image;
				sprite.getChildAt( 2 ).alpha = 1; // text
			}
			else
			{
				sprite.getChildAt( 1 ).visible = true;
			}		
		}
	}

	private function _eventMouseOut( e:MouseEvent ):Void
	{
		var sprite:Sprite = e.target;		
		if( Std.is( sprite, TextField ) )
		{
			var obj:Dynamic = sprite.parent;
			if( obj.parent.get( "type" ) == "building" )
			{
				sprite.parent.parent.getChildAt( 1 ).visible = false;
				sprite.parent.parent.getChildAt( 2 ).alpha = 0;	
			}
			else
			{
				sprite.parent.parent.getChildAt( 1 ).visible = false;
				sprite.parent.parent.getChildAt( 2 ).visible = false;
			}	
		}
		else
		{	
			var obj:Dynamic = e.target;
			if( obj.get( "type" ) == "building" )
			{
				sprite.getChildAt( 1 ).visible = false;
				sprite.getChildAt( 2 ).alpha = 0;
			}
			else
			{
				sprite.getChildAt( 1 ).visible = false;
				sprite.getChildAt( 2 ).visible = false;
			}			
		}
	}

	private function _eventMouseDown( e:MouseEvent ):Void
	{
		var sprite:Sprite = e.target;
		if( Std.is( sprite, TextField ) )
			sprite.parent.parent.getChildAt( 2 ).visible = true;
		else
			sprite.getChildAt( 2 ).visible = true;

	}

	private function _eventMouseUp( e:MouseEvent ):Void
	{
		var sprite:Sprite = e.target;
		var entity:Dynamic = e.target;
		if( Std.is( sprite, TextField ) )
		{
			sprite.parent.parent.getChildAt( 2 ).visible = false;			
		}
		else
		{
			sprite.getChildAt( 2 ).visible = false;
		}
	}

	public function new( parent:Game ):Void
	{
		this._parent = parent;
		this._eventListeners = new Array();
	}

	public function addEvent( name:String, object:Sprite ):Void
	{
		switch( name )
		{
			case "startSceneStartButton", "startSceneContinueButton", "startSceneOptionsButton", "startSceneAuthorsButton", "innWindowButtonHeroListUp",  
				 "innWindowButtonHeroListDown", "citySceneStartJourneyButton", "chooseDungeonSceneDungeonButtonA" : this._addStartSceneButton( name, object );
			case "hospital", "tavern", "academy", "recruits", "storage", "graveyard", "blacksmith", "hermit", "merchant", "questman", "fontain" : this._addCitySceneBuildings( name, object );
			default: trace( "Error in EventSystem.addEvent, type of event can't be: " + name + "." );
		}		
	}

	public function removeEvent( name:String, object:Sprite, eventName:String  ):Void
	{
		var newEvent = null;
		switch( eventName ) 
		{
			case "mCLICK": newEvent = MouseEvent.CLICK;
			case "mOUT": newEvent = MouseEvent.MOUSE_OUT;
			case "mOVER": newEvent = MouseEvent.MOUSE_OVER;
			case "mUP": newEvent = MouseEvent.MOUSE_UP;
			case "mDOWN": newEvent = MouseEvent.MOUSE_DOWN;
		}
		//remove all; { "name": "button1", "events": [ { "event": MouseEvent.CLICK, "eventFunction": this._buttonClick } ] };
		for( i in 0...this._eventListeners.length ) 
		{
			var listener = this._eventListeners[ i ];
			if( name == listener.name )
			{
				var array:Array<Dynamic> = listener.events;
				for( j in 0...array.length )
				{
					if( newEvent == null )
						object.removeEventListener( array[ j ].event, array[ j ].eventFunction );
					else if( newEvent == array[ j ].event )
					{
						object.removeEventListener( array[ j ].event, array[ j ].eventFunction );
						listener.events.splice( j, 1 );
						break;
					}
				}
				this._eventListeners.splice( i, 1 ); //remove object totally;
				break;
			}
		}
	}
}