package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.internalDatacenter.guild.PaddockWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.actions.ChangeWorldInteractionAction;
   import com.ankamagames.dofus.logic.game.common.frames.AllianceFrame;
   import com.ankamagames.dofus.logic.game.common.frames.BidHouseManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.CommonExchangeManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.CraftFrame;
   import com.ankamagames.dofus.logic.game.common.frames.EmoticonFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ExchangeManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.HumanVendorManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SpectatorManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SpellForgetDialogFrame;
   import com.ankamagames.dofus.logic.game.roleplay.types.RoleplaySpellCastProvider;
   import com.ankamagames.dofus.network.messages.game.context.GameMapChangeOrientationRequestMessage;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNamedActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.utils.display.AngleToOrientation;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getQualifiedClassName;
   
   public class RoleplayContextFrame implements Frame
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RoleplayContextFrame));
      
      private static const ASTRUB_SUBAREA_IDS:Array = [143,92,95,96,97,98,99,100,101,173,318,306];
      
      private static var currentStatus:int = -1;
      
      private var _priority:int = 0;
      
      private var _entitiesFrame:RoleplayEntitiesFrame;
      
      private var _worldFrame:RoleplayWorldFrame;
      
      private var _interactivesFrame:RoleplayInteractivesFrame;
      
      private var _npcDialogFrame:NpcDialogFrame;
      
      private var _documentFrame:DocumentFrame;
      
      private var _zaapFrame:ZaapFrame;
      
      private var _paddockFrame:PaddockFrame;
      
      private var _emoticonFrame:EmoticonFrame;
      
      private var _exchangeManagementFrame:ExchangeManagementFrame;
      
      private var _humanVendorManagementFrame:HumanVendorManagementFrame;
      
      private var _spectatorManagementFrame:SpectatorManagementFrame;
      
      private var _bidHouseManagementFrame:BidHouseManagementFrame;
      
      private var _estateFrame:EstateFrame;
      
      private var _allianceFrame:AllianceFrame;
      
      private var _craftFrame:CraftFrame;
      
      private var _commonExchangeFrame:CommonExchangeManagementFrame;
      
      private var _movementFrame:RoleplayMovementFrame;
      
      private var _spellForgetDialogFrame:SpellForgetDialogFrame;
      
      private var _delayedActionFrame:DelayedActionFrame;
      
      private var _currentWaitingFightId:uint;
      
      private var _crafterId:uint;
      
      private var _customerID:uint;
      
      private var _playersMultiCraftSkill:Array;
      
      private var _currentPaddock:PaddockWrapper;
      
      private var _playerEntity:AnimatedCharacter;
      
      private var _interactionIsLimited:Boolean = false;
      
      public function RoleplayContextFrame()
      {
         super();
      }
      
      public function get crafterId() : uint
      {
         return this._crafterId;
      }
      
      public function get customerID() : uint
      {
         return this._customerID;
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function set priority(param1:int) : void
      {
         this._priority = param1;
      }
      
      public function get entitiesFrame() : RoleplayEntitiesFrame
      {
         return this._entitiesFrame;
      }
      
      private function get socialFrame() : SocialFrame
      {
         return Kernel.getWorker().getFrame(SocialFrame) as SocialFrame;
      }
      
      public function get hasWorldInteraction() : Boolean
      {
         return !this._interactionIsLimited;
      }
      
      public function get commonExchangeFrame() : CommonExchangeManagementFrame
      {
         return this._commonExchangeFrame;
      }
      
      public function get hasGuildedPaddock() : Boolean
      {
         return Boolean(this._currentPaddock) && Boolean(this._currentPaddock.guildIdentity);
      }
      
      public function get currentPaddock() : PaddockWrapper
      {
         return this._currentPaddock;
      }
      
      public function pushed() : Boolean
      {
         this._entitiesFrame = new RoleplayEntitiesFrame();
         this._delayedActionFrame = new DelayedActionFrame();
         this._movementFrame = new RoleplayMovementFrame();
         this._worldFrame = new RoleplayWorldFrame();
         this._interactivesFrame = new RoleplayInteractivesFrame();
         Kernel.getWorker().addFrame(this._delayedActionFrame);
         this._npcDialogFrame = new NpcDialogFrame();
         this._documentFrame = new DocumentFrame();
         this._zaapFrame = new ZaapFrame();
         this._paddockFrame = new PaddockFrame();
         this._exchangeManagementFrame = new ExchangeManagementFrame();
         this._spectatorManagementFrame = new SpectatorManagementFrame();
         this._bidHouseManagementFrame = new BidHouseManagementFrame();
         this._estateFrame = new EstateFrame();
         this._craftFrame = new CraftFrame();
         this._humanVendorManagementFrame = new HumanVendorManagementFrame();
         this._spellForgetDialogFrame = new SpellForgetDialogFrame();
         Kernel.getWorker().addFrame(this._spectatorManagementFrame);
         if(!Kernel.getWorker().contains(EstateFrame))
         {
            Kernel.getWorker().addFrame(this._estateFrame);
         }
         this._allianceFrame = Kernel.getWorker().getFrame(AllianceFrame) as AllianceFrame;
         this._allianceFrame.pushRoleplay();
         if(!Kernel.getWorker().contains(EmoticonFrame))
         {
            this._emoticonFrame = new EmoticonFrame();
            Kernel.getWorker().addFrame(this._emoticonFrame);
         }
         else
         {
            this._emoticonFrame = Kernel.getWorker().getFrame(EmoticonFrame) as EmoticonFrame;
         }
         this._playersMultiCraftSkill = new Array();
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         /*
          * Erreur de décompilation
          * Le délais dattente de ({0}) est expiré
          * Nb d'instructions : 4214
          */
         throw new flash.errors.IllegalOperationError("Non décompilé car le délais d'attente a été atteint");
      }
      
      public function pulled() : Boolean
      {
         var _loc1_:AllianceFrame = Kernel.getWorker().getFrame(AllianceFrame) as AllianceFrame;
         _loc1_.pullRoleplay();
         this._interactivesFrame.clear();
         Kernel.getWorker().removeFrame(this._entitiesFrame);
         Kernel.getWorker().removeFrame(this._delayedActionFrame);
         Kernel.getWorker().removeFrame(this._worldFrame);
         Kernel.getWorker().removeFrame(this._movementFrame);
         Kernel.getWorker().removeFrame(this._interactivesFrame);
         Kernel.getWorker().removeFrame(this._spectatorManagementFrame);
         Kernel.getWorker().removeFrame(this._npcDialogFrame);
         Kernel.getWorker().removeFrame(this._documentFrame);
         Kernel.getWorker().removeFrame(this._zaapFrame);
         Kernel.getWorker().removeFrame(this._paddockFrame);
         return true;
      }
      
      public function getActorName(param1:int) : String
      {
         var _loc2_:GameRolePlayActorInformations = null;
         var _loc3_:GameRolePlayTaxCollectorInformations = null;
         _loc2_ = this.getActorInfos(param1);
         if(!_loc2_)
         {
            return "Unknown Actor";
         }
         switch(true)
         {
            case _loc2_ is GameRolePlayNamedActorInformations:
               return (_loc2_ as GameRolePlayNamedActorInformations).name;
            case _loc2_ is GameRolePlayTaxCollectorInformations:
               _loc3_ = _loc2_ as GameRolePlayTaxCollectorInformations;
               return TaxCollectorFirstname.getTaxCollectorFirstnameById(_loc3_.identification.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(_loc3_.identification.lastNameId).name;
            case _loc2_ is GameRolePlayNpcInformations:
               return Npc.getNpcById((_loc2_ as GameRolePlayNpcInformations).npcId).name;
            case _loc2_ is GameRolePlayGroupMonsterInformations:
            case _loc2_ is GameRolePlayPrismInformations:
               _log.error("Fail: getActorName called with an actorId corresponding to a monsters group or a prism (" + _loc2_ + ").");
               return "<error: cannot get a name>";
            default:
               return "Unknown Actor Type";
         }
      }
      
      private function getActorInfos(param1:int) : GameRolePlayActorInformations
      {
         return this.entitiesFrame.getEntityInfos(param1) as GameRolePlayActorInformations;
      }
      
      private function executeSpellBuffer(param1:Function, param2:Boolean, param3:Boolean = false, param4:RoleplaySpellCastProvider = null) : void
      {
         var _loc6_:ISequencable = null;
         var _loc5_:SerialSequencer = new SerialSequencer();
         for each(_loc6_ in param4.stepsBuffer)
         {
            _loc5_.addStep(_loc6_);
         }
         _loc5_.start();
      }
      
      private function addCraftFrame() : void
      {
         if(!Kernel.getWorker().contains(CraftFrame))
         {
            Kernel.getWorker().addFrame(this._craftFrame);
         }
      }
      
      private function addCommonExchangeFrame(param1:uint) : void
      {
         if(!Kernel.getWorker().contains(CommonExchangeManagementFrame))
         {
            this._commonExchangeFrame = new CommonExchangeManagementFrame(param1);
            Kernel.getWorker().addFrame(this._commonExchangeFrame);
         }
      }
      
      private function onListenOrientation(param1:MouseEvent) : void
      {
         var _loc2_:Point = this._playerEntity.localToGlobal(new Point(0,0));
         var _loc3_:Number = StageShareManager.stage.mouseY - _loc2_.y;
         var _loc4_:Number = StageShareManager.stage.mouseX - _loc2_.x;
         var _loc5_:uint = AngleToOrientation.angleToOrientation(Math.atan2(_loc3_,_loc4_));
         var _loc6_:String = this._playerEntity.getAnimation();
         var _loc7_:Emoticon = Emoticon.getEmoticonById(this._entitiesFrame.currentEmoticon);
         if(!_loc7_ || _loc7_ && _loc7_.eight_directions)
         {
            this._playerEntity.setDirection(_loc5_);
         }
         else if(_loc5_ % 2 == 0)
         {
            this._playerEntity.setDirection(_loc5_ + 1);
         }
         else
         {
            this._playerEntity.setDirection(_loc5_);
         }
      }
      
      private function onClickOrientation(param1:MouseEvent) : void
      {
         Kernel.getWorker().process(ChangeWorldInteractionAction.create(true));
         StageShareManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onListenOrientation);
         StageShareManager.stage.removeEventListener(MouseEvent.CLICK,this.onClickOrientation);
         var _loc2_:String = this._playerEntity.getAnimation();
         var _loc3_:GameMapChangeOrientationRequestMessage = new GameMapChangeOrientationRequestMessage();
         _loc3_.initGameMapChangeOrientationRequestMessage(this._playerEntity.getDirection());
         ConnectionsHandler.getConnection().send(_loc3_);
      }
      
      public function getMultiCraftSkills(param1:uint) : Vector.<uint>
      {
         var _loc2_:MultiCraftEnableForPlayer = null;
         for each(_loc2_ in this._playersMultiCraftSkill)
         {
            if(_loc2_.playerId == param1)
            {
               return _loc2_.skills;
            }
         }
         return null;
      }
   }
}

class MultiCraftEnableForPlayer
{
   public var playerId:uint;
   
   public var skills:Vector.<uint>;
   
   public function MultiCraftEnableForPlayer()
   {
      super();
   }
}
