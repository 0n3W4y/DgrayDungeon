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

	private function _createWindowButtonType( id:String, type:String, name:String,  params:Dynamic ):Entity
	{
		var uiObject:Entity = new Entity( this, id, type, name );
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

	private function _createBuilding( id:String, type:String, name:String, params:Dynamic ):Entity
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

	private function _generateHeroParams():Dynamic
	{
		var heroList:Array<String> = new Array();
		for( key in Reflect.fields( this._config.hero) )
		{
			heroList.push( key );
		}

		var randomHeroNum = Math.floor( Math.random() * ( heroList.length ) ); // heroList.length - 1 + 1 ;
		var heroName = heroList[ randomHeroNum ];
		var rarityNum = Math.floor( Math.random() * 100 ); // 0 - 65%, 1 - 20%, 2 - 10%, 3 - 5%
		var rarity:Int = 0;
		if( rarityNum < 10 )
			rarity = 2;
		else if( rarityNum >= 75 && rarityNum < 95 )
			rarity = 1;
		else if( rarityNum >= 95 )
			rarity = 3;
		var params:Dynamic = { "rarity": rarity, "name": heroName };
		return params;
	}

	private function _createHero( id:String, type:String, name:String, params:Dynamic ):Entity
	{
		if( params == null )
			params = this._generateHeroParams();

		if( name == null )
			name = params.name;

		var hero = new Entity( null, id, type, name );
		var config:Dynamic = this._config.hero;
		var heroType:Int = params.rarity; // "common"-0, "uncommon"-1, "rare"-2, "legendary"-3;
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
				case "event": component = this.createComponent( num, value );
				case "name": 
				{
					var names:Array<String> = [ "Alex", "Sally", "Edward", "Bob", "Alice", "Odry", "Cooper", "Ann" ];
					var surnames:Array<String> = [ "Oldrich", "Slowpoke", "Duckman", "Smith", "Oldman", "Cage", "Travolta", "Parker", "Stark", "Anderson" ];
					var newName:String = names[ Math.floor( Math.random() * names.length ) ];
					var newSurname:String = surnames[ Math.floor( Math.random() * surnames.length ) ];
					// genderNames;
					var nameConfig:Dynamic = 
					{
						"name": newName,
						"surname": newSurname,
						"rank": null,
						"type": name,
						"rarity": value.rarity[ heroType ]
					};
					//TODO: Generate name;
					component = this.createComponent( num, nameConfig );
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
					var traitConfig:Dynamic = this._config.trait;
					component = this.createComponent( num, traits );

				};
				case "skills":
				{
					var maxActive = value.active.maxActiveSkills[ heroType ];
					var maxPassive = value.passive.maxPassiveSkills[ heroType ];
					var maxCamping = value.camping.maxCampingSkills[ heroType ];
					var skills = 
					{
						"maxActiveSkills": maxActive,
						"maxStaticActiveSkills": value.active.maxStaticActiveSkills[ heroType ],
						"maxPassiveSkills": maxPassive,
						"maxStaticPassiveSkills": value.passive.maxStaticPassiveSkills[ heroType ],
						"maxCampingSkills": maxCamping,
						"maxStaticCampingSkills": value.camping.maxStaticCampingSkills[ heroType ]
					}
					component = this.createComponent( num, skills );

					//generate skills into component;
					for( k in 0...2 )
					{
						var list:Dynamic = value.active.skills;
						var maxSkills:Int = maxActive;
						var typeSkill:String = "active";
						if( k == 1 )
						{
							list = value.passive.skills;
							typeSkill = "passive";
							maxSkills = maxPassive;
						}

						var arrayList:Array<String> = new Array();
						for( key in Reflect.fields( list ) )
						{
							if( key == "basic" ) // need to use basic skill always;
								continue;
							arrayList.push( key ); // [ "skill1", "skill2", "skill3" ];
						}
						var dif = arrayList.length - maxSkills;// find diffirence from array to max skills;

						for( j in 0...dif )// try to cut random skills from array of skills;
						{
							var randomNum = Math.floor( Math.random() * arrayList.length );
							arrayList.splice( randomNum, 1 );
						}
						if( k == 0 )
							arrayList.push( "basic" ); // add basic skill back;

						for( i in 0...arrayList.length )// create skills;
						{
							var skill = Reflect.getProperty( list, arrayList[ i ] );
							var newSkill = 
							{
								"name": skill.name,
								"isChoosen": false,
								"isStatic": false,
								"upgradeLevel": 0,
								"onCooldawn": 0,
								"maxUpgradeLevel": skill.maxUpgradeLevel,
								"value": skill.upgradeValue.value[ 0 ], //upgradeLevel = 0;
								"type": skill.upgradeValue.type,
								"effect": skill.upgradeValue.effect,
								"removeEffect": skill.upgradeValue.removeEffect,
								"valueType": skill.upgradeValue.valueType,
								"action": skill.upgradeValue.action,
								"targetStat": skill.upgradeValue.targetStat, 
								"duration": skill.upgradeValue.duration[ 0 ],
								"cooldawn": skill.upgradeValue.cooldawn[ 0 ],
								"target": skill.upgradeValue.target[ 0 ]							
							};
							component.addSkill( newSkill, typeSkill );
						}
					}

					var listOfCamping = value.camping.skills;

					
				}
				default : trace( "Error in EntitySystem._heroConfig, no key with name: " + num + ", in container with heroType: " + heroType );
			}
			this.addComponentTo( component, hero );
		}

		//Test for console.
		//trace( hero.get( "name" ) + "; " + hero.get( "type" ) + "; " + hero.getComponent( "name" ).get("fullName") + "; " + hero.getComponent( "name" ).get("rarity") );
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
			case "window", "button" : return this._createWindowButtonType( id, type, name, params );
			case "building" : return this._createBuilding( id, type, name, params );
			case "hero": return this._createHero( id, type, name, params );
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
			case "event": component = new Event( null, id, params );
			default: trace( "Error in EntitySystem.createComponent, component with name: '" + componentName + "' does not exist." );
		}
		return component;
	}

	public function addEntityToScene( entity:Entity, scene:Scene ):Void
	{
		entity.setParent( scene );
		var type = entity.get( "type" );
		switch( type )
		{
			case "window": scene.getEntities( "ui" ).window.push( entity );
			case "button": scene.getEntities( "ui" ).button.push( entity );
			case "building": scene.getEntities( "object" ).building.push( entity );
			case "hero": scene.getEntities( "alive" ).hero.push( entity );
			case "enemy": scene.getEntities( "alive" ).enemy.push( entity );
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

	public function getConfig():Dynamic
	{
		return this._config;
	}
}