package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.items.criterion.GroupItemCriterion;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.actions.ChangeWorldInteractionAction;
   import com.ankamagames.dofus.logic.game.common.actions.LeaveDialogAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectMoveKamaAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertAllFromInvAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertAllToInvAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertExistingFromInvAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertExistingToInvAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertListFromInvAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertListToInvAction;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.roleplay.actions.LeaveDialogRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayMovementFrame;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.network.ProtocolConstantsEnum;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.DialogTypeEnum;
   import com.ankamagames.dofus.network.enums.ExchangeTypeEnum;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectMoveKamaMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectTransfertAllFromInvMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectTransfertAllToInvMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectTransfertExistingFromInvMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectTransfertExistingToInvMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectTransfertListFromInvMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectTransfertListToInvMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestedTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkNpcShopMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkNpcTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkTaxCollectorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedWithPodsMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedWithStorageMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageInventoryContentMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageKamasUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectsRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectsUpdateMessage;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNamedActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemToSellInNpcShop;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.network.IServerConnection;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.utils.getQualifiedClassName;
   
   public class ExchangeManagementFrame implements Frame
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ExchangeManagementFrame));
      
      private var _priority:int = 0;
      
      private var _sourceInformations:GameRolePlayNamedActorInformations;
      
      private var _targetInformations:GameRolePlayNamedActorInformations;
      
      private var _meReady:Boolean = false;
      
      private var _youReady:Boolean = false;
      
      private var _exchangeInventory:Array;
      
      private var _success:Boolean;
      
      public function ExchangeManagementFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function set priority(param1:int) : void
      {
         this._priority = param1;
      }
      
      private function get roleplayContextFrame() : RoleplayContextFrame
      {
         return Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
      }
      
      private function get roleplayEntitiesFrame() : RoleplayEntitiesFrame
      {
         return Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
      }
      
      private function get roleplayMovementFrame() : RoleplayMovementFrame
      {
         return Kernel.getWorker().getFrame(RoleplayMovementFrame) as RoleplayMovementFrame;
      }
      
      public function initMountStock(param1:Vector.<ObjectItem>) : void
      {
         InventoryManager.getInstance().bankInventory.initializeFromObjectItems(param1);
         InventoryManager.getInstance().bankInventory.releaseHooks();
      }
      
      public function processExchangeRequestedTradeMessage(param1:ExchangeRequestedTradeMessage) : void
      {
         var _loc4_:SocialFrame = null;
         var _loc5_:LeaveDialogAction = null;
         if(param1.exchangeType != ExchangeTypeEnum.PLAYER_TRADE)
         {
            return;
         }
         this._sourceInformations = this.roleplayEntitiesFrame.getEntityInfos(param1.source) as GameRolePlayNamedActorInformations;
         this._targetInformations = this.roleplayEntitiesFrame.getEntityInfos(param1.target) as GameRolePlayNamedActorInformations;
         var _loc2_:String = this._sourceInformations.name;
         var _loc3_:String = this._targetInformations.name;
         if(param1.source == PlayedCharacterManager.getInstance().id)
         {
            this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeRequestCharacterFromMe,_loc2_,_loc3_);
         }
         else
         {
            _loc4_ = Kernel.getWorker().getFrame(SocialFrame) as SocialFrame;
            if((Boolean(_loc4_)) && _loc4_.isIgnored(_loc2_))
            {
               _loc5_ = new LeaveDialogAction();
               Kernel.getWorker().process(_loc5_);
               return;
            }
            this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeRequestCharacterToMe,_loc3_,_loc2_);
         }
      }
      
      public function processExchangeStartOkNpcTradeMessage(param1:ExchangeStartOkNpcTradeMessage) : void
      {
         var _loc2_:String = PlayedCharacterManager.getInstance().infos.name;
         var _loc3_:int = this.roleplayEntitiesFrame.getEntityInfos(param1.npcId).contextualId;
         var _loc4_:Npc = Npc.getNpcById(_loc3_);
         var _loc5_:String = Npc.getNpcById((this.roleplayEntitiesFrame.getEntityInfos(param1.npcId) as GameRolePlayNpcInformations).npcId).name;
         var _loc6_:TiphonEntityLook = EntityLookAdapter.getRiderLook(PlayedCharacterManager.getInstance().infos.entityLook);
         var _loc7_:TiphonEntityLook = EntityLookAdapter.getRiderLook(this.roleplayContextFrame.entitiesFrame.getEntityInfos(param1.npcId).look);
         var _loc8_:ExchangeStartOkNpcTradeMessage = param1 as ExchangeStartOkNpcTradeMessage;
         PlayedCharacterManager.getInstance().isInExchange = true;
         this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartOkNpcTrade,_loc8_.npcId,_loc2_,_loc5_,_loc6_,_loc7_);
         this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType,ExchangeTypeEnum.NPC_TRADE);
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc4_:ExchangeStartedWithStorageMessage = null;
         var _loc5_:CommonExchangeManagementFrame = null;
         var _loc6_:int = 0;
         var _loc7_:ExchangeStartedMessage = null;
         var _loc8_:CommonExchangeManagementFrame = null;
         var _loc9_:StorageInventoryContentMessage = null;
         var _loc10_:ExchangeStartOkTaxCollectorMessage = null;
         var _loc11_:StorageObjectUpdateMessage = null;
         var _loc12_:ObjectItem = null;
         var _loc13_:ItemWrapper = null;
         var _loc14_:StorageObjectRemoveMessage = null;
         var _loc15_:StorageObjectsUpdateMessage = null;
         var _loc16_:StorageObjectsRemoveMessage = null;
         var _loc17_:StorageKamasUpdateMessage = null;
         var _loc18_:ExchangeObjectMoveKamaAction = null;
         var _loc19_:ExchangeObjectMoveKamaMessage = null;
         var _loc20_:ExchangeObjectTransfertAllToInvAction = null;
         var _loc21_:ExchangeObjectTransfertAllToInvMessage = null;
         var _loc22_:ExchangeObjectTransfertListToInvAction = null;
         var _loc23_:ExchangeObjectTransfertExistingToInvAction = null;
         var _loc24_:ExchangeObjectTransfertExistingToInvMessage = null;
         var _loc25_:ExchangeObjectTransfertAllFromInvAction = null;
         var _loc26_:ExchangeObjectTransfertAllFromInvMessage = null;
         var _loc27_:ExchangeObjectTransfertListFromInvAction = null;
         var _loc28_:ExchangeObjectTransfertExistingFromInvAction = null;
         var _loc29_:ExchangeObjectTransfertExistingFromInvMessage = null;
         var _loc30_:ExchangeStartOkNpcShopMessage = null;
         var _loc31_:GameContextActorInformations = null;
         var _loc32_:TiphonEntityLook = null;
         var _loc33_:Array = null;
         var _loc34_:ExchangeLeaveMessage = null;
         var _loc35_:String = null;
         var _loc36_:String = null;
         var _loc37_:TiphonEntityLook = null;
         var _loc38_:TiphonEntityLook = null;
         var _loc39_:ExchangeStartedWithPodsMessage = null;
         var _loc40_:int = 0;
         var _loc41_:int = 0;
         var _loc42_:int = 0;
         var _loc43_:int = 0;
         var _loc44_:int = 0;
         var _loc45_:ObjectItem = null;
         var _loc46_:ObjectItem = null;
         var _loc47_:ItemWrapper = null;
         var _loc48_:uint = 0;
         var _loc49_:ExchangeObjectTransfertListToInvMessage = null;
         var _loc50_:ExchangeObjectTransfertListFromInvMessage = null;
         var _loc51_:ObjectItemToSellInNpcShop = null;
         var _loc52_:ItemWrapper = null;
         switch(true)
         {
            case param1 is ExchangeStartedWithStorageMessage:
               _loc4_ = param1 as ExchangeStartedWithStorageMessage;
               PlayedCharacterManager.getInstance().isInExchange = true;
               _loc5_ = Kernel.getWorker().getFrame(CommonExchangeManagementFrame) as CommonExchangeManagementFrame;
               if(_loc5_)
               {
                  _loc5_.resetEchangeSequence();
               }
               _loc6_ = int(_loc4_.storageMaxSlot);
               this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeBankStartedWithStorage,ExchangeTypeEnum.STORAGE,_loc6_);
               return true;
            case param1 is ExchangeStartedMessage:
               _loc7_ = param1 as ExchangeStartedMessage;
               PlayedCharacterManager.getInstance().isInExchange = true;
               _loc8_ = Kernel.getWorker().getFrame(CommonExchangeManagementFrame) as CommonExchangeManagementFrame;
               if(_loc8_)
               {
                  _loc8_.resetEchangeSequence();
               }
               switch(_loc7_.exchangeType)
               {
                  case ExchangeTypeEnum.PLAYER_TRADE:
                     _loc35_ = this._sourceInformations.name;
                     _loc36_ = this._targetInformations.name;
                     _loc37_ = EntityLookAdapter.getRiderLook(this._sourceInformations.look);
                     _loc38_ = EntityLookAdapter.getRiderLook(this._targetInformations.look);
                     if(_loc7_.getMessageId() == ExchangeStartedWithPodsMessage.protocolId)
                     {
                        _loc39_ = param1 as ExchangeStartedWithPodsMessage;
                     }
                     _loc40_ = -1;
                     _loc41_ = -1;
                     _loc42_ = -1;
                     _loc43_ = -1;
                     if(_loc39_ != null)
                     {
                        if(_loc39_.firstCharacterId == this._sourceInformations.contextualId)
                        {
                           _loc40_ = int(_loc39_.firstCharacterCurrentWeight);
                           _loc41_ = int(_loc39_.secondCharacterCurrentWeight);
                           _loc42_ = int(_loc39_.firstCharacterMaxWeight);
                           _loc43_ = int(_loc39_.secondCharacterMaxWeight);
                        }
                        else
                        {
                           _loc41_ = int(_loc39_.firstCharacterCurrentWeight);
                           _loc40_ = int(_loc39_.secondCharacterCurrentWeight);
                           _loc43_ = int(_loc39_.firstCharacterMaxWeight);
                           _loc42_ = int(_loc39_.secondCharacterMaxWeight);
                        }
                     }
                     if(PlayedCharacterManager.getInstance().id == _loc39_.firstCharacterId)
                     {
                        _loc44_ = _loc39_.secondCharacterId;
                     }
                     else
                     {
                        _loc44_ = _loc39_.firstCharacterId;
                     }
                     _log.debug("look : " + _loc37_.toString() + "    " + _loc38_.toString());
                     this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStarted,_loc35_,_loc36_,_loc37_,_loc38_,_loc40_,_loc41_,_loc42_,_loc43_,_loc44_);
                     this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType,_loc7_.exchangeType);
                     return true;
                  case ExchangeTypeEnum.STORAGE:
                     this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType,_loc7_.exchangeType);
                     return true;
                  case ExchangeTypeEnum.TAXCOLLECTOR:
                     this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType,_loc7_.exchangeType);
                     return true;
                  default:
                     return false;
               }
               break;
            case param1 is StorageInventoryContentMessage:
               _loc9_ = param1 as StorageInventoryContentMessage;
               InventoryManager.getInstance().bankInventory.kamas = _loc9_.kamas;
               InventoryManager.getInstance().bankInventory.initializeFromObjectItems(_loc9_.objects);
               InventoryManager.getInstance().bankInventory.releaseHooks();
               return false;
            case param1 is ExchangeStartOkTaxCollectorMessage:
               _loc10_ = param1 as ExchangeStartOkTaxCollectorMessage;
               InventoryManager.getInstance().bankInventory.kamas = _loc10_.goldInfo;
               InventoryManager.getInstance().bankInventory.initializeFromObjectItems(_loc10_.objectsInfos);
               InventoryManager.getInstance().bankInventory.releaseHooks();
               return false;
            case param1 is StorageObjectUpdateMessage:
               _loc11_ = param1 as StorageObjectUpdateMessage;
               _loc12_ = _loc11_.object;
               _loc13_ = ItemWrapper.create(_loc12_.position,_loc12_.objectUID,_loc12_.objectGID,_loc12_.quantity,_loc12_.effects);
               InventoryManager.getInstance().bankInventory.modifyItem(_loc13_);
               InventoryManager.getInstance().bankInventory.releaseHooks();
               return false;
            case param1 is StorageObjectRemoveMessage:
               _loc14_ = param1 as StorageObjectRemoveMessage;
               InventoryManager.getInstance().bankInventory.removeItem(_loc14_.objectUID);
               InventoryManager.getInstance().bankInventory.releaseHooks();
               return false;
            case param1 is StorageObjectsUpdateMessage:
               _loc15_ = param1 as StorageObjectsUpdateMessage;
               for each(_loc45_ in _loc15_.objectList)
               {
                  _loc46_ = _loc45_;
                  _loc47_ = ItemWrapper.create(_loc46_.position,_loc46_.objectUID,_loc46_.objectGID,_loc46_.quantity,_loc46_.effects);
                  InventoryManager.getInstance().bankInventory.modifyItem(_loc47_);
               }
               InventoryManager.getInstance().bankInventory.releaseHooks();
               return false;
            case param1 is StorageObjectsRemoveMessage:
               _loc16_ = param1 as StorageObjectsRemoveMessage;
               for each(_loc48_ in _loc16_.objectUIDList)
               {
                  InventoryManager.getInstance().bankInventory.removeItem(_loc48_);
               }
               InventoryManager.getInstance().bankInventory.releaseHooks();
               return false;
            case param1 is StorageKamasUpdateMessage:
               _loc17_ = param1 as StorageKamasUpdateMessage;
               InventoryManager.getInstance().bankInventory.kamas = _loc17_.kamasTotal;
               KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageKamasUpdate,_loc17_.kamasTotal);
               return false;
            case param1 is ExchangeObjectMoveKamaAction:
               _loc18_ = param1 as ExchangeObjectMoveKamaAction;
               _loc19_ = new ExchangeObjectMoveKamaMessage();
               _loc19_.initExchangeObjectMoveKamaMessage(_loc18_.kamas);
               this._serverConnection.send(_loc19_);
               return true;
            case param1 is ExchangeObjectTransfertAllToInvAction:
               _loc20_ = param1 as ExchangeObjectTransfertAllToInvAction;
               _loc21_ = new ExchangeObjectTransfertAllToInvMessage();
               _loc21_.initExchangeObjectTransfertAllToInvMessage();
               this._serverConnection.send(_loc21_);
               return true;
            case param1 is ExchangeObjectTransfertListToInvAction:
               _loc22_ = param1 as ExchangeObjectTransfertListToInvAction;
               if(_loc22_.ids.length > ProtocolConstantsEnum.MAX_OBJ_COUNT_BY_XFERT)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.exchange.partialTransfert"),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               if(_loc22_.ids.length >= ProtocolConstantsEnum.MIN_OBJ_COUNT_BY_XFERT)
               {
                  _loc49_ = new ExchangeObjectTransfertListToInvMessage();
                  _loc49_.initExchangeObjectTransfertListToInvMessage(_loc22_.ids.slice(0,ProtocolConstantsEnum.MAX_OBJ_COUNT_BY_XFERT));
                  this._serverConnection.send(_loc49_);
               }
               return true;
            case param1 is ExchangeObjectTransfertExistingToInvAction:
               _loc23_ = param1 as ExchangeObjectTransfertExistingToInvAction;
               _loc24_ = new ExchangeObjectTransfertExistingToInvMessage();
               _loc24_.initExchangeObjectTransfertExistingToInvMessage();
               this._serverConnection.send(_loc24_);
               return true;
            case param1 is ExchangeObjectTransfertAllFromInvAction:
               _loc25_ = param1 as ExchangeObjectTransfertAllFromInvAction;
               _loc26_ = new ExchangeObjectTransfertAllFromInvMessage();
               _loc26_.initExchangeObjectTransfertAllFromInvMessage();
               this._serverConnection.send(_loc26_);
               return true;
            case param1 is ExchangeObjectTransfertListFromInvAction:
               _loc27_ = param1 as ExchangeObjectTransfertListFromInvAction;
               if(_loc27_.ids.length > ProtocolConstantsEnum.MAX_OBJ_COUNT_BY_XFERT)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.exchange.partialTransfert"),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               if(_loc27_.ids.length >= ProtocolConstantsEnum.MIN_OBJ_COUNT_BY_XFERT)
               {
                  _loc50_ = new ExchangeObjectTransfertListFromInvMessage();
                  _loc50_.initExchangeObjectTransfertListFromInvMessage(_loc27_.ids.slice(0,ProtocolConstantsEnum.MAX_OBJ_COUNT_BY_XFERT));
                  this._serverConnection.send(_loc50_);
               }
               return true;
            case param1 is ExchangeObjectTransfertExistingFromInvAction:
               _loc28_ = param1 as ExchangeObjectTransfertExistingFromInvAction;
               _loc29_ = new ExchangeObjectTransfertExistingFromInvMessage();
               _loc29_.initExchangeObjectTransfertExistingFromInvMessage();
               this._serverConnection.send(_loc29_);
               return true;
            case param1 is ExchangeStartOkNpcShopMessage:
               _loc30_ = param1 as ExchangeStartOkNpcShopMessage;
               PlayedCharacterManager.getInstance().isInExchange = true;
               Kernel.getWorker().process(ChangeWorldInteractionAction.create(false,true));
               _loc31_ = this.roleplayContextFrame.entitiesFrame.getEntityInfos(_loc30_.npcSellerId);
               _loc32_ = EntityLookAdapter.fromNetwork(_loc31_.look);
               _loc33_ = new Array();
               for each(_loc51_ in _loc30_.objectsInfos)
               {
                  _loc52_ = ItemWrapper.create(63,0,_loc51_.objectGID,0,_loc51_.effects,false);
                  _loc33_.push({
                     "item":_loc52_,
                     "price":_loc51_.objectPrice,
                     "criterion":new GroupItemCriterion(_loc51_.buyCriterion)
                  });
               }
               this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartOkNpcShop,_loc30_.npcSellerId,_loc33_,_loc32_,_loc30_.tokenId);
               return true;
            case param1 is LeaveDialogRequestAction:
               ConnectionsHandler.getConnection().send(new LeaveDialogRequestMessage());
               return true;
            case param1 is ExchangeLeaveMessage:
               _loc34_ = param1 as ExchangeLeaveMessage;
               if(_loc34_.dialogType == DialogTypeEnum.DIALOG_EXCHANGE)
               {
                  PlayedCharacterManager.getInstance().isInExchange = false;
                  this._success = _loc34_.success;
                  Kernel.getWorker().removeFrame(this);
               }
               return true;
            default:
               return false;
         }
      }
      
      private function proceedExchange() : void
      {
      }
      
      public function pushed() : Boolean
      {
         this._success = false;
         return true;
      }
      
      public function pulled() : Boolean
      {
         if(Kernel.getWorker().contains(CommonExchangeManagementFrame))
         {
            Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(CommonExchangeManagementFrame));
         }
         KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeLeave,this._success);
         this._exchangeInventory = null;
         return true;
      }
      
      private function get _kernelEventsManager() : KernelEventsManager
      {
         return KernelEventsManager.getInstance();
      }
      
      private function get _serverConnection() : IServerConnection
      {
         return ConnectionsHandler.getConnection();
      }
   }
}

