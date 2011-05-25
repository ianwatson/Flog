package com.lassie.lib
{
    public interface IMediaLibrary
    {
        function get contents():Array;
        function getAsset(className:String):*;
		function getAssetClass(className:String):Class;
    }
}