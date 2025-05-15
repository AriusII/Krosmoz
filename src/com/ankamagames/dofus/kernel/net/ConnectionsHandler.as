package com.ankamagames.dofus.kernel.net
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.utils.LagometerAck;
   import com.ankamagames.dofus.logic.connection.frames.HandshakeFrame;
   import com.ankamagames.dofus.network.MessageReceiver;
   import com.ankamagames.dofus.network.messages.common.basic.BasicPingMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.ConnectionResumedMessage;
   import com.ankamagames.jerakine.network.HttpServerConnection;
   import com.ankamagames.jerakine.network.IConnectionProxy;
   import com.ankamagames.jerakine.network.IServerConnection;
   import com.ankamagames.jerakine.network.ProxyedServerConnection;
   import com.ankamagames.jerakine.network.ServerConnection;
   import com.ankamagames.jerakine.network.SnifferServerConnection;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class ConnectionsHandler
   {
      private static var _useSniffer:Boolean;
      
      private static var _currentConnection:IServerConnection;
      
      private static var _currentConnectionType:uint;
      
      private static var _wantedSocketLost:Boolean;
      
      private static var _wantedSocketLostReason:uint;
      
      private static var _connectionTimeout:Timer;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ConnectionsHandler));
      
      private static var _hasReceivedMsg:Boolean = false;
      
      private static var _currentHttpConnection:HttpServerConnection = new HttpServerConnection();
      
      public function ConnectionsHandler()
      {
         super();
      }
      
      public static function get useSniffer() : Boolean
      {
         return _useSniffer;
      }
      
      public static function set useSniffer(param1:Boolean) : void
      {
         _useSniffer = param1;
      }
      
      public static function get connectionType() : uint
      {
         return _currentConnectionType;
      }
      
      public static function get hasReceivedMsg() : Boolean
      {
         return _hasReceivedMsg;
      }
      
      public static function set hasReceivedMsg(param1:Boolean) : void
      {
         _hasReceivedMsg = param1;
      }
      
      public static function getConnection() : IServerConnection
      {
         return _currentConnection;
      }
      
      public static function getHttpConnection() : HttpServerConnection
      {
         if(!_currentHttpConnection.handler)
         {
            _currentHttpConnection.handler = Kernel.getWorker();
            _currentHttpConnection.rawParser = new MessageReceiver();
         }
         return _currentHttpConnection;
      }
      
      public static function connectToLoginServer(param1:String, param2:uint) : void
      {
         if(_currentConnection != null)
         {
            closeConnection();
         }
         etablishConnection(param1,param2,_useSniffer);
         _currentConnectionType = ConnectionType.TO_LOGIN_SERVER;
      }
      
      public static function connectToGameServer(param1:String, param2:uint) : void
      {
         if(!_connectionTimeout)
         {
            _connectionTimeout = new Timer(4000,1);
            _connectionTimeout.addEventListener(TimerEvent.TIMER,onConnectionTimeout);
         }
         else
         {
            _connectionTimeout.reset();
         }
         _connectionTimeout.start();
         _log.debug("Lancement du timer pour valider la connexion au serveur de jeu");
         if(_currentConnection != null)
         {
            closeConnection();
         }
         etablishConnection(param1,param2,_useSniffer);
         _currentConnectionType = ConnectionType.TO_GAME_SERVER;
      }
      
      public static function confirmGameServerConnection() : void
      {
         _log.debug("Confirmation de la connexion au serveur de jeu, désactivation du timer");
         if(_connectionTimeout)
         {
            _connectionTimeout.stop();
         }
      }
      
      public static function onConnectionTimeout(param1:TimerEvent) : void
      {
         var _loc2_:BasicPingMessage = null;
         _log.debug("Expiration du timer de connexion au serveur de jeu");
         if(Boolean(_currentConnection) && _currentConnection.connected)
         {
            _loc2_ = new BasicPingMessage();
            _loc2_.initBasicPingMessage(true);
            _log.warn("La connection au serveur de jeu semble longue. On envoit un BasicPingMessage pour essayer de débloquer la situation.");
            _currentConnection.send(_loc2_);
            if(_connectionTimeout)
            {
               _connectionTimeout.stop();
            }
         }
      }
      
      public static function closeConnection() : void
      {
         if(Kernel.getWorker().contains(HandshakeFrame))
         {
            Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(HandshakeFrame));
         }
         if(Boolean(_currentConnection) && _currentConnection.connected)
         {
            _currentConnection.close();
         }
         _currentConnection = null;
         _currentConnectionType = ConnectionType.DISCONNECTED;
      }
      
      public static function handleDisconnection() : DisconnectionReason
      {
         _log.debug("handleDisconnection");
         closeConnection();
         var _loc1_:DisconnectionReason = new DisconnectionReason(_wantedSocketLost,_wantedSocketLostReason);
         _wantedSocketLost = false;
         _wantedSocketLostReason = DisconnectionReasonEnum.UNEXPECTED;
         return _loc1_;
      }
      
      public static function connectionGonnaBeClosed(param1:uint) : void
      {
         _wantedSocketLostReason = param1;
         _wantedSocketLost = true;
      }
      
      public static function pause() : void
      {
         _log.debug("Pause connection");
         _currentConnection.pause();
      }
      
      public static function resume() : void
      {
         _log.debug("Resume connection");
         if(_currentConnection)
         {
            _currentConnection.resume();
         }
         Kernel.getWorker().process(new ConnectionResumedMessage());
      }
      
      private static function etablishConnection(param1:String, param2:int, param3:Boolean = false, param4:IConnectionProxy = null) : void
      {
         if(param3)
         {
            if(param4 != null)
            {
               throw new ArgumentError("Can\'t etablish a connection using a proxy and the sniffer.");
            }
            _currentConnection = new SnifferServerConnection();
         }
         else if(param4 != null)
         {
            _currentConnection = new ProxyedServerConnection(param4);
         }
         else
         {
            _currentConnection = new ServerConnection();
         }
         _currentConnection.lagometer = new LagometerAck();
         _currentConnection.handler = Kernel.getWorker();
         _currentConnection.rawParser = new MessageReceiver();
         Kernel.getWorker().addFrame(new HandshakeFrame());
         _currentConnection.connect(param1,param2);
      }
   }
}

