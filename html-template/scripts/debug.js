/* 	
	Writes out external interface and output forms.
	Include in your HTML page using the following:
	<script type="text/javascript" src="../js/debug.js"></script>
*/

document.write('<form action="" id="debug" method="post">');
document.write('<fieldset style="display: block; border: 1px solid #000; width: 220px; height: 210px; float: left; padding: 10px; margin-right: 5px;">');
document.write('<legend style="font-family: arial, sans-serif; font-weight: bold; color: #000;">EXTERNAL INTERFACE</legend>');
document.write('<p><label for="command" style="font-family: verdana, sans-serif; font-size: small;">Command:</label>');
document.write('<br /><input type="text" id="command" style="border:1px solid #000; width: 200px; font-family: verdana, sans-serif; font-size: small; color: #ff0000;" /></p>');
document.write('<p><label for="params" style="font-family: verdana, sans-serif; font-size: small;">Params (comma separated):</label>');
document.write('<br /><input type="text" id="params" style="border:1px solid #000; width: 200px; font-family: verdana, sans-serif; font-size: small; color: #ff0000;" /></p>');
document.write('<p><input type="button" value="Submit" onclick="externalInterfaceTest()" style="border:1px solid #000; background: #fff;" />');
document.write(' <input type="reset" value="Reset" style="border:1px solid #000; background: #fff;" /></p>');
document.write('</fieldset>');
document.write('</form>');
document.write('<form action="" method="post">');
document.write('<fieldset style="display: block; border: 1px solid #000; width: 670px; height: 210px; float: left; padding: 10px; margin-left: 0px;">');
document.write('<legend style="font-family: arial, sans-serif; font-weight: bold; color: #000;">OUTPUT</legend>');
document.write('<br /><textarea id="output" cols="10" rows="6" value="" style="border:1px solid #000; width: 650px; font-family: verdana, sans-serif; font-size: small; color: #ff0000;"></textarea>');
document.write('<p><input type="reset" value="Clear" style="border:1px solid #000; background: #fff;" /></p>');
document.write('</fieldset>');
document.write('</form>');