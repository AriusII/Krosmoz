package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.atouin.messages.EntityMovementCompleteMessage;
   import com.ankamagames.atouin.messages.EntityMovementStoppedMessage;
   import com.ankamagames.atouin.messages.MapLoadedMessage;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.datacenter.sounds.SoundAnimation;
   import com.ankamagames.dofus.datacenter.sounds.SoundBones;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.factories.RolePlayEntitiesFactory;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.house.HouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.game.common.actions.StartZoomAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.PaddockMoveItemRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.PaddockRemoveItemRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.roleplay.SwitchCreatureModeAction;
   import com.ankamagames.dofus.logic.game.common.frames.AbstractEntitiesFrame;
   import com.ankamagames.dofus.logic.game.common.frames.AllianceFrame;
   import com.ankamagames.dofus.logic.game.common.frames.EmoticonFrame;
   import com.ankamagames.dofus.logic.game.common.managers.ChatAutocompleteNameManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.roleplay.managers.AnimFunManager;
   import com.ankamagames.dofus.logic.game.roleplay.messages.CharacterMovementStoppedMessage;
   import com.ankamagames.dofus.logic.game.roleplay.messages.DelayedActionMessage;
   import com.ankamagames.dofus.logic.game.roleplay.messages.GameRolePlaySetAnimationMessage;
   import com.ankamagames.dofus.logic.game.roleplay.types.EntityIcon;
   import com.ankamagames.dofus.logic.game.roleplay.types.Fight;
   import com.ankamagames.dofus.logic.game.roleplay.types.FightTeam;
   import com.ankamagames.dofus.logic.game.roleplay.types.GameContextPaddockItemInformations;
   import com.ankamagames.dofus.logic.game.roleplay.types.GroundObject;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.PrismHookList;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.misc.utils.EmbedAssets;
   import com.ankamagames.dofus.network.enums.AggressableStatusEnum;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.MapObstacleStateEnum;
   import com.ankamagames.dofus.network.enums.PlayerLifeStatusEnum;
   import com.ankamagames.dofus.network.enums.PrismStateEnum;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRefreshEntityLookMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRemoveElementMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapChangeOrientationMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapChangeOrientationsMessage;
   import com.ankamagames.dofus.network.messages.game.context.ShowCellMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightOptionStateUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightRemoveTeamMemberMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightUpdateTeamMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.GameDataPaddockObjectAddMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.GameDataPaddockObjectListAddMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.GameDataPaddockObjectRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.PaddockMoveItemRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.PaddockRemoveItemRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.GameRolePlayShowActorMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataInHouseMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsWithCoordsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapFightCountMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapInformationsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayRemoveChallengeMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayShowChallengeMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HousePropertiesMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.MapNpcsQuestStatusUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.objects.ObjectGroundAddedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.objects.ObjectGroundListAddedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.objects.ObjectGroundRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.paddock.GameDataPlayFarmObjectAnimationMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveMapUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.StatedMapUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.pvp.UpdateMapPlayersAgressableStatusMessage;
   import com.ankamagames.dofus.network.messages.game.pvp.UpdateSelfAgressableStatusMessage;
   import com.ankamagames.dofus.network.types.game.context.ActorOrientation;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightCommonInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayHumanoidInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcWithQuestInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionAlliance;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionEmote;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionFollowers;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionObjectUse;
   import com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations;
   import com.ankamagames.dofus.network.types.game.house.HouseInformations;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.interactive.MapObstacle;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.network.types.game.look.IndexedEntityLook;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockItem;
   import com.ankamagames.dofus.types.entities.AnimStatiqueSubEntityBehavior;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.entities.RoleplayObjectEntity;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.dofus.types.enums.EntityIconEnum;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.newCache.garbage.LruGarbageCollector;
   import com.ankamagames.jerakine.newCache.impl.Cache;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.Rectangle2;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.tiphon.display.TiphonAnimation;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.engine.TiphonEventsManager;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.types.IAnimationModifier;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   
   public class RoleplayEntitiesFrame extends AbstractEntitiesFrame implements Frame
   {
      private static const ICONS_FILEPATH:String = XmlConfig.getInstance().getEntry("config.content.path") + "gfx/icons/conquestIcon.swf";
      
      private var _fights:Dictionary;
      
      private var _objects:Dictionary;
      
      private var _uri:Dictionary;
      
      private var _paddockItem:Dictionary = new Dictionary();
      
      private var _fightNumber:uint = 0;
      
      private var _timeout:Number;
      
      private var _loader:IResourceLoader;
      
      private var _groundObjectCache:ICache = new Cache(20,new LruGarbageCollector());
      
      private var _currentPaddockItemCellId:uint;
      
      private var _usableEmotes:Array = new Array();
      
      private var _currentEmoticon:uint = 0;
      
      private var _bRequestingAura:Boolean = false;
      
      private var _playersId:Array;
      
      private var _npcList:Dictionary = new Dictionary(true);
      
      private var _housesList:Dictionary;
      
      private var _emoteTimesBySprite:Dictionary;
      
      private var _waitForMap:Boolean;
      
      private var _monstersIds:Vector.<int>;
      
      private var _allianceFrame:AllianceFrame;
      
      private var _entitiesIconsNames:Dictionary = new Dictionary();
      
      private var _entitiesIcons:Dictionary = new Dictionary();
      
      private var _entitiesIconsContainer:Sprite = new Sprite();
      
      private var _updateAllIcons:Boolean;
      
      private var _waitingEmotesAnims:Dictionary = new Dictionary();
      
      public function RoleplayEntitiesFrame()
      {
         super();
      }
      
      public function get currentEmoticon() : uint
      {
         return this._currentEmoticon;
      }
      
      public function set currentEmoticon(param1:uint) : void
      {
         this._currentEmoticon = param1;
      }
      
      public function get usableEmoticons() : Array
      {
         return this._usableEmotes;
      }
      
      public function get fightNumber() : uint
      {
         return this._fightNumber;
      }
      
      public function get currentSubAreaId() : uint
      {
         return _currentSubAreaId;
      }
      
      public function get playersId() : Array
      {
         return this._playersId;
      }
      
      public function get housesInformations() : Dictionary
      {
         return this._housesList;
      }
      
      public function get fights() : Dictionary
      {
         return this._fights;
      }
      
      public function get isCreatureMode() : Boolean
      {
         return _creaturesMode;
      }
      
      public function get monstersIds() : Vector.<int>
      {
         return this._monstersIds;
      }
      
      override public function pushed() : Boolean
      {
         var _loc1_:MapInformationsRequestMessage = null;
         this.initNewMap();
         this._playersId = new Array();
         this._monstersIds = new Vector.<int>();
         this._emoteTimesBySprite = new Dictionary();
         _humanNumber = 0;
         if(MapDisplayManager.getInstance().currentMapRendered)
         {
            _loc1_ = new MapInformationsRequestMessage();
            _loc1_.initMapInformationsRequestMessage(MapDisplayManager.getInstance().currentMapPoint.mapId);
            ConnectionsHandler.getConnection().send(_loc1_);
         }
         else
         {
            this._waitForMap = true;
         }
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onGroundObjectLoaded);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onGroundObjectLoadFailed);
         _interactiveElements = new Vector.<InteractiveElement>();
         Dofus.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,onPropertyChanged);
         this._usableEmotes = new Array();
         this._allianceFrame = Kernel.getWorker().getFrame(AllianceFrame) as AllianceFrame;
         this._entitiesIconsContainer.mouseChildren = false;
         this._entitiesIconsContainer.mouseEnabled = false;
         DisplayObjectContainer(Berilia.getInstance().docMain.getChildAt(StrataEnum.STRATA_WORLD + 1)).addChild(this._entitiesIconsContainer);
         EnterFrameDispatcher.addEventListener(this.showIcons,"showIcons",25);
         return super.pushed();
      }
      
      override public function process(param1:Message) : Boolean
      {
         var _loc2_:MapComplementaryInformationsDataMessage = null;
         var _loc3_:SubArea = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:InteractiveMapUpdateMessage = null;
         var _loc9_:StatedMapUpdateMessage = null;
         var _loc10_:HouseInformations = null;
         var _loc11_:GameRolePlayShowActorMessage = null;
         var _loc12_:GameContextRefreshEntityLookMessage = null;
         var _loc13_:GameMapChangeOrientationMessage = null;
         var _loc14_:GameMapChangeOrientationsMessage = null;
         var _loc15_:int = 0;
         var _loc16_:GameRolePlaySetAnimationMessage = null;
         var _loc17_:AnimatedCharacter = null;
         var _loc18_:EntityMovementCompleteMessage = null;
         var _loc19_:EntityMovementStoppedMessage = null;
         var _loc20_:CharacterMovementStoppedMessage = null;
         var _loc21_:AnimatedCharacter = null;
         var _loc22_:GameRolePlayShowChallengeMessage = null;
         var _loc23_:GameFightOptionStateUpdateMessage = null;
         var _loc24_:GameFightUpdateTeamMessage = null;
         var _loc25_:GameFightRemoveTeamMemberMessage = null;
         var _loc26_:GameRolePlayRemoveChallengeMessage = null;
         var _loc27_:GameContextRemoveElementMessage = null;
         var _loc28_:uint = 0;
         var _loc29_:int = 0;
         var _loc30_:MapFightCountMessage = null;
         var _loc31_:UpdateMapPlayersAgressableStatusMessage = null;
         var _loc32_:int = 0;
         var _loc33_:int = 0;
         var _loc34_:GameRolePlayHumanoidInformations = null;
         var _loc35_:* = undefined;
         var _loc36_:UpdateSelfAgressableStatusMessage = null;
         var _loc37_:GameRolePlayHumanoidInformations = null;
         var _loc38_:* = undefined;
         var _loc39_:ObjectGroundAddedMessage = null;
         var _loc40_:ObjectGroundRemovedMessage = null;
         var _loc41_:ObjectGroundListAddedMessage = null;
         var _loc42_:uint = 0;
         var _loc43_:PaddockRemoveItemRequestAction = null;
         var _loc44_:PaddockRemoveItemRequestMessage = null;
         var _loc45_:PaddockMoveItemRequestAction = null;
         var _loc46_:Texture = null;
         var _loc47_:ItemWrapper = null;
         var _loc48_:GameDataPaddockObjectRemoveMessage = null;
         var _loc49_:RoleplayContextFrame = null;
         var _loc50_:GameDataPaddockObjectAddMessage = null;
         var _loc51_:GameDataPaddockObjectListAddMessage = null;
         var _loc52_:GameDataPlayFarmObjectAnimationMessage = null;
         var _loc53_:MapNpcsQuestStatusUpdateMessage = null;
         var _loc54_:ShowCellMessage = null;
         var _loc55_:RoleplayContextFrame = null;
         var _loc56_:String = null;
         var _loc57_:String = null;
         var _loc58_:StartZoomAction = null;
         var _loc59_:DisplayObject = null;
         var _loc60_:SwitchCreatureModeAction = null;
         var _loc61_:MapInformationsRequestMessage = null;
         var _loc62_:MapComplementaryInformationsWithCoordsMessage = null;
         var _loc63_:MapComplementaryInformationsDataInHouseMessage = null;
         var _loc64_:* = false;
         var _loc65_:GameRolePlayActorInformations = null;
         var _loc66_:GameRolePlayActorInformations = null;
         var _loc67_:AnimatedCharacter = null;
         var _loc68_:GameRolePlayCharacterInformations = null;
         var _loc69_:* = undefined;
         var _loc70_:DelayedActionMessage = null;
         var _loc71_:Emoticon = null;
         var _loc72_:Boolean = false;
         var _loc73_:Date = null;
         var _loc74_:TiphonEntityLook = null;
         var _loc75_:GameRolePlaySetAnimationMessage = null;
         var _loc76_:FightCommonInformations = null;
         var _loc77_:HouseInformations = null;
         var _loc78_:HouseWrapper = null;
         var _loc79_:int = 0;
         var _loc80_:int = 0;
         var _loc81_:HousePropertiesMessage = null;
         var _loc82_:MapObstacle = null;
         var _loc83_:GameRolePlayCharacterInformations = null;
         var _loc84_:int = 0;
         var _loc85_:ActorOrientation = null;
         var _loc86_:TiphonSprite = null;
         var _loc87_:Emoticon = null;
         var _loc88_:EmoticonFrame = null;
         var _loc89_:uint = 0;
         var _loc90_:Emoticon = null;
         var _loc91_:EmotePlayRequestMessage = null;
         var _loc92_:uint = 0;
         var _loc93_:uint = 0;
         var _loc94_:PaddockItem = null;
         var _loc95_:uint = 0;
         var _loc96_:TiphonSprite = null;
         var _loc97_:Sprite = null;
         var _loc98_:int = 0;
         var _loc99_:int = 0;
         var _loc100_:Quest = null;
         var _loc101_:Rectangle = null;
         var _loc102_:* = undefined;
         switch(true)
         {
            case param1 is MapLoadedMessage:
               if(this._waitForMap)
               {
                  _loc61_ = new MapInformationsRequestMessage();
                  _loc61_.initMapInformationsRequestMessage(MapDisplayManager.getInstance().currentMapPoint.mapId);
                  ConnectionsHandler.getConnection().send(_loc61_);
                  this._waitForMap = false;
               }
               return false;
            case param1 is MapComplementaryInformationsDataMessage:
               _loc2_ = param1 as MapComplementaryInformationsDataMessage;
               this.initNewMap();
               _interactiveElements = _loc2_.interactiveElements;
               this._fightNumber = _loc2_.fights.length;
               if(param1 is MapComplementaryInformationsWithCoordsMessage)
               {
                  _loc62_ = param1 as MapComplementaryInformationsWithCoordsMessage;
                  if(PlayedCharacterManager.getInstance().isInHouse)
                  {
                     KernelEventsManager.getInstance().processCallback(HookList.HouseExit);
                  }
                  PlayedCharacterManager.getInstance().isInHouse = false;
                  PlayedCharacterManager.getInstance().isInHisHouse = false;
                  PlayedCharacterManager.getInstance().currentMap.setOutdoorCoords(_loc62_.worldX,_loc62_.worldY);
                  _worldPoint = new WorldPointWrapper(_loc62_.mapId,true,_loc62_.worldX,_loc62_.worldY);
               }
               else if(param1 is MapComplementaryInformationsDataInHouseMessage)
               {
                  _loc63_ = param1 as MapComplementaryInformationsDataInHouseMessage;
                  _loc64_ = PlayerManager.getInstance().nickname == _loc63_.currentHouse.ownerName;
                  PlayedCharacterManager.getInstance().isInHouse = true;
                  if(_loc64_)
                  {
                     PlayedCharacterManager.getInstance().isInHisHouse = true;
                  }
                  PlayedCharacterManager.getInstance().currentMap.setOutdoorCoords(_loc63_.currentHouse.worldX,_loc63_.currentHouse.worldY);
                  KernelEventsManager.getInstance().processCallback(HookList.HouseEntered,_loc64_,_loc63_.currentHouse.ownerId,_loc63_.currentHouse.ownerName,_loc63_.currentHouse.price,_loc63_.currentHouse.isLocked,_loc63_.currentHouse.worldX,_loc63_.currentHouse.worldY,HouseWrapper.manualCreate(_loc63_.currentHouse.modelId,-1,_loc63_.currentHouse.ownerName,_loc63_.currentHouse.price != 0));
                  _worldPoint = new WorldPointWrapper(_loc63_.mapId,true,_loc63_.currentHouse.worldX,_loc63_.currentHouse.worldY);
               }
               else
               {
                  _worldPoint = new WorldPointWrapper(_loc2_.mapId);
                  if(PlayedCharacterManager.getInstance().isInHouse)
                  {
                     KernelEventsManager.getInstance().processCallback(HookList.HouseExit);
                  }
                  PlayedCharacterManager.getInstance().isInHouse = false;
                  PlayedCharacterManager.getInstance().isInHisHouse = false;
               }
               _currentSubAreaId = _loc2_.subAreaId;
               _loc3_ = SubArea.getSubAreaById(_currentSubAreaId);
               PlayedCharacterManager.getInstance().currentMap = _worldPoint;
               PlayedCharacterManager.getInstance().currentSubArea = _loc3_;
               TooltipManager.hide();
               updateCreaturesLimit();
               _loc4_ = false;
               for each(_loc65_ in _loc2_.actors)
               {
                  ++_humanNumber;
                  if(_creaturesLimit == 0 || _creaturesLimit < 50 && _humanNumber >= _creaturesLimit)
                  {
                     _creaturesMode = true;
                  }
                  if(_loc65_.contextualId > 0 && this._playersId && this._playersId.indexOf(_loc65_.contextualId) == -1)
                  {
                     this._playersId.push(_loc65_.contextualId);
                  }
                  if(_loc65_ is GameRolePlayGroupMonsterInformations && this._monstersIds.indexOf(_loc65_.contextualId) == -1)
                  {
                     this._monstersIds.push(_loc65_.contextualId);
                  }
               }
               _loc5_ = true;
               _loc6_ = 0;
               _loc7_ = 0;
               for each(_loc66_ in _loc2_.actors)
               {
                  _loc67_ = this.addOrUpdateActor(_loc66_) as AnimatedCharacter;
                  if(_loc67_)
                  {
                     _loc68_ = _loc66_ as GameRolePlayCharacterInformations;
                     if(_loc68_)
                     {
                        _loc6_ = 0;
                        _loc7_ = 0;
                        for each(_loc69_ in _loc68_.humanoidInfo.options)
                        {
                           if(_loc69_ is HumanOptionEmote)
                           {
                              _loc6_ = int(_loc69_.emoteId);
                              _loc7_ = Number(_loc69_.emoteStartTime);
                           }
                           else if(_loc69_ is HumanOptionObjectUse)
                           {
                              _loc70_ = new DelayedActionMessage(_loc68_.contextualId,_loc69_.objectGID,_loc69_.delayEndTime);
                              Kernel.getWorker().process(_loc70_);
                           }
                        }
                        if(_loc6_ > 0)
                        {
                           _loc71_ = Emoticon.getEmoticonById(_loc6_);
                           if(_loc71_.persistancy)
                           {
                              this._currentEmoticon = _loc71_.id;
                              if(!_loc71_.aura)
                              {
                                 _loc72_ = false;
                                 _loc73_ = new Date();
                                 if(_loc73_.getTime() - _loc7_ >= _loc71_.duration)
                                 {
                                    _loc72_ = true;
                                 }
                                 _loc74_ = EntityLookAdapter.fromNetwork(_loc68_.look);
                                 _loc75_ = new GameRolePlaySetAnimationMessage(_loc66_,_loc71_.getAnimName(_loc74_),_loc7_,!_loc71_.persistancy,_loc71_.eight_directions,_loc72_);
                                 if(_loc67_.rendered)
                                 {
                                    this.process(_loc75_);
                                 }
                              }
                           }
                        }
                     }
                  }
                  if(_loc5_)
                  {
                     if(_loc66_ is GameRolePlayGroupMonsterInformations)
                     {
                        _loc5_ = false;
                        KernelEventsManager.getInstance().processCallback(TriggerHookList.MapWithMonsters);
                     }
                  }
                  if(_loc66_ is GameRolePlayCharacterInformations)
                  {
                     ChatAutocompleteNameManager.getInstance().addEntry((_loc66_ as GameRolePlayCharacterInformations).name,0);
                  }
               }
               for each(_loc76_ in _loc2_.fights)
               {
                  this.addFight(_loc76_);
               }
               this._housesList = new Dictionary();
               for each(_loc77_ in _loc2_.houses)
               {
                  _loc78_ = HouseWrapper.create(_loc77_);
                  _loc79_ = int(_loc77_.doorsOnMap.length);
                  _loc80_ = 0;
                  while(_loc80_ < _loc79_)
                  {
                     this._housesList[_loc77_.doorsOnMap[_loc80_]] = _loc78_;
                     _loc80_++;
                  }
                  _loc81_ = new HousePropertiesMessage();
                  _loc81_.initHousePropertiesMessage(_loc77_);
                  Kernel.getWorker().process(_loc81_);
               }
               for each(_loc82_ in _loc2_.obstacles)
               {
                  InteractiveCellManager.getInstance().updateCell(_loc82_.obstacleCellId,_loc82_.state == MapObstacleStateEnum.OBSTACLE_OPENED);
               }
               _loc8_ = new InteractiveMapUpdateMessage();
               _loc8_.initInteractiveMapUpdateMessage(_loc2_.interactiveElements);
               Kernel.getWorker().process(_loc8_);
               _loc9_ = new StatedMapUpdateMessage();
               _loc9_.initStatedMapUpdateMessage(_loc2_.statedElements);
               Kernel.getWorker().process(_loc9_);
               KernelEventsManager.getInstance().processCallback(HookList.MapComplementaryInformationsData,PlayedCharacterManager.getInstance().currentMap,_currentSubAreaId,Dofus.getInstance().options.mapCoordinates);
               KernelEventsManager.getInstance().processCallback(HookList.MapFightCount,0);
               AnimFunManager.getInstance().initializeByMap(_loc2_.mapId);
               this.switchPokemonMode();
               if(Kernel.getWorker().contains(MonstersInfoFrame))
               {
                  (Kernel.getWorker().getFrame(MonstersInfoFrame) as MonstersInfoFrame).update();
               }
               if(Kernel.getWorker().contains(InfoEntitiesFrame))
               {
                  (Kernel.getWorker().getFrame(InfoEntitiesFrame) as InfoEntitiesFrame).update();
               }
               return true;
            case param1 is HousePropertiesMessage:
               _loc10_ = (param1 as HousePropertiesMessage).properties;
               _loc78_ = HouseWrapper.create(_loc10_);
               _loc79_ = int(_loc10_.doorsOnMap.length);
               _loc80_ = 0;
               while(_loc80_ < _loc79_)
               {
                  this._housesList[_loc10_.doorsOnMap[_loc80_]] = _loc78_;
                  _loc80_++;
               }
               KernelEventsManager.getInstance().processCallback(HookList.HouseProperties,_loc10_.houseId,_loc10_.doorsOnMap,_loc10_.ownerName,_loc10_.isOnSale,_loc10_.modelId);
               return true;
            case param1 is GameRolePlayShowActorMessage:
               _loc11_ = param1 as GameRolePlayShowActorMessage;
               updateCreaturesLimit();
               ++_humanNumber;
               this.addOrUpdateActor(_loc11_.informations);
               if(this.switchPokemonMode())
               {
                  return true;
               }
               if(_loc11_.informations is GameRolePlayCharacterInformations)
               {
                  ChatAutocompleteNameManager.getInstance().addEntry((_loc11_.informations as GameRolePlayCharacterInformations).name,0);
               }
               if(_loc11_.informations is GameRolePlayCharacterInformations && PlayedCharacterManager.getInstance().characteristics.alignmentInfos.aggressable == AggressableStatusEnum.PvP_ENABLED_AGGRESSABLE)
               {
                  _loc83_ = _loc11_.informations as GameRolePlayCharacterInformations;
                  switch(PlayedCharacterManager.getInstance().levelDiff(_loc83_.alignmentInfos.characterPower - _loc11_.informations.contextualId))
                  {
                     case -1:
                        SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_NEW_ENEMY_WEAK);
                        break;
                     case 1:
                        SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_NEW_ENEMY_STRONG);
                  }
               }
               AnimFunManager.getInstance().restart();
               this._bRequestingAura = false;
               return true;
               break;
            case param1 is GameContextRefreshEntityLookMessage:
               _loc12_ = param1 as GameContextRefreshEntityLookMessage;
               updateActorLook(_loc12_.id,_loc12_.look,true);
               return true;
            case param1 is GameMapChangeOrientationMessage:
               _loc13_ = param1 as GameMapChangeOrientationMessage;
               updateActorOrientation(_loc13_.orientation.id,_loc13_.orientation.direction);
               return true;
            case param1 is GameMapChangeOrientationsMessage:
               _loc14_ = param1 as GameMapChangeOrientationsMessage;
               _loc15_ = int(_loc14_.orientations.length);
               _loc84_ = 0;
               while(_loc84_ < _loc15_)
               {
                  _loc85_ = _loc14_.orientations[_loc84_];
                  updateActorOrientation(_loc85_.id,_loc85_.direction);
                  _loc84_++;
               }
               return true;
            case param1 is GameRolePlaySetAnimationMessage:
               _loc16_ = param1 as GameRolePlaySetAnimationMessage;
               _loc17_ = DofusEntities.getEntity(_loc16_.informations.contextualId) as AnimatedCharacter;
               if(_loc16_.animation == AnimationEnum.ANIM_STATIQUE)
               {
                  this._currentEmoticon = 0;
                  _loc17_.setAnimation(_loc16_.animation);
                  this._emoteTimesBySprite[_loc17_.name] = 0;
               }
               else
               {
                  if(!_loc16_.directions8)
                  {
                     if(_loc17_.getDirection() % 2 == 0)
                     {
                        _loc17_.setDirection(_loc17_.getDirection() + 1);
                     }
                  }
                  if(!_loc17_.hasAnimation(_loc16_.animation,_loc17_.getDirection()))
                  {
                     _log.error("GameRolePlaySetAnimationMessage : l\'animation " + _loc16_.animation + "_" + _loc17_.getDirection() + " n\'a pas ete trouvee");
                  }
                  else if(!_creaturesMode)
                  {
                     this._emoteTimesBySprite[_loc17_.name] = _loc16_.duration;
                     _loc17_.removeEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
                     _loc17_.addEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
                     _loc86_ = _loc17_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) as TiphonSprite;
                     if(_loc86_)
                     {
                        _loc86_.removeEventListener(TiphonEvent.ANIMATION_ADDED,this.onAnimationAdded);
                        _loc86_.addEventListener(TiphonEvent.ANIMATION_ADDED,this.onAnimationAdded);
                     }
                     _loc17_.setAnimation(_loc16_.animation);
                     if(_loc16_.playStaticOnly)
                     {
                        if(Boolean(_loc17_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET)) && Boolean(_loc17_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET).length))
                        {
                           _loc17_.setSubEntityBehaviour(1,new AnimStatiqueSubEntityBehavior());
                        }
                        _loc17_.stopAnimationAtLastFrame();
                     }
                  }
               }
               return true;
            case param1 is EntityMovementCompleteMessage:
               _loc18_ = param1 as EntityMovementCompleteMessage;
               if(this._entitiesIcons[_loc18_.entity.id])
               {
                  this._entitiesIcons[_loc18_.entity.id].needUpdate = true;
               }
               return false;
            case param1 is EntityMovementStoppedMessage:
               _loc19_ = param1 as EntityMovementStoppedMessage;
               if(this._entitiesIcons[_loc19_.entity.id])
               {
                  this._entitiesIcons[_loc19_.entity.id].needUpdate = true;
               }
               return false;
            case param1 is CharacterMovementStoppedMessage:
               _loc20_ = param1 as CharacterMovementStoppedMessage;
               _loc21_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().infos.id) as AnimatedCharacter;
               if(OptionManager.getOptionManager("tiphon").alwaysShowAuraOnFront && _loc21_.getDirection() == DirectionsEnum.DOWN && _loc21_.getAnimation().indexOf(AnimationEnum.ANIM_STATIQUE) != -1 && PlayedCharacterManager.getInstance().state == PlayerLifeStatusEnum.STATUS_ALIVE_AND_KICKING)
               {
                  _loc88_ = Kernel.getWorker().getFrame(EmoticonFrame) as EmoticonFrame;
                  for each(_loc89_ in _loc88_.emotes)
                  {
                     _loc90_ = Emoticon.getEmoticonById(_loc89_);
                     if(_loc90_.aura)
                     {
                        if(!_loc87_ || _loc90_.weight > _loc87_.weight)
                        {
                           _loc87_ = _loc90_;
                        }
                     }
                  }
                  if(_loc87_)
                  {
                     _loc91_ = new EmotePlayRequestMessage();
                     _loc91_.initEmotePlayRequestMessage(_loc87_.id);
                     ConnectionsHandler.getConnection().send(_loc91_);
                  }
               }
               return true;
            case param1 is GameRolePlayShowChallengeMessage:
               _loc22_ = param1 as GameRolePlayShowChallengeMessage;
               this.addFight(_loc22_.commonsInfos);
               return true;
            case param1 is GameFightOptionStateUpdateMessage:
               _loc23_ = param1 as GameFightOptionStateUpdateMessage;
               this.updateSwordOptions(_loc23_.fightId,_loc23_.teamId,_loc23_.option,_loc23_.state);
               KernelEventsManager.getInstance().processCallback(HookList.GameFightOptionStateUpdate,_loc23_.fightId,_loc23_.teamId,_loc23_.option,_loc23_.state);
               return true;
            case param1 is GameFightUpdateTeamMessage:
               _loc24_ = param1 as GameFightUpdateTeamMessage;
               this.updateFight(_loc24_.fightId,_loc24_.team);
               return true;
            case param1 is GameFightRemoveTeamMemberMessage:
               _loc25_ = param1 as GameFightRemoveTeamMemberMessage;
               this.removeFighter(_loc25_.fightId,_loc25_.teamId,_loc25_.charId);
               return true;
            case param1 is GameRolePlayRemoveChallengeMessage:
               _loc26_ = param1 as GameRolePlayRemoveChallengeMessage;
               KernelEventsManager.getInstance().processCallback(HookList.GameRolePlayRemoveFight,_loc26_.fightId);
               this.removeFight(_loc26_.fightId);
               return true;
            case param1 is GameContextRemoveElementMessage:
               _loc27_ = param1 as GameContextRemoveElementMessage;
               _loc28_ = 0;
               for each(_loc92_ in this._playersId)
               {
                  if(_loc92_ == _loc27_.id)
                  {
                     this._playersId.splice(_loc28_,1);
                  }
                  else
                  {
                     _loc28_++;
                  }
               }
               _loc29_ = int(this._monstersIds.indexOf(_loc27_.id));
               if(_loc29_ != -1)
               {
                  this._monstersIds.splice(_loc29_,1);
               }
               if(this._entitiesIconsNames[_loc27_.id])
               {
                  delete this._entitiesIconsNames[_loc27_.id];
               }
               if(this._entitiesIcons[_loc27_.id])
               {
                  this.removeIcon(_loc27_.id);
               }
               delete this._waitingEmotesAnims[_loc27_.id];
               this.removeEntityListeners(_loc27_.id);
               removeActor(_loc27_.id);
               return true;
            case param1 is MapFightCountMessage:
               _loc30_ = param1 as MapFightCountMessage;
               KernelEventsManager.getInstance().processCallback(HookList.MapFightCount,_loc30_.fightCount);
               return true;
            case param1 is UpdateMapPlayersAgressableStatusMessage:
               _loc31_ = param1 as UpdateMapPlayersAgressableStatusMessage;
               _loc33_ = int(_loc31_.playerIds.length);
               _loc32_ = 0;
               while(_loc32_ < _loc33_)
               {
                  _loc34_ = getEntityInfos(_loc31_.playerIds[_loc32_]) as GameRolePlayHumanoidInformations;
                  if(_loc34_)
                  {
                     for each(_loc35_ in _loc34_.humanoidInfo.options)
                     {
                        if(_loc35_ is HumanOptionAlliance)
                        {
                           (_loc35_ as HumanOptionAlliance).aggressable = _loc31_.enable[_loc32_];
                           break;
                        }
                     }
                  }
                  if(_loc31_.playerIds[_loc32_] == PlayedCharacterManager.getInstance().id)
                  {
                     PlayedCharacterManager.getInstance().characteristics.alignmentInfos.aggressable = _loc31_.enable[_loc32_];
                     KernelEventsManager.getInstance().processCallback(PrismHookList.PvpAvaStateChange,_loc31_.enable[_loc32_],0);
                  }
                  _loc32_++;
               }
               this.updateConquestIcons(_loc31_.playerIds);
               return true;
            case param1 is UpdateSelfAgressableStatusMessage:
               _loc36_ = param1 as UpdateSelfAgressableStatusMessage;
               _loc37_ = getEntityInfos(PlayedCharacterManager.getInstance().id) as GameRolePlayHumanoidInformations;
               if(_loc37_)
               {
                  for each(_loc38_ in _loc37_.humanoidInfo.options)
                  {
                     if(_loc38_ is HumanOptionAlliance)
                     {
                        (_loc38_ as HumanOptionAlliance).aggressable = _loc36_.status;
                        break;
                     }
                  }
               }
               if(PlayedCharacterManager.getInstance().characteristics)
               {
                  PlayedCharacterManager.getInstance().characteristics.alignmentInfos.aggressable = _loc36_.status;
               }
               KernelEventsManager.getInstance().processCallback(PrismHookList.PvpAvaStateChange,_loc36_.status,_loc36_.probationTime);
               this.updateConquestIcons(PlayedCharacterManager.getInstance().id);
               return true;
            case param1 is ObjectGroundAddedMessage:
               _loc39_ = param1 as ObjectGroundAddedMessage;
               this.addObject(_loc39_.objectGID,_loc39_.cellId);
               return true;
            case param1 is ObjectGroundRemovedMessage:
               _loc40_ = param1 as ObjectGroundRemovedMessage;
               this.removeObject(_loc40_.cell);
               return true;
            case param1 is ObjectGroundListAddedMessage:
               _loc41_ = param1 as ObjectGroundListAddedMessage;
               _loc42_ = 0;
               for each(_loc93_ in _loc41_.referenceIds)
               {
                  this.addObject(_loc93_,_loc41_.cells[_loc42_]);
                  _loc42_++;
               }
               return true;
            case param1 is PaddockRemoveItemRequestAction:
               _loc43_ = param1 as PaddockRemoveItemRequestAction;
               _loc44_ = new PaddockRemoveItemRequestMessage();
               _loc44_.initPaddockRemoveItemRequestMessage(_loc43_.cellId);
               ConnectionsHandler.getConnection().send(_loc44_);
               return true;
            case param1 is PaddockMoveItemRequestAction:
               _loc45_ = param1 as PaddockMoveItemRequestAction;
               this._currentPaddockItemCellId = _loc45_.object.disposition.cellId;
               _loc46_ = new Texture();
               _loc47_ = ItemWrapper.create(0,0,_loc45_.object.item.id,0,null,false);
               _loc46_.uri = _loc47_.iconUri;
               _loc46_.finalize();
               Kernel.getWorker().addFrame(new RoleplayPointCellFrame(this.onCellPointed,_loc46_,true,this.paddockCellValidator,true));
               return true;
            case param1 is GameDataPaddockObjectRemoveMessage:
               _loc48_ = param1 as GameDataPaddockObjectRemoveMessage;
               _loc49_ = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
               this.removePaddockItem(_loc48_.cellId);
               return true;
            case param1 is GameDataPaddockObjectAddMessage:
               _loc50_ = param1 as GameDataPaddockObjectAddMessage;
               this.addPaddockItem(_loc50_.paddockItemDescription);
               return true;
            case param1 is GameDataPaddockObjectListAddMessage:
               _loc51_ = param1 as GameDataPaddockObjectListAddMessage;
               for each(_loc94_ in _loc51_.paddockItemDescription)
               {
                  this.addPaddockItem(_loc94_);
               }
               return true;
            case param1 is GameDataPlayFarmObjectAnimationMessage:
               _loc52_ = param1 as GameDataPlayFarmObjectAnimationMessage;
               for each(_loc95_ in _loc52_.cellId)
               {
                  this.activatePaddockItem(_loc95_);
               }
               return true;
            case param1 is MapNpcsQuestStatusUpdateMessage:
               _loc53_ = param1 as MapNpcsQuestStatusUpdateMessage;
               if(MapDisplayManager.getInstance().currentMapPoint.mapId == _loc53_.mapId)
               {
                  for each(_loc96_ in this._npcList)
                  {
                     this.removeBackground(_loc96_);
                  }
                  _loc99_ = int(_loc53_.npcsIdsWithQuest.length);
                  _loc98_ = 0;
                  while(_loc98_ < _loc99_)
                  {
                     _loc96_ = this._npcList[_loc53_.npcsIdsWithQuest[_loc98_]];
                     if(_loc96_)
                     {
                        _loc100_ = Quest.getFirstValidQuest(_loc53_.questFlags[_loc80_]);
                        if(_loc100_ != null)
                        {
                           if(_loc53_.questFlags[_loc80_].questsToStartId.indexOf(_loc100_.id) != -1)
                           {
                              if(_loc100_.repeatType == 0)
                              {
                                 _loc97_ = EmbedAssets.getSprite("QUEST_CLIP");
                                 _loc96_.addBackground("questClip",_loc97_,true);
                              }
                              else
                              {
                                 _loc97_ = EmbedAssets.getSprite("QUEST_REPEATABLE_CLIP");
                                 _loc96_.addBackground("questRepeatableClip",_loc97_,true);
                              }
                           }
                           else if(_loc100_.repeatType == 0)
                           {
                              _loc97_ = EmbedAssets.getSprite("QUEST_OBJECTIVE_CLIP");
                              _loc96_.addBackground("questObjectiveClip",_loc97_,true);
                           }
                           else
                           {
                              _loc97_ = EmbedAssets.getSprite("QUEST_REPEATABLE_OBJECTIVE_CLIP");
                              _loc96_.addBackground("questRepeatableObjectiveClip",_loc97_,true);
                           }
                        }
                     }
                     _loc98_++;
                  }
               }
               return true;
            case param1 is ShowCellMessage:
               _loc54_ = param1 as ShowCellMessage;
               HyperlinkShowCellManager.showCell(_loc54_.cellId);
               _loc55_ = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
               _loc56_ = _loc55_.getActorName(_loc54_.sourceId);
               _loc57_ = I18n.getUiText("ui.fight.showCell",[_loc56_,"{cell," + _loc54_.cellId + "::" + _loc54_.cellId + "}"]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc57_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is StartZoomAction:
               _loc58_ = param1 as StartZoomAction;
               if(Atouin.getInstance().currentZoom != 1)
               {
                  Atouin.getInstance().cancelZoom();
                  KernelEventsManager.getInstance().processCallback(HookList.StartZoom,false);
                  return true;
               }
               _loc59_ = DofusEntities.getEntity(_loc58_.playerId) as DisplayObject;
               if((Boolean(_loc59_)) && Boolean(_loc59_.stage))
               {
                  _loc101_ = _loc59_.getRect(Atouin.getInstance().worldContainer);
                  Atouin.getInstance().zoom(_loc58_.value,_loc101_.x + _loc101_.width / 2,_loc101_.y + _loc101_.height / 2);
                  KernelEventsManager.getInstance().processCallback(HookList.StartZoom,true);
               }
               return true;
               break;
            case param1 is SwitchCreatureModeAction:
               _loc60_ = param1 as SwitchCreatureModeAction;
               if(_creaturesMode != _loc60_.isActivated)
               {
                  _creaturesMode = _loc60_.isActivated;
                  for(_loc102_ in _entities)
                  {
                     updateActorLook(_loc102_,(_entities[_loc102_] as GameContextActorInformations).look);
                  }
               }
               return true;
            default:
               return false;
         }
      }
      
      private function initNewMap() : void
      {
         this._npcList = new Dictionary();
         this._fights = new Dictionary();
         this._objects = new Dictionary();
         this._uri = new Dictionary();
         this._paddockItem = new Dictionary();
      }
      
      override protected function switchPokemonMode() : Boolean
      {
         if(super.switchPokemonMode())
         {
            KernelEventsManager.getInstance().processCallback(TriggerHookList.CreaturesMode);
            return true;
         }
         return false;
      }
      
      override public function pulled() : Boolean
      {
         var _loc1_:Fight = null;
         var _loc2_:FightTeam = null;
         for each(_loc1_ in this._fights)
         {
            for each(_loc2_ in _loc1_.teams)
            {
               TooltipManager.hide("fightOptions_" + _loc1_.fightId + "_" + _loc2_.teamInfos.teamId);
            }
         }
         if(this._loader)
         {
            this._loader.removeEventListener(ResourceLoadedEvent.LOADED,this.onGroundObjectLoaded);
            this._loader.removeEventListener(ResourceErrorEvent.ERROR,this.onGroundObjectLoadFailed);
            this._loader = null;
         }
         AnimFunManager.getInstance().stopAllTimer();
         this._fights = null;
         this._objects = null;
         this._npcList = null;
         Dofus.getInstance().options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGED,onPropertyChanged);
         EnterFrameDispatcher.removeEventListener(this.showIcons);
         DisplayObjectContainer(Berilia.getInstance().docMain.getChildAt(StrataEnum.STRATA_WORLD + 1)).removeChild(this._entitiesIconsContainer);
         this.removeAllIcons();
         return super.pulled();
      }
      
      public function isFight(param1:int) : Boolean
      {
         return _entities[param1] is FightTeam;
      }
      
      public function isPaddockItem(param1:int) : Boolean
      {
         return _entities[param1] is GameContextPaddockItemInformations;
      }
      
      public function getFightTeam(param1:int) : FightTeam
      {
         return _entities[param1] as FightTeam;
      }
      
      public function getFightId(param1:int) : uint
      {
         return (_entities[param1] as FightTeam).fight.fightId;
      }
      
      public function getFightLeaderId(param1:int) : uint
      {
         return (_entities[param1] as FightTeam).teamInfos.leaderId;
      }
      
      public function getFightTeamType(param1:int) : uint
      {
         return (_entities[param1] as FightTeam).teamType;
      }
      
      override public function addOrUpdateActor(param1:GameContextActorInformations, param2:IAnimationModifier = null) : AnimatedCharacter
      {
         var _loc4_:Sprite = null;
         var _loc5_:Quest = null;
         var _loc6_:GameRolePlayGroupMonsterInformations = null;
         var _loc7_:Boolean = false;
         var _loc8_:Vector.<EntityLook> = null;
         var _loc9_:uint = 0;
         var _loc10_:Vector.<EntityLook> = null;
         var _loc11_:MonsterInGroupInformations = null;
         var _loc12_:* = undefined;
         var _loc13_:Array = null;
         var _loc14_:IndexedEntityLook = null;
         var _loc15_:IndexedEntityLook = null;
         var _loc3_:AnimatedCharacter = super.addOrUpdateActor(param1);
         switch(true)
         {
            case param1 is GameRolePlayNpcWithQuestInformations:
               this._npcList[param1.contextualId] = _loc3_;
               _loc5_ = Quest.getFirstValidQuest((param1 as GameRolePlayNpcWithQuestInformations).questFlag);
               this.removeBackground(_loc3_);
               if(_loc5_ != null)
               {
                  if((param1 as GameRolePlayNpcWithQuestInformations).questFlag.questsToStartId.indexOf(_loc5_.id) != -1)
                  {
                     if(_loc5_.repeatType == 0)
                     {
                        _loc4_ = EmbedAssets.getSprite("QUEST_CLIP");
                        _loc3_.addBackground("questClip",_loc4_,true);
                     }
                     else
                     {
                        _loc4_ = EmbedAssets.getSprite("QUEST_REPEATABLE_CLIP");
                        _loc3_.addBackground("questRepeatableClip",_loc4_,true);
                     }
                  }
                  else if(_loc5_.repeatType == 0)
                  {
                     _loc4_ = EmbedAssets.getSprite("QUEST_OBJECTIVE_CLIP");
                     _loc3_.addBackground("questObjectiveClip",_loc4_,true);
                  }
                  else
                  {
                     _loc4_ = EmbedAssets.getSprite("QUEST_REPEATABLE_OBJECTIVE_CLIP");
                     _loc3_.addBackground("questRepeatableObjectiveClip",_loc4_,true);
                  }
               }
               if(_loc3_.look.getBone() == 1)
               {
                  _loc3_.addAnimationModifier(_customAnimModifier);
               }
               if(_creaturesMode || _loc3_.getAnimation() == AnimationEnum.ANIM_STATIQUE)
               {
                  _loc3_.setAnimation(AnimationEnum.ANIM_STATIQUE);
               }
               break;
            case param1 is GameRolePlayGroupMonsterInformations:
               _loc6_ = param1 as GameRolePlayGroupMonsterInformations;
               _loc7_ = Monster.getMonsterById(_loc6_.staticInfos.mainCreatureLightInfos.creatureGenericId).isMiniBoss;
               _loc8_ = !!Dofus.getInstance().options.showEveryMonsters ? new Vector.<EntityLook>(_loc6_.staticInfos.underlings.length,true) : null;
               _loc9_ = 0;
               for each(_loc11_ in _loc6_.staticInfos.underlings)
               {
                  if(_loc8_)
                  {
                     var _loc18_:*;
                     _loc8_[_loc18_ = _loc9_++] = _loc11_.look;
                  }
                  if(!_loc7_ && Monster.getMonsterById(_loc11_.creatureGenericId).isMiniBoss)
                  {
                     _loc7_ = true;
                     if(!_loc8_)
                     {
                        break;
                     }
                  }
               }
               if(_loc8_)
               {
                  this.manageFollowers(_loc3_,_loc8_);
               }
               if(this._monstersIds.indexOf(param1.contextualId) == -1)
               {
                  this._monstersIds.push(param1.contextualId);
               }
               if(Kernel.getWorker().contains(MonstersInfoFrame))
               {
                  (Kernel.getWorker().getFrame(MonstersInfoFrame) as MonstersInfoFrame).update();
               }
               if(PlayerManager.getInstance().serverGameType != 0 && _loc6_.hasHardcoreDrop)
               {
                  this.addEntityIcon(_loc6_.contextualId,"treasure");
               }
               if(_loc7_)
               {
                  this.addEntityIcon(_loc6_.contextualId,"archmonsters");
               }
               break;
            case param1 is GameRolePlayHumanoidInformations:
               this._playersId.push(param1.contextualId);
               _loc10_ = new Vector.<EntityLook>();
               for each(_loc12_ in (param1 as GameRolePlayHumanoidInformations).humanoidInfo.options)
               {
                  switch(true)
                  {
                     case _loc12_ is HumanOptionFollowers:
                        _loc13_ = new Array();
                        for each(_loc14_ in _loc12_.followingCharactersLook)
                        {
                           _loc13_.push(_loc14_);
                        }
                        _loc13_.sortOn("index");
                        for each(_loc15_ in _loc13_)
                        {
                           _loc10_.push(_loc15_.look);
                        }
                        break;
                     case _loc12_ is HumanOptionAlliance:
                        this.addConquestIcon(param1.contextualId,_loc12_ as HumanOptionAlliance);
                        break;
                  }
               }
               this.manageFollowers(_loc3_,_loc10_);
               if(_loc3_.look.getBone() == 1)
               {
                  _loc3_.addAnimationModifier(_customAnimModifier);
               }
               if(_creaturesMode || _loc3_.getAnimation() == AnimationEnum.ANIM_STATIQUE)
               {
                  _loc3_.setAnimation(AnimationEnum.ANIM_STATIQUE);
               }
               break;
            case param1 is GameRolePlayMerchantInformations:
               if(_loc3_.look.getBone() == 1)
               {
                  _loc3_.addAnimationModifier(_customAnimModifier);
               }
               if(_creaturesMode || _loc3_.getAnimation() == AnimationEnum.ANIM_STATIQUE)
               {
                  _loc3_.setAnimation(AnimationEnum.ANIM_STATIQUE);
               }
               break;
            case param1 is GameRolePlayTaxCollectorInformations:
            case param1 is GameRolePlayPrismInformations:
               _loc3_.allowMovementThrough = true;
               break;
            default:
               _log.warn("Unknown GameRolePlayActorInformations type : " + param1 + ".");
         }
         return _loc3_;
      }
      
      private function removeBackground(param1:TiphonSprite) : void
      {
         if(!param1)
         {
            return;
         }
         param1.removeBackground("questClip");
         param1.removeBackground("questObjectiveClip");
         param1.removeBackground("questRepeatableClip");
         param1.removeBackground("questRepeatableObjectiveClip");
      }
      
      private function manageFollowers(param1:AnimatedCharacter, param2:Vector.<EntityLook>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:EntityLook = null;
         var _loc6_:TiphonEntityLook = null;
         var _loc7_:AnimatedCharacter = null;
         if(!param1.followersEqual(param2))
         {
            param1.removeAllFollowers();
            _loc3_ = int(param2.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = param2[_loc4_];
               _loc6_ = EntityLookAdapter.fromNetwork(_loc5_);
               _loc7_ = new AnimatedCharacter(EntitiesManager.getInstance().getFreeEntityId(),_loc6_,param1);
               param1.addFollower(_loc7_);
               _loc4_++;
            }
         }
      }
      
      private function addFight(param1:FightCommonInformations) : void
      {
         var _loc5_:FightTeamInformations = null;
         var _loc6_:IEntity = null;
         var _loc7_:FightTeam = null;
         var _loc2_:Vector.<FightTeam> = new Vector.<FightTeam>(0,false);
         var _loc3_:Fight = new Fight(param1.fightId,_loc2_);
         var _loc4_:uint = 0;
         for each(_loc5_ in param1.fightTeams)
         {
            _loc6_ = RolePlayEntitiesFactory.createFightEntity(param1,_loc5_,MapPoint.fromCellId(param1.fightTeamsPositions[_loc4_]));
            (_loc6_ as IDisplayable).display();
            _loc7_ = new FightTeam(_loc3_,_loc5_.teamTypeId,_loc6_,_loc5_,param1.fightTeamsOptions[_loc5_.teamId]);
            _entities[_loc6_.id] = _loc7_;
            _loc2_.push(_loc7_);
            _loc4_++;
         }
         this._fights[param1.fightId] = _loc3_;
         for each(_loc5_ in param1.fightTeams)
         {
            this.updateSwordOptions(param1.fightId,_loc5_.teamId);
         }
      }
      
      private function addObject(param1:uint, param2:uint) : void
      {
         var _loc3_:Uri = new Uri(LangManager.getInstance().getEntry("config.gfx.path.item.vector") + Item.getItemById(param1).iconId + ".swf");
         var _loc4_:IInteractive = new RoleplayObjectEntity(param1,MapPoint.fromCellId(param2));
         (_loc4_ as IDisplayable).display();
         var _loc5_:GameContextActorInformations = new GroundObject(Item.getItemById(param1));
         _loc5_.contextualId = _loc4_.id;
         _loc5_.disposition.cellId = param2;
         _loc5_.disposition.direction = DirectionsEnum.DOWN_RIGHT;
         if(this._objects == null)
         {
            this._objects = new Dictionary();
         }
         this._objects[_loc3_] = _loc4_;
         this._uri[param2] = this._objects[_loc3_];
         _entities[_loc4_.id] = _loc5_;
         this._loader.load(_loc3_,null,null,true);
      }
      
      private function removeObject(param1:uint) : void
      {
         if(this._uri[param1] != null)
         {
            if(this._objects[this._uri[param1]] != null)
            {
               delete this._objects[this._uri[param1]];
            }
            if(_entities[this._uri[param1].id] != null)
            {
               delete _entities[this._uri[param1].id];
            }
            (this._uri[param1] as IDisplayable).remove();
            delete this._uri[param1];
         }
      }
      
      private function updateFight(param1:uint, param2:FightTeamInformations) : void
      {
         var _loc6_:FightTeamMemberInformations = null;
         var _loc7_:Boolean = false;
         var _loc8_:FightTeamMemberInformations = null;
         var _loc3_:Fight = this._fights[param1];
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:FightTeam = _loc3_.getTeamById(param2.teamId);
         var _loc5_:FightTeamInformations = (_entities[_loc4_.teamEntity.id] as FightTeam).teamInfos;
         if(_loc5_.teamMembers == param2.teamMembers)
         {
            return;
         }
         for each(_loc6_ in param2.teamMembers)
         {
            _loc7_ = false;
            for each(_loc8_ in _loc5_.teamMembers)
            {
               if(_loc8_.id == _loc6_.id)
               {
                  _loc7_ = true;
               }
            }
            if(!_loc7_)
            {
               _loc5_.teamMembers.push(_loc6_);
            }
         }
      }
      
      private function removeFighter(param1:uint, param2:uint, param3:int) : void
      {
         var _loc5_:FightTeam = null;
         var _loc6_:FightTeamInformations = null;
         var _loc7_:Vector.<FightTeamMemberInformations> = null;
         var _loc8_:FightTeamMemberInformations = null;
         var _loc4_:Fight = this._fights[param1];
         if(_loc4_)
         {
            _loc5_ = _loc4_.teams[param2];
            _loc6_ = _loc5_.teamInfos;
            _loc7_ = new Vector.<FightTeamMemberInformations>(0,false);
            for each(_loc8_ in _loc6_.teamMembers)
            {
               if(_loc8_.id != param3)
               {
                  _loc7_.push(_loc8_);
               }
            }
            _loc6_.teamMembers = _loc7_;
         }
      }
      
      private function removeFight(param1:uint) : void
      {
         var _loc3_:FightTeam = null;
         var _loc4_:Object = null;
         var _loc2_:Fight = this._fights[param1];
         if(_loc2_ == null)
         {
            return;
         }
         for each(_loc3_ in _loc2_.teams)
         {
            _loc4_ = _entities[_loc3_.teamEntity.id];
            Kernel.getWorker().process(new EntityMouseOutMessage(_loc3_.teamEntity as IInteractive));
            (_loc3_.teamEntity as IDisplayable).remove();
            TooltipManager.hide("fightOptions_" + param1 + "_" + _loc3_.teamInfos.teamId);
            delete _entities[_loc3_.teamEntity.id];
         }
         delete this._fights[param1];
      }
      
      private function addPaddockItem(param1:PaddockItem) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Item = Item.getItemById(param1.objectGID);
         if(this._paddockItem[param1.cellId])
         {
            _loc3_ = (this._paddockItem[param1.cellId] as IEntity).id;
         }
         else
         {
            _loc3_ = EntitiesManager.getInstance().getFreeEntityId();
         }
         var _loc4_:GameContextPaddockItemInformations = new GameContextPaddockItemInformations(_loc3_,_loc2_.appearance,param1.cellId,param1.durability,_loc2_);
         var _loc5_:IEntity = this.addOrUpdateActor(_loc4_);
         this._paddockItem[param1.cellId] = _loc5_;
      }
      
      private function removePaddockItem(param1:uint) : void
      {
         var _loc2_:IEntity = this._paddockItem[param1];
         if(!_loc2_)
         {
            return;
         }
         (_loc2_ as IDisplayable).remove();
         delete this._paddockItem[param1];
      }
      
      private function activatePaddockItem(param1:uint) : void
      {
         var _loc3_:SerialSequencer = null;
         var _loc2_:TiphonSprite = this._paddockItem[param1];
         if(_loc2_)
         {
            _loc3_ = new SerialSequencer();
            _loc3_.addStep(new PlayAnimationStep(_loc2_,AnimationEnum.ANIM_HIT));
            _loc3_.addStep(new PlayAnimationStep(_loc2_,AnimationEnum.ANIM_STATIQUE));
            _loc3_.start();
         }
      }
      
      private function updateSwordOptions(param1:uint, param2:uint, param3:int = -1, param4:Boolean = false) : void
      {
         var _loc8_:* = undefined;
         var _loc5_:Fight = this._fights[param1];
         if(_loc5_ == null)
         {
            return;
         }
         var _loc6_:FightTeam = _loc5_.teams[param2];
         if(_loc6_ == null)
         {
            return;
         }
         if(param3 != -1)
         {
            _loc6_.teamOptions[param3] = param4;
         }
         var _loc7_:Vector.<String> = new Vector.<String>();
         for(_loc8_ in _loc6_.teamOptions)
         {
            if(_loc6_.teamOptions[_loc8_])
            {
               _loc7_.push("fightOption" + _loc8_);
            }
         }
         TooltipManager.show(_loc7_,(_loc6_.teamEntity as IDisplayable).absoluteBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"fightOptions_" + param1 + "_" + param2,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,null,null,null,false,0);
      }
      
      private function paddockCellValidator(param1:int) : Boolean
      {
         var _loc3_:GameContextActorInformations = null;
         var _loc2_:IEntity = EntitiesManager.getInstance().getEntityOnCell(param1);
         if(_loc2_)
         {
            _loc3_ = getEntityInfos(_loc2_.id);
            if(_loc3_ is GameContextPaddockItemInformations)
            {
               return false;
            }
         }
         return DataMapProvider.getInstance().farmCell(MapPoint.fromCellId(param1).x,MapPoint.fromCellId(param1).y) && DataMapProvider.getInstance().pointMov(MapPoint.fromCellId(param1).x,MapPoint.fromCellId(param1).y,true);
      }
      
      private function removeEntityListeners(param1:int) : void
      {
         var _loc3_:TiphonSprite = null;
         var _loc2_:TiphonSprite = DofusEntities.getEntity(param1) as TiphonSprite;
         if(_loc2_)
         {
            _loc2_.removeEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
            _loc3_ = _loc2_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) as TiphonSprite;
            if(_loc3_)
            {
               _loc3_.removeEventListener(TiphonEvent.ANIMATION_ADDED,this.onAnimationAdded);
            }
            _loc2_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityReadyForEmote);
         }
      }
      
      private function onEntityReadyForEmote(param1:TiphonEvent) : void
      {
         var _loc2_:AnimatedCharacter = param1.currentTarget as AnimatedCharacter;
         _loc2_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityReadyForEmote);
         if(this._playersId.indexOf(_loc2_.id) != -1)
         {
            this.process(this._waitingEmotesAnims[_loc2_.id]);
         }
         delete this._waitingEmotesAnims[_loc2_.id];
      }
      
      private function onAnimationAdded(param1:TiphonEvent) : void
      {
         var _loc5_:String = null;
         var _loc6_:Vector.<SoundAnimation> = null;
         var _loc7_:SoundAnimation = null;
         var _loc8_:String = null;
         var _loc2_:TiphonSprite = param1.currentTarget as TiphonSprite;
         _loc2_.removeEventListener(TiphonEvent.ANIMATION_ADDED,this.onAnimationAdded);
         var _loc3_:TiphonAnimation = _loc2_.rawAnimation;
         var _loc4_:SoundBones = SoundBones.getSoundBonesById(_loc2_.look.getBone());
         if(_loc4_)
         {
            _loc5_ = getQualifiedClassName(_loc3_);
            _loc6_ = _loc4_.getSoundAnimations(_loc5_);
            _loc3_.spriteHandler.tiphonEventManager.removeEvents(TiphonEventsManager.BALISE_SOUND,_loc5_);
            for each(_loc7_ in _loc6_)
            {
               _loc8_ = TiphonEventsManager.BALISE_DATASOUND + TiphonEventsManager.BALISE_PARAM_BEGIN + (_loc7_.label != null && _loc7_.label != "null" ? _loc7_.label : "") + TiphonEventsManager.BALISE_PARAM_END;
               _loc3_.spriteHandler.tiphonEventManager.addEvent(_loc8_,_loc7_.startFrame,_loc5_);
            }
         }
      }
      
      private function onGroundObjectLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:MovieClip = param1.resource;
         _loc2_.x -= _loc2_.width / 2;
         _loc2_.y -= _loc2_.height / 2;
         this._objects[param1.uri].addChild(_loc2_);
      }
      
      private function onGroundObjectLoadFailed(param1:ResourceErrorEvent) : void
      {
      }
      
      public function timeoutStop(param1:AnimatedCharacter) : void
      {
         clearTimeout(this._timeout);
         param1.setAnimation(AnimationEnum.ANIM_STATIQUE);
         this._currentEmoticon = 0;
      }
      
      override public function onPlayAnim(param1:TiphonEvent) : void
      {
         var _loc2_:Array = new Array();
         var _loc3_:String = param1.params.substring(6,param1.params.length - 1);
         _loc2_ = _loc3_.split(",");
         var _loc4_:int = this._emoteTimesBySprite[(param1.currentTarget as TiphonSprite).name] % _loc2_.length;
         param1.sprite.setAnimation(_loc2_[_loc4_]);
      }
      
      private function onAnimationEnd(param1:TiphonEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:TiphonSprite = param1.currentTarget as TiphonSprite;
         _loc2_.removeEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
         var _loc5_:Object = _loc2_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0);
         if(_loc5_ != null)
         {
            _loc4_ = _loc5_.getAnimation();
            if(_loc4_.indexOf("_") == -1)
            {
               _loc4_ = _loc2_.getAnimation();
            }
         }
         else
         {
            _loc4_ = _loc2_.getAnimation();
         }
         if(_loc4_.indexOf("_Statique_") == -1)
         {
            _loc3_ = _loc4_.replace("_","_Statique_");
         }
         else
         {
            _loc3_ = _loc4_;
         }
         if(_loc2_.hasAnimation(_loc3_,_loc2_.getDirection()) || _loc5_ && _loc5_ is TiphonSprite && TiphonSprite(_loc5_).hasAnimation(_loc3_,TiphonSprite(_loc5_).getDirection()))
         {
            _loc2_.setAnimation(_loc3_);
         }
         else
         {
            _loc2_.setAnimation(AnimationEnum.ANIM_STATIQUE);
            this._currentEmoticon = 0;
         }
      }
      
      private function onCellPointed(param1:Boolean, param2:uint, param3:int) : void
      {
         var _loc4_:PaddockMoveItemRequestMessage = null;
         if(param1)
         {
            _loc4_ = new PaddockMoveItemRequestMessage();
            _loc4_.initPaddockMoveItemRequestMessage(this._currentPaddockItemCellId,param2);
            ConnectionsHandler.getConnection().send(_loc4_);
         }
      }
      
      private function updateConquestIcons(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GameRolePlayHumanoidInformations = null;
         var _loc4_:* = undefined;
         if(param1 is Vector.<uint> && (param1 as Vector.<uint>).length > 0)
         {
            for each(_loc2_ in param1)
            {
               _loc3_ = getEntityInfos(_loc2_) as GameRolePlayHumanoidInformations;
               if(_loc3_)
               {
                  for each(_loc4_ in _loc3_.humanoidInfo.options)
                  {
                     if(_loc4_ is HumanOptionAlliance)
                     {
                        this.addConquestIcon(_loc3_.contextualId,_loc4_ as HumanOptionAlliance);
                        break;
                     }
                  }
               }
            }
         }
         else if(param1 is int)
         {
            _loc3_ = getEntityInfos(param1) as GameRolePlayHumanoidInformations;
            if(_loc3_)
            {
               for each(_loc4_ in _loc3_.humanoidInfo.options)
               {
                  if(_loc4_ is HumanOptionAlliance)
                  {
                     this.addConquestIcon(_loc3_.contextualId,_loc4_ as HumanOptionAlliance);
                     break;
                  }
               }
            }
         }
      }
      
      private function addConquestIcon(param1:int, param2:HumanOptionAlliance) : void
      {
         var _loc3_:PrismSubAreaWrapper = null;
         var _loc4_:String = null;
         var _loc5_:Vector.<String> = null;
         var _loc6_:String = null;
         if(PlayedCharacterManager.getInstance().characteristics.alignmentInfos.aggressable != AggressableStatusEnum.NON_AGGRESSABLE && this._allianceFrame && this._allianceFrame.hasAlliance && param2.aggressable != AggressableStatusEnum.NON_AGGRESSABLE && param2.aggressable != AggressableStatusEnum.PvP_ENABLED_AGGRESSABLE && param2.aggressable != AggressableStatusEnum.PvP_ENABLED_NON_AGGRESSABLE)
         {
            _loc3_ = this._allianceFrame.getPrismSubAreaById(PlayedCharacterManager.getInstance().currentSubArea.id);
            if(Boolean(_loc3_) && _loc3_.state == PrismStateEnum.PRISM_STATE_VULNERABLE)
            {
               switch(param2.aggressable)
               {
                  case AggressableStatusEnum.AvA_DISQUALIFIED:
                     if(param1 == PlayedCharacterManager.getInstance().id)
                     {
                        _loc4_ = "neutral";
                     }
                     break;
                  case AggressableStatusEnum.AvA_PREQUALIFIED_AGGRESSABLE:
                     if(param1 == PlayedCharacterManager.getInstance().id)
                     {
                        _loc4_ = "clock";
                        break;
                     }
                     _loc4_ = this.getPlayerConquestStatus(param1,param2.allianceInformations.allianceId,_loc3_.alliance.allianceId);
                     break;
                  case AggressableStatusEnum.AvA_ENABLED_AGGRESSABLE:
                     _loc4_ = this.getPlayerConquestStatus(param1,param2.allianceInformations.allianceId,_loc3_.alliance.allianceId);
               }
               if(_loc4_)
               {
                  _loc5_ = this.getIconNamesByCategory(param1,EntityIconEnum.AVA_CATEGORY);
                  if((Boolean(_loc5_)) && _loc5_[0] != _loc4_)
                  {
                     _loc6_ = _loc5_[0];
                     _loc5_.length = 0;
                     this.removeIcon(param1,_loc6_);
                  }
                  this.addEntityIcon(param1,_loc4_,EntityIconEnum.AVA_CATEGORY);
               }
            }
         }
         if(!_loc4_ && this._entitiesIconsNames[param1] && Boolean(this._entitiesIconsNames[param1][EntityIconEnum.AVA_CATEGORY]))
         {
            this.removeIconsCategory(param1,EntityIconEnum.AVA_CATEGORY);
         }
      }
      
      private function getPlayerConquestStatus(param1:int, param2:int, param3:int) : String
      {
         var _loc4_:String = null;
         if(param1 == PlayedCharacterManager.getInstance().id || this._allianceFrame.alliance.allianceId == param2)
         {
            _loc4_ = "ownTeam";
         }
         else if(param2 == param3)
         {
            _loc4_ = "defender";
         }
         else
         {
            _loc4_ = "forward";
         }
         return _loc4_;
      }
      
      public function addEntityIcon(param1:int, param2:String, param3:int = 0) : void
      {
         if(!this._entitiesIconsNames[param1])
         {
            this._entitiesIconsNames[param1] = new Dictionary();
         }
         if(!this._entitiesIconsNames[param1][param3])
         {
            this._entitiesIconsNames[param1][param3] = new Vector.<String>(0);
         }
         if(this._entitiesIconsNames[param1][param3].indexOf(param2) == -1)
         {
            this._entitiesIconsNames[param1][param3].push(param2);
         }
         if(this._entitiesIcons[param1])
         {
            this._entitiesIcons[param1].needUpdate = true;
         }
      }
      
      public function updateAllIcons() : void
      {
         this._updateAllIcons = true;
      }
      
      public function forceIconUpdate(param1:int) : void
      {
         this._entitiesIcons[param1].needUpdate = true;
      }
      
      private function removeAllIcons() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this._entitiesIconsNames)
         {
            delete this._entitiesIconsNames[_loc1_];
            this.removeIcon(_loc1_);
         }
      }
      
      public function removeIcon(param1:int, param2:String = null) : void
      {
         var _loc3_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         if(_loc3_)
         {
            _loc3_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.updateIconAfterRender);
         }
         if(this._entitiesIcons[param1])
         {
            if(!param2)
            {
               this._entitiesIcons[param1].remove();
               delete this._entitiesIcons[param1];
            }
            else
            {
               this._entitiesIcons[param1].removeIcon(param2);
            }
         }
      }
      
      public function getIconNamesByCategory(param1:int, param2:int) : Vector.<String>
      {
         var _loc3_:Vector.<String> = null;
         if(Boolean(this._entitiesIconsNames[param1]) && Boolean(this._entitiesIconsNames[param1][param2]))
         {
            _loc3_ = this._entitiesIconsNames[param1][param2];
         }
         return _loc3_;
      }
      
      public function removeIconsCategory(param1:int, param2:int) : void
      {
         var _loc3_:String = null;
         if(Boolean(this._entitiesIconsNames[param1]) && Boolean(this._entitiesIconsNames[param1][param2]))
         {
            if(this._entitiesIcons[param1])
            {
               for each(_loc3_ in this._entitiesIconsNames[param1][param2])
               {
                  this._entitiesIcons[param1].removeIcon(_loc3_);
               }
            }
            delete this._entitiesIconsNames[param1][param2];
            if(Boolean(this._entitiesIcons[param1]) && this._entitiesIcons[param1].length == 0)
            {
               delete this._entitiesIconsNames[param1];
               this.removeIcon(param1);
            }
         }
      }
      
      public function hasIcon(param1:int, param2:String = null) : Boolean
      {
         return !!this._entitiesIcons[param1] ? (!!param2 ? Boolean(this._entitiesIcons[param1].hasIcon(param2)) : true) : false;
      }
      
      private function showIcons(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:DisplayObject = null;
         var _loc4_:AnimatedCharacter = null;
         var _loc5_:IRectangle = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Rectangle2 = null;
         var _loc8_:EntityIcon = null;
         var _loc10_:TiphonSprite = null;
         var _loc11_:DisplayObject = null;
         var _loc12_:* = undefined;
         var _loc13_:String = null;
         var _loc14_:Boolean = false;
         for(_loc2_ in this._entitiesIconsNames)
         {
            _loc4_ = DofusEntities.getEntity(_loc2_) as AnimatedCharacter;
            if(!_loc4_)
            {
               delete this._entitiesIconsNames[_loc2_];
               if(this._entitiesIcons[_loc2_])
               {
                  this.removeIcon(_loc2_);
               }
            }
            else
            {
               _loc5_ = null;
               if(this._updateAllIcons || _loc4_.isMoving || !this._entitiesIcons[_loc2_] || Boolean(this._entitiesIcons[_loc2_].needUpdate))
               {
                  if(Boolean(this._entitiesIcons[_loc2_]) && Boolean(this._entitiesIcons[_loc2_].rendering))
                  {
                     continue;
                  }
                  _loc10_ = _loc4_ as TiphonSprite;
                  if(Boolean(_loc4_.getSubEntitySlot(2,0)) && !this.isCreatureMode)
                  {
                     _loc10_ = _loc4_.getSubEntitySlot(2,0) as TiphonSprite;
                  }
                  _loc3_ = _loc10_.getSlot("Tete");
                  if(_loc3_)
                  {
                     _loc6_ = _loc3_.getBounds(StageShareManager.stage);
                     _loc5_ = _loc7_ = new Rectangle2(_loc6_.x,_loc6_.y,_loc6_.width,_loc6_.height);
                     if(_loc5_.y - 30 - 10 < 0)
                     {
                        _loc11_ = _loc10_.getSlot("Pied");
                        if(_loc11_)
                        {
                           _loc6_ = _loc11_.getBounds(StageShareManager.stage);
                           _loc5_ = _loc7_ = new Rectangle2(_loc6_.x,_loc6_.y + _loc5_.height + 30,_loc6_.width,_loc6_.height);
                        }
                     }
                  }
                  else
                  {
                     if(_loc10_ is IDisplayable)
                     {
                        _loc5_ = (_loc10_ as IDisplayable).absoluteBounds;
                     }
                     else
                     {
                        _loc6_ = _loc10_.getBounds(StageShareManager.stage);
                        _loc5_ = _loc7_ = new Rectangle2(_loc6_.x,_loc6_.y,_loc6_.width,_loc6_.height);
                     }
                     if(_loc5_.y - 30 - 10 < 0)
                     {
                        _loc5_.y += _loc5_.height + 30;
                     }
                  }
               }
               if(_loc5_)
               {
                  _loc8_ = this._entitiesIcons[_loc2_];
                  if(!_loc8_)
                  {
                     this._entitiesIcons[_loc2_] = new EntityIcon();
                     _loc8_ = this._entitiesIcons[_loc2_];
                     this._entitiesIconsContainer.addChild(_loc8_);
                  }
                  _loc14_ = false;
                  for(_loc12_ in this._entitiesIconsNames[_loc2_])
                  {
                     for each(_loc13_ in this._entitiesIconsNames[_loc2_][_loc12_])
                     {
                        if(!_loc8_.hasIcon(_loc13_))
                        {
                           _loc14_ = true;
                           _loc8_.addIcon(ICONS_FILEPATH + "|" + _loc13_,_loc13_);
                        }
                     }
                  }
                  if(!_loc14_)
                  {
                     if(this._entitiesIcons[_loc2_].needUpdate && !_loc4_.isMoving && _loc4_.getAnimation().indexOf(AnimationEnum.ANIM_STATIQUE) == 0)
                     {
                        this._entitiesIcons[_loc2_].needUpdate = false;
                     }
                     if(_loc8_.scaleX != Atouin.getInstance().rootContainer.scaleX)
                     {
                        _loc8_.scaleX = Atouin.getInstance().rootContainer.scaleX;
                     }
                     if(_loc8_.scaleY != Atouin.getInstance().rootContainer.scaleY)
                     {
                        _loc8_.scaleY = Atouin.getInstance().rootContainer.scaleY;
                     }
                     if(_loc4_.rendered)
                     {
                        _loc8_.x = _loc5_.x + _loc5_.width / 2 - _loc8_.width / 2;
                        _loc8_.y = _loc5_.y - 10;
                     }
                     else
                     {
                        _loc8_.rendering = true;
                        _loc4_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.updateIconAfterRender);
                        _loc4_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.updateIconAfterRender);
                     }
                  }
               }
            }
         }
         this._updateAllIcons = false;
      }
      
      private function updateIconAfterRender(param1:TiphonEvent) : void
      {
         var _loc2_:AnimatedCharacter = param1.currentTarget as AnimatedCharacter;
         _loc2_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.updateIconAfterRender);
         if(this._entitiesIcons[_loc2_.id])
         {
            this._entitiesIcons[_loc2_.id].rendering = false;
            this._entitiesIcons[_loc2_.id].needUpdate = true;
         }
      }
   }
}

