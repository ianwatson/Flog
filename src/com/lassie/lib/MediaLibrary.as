package com.lassie.lib
{
    import flash.display.MovieClip;

    public dynamic class MediaLibrary extends MovieClip implements IMediaLibrary
    {
        public function MediaLibrary():void
        {
            super();
        }

    // --------------------------------------------------
    //  Include a library media class
    // --------------------------------------------------

        public function addClass($class:Class, $path:String=""):void
        {
            if (($path.split(".")).length > 1)
            {
                this[$path] = $class;
            }
            else
            {
                var $cname:String = $class.toString();
                this[$cname.substr(7, $cname.length-8)] = $class;
            }
        }

    // --------------------------------------------------
    //  Get library contents (lists class names)
    // --------------------------------------------------

        public function get contents():Array
        {
            var classList:Array = new Array();
            for (var j:String in this)
            {
                classList.push(j);
            }
            classList.sort();
            return classList;
        }

    // --------------------------------------------------
    //  Extract library class asset
    // --------------------------------------------------

        public function getAsset(className:String):*
        {
            try
            {
                var classObj:Class = this[className];
                return new classObj();
            }
            catch(e:Error)
            {
                trace("error extracting requested class.");
            }
            return null;
        }
		
    // --------------------------------------------------
    //  Extract library class 
    // --------------------------------------------------

        public function getAssetClass(className:String):Class
        {
            try
            {
                var classObj:Class = this[className];
                return classObj;
            }
            catch(e:Error)
            {
                trace("error extracting requested class.");
            }
            return null;
        }
    }
}