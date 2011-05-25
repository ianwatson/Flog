<?php

class Contact
{
	var $recipient = "ian@sweet.uk.net";
	var $subject = "Message from Flog!";

	function Contact()
	{
	
	}

	function SendMessage($name, $email, $message)
	{
		$mail_header  = "From: $name <$email>\n";
		$mail_header .= "Reply-To: $name <$email>\n";
		$mail_header .= "X-Mailer: PHP/ $version\n";
		$mail_header .= "X-Priority: 1";	

		$mail_to = $this -> recipient;
		$mail_subject = $this -> subject;
		$mail_body = $message . "\n" . $email;

		/*
		if (mail($mail_to, $mail_subject, $mail_body, $mail_header))
		{
			echo "1";
		}
		else
		{
			echo "0";
		}
		*/
		
		//echo($mail_header . "\n");
		//echo($mail_body . "\n");	
		echo "1";
	}
}


$name = $_POST['name'];
$email = $_POST['email'];
$message = $_POST['message'];

if ($name && $email && $message) 
{
	$mailer = new Contact();
	$mailer -> SendMessage($name, $email, $message);
} 
else 
{
	echo("0");
}
?>
