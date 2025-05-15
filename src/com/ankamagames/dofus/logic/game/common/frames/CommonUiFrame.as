package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.dofus.datacenter.communication.InfoMessage;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatBubble;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.frames.DisconnectionHandlerFrame;
   import com.ankamagames.dofus.logic.connection.messages.DelayedSystemMessageDisplayMessage;
   import com.ankamagames.dofus.logic.game.common.actions.CloseInventoryAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenArenaAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenBookAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenInventoryAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenMainMenuAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenMapAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenMountAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenSmileysAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenStatsAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenTeamSearchAction;
   import com.ankamagames.dofus.logic.game.common.managers.FlagManager;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleHelpWantedAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleLockFightAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleLockPartyAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleWitnessForbiddenAction;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayInteractivesFrame;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.CustomUiHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.misc.utils.ParamsDecoder;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.FightOptionsEnum;
   import com.ankamagames.dofus.network.enums.NumericalValueTypeEnum;
   import com.ankamagames.dofus.network.enums.SubscriptionRequiredEnum;
   import com.ankamagames.dofus.network.enums.TextInformationTypeEnum;
   import com.ankamagames.dofus.network.messages.game.atlas.AtlasPointInformationsMessage;
   import com.ankamagames.dofus.network.messages.game.context.display.DisplayNumericalValueMessage;
   import com.ankamagames.dofus.network.messages.game.context.display.DisplayNumericalValueWithAgeBonusMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightOptionStateUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightOptionToggleMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.EntityTalkMessage;
   import com.ankamagames.dofus.network.messages.game.subscriber.SubscriptionLimitationMessage;
   import com.ankamagames.dofus.network.messages.game.subscriber.SubscriptionZoneMessage;
   import com.ankamagames.dofus.network.messages.game.ui.ClientUIOpenedByObjectMessage;
   import com.ankamagames.dofus.network.messages.game.ui.ClientUIOpenedMessage;
   import com.ankamagames.dofus.network.messages.server.basic.SystemMessageDisplayMessage;
   import com.ankamagames.dofus.network.types.game.context.MapCoordinatesExtended;
   import com.ankamagames.dofus.types.characteristicContextual.CharacteristicContextualManager;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import flash.events.TimerEvent;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class CommonUiFrame implements Frame
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(CommonUiFrame));
      
      private var _dnvmsgs:Dictionary;
      
      public function CommonUiFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return 0;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:OpenSmileysAction = null;
         var _loc3_:OpenBookAction = null;
         var _loc4_:OpenTeamSearchAction = null;
         var _loc5_:OpenArenaAction = null;
         var _loc6_:IEntity = null;
         var _loc7_:OpenInventoryAction = null;
         var _loc8_:DisplayNumericalValueMessage = null;
         var _loc9_:IEntity = null;
         var _loc10_:uint = 0;
         var _loc11_:Timer = null;
         var _loc12_:DelayedSystemMessageDisplayMessage = null;
         var _loc13_:SystemMessageDisplayMessage = null;
         var _loc14_:ClientUIOpenedByObjectMessage = null;
         var _loc15_:ClientUIOpenedMessage = null;
         var _loc16_:EntityTalkMessage = null;
         var _loc17_:IDisplayable = null;
         var _loc18_:String = null;
         var _loc19_:uint = 0;
         var _loc20_:Array = null;
         var _loc21_:uint = 0;
         var _loc22_:Array = null;
         var _loc23_:ChatBubble = null;
         var _loc24_:SubscriptionLimitationMessage = null;
         var _loc25_:String = null;
         var _loc26_:SubscriptionZoneMessage = null;
         var _loc27_:AtlasPointInformationsMessage = null;
         var _loc28_:GameFightOptionStateUpdateMessage = null;
         var _loc29_:uint = 0;
         var _loc30_:GameFightOptionToggleMessage = null;
         var _loc31_:uint = 0;
         var _loc32_:GameFightOptionToggleMessage = null;
         var _loc33_:uint = 0;
         var _loc34_:GameFightOptionToggleMessage = null;
         var _loc35_:uint = 0;
         var _loc36_:GameFightOptionToggleMessage = null;
         var _loc37_:RoleplayInteractivesFrame = null;
         var _loc38_:DelayedSystemMessageDisplayMessage = null;
         var _loc39_:* = undefined;
         var _loc40_:Array = null;
         var _loc41_:MapCoordinatesExtended = null;
         switch(true)
         {
            case param1 is OpenSmileysAction:
               _loc2_ = param1 as OpenSmileysAction;
               KernelEventsManager.getInstance().processCallback(HookList.SmileysStart,_loc2_.type,_loc2_.forceOpen);
               return true;
            case param1 is OpenBookAction:
               _loc3_ = param1 as OpenBookAction;
               KernelEventsManager.getInstance().processCallback(HookList.OpenBook,_loc3_.value,_loc3_.param);
               return true;
            case param1 is OpenTeamSearchAction:
               _loc4_ = param1 as OpenTeamSearchAction;
               KernelEventsManager.getInstance().processCallback(TriggerHookList.OpenTeamSearch);
               return true;
            case param1 is OpenArenaAction:
               _loc5_ = param1 as OpenArenaAction;
               KernelEventsManager.getInstance().processCallback(TriggerHookList.OpenArena);
               return true;
            case param1 is OpenMapAction:
               _loc6_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
               if(!_loc6_)
               {
                  return true;
               }
               TooltipManager.hideAll();
               KernelEventsManager.getInstance().processCallback(HookList.OpenMap,(param1 as OpenMapAction).conquest);
               if((_loc6_ as IMovable).isMoving && !Kernel.getWorker().getFrame(FightContextFrame))
               {
                  (_loc6_ as IMovable).stop();
               }
               return true;
               break;
            case param1 is OpenInventoryAction:
               _loc7_ = param1 as OpenInventoryAction;
               KernelEventsManager.getInstance().processCallback(HookList.OpenInventory,_loc7_.behavior);
               return true;
            case param1 is CloseInventoryAction:
               KernelEventsManager.getInstance().processCallback(HookList.CloseInventory);
               return true;
            case param1 is OpenMountAction:
               KernelEventsManager.getInstance().processCallback(HookList.OpenMount);
               return true;
            case param1 is OpenMainMenuAction:
               KernelEventsManager.getInstance().processCallback(HookList.OpenMainMenu);
               return true;
            case param1 is OpenStatsAction:
               KernelEventsManager.getInstance().processCallback(HookList.OpenStats,InventoryManager.getInstance().inventory.getView("equipment").content);
               return true;
            case param1 is DisplayNumericalValueMessage:
               _loc8_ = param1 as DisplayNumericalValueMessage;
               _loc9_ = DofusEntities.getEntity(_loc8_.entityId);
               _loc10_ = 0;
               switch(_loc8_.type)
               {
                  case NumericalValueTypeEnum.NUMERICAL_VALUE_COLLECT:
                     _loc10_ = 7615756;
                     _loc37_ = Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame;
                     if((Boolean(_loc37_)) && (_loc9_ as IAnimated).getAnimation() != AnimationEnum.ANIM_STATIQUE)
                     {
                        _loc11_ = _loc37_.getInteractiveActionTimer(_loc9_);
                     }
                     if(Boolean(_loc11_) && _loc11_.running)
                     {
                        this._dnvmsgs[_loc11_] = _loc8_;
                        _loc11_.addEventListener(TimerEvent.TIMER,this.onAnimEnd);
                     }
                     else
                     {
                        this.displayNumericalValue(_loc9_,_loc8_,_loc10_);
                     }
                     return true;
                  default:
                     _log.warn("DisplayNumericalValueMessage with unsupported type : " + _loc8_.type);
                     return false;
               }
               break;
            case param1 is DelayedSystemMessageDisplayMessage:
               _loc12_ = param1 as DelayedSystemMessageDisplayMessage;
               this.systemMessageDisplay(_loc12_);
               return true;
            case param1 is SystemMessageDisplayMessage:
               _loc13_ = param1 as SystemMessageDisplayMessage;
               if(_loc13_.hangUp)
               {
                  _loc38_ = new DelayedSystemMessageDisplayMessage();
                  _loc38_.initDelayedSystemMessageDisplayMessage(_loc13_.hangUp,_loc13_.msgId,_loc13_.parameters);
                  DisconnectionHandlerFrame.messagesAfterReset.push(_loc38_);
               }
               this.systemMessageDisplay(_loc13_);
               return true;
            case param1 is ClientUIOpenedByObjectMessage:
               _loc14_ = param1 as ClientUIOpenedByObjectMessage;
               KernelEventsManager.getInstance().processCallback(CustomUiHookList.ClientUIOpened,_loc14_.type,_loc14_.uid);
               return true;
            case param1 is ClientUIOpenedMessage:
               _loc15_ = param1 as ClientUIOpenedMessage;
               KernelEventsManager.getInstance().processCallback(CustomUiHookList.ClientUIOpened,_loc15_.type,0);
               return true;
            case param1 is EntityTalkMessage:
               _loc16_ = param1 as EntityTalkMessage;
               _loc17_ = DofusEntities.getEntity(_loc16_.entityId) as IDisplayable;
               _loc20_ = new Array();
               _loc21_ = TextInformationTypeEnum.TEXT_ENTITY_TALK;
               if(_loc17_ == null)
               {
                  return true;
               }
               _loc22_ = new Array();
               for each(_loc39_ in _loc16_.parameters)
               {
                  _loc22_.push(_loc39_);
               }
               if(InfoMessage.getInfoMessageById(_loc21_ * 10000 + _loc16_.textId))
               {
                  _loc19_ = InfoMessage.getInfoMessageById(_loc21_ * 10000 + _loc16_.textId).textId;
                  if(_loc22_ != null)
                  {
                     if(Boolean(_loc22_[0]) && _loc22_[0].indexOf("~") != -1)
                     {
                        _loc20_ = _loc22_[0].split("~");
                     }
                     else
                     {
                        _loc20_ = _loc22_;
                     }
                  }
               }
               else
               {
                  _log.error("Texte " + (_loc21_ * 10000 + _loc16_.textId) + " not found.");
                  _loc18_ = "" + _loc16_.textId;
               }
               if(!_loc18_)
               {
                  _loc18_ = I18n.getText(_loc19_,_loc20_);
               }
               _loc23_ = new ChatBubble(_loc18_);
               TooltipManager.show(_loc23_,_loc17_.absoluteBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),true,"entityMsg" + _loc16_.entityId,LocationEnum.POINT_BOTTOMLEFT,LocationEnum.POINT_TOPRIGHT,0,true,null,null);
               return true;
               break;
            case param1 is SubscriptionLimitationMessage:
               _loc24_ = param1 as SubscriptionLimitationMessage;
               _log.error("SubscriptionLimitationMessage reason " + _loc24_.reason);
               _loc25_ = "";
               switch(_loc24_.reason)
               {
                  case SubscriptionRequiredEnum.LIMIT_ON_JOB_XP:
                     _loc25_ = I18n.getUiText("ui.payzone.limitJobXp");
                     break;
                  case SubscriptionRequiredEnum.LIMIT_ON_JOB_USE:
                     _loc25_ = I18n.getUiText("ui.payzone.limitJobXp");
                     break;
                  case SubscriptionRequiredEnum.LIMIT_ON_MAP:
                     _loc25_ = I18n.getUiText("ui.payzone.limit");
                     break;
                  case SubscriptionRequiredEnum.LIMIT_ON_ITEM:
                     _loc25_ = I18n.getUiText("ui.payzone.limitItem");
                     break;
                  case SubscriptionRequiredEnum.LIMIT_ON_VENDOR:
                     _loc25_ = I18n.getUiText("ui.payzone.limitVendor");
                     break;
                  case SubscriptionRequiredEnum.LIMITED_TO_SUBSCRIBER:
                  default:
                     _loc25_ = I18n.getUiText("ui.payzone.limit");
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc25_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               KernelEventsManager.getInstance().processCallback(HookList.NonSubscriberPopup);
               return true;
            case param1 is SubscriptionZoneMessage:
               _loc26_ = param1 as SubscriptionZoneMessage;
               _log.error("SubscriptionZoneMessage active " + _loc26_.active);
               KernelEventsManager.getInstance().processCallback(HookList.SubscriptionZone,_loc26_.active);
               return true;
            case param1 is AtlasPointInformationsMessage:
               _loc27_ = AtlasPointInformationsMessage(param1);
               if(_loc27_.type.type == 3)
               {
                  _loc40_ = new Array();
                  for each(_loc41_ in _loc27_.type.coords)
                  {
                     _loc40_.push(_loc41_.mapId);
                  }
                  FlagManager.getInstance().phoenixs = _loc40_;
                  KernelEventsManager.getInstance().processCallback(HookList.phoenixUpdate);
               }
               return true;
            case param1 is GameFightOptionStateUpdateMessage:
               _loc28_ = param1 as GameFightOptionStateUpdateMessage;
               switch(_loc28_.option)
               {
                  case FightOptionsEnum.FIGHT_OPTION_SET_SECRET:
                     KernelEventsManager.getInstance().processCallback(HookList.OptionWitnessForbidden,_loc28_.state);
                     break;
                  case FightOptionsEnum.FIGHT_OPTION_SET_TO_PARTY_ONLY:
                     if(Kernel.getWorker().getFrame(FightContextFrame))
                     {
                        KernelEventsManager.getInstance().processCallback(HookList.OptionLockParty,_loc28_.state);
                     }
                     break;
                  case FightOptionsEnum.FIGHT_OPTION_SET_CLOSED:
                     if(PlayedCharacterManager.getInstance().teamId == _loc28_.teamId)
                     {
                        KernelEventsManager.getInstance().processCallback(HookList.OptionLockFight,_loc28_.state);
                     }
                     break;
                  case FightOptionsEnum.FIGHT_OPTION_ASK_FOR_HELP:
                     KernelEventsManager.getInstance().processCallback(HookList.OptionHelpWanted,_loc28_.state);
               }
               return false;
            case param1 is ToggleWitnessForbiddenAction:
               _loc29_ = FightOptionsEnum.FIGHT_OPTION_SET_SECRET;
               _loc30_ = new GameFightOptionToggleMessage();
               _loc30_.initGameFightOptionToggleMessage(_loc29_);
               ConnectionsHandler.getConnection().send(_loc30_);
               return true;
            case param1 is ToggleLockPartyAction:
               _loc31_ = FightOptionsEnum.FIGHT_OPTION_SET_TO_PARTY_ONLY;
               _loc32_ = new GameFightOptionToggleMessage();
               _loc32_.initGameFightOptionToggleMessage(_loc31_);
               ConnectionsHandler.getConnection().send(_loc32_);
               return true;
            case param1 is ToggleLockFightAction:
               _loc33_ = FightOptionsEnum.FIGHT_OPTION_SET_CLOSED;
               _loc34_ = new GameFightOptionToggleMessage();
               _loc34_.initGameFightOptionToggleMessage(_loc33_);
               ConnectionsHandler.getConnection().send(_loc34_);
               return true;
            case param1 is ToggleHelpWantedAction:
               _loc35_ = FightOptionsEnum.FIGHT_OPTION_ASK_FOR_HELP;
               _loc36_ = new GameFightOptionToggleMessage();
               _loc36_.initGameFightOptionToggleMessage(_loc35_);
               ConnectionsHandler.getConnection().send(_loc36_);
               return true;
            default:
               return false;
         }
      }
      
      public function pushed() : Boolean
      {
         this._dnvmsgs = new Dictionary(true);
         return true;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      private function onAnimEnd(param1:TimerEvent) : void
      {
         param1.currentTarget.removeEventListener(TimerEvent.TIMER,this.onAnimEnd);
         var _loc2_:DisplayNumericalValueMessage = this._dnvmsgs[param1.currentTarget];
         this.displayNumericalValue(DofusEntities.getEntity(_loc2_.entityId),_loc2_,7615756,1,1500);
         delete this._dnvmsgs[param1.currentTarget];
      }
      
      private function displayNumericalValue(param1:IEntity, param2:DisplayNumericalValueMessage, param3:uint, param4:Number = 1, param5:uint = 2500) : void
      {
         this.displayValue(param1,param2.value.toString(),param3,param4,param5);
         var _loc6_:DisplayNumericalValueWithAgeBonusMessage = param2 as DisplayNumericalValueWithAgeBonusMessage;
         if(_loc6_)
         {
            this.displayValue(param1,_loc6_.valueOfBonus.toString(),16733440,param4,param5);
         }
      }
      
      private function displayValue(param1:IEntity, param2:String, param3:uint, param4:Number, param5:uint) : void
      {
         CharacteristicContextualManager.getInstance().addStatContextual(param2,param1,new TextFormat("Verdana",24,param3,true),1,param4,param5);
      }
      
      private function systemMessageDisplay(param1:SystemMessageDisplayMessage) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = null;
         var _loc6_:InfoMessage = null;
         var _loc7_:uint = 0;
         var _loc2_:Object = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
         var _loc3_:Array = new Array();
         for each(_loc4_ in param1.parameters)
         {
            _loc3_.push(_loc4_);
         }
         _loc6_ = InfoMessage.getInfoMessageById(40000 + param1.msgId);
         if(_loc6_)
         {
            _loc7_ = _loc6_.textId;
            _loc5_ = I18n.getText(_loc7_);
            if(_loc5_)
            {
               _loc5_ = ParamsDecoder.applyParams(_loc5_,_loc3_);
            }
         }
         else
         {
            _log.error("Information message " + (40000 + param1.msgId) + " cannot be found.");
            _loc5_ = "Information message " + (40000 + param1.msgId) + " cannot be found.";
         }
         _loc2_.openPopup(I18n.getUiText("ui.popup.warning"),_loc5_,[I18n.getUiText("ui.common.ok")],null,null,null,null,false,true);
      }
   }
}

