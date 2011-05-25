/**
 * Manages the load of asynchronous startup resources 
 * using the PureMVC startup manager.
 */

package net.uk.sweet.flog.controller 
{
	import flash.display.Stage;
	
	import org.puremvc.as3.interfaces.ICommand;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    import org.puremvc.as3.utilities.startupmanager.model.StartupResourceProxy;
    import org.puremvc.as3.utilities.startupmanager.model.StartupMonitorProxy;
    import org.puremvc.as3.utilities.startupmanager.interfaces.IStartupProxy;
	
	import net.uk.sweet.flog.model.*;
    import net.uk.sweet.flog.view.StageMediator;

    public class StartupCommand extends SimpleCommand implements ICommand 
    {
        private var _monitor:StartupMonitorProxy;
		
		override public function execute(note:INotification):void    
        {
			// pass view component to new instance of stage mediator and register with app
			var stage:Stage = note.getBody() as Stage;
			facade.registerMediator(new StageMediator(stage));
			
			// create new startup proxy and register with app
			facade.registerProxy(new StartupMonitorProxy());
            _monitor = facade.retrieveProxy(StartupMonitorProxy.NAME) as StartupMonitorProxy;
            //_monitor.defaultTimeout = 30;
			
			// create and register new instances of startup proxies
			var applicationDataProxy:ApplicationDataProxy = new ApplicationDataProxy();
			var loggerProxy:LoggerProxy = new LoggerProxy();
			var styleSheetProxy:StyleSheetProxy = new StyleSheetProxy();
			var fontProxy:FontProxy = new FontProxy();
			var mediaDataProxy:MediaDataProxy = new MediaDataProxy();
			var guestbookDataProxy:GuestbookDataProxy = new GuestbookDataProxy();
			var libraryProxy:LibraryProxy = new LibraryProxy();
			var externalInterfaceProxy:ExternalInterfaceProxy = new ExternalInterfaceProxy();
			
			facade.registerProxy(applicationDataProxy);			
			facade.registerProxy(loggerProxy);			
			facade.registerProxy(styleSheetProxy);
			facade.registerProxy(fontProxy);
			facade.registerProxy(mediaDataProxy);
			facade.registerProxy(guestbookDataProxy);
			facade.registerProxy(libraryProxy);
			facade.registerProxy(externalInterfaceProxy);
			
			// create supporting proxies required by the start up manager
			// these proxies only have relevance within the scope of start up
			// elsewhere in the application the main proxies should be used
			var rApplicationDataProxy:StartupResourceProxy = makeAndRegisterStartupResource(ApplicationDataProxy.SRNAME, applicationDataProxy);
			var rLoggerProxy:StartupResourceProxy = makeAndRegisterStartupResource(LoggerProxy.SRNAME, loggerProxy);
			var rStyleSheetProxy:StartupResourceProxy = makeAndRegisterStartupResource(StyleSheetProxy.SRNAME, styleSheetProxy);
			var rFontProxy:StartupResourceProxy = makeAndRegisterStartupResource(FontProxy.SRNAME, fontProxy);
			var rMediaDataProxy:StartupResourceProxy = makeAndRegisterStartupResource(MediaDataProxy.SRNAME, mediaDataProxy);
			var rGuestbookDataProxy:StartupResourceProxy = makeAndRegisterStartupResource(GuestbookDataProxy.SRNAME, guestbookDataProxy);
			var rLibraryProxy:StartupResourceProxy = makeAndRegisterStartupResource(LibraryProxy.SRNAME, libraryProxy);
			var rExternalInterfaceProxy:StartupResourceProxy = makeAndRegisterStartupResource(ExternalInterfaceProxy.SRNAME, externalInterfaceProxy);
			//var rKulerProxy:StartupResourceProxy = makeAndRegisterStartupResource(KulerProxy.SRNAME, kulerProxy);
			
			// define dependencies to ensure an asynchronous load of application assets
			rLoggerProxy.requires 					= [ rApplicationDataProxy ];
			rStyleSheetProxy.requires 				= [ rLoggerProxy ];
			rFontProxy.requires 					= [ rStyleSheetProxy ];
			rMediaDataProxy.requires				= [ rFontProxy ];
			rGuestbookDataProxy.requires			= [ rMediaDataProxy ];
			rLibraryProxy.requires					= [ rGuestbookDataProxy ];
			rExternalInterfaceProxy.requires		= [ rLibraryProxy ];
			
			// start load
			_monitor.loadResources();
        }
		
		// helper method for creating and registering start up resource proxies
		private function makeAndRegisterStartupResource(proxyName:String, appResourceProxy:IStartupProxy):StartupResourceProxy 
		{
            var r:StartupResourceProxy = new StartupResourceProxy(proxyName, appResourceProxy);
            facade.registerProxy(r);
            _monitor.addResource(r);
			
            return r;
        }
    }
}