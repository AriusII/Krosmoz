package com.ankamagames.dofus.kernel.updater
{
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.approach.frames.UpdaterDialogFrame;
   import com.ankamagames.dofus.logic.game.approach.managers.PartManager;
   import com.ankamagames.dofus.misc.utils.StatisticReportingManager;
   import com.ankamagames.dofus.network.MessageReceiver;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.network.ServerConnection;
   import com.ankamagames.jerakine.utils.system.CommandLineArguments;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.utils.getQualifiedClassName;
   
   public class UpdaterConnexionHandler
   {
      private static var _self:UpdaterConnexionHandler;
      
      private static var _currentConnection:ServerConnection;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(UpdaterConnexionHandler));
      
      public function UpdaterConnexionHandler()
      {
         super();
         if(!_self)
         {
            _currentConnection = new ServerConnection();
            _currentConnection.addEventListener(IOErrorEvent.IO_ERROR,this.onIoError);
            _currentConnection.addEventListener(Event.CONNECT,this.onConnect);
            _currentConnection.handler = Kernel.getWorker();
            _currentConnection.rawParser = new MessageReceiver();
            Kernel.getWorker().addFrame(new UpdaterDialogFrame());
            if(CommandLineArguments.getInstance().hasArgument("update-server-port"))
            {
               _log.debug("update-server-port");
               _currentConnection.connect("localhost",int(CommandLineArguments.getInstance().getArgument("update-server-port")));
            }
            else
            {
               _log.debug("default port");
               _currentConnection.connect("localhost",4242);
            }
            return;
         }
         throw new Error("La classe UpdaterConnexionHandler est un singleton");
      }
      
      public static function getInstance() : UpdaterConnexionHandler
      {
         if(!_self)
         {
            _self = new UpdaterConnexionHandler();
         }
         return _self;
      }
      
      public static function getConnection() : ServerConnection
      {
         return _currentConnection;
      }
      
      public function onConnect(param1:Event) : void
      {
         StatisticReportingManager.getInstance().report("UpdaterConnexion - " + BuildInfos.BUILD_TYPE + " - " + BuildInfos.BUILD_VERSION,"success");
         PartManager.getInstance().initialize();
      }
      
      public function onIoError(param1:IOErrorEvent) : void
      {
         if(CommandLineArguments.getInstance().hasArgument("update-server-port"))
         {
            StatisticReportingManager.getInstance().report("UpdaterConnexion - " + BuildInfos.BUILD_TYPE + " - " + BuildInfos.BUILD_VERSION,"failed");
         }
         else
         {
            StatisticReportingManager.getInstance().report("UpdaterConnexion - " + BuildInfos.BUILD_TYPE + " - " + BuildInfos.BUILD_VERSION,"noupdater");
         }
         _log.error("Can\'t etablish connection with updater");
      }
   }
}

