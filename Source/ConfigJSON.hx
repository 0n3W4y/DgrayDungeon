class ConfigJSON {
  // path is relative to where haxe is executed
 	 macro public static function json( path : String ) {
    var value = sys.io.File.getContent( path ),
        json = haxe.Json.parse( value );
    return macro $v{json};
  }
}