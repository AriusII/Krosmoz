package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.quest.Achievement;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.datacenter.quest.QuestStep;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.actions.NotificationResetAction;
   import com.ankamagames.dofus.logic.game.common.actions.NotificationUpdateFlagAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.AchievementDetailedListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.AchievementDetailsRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.AchievementRewardRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.GuidedModeQuitRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.GuidedModeReturnRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestInfosRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestObjectiveValidationAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestStartRequestAction;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.QuestHookList;
   import com.ankamagames.dofus.misc.utils.ParamsDecoder;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.CompassTypeEnum;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementDetailedListMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementDetailedListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementDetailsMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementDetailsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementFinishedInformationMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementFinishedMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementListMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementRewardErrorMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementRewardRequestMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementRewardSuccessMessage;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationResetMessage;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationUpdateFlagMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.GuidedModeQuitRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.GuidedModeReturnRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestListMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestObjectiveValidatedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestObjectiveValidationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStartRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStartedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepInfoMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepInfoRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepStartedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepValidatedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestValidatedMessage;
   import com.ankamagames.dofus.network.types.game.achievement.AchievementRewardable;
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.QuestActiveDetailedInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.QuestActiveInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.QuestObjectiveInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.QuestObjectiveInformationsWithCompletion;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class QuestFrame implements Frame
   {
      public static var notificationList:Array;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(QuestFrame));
      
      private var _nbAllAchievements:int;
      
      private var _activeQuests:Vector.<QuestActiveInformations>;
      
      private var _completedQuests:Vector.<uint>;
      
      private var _questsInformations:Dictionary = new Dictionary();
      
      private var _finishedAchievementsIds:Vector.<uint>;
      
      private var _rewardableAchievements:Vector.<AchievementRewardable>;
      
      private var _rewardableAchievementsVisible:Boolean;
      
      public function QuestFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get finishedAchievementsIds() : Vector.<uint>
      {
         return this._finishedAchievementsIds;
      }
      
      public function getActiveQuests() : Vector.<QuestActiveInformations>
      {
         return this._activeQuests;
      }
      
      public function getCompletedQuests() : Vector.<uint>
      {
         return this._completedQuests;
      }
      
      public function getQuestInformations(param1:uint) : Object
      {
         return this._questsInformations[param1];
      }
      
      public function get rewardableAchievements() : Vector.<AchievementRewardable>
      {
         return this._rewardableAchievements;
      }
      
      public function pushed() : Boolean
      {
         this._rewardableAchievements = new Vector.<AchievementRewardable>();
         this._finishedAchievementsIds = new Vector.<uint>();
         this._nbAllAchievements = Achievement.getAchievements().length;
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:QuestListRequestMessage = null;
         var _loc3_:QuestListMessage = null;
         var _loc4_:QuestInfosRequestAction = null;
         var _loc5_:QuestStepInfoRequestMessage = null;
         var _loc6_:QuestStepInfoMessage = null;
         var _loc7_:QuestStartRequestAction = null;
         var _loc8_:QuestStartRequestMessage = null;
         var _loc9_:QuestObjectiveValidationAction = null;
         var _loc10_:QuestObjectiveValidationMessage = null;
         var _loc11_:GuidedModeReturnRequestMessage = null;
         var _loc12_:GuidedModeQuitRequestMessage = null;
         var _loc13_:QuestStartedMessage = null;
         var _loc14_:QuestValidatedMessage = null;
         var _loc15_:int = 0;
         var _loc16_:Quest = null;
         var _loc17_:QuestObjectiveValidatedMessage = null;
         var _loc18_:QuestStepValidatedMessage = null;
         var _loc19_:Object = null;
         var _loc20_:QuestStepStartedMessage = null;
         var _loc21_:NotificationUpdateFlagAction = null;
         var _loc22_:NotificationUpdateFlagMessage = null;
         var _loc23_:NotificationResetMessage = null;
         var _loc24_:AchievementListMessage = null;
         var _loc25_:int = 0;
         var _loc26_:AchievementDetailedListRequestAction = null;
         var _loc27_:AchievementDetailedListRequestMessage = null;
         var _loc28_:AchievementDetailedListMessage = null;
         var _loc29_:AchievementDetailsRequestAction = null;
         var _loc30_:AchievementDetailsRequestMessage = null;
         var _loc31_:AchievementDetailsMessage = null;
         var _loc32_:AchievementFinishedInformationMessage = null;
         var _loc33_:String = null;
         var _loc34_:AchievementFinishedMessage = null;
         var _loc35_:AchievementRewardable = null;
         var _loc36_:String = null;
         var _loc37_:AchievementRewardRequestAction = null;
         var _loc38_:AchievementRewardRequestMessage = null;
         var _loc39_:AchievementRewardSuccessMessage = null;
         var _loc40_:int = 0;
         var _loc41_:AchievementRewardErrorMessage = null;
         var _loc42_:QuestActiveDetailedInformations = null;
         var _loc43_:QuestObjectiveInformations = null;
         var _loc44_:Array = null;
         var _loc45_:int = 0;
         var _loc46_:int = 0;
         var _loc47_:Object = null;
         var _loc48_:QuestActiveInformations = null;
         var _loc49_:QuestStep = null;
         var _loc50_:int = 0;
         var _loc51_:int = 0;
         var _loc52_:int = 0;
         var _loc53_:AchievementRewardable = null;
         var _loc54_:AchievementRewardable = null;
         switch(true)
         {
            case param1 is QuestListRequestAction:
               _loc2_ = new QuestListRequestMessage();
               _loc2_.initQuestListRequestMessage();
               ConnectionsHandler.getConnection().send(_loc2_);
               return true;
            case param1 is QuestListMessage:
               _loc3_ = param1 as QuestListMessage;
               this._activeQuests = _loc3_.activeQuests;
               this._completedQuests = _loc3_.finishedQuestsIds;
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestListUpdated);
               return true;
            case param1 is QuestInfosRequestAction:
               _loc4_ = param1 as QuestInfosRequestAction;
               _loc5_ = new QuestStepInfoRequestMessage();
               _loc5_.initQuestStepInfoRequestMessage(_loc4_.questId);
               ConnectionsHandler.getConnection().send(_loc5_);
               return true;
            case param1 is QuestStepInfoMessage:
               _loc6_ = param1 as QuestStepInfoMessage;
               if(_loc6_.infos is QuestActiveDetailedInformations)
               {
                  _loc42_ = _loc6_.infos as QuestActiveDetailedInformations;
                  this._questsInformations[_loc42_.questId] = {
                     "questId":_loc42_.questId,
                     "stepId":_loc42_.stepId
                  };
                  this._questsInformations[_loc42_.questId].objectives = new Array();
                  this._questsInformations[_loc42_.questId].objectivesData = new Array();
                  this._questsInformations[_loc42_.questId].objectivesDialogParams = new Array();
                  for each(_loc43_ in _loc42_.objectives)
                  {
                     this._questsInformations[_loc42_.questId].objectives[_loc43_.objectiveId] = _loc43_.objectiveStatus;
                     if(Boolean(_loc43_.dialogParams) && _loc43_.dialogParams.length > 0)
                     {
                        _loc44_ = new Array();
                        _loc45_ = int(_loc43_.dialogParams.length);
                        _loc46_ = 0;
                        while(_loc46_ < _loc45_)
                        {
                           _loc44_.push(_loc43_.dialogParams[_loc46_]);
                           _loc46_++;
                        }
                     }
                     this._questsInformations[_loc42_.questId].objectivesDialogParams[_loc43_.objectiveId] = _loc44_;
                     if(_loc43_ is QuestObjectiveInformationsWithCompletion)
                     {
                        _loc47_ = new Object();
                        _loc47_.current = (_loc43_ as QuestObjectiveInformationsWithCompletion).curCompletion;
                        _loc47_.max = (_loc43_ as QuestObjectiveInformationsWithCompletion).maxCompletion;
                        this._questsInformations[_loc42_.questId].objectivesData[_loc43_.objectiveId] = _loc47_;
                     }
                  }
                  KernelEventsManager.getInstance().processCallback(QuestHookList.QuestInfosUpdated,_loc42_.questId,true);
               }
               else if(_loc6_.infos is QuestActiveInformations)
               {
                  KernelEventsManager.getInstance().processCallback(QuestHookList.QuestInfosUpdated,(_loc6_.infos as QuestActiveInformations).questId,false);
               }
               return true;
            case param1 is QuestStartRequestAction:
               _loc7_ = param1 as QuestStartRequestAction;
               _loc8_ = new QuestStartRequestMessage();
               _loc8_.initQuestStartRequestMessage(_loc7_.questId);
               ConnectionsHandler.getConnection().send(_loc8_);
               return true;
            case param1 is QuestObjectiveValidationAction:
               _loc9_ = param1 as QuestObjectiveValidationAction;
               _loc10_ = new QuestObjectiveValidationMessage();
               _loc10_.initQuestObjectiveValidationMessage(_loc9_.questId,_loc9_.objectiveId);
               ConnectionsHandler.getConnection().send(_loc10_);
               return true;
            case param1 is GuidedModeReturnRequestAction:
               _loc11_ = new GuidedModeReturnRequestMessage();
               _loc11_.initGuidedModeReturnRequestMessage();
               ConnectionsHandler.getConnection().send(_loc11_);
               return true;
            case param1 is GuidedModeQuitRequestAction:
               _loc12_ = new GuidedModeQuitRequestMessage();
               _loc12_.initGuidedModeQuitRequestMessage();
               ConnectionsHandler.getConnection().send(_loc12_);
               return true;
            case param1 is QuestStartedMessage:
               _loc13_ = param1 as QuestStartedMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestStarted,_loc13_.questId);
               return true;
            case param1 is QuestValidatedMessage:
               _loc14_ = param1 as QuestValidatedMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestValidated,_loc14_.questId);
               this._completedQuests.push(_loc14_.questId);
               for each(_loc48_ in this._activeQuests)
               {
                  if(_loc48_.questId == _loc14_.questId)
                  {
                     break;
                  }
                  _loc15_++;
               }
               if(_loc15_ < this._activeQuests.length)
               {
                  this._activeQuests.splice(_loc15_,1);
               }
               _loc16_ = Quest.getQuestById(_loc14_.questId);
               for each(_loc49_ in _loc16_.steps)
               {
                  for each(_loc50_ in _loc49_.objectiveIds)
                  {
                     KernelEventsManager.getInstance().processCallback(HookList.RemoveMapFlag,"flag_srv" + CompassTypeEnum.COMPASS_TYPE_QUEST + "_" + _loc14_.questId + "_" + _loc50_,PlayedCharacterManager.getInstance().currentWorldMap.id);
                  }
               }
               return true;
            case param1 is QuestObjectiveValidatedMessage:
               _loc17_ = param1 as QuestObjectiveValidatedMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestObjectiveValidated,_loc17_.questId,_loc17_.objectiveId);
               KernelEventsManager.getInstance().processCallback(HookList.RemoveMapFlag,"flag_srv" + CompassTypeEnum.COMPASS_TYPE_QUEST + "_" + _loc17_.questId + "_" + _loc17_.objectiveId,PlayedCharacterManager.getInstance().currentWorldMap.id);
               return true;
            case param1 is QuestStepValidatedMessage:
               _loc18_ = param1 as QuestStepValidatedMessage;
               if(this._questsInformations[_loc18_.questId])
               {
                  this._questsInformations[_loc18_.questId].stepId = _loc18_.stepId;
               }
               _loc19_ = QuestStep.getQuestStepById(_loc18_.stepId).objectiveIds;
               for each(_loc51_ in _loc19_)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.RemoveMapFlag,"flag_srv" + CompassTypeEnum.COMPASS_TYPE_QUEST + "_" + _loc18_.questId + "_" + _loc51_,PlayedCharacterManager.getInstance().currentWorldMap.id);
               }
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestStepValidated,_loc18_.questId,_loc18_.stepId);
               return true;
            case param1 is QuestStepStartedMessage:
               _loc20_ = param1 as QuestStepStartedMessage;
               if(this._questsInformations[_loc20_.questId])
               {
                  this._questsInformations[_loc20_.questId].stepId = _loc20_.stepId;
               }
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestStepStarted,_loc20_.questId,_loc20_.stepId);
               return true;
            case param1 is NotificationUpdateFlagAction:
               _loc21_ = param1 as NotificationUpdateFlagAction;
               _loc22_ = new NotificationUpdateFlagMessage();
               _loc22_.initNotificationUpdateFlagMessage(_loc21_.index);
               ConnectionsHandler.getConnection().send(_loc22_);
               return true;
            case param1 is NotificationResetAction:
               notificationList = new Array();
               _loc23_ = new NotificationResetMessage();
               _loc23_.initNotificationResetMessage();
               ConnectionsHandler.getConnection().send(_loc23_);
               KernelEventsManager.getInstance().processCallback(HookList.NotificationReset);
               return true;
            case param1 is AchievementListMessage:
               _loc24_ = param1 as AchievementListMessage;
               this._finishedAchievementsIds = _loc24_.finishedAchievementsIds;
               this._rewardableAchievements = _loc24_.rewardableAchievements;
               for each(_loc52_ in this._finishedAchievementsIds)
               {
                  if(Achievement.getAchievementById(_loc52_))
                  {
                     _loc25_ += Achievement.getAchievementById(_loc52_).points;
                  }
                  else
                  {
                     _log.warn("Succés " + _loc52_ + " non exporté");
                  }
               }
               for each(_loc53_ in this._rewardableAchievements)
               {
                  if(Achievement.getAchievementById(_loc53_.id))
                  {
                     _loc25_ += Achievement.getAchievementById(_loc53_.id).points;
                     this._finishedAchievementsIds.push(_loc53_.id);
                  }
                  else
                  {
                     _log.warn("Succés " + _loc53_.id + " non exporté");
                  }
               }
               KernelEventsManager.getInstance().processCallback(QuestHookList.AchievementList,this._finishedAchievementsIds);
               if(!this._rewardableAchievementsVisible && this._rewardableAchievements.length > 0)
               {
                  this._rewardableAchievementsVisible = true;
                  KernelEventsManager.getInstance().processCallback(QuestHookList.RewardableAchievementsVisible,this._rewardableAchievementsVisible);
               }
               PlayedCharacterManager.getInstance().achievementPercent = Math.floor(this._finishedAchievementsIds.length / this._nbAllAchievements * 100);
               PlayedCharacterManager.getInstance().achievementPoints = _loc25_;
               return true;
            case param1 is AchievementDetailedListRequestAction:
               _loc26_ = param1 as AchievementDetailedListRequestAction;
               _loc27_ = new AchievementDetailedListRequestMessage();
               _loc27_.initAchievementDetailedListRequestMessage(_loc26_.categoryId);
               ConnectionsHandler.getConnection().send(_loc27_);
               return true;
            case param1 is AchievementDetailedListMessage:
               _loc28_ = param1 as AchievementDetailedListMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.AchievementDetailedList,_loc28_.finishedAchievements,_loc28_.startedAchievements);
               return true;
            case param1 is AchievementDetailsRequestAction:
               _loc29_ = param1 as AchievementDetailsRequestAction;
               _loc30_ = new AchievementDetailsRequestMessage();
               _loc30_.initAchievementDetailsRequestMessage(_loc29_.achievementId);
               ConnectionsHandler.getConnection().send(_loc30_);
               return true;
            case param1 is AchievementDetailsMessage:
               _loc31_ = param1 as AchievementDetailsMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.AchievementDetails,_loc31_.achievement);
               return true;
            case param1 is AchievementFinishedInformationMessage:
               _loc32_ = param1 as AchievementFinishedInformationMessage;
               _loc33_ = ParamsDecoder.applyParams(I18n.getUiText("ui.achievement.characterUnlocksAchievement",["{player," + _loc32_.name + "," + _loc32_.playerId + "}"]),[_loc32_.name,_loc32_.id]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc33_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is AchievementFinishedMessage:
               _loc34_ = param1 as AchievementFinishedMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.AchievementFinished,_loc34_.id);
               this._finishedAchievementsIds.push(_loc34_.id);
               _loc35_ = new AchievementRewardable();
               this._rewardableAchievements.push(_loc35_.initAchievementRewardable(_loc34_.id,_loc34_.finishedlevel));
               if(!this._rewardableAchievementsVisible)
               {
                  this._rewardableAchievementsVisible = true;
                  KernelEventsManager.getInstance().processCallback(QuestHookList.RewardableAchievementsVisible,this._rewardableAchievementsVisible);
               }
               _loc36_ = ParamsDecoder.applyParams(I18n.getUiText("ui.achievement.achievementUnlockWithLink"),[_loc34_.id]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc36_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               PlayedCharacterManager.getInstance().achievementPercent = Math.floor(this._finishedAchievementsIds.length / this._nbAllAchievements * 100);
               PlayedCharacterManager.getInstance().achievementPoints = PlayedCharacterManager.getInstance().achievementPoints + Achievement.getAchievementById(_loc34_.id).points;
               return true;
            case param1 is AchievementRewardRequestAction:
               _loc37_ = param1 as AchievementRewardRequestAction;
               _loc38_ = new AchievementRewardRequestMessage();
               _loc38_.initAchievementRewardRequestMessage(_loc37_.achievementId);
               ConnectionsHandler.getConnection().send(_loc38_);
               return true;
            case param1 is AchievementRewardSuccessMessage:
               _loc39_ = param1 as AchievementRewardSuccessMessage;
               for each(_loc54_ in this._rewardableAchievements)
               {
                  if(_loc54_.id == _loc39_.achievementId)
                  {
                     _loc40_ = int(this._rewardableAchievements.indexOf(_loc54_));
                     break;
                  }
               }
               this._rewardableAchievements.splice(_loc40_,1);
               KernelEventsManager.getInstance().processCallback(QuestHookList.AchievementRewardSuccess,_loc39_.achievementId);
               if(this._rewardableAchievementsVisible && this._rewardableAchievements.length == 0)
               {
                  this._rewardableAchievementsVisible = false;
                  KernelEventsManager.getInstance().processCallback(QuestHookList.RewardableAchievementsVisible,this._rewardableAchievementsVisible);
               }
               return true;
            case param1 is AchievementRewardErrorMessage:
               _loc41_ = param1 as AchievementRewardErrorMessage;
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
   }
}

