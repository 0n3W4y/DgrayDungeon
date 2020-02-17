package;

import Window;

typedef StateConfig =
{
	var Parent:Game;
}

class State
{
	private var _parent:Game;


	public inline function new( config:StateConfig ):Void
	{
		this._parent = config.Parent;
	}

	public function init( error:String ):Void
	{

	}

	public function postInit():Void
	{

	}

	public function get( value:String ):Dynamic
	{
		switch( value )
		{
			case "parent": return this._parent;
			default: throw 'Error in State.get. No "$value" found.';
		}
	}

	public function openWindow( value:String ):Void
	{
		switch( value )
		{
			case "recruit": this._openRecruitWindow();
			default: throw 'Error in State.openWindow. No action for $value';
		}
	}

	public function closeWindow( value:String ):Void
	{
		switch( value )
		{
			case "citySceneMain": this._closeCitySceneMainWindow();
			default: throw 'Error in State.closeWindow. No action for $value';
		}
	}

	public function startGame():Void
	{
		var sceneSystem:SceneSystem = this._parent.getSystem( "scene" );
		var player:Player = this._parent.createPlayer( 100 , "test player" );

		var scene:Scene = sceneSystem.createScene( 1001 );
		sceneSystem.prepareScene( scene );
		sceneSystem.changeSceneTo( scene );

	}


	//PRIVATE

	private function _openRecruitWindow():Void
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var deployIdRecruitWindow:WindowDeployID = WindowDeployID( 3002 );
		var deployIdMainWindow:WindowDeployID = WindowDeployID( 3001 );
		ui.showUiObject( deployIdMainWindow );
		ui.showUiObject( deployIdRecruitWindow );
	}

	private function _closeCitySceneMainWindow():Void
	{
		var ui:UserInterface = this._parent.getSystem( "ui" );
		var deployIdMainWindow:WindowDeployID = WindowDeployID( 3001 );
		ui.hideUiObject( deployIdMainWindow );
	}

}
