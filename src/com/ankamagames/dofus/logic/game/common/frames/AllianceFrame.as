package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.externalnotification.ExternalNotificationManager;
   import com.ankamagames.dofus.externalnotification.enums.ExternalNotificationTypeEnum;
   import com.ankamagames.dofus.internalDatacenter.conquest.AllianceOnTheHillWrapper;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismFightersWrapper;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildFactSheetWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.SocialEntityInFightWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.managers.NotificationManager;
   import com.ankamagames.dofus.logic.game.common.actions.alliance.AllianceChangeGuildRightsAction;
   import com.ankamagames.dofus.logic.game.common.actions.alliance.AllianceFactsRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.alliance.AllianceInsiderInfoRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.alliance.AllianceInvitationAction;
   import com.ankamagames.dofus.logic.game.common.actions.alliance.AllianceKickRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.alliance.SetEnableAVARequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.prism.PrismAttackRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.prism.PrismFightJoinLeaveRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.prism.PrismFightSwapRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.prism.PrismInfoJoinLeaveRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.prism.PrismSettingsRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.prism.PrismUseRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.prism.PrismsListRegisterAction;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TaxCollectorsManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.lists.AlignmentHookList;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.PrismHookList;
   import com.ankamagames.dofus.misc.lists.SocialHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.SocialGroupCreationResultEnum;
   import com.ankamagames.dofus.network.enums.SocialGroupInvitationStateEnum;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceChangeGuildRightsMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceCreationResultMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceCreationStartedMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceFactsErrorMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceFactsMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceFactsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceGuildLeavingMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceInsiderInfoMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceInsiderInfoRequestMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceInvitationMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceInvitationStateRecrutedMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceInvitationStateRecruterMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceInvitedMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceJoinedMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceKickRequestMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceLeftMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceMembershipMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceModificationStartedMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.KohUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.AlliancePrismDialogQuestionMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismAttackRequestMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightAddedMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightAttackerAddMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightAttackerRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightDefenderAddMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightDefenderLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightJoinLeaveRequestMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightSwapRequestMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismInfoJoinLeaveRequestMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismSettingsErrorMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismSettingsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismUseRequestMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismsInfoValidMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismsListMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismsListRegisterMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismsListUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.pvp.SetEnableAVARequestMessage;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GuildInAllianceInformations;
   import com.ankamagames.dofus.network.types.game.prism.AllianceInsiderPrismInformation;
   import com.ankamagames.dofus.network.types.game.prism.AlliancePrismInformation;
   import com.ankamagames.dofus.network.types.game.prism.PrismGeolocalizedInformation;
   import com.ankamagames.dofus.network.types.game.prism.PrismSubareaEmptyInfo;
   import com.ankamagames.dofus.network.types.game.social.GuildInsiderFactSheetInformations;
   import com.ankamagames.dofus.types.enums.NotificationTypeEnum;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class AllianceFrame implements Frame
   {
      private static var _instance:AllianceFrame;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AllianceFrame));
      
      private static const SIDE_MINE:int = 0;
      
      private static const SIDE_DEFENDERS:int = 1;
      
      private static const SIDE_ATTACKERS:int = 2;
      
      private var _allianceDialogFrame:AllianceDialogFrame;
      
      private var _hasAlliance:Boolean = false;
      
      private var _alliance:AllianceWrapper;
      
      private var _allAlliances:Dictionary = new Dictionary(true);
      
      private var _alliancesOnTheHill:Vector.<AllianceOnTheHillWrapper>;
      
      private var _fightId:uint = 0;
      
      private var _prismState:int = 0;
      
      private var _infoJoinLeave:Boolean;
      
      private var _autoLeaveHelpers:Boolean;
      
      public function AllianceFrame()
      {
         super();
      }
      
      public static function getInstance() : AllianceFrame
      {
         return _instance;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get hasAlliance() : Boolean
      {
         return this._hasAlliance;
      }
      
      public function get alliance() : AllianceWrapper
      {
         return this._alliance;
      }
      
      public function getAllianceById(param1:uint) : AllianceWrapper
      {
         var _loc2_:AllianceWrapper = this._allAlliances[param1];
         if(!_loc2_)
         {
            _loc2_ = AllianceWrapper.getAllianceById(param1);
         }
         return _loc2_;
      }
      
      public function getPrismSubAreaById(param1:uint) : PrismSubAreaWrapper
      {
         return PrismSubAreaWrapper.prismList[param1];
      }
      
      public function get alliancesOnTheHill() : Vector.<AllianceOnTheHillWrapper>
      {
         return this._alliancesOnTheHill;
      }
      
      public function _pickup_fighter(param1:Array, param2:uint) : PrismFightersWrapper
      {
         var _loc5_:PrismFightersWrapper = null;
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         for each(_loc5_ in param1)
         {
            if(_loc5_.playerCharactersInformations.id == param2)
            {
               _loc4_ = true;
               break;
            }
            _loc3_++;
         }
         return param1.splice(_loc3_,1)[0];
      }
      
      public function pushed() : Boolean
      {
         PrismSubAreaWrapper.reset();
         _instance = this;
         this._infoJoinLeave = false;
         this._allianceDialogFrame = new AllianceDialogFrame();
         return true;
      }
      
      public function pulled() : Boolean
      {
         _instance = null;
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:SetEnableAVARequestAction = null;
         var _loc3_:SetEnableAVARequestMessage = null;
         var _loc4_:KohUpdateMessage = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:AllianceOnTheHillWrapper = null;
         var _loc9_:int = 0;
         var _loc10_:AllianceModificationStartedMessage = null;
         var _loc11_:AllianceCreationResultMessage = null;
         var _loc12_:String = null;
         var _loc13_:AllianceMembershipMessage = null;
         var _loc14_:AllianceInvitationAction = null;
         var _loc15_:AllianceInvitationMessage = null;
         var _loc16_:AllianceInvitedMessage = null;
         var _loc17_:AllianceInvitationStateRecruterMessage = null;
         var _loc18_:AllianceInvitationStateRecrutedMessage = null;
         var _loc19_:AllianceJoinedMessage = null;
         var _loc20_:String = null;
         var _loc21_:AllianceKickRequestAction = null;
         var _loc22_:AllianceKickRequestMessage = null;
         var _loc23_:AllianceGuildLeavingMessage = null;
         var _loc24_:AllianceFactsRequestAction = null;
         var _loc25_:AllianceFactsRequestMessage = null;
         var _loc26_:AllianceFactsMessage = null;
         var _loc27_:AllianceWrapper = null;
         var _loc28_:Vector.<GuildFactSheetWrapper> = null;
         var _loc29_:GuildFactSheetWrapper = null;
         var _loc30_:int = 0;
         var _loc31_:SocialFrame = null;
         var _loc32_:AllianceFactsErrorMessage = null;
         var _loc33_:AllianceChangeGuildRightsAction = null;
         var _loc34_:AllianceChangeGuildRightsMessage = null;
         var _loc35_:AllianceInsiderInfoRequestAction = null;
         var _loc36_:AllianceInsiderInfoRequestMessage = null;
         var _loc37_:AllianceInsiderInfoMessage = null;
         var _loc38_:Vector.<GuildFactSheetWrapper> = null;
         var _loc39_:GuildFactSheetWrapper = null;
         var _loc40_:Boolean = false;
         var _loc41_:Vector.<uint> = null;
         var _loc42_:int = 0;
         var _loc43_:SocialFrame = null;
         var _loc44_:PrismsListUpdateMessage = null;
         var _loc45_:PrismSettingsRequestAction = null;
         var _loc46_:PrismSettingsRequestMessage = null;
         var _loc47_:PrismSettingsErrorMessage = null;
         var _loc48_:String = null;
         var _loc49_:PrismFightJoinLeaveRequestAction = null;
         var _loc50_:PrismFightJoinLeaveRequestMessage = null;
         var _loc51_:PrismFightSwapRequestAction = null;
         var _loc52_:PrismFightSwapRequestMessage = null;
         var _loc53_:PrismInfoJoinLeaveRequestAction = null;
         var _loc54_:PrismInfoJoinLeaveRequestMessage = null;
         var _loc55_:PrismsListRegisterAction = null;
         var _loc56_:PrismsListRegisterMessage = null;
         var _loc57_:PrismAttackRequestAction = null;
         var _loc58_:PrismAttackRequestMessage = null;
         var _loc59_:PrismUseRequestAction = null;
         var _loc60_:PrismUseRequestMessage = null;
         var _loc61_:PrismFightDefenderAddMessage = null;
         var _loc62_:PrismFightDefenderLeaveMessage = null;
         var _loc63_:PrismFightAttackerAddMessage = null;
         var _loc64_:PrismFightAttackerRemoveMessage = null;
         var _loc65_:PrismsListUpdateMessage = null;
         var _loc66_:Array = null;
         var _loc67_:PrismSubAreaWrapper = null;
         var _loc69_:PrismGeolocalizedInformation = null;
         var _loc70_:AllianceInsiderPrismInformation = null;
         var _loc72_:PrismsListMessage = null;
         var _loc73_:Vector.<PrismSubAreaWrapper> = null;
         var _loc74_:PrismFightAddedMessage = null;
         var _loc75_:PrismFightRemovedMessage = null;
         var _loc76_:PrismsInfoValidMessage = null;
         var _loc77_:AlliancePrismDialogQuestionMessage = null;
         var _loc78_:int = 0;
         var _loc79_:GuildInAllianceInformations = null;
         var _loc80_:GuildInsiderFactSheetInformations = null;
         var _loc81_:PrismSubareaEmptyInfo = null;
         var _loc82_:SocialEntityInFightWrapper = null;
         var _loc83_:Object = null;
         var _loc84_:PrismSubareaEmptyInfo = null;
         var _loc85_:int = 0;
         var _loc86_:int = 0;
         var _loc87_:* = null;
         var _loc88_:String = null;
         var _loc89_:uint = 0;
         var _loc90_:uint = 0;
         var _loc91_:PrismSubAreaWrapper = null;
         switch(true)
         {
            case param1 is SetEnableAVARequestAction:
               _loc2_ = param1 as SetEnableAVARequestAction;
               _loc3_ = new SetEnableAVARequestMessage();
               _loc3_.initSetEnableAVARequestMessage(_loc2_.enable);
               ConnectionsHandler.getConnection().send(_loc3_);
               return true;
            case param1 is KohUpdateMessage:
               _loc4_ = param1 as KohUpdateMessage;
               this._alliancesOnTheHill = new Vector.<AllianceOnTheHillWrapper>();
               _loc5_ = int(_loc4_.alliances.length);
               _loc7_ = PlayedCharacterManager.getInstance().currentSubArea.id;
               _loc9_ = 0;
               if(this.alliance)
               {
                  _loc9_ = int(this.alliance.allianceId);
               }
               _loc78_ = 0;
               while(_loc78_ < _loc5_)
               {
                  if(_loc4_.alliances[_loc78_].allianceId == _loc9_)
                  {
                     _loc6_ = SIDE_MINE;
                  }
                  else if(_loc4_.alliances[_loc78_].allianceId == _loc7_)
                  {
                     _loc6_ = SIDE_DEFENDERS;
                  }
                  else
                  {
                     _loc6_ = SIDE_ATTACKERS;
                  }
                  _loc8_ = AllianceOnTheHillWrapper.create(_loc4_.alliances[_loc78_].allianceId,_loc4_.alliances[_loc78_].allianceTag,_loc4_.alliances[_loc78_].allianceName,_loc4_.alliances[_loc78_].allianceEmblem,_loc4_.allianceNbMembers[_loc78_],_loc4_.allianceRoundWeigth[_loc78_],_loc4_.allianceMatchScore[_loc78_],_loc6_);
                  this._alliancesOnTheHill.push(_loc8_);
                  _loc78_++;
               }
               KernelEventsManager.getInstance().processCallback(AlignmentHookList.KohUpdate,this._alliancesOnTheHill,_loc4_.allianceMapWinner,_loc4_.allianceMapWinnerScore,_loc4_.allianceMapMyAllianceScore);
               return true;
            case param1 is AllianceCreationStartedMessage:
               Kernel.getWorker().addFrame(this._allianceDialogFrame);
               KernelEventsManager.getInstance().processCallback(SocialHookList.AllianceCreationStarted,false,false);
               return true;
            case param1 is AllianceModificationStartedMessage:
               _loc10_ = param1 as AllianceModificationStartedMessage;
               Kernel.getWorker().addFrame(this._allianceDialogFrame);
               KernelEventsManager.getInstance().processCallback(SocialHookList.AllianceCreationStarted,_loc10_.canChangeName,_loc10_.canChangeEmblem);
               return true;
            case param1 is AllianceCreationResultMessage:
               _loc11_ = param1 as AllianceCreationResultMessage;
               switch(_loc11_.result)
               {
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_ALREADY_IN_GROUP:
                     _loc12_ = I18n.getUiText("ui.alliance.alreadyInAlliance");
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_CANCEL:
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_EMBLEM_ALREADY_EXISTS:
                     _loc12_ = I18n.getUiText("ui.guild.AlreadyUseEmblem");
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_LEAVE:
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_NAME_ALREADY_EXISTS:
                     _loc12_ = I18n.getUiText("ui.alliance.alreadyUseName");
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_NAME_INVALID:
                     _loc12_ = I18n.getUiText("ui.alliance.invalidName");
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_TAG_ALREADY_EXISTS:
                     _loc12_ = I18n.getUiText("ui.alliance.alreadyUseTag");
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_TAG_INVALID:
                     _loc12_ = I18n.getUiText("ui.alliance.invalidTag");
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_REQUIREMENT_UNMET:
                     _loc12_ = I18n.getUiText("ui.guild.requirementUnmet");
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_OK:
                     Kernel.getWorker().removeFrame(this._allianceDialogFrame);
                     this._hasAlliance = true;
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_UNKNOWN:
                     _loc12_ = I18n.getUiText("ui.common.unknownFail");
               }
               if(_loc12_)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc12_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.AllianceCreationResult,_loc11_.result);
               return true;
            case param1 is AllianceMembershipMessage:
               _loc13_ = param1 as AllianceMembershipMessage;
               if(this._alliance != null)
               {
                  this._alliance.update(_loc13_.allianceInfo.allianceId,_loc13_.allianceInfo.allianceTag,_loc13_.allianceInfo.allianceName,_loc13_.allianceInfo.allianceEmblem);
               }
               else
               {
                  this._alliance = AllianceWrapper.create(_loc13_.allianceInfo.allianceId,_loc13_.allianceInfo.allianceTag,_loc13_.allianceInfo.allianceName,_loc13_.allianceInfo.allianceEmblem);
               }
               this._hasAlliance = true;
               KernelEventsManager.getInstance().processCallback(SocialHookList.AllianceMembershipUpdated,true);
               return true;
            case param1 is AllianceInvitationAction:
               _loc14_ = param1 as AllianceInvitationAction;
               _loc15_ = new AllianceInvitationMessage();
               _loc15_.initAllianceInvitationMessage(_loc14_.targetId);
               ConnectionsHandler.getConnection().send(_loc15_);
               return true;
            case param1 is AllianceInvitedMessage:
               _loc16_ = param1 as AllianceInvitedMessage;
               Kernel.getWorker().addFrame(this._allianceDialogFrame);
               KernelEventsManager.getInstance().processCallback(SocialHookList.AllianceInvited,_loc16_.allianceInfo.allianceName,_loc16_.recruterId,_loc16_.recruterName);
               return true;
            case param1 is AllianceInvitationStateRecruterMessage:
               _loc17_ = param1 as AllianceInvitationStateRecruterMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.AllianceInvitationStateRecruter,_loc17_.invitationState,_loc17_.recrutedName);
               if(_loc17_.invitationState == SocialGroupInvitationStateEnum.SOCIAL_GROUP_INVITATION_CANCELED || _loc17_.invitationState == SocialGroupInvitationStateEnum.SOCIAL_GROUP_INVITATION_OK)
               {
                  Kernel.getWorker().removeFrame(this._allianceDialogFrame);
               }
               else
               {
                  Kernel.getWorker().addFrame(this._allianceDialogFrame);
               }
               return true;
            case param1 is AllianceInvitationStateRecrutedMessage:
               _loc18_ = param1 as AllianceInvitationStateRecrutedMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.AllianceInvitationStateRecruted,_loc18_.invitationState);
               if(_loc18_.invitationState == SocialGroupInvitationStateEnum.SOCIAL_GROUP_INVITATION_CANCELED || _loc18_.invitationState == SocialGroupInvitationStateEnum.SOCIAL_GROUP_INVITATION_OK)
               {
                  Kernel.getWorker().removeFrame(this._allianceDialogFrame);
               }
               return true;
            case param1 is AllianceJoinedMessage:
               _loc19_ = param1 as AllianceJoinedMessage;
               this._hasAlliance = true;
               this._alliance = AllianceWrapper.create(_loc19_.allianceInfo.allianceId,_loc19_.allianceInfo.allianceTag,_loc19_.allianceInfo.allianceName,_loc19_.allianceInfo.allianceEmblem);
               KernelEventsManager.getInstance().processCallback(SocialHookList.AllianceMembershipUpdated,true);
               _loc20_ = I18n.getUiText("ui.alliance.joinAllianceMessage",[_loc19_.allianceInfo.allianceName]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc20_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is AllianceKickRequestAction:
               _loc21_ = param1 as AllianceKickRequestAction;
               _loc22_ = new AllianceKickRequestMessage();
               _loc22_.initAllianceKickRequestMessage(_loc21_.guildId);
               ConnectionsHandler.getConnection().send(_loc22_);
               return true;
            case param1 is AllianceGuildLeavingMessage:
               _loc23_ = param1 as AllianceGuildLeavingMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.AllianceGuildLeaving,_loc23_.kicked,_loc23_.guildId);
               return true;
            case param1 is AllianceLeftMessage:
               KernelEventsManager.getInstance().processCallback(SocialHookList.AllianceLeft);
               this._hasAlliance = false;
               this._alliance = null;
               KernelEventsManager.getInstance().processCallback(SocialHookList.AllianceMembershipUpdated,false);
               return true;
            case param1 is AllianceFactsRequestAction:
               _loc24_ = param1 as AllianceFactsRequestAction;
               _loc25_ = new AllianceFactsRequestMessage();
               _loc25_.initAllianceFactsRequestMessage(_loc24_.allianceId);
               ConnectionsHandler.getConnection().send(_loc25_);
               return true;
            case param1 is AllianceFactsMessage:
               _loc26_ = param1 as AllianceFactsMessage;
               _loc27_ = this._allAlliances[_loc26_.infos.allianceId];
               _loc28_ = new Vector.<GuildFactSheetWrapper>();
               _loc30_ = 0;
               _loc31_ = SocialFrame.getInstance();
               for each(_loc79_ in _loc26_.guilds)
               {
                  _loc29_ = _loc31_.getGuildById(_loc79_.guildId);
                  if(_loc29_)
                  {
                     _loc29_.update(_loc79_.guildId,_loc79_.guildName,_loc79_.guildEmblem,_loc29_.leaderId,_loc29_.leaderName,_loc79_.guildLevel,_loc79_.nbMembers,_loc29_.creationDate,_loc29_.members,_loc29_.nbConnectedMembers,_loc29_.nbTaxCollectors,_loc29_.lastActivity,_loc79_.enabled,_loc26_.infos.allianceId,_loc26_.infos.allianceName,_loc40_);
                  }
                  else
                  {
                     _loc29_ = GuildFactSheetWrapper.create(_loc79_.guildId,_loc79_.guildName,_loc79_.guildEmblem,0,"",_loc79_.guildLevel,_loc79_.nbMembers,0,null,0,0,0,_loc79_.enabled,_loc26_.infos.allianceId,_loc26_.infos.allianceName,_loc40_);
                  }
                  _loc30_ += _loc79_.nbMembers;
                  _loc31_.updateGuildById(_loc79_.guildId,_loc29_);
                  _loc28_.push(_loc29_);
               }
               if(_loc27_)
               {
                  _loc27_.update(_loc26_.infos.allianceId,_loc26_.infos.allianceTag,_loc26_.infos.allianceName,_loc26_.infos.allianceEmblem,_loc26_.infos.creationDate,_loc28_.length,_loc30_,_loc28_,_loc26_.controlledSubareaIds);
               }
               else
               {
                  _loc27_ = AllianceWrapper.create(_loc26_.infos.allianceId,_loc26_.infos.allianceTag,_loc26_.infos.allianceName,_loc26_.infos.allianceEmblem,_loc26_.infos.creationDate,_loc28_.length,_loc30_,_loc28_,_loc26_.controlledSubareaIds);
                  this._allAlliances[_loc26_.infos.allianceId] = _loc27_;
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.OpenOneAlliance,_loc27_);
               return true;
            case param1 is AllianceFactsErrorMessage:
               _loc32_ = param1 as AllianceFactsErrorMessage;
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.alliance.doesntExistAnymore"),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is AllianceChangeGuildRightsAction:
               _loc33_ = param1 as AllianceChangeGuildRightsAction;
               _loc34_ = new AllianceChangeGuildRightsMessage();
               _loc34_.initAllianceChangeGuildRightsMessage(_loc33_.guildId,_loc33_.rights);
               ConnectionsHandler.getConnection().send(_loc34_);
               return true;
            case param1 is AllianceInsiderInfoRequestAction:
               _loc35_ = param1 as AllianceInsiderInfoRequestAction;
               _loc36_ = new AllianceInsiderInfoRequestMessage();
               _loc36_.initAllianceInsiderInfoRequestMessage();
               ConnectionsHandler.getConnection().send(_loc36_);
               return true;
            case param1 is AllianceInsiderInfoMessage:
               _loc37_ = param1 as AllianceInsiderInfoMessage;
               _loc38_ = new Vector.<GuildFactSheetWrapper>();
               _loc40_ = true;
               _loc41_ = new Vector.<uint>();
               _loc42_ = 0;
               _loc43_ = SocialFrame.getInstance();
               for each(_loc80_ in _loc37_.guilds)
               {
                  _loc39_ = _loc43_.getGuildById(_loc80_.guildId);
                  if(_loc39_)
                  {
                     _loc39_.update(_loc80_.guildId,_loc80_.guildName,_loc80_.guildEmblem,_loc80_.leaderId,_loc80_.leaderName,_loc80_.guildLevel,_loc80_.nbMembers,_loc39_.creationDate,_loc39_.members,_loc80_.nbConnectedMembers,_loc80_.nbTaxCollectors,_loc80_.lastActivity,_loc80_.enabled,_loc37_.allianceInfos.allianceId,_loc37_.allianceInfos.allianceName,_loc40_);
                  }
                  else
                  {
                     _loc39_ = GuildFactSheetWrapper.create(_loc80_.guildId,_loc80_.guildName,_loc80_.guildEmblem,_loc80_.leaderId,_loc80_.leaderName,_loc80_.guildLevel,_loc80_.nbMembers,0,null,_loc80_.nbConnectedMembers,_loc80_.nbTaxCollectors,_loc80_.lastActivity,_loc80_.enabled,_loc37_.allianceInfos.allianceId,_loc37_.allianceInfos.allianceName,_loc40_);
                  }
                  _loc42_ += _loc80_.nbMembers;
                  _loc43_.updateGuildById(_loc80_.guildId,_loc39_);
                  _loc38_.push(_loc39_);
                  _loc40_ = false;
               }
               for each(_loc81_ in _loc37_.prisms)
               {
                  if(_loc81_ is PrismGeolocalizedInformation && (_loc81_ as PrismGeolocalizedInformation).prism is AllianceInsiderPrismInformation)
                  {
                     _loc41_.push(_loc81_.subAreaId);
                  }
               }
               _loc44_ = new PrismsListUpdateMessage();
               _loc44_.initPrismsListUpdateMessage(_loc37_.prisms);
               this.process(_loc44_);
               if(this._alliance)
               {
                  this._alliance.update(_loc37_.allianceInfos.allianceId,_loc37_.allianceInfos.allianceTag,_loc37_.allianceInfos.allianceName,_loc37_.allianceInfos.allianceEmblem,_loc37_.allianceInfos.creationDate,_loc37_.guilds.length,_loc42_,_loc38_,_loc41_);
               }
               else
               {
                  this._alliance = AllianceWrapper.create(_loc37_.allianceInfos.allianceId,_loc37_.allianceInfos.allianceTag,_loc37_.allianceInfos.allianceName,_loc37_.allianceInfos.allianceEmblem,_loc37_.allianceInfos.creationDate,_loc37_.guilds.length,_loc42_,_loc38_,_loc41_);
               }
               this._allAlliances[_loc37_.allianceInfos.allianceId] = this._alliance;
               this._hasAlliance = true;
               KernelEventsManager.getInstance().processCallback(SocialHookList.AllianceUpdateInformations);
               return true;
            case param1 is PrismSettingsRequestAction:
               _loc45_ = param1 as PrismSettingsRequestAction;
               _loc46_ = new PrismSettingsRequestMessage();
               _loc46_.initPrismSettingsRequestMessage(_loc45_.subAreaId,_loc45_.startDefenseTime);
               ConnectionsHandler.getConnection().send(_loc46_);
               return true;
            case param1 is PrismSettingsErrorMessage:
               _loc47_ = param1 as PrismSettingsErrorMessage;
               _loc48_ = I18n.getUiText("ui.error.cantModifiedPrismVulnerabiltyHour");
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc48_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is PrismFightJoinLeaveRequestAction:
               _loc49_ = param1 as PrismFightJoinLeaveRequestAction;
               _loc50_ = new PrismFightJoinLeaveRequestMessage();
               this._autoLeaveHelpers = false;
               if(_loc49_.subAreaId == 0 && !_loc49_.join)
               {
                  for each(_loc82_ in TaxCollectorsManager.getInstance().prismsFighters)
                  {
                     for each(_loc83_ in _loc82_.allyCharactersInformations)
                     {
                        if(_loc83_.playerCharactersInformations.id == PlayedCharacterManager.getInstance().infos.id)
                        {
                           this._autoLeaveHelpers = true;
                           _loc50_.initPrismFightJoinLeaveRequestMessage(_loc82_.uniqueId,_loc49_.join);
                        }
                     }
                  }
               }
               else
               {
                  _loc50_.initPrismFightJoinLeaveRequestMessage(_loc49_.subAreaId,_loc49_.join);
               }
               ConnectionsHandler.getConnection().send(_loc50_);
               return true;
            case param1 is PrismFightSwapRequestAction:
               _loc51_ = param1 as PrismFightSwapRequestAction;
               _loc52_ = new PrismFightSwapRequestMessage();
               _loc52_.initPrismFightSwapRequestMessage(_loc51_.subAreaId,_loc51_.targetId);
               ConnectionsHandler.getConnection().send(_loc52_);
               return true;
            case param1 is PrismInfoJoinLeaveRequestAction:
               _loc53_ = param1 as PrismInfoJoinLeaveRequestAction;
               _loc54_ = new PrismInfoJoinLeaveRequestMessage();
               _loc54_.initPrismInfoJoinLeaveRequestMessage(_loc53_.join);
               this._infoJoinLeave = _loc53_.join;
               ConnectionsHandler.getConnection().send(_loc54_);
               return true;
            case param1 is PrismsListRegisterAction:
               _loc55_ = param1 as PrismsListRegisterAction;
               _loc56_ = new PrismsListRegisterMessage();
               _loc56_.initPrismsListRegisterMessage(_loc55_.listen);
               ConnectionsHandler.getConnection().send(_loc56_);
               return true;
            case param1 is PrismAttackRequestAction:
               _loc57_ = param1 as PrismAttackRequestAction;
               _loc58_ = new PrismAttackRequestMessage();
               _loc58_.initPrismAttackRequestMessage();
               ConnectionsHandler.getConnection().send(_loc58_);
               return true;
            case param1 is PrismUseRequestAction:
               _loc59_ = param1 as PrismUseRequestAction;
               _loc60_ = new PrismUseRequestMessage();
               _loc60_.initPrismUseRequestMessage();
               ConnectionsHandler.getConnection().send(_loc60_);
               return true;
            case param1 is PrismFightDefenderAddMessage:
               _loc61_ = param1 as PrismFightDefenderAddMessage;
               TaxCollectorsManager.getInstance().addFighter(1,_loc61_.subAreaId,_loc61_.defender,true);
               return true;
            case param1 is PrismFightDefenderLeaveMessage:
               _loc62_ = param1 as PrismFightDefenderLeaveMessage;
               if(this._autoLeaveHelpers && _loc62_.fighterToRemoveId == PlayedCharacterManager.getInstance().infos.id)
               {
                  _loc48_ = I18n.getUiText("ui.prism.AutoDisjoin");
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc48_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               TaxCollectorsManager.getInstance().removeFighter(1,_loc62_.subAreaId,_loc62_.fighterToRemoveId,true);
               return true;
            case param1 is PrismFightAttackerAddMessage:
               _loc63_ = param1 as PrismFightAttackerAddMessage;
               TaxCollectorsManager.getInstance().addFighter(1,_loc63_.subAreaId,_loc63_.attacker,false);
               return true;
            case param1 is PrismFightAttackerRemoveMessage:
               _loc64_ = param1 as PrismFightAttackerRemoveMessage;
               TaxCollectorsManager.getInstance().removeFighter(1,_loc64_.subAreaId,_loc64_.fighterToRemoveId,false);
               return true;
            case param1 is PrismsListUpdateMessage:
               _loc65_ = param1 as PrismsListUpdateMessage;
               _loc66_ = new Array();
               for each(_loc84_ in _loc65_.prisms)
               {
                  if(_loc84_ is PrismGeolocalizedInformation && (_loc84_ as PrismGeolocalizedInformation).prism is AllianceInsiderPrismInformation)
                  {
                     _loc69_ = _loc84_ as PrismGeolocalizedInformation;
                     _loc70_ = _loc69_.prism as AllianceInsiderPrismInformation;
                     _loc67_ = PrismSubAreaWrapper.prismList[_loc84_.subAreaId];
                     if(_loc70_.state == 2 && _loc67_.state != 2)
                     {
                        _loc85_ = _loc69_.worldX;
                        _loc86_ = _loc69_.worldY;
                        _loc87_ = SubArea.getSubAreaById(_loc69_.subAreaId).name + " (" + SubArea.getSubAreaById(_loc69_.subAreaId).area.name + ")";
                        _loc88_ = I18n.getUiText("ui.prism.attacked",[_loc87_,_loc85_ + "," + _loc86_]);
                        KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,"{openSocial,2,2,1," + _loc69_.subAreaId + "::" + _loc88_ + "}",ChatActivableChannelsEnum.CHANNEL_ALLIANCE,TimeManager.getInstance().getTimestamp());
                        if(AirScanner.hasAir() && ExternalNotificationManager.getInstance().canAddExternalNotification(ExternalNotificationTypeEnum.PRISM_ATTACK))
                        {
                           KernelEventsManager.getInstance().processCallback(HookList.ExternalNotification,ExternalNotificationTypeEnum.PRISM_ATTACK,[_loc87_,_loc69_.worldX + "," + _loc69_.worldY]);
                        }
                        if(OptionManager.getOptionManager("dofus")["warnOnGuildItemAgression"])
                        {
                           _loc89_ = NotificationManager.getInstance().prepareNotification(I18n.getUiText("ui.prism.attackedNotificationTitle"),I18n.getUiText("ui.prism.attackedNotification",[SubArea.getSubAreaById(_loc69_.subAreaId).name,_loc69_.worldX + "," + _loc69_.worldY]),NotificationTypeEnum.INVITATION,"PrismAttacked");
                           NotificationManager.getInstance().addButtonToNotification(_loc89_,I18n.getUiText("ui.common.join"),"OpenSocial",[2,2,[1,_loc69_.subAreaId]],false,200,0,"hook");
                           NotificationManager.getInstance().sendNotification(_loc89_);
                        }
                     }
                  }
                  _loc66_.push(_loc84_.subAreaId);
                  PrismSubAreaWrapper.getFromNetwork(_loc84_,this._alliance);
               }
               KernelEventsManager.getInstance().processCallback(PrismHookList.PrismsListUpdate,_loc66_);
               return true;
            case param1 is PrismsListMessage:
               _loc72_ = param1 as PrismsListMessage;
               _loc73_ = new Vector.<PrismSubAreaWrapper>();
               _loc90_ = 0;
               while(_loc90_ < _loc72_.prisms.length)
               {
                  _loc91_ = PrismSubAreaWrapper.getFromNetwork(_loc72_.prisms[_loc90_],this._alliance);
                  if(_loc91_.alliance)
                  {
                     _loc73_.push(_loc91_);
                  }
                  _loc90_++;
               }
               KernelEventsManager.getInstance().processCallback(PrismHookList.PrismsList,PrismSubAreaWrapper.prismList);
               return true;
            case param1 is PrismFightAddedMessage:
               _loc74_ = param1 as PrismFightAddedMessage;
               TaxCollectorsManager.getInstance().addPrism(_loc74_.fight);
               KernelEventsManager.getInstance().processCallback(PrismHookList.PrismInFightAdded,_loc74_.fight.subAreaId);
               return true;
            case param1 is PrismFightRemovedMessage:
               _loc75_ = param1 as PrismFightRemovedMessage;
               delete TaxCollectorsManager.getInstance().prismsFighters[_loc75_.subAreaId];
               KernelEventsManager.getInstance().processCallback(PrismHookList.PrismInFightRemoved,_loc75_.subAreaId);
               return true;
            case param1 is PrismsInfoValidMessage:
               _loc76_ = param1 as PrismsInfoValidMessage;
               TaxCollectorsManager.getInstance().setPrismsInFight(_loc76_.fights);
               KernelEventsManager.getInstance().processCallback(PrismHookList.PrismsInFightList);
               return true;
            case param1 is AlliancePrismDialogQuestionMessage:
               _loc77_ = param1 as AlliancePrismDialogQuestionMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.AlliancePrismDialogQuestion);
               return true;
            default:
               return false;
         }
      }
      
      public function pushRoleplay() : void
      {
      }
      
      public function pullRoleplay() : void
      {
      }
   }
}

