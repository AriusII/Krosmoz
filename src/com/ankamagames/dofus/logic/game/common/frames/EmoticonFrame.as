package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.internalDatacenter.communication.EmoteWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ShortcutWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.managers.AccountManager;
   import com.ankamagames.dofus.logic.common.managers.NotificationManager;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.roleplay.actions.EmotePlayRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayMovementFrame;
   import com.ankamagames.dofus.logic.game.roleplay.messages.GameRolePlaySetAnimationMessage;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.misc.lists.RoleplayHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.PlayerLifeStatusEnum;
   import com.ankamagames.dofus.network.messages.game.character.stats.LifePointsRegenBeginMessage;
   import com.ankamagames.dofus.network.messages.game.character.stats.LifePointsRegenEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmoteAddMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmoteListMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayErrorMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayMassiveMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmoteRemoveMessage;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.dofus.types.enums.NotificationTypeEnum;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.utils.clearInterval;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setInterval;
   
   public class EmoticonFrame implements Frame
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(EmoticonFrame));
      
      private var _emotes:Array;
      
      private var _emotesList:Array;
      
      private var _interval:Number;
      
      private var _bEmoteOn:Boolean = false;
      
      public function EmoticonFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get emotes() : Array
      {
         this._emotes.sort(Array.NUMERIC);
         return this._emotes;
      }
      
      public function get emotesList() : Array
      {
         this._emotesList.sortOn("order",Array.NUMERIC);
         return this._emotesList;
      }
      
      private function get socialFrame() : SocialFrame
      {
         return Kernel.getWorker().getFrame(SocialFrame) as SocialFrame;
      }
      
      private function get roleplayEntitiesFrame() : RoleplayEntitiesFrame
      {
         return Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
      }
      
      private function get roleplayMovementFrame() : RoleplayMovementFrame
      {
         return Kernel.getWorker().getFrame(RoleplayMovementFrame) as RoleplayMovementFrame;
      }
      
      public function pushed() : Boolean
      {
         this._emotes = new Array();
         this._emotesList = new Array();
         return true;
      }
      
      public function isKnownEmote(param1:int) : Boolean
      {
         return this._emotes.indexOf(param1) != -1;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:ShortcutWrapper = null;
         var _loc3_:EmoteListMessage = null;
         var _loc4_:uint = 0;
         var _loc5_:EmoteAddMessage = null;
         var _loc6_:Emoticon = null;
         var _loc7_:EmoteWrapper = null;
         var _loc8_:String = null;
         var _loc9_:EmoteRemoveMessage = null;
         var _loc10_:String = null;
         var _loc11_:EmotePlayRequestAction = null;
         var _loc12_:Emoticon = null;
         var _loc13_:EmotePlayRequestMessage = null;
         var _loc14_:IEntity = null;
         var _loc15_:EmotePlayMessage = null;
         var _loc16_:GameContextActorInformations = null;
         var _loc17_:EmotePlayMassiveMessage = null;
         var _loc18_:EmotePlayErrorMessage = null;
         var _loc19_:String = null;
         var _loc20_:LifePointsRegenBeginMessage = null;
         var _loc21_:LifePointsRegenEndMessage = null;
         var _loc22_:* = undefined;
         var _loc23_:EmoteWrapper = null;
         var _loc24_:* = undefined;
         var _loc25_:uint = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:Emoticon = null;
         var _loc29_:TiphonEntityLook = null;
         var _loc30_:String = null;
         var _loc31_:Boolean = false;
         var _loc32_:Boolean = false;
         var _loc33_:* = undefined;
         var _loc34_:GameContextActorInformations = null;
         var _loc35_:TiphonEntityLook = null;
         var _loc36_:String = null;
         var _loc37_:Boolean = false;
         var _loc38_:Boolean = false;
         var _loc39_:String = null;
         switch(true)
         {
            case param1 is EmoteListMessage:
               _loc3_ = param1 as EmoteListMessage;
               this._emotes = new Array();
               this._emotesList.splice(0,this._emotesList.length);
               _loc4_ = 0;
               for each(_loc22_ in _loc3_.emoteIds)
               {
                  this._emotes.push(_loc22_);
                  _loc23_ = EmoteWrapper.create(_loc22_,_loc4_);
                  this._emotesList.push(_loc23_);
                  _loc4_++;
               }
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.EmoteListUpdated);
               for each(_loc2_ in InventoryManager.getInstance().shortcutBarItems)
               {
                  if(Boolean(_loc2_) && _loc2_.type == 4)
                  {
                     if(this._emotes.indexOf(_loc2_.id) != -1)
                     {
                        _loc2_.active = true;
                     }
                     else
                     {
                        _loc2_.active = false;
                     }
                  }
               }
               KernelEventsManager.getInstance().processCallback(InventoryHookList.ShortcutBarViewContent,0);
               return true;
            case param1 is EmoteAddMessage:
               _loc5_ = param1 as EmoteAddMessage;
               for(_loc24_ in this._emotes)
               {
                  if(this._emotes[_loc24_] == _loc5_.emoteId)
                  {
                     return true;
                  }
               }
               _loc6_ = Emoticon.getEmoticonById(_loc5_.emoteId);
               if(!_loc6_)
               {
                  return true;
               }
               this._emotes.push(_loc5_.emoteId);
               _loc7_ = EmoteWrapper.create(_loc5_.emoteId,this._emotes.length);
               this._emotesList.push(_loc7_);
               if(!StoreDataManager.getInstance().getData(Constants.DATASTORE_COMPUTER_OPTIONS,"learnEmote" + _loc5_.emoteId))
               {
                  StoreDataManager.getInstance().setData(Constants.DATASTORE_COMPUTER_OPTIONS,"learnEmote" + _loc5_.emoteId,true);
                  _loc25_ = NotificationManager.getInstance().prepareNotification(I18n.getUiText("ui.common.emotes"),I18n.getUiText("ui.common.emoteAdded",[_loc6_.name]),NotificationTypeEnum.TUTORIAL,"new_emote_" + _loc5_.emoteId);
                  NotificationManager.getInstance().addButtonToNotification(_loc25_,I18n.getUiText("ui.common.details"),"OpenSmileys",[1,true],true,130);
                  NotificationManager.getInstance().sendNotification(_loc25_);
               }
               _loc8_ = I18n.getUiText("ui.common.emoteAdded",[Emoticon.getEmoticonById(_loc5_.emoteId).name]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc8_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.EmoteListUpdated);
               for each(_loc2_ in InventoryManager.getInstance().shortcutBarItems)
               {
                  if(_loc2_ && _loc2_.type == 4 && _loc2_.id == _loc5_.emoteId)
                  {
                     _loc2_.active = true;
                     KernelEventsManager.getInstance().processCallback(InventoryHookList.ShortcutBarViewContent,0);
                  }
               }
               return true;
               break;
            case param1 is EmoteRemoveMessage:
               _loc9_ = param1 as EmoteRemoveMessage;
               _loc26_ = 0;
               while(_loc26_ < this._emotes.length)
               {
                  if(this._emotes[_loc26_] == _loc9_.emoteId)
                  {
                     this._emotes[_loc26_] = null;
                     this._emotes.splice(_loc26_,1);
                     break;
                  }
                  _loc26_++;
               }
               _loc27_ = 0;
               while(_loc27_ < this._emotesList.length)
               {
                  if(this._emotesList[_loc27_].id == _loc9_.emoteId)
                  {
                     this._emotesList[_loc27_] = null;
                     this._emotesList.splice(_loc27_,1);
                     break;
                  }
                  _loc27_++;
               }
               _loc10_ = I18n.getUiText("ui.common.emoteRemoved",[Emoticon.getEmoticonById(_loc9_.emoteId).name]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc10_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.EmoteListUpdated);
               for each(_loc2_ in InventoryManager.getInstance().shortcutBarItems)
               {
                  if(_loc2_ && _loc2_.type == 4 && _loc2_.id == _loc9_.emoteId)
                  {
                     _loc2_.active = false;
                     KernelEventsManager.getInstance().processCallback(InventoryHookList.ShortcutBarViewContent,0);
                  }
               }
               return true;
            case param1 is EmotePlayRequestAction:
               _loc11_ = param1 as EmotePlayRequestAction;
               _loc12_ = Emoticon.getEmoticonById(_loc11_.emoteId);
               if(PlayedCharacterManager.getInstance().state != PlayerLifeStatusEnum.STATUS_ALIVE_AND_KICKING)
               {
                  return true;
               }
               if(EmoteWrapper.getEmoteWrapperById(_loc12_.id).timer > 0)
               {
                  return true;
               }
               EmoteWrapper.getEmoteWrapperById(_loc12_.id).timerToStart = _loc12_.cooldown;
               _loc13_ = new EmotePlayRequestMessage();
               _loc13_.initEmotePlayRequestMessage(_loc11_.emoteId);
               _loc14_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
               if(!_loc14_)
               {
                  return true;
               }
               if((_loc14_ as IMovable).isMoving)
               {
                  this.roleplayMovementFrame.setFollowingMessage(_loc13_);
                  (_loc14_ as IMovable).stop();
               }
               else
               {
                  ConnectionsHandler.getConnection().send(_loc13_);
               }
               return true;
               break;
            case param1 is EmotePlayMessage:
               _loc15_ = param1 as EmotePlayMessage;
               this._bEmoteOn = true;
               if(this.roleplayEntitiesFrame == null)
               {
                  return true;
               }
               _loc16_ = this.roleplayEntitiesFrame.getEntityInfos(_loc15_.actorId);
               AccountManager.getInstance().setAccountFromId(_loc15_.actorId,_loc15_.accountId);
               if(_loc16_ is GameRolePlayCharacterInformations && this.socialFrame.isIgnored(GameRolePlayCharacterInformations(_loc16_).name,_loc15_.accountId))
               {
                  return true;
               }
               if(_loc15_.emoteId == 0)
               {
                  this.roleplayEntitiesFrame.process(new GameRolePlaySetAnimationMessage(_loc16_,AnimationEnum.ANIM_STATIQUE));
               }
               else
               {
                  if(!_loc16_)
                  {
                     return true;
                  }
                  _loc28_ = Emoticon.getEmoticonById(_loc15_.emoteId);
                  if(!_loc28_)
                  {
                     _log.error("ERREUR : Le client n\'a pas de données pour l\'emote [" + _loc15_.emoteId + "].");
                     return true;
                  }
                  _loc29_ = EntityLookAdapter.fromNetwork(_loc16_.look);
                  _loc30_ = _loc28_.getAnimName(TiphonUtility.getLookWithoutMount(_loc29_));
                  _loc31_ = _loc28_.persistancy;
                  _loc32_ = _loc28_.eight_directions;
                  this.roleplayEntitiesFrame.currentEmoticon = _loc15_.emoteId;
                  this.roleplayEntitiesFrame.process(new GameRolePlaySetAnimationMessage(_loc16_,_loc30_,_loc15_.emoteStartTime,!_loc31_,_loc32_));
               }
               return true;
               break;
            case param1 is EmotePlayMassiveMessage:
               _loc17_ = param1 as EmotePlayMassiveMessage;
               this._bEmoteOn = true;
               if(this.roleplayEntitiesFrame == null)
               {
                  return true;
               }
               for each(_loc33_ in _loc17_.actorIds)
               {
                  _loc34_ = this.roleplayEntitiesFrame.getEntityInfos(_loc33_);
                  if(_loc17_.emoteId == 0)
                  {
                     this.roleplayEntitiesFrame.process(new GameRolePlaySetAnimationMessage(_loc34_,AnimationEnum.ANIM_STATIQUE));
                  }
                  else
                  {
                     _loc35_ = EntityLookAdapter.fromNetwork(_loc34_.look);
                     _loc36_ = Emoticon.getEmoticonById(_loc17_.emoteId).getAnimName(TiphonUtility.getLookWithoutMount(_loc35_));
                     _loc37_ = Emoticon.getEmoticonById(_loc17_.emoteId).persistancy;
                     _loc38_ = Emoticon.getEmoticonById(_loc17_.emoteId).eight_directions;
                     this.roleplayEntitiesFrame.currentEmoticon = _loc17_.emoteId;
                     this.roleplayEntitiesFrame.process(new GameRolePlaySetAnimationMessage(_loc34_,_loc36_,_loc17_.emoteStartTime,!_loc37_,_loc38_));
                  }
               }
               return true;
               break;
            case param1 is EmotePlayErrorMessage:
               _loc18_ = param1 as EmotePlayErrorMessage;
               _loc19_ = I18n.getUiText("ui.common.cantUseEmote");
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc19_,ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is LifePointsRegenBeginMessage:
               _loc20_ = param1 as LifePointsRegenBeginMessage;
               this._interval = setInterval(this.interval,_loc20_.regenRate * 100);
               KernelEventsManager.getInstance().processCallback(HookList.LifePointsRegenBegin,null);
               return true;
            case param1 is LifePointsRegenEndMessage:
               _loc21_ = param1 as LifePointsRegenEndMessage;
               if(this._bEmoteOn)
               {
                  if(_loc21_.lifePointsGained != 0)
                  {
                     _loc39_ = I18n.getUiText("ui.common.emoteRestoreLife",[_loc21_.lifePointsGained]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc39_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  }
                  this._bEmoteOn = false;
               }
               clearInterval(this._interval);
               PlayedCharacterManager.getInstance().characteristics.lifePoints = _loc21_.lifePoints;
               PlayedCharacterManager.getInstance().characteristics.maxLifePoints = _loc21_.maxLifePoints;
               KernelEventsManager.getInstance().processCallback(HookList.CharacterStatsList);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         if(this._interval)
         {
            clearInterval(this._interval);
         }
         return true;
      }
      
      public function interval() : void
      {
         if(Boolean(PlayedCharacterManager.getInstance()) && Boolean(PlayedCharacterManager.getInstance().characteristics))
         {
            PlayedCharacterManager.getInstance().characteristics.lifePoints = PlayedCharacterManager.getInstance().characteristics.lifePoints + 1;
            if(PlayedCharacterManager.getInstance().characteristics.lifePoints >= PlayedCharacterManager.getInstance().characteristics.maxLifePoints)
            {
               clearInterval(this._interval);
               PlayedCharacterManager.getInstance().characteristics.lifePoints = PlayedCharacterManager.getInstance().characteristics.maxLifePoints;
            }
            KernelEventsManager.getInstance().processCallback(HookList.CharacterStatsList,true);
         }
      }
   }
}

