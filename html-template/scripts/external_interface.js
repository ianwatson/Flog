// resolves movie using supplied id
function thisMovie(movieName) 
{
	if (navigator.appName.indexOf("Microsoft") != -1) 
	{
		return window[movieName]
	}
	else 
	{
		return document[movieName]
	}
}

// standard interface for JavaScript calls on Flash
function flashInterface(jObj)
{
	return thisMovie("flashContent").flashInterface(jObj);
}

function externalInterfaceTest()
{
	var command = document.getElementById("command").value;
	var params = document.getElementById("params").value.split(",");
	
	// remove leading and trailing whitespace from params
	for (var i = 0; i < params.length; i ++) 
	{
		params[i] = stripWhitespace(params[i]);
	}
	
	var jObj = {"command": command, "returnRequired": false, "params": params};
	flashInterface(jObj);
}

// standard interface for Flash calls on JavaScript
function javascriptInterface(jObj)
{
	//window.alert("Call made by Flash, command: " + jObj.command + ", returnRequired: " + jObj.returnRequired + ", parameters: " + jObj.params + ", webtrends: " + jObj.analytics);

	
	// pass any analytics parameters to dcsTrk method
	
	/*
	if (jObj.analytics.length>0) 
	{ 
		output("WebTrends: " + jObj.analytics[0]); 
	}
	else
	{
		output("Call made by Flash, command: " + jObj.command + ", returnRequired: " + jObj.returnRequired + ", parameters: " + jObj.params + ", webtrends: " + jObj.analytics);
	}
	*/
		
	//output("Call made by Flash, command: " + jObj.command + ", returnRequired: " + jObj.returnRequired + ", parameters: " + jObj.params + ", webtrends: " + jObj.analytics);
	
	switch(jObj.command)
	{	
		case "javascript_available":
		return true;
		break;
		
		case "flash_available":
		// no return required here
		// this is the hook for any applications which 
		// receive initial state via external interface
		break;
		
		case "hello_javascript":
		// do nothing, just want to stop error message below
		break;
		
		case "show_overlay":

			case "photos":
				showPhoto(jObj.params[0], jObj.params[1]);
			break;

			case "guestbook":
				showComment(jObj.params[0], jObj.params[1]);
			break;

		default:
		window.alert("Command name " + jObj.command + " not recognised");
	}
}

function updateCloud()
{
	//window.alert($('input#result').val());
/*
	if ($("input#result").val() == "true")
	{
		flashInterface({command: "comment_posted"});
	}
	*/
}

// for debug only, outputs supplied message through output field
function output(msg)
{
	document.getElementById("output").value = (msg + "\n" + document.getElementById("output").value);
}

// strips leading and trailing whitespace
// http://bytes.com/forum/thread165013.html
function stripWhitespace(str)
{
	return str.replace(/^\s*|\s*$/g, "");
}