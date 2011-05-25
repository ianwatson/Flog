package net.uk.sweet.flog.controller 
{
	import org.puremvc.as3.interfaces.ICommand;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;

	import net.uk.sweet.flog.model.InitVarsProxy;

    public class InitVarsCommand extends SimpleCommand implements ICommand 
    {
		override public function execute(note:INotification):void    
        {
			//trace("InitVarsCommand.execute(): ");
			var flashVars:Object = note.getBody() as Object;
			
			facade.registerProxy(new InitVarsProxy(InitVarsProxy.NAME, flashVars));
        }
    }
}