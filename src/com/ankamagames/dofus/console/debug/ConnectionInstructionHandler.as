package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   
   public class ConnectionInstructionHandler implements ConsoleInstructionHandler
   {
      public function ConnectionInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         switch(param2)
         {
            case "connectionstatus":
               param1.output("" + (!!ConnectionsHandler.getConnection() ? ConnectionsHandler.getConnection() : "There is currently no connection."));
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "connectionstatus":
               return "Print the status of the current connection (if any).";
            default:
               return "No help for command \'" + param1 + "\'";
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         return [];
      }
   }
}

