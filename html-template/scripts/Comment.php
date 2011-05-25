<?php

require_once("utils/DatabaseConnection.php");

class Comment
{
	var $db;
	
	// mysql details
	var $dbname  = "flog";
	var $dbtable = "guestbook"; // for AddEntry (table varies for GetEntries)
	
	// Class constructor
	function Comment()
	{
		// connect to the database
	    $this -> db = new DatabaseConnection($this -> dbname);
	}

	/**
		Adds an entry to the guestbook database according to the supplied parameters

		Parameters:
				the name supplied by the user
				the message supplied by the user

		Returns:	1 if query was successful
	*/
	function AddEntry($name, $message) 
	{
		// prepare the parameters	
		$name = addslashes($name);
		$message = addslashes($message);

		// construct the query
		$query = sprintf("INSERT INTO %s (id, name, message, date) VALUES ('', '%s', '%s', NOW())", $this -> dbtable, $name, $message);
		
		// returns 1 if query was successful
		echo @mysql_query($query);
	}
}

$name = $_POST['name'];
$message = $_POST['message'];

if ($name && $message)
{
	$updater = new Comment();
	$updater -> AddEntry($name, $message);
}
else
{
	echo "0";
}
?>
