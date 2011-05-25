package net.uk.sweet.flog.controller 
{
	import net.uk.sweet.external.ExternalInterfaceData;
	import net.uk.sweet.flog.ApplicationFacade;
	import net.uk.sweet.flog.interfaces.ICloudVO;
	import net.uk.sweet.flog.model.ApplicationDataProxy;
	import net.uk.sweet.flog.model.ExternalInterfaceProxy;
	import net.uk.sweet.flog.model.MediaDataProxy;
	import net.uk.sweet.flog.model.enum.ItemTypes;
	import net.uk.sweet.flog.model.vo.GuestbookVO;
	import net.uk.sweet.flog.model.vo.MediaVO;
	import net.uk.sweet.flog.view.components.InteractiveText3D;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
    public class ZoomCompletedCommand extends SimpleCommand implements ICommand 
    {
		override public function execute(note:INotification):void    
        {	
			var dataProxy:ApplicationDataProxy = ApplicationDataProxy(
				facade.retrieveProxy(ApplicationDataProxy.NAME));
			
			var externalProxy:ExternalInterfaceProxy = ExternalInterfaceProxy(
				facade.retrieveProxy(ExternalInterfaceProxy.NAME));
			
			var selectedItem:ICloudVO = dataProxy.selectedItem;
			var data:ExternalInterfaceData;
			
			if (selectedItem.type == ItemTypes.PHOTOS)
			{
				//trace("ItemClickedCommand.execute(): image: " + proxy.selectedItem.path);
				data = new ExternalInterfaceData(ItemTypes.PHOTOS
					, [MediaVO(selectedItem).path
						, selectedItem.title]);
			}
			else
			{
				// gonna need a diferent overlay style for this bad ass
				data = new ExternalInterfaceData(ItemTypes.GUESTBOOK
					, [GuestbookVO(selectedItem).message
						, selectedItem.title]);
			}
			
			externalProxy.send(data);
 	     }
    }
}