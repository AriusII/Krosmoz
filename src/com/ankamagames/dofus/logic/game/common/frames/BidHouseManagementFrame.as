package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.actions.bid.BidHouseStringSearchAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.BidSwitchToBuyerModeAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.BidSwitchToSellerModeAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.ExchangeBidHouseBuyAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.ExchangeBidHouseListAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.ExchangeBidHousePriceAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.ExchangeBidHouseSearchAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.ExchangeBidHouseTypeAction;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.network.enums.DialogTypeEnum;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcGenericActionRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseBuyMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseGenericItemAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseGenericItemRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseInListAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseInListRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseInListUpdatedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseItemAddOkMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseItemRemoveOkMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseListMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHousePriceMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseSearchMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseTypeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidPriceMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidSearchOkMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedBidBuyerMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedBidSellerMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeTypesExchangerDescriptionForUserMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeTypesItemsExchangerDescriptionForUserMessage;
   import com.ankamagames.dofus.network.types.game.data.items.BidExchangerObjectInfo;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemToSellInBid;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.network.IServerConnection;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class BidHouseManagementFrame implements Frame
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(BidHouseManagementFrame));
      
      private var _bidHouseObjects:Array;
      
      private var _vendorObjects:Array;
      
      private var _typeAsk:uint;
      
      private var _GIDAsk:uint;
      
      private var _NPCId:uint;
      
      private var _listItemsSearchMode:Array;
      
      private var _itemsTypesAllowed:Vector.<uint>;
      
      private var _switching:Boolean = false;
      
      private var _success:Boolean;
      
      public function BidHouseManagementFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get switching() : Boolean
      {
         return this._switching;
      }
      
      public function set switching(param1:Boolean) : void
      {
         this._switching = param1;
      }
      
      public function processExchangeStartedBidSellerMessage(param1:ExchangeStartedBidSellerMessage) : void
      {
         var _loc3_:ObjectItemToSellInBid = null;
         var _loc4_:ItemWrapper = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         this._switching = false;
         var _loc2_:ExchangeStartedBidSellerMessage = param1 as ExchangeStartedBidSellerMessage;
         this._NPCId = _loc2_.sellerDescriptor.npcContextualId;
         this.initSearchMode(_loc2_.sellerDescriptor.types);
         this._vendorObjects = new Array();
         for each(_loc3_ in _loc2_.objectsInfos)
         {
            _loc4_ = ItemWrapper.create(63,_loc3_.objectUID,_loc3_.objectGID,_loc3_.quantity,_loc3_.effects);
            _loc5_ = _loc3_.objectPrice;
            _loc6_ = _loc3_.unsoldDelay;
            this._vendorObjects.push(new ItemSellByPlayer(_loc4_,_loc5_,_loc6_));
         }
         this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedBidSeller,_loc2_.sellerDescriptor,_loc2_.objectsInfos);
         this._kernelEventsManager.processCallback(ExchangeHookList.SellerObjectListUpdate,this._vendorObjects);
      }
      
      public function processExchangeStartedBidBuyerMessage(param1:ExchangeStartedBidBuyerMessage) : void
      {
         var _loc3_:uint = 0;
         this._switching = false;
         var _loc2_:ExchangeStartedBidBuyerMessage = param1 as ExchangeStartedBidBuyerMessage;
         this._NPCId = _loc2_.buyerDescriptor.npcContextualId;
         this.initSearchMode(_loc2_.buyerDescriptor.types);
         this._bidHouseObjects = new Array();
         for each(_loc3_ in _loc2_.buyerDescriptor.types)
         {
            this._bidHouseObjects.push(new TypeObjectData(_loc3_,null));
         }
         this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedBidBuyer,_loc2_.buyerDescriptor);
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:ExchangeBidHouseSearchAction = null;
         var _loc3_:ExchangeBidHouseListAction = null;
         var _loc4_:ExchangeBidHouseTypeAction = null;
         var _loc5_:ExchangeBidHouseTypeMessage = null;
         var _loc6_:ExchangeBidHouseBuyAction = null;
         var _loc7_:ExchangeBidHouseBuyMessage = null;
         var _loc8_:ExchangeBidHousePriceAction = null;
         var _loc9_:ExchangeBidHousePriceMessage = null;
         var _loc10_:ExchangeBidPriceMessage = null;
         var _loc11_:ExchangeBidHouseItemAddOkMessage = null;
         var _loc12_:Item = null;
         var _loc13_:ItemWrapper = null;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:ExchangeBidHouseItemRemoveOkMessage = null;
         var _loc17_:uint = 0;
         var _loc18_:ExchangeBidHouseGenericItemAddedMessage = null;
         var _loc19_:TypeObjectData = null;
         var _loc20_:ExchangeBidHouseGenericItemRemovedMessage = null;
         var _loc21_:TypeObjectData = null;
         var _loc22_:int = 0;
         var _loc23_:ExchangeBidHouseInListUpdatedMessage = null;
         var _loc24_:TypeObjectData = null;
         var _loc25_:GIDObjectData = null;
         var _loc26_:ExchangeBidHouseInListAddedMessage = null;
         var _loc27_:TypeObjectData = null;
         var _loc28_:GIDObjectData = null;
         var _loc29_:ExchangeBidHouseInListRemovedMessage = null;
         var _loc30_:uint = 0;
         var _loc31_:GIDObjectData = null;
         var _loc32_:uint = 0;
         var _loc33_:ExchangeTypesExchangerDescriptionForUserMessage = null;
         var _loc34_:TypeObjectData = null;
         var _loc35_:ExchangeTypesItemsExchangerDescriptionForUserMessage = null;
         var _loc36_:GIDObjectData = null;
         var _loc37_:GIDObjectData = null;
         var _loc38_:ExchangeBidSearchOkMessage = null;
         var _loc39_:BidHouseStringSearchAction = null;
         var _loc40_:String = null;
         var _loc41_:int = 0;
         var _loc42_:int = 0;
         var _loc43_:int = 0;
         var _loc44_:Vector.<uint> = null;
         var _loc45_:NpcGenericActionRequestMessage = null;
         var _loc46_:NpcGenericActionRequestMessage = null;
         var _loc47_:ExchangeLeaveMessage = null;
         var _loc48_:ExchangeBidHouseSearchMessage = null;
         var _loc49_:ExchangeBidHouseListMessage = null;
         var _loc50_:ExchangeBidHouseListMessage = null;
         var _loc51_:ItemSellByPlayer = null;
         var _loc52_:GIDObjectData = null;
         var _loc53_:ItemSellByBid = null;
         var _loc54_:Vector.<int> = null;
         var _loc55_:uint = 0;
         var _loc56_:GIDObjectData = null;
         var _loc57_:ItemWrapper = null;
         var _loc58_:Vector.<int> = null;
         var _loc59_:uint = 0;
         var _loc60_:GIDObjectData = null;
         var _loc61_:ItemWrapper = null;
         var _loc62_:Vector.<int> = null;
         var _loc63_:uint = 0;
         var _loc64_:ItemSellByBid = null;
         var _loc65_:TypeObjectData = null;
         var _loc66_:Array = null;
         var _loc67_:GIDObjectData = null;
         var _loc68_:uint = 0;
         var _loc69_:TypeObjectData = null;
         var _loc70_:GIDObjectData = null;
         var _loc71_:BidExchangerObjectInfo = null;
         var _loc72_:ItemWrapper = null;
         var _loc73_:Vector.<int> = null;
         var _loc74_:uint = 0;
         var _loc75_:Array = null;
         var _loc76_:Object = null;
         var _loc77_:String = null;
         switch(true)
         {
            case param1 is ExchangeBidHouseSearchAction:
               _loc2_ = param1 as ExchangeBidHouseSearchAction;
               if(this._typeAsk != _loc2_.type || this._typeAsk == _loc2_.type)
               {
                  _loc48_ = new ExchangeBidHouseSearchMessage();
                  _loc48_.initExchangeBidHouseSearchMessage(_loc2_.type,_loc2_.genId);
                  this._typeAsk = _loc2_.type;
                  this._GIDAsk = _loc2_.genId;
                  this._serverConnection.send(_loc48_);
               }
               return true;
            case param1 is ExchangeBidHouseListAction:
               _loc3_ = param1 as ExchangeBidHouseListAction;
               if(this._GIDAsk != _loc3_.id)
               {
                  this._GIDAsk = _loc3_.id;
                  _loc49_ = new ExchangeBidHouseListMessage();
                  _loc49_.initExchangeBidHouseListMessage(_loc3_.id);
                  this._serverConnection.send(_loc49_);
               }
               else
               {
                  _loc50_ = new ExchangeBidHouseListMessage();
                  _loc50_.initExchangeBidHouseListMessage(_loc3_.id);
                  this._serverConnection.send(_loc50_);
               }
               return true;
            case param1 is ExchangeBidHouseTypeAction:
               _loc4_ = param1 as ExchangeBidHouseTypeAction;
               _loc5_ = new ExchangeBidHouseTypeMessage();
               if(this._typeAsk != _loc4_.type)
               {
                  this._typeAsk = _loc4_.type;
                  _loc5_.initExchangeBidHouseTypeMessage(_loc4_.type);
                  this._serverConnection.send(_loc5_);
               }
               else
               {
                  _loc5_.initExchangeBidHouseTypeMessage(_loc4_.type);
                  this._serverConnection.send(_loc5_);
               }
               return true;
            case param1 is ExchangeBidHouseBuyAction:
               _loc6_ = param1 as ExchangeBidHouseBuyAction;
               _loc7_ = new ExchangeBidHouseBuyMessage();
               _loc7_.initExchangeBidHouseBuyMessage(_loc6_.uid,_loc6_.qty,_loc6_.price);
               this._serverConnection.send(_loc7_);
               return true;
            case param1 is ExchangeBidHousePriceAction:
               _loc8_ = param1 as ExchangeBidHousePriceAction;
               _loc9_ = new ExchangeBidHousePriceMessage();
               _loc9_.initExchangeBidHousePriceMessage(_loc8_.genId);
               this._serverConnection.send(_loc9_);
               return true;
            case param1 is ExchangeBidPriceMessage:
               _loc10_ = param1 as ExchangeBidPriceMessage;
               this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeBidPrice,_loc10_.genericId,_loc10_.averagePrice);
               return true;
            case param1 is ExchangeBidHouseItemAddOkMessage:
               _loc11_ = param1 as ExchangeBidHouseItemAddOkMessage;
               _loc12_ = Item.getItemById(_loc11_.itemInfo.objectGID);
               _loc13_ = ItemWrapper.create(63,_loc11_.itemInfo.objectUID,_loc11_.itemInfo.objectGID,_loc11_.itemInfo.quantity,_loc11_.itemInfo.effects);
               _loc14_ = _loc11_.itemInfo.objectPrice;
               _loc15_ = _loc11_.itemInfo.unsoldDelay;
               this._vendorObjects.push(new ItemSellByPlayer(_loc13_,_loc14_,_loc15_));
               this._kernelEventsManager.processCallback(ExchangeHookList.SellerObjectListUpdate,this._vendorObjects);
               return true;
            case param1 is ExchangeBidHouseItemRemoveOkMessage:
               _loc16_ = param1 as ExchangeBidHouseItemRemoveOkMessage;
               _loc17_ = 0;
               for each(_loc51_ in this._vendorObjects)
               {
                  if(_loc51_.itemWrapper.objectUID == _loc16_.sellerId)
                  {
                     this._vendorObjects.splice(_loc17_,1);
                  }
                  _loc17_++;
               }
               this._kernelEventsManager.processCallback(ExchangeHookList.SellerObjectListUpdate,this._vendorObjects);
               return true;
            case param1 is ExchangeBidHouseGenericItemAddedMessage:
               _loc18_ = param1 as ExchangeBidHouseGenericItemAddedMessage;
               _loc19_ = this.getTypeObject(this._typeAsk);
               _loc19_.objects.push(new GIDObjectData(_loc18_.objGenericId,new Array()));
               this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectTypeListUpdate,_loc19_.objects);
               return true;
            case param1 is ExchangeBidHouseGenericItemRemovedMessage:
               _loc20_ = param1 as ExchangeBidHouseGenericItemRemovedMessage;
               _loc21_ = this.getTypeObject(this._typeAsk);
               _loc22_ = this.getGIDObjectIndex(this._typeAsk,_loc20_.objGenericId);
               if(_loc22_ == -1)
               {
                  return true;
               }
               _loc21_.objects.splice(_loc22_,1);
               this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectTypeListUpdate,_loc21_.objects);
               return true;
               break;
            case param1 is ExchangeBidHouseInListUpdatedMessage:
               _loc23_ = param1 as ExchangeBidHouseInListUpdatedMessage;
               _loc24_ = this.getTypeObject(this._typeAsk);
               for each(_loc52_ in _loc24_.objects)
               {
                  if(_loc52_.GIDObject == _loc23_.objGenericId)
                  {
                     _loc25_ = _loc52_;
                     for each(_loc53_ in _loc52_.objects)
                     {
                        if(_loc53_.itemWrapper.objectUID == _loc23_.itemUID)
                        {
                           _loc53_.itemWrapper.update(63,_loc23_.itemUID,_loc23_.objGenericId,1,_loc23_.effects);
                           _loc54_ = new Vector.<int>();
                           for each(_loc55_ in _loc23_.prices)
                           {
                              _loc54_.push(_loc55_ as int);
                           }
                           _loc53_.prices = _loc54_;
                        }
                     }
                  }
               }
               this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectListUpdate,_loc25_.objects);
               return true;
            case param1 is ExchangeBidHouseInListAddedMessage:
               _loc26_ = param1 as ExchangeBidHouseInListAddedMessage;
               _loc27_ = this.getTypeObject(this._typeAsk);
               for each(_loc56_ in _loc27_.objects)
               {
                  if(_loc56_.GIDObject == _loc26_.objGenericId)
                  {
                     _loc28_ = _loc56_;
                     if(_loc56_.objects == null)
                     {
                        _loc56_.objects = new Array();
                     }
                     _loc57_ = ItemWrapper.create(63,_loc26_.itemUID,_loc26_.objGenericId,1,_loc26_.effects);
                     _loc58_ = new Vector.<int>();
                     for each(_loc59_ in _loc26_.prices)
                     {
                        _loc58_.push(_loc59_ as int);
                     }
                     _loc56_.objects.push(new ItemSellByBid(_loc57_,_loc58_));
                  }
               }
               if(!_loc28_)
               {
                  _loc28_ = _loc60_ = new GIDObjectData(_loc26_.objGenericId,new Array());
                  _loc61_ = ItemWrapper.create(63,_loc26_.itemUID,_loc26_.objGenericId,1,_loc26_.effects);
                  _loc62_ = new Vector.<int>();
                  for each(_loc63_ in _loc26_.prices)
                  {
                     _loc62_.push(_loc63_ as int);
                  }
                  _loc60_.objects.push(new ItemSellByBid(_loc61_,_loc62_));
                  _loc27_.objects.push(_loc60_);
                  this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectTypeListUpdate,_loc27_.objects);
               }
               this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectListUpdate,_loc28_.objects);
               return true;
            case param1 is ExchangeBidHouseInListRemovedMessage:
               _loc29_ = param1 as ExchangeBidHouseInListRemovedMessage;
               _loc30_ = 0;
               _loc31_ = this.getGIDObject(this._typeAsk,this._GIDAsk);
               _loc32_ = 0;
               if(_loc31_ == null)
               {
                  return true;
               }
               for each(_loc64_ in _loc31_.objects)
               {
                  if(_loc29_.itemUID == _loc64_.itemWrapper.objectUID)
                  {
                     _loc31_.objects.splice(_loc32_,1);
                  }
                  _loc32_++;
               }
               if(_loc31_.objects.length == 0)
               {
                  _loc65_ = this.getTypeObject(this._typeAsk);
                  _loc66_ = new Array();
                  for each(_loc67_ in _loc65_.objects)
                  {
                     if(_loc67_.GIDObject != this._GIDAsk)
                     {
                        _loc66_.push(_loc67_);
                     }
                  }
                  _loc65_.objects = _loc66_;
                  this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectTypeListUpdate,_loc65_.objects);
               }
               this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectListUpdate,_loc31_.objects);
               return true;
               break;
            case param1 is ExchangeTypesExchangerDescriptionForUserMessage:
               _loc33_ = param1 as ExchangeTypesExchangerDescriptionForUserMessage;
               _loc34_ = this.getTypeObject(this._typeAsk);
               _loc34_.objects = new Array();
               for each(_loc68_ in _loc33_.typeDescription)
               {
                  _loc34_.objects.push(new GIDObjectData(_loc68_,new Array()));
               }
               this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectTypeListUpdate,_loc34_.objects);
               return true;
            case param1 is ExchangeTypesItemsExchangerDescriptionForUserMessage:
               _loc35_ = param1 as ExchangeTypesItemsExchangerDescriptionForUserMessage;
               _loc36_ = this.getGIDObject(this._typeAsk,this._GIDAsk);
               if(!_loc36_)
               {
                  _loc69_ = this.getTypeObject(this._typeAsk);
                  _loc70_ = new GIDObjectData(this._GIDAsk,new Array());
                  if(!_loc69_.objects)
                  {
                     _loc69_.objects = new Array();
                  }
                  if(_loc69_.objects.indexOf(_loc70_) == -1)
                  {
                     _loc69_.objects.push(_loc70_);
                  }
               }
               _loc37_ = this.getGIDObject(this._typeAsk,this._GIDAsk);
               if(_loc37_)
               {
                  _loc37_.objects = new Array();
                  for each(_loc71_ in _loc35_.itemTypeDescriptions)
                  {
                     _loc72_ = ItemWrapper.create(63,_loc71_.objectUID,this._GIDAsk,1,_loc71_.effects);
                     _loc73_ = new Vector.<int>();
                     for each(_loc74_ in _loc71_.prices)
                     {
                        _loc73_.push(_loc74_ as int);
                     }
                     _loc37_.objects.push(new ItemSellByBid(_loc72_,_loc73_));
                  }
                  this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectListUpdate,_loc37_.objects,false,true);
               }
               else
               {
                  this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectListUpdate,null,false,true);
               }
               return true;
            case param1 is ExchangeBidSearchOkMessage:
               _loc38_ = param1 as ExchangeBidSearchOkMessage;
               return true;
            case param1 is BidHouseStringSearchAction:
               _loc39_ = param1 as BidHouseStringSearchAction;
               _loc40_ = _loc39_.searchString;
               _loc43_ = getTimer();
               _loc44_ = new Vector.<uint>();
               if(this._listItemsSearchMode == null)
               {
                  this._listItemsSearchMode = new Array();
                  _loc75_ = Item.getItems();
                  _loc42_ = int(_loc75_.length);
                  _loc41_ = 0;
                  while(_loc41_ < _loc42_)
                  {
                     _loc76_ = _loc75_[_loc41_];
                     if((Boolean(_loc76_)) && this._itemsTypesAllowed.indexOf(_loc76_.typeId) != -1)
                     {
                        if(_loc76_.name)
                        {
                           this._listItemsSearchMode.push(_loc76_.name.toLowerCase(),_loc76_.id);
                        }
                     }
                     _loc41_++;
                  }
                  _log.debug("Initialisation recherche HDV en " + (getTimer() - _loc43_) + " ms.");
               }
               _loc42_ = int(this._listItemsSearchMode.length);
               _loc41_ = 0;
               while(_loc41_ < _loc42_)
               {
                  _loc77_ = this._listItemsSearchMode[_loc41_];
                  if(_loc77_.indexOf(_loc40_) != -1)
                  {
                     _loc44_.push(this._listItemsSearchMode[_loc41_ + 1]);
                  }
                  _loc41_ += 2;
               }
               this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectTypeListUpdate,_loc44_,true);
               return true;
            case param1 is BidSwitchToBuyerModeAction:
               this._switching = true;
               _loc45_ = new NpcGenericActionRequestMessage();
               _loc45_.initNpcGenericActionRequestMessage(this._NPCId,6,PlayedCharacterManager.getInstance().currentMap.mapId);
               ConnectionsHandler.getConnection().send(_loc45_);
               return true;
            case param1 is BidSwitchToSellerModeAction:
               this._switching = true;
               _loc46_ = new NpcGenericActionRequestMessage();
               _loc46_.initNpcGenericActionRequestMessage(this._NPCId,5,PlayedCharacterManager.getInstance().currentMap.mapId);
               ConnectionsHandler.getConnection().send(_loc46_);
               return true;
            case param1 is ExchangeLeaveMessage:
               _loc47_ = param1 as ExchangeLeaveMessage;
               if(_loc47_.dialogType == DialogTypeEnum.DIALOG_EXCHANGE)
               {
                  PlayedCharacterManager.getInstance().isInExchange = false;
                  this._success = _loc47_.success;
                  Kernel.getWorker().removeFrame(this);
               }
               return true;
            default:
               return false;
         }
      }
      
      public function pushed() : Boolean
      {
         this._success = false;
         return true;
      }
      
      public function pulled() : Boolean
      {
         if(!this.switching)
         {
            if(Kernel.getWorker().contains(CommonExchangeManagementFrame))
            {
               Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(CommonExchangeManagementFrame));
            }
            KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeLeave,this._success);
         }
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
      
      private function getTypeObject(param1:uint) : TypeObjectData
      {
         var _loc2_:TypeObjectData = null;
         if(this._bidHouseObjects == null)
         {
            return null;
         }
         for each(_loc2_ in this._bidHouseObjects)
         {
            if(_loc2_.typeObject == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function getGIDObject(param1:uint, param2:uint) : GIDObjectData
      {
         var _loc4_:GIDObjectData = null;
         if(this._bidHouseObjects == null)
         {
            return null;
         }
         var _loc3_:TypeObjectData = this.getTypeObject(param1);
         if(_loc3_ == null)
         {
            return null;
         }
         for each(_loc4_ in _loc3_.objects)
         {
            if(_loc4_.GIDObject == param2)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      private function getGIDObjectIndex(param1:uint, param2:uint) : int
      {
         var _loc5_:GIDObjectData = null;
         if(this._bidHouseObjects == null)
         {
            return -1;
         }
         var _loc3_:TypeObjectData = this.getTypeObject(param1);
         if(_loc3_ == null)
         {
            return -1;
         }
         var _loc4_:int = 0;
         for each(_loc5_ in _loc3_.objects)
         {
            if(_loc5_.GIDObject == param2)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return -1;
      }
      
      private function initSearchMode(param1:Vector.<uint>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(this._itemsTypesAllowed)
         {
            _loc2_ = int(param1.length);
            if(_loc2_ == this._itemsTypesAllowed.length)
            {
               _loc3_ = false;
               _loc4_ = 0;
               while(_loc4_ < _loc2_)
               {
                  if(param1[_loc4_] != this._itemsTypesAllowed[_loc4_])
                  {
                     _loc3_ = true;
                     break;
                  }
                  _loc4_++;
               }
               if(_loc3_)
               {
                  this._listItemsSearchMode = null;
               }
            }
            else
            {
               this._listItemsSearchMode = null;
            }
         }
         else
         {
            this._listItemsSearchMode = null;
         }
         this._itemsTypesAllowed = param1;
      }
   }
}

import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;

class ItemSellByPlayer
{
   public var itemWrapper:ItemWrapper;
   
   public var price:int;
   
   public var unsoldDelay:uint;
   
   public function ItemSellByPlayer(param1:ItemWrapper, param2:int, param3:uint)
   {
      super();
      this.itemWrapper = param1;
      this.price = param2;
      this.unsoldDelay = param3;
   }
}

class ItemSellByBid
{
   public var itemWrapper:ItemWrapper;
   
   public var prices:Vector.<int>;
   
   public function ItemSellByBid(param1:ItemWrapper, param2:Vector.<int>)
   {
      super();
      this.itemWrapper = param1;
      this.prices = param2;
   }
}

class TypeObjectData
{
   public var objects:Array;
   
   public var typeObject:uint;
   
   public function TypeObjectData(param1:uint, param2:Array)
   {
      super();
      this.objects = param2;
      this.typeObject = param1;
   }
}

class GIDObjectData
{
   public var objects:Array;
   
   public var GIDObject:uint;
   
   public function GIDObjectData(param1:uint, param2:Array)
   {
      super();
      this.objects = param2;
      this.GIDObject = param1;
   }
}
