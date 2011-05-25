package net.uk.sweet.flog.view
{
    import flash.events.Event;
    
    import net.uk.sweet.flog.model.*;
    import net.uk.sweet.model.*;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;	
	
    /**
     * Base class for mediators containing cached references to common 
	 * proxies and utilities.
     */
    public class BaseMediator extends Mediator implements IMediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = 'BaseMediator';
		
		protected var settings:Settings;
		protected var dictionary:Dictionary;		

		protected var dataProxy:ApplicationDataProxy;
		protected var libraryProxy:LibraryProxy;
		protected var styleSheetProxy:StyleSheetProxy;
		protected var externalInterfaceProxy:ExternalInterfaceProxy;
		
        /**
         * Constructor. 
         */
        public function BaseMediator(mediatorName:String = null, viewComponent:Object = null) 
        {
            // pass the viewComponent to the superclass where 
            // it will be stored in the inherited viewComponent property
            super(mediatorName, viewComponent);
        }
		
		override public function onRegister():void 
		{
			super.onRegister();
			
			settings = Settings.getInstance();
			dictionary = Dictionary.getInstance();
			
			dataProxy = facade.retrieveProxy(ApplicationDataProxy.NAME) as ApplicationDataProxy;
			libraryProxy = facade.retrieveProxy(LibraryProxy.NAME) as LibraryProxy;
			styleSheetProxy = facade.retrieveProxy(StyleSheetProxy.NAME) as StyleSheetProxy;
			externalInterfaceProxy = facade.retrieveProxy(ExternalInterfaceProxy.NAME)	
													as ExternalInterfaceProxy;
		}
    }
}