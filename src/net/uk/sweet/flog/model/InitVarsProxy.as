/**
 * Proxy for flashVars
 */

package net.uk.sweet.flog.model 
{
    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class InitVarsProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "InitVarsProxy";

		public function InitVarsProxy(name:String = null, data:Object = null) 
		{
			super(name, data);
			
			//for (var prop in this.getData()) trace("InitVarsProxy.InitVarsProxy(): " + prop + " : " + this.getData()[prop]);
		}
	}
}