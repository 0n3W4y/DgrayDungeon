package;

class EntitySystem
{
	private var _parent:Game;
	private var _nextId:Int = 0;
	private var _config:Dynamic;


	private function _createId():String
	{
		var id = "" + this._nextId;
		this._nextId++;
		return id ;
	}

	private function _createUiType( type:String, name:String, id:String, params:Dynamic ):Entity
	{
		var uiObject = new Entity( this, id, type, name );
		var config:Dynamic = this._config.window;
		if( type == "button" )
			config = this._config.button;

		var uiObjectConfig:Dynamic = null;
		for( obj in Reflect.fields( config ) )
		{
			if( obj == name )
			{
				uiObjectConfig = Reflect.getProperty( config, obj );
				break;
			}
		}

		for( key in Reflect.fields( uiObjectConfig ) )
		{
			var value = Reflect.getProperty( uiObjectConfig, key );
			var component = this.createComponent( key, value );
			this.addComponentTo( component, uiObject );
		}
		return uiObject;
	}

	private function _createBuilding( type:String, name:String, id:String, params:Dynamic ):Entity
	{
		var building = new Entity( this, id, type, name );
		var config:Dynamic = this._config.building;
		var buildingConfig:Dynamic = null;
		for( obj in Reflect.fields( config ) )
		{
			if( obj == name )
			{
				buildingConfig = Reflect.getProperty( config, obj );
				break;
			}
		}

		for( key in Reflect.fields( buildingConfig ) )
		{
			var value = Reflect.getProperty( buildingConfig, key );
			var component = this.createComponent( key, value );
			this.addComponentTo( component, building );
		}


		return building;
	}

	private function _createHero( type:String, name:String, id:String, params:Dynamic ):Entity
	{
		var hero = new Entity( null, id, type, name );
		var config:Dynamic = this._config.heroes;
		var traitConfig:Dynamic = this._config.trait;
		var skillConfig:Dynamic = this._config.skill;
		var heroType:Int = 0; // "common"
		switch( params.rarity )
		{
			case "uncommon": heroType = 1; // "uncommon", 
			case "rare": heroType = 2; //"rare", 
			case "legendary": heroType = 3; //"legendary"
		}

		var heroConfig:Dynamic = null;
		var heroTypeConfig:Dynamic = null;
		var skill:Dynamic = null;
		var trait:Dynamic = null;

		for( key in Reflect.fields( config ) )
		{
			if( key == name )
			{
				heroConfig = Reflect.getProperty( config, key );
				break;
			}
		}

		for( num in Reflect.fields( heroConfig ) )
		{
			var value:Dynamic = Reflect.getProperty( heroConfig, num );
			var component:Dynamic = null;
			switch( num )
			{
				case "name": 
				{
					var names:Array<String> = [ "Alex", "Sally", "Edward", "Bob", "Alice", "Odry", "Cooper", "Ann" ];
					var surnames:Array<String> = [ "Oldrich", "Slowpoke", "Duckman", "Smith", "Oldman", "Cage", "Travolta", "Parker", "Stark", "Anderson" ];
					var newName:String = names[ Math.floor( Math.random() * names.length ) ];
					var newSurname:String = surnames[ Math.floor( Math.random() * surnames.length ) ];
					// genderNames;
					var name:Dynamic = 
					{
						"name": newName,
						"surname": newSurname,
						"rank": null,
						"type": "Crossbowman",
						"rarity": value.rarity[ heroType ]
					};
					//TODO: Generate name;
					component = this.createComponent( num, name );
				}
				case "experience":
				{
					var experience:Dynamic = 
					{
						"lvl": 1,
						"exp": 0,
						"expToNextLvl": value.expToNextLvl[ heroType ],
						"maxLvl": 10
					};
					component = this.createComponent( num, experience );
				}
				case "inventory":
				{
					component = this.createComponent( num, value );
				}
				case "graphics":
				{
					//TODO: Do some graphics for hero rarity;
					component = this.createComponent( num, value );
				}
				case "stats":
				{
					var stats = 
					{
						"hp": value.hp[ heroType ],
						"acc": value.acc[ heroType ],
						"ddg": value.ddg[ heroType ], 
						"cc": value.cc[ heroType ],
						"def": value.def[ heroType ],
						"dmg": value.dmg[ heroType ],
						"spd": value.spd[ heroType ],
						"cd": value.cd[ heroType ],
						"stress": value.stress[ heroType ],
						"stun": value.stun[ heroType ],
						"poison": value.poison[ heroType ],
						"bleed": value.bleed[ heroType ],
						"diseas": value.diseas[ heroType ],
						"debuff": value.debuff[ heroType ],
						"move": value.move[ heroType ],
						"fire": value.fire[ heroType ],
						"upHp": value.upHp[ heroType ],
						"upAcc": value.upAcc[ heroType ],
						"upDdg": value.upDdg[ heroType ], 
						"upCc": value.upCc[ heroType ],
						"upDef": value.upDef[ heroType ],
						"upDmg": value.upDmg[ heroType ],
						"upSpd": value.upSpd[ heroType ],
						"upCd": value.upCd[ heroType ],
						"upStress": value.upStress[ heroType ],
						"upStun": value.upStun[ heroType ],
						"upPoison": value.upPpoison[ heroType ],
						"upBleed": value.upBleed[ heroType ],
						"upDiseas": value.upDiseas[ heroType ],
						"upDebuff": value.upDebuff[ heroType ],
						"upMove": value.upMove[ heroType ],
						"upFire": value.upFire[ heroType ],
						"position": value.position[ heroType ],
						"target": value.target[ heroType ]
					};
					component = this.createComponent( num, stats );
				};
				case "traits":
				{
					var traits = 
					{
						"maxNumOfPositive": value.maxNumOfPositive[ heroType ],
						"maxNumOfNegative": value.maxNumOfNegative[ heroType ],
						"maxNumOfPositiveStatic": value.maxNumOfPositiveStatic[ heroType ],
						"maxNumOfNegativeStatic": value.maxNumOfNegativeStatic[ heroType ]
					}
					// TODO: generate traits and add it to component;
					component = this.createComponent( num, traits );

				};
				case "skills":
				{
					var skills = 
					{
						"active":
						{
							"maxActiveSkills": value.active.maxActiveSkills[ heroType ],
							"maxStaticActiveSkills": value.active.maxStaticActiveSkills[ heroType ]
						},
						"passive":
						{
							"maxPassiveSkills": value.passive.maxPassiveSkills[ heroType ],
							"maxStaticPassiveSkills": value.passive.maxStaticPassiveSkills[ heroType ]
						},
						"camping":
						{

						}
					}
					//TODO: generate skills, and add it to component;
					component = this.createComponent( num, skills );
				}
				default : trace( "Error in EntitySystem._heroConfig, no key with name: " + num + ", in container with heroType: " + heroType );
			}
			this.addComponentTo( component, hero );
		}

		for( obj in Reflect.fields( skillConfig ) )
		{
			if( obj == name )
			{
				skill = Reflect.getProperty( skillConfig, obj );
				break;
			}
		}

		for( box in Reflect.fields( traitConfig ) )
		{
			if( box == name )
			{
				trait = Reflect.getProperty( traitConfig, box );
				break;
			}
		}

		//Test for console.
		trace( hero.get( "name" ) + "; " + hero.get( "type" ) + "; " + hero.getComponent( "name" ).get("fullName") + "; " + hero.getComponent( "name" ).get("rarity") );
		//trace( hero.getComponent( "inventory").getInventory() );
		return hero;
	}

	public function new( parent:Game, params:Dynamic ):Void
	{
		this._parent = parent;
		this._config = params;
	}

	public function createEntity( type:String, name:String, params:Dynamic ):Entity
	{
		var id = this._createId();
		switch( type )
		{
			case "window", "button" : return this._createUiType( type, name, id, params );
			case "building" : return this._createBuilding( type, name, id, params );
			case "hero": return this._createHero( type, name, id, params );
			default: trace( "Error in EntitySystem.createEntity, can't find entity with type: " + type + "." );
		};
		return null;
	}

	public function addComponentTo( component:Component, entity:Entity ):Void
	{
		entity.addComponent( component );
	}

	public function createComponent( componentName:String, params:Dynamic ):Component
	{
		var id = this._createId();
		var component:Component = null;
		switch( componentName )
		{
			case "graphics": component = new Graphics( null, id, params );
			case "ui": component = new UI( null, id, params );
			case "name": component = new Name( null, id, params );
			case "inventory": component = new Inventory( null, id, params );
			case "skills": component = new Skills( null, id, params );
			case "stats": component = new Stats( null, id, params );
			case "traits": component = new Traits( null, id, params );
			case "experience": component = new Experience( null, id, params );
			default: trace( "Error in EntitySystem.createComponent, component with name: '" + componentName + "' does not exist." );
		}
		return component;
	}

	public function addEntityToScene( entity:Entity, scene:Scene ):Void
	{
		var type = entity.get( "type" );
		var container = null;
		switch( type )
		{
			case "window": scene.getEntities( "ui" ).windows.push( entity );
			case "button": scene.getEntities( "ui" ).buttons.push( entity );
			case "building": container = scene.getEntities( "object" ).buildings.push( entity );
			default: trace( "Error in Scene.addEntity, can't add entity with name: " + entity.get( "name" ) + ", and type: " + type + "." );
		}
	}

	public function createEntitiesForScene( scene:Scene, type:String, list:Array<String> )
	{
		var paramsContainer = Reflect.getProperty( this._config, type );
		if(  paramsContainer == null )
			trace( "Error in EntitySystem.createEntitiesForScene, can't find type: " + type + " into config container!" );
		for( i in 0...list.length )
		{	
			var object = this.createEntity( type, list[ i ], null );
			this.addEntityToScene( object, scene );
		}
	}

	public function getHeroList():Array<String>
	{
		var heroList:Array<String> = new Array();
		for( key in Reflect.fields( _config.heroes) )
		{
			heroList.push( key );
		}
		return heroList;
	}
}