<?php

	class DatabaseConnection
	{
		// mysql details
		var $dbhost  = "localhost";
		var $dbuser  = "root";
		var $dbpass  = "ThIu48";
		
		/*
		// won't work from localhost
		var $dbhost  = "sweetweb-5302-001.dsvr.co.uk";
		var $dbuser  = "root";
		var $dbpass  = "";
		*/		
		// Class constructor
		function DatabaseConnection($dbname)
		{
			// connect to the database
			$db = mysql_connect($this -> dbhost, $this -> dbuser);
			mysql_select_db($dbname);
			
			return $db;
		}
	}
?>
