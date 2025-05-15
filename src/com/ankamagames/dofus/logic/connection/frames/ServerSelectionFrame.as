package com.ankamagames.dofus.logic.connection.frames
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.net.DisconnectionReasonEnum;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.connection.actions.AcquaintanceSearchAction;
   import com.ankamagames.dofus.logic.connection.actions.ServerSelectionAction;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.logic.game.approach.frames.GameServerApproachFrame;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.ServerConnectionErrorEnum;
   import com.ankamagames.dofus.network.enums.ServerStatusEnum;
   import com.ankamagames.dofus.network.messages.connection.SelectedServerDataMessage;
   import com.ankamagames.dofus.network.messages.connection.SelectedServerRefusedMessage;
   import com.ankamagames.dofus.network.messages.connection.ServerSelectionMessage;
   import com.ankamagames.dofus.network.messages.connection.ServerStatusUpdateMessage;
   import com.ankamagames.dofus.network.messages.connection.ServersListMessage;
   import com.ankamagames.dofus.network.messages.connection.search.AcquaintanceSearchErrorMessage;
   import com.ankamagames.dofus.network.messages.connection.search.AcquaintanceSearchMessage;
   import com.ankamagames.dofus.network.messages.connection.search.AcquaintanceServerListMessage;
   import com.ankamagames.dofus.network.types.connection.GameServerInformations;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.*;
   import com.ankamagames.jerakine.network.messages.ExpectedSocketClosureMessage;
   import com.ankamagames.jerakine.network.messages.WrongSocketClosureReasonMessage;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   
   public class ServerSelectionFrame implements Frame
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ServerSelectionFrame));
      
      private var _serversList:Vector.<GameServerInformations>;
      
      private var _serversUsedList:Vector.<GameServerInformations>;
      
      private var _serversListMessage:ServersListMessage;
      
      private var _selectedServer:SelectedServerDataMessage;
      
      private var _worker:Worker;
      
      public function ServerSelectionFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get usedServers() : Vector.<GameServerInformations>
      {
         return this._serversUsedList;
      }
      
      public function get servers() : Vector.<GameServerInformations>
      {
         return this._serversList;
      }
      
      public function pushed() : Boolean
      {
         this._worker = Kernel.getWorker();
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:ServersListMessage = null;
         var _loc3_:ServerStatusUpdateMessage = null;
         var _loc4_:ServerSelectionAction = null;
         var _loc5_:SelectedServerDataMessage = null;
         var _loc6_:ExpectedSocketClosureMessage = null;
         var _loc7_:AcquaintanceSearchAction = null;
         var _loc8_:AcquaintanceSearchMessage = null;
         var _loc9_:AcquaintanceSearchErrorMessage = null;
         var _loc10_:String = null;
         var _loc11_:AcquaintanceServerListMessage = null;
         var _loc12_:SelectedServerRefusedMessage = null;
         var _loc13_:* = null;
         var _loc14_:* = undefined;
         var _loc15_:ServerSelectionMessage = null;
         var _loc16_:* = null;
         switch(true)
         {
            case param1 is ServersListMessage:
               _loc2_ = param1 as ServersListMessage;
               PlayerManager.getInstance().server = null;
               this._serversList = _loc2_.servers;
               this._serversListMessage = _loc2_;
               if(!Berilia.getInstance().uiList["CharacterHeader"])
               {
                  KernelEventsManager.getInstance().processCallback(HookList.AuthenticationTicketAccepted);
               }
               this.broadcastServersListUpdate();
               return true;
            case param1 is ServerStatusUpdateMessage:
               _loc3_ = param1 as ServerStatusUpdateMessage;
               this._serversList.forEach(this.getUpdateServerFunction(_loc3_.server));
               _log.debug("[" + _loc3_.server.id + "] Status changed to " + _loc3_.server.status + ".");
               this.broadcastServersListUpdate();
               return true;
            case param1 is ServerSelectionAction:
               _loc4_ = param1 as ServerSelectionAction;
               for each(_loc14_ in this._serversList)
               {
                  if(_loc14_.id == _loc4_.serverId)
                  {
                     if(_loc14_.status == ServerStatusEnum.ONLINE)
                     {
                        _loc15_ = new ServerSelectionMessage();
                        _loc15_.initServerSelectionMessage(_loc4_.serverId);
                        ConnectionsHandler.getConnection().send(_loc15_);
                     }
                     else
                     {
                        _loc16_ = "Status";
                        switch(_loc14_.status)
                        {
                           case ServerStatusEnum.OFFLINE:
                              _loc16_ += "Offline";
                              break;
                           case ServerStatusEnum.STARTING:
                              _loc16_ += "Starting";
                              break;
                           case ServerStatusEnum.NOJOIN:
                              _loc16_ += "Nojoin";
                              break;
                           case ServerStatusEnum.SAVING:
                              _loc16_ += "Saving";
                              break;
                           case ServerStatusEnum.STOPING:
                              _loc16_ += "Stoping";
                              break;
                           case ServerStatusEnum.FULL:
                              _loc16_ += "Full";
                              break;
                           case ServerStatusEnum.STATUS_UNKNOWN:
                           default:
                              _loc16_ += "Unknown";
                        }
                        KernelEventsManager.getInstance().processCallback(HookList.SelectedServerRefused,_loc14_.id,_loc16_,this.getSelectableServers());
                     }
                  }
               }
               return true;
            case param1 is SelectedServerDataMessage:
               _loc5_ = param1 as SelectedServerDataMessage;
               ConnectionsHandler.connectionGonnaBeClosed(DisconnectionReasonEnum.SWITCHING_TO_GAME_SERVER);
               this._selectedServer = _loc5_;
               AuthentificationManager.getInstance().gameServerTicket = _loc5_.ticket;
               PlayerManager.getInstance().server = Server.getServerById(_loc5_.serverId);
               return true;
            case param1 is ExpectedSocketClosureMessage:
               _loc6_ = param1 as ExpectedSocketClosureMessage;
               if(_loc6_.reason != DisconnectionReasonEnum.SWITCHING_TO_GAME_SERVER)
               {
                  this._worker.process(new WrongSocketClosureReasonMessage(DisconnectionReasonEnum.SWITCHING_TO_GAME_SERVER,_loc6_.reason));
                  return true;
               }
               this._worker.removeFrame(this);
               this._worker.addFrame(new GameServerApproachFrame());
               ConnectionsHandler.connectToGameServer(this._selectedServer.address,this._selectedServer.port);
               return true;
               break;
            case param1 is AcquaintanceSearchAction:
               _loc7_ = param1 as AcquaintanceSearchAction;
               _loc8_ = new AcquaintanceSearchMessage();
               _loc8_.initAcquaintanceSearchMessage(_loc7_.friendName);
               ConnectionsHandler.getConnection().send(_loc8_);
               return true;
            case param1 is AcquaintanceSearchErrorMessage:
               _loc9_ = param1 as AcquaintanceSearchErrorMessage;
               switch(_loc9_.reason)
               {
                  case 1:
                     _loc10_ = "unavailable";
                     break;
                  case 2:
                     _loc10_ = "no_result";
                     break;
                  case 3:
                     _loc10_ = "flood";
                     break;
                  case 0:
                  default:
                     _loc10_ = "unknown";
               }
               KernelEventsManager.getInstance().processCallback(HookList.AcquaintanceSearchError,_loc10_);
               return true;
            case param1 is AcquaintanceServerListMessage:
               _loc11_ = param1 as AcquaintanceServerListMessage;
               KernelEventsManager.getInstance().processCallback(HookList.AcquaintanceServerList,_loc11_.servers);
               return true;
            case param1 is SelectedServerRefusedMessage:
               _loc12_ = param1 as SelectedServerRefusedMessage;
               this._serversList.forEach(this.getUpdateServerStatusFunction(_loc12_.serverId,_loc12_.serverStatus));
               this.broadcastServersListUpdate();
               loop4:
               switch(_loc12_.error)
               {
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_DUE_TO_STATUS:
                     _loc13_ = "Status";
                     switch(_loc12_.serverStatus)
                     {
                        case ServerStatusEnum.OFFLINE:
                           _loc13_ += "Offline";
                           break loop4;
                        case ServerStatusEnum.STARTING:
                           _loc13_ += "Starting";
                           break loop4;
                        case ServerStatusEnum.NOJOIN:
                           _loc13_ += "Nojoin";
                           break loop4;
                        case ServerStatusEnum.SAVING:
                           _loc13_ += "Saving";
                           break loop4;
                        case ServerStatusEnum.STOPING:
                           _loc13_ += "Stoping";
                           break loop4;
                        case ServerStatusEnum.FULL:
                           _loc13_ += "Full";
                           break loop4;
                        case ServerStatusEnum.STATUS_UNKNOWN:
                     }
                     _loc13_ += "Unknown";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_ACCOUNT_RESTRICTED:
                     _loc13_ = "AccountRestricted";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_COMMUNITY_RESTRICTED:
                     _loc13_ = "CommunityRestricted";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_LOCATION_RESTRICTED:
                     _loc13_ = "LocationRestricted";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_SUBSCRIBERS_ONLY:
                     _loc13_ = "SubscribersOnly";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_REGULAR_PLAYERS_ONLY:
                     _loc13_ = "RegularPlayersOnly";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_NO_REASON:
                  default:
                     _loc13_ = "NoReason";
               }
               KernelEventsManager.getInstance().processCallback(HookList.SelectedServerRefused,_loc12_.serverId,_loc13_,this.getSelectableServers());
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      private function getSelectableServers() : Array
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._serversList)
         {
            if(_loc2_.status == ServerStatusEnum.ONLINE && Boolean(_loc2_.isSelectable))
            {
               _loc1_.push(_loc2_.id);
            }
         }
         return _loc1_;
      }
      
      private function broadcastServersListUpdate() : void
      {
         var _loc1_:Object = null;
         this._serversUsedList = new Vector.<GameServerInformations>();
         for each(_loc1_ in this._serversList)
         {
            _log.warn("serveur " + _loc1_.id);
            if(_loc1_.charactersCount > 0)
            {
               _log.warn("   " + _loc1_.charactersCount + " perso");
               this._serversUsedList.push(_loc1_);
            }
         }
         KernelEventsManager.getInstance().processCallback(HookList.ServersList,this._serversList);
      }
      
      private function getUpdateServerFunction(param1:GameServerInformations) : Function
      {
         var serverToUpdate:GameServerInformations = param1;
         return function(param1:*, param2:int, param3:Vector.<GameServerInformations>):void
         {
            var _loc4_:* = param1 as GameServerInformations;
            if(serverToUpdate.id == _loc4_.id)
            {
               _loc4_.charactersCount = serverToUpdate.charactersCount;
               _loc4_.completion = serverToUpdate.completion;
               _loc4_.isSelectable = serverToUpdate.isSelectable;
               _loc4_.status = serverToUpdate.status;
            }
         };
      }
      
      private function getUpdateServerStatusFunction(param1:uint, param2:uint) : Function
      {
         var serverId:uint = param1;
         var newStatus:uint = param2;
         return function(param1:*, param2:int, param3:Vector.<GameServerInformations>):void
         {
            var _loc4_:* = param1 as GameServerInformations;
            if(serverId == _loc4_.id)
            {
               _loc4_.status = newStatus;
            }
         };
      }
   }
}

