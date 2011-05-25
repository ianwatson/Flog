<?php

// import flickr api wrapper
require_once("phpFlickr-2.3.0.1/phpFlickr.php");
require_once("utils/DatabaseConnection.php");

class UpdateFlickrData
{
	var $f;
	var $db;

	// flickr details
	var $flickr_key = "f8f8f7e024420735cee8fc587b681d00";
	var $flickr_user = "net.uk.sweet";
	var $flickr_tags = ""; // expand by comma delimited

	// database details
	var $dbname  = "flog";
	var $dbtable = "photos"; 

	function UpdateFlickrData()
	{
		// create an instance of the flickr api wrapper
		$this -> f = new phpFlickr($this -> flickr_key);

		// connect to the database
	        $this -> db = new DatabaseConnection($this -> dbname);
		
		// remove all records from the table
		$query = sprintf("TRUNCATE TABLE %s", $this -> dbtable);
		@mysql_query($query);
	}

	/**
		Retrieves required data from flickr and writes it to the database

		Returns:	1 if query was successful
	*/
	function GetData() 
	{
		// Find the NSID based on supplied username
		$person = $this -> f -> people_findByUsername($this -> flickr_user);
		// Return photographs by supplied username matching supplied tags
		$photos = $this -> f -> photos_search(array("user_id" => $person["id"],"tags" => $this -> flickr_tags, 
								"tag_mode" => "all", "per_page" => "100"));

		//$photos = $this -> f -> photos_search(array("user_id" => $person["id"], "per_page" => "100"));
		//$photos = $f -> people_getPublicPhotos($person[id], NULL, 3);
		
		// Loop through the photos and output the html
		foreach ((array)$photos["photo"] as $photo) 
		{
			$photos_info = $this -> f -> photos_getInfo($photo["id"], $photo["secret"]);
			
			$title = addslashes($photos_info["title"]);
			$photo = $this -> f -> buildPhotoURL($photo);
			$page = $photos_info["urls"]["url"]["0"]["_content"];
			$date = $photos_info["dates"]["taken"];
	
			// and .. write to database
			$query = sprintf("INSERT INTO %s (id, title, photo, page, date) VALUES ('', '%s', '%s', '%s', '%s')", 
						$this -> dbtable, $title, $photo, $page, $date);
			
			// query failed, return a 0
			if (!@mysql_query($query)) return 0;
		}

		// queries were all successful
		return 1;
	}
}

$data = new UpdateFlickrData();
echo($data -> GetData());
?>
