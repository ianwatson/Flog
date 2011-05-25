package net.uk.sweet.flog.controller 
{
	import net.uk.sweet.flog.ApplicationFacade;
	import net.uk.sweet.flog.model.GuestbookDataProxy;
	import net.uk.sweet.flog.model.enum.ExternalInterfaceTypes;
	import net.uk.sweet.flog.model.vo.GuestbookVO;
	import net.uk.sweet.utils.Logger;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	/**
	 * 
	 */
    public class ExternalInterfaceReceiveCommand extends SimpleCommand implements ICommand 
    {
		override public function execute(note:INotification):void    
        {
			var data:* = note.getBody();
//			Logger.output("Command received: " + data.command);
			switch (data.command)
			{
				// TODO: should be an enum class for all commands sent and received
				case ExternalInterfaceTypes.OVERLAY_CLOSED:
				{
					sendNotification(ApplicationFacade.RESET);
					break;
				}
				
				case ExternalInterfaceTypes.COMMENT_POSTED:
				{
//					Logger.output(data.params[0] + " " + data.params[1]);/**/
					var guestbookProxy:GuestbookDataProxy = GuestbookDataProxy(
						facade.retrieveProxy(GuestbookDataProxy.NAME));
					
					var guestbookVO:GuestbookVO = guestbookProxy.getItem(
						data.params[0], 
						data.params[1]
					);
					
					sendNotification(ApplicationFacade.ADD_GUESTBOOK_ITEM, guestbookVO);
					break;
				}
				
				case ExternalInterfaceTypes.PAUSE:
				{
					sendNotification(ApplicationFacade.PAUSE);
					break;
				}
					
				case ExternalInterfaceTypes.RESTART:
				{
					sendNotification(ApplicationFacade.RESTART);
					break;
				}
					
				default: 
				{
					Logger.output("ExternalInterfaceSendCommand.execute(): command " + data.command + " not recognised: ");
				}
			}
		}
    }
}