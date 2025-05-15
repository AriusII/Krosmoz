package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.managers.FrustumManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.messages.AdjacentMapClickMessage;
   import com.ankamagames.atouin.messages.AdjacentMapOutMessage;
   import com.ankamagames.atouin.messages.AdjacentMapOverMessage;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.atouin.utils.CellIdConverter;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.dofus.datacenter.interactives.Interactive;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.internalDatacenter.house.HouseWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildFightJoinRequestAction;
   import com.ankamagames.dofus.logic.game.common.frames.AllianceFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.actions.ShowAllNamesAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.ShowMonstersInfoAction;
   import com.ankamagames.dofus.logic.game.roleplay.managers.RoleplayManager;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementActivationMessage;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementMouseOutMessage;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementMouseOverMessage;
   import com.ankamagames.dofus.logic.game.roleplay.types.CharacterTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.FightTeam;
   import com.ankamagames.dofus.logic.game.roleplay.types.MutantTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.PrismTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.RoleplayTeamFightersTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.TaxCollectorTooltipInformation;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.SocialHookList;
   import com.ankamagames.dofus.network.enums.PlayerLifeStatusEnum;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.enums.TeamTypeEnum;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightJoinRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HouseKickIndoorMerchantRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyInvitationRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeOnHumanVendorRequestMessage;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.TaxCollectorStaticExtendedInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.AllianceInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMutantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNamedActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GuildInformations;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElementSkill;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElementWithAgeBonus;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.entities.messages.EntityClickMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseRightClickMessage;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.display.Rectangle2;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class RoleplayWorldFrame implements Frame
   {
      private static var _monstersInfoEnabled:Boolean;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RoleplayWorldFrame));
      
      private static const NO_CURSOR:int = -1;
      
      private static const FIGHT_CURSOR:int = 3;
      
      private static const NPC_CURSOR:int = 1;
      
      private static const INTERACTIVE_CURSOR_OFFSET:Point = new Point(0,0);
      
      private static const COLLECTABLE_INTERACTIVE_ACTION_ID:uint = 1;
      
      private static var _monstersInfoFrame:MonstersInfoFrame = new MonstersInfoFrame();
      
      private const _common:String = XmlConfig.getInstance().getEntry("config.ui.skin");
      
      private var _mouseTop:Texture;
      
      private var _mouseBottom:Texture;
      
      private var _mouseRight:Texture;
      
      private var _mouseLeft:Texture;
      
      private var _texturesReady:Boolean;
      
      private var _playerEntity:AnimatedCharacter;
      
      private var _playerName:String;
      
      private var _allowOnlyCharacterInteraction:Boolean;
      
      public var cellClickEnabled:Boolean;
      
      private var _infoEntitiesFrame:InfoEntitiesFrame = new InfoEntitiesFrame();
      
      private var sysApi:SystemApi = new SystemApi();
      
      private var _entityTooltipData:Dictionary = new Dictionary();
      
      public var pivotingCharacter:Boolean;
      
      public function RoleplayWorldFrame()
      {
         super();
      }
      
      public function set allowOnlyCharacterInteraction(param1:Boolean) : void
      {
         this._allowOnlyCharacterInteraction = param1;
      }
      
      public function get allowOnlyCharacterInteraction() : Boolean
      {
         return this._allowOnlyCharacterInteraction;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      private function get roleplayContextFrame() : RoleplayContextFrame
      {
         return Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
      }
      
      private function get roleplayMovementFrame() : RoleplayMovementFrame
      {
         return Kernel.getWorker().getFrame(RoleplayMovementFrame) as RoleplayMovementFrame;
      }
      
      public function pushed() : Boolean
      {
         FrustumManager.getInstance().setBorderInteraction(true);
         this._allowOnlyCharacterInteraction = false;
         this.cellClickEnabled = true;
         this.pivotingCharacter = false;
         if(_monstersInfoEnabled)
         {
            Kernel.getWorker().addFrame(_monstersInfoFrame);
         }
         if(this._texturesReady)
         {
            return true;
         }
         this._mouseBottom = new Texture();
         this._mouseBottom.uri = new Uri(this._common + "assets.swf|cursorBottom");
         this._mouseBottom.finalize();
         this._mouseTop = new Texture();
         this._mouseTop.uri = new Uri(this._common + "assets.swf|cursorTop");
         this._mouseTop.finalize();
         this._mouseRight = new Texture();
         this._mouseRight.uri = new Uri(this._common + "assets.swf|cursorRight");
         this._mouseRight.finalize();
         this._mouseLeft = new Texture();
         this._mouseLeft.uri = new Uri(this._common + "assets.swf|cursorLeft");
         this._mouseLeft.finalize();
         this._texturesReady = true;
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:AdjacentMapOverMessage = null;
         var _loc3_:Point = null;
         var _loc4_:GraphicCell = null;
         var _loc5_:LinkedCursorData = null;
         var _loc6_:EntityMouseOverMessage = null;
         var _loc7_:String = null;
         var _loc8_:IInteractive = null;
         var _loc9_:AnimatedCharacter = null;
         var _loc10_:* = undefined;
         var _loc11_:IRectangle = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:Number = NaN;
         var _loc15_:MouseRightClickMessage = null;
         var _loc16_:Object = null;
         var _loc17_:IInteractive = null;
         var _loc18_:EntityMouseOutMessage = null;
         var _loc19_:EntityClickMessage = null;
         var _loc20_:IInteractive = null;
         var _loc21_:GameContextActorInformations = null;
         var _loc22_:Boolean = false;
         var _loc23_:InteractiveElementActivationMessage = null;
         var _loc24_:RoleplayInteractivesFrame = null;
         var _loc25_:InteractiveElementMouseOverMessage = null;
         var _loc26_:Object = null;
         var _loc27_:String = null;
         var _loc28_:String = null;
         var _loc29_:InteractiveElement = null;
         var _loc30_:InteractiveElementSkill = null;
         var _loc31_:Interactive = null;
         var _loc32_:uint = 0;
         var _loc33_:RoleplayEntitiesFrame = null;
         var _loc34_:HouseWrapper = null;
         var _loc35_:Rectangle = null;
         var _loc36_:InteractiveElementMouseOutMessage = null;
         var _loc37_:CellClickMessage = null;
         var _loc38_:AdjacentMapClickMessage = null;
         var _loc39_:IEntity = null;
         var _loc40_:TiphonSprite = null;
         var _loc41_:TiphonSprite = null;
         var _loc42_:Boolean = false;
         var _loc43_:DisplayObject = null;
         var _loc44_:Rectangle = null;
         var _loc45_:Rectangle2 = null;
         var _loc46_:FightTeam = null;
         var _loc47_:AllianceInformations = null;
         var _loc48_:int = 0;
         var _loc49_:GameRolePlayTaxCollectorInformations = null;
         var _loc50_:GuildInformations = null;
         var _loc51_:GuildWrapper = null;
         var _loc52_:AllianceWrapper = null;
         var _loc53_:GameRolePlayNpcInformations = null;
         var _loc54_:Npc = null;
         var _loc55_:AllianceFrame = null;
         var _loc56_:uint = 0;
         var _loc57_:uint = 0;
         var _loc58_:RoleplayContextFrame = null;
         var _loc59_:GameContextActorInformations = null;
         var _loc60_:GameContextActorInformations = null;
         var _loc61_:Object = null;
         var _loc62_:uint = 0;
         var _loc63_:int = 0;
         var _loc64_:uint = 0;
         var _loc65_:GameFightJoinRequestMessage = null;
         var _loc66_:IEntity = null;
         var _loc67_:int = 0;
         var _loc68_:FightTeam = null;
         var _loc69_:FightTeamMemberInformations = null;
         var _loc70_:GuildWrapper = null;
         var _loc71_:IEntity = null;
         var _loc72_:Array = null;
         var _loc73_:int = 0;
         var _loc74_:MapPoint = null;
         var _loc75_:MapPoint = null;
         var _loc76_:Object = null;
         var _loc77_:String = null;
         var _loc78_:String = null;
         var _loc79_:Skill = null;
         var _loc80_:Boolean = false;
         var _loc81_:InteractiveElementWithAgeBonus = null;
         switch(true)
         {
            case param1 is CellClickMessage:
               if(this.pivotingCharacter)
               {
                  return false;
               }
               if(this.allowOnlyCharacterInteraction)
               {
                  return false;
               }
               if(this.cellClickEnabled)
               {
                  _loc37_ = param1 as CellClickMessage;
                  this.roleplayMovementFrame.resetNextMoveMapChange();
                  _log.debug("Player clicked on cell " + _loc37_.cellId + ".");
                  this.roleplayMovementFrame.setFollowingInteraction(null);
                  this.roleplayMovementFrame.askMoveTo(MapPoint.fromCellId(_loc37_.cellId));
               }
               return true;
               break;
            case param1 is AdjacentMapClickMessage:
               if(this.allowOnlyCharacterInteraction)
               {
                  return false;
               }
               if(this.cellClickEnabled)
               {
                  _loc38_ = param1 as AdjacentMapClickMessage;
                  _loc39_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                  if(!_loc39_)
                  {
                     _log.warn("The player tried to move before its character was added to the scene. Aborting.");
                     return false;
                  }
                  this.roleplayMovementFrame.setNextMoveMapChange(_loc38_.adjacentMapId);
                  if(!_loc39_.position.equals(MapPoint.fromCellId(_loc38_.cellId)))
                  {
                     this.roleplayMovementFrame.setFollowingInteraction(null);
                     this.roleplayMovementFrame.askMoveTo(MapPoint.fromCellId(_loc38_.cellId));
                  }
                  else
                  {
                     this.roleplayMovementFrame.setFollowingInteraction(null);
                     this.roleplayMovementFrame.askMapChange();
                  }
               }
               return true;
               break;
            case param1 is AdjacentMapOutMessage:
               if(this.allowOnlyCharacterInteraction)
               {
                  return false;
               }
               LinkedCursorSpriteManager.getInstance().removeItem("changeMapCursor");
               return true;
               break;
            case param1 is AdjacentMapOverMessage:
               if(this.allowOnlyCharacterInteraction)
               {
                  return false;
               }
               _loc2_ = AdjacentMapOverMessage(param1);
               _loc3_ = CellIdConverter.cellIdToCoord(_loc2_.cellId);
               _loc4_ = InteractiveCellManager.getInstance().getCell(_loc2_.cellId);
               _loc5_ = new LinkedCursorData();
               switch(_loc2_.direction)
               {
                  case DirectionsEnum.LEFT:
                     _loc5_.sprite = this._mouseLeft;
                     _loc5_.lockX = true;
                     _loc5_.sprite.x = _loc2_.zone.x + _loc2_.zone.width / 2;
                     _loc5_.offset = new Point(0,0);
                     _loc5_.lockY = true;
                     _loc5_.sprite.y = _loc4_.y + AtouinConstants.CELL_HEIGHT / 2;
                     break;
                  case DirectionsEnum.UP:
                     _loc5_.sprite = this._mouseTop;
                     _loc5_.lockY = true;
                     _loc5_.sprite.y = _loc2_.zone.y + _loc2_.zone.height / 2;
                     _loc5_.offset = new Point(0,0);
                     _loc5_.lockX = true;
                     _loc5_.sprite.x = _loc4_.x + AtouinConstants.CELL_WIDTH / 2;
                     break;
                  case DirectionsEnum.DOWN:
                     _loc5_.sprite = this._mouseBottom;
                     _loc5_.lockY = true;
                     _loc5_.sprite.y = _loc2_.zone.getBounds(_loc2_.zone).top;
                     _loc5_.offset = new Point(0,0);
                     _loc5_.lockX = true;
                     _loc5_.sprite.x = _loc4_.x + AtouinConstants.CELL_WIDTH / 2;
                     break;
                  case DirectionsEnum.RIGHT:
                     _loc5_.sprite = this._mouseRight;
                     _loc5_.lockX = true;
                     _loc5_.sprite.x = _loc2_.zone.getBounds(_loc2_.zone).left + _loc2_.zone.width / 2;
                     _loc5_.offset = new Point(0,0);
                     _loc5_.lockY = true;
                     _loc5_.sprite.y = _loc4_.y + AtouinConstants.CELL_HEIGHT / 2;
               }
               LinkedCursorSpriteManager.getInstance().addItem("changeMapCursor",_loc5_);
               return true;
               break;
            case param1 is EntityMouseOverMessage:
               _loc6_ = param1 as EntityMouseOverMessage;
               _loc7_ = "entity_" + _loc6_.entity.id;
               this.displayCursor(NO_CURSOR);
               _loc8_ = _loc6_.entity as IInteractive;
               _loc9_ = _loc8_ as AnimatedCharacter;
               if(_loc9_)
               {
                  _loc9_ = _loc9_.getRootEntity();
                  _loc9_.highLightCharacterAndFollower(true);
                  _loc8_ = _loc9_;
               }
               _loc10_ = this.roleplayContextFrame.entitiesFrame.getEntityInfos(_loc8_.id) as GameRolePlayActorInformations;
               if(_loc8_ is TiphonSprite)
               {
                  _loc40_ = _loc8_ as TiphonSprite;
                  _loc41_ = (_loc8_ as TiphonSprite).getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) as TiphonSprite;
                  _loc42_ = Boolean(Kernel.getWorker().getFrame(RoleplayEntitiesFrame)) && RoleplayEntitiesFrame(Kernel.getWorker().getFrame(RoleplayEntitiesFrame)).isCreatureMode;
                  if(Boolean(_loc41_) && !_loc42_)
                  {
                     _loc40_ = _loc41_;
                  }
                  _loc43_ = _loc40_.getSlot("Tete");
                  if(_loc43_)
                  {
                     _loc44_ = _loc43_.getBounds(StageShareManager.stage);
                     _loc11_ = _loc45_ = new Rectangle2(_loc44_.x,_loc44_.y,_loc44_.width,_loc44_.height);
                  }
               }
               if(!_loc11_ || _loc11_.width == 0 && _loc11_.height == 0)
               {
                  _loc11_ = (_loc8_ as IDisplayable).absoluteBounds;
               }
               _loc12_ = null;
               _loc14_ = 0;
               if(this.roleplayContextFrame.entitiesFrame.isFight(_loc8_.id))
               {
                  if(this.allowOnlyCharacterInteraction)
                  {
                     return false;
                  }
                  _loc46_ = this.roleplayContextFrame.entitiesFrame.getFightTeam(_loc8_.id);
                  _loc10_ = new RoleplayTeamFightersTooltipInformation(_loc46_);
                  _loc12_ = "roleplayFight";
                  this.displayCursor(FIGHT_CURSOR,!PlayedCharacterManager.getInstance().restrictions.cantAttackMonster);
               }
               else
               {
                  switch(true)
                  {
                     case _loc10_ is GameRolePlayCharacterInformations:
                        if(_loc10_.contextualId == PlayedCharacterManager.getInstance().id)
                        {
                           _loc48_ = 0;
                        }
                        else
                        {
                           _loc56_ = _loc10_.alignmentInfos.characterPower - _loc10_.contextualId;
                           _loc57_ = PlayedCharacterManager.getInstance().infos.level;
                           _loc48_ = PlayedCharacterManager.getInstance().levelDiff(_loc56_);
                        }
                        _loc10_ = new CharacterTooltipInformation(_loc10_ as GameRolePlayCharacterInformations,_loc48_);
                        _loc13_ = "CharacterCache";
                        break;
                     case _loc10_ is GameRolePlayMutantInformations:
                        if((_loc10_ as GameRolePlayMutantInformations).humanoidInfo.restrictions.cantAttack)
                        {
                           _loc10_ = new CharacterTooltipInformation(_loc10_,0);
                           break;
                        }
                        _loc10_ = new MutantTooltipInformation(_loc10_ as GameRolePlayMutantInformations);
                        break;
                     case _loc10_ is GameRolePlayTaxCollectorInformations:
                        if(this.allowOnlyCharacterInteraction)
                        {
                           return false;
                        }
                        _loc49_ = _loc10_ as GameRolePlayTaxCollectorInformations;
                        _loc50_ = _loc49_.identification.guildIdentity;
                        _loc47_ = _loc49_.identification is TaxCollectorStaticExtendedInformations ? (_loc49_.identification as TaxCollectorStaticExtendedInformations).allianceIdentity : null;
                        _loc51_ = GuildWrapper.create(_loc50_.guildId,_loc50_.guildName,_loc50_.guildEmblem,0,true);
                        _loc52_ = !!_loc47_ ? AllianceWrapper.create(_loc47_.allianceId,_loc47_.allianceTag,_loc47_.allianceName,_loc47_.allianceEmblem) : null;
                        _loc10_ = new TaxCollectorTooltipInformation(TaxCollectorName.getTaxCollectorNameById((_loc10_ as GameRolePlayTaxCollectorInformations).identification.lastNameId).name,TaxCollectorFirstname.getTaxCollectorFirstnameById((_loc10_ as GameRolePlayTaxCollectorInformations).identification.firstNameId).firstname,_loc51_,_loc52_,(_loc10_ as GameRolePlayTaxCollectorInformations).taxCollectorAttack);
                        break;
                     case _loc10_ is GameRolePlayNpcInformations:
                        if(this.allowOnlyCharacterInteraction)
                        {
                           return false;
                        }
                        _loc53_ = _loc10_ as GameRolePlayNpcInformations;
                        _loc54_ = Npc.getNpcById(_loc53_.npcId);
                        if(_loc54_.actions.length == 0)
                        {
                           break;
                        }
                        this.displayCursor(NPC_CURSOR);
                        _loc10_ = new TextTooltipInfo(_loc54_.name,XmlConfig.getInstance().getEntry("config.ui.skin") + "css/tooltip_npc.css","green",0);
                        _loc10_.bgCornerRadius = 10;
                        _loc13_ = "NPCCacheName";
                        break;
                     case _loc10_ is GameRolePlayGroupMonsterInformations:
                        if(this.allowOnlyCharacterInteraction)
                        {
                           return false;
                        }
                        this.displayCursor(FIGHT_CURSOR,!PlayedCharacterManager.getInstance().restrictions.cantAttackMonster);
                        _loc13_ = "GroupMonsterCache";
                        break;
                     case _loc10_ is GameRolePlayPrismInformations:
                        _loc55_ = Kernel.getWorker().getFrame(AllianceFrame) as AllianceFrame;
                        _loc10_ = new PrismTooltipInformation(_loc55_.getPrismSubAreaById(PlayedCharacterManager.getInstance().currentSubArea.id).alliance);
                  }
               }
               if(!_loc10_)
               {
                  _log.warn("Rolling over a unknown entity (" + _loc6_.entity.id + ").");
                  return false;
               }
               if(this.roleplayContextFrame.entitiesFrame.hasIcon(_loc8_.id))
               {
                  _loc14_ = 45;
               }
               if(_loc9_ && !_loc9_.rawAnimation && !this._entityTooltipData[_loc9_])
               {
                  this._entityTooltipData[_loc9_] = {
                     "data":_loc10_,
                     "name":_loc7_,
                     "tooltipMaker":_loc12_,
                     "tooltipOffset":_loc14_,
                     "cacheName":_loc13_
                  };
                  _loc9_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityAnimRendered);
               }
               else
               {
                  TooltipManager.show(_loc10_,_loc11_,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,_loc7_,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,_loc14_,true,_loc12_,null,null,_loc13_,false,StrataEnum.STRATA_WORLD,this.sysApi.getCurrentZoom());
               }
               return true;
               break;
            case param1 is MouseRightClickMessage:
               _loc15_ = param1 as MouseRightClickMessage;
               _loc16_ = UiModuleManager.getInstance().getModule("Ankama_ContextMenu").mainClass;
               _loc17_ = _loc15_.target as IInteractive;
               if(_loc17_)
               {
                  _loc58_ = this.roleplayContextFrame;
                  _loc59_ = _loc58_.entitiesFrame.getEntityInfos(_loc17_.id);
                  if(_loc59_ is GameRolePlayNamedActorInformations)
                  {
                     if(!(_loc17_ is AnimatedCharacter))
                     {
                        _log.error("L\'entity " + _loc17_.id + " est un GameRolePlayNamedActorInformations mais n\'est pas un AnimatedCharacter");
                        return true;
                     }
                     _loc17_ = (_loc17_ as AnimatedCharacter).getRootEntity();
                     _loc60_ = this.roleplayContextFrame.entitiesFrame.getEntityInfos(_loc17_.id);
                     _loc61_ = MenusFactory.create(_loc60_,"multiplayer",[_loc17_]);
                     if(_loc61_)
                     {
                        _loc16_.createContextMenu(_loc61_);
                     }
                     return true;
                  }
                  if(_loc59_ is GameRolePlayGroupMonsterInformations)
                  {
                     _loc61_ = MenusFactory.create(_loc59_,"monsterGroup",[_loc17_]);
                     if(_loc61_)
                     {
                        _loc16_.createContextMenu(_loc61_);
                     }
                     return true;
                  }
               }
               return false;
            case param1 is EntityMouseOutMessage:
               _loc18_ = param1 as EntityMouseOutMessage;
               this.displayCursor(NO_CURSOR);
               TooltipManager.hide("entity_" + _loc18_.entity.id);
               _loc9_ = _loc18_.entity as AnimatedCharacter;
               if(_loc9_)
               {
                  _loc9_ = _loc9_.getRootEntity();
                  _loc9_.highLightCharacterAndFollower(false);
               }
               return true;
            case param1 is EntityClickMessage:
               _loc19_ = param1 as EntityClickMessage;
               _loc20_ = _loc19_.entity as IInteractive;
               if(_loc20_ is AnimatedCharacter)
               {
                  _loc20_ = (_loc20_ as AnimatedCharacter).getRootEntity();
               }
               _loc21_ = this.roleplayContextFrame.entitiesFrame.getEntityInfos(_loc20_.id);
               _loc22_ = RoleplayManager.getInstance().displayContextualMenu(_loc21_,_loc20_);
               if(this.roleplayContextFrame.entitiesFrame.isFight(_loc20_.id))
               {
                  _loc62_ = this.roleplayContextFrame.entitiesFrame.getFightId(_loc20_.id);
                  _loc63_ = int(this.roleplayContextFrame.entitiesFrame.getFightLeaderId(_loc20_.id));
                  _loc64_ = this.roleplayContextFrame.entitiesFrame.getFightTeamType(_loc20_.id);
                  if(_loc64_ == TeamTypeEnum.TEAM_TYPE_TAXCOLLECTOR)
                  {
                     _loc68_ = this.roleplayContextFrame.entitiesFrame.getFightTeam(_loc20_.id) as FightTeam;
                     for each(_loc69_ in _loc68_.teamInfos.teamMembers)
                     {
                        if(_loc69_ is FightTeamMemberTaxCollectorInformations)
                        {
                           _loc67_ = int((_loc69_ as FightTeamMemberTaxCollectorInformations).guildId);
                        }
                     }
                     _loc70_ = (Kernel.getWorker().getFrame(SocialFrame) as SocialFrame).guild;
                     if((Boolean(_loc70_)) && _loc67_ == _loc70_.guildId)
                     {
                        KernelEventsManager.getInstance().processCallback(SocialHookList.OpenSocial,1,2);
                        Kernel.getWorker().process(GuildFightJoinRequestAction.create(PlayedCharacterManager.getInstance().currentMap.mapId));
                        return true;
                     }
                  }
                  _loc65_ = new GameFightJoinRequestMessage();
                  _loc65_.initGameFightJoinRequestMessage(_loc63_,_loc62_);
                  _loc66_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                  if((_loc66_ as IMovable).isMoving)
                  {
                     this.roleplayMovementFrame.setFollowingMessage(_loc65_);
                     (_loc66_ as IMovable).stop();
                  }
                  else
                  {
                     ConnectionsHandler.getConnection().send(_loc65_);
                  }
               }
               else if(_loc20_.id != PlayedCharacterManager.getInstance().id && !_loc22_)
               {
                  this.roleplayMovementFrame.setFollowingInteraction(null);
                  this.roleplayMovementFrame.askMoveTo(_loc20_.position);
               }
               return true;
            case param1 is InteractiveElementActivationMessage:
               if(this.allowOnlyCharacterInteraction)
               {
                  return false;
               }
               _loc23_ = param1 as InteractiveElementActivationMessage;
               _loc24_ = Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame;
               if(!((Boolean(_loc24_)) && _loc24_.usingInteractive))
               {
                  _loc71_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                  if(!DataMapProvider.getInstance().farmCell(_loc71_.position.x,_loc71_.position.y) && _loc23_.interactiveElement.elementTypeId == 120)
                  {
                     _loc73_ = 0;
                     while(_loc73_ < 8)
                     {
                        _loc75_ = _loc23_.position.getNearestCellInDirection(_loc73_);
                        if((Boolean(_loc75_)) && DataMapProvider.getInstance().farmCell(_loc75_.x,_loc75_.y))
                        {
                           if(!_loc72_)
                           {
                              _loc72_ = [];
                           }
                           _loc72_.push(_loc75_.cellId);
                        }
                        _loc73_++;
                     }
                  }
                  _loc74_ = _loc23_.position.getNearestFreeCellInDirection(_loc23_.position.advancedOrientationTo(_loc71_.position),DataMapProvider.getInstance(),true,true,_loc72_);
                  if(!_loc74_)
                  {
                     _loc74_ = _loc23_.position;
                  }
                  this.roleplayMovementFrame.setFollowingInteraction({
                     "ie":_loc23_.interactiveElement,
                     "skillInstanceId":_loc23_.skillInstanceId
                  });
                  this.roleplayMovementFrame.askMoveTo(_loc74_);
               }
               return true;
               break;
            case param1 is InteractiveElementMouseOverMessage:
               if(this.allowOnlyCharacterInteraction)
               {
                  return false;
               }
               _loc25_ = param1 as InteractiveElementMouseOverMessage;
               _loc29_ = _loc25_.interactiveElement;
               for each(_loc30_ in _loc29_.enabledSkills)
               {
                  if(_loc30_.skillId == 175)
                  {
                     _loc26_ = this.roleplayContextFrame.currentPaddock;
                     break;
                  }
               }
               _loc31_ = Interactive.getInteractiveById(_loc29_.elementTypeId);
               _loc32_ = _loc25_.interactiveElement.elementId;
               _loc33_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
               _loc34_ = _loc33_.housesInformations[_loc32_];
               _loc35_ = _loc25_.sprite.getRect(StageShareManager.stage);
               if(_loc34_)
               {
                  _loc26_ = _loc34_;
               }
               else if(_loc26_ == null && Boolean(_loc31_))
               {
                  _loc76_ = new Object();
                  _loc76_.interactive = _loc31_.name;
                  _loc77_ = "";
                  for each(_loc30_ in _loc29_.enabledSkills)
                  {
                     _loc77_ += Skill.getSkillById(_loc30_.skillId).name + "\n";
                  }
                  _loc76_.enabledSkills = _loc77_;
                  _loc78_ = "";
                  for each(_loc30_ in _loc29_.disabledSkills)
                  {
                     _loc78_ += Skill.getSkillById(_loc30_.skillId).name + "\n";
                  }
                  _loc76_.disabledSkills = _loc78_;
                  _loc76_.isCollectable = _loc31_.actionId == COLLECTABLE_INTERACTIVE_ACTION_ID;
                  if(_loc76_.isCollectable)
                  {
                     _loc80_ = true;
                     _loc81_ = _loc29_ as InteractiveElementWithAgeBonus;
                     if(_loc29_.enabledSkills.length > 0)
                     {
                        _loc79_ = Skill.getSkillById(_loc29_.enabledSkills[0].skillId);
                        if(_loc79_.parentJobId == 1)
                        {
                           _loc80_ = false;
                        }
                     }
                     else if(!_loc81_)
                     {
                        _loc80_ = false;
                     }
                     if(_loc80_)
                     {
                        _loc76_.collectSkill = _loc79_;
                        _loc76_.ageBonus = !!_loc81_ ? _loc81_.ageBonus : 0;
                     }
                  }
                  _loc26_ = _loc76_;
                  _loc27_ = "interactiveElement";
                  _loc28_ = "InteractiveElementCache";
               }
               if(_loc26_)
               {
                  TooltipManager.show(_loc26_,new Rectangle(_loc35_.right,int(_loc35_.y + _loc35_.height - AtouinConstants.CELL_HEIGHT),0,0),UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,TooltipManager.TOOLTIP_STANDAR_NAME,LocationEnum.POINT_BOTTOMLEFT,LocationEnum.POINT_TOP,0,true,_loc27_,null,null,_loc28_);
               }
               return true;
               break;
            case param1 is InteractiveElementMouseOutMessage:
               if(this.allowOnlyCharacterInteraction)
               {
                  return false;
               }
               _loc36_ = param1 as InteractiveElementMouseOutMessage;
               TooltipManager.hide();
               return true;
               break;
            case param1 is ShowAllNamesAction:
               if(Kernel.getWorker().contains(InfoEntitiesFrame))
               {
                  Kernel.getWorker().removeFrame(this._infoEntitiesFrame);
                  KernelEventsManager.getInstance().processCallback(HookList.ShowPlayersNames,false);
                  break;
               }
               Kernel.getWorker().addFrame(this._infoEntitiesFrame);
               KernelEventsManager.getInstance().processCallback(HookList.ShowPlayersNames,true);
               break;
            case param1 is ShowMonstersInfoAction:
               if(Kernel.getWorker().contains(MonstersInfoFrame))
               {
                  Kernel.getWorker().removeFrame(_monstersInfoFrame);
                  KernelEventsManager.getInstance().processCallback(HookList.ShowMonstersInfo,false);
                  _monstersInfoEnabled = false;
               }
               else
               {
                  Kernel.getWorker().addFrame(_monstersInfoFrame);
                  KernelEventsManager.getInstance().processCallback(HookList.ShowMonstersInfo,true);
                  _monstersInfoEnabled = true;
               }
               return true;
         }
         return false;
      }
      
      public function pulled() : Boolean
      {
         Mouse.show();
         LinkedCursorSpriteManager.getInstance().removeItem("changeMapCursor");
         LinkedCursorSpriteManager.getInstance().removeItem("interactiveCursor");
         FrustumManager.getInstance().setBorderInteraction(false);
         Kernel.getWorker().removeFrame(_monstersInfoFrame);
         return true;
      }
      
      private function onEntityAnimRendered(param1:TiphonEvent) : void
      {
         var _loc2_:AnimatedCharacter = param1.currentTarget as AnimatedCharacter;
         _loc2_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityAnimRendered);
         var _loc3_:Object = this._entityTooltipData[_loc2_];
         TooltipManager.show(_loc3_.data,_loc2_.absoluteBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,_loc3_.name,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,_loc3_.tooltipOffset,true,_loc3_.tooltipMaker,null,null,_loc3_.cacheName,false,StrataEnum.STRATA_WORLD,this.sysApi.getCurrentZoom());
         delete this._entityTooltipData[_loc2_];
      }
      
      private function displayCursor(param1:int, param2:Boolean = true) : void
      {
         if(param1 == -1)
         {
            Mouse.show();
            LinkedCursorSpriteManager.getInstance().removeItem("interactiveCursor");
            return;
         }
         if(PlayedCharacterManager.getInstance().state != PlayerLifeStatusEnum.STATUS_ALIVE_AND_KICKING)
         {
            return;
         }
         var _loc3_:LinkedCursorData = new LinkedCursorData();
         _loc3_.sprite = RoleplayInteractivesFrame.getCursor(param1,param2);
         _loc3_.offset = INTERACTIVE_CURSOR_OFFSET;
         Mouse.hide();
         LinkedCursorSpriteManager.getInstance().addItem("interactiveCursor",_loc3_);
      }
      
      private function onWisperMessage(param1:String) : void
      {
         KernelEventsManager.getInstance().processCallback(ChatHookList.ChatFocus,param1);
      }
      
      private function onMerchantPlayerBuyClick(param1:int, param2:uint) : void
      {
         var _loc3_:ExchangeOnHumanVendorRequestMessage = new ExchangeOnHumanVendorRequestMessage();
         _loc3_.initExchangeOnHumanVendorRequestMessage(param1,param2);
         ConnectionsHandler.getConnection().send(_loc3_);
      }
      
      private function onInviteMenuClicked(param1:String) : void
      {
         var _loc2_:PartyInvitationRequestMessage = new PartyInvitationRequestMessage();
         _loc2_.initPartyInvitationRequestMessage(param1);
         ConnectionsHandler.getConnection().send(_loc2_);
      }
      
      private function onMerchantHouseKickOff(param1:uint) : void
      {
         var _loc2_:HouseKickIndoorMerchantRequestMessage = new HouseKickIndoorMerchantRequestMessage();
         _loc2_.initHouseKickIndoorMerchantRequestMessage(param1);
         ConnectionsHandler.getConnection().send(_loc2_);
      }
   }
}

