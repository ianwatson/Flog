package net.uk.sweet.flog.model 
{

    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;
    import org.puremvc.as3.utilities.startupmanager.model.StartupResourceProxy;
	
    import net.uk.sweet.flog.ApplicationFacade;
  
    public class EntityProxy extends Proxy implements IProxy
    {
        public function EntityProxy(name:String) 
		{
            super(name);
        }

        protected function sendLoadedNotification(noteName:String, noteBody:String, srName:String):void 
		{
            var srProxy:StartupResourceProxy = facade.retrieveProxy(srName) as StartupResourceProxy;
            if (!srProxy.isTimedOut())
			{
                sendNotification(noteName, noteBody, srName);
			}
        }

    }
}