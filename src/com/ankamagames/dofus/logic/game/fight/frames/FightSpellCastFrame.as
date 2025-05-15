package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.*;
   import com.ankamagames.atouin.messages.AdjacentMapClickMessage;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.messages.CellOutMessage;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.atouin.renderers.*;
   import com.ankamagames.atouin.types.*;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.actions.BannerEmptySlotClickAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityClickAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOverAction;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.GameActionMarkTypeEnum;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCastOnTargetRequestMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCastRequestMessage;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.types.entities.Glyph;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.messages.EntityClickMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseRightClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseUpMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.map.*;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Cone;
   import com.ankamagames.jerakine.types.zones.Cross;
   import com.ankamagames.jerakine.types.zones.Custom;
   import com.ankamagames.jerakine.types.zones.HalfLozenge;
   import com.ankamagames.jerakine.types.zones.IZone;
   import com.ankamagames.jerakine.types.zones.Line;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.jerakine.types.zones.Square;
   import com.ankamagames.jerakine.utils.display.spellZone.SpellShapeEnum;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class FightSpellCastFrame implements Frame
   {
      private static const FORBIDDEN_CURSOR:Class = FightSpellCastFrame_FORBIDDEN_CURSOR;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightSpellCastFrame));
      
      private static const RANGE_COLOR:Color = new Color(5533093);
      
      private static const LOS_COLOR:Color = new Color(2241433);
      
      private static const TARGET_COLOR:Color = new Color(14487842);
      
      private static const SELECTION_RANGE:String = "SpellCastRange";
      
      private static const SELECTION_LOS:String = "SpellCastLos";
      
      private static const SELECTION_TARGET:String = "SpellCastTarget";
      
      private static const FORBIDDEN_CURSOR_NAME:String = "SpellCastForbiddenCusror";
      
      private var _spellLevel:Object;
      
      private var _spellId:uint;
      
      private var _rangeSelection:Selection;
      
      private var _losSelection:Selection;
      
      private var _targetSelection:Selection;
      
      private var _currentCell:int = -1;
      
      private var _virtualCast:Boolean;
      
      private var _cancelTimer:Timer;
      
      private var _cursorData:LinkedCursorData;
      
      private var _lastTargetStatus:Boolean = true;
      
      private var _isInfiniteTarget:Boolean;
      
      private var _usedWrapper:*;
      
      private var _currentTargetIsTargetable:Boolean;
      
      private var _clearTargetTimer:Timer;
      
      public function FightSpellCastFrame(param1:uint)
      {
         var _loc2_:SpellWrapper = null;
         var _loc3_:* = undefined;
         super();
         this._spellId = param1;
         this._cursorData = new LinkedCursorData();
         this._cursorData.sprite = new FORBIDDEN_CURSOR();
         this._cursorData.sprite.cacheAsBitmap = true;
         this._cursorData.offset = new Point(14,14);
         this._cancelTimer = new Timer(50);
         this._cancelTimer.addEventListener(TimerEvent.TIMER,this.cancelCast);
         if(Boolean(param1) || !PlayedCharacterManager.getInstance().currentWeapon)
         {
            for each(_loc2_ in PlayedCharacterManager.getInstance().spellsInventory)
            {
               if(_loc2_.spellId == this._spellId)
               {
                  this._spellLevel = _loc2_;
               }
            }
         }
         else
         {
            _loc3_ = PlayedCharacterManager.getInstance().currentWeapon;
            this._spellLevel = {
               "effects":_loc3_.effects,
               "castTestLos":_loc3_.castTestLos,
               "castInLine":_loc3_.castInLine,
               "castInDiagonal":_loc3_.castInDiagonal,
               "minRange":_loc3_.minRange,
               "range":_loc3_.range,
               "apCost":_loc3_.apCost,
               "needFreeCell":false,
               "needTakenCell":false,
               "needFreeTrapCell":false
            };
         }
         this._clearTargetTimer = new Timer(50,1);
         this._clearTargetTimer.addEventListener(TimerEvent.TIMER,this.onClearTarget);
      }
      
      public static function updateRangeAndTarget() : void
      {
         var _loc1_:FightSpellCastFrame = Kernel.getWorker().getFrame(FightSpellCastFrame) as FightSpellCastFrame;
         if(_loc1_)
         {
            _loc1_.removeRange();
            _loc1_.drawRange();
            _loc1_.refreshTarget(true);
         }
      }
      
      public function get priority() : int
      {
         return Priority.HIGHEST;
      }
      
      public function get currentTargetIsTargetable() : Boolean
      {
         return this._currentTargetIsTargetable;
      }
      
      public function pushed() : Boolean
      {
         this._cancelTimer.reset();
         this._lastTargetStatus = true;
         if(this._spellId == 0)
         {
            if(PlayedCharacterManager.getInstance().currentWeapon)
            {
               this._usedWrapper = PlayedCharacterManager.getInstance().currentWeapon;
            }
            else
            {
               this._usedWrapper = SpellWrapper.create(-1,0,1,false,PlayedCharacterManager.getInstance().id);
            }
         }
         else
         {
            this._usedWrapper = SpellWrapper.getFirstSpellWrapperById(this._spellId,CurrentPlayedFighterManager.getInstance().currentFighterId);
         }
         KernelEventsManager.getInstance().processCallback(HookList.CastSpellMode,this._usedWrapper);
         this.drawRange();
         this.refreshTarget();
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:CellOverMessage = null;
         var _loc3_:EntityMouseOverMessage = null;
         var _loc4_:TimelineEntityOverAction = null;
         var _loc5_:IEntity = null;
         var _loc6_:CellClickMessage = null;
         var _loc7_:EntityClickMessage = null;
         var _loc8_:TimelineEntityClickAction = null;
         switch(true)
         {
            case param1 is CellOverMessage:
               _loc2_ = param1 as CellOverMessage;
               FightContextFrame.currentCell = _loc2_.cellId;
               this.refreshTarget();
               return false;
            case param1 is EntityMouseOutMessage:
               this.clearTarget();
               return false;
            case param1 is CellOutMessage:
               this.clearTarget();
               return false;
            case param1 is EntityMouseOverMessage:
               _loc3_ = param1 as EntityMouseOverMessage;
               FightContextFrame.currentCell = _loc3_.entity.position.cellId;
               this.refreshTarget();
               return false;
            case param1 is TimelineEntityOverAction:
               _loc4_ = param1 as TimelineEntityOverAction;
               _loc5_ = DofusEntities.getEntity(_loc4_.targetId);
               if((_loc5_) && _loc5_.position && _loc5_.position.cellId > -1)
               {
                  FightContextFrame.currentCell = _loc5_.position.cellId;
                  this.refreshTarget();
               }
               return false;
            case param1 is CellClickMessage:
               _loc6_ = param1 as CellClickMessage;
               this.castSpell(_loc6_.cellId);
               return true;
            case param1 is EntityClickMessage:
               _loc7_ = param1 as EntityClickMessage;
               this.castSpell(_loc7_.entity.position.cellId,_loc7_.entity.id);
               return true;
            case param1 is TimelineEntityClickAction:
               _loc8_ = param1 as TimelineEntityClickAction;
               this.castSpell(0,_loc8_.fighterId);
               return true;
            case param1 is AdjacentMapClickMessage:
            case param1 is MouseRightClickMessage:
               this.cancelCast();
               return true;
            case param1 is BannerEmptySlotClickAction:
               this.cancelCast();
               return true;
            case param1 is MouseUpMessage:
               this._cancelTimer.start();
               return false;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         this._cancelTimer.reset();
         this.removeRange();
         this.removeTarget();
         LinkedCursorSpriteManager.getInstance().removeItem(FORBIDDEN_CURSOR_NAME);
         try
         {
            KernelEventsManager.getInstance().processCallback(HookList.CancelCastSpell,SpellWrapper.getFirstSpellWrapperById(this._spellId,CurrentPlayedFighterManager.getInstance().currentFighterId));
         }
         catch(e:Error)
         {
         }
         return true;
      }
      
      public function refreshTarget(param1:Boolean = false) : void
      {
         var _loc5_:int = 0;
         var _loc6_:GameFightFighterInformations = null;
         var _loc7_:ZoneDARenderer = null;
         var _loc8_:Boolean = false;
         if(this._clearTargetTimer.running)
         {
            this._clearTargetTimer.reset();
         }
         var _loc2_:int = FightContextFrame.currentCell;
         if(!param1 && this._currentCell == _loc2_)
         {
            return;
         }
         this._currentCell = _loc2_;
         var _loc3_:FightTurnFrame = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:Boolean = _loc3_.myTurn;
         this._currentTargetIsTargetable = this.isValidCell(_loc2_);
         if(_loc2_ != -1 && this._currentTargetIsTargetable)
         {
            if(!this._targetSelection)
            {
               this._targetSelection = new Selection();
               this._targetSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA,1,true);
               this._targetSelection.color = TARGET_COLOR;
               this._targetSelection.zone = this.getSpellZone();
               SelectionManager.getInstance().addSelection(this._targetSelection,SELECTION_TARGET);
            }
            _loc5_ = CurrentPlayedFighterManager.getInstance().currentFighterId;
            _loc6_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc5_) as GameFightFighterInformations;
            if(_loc6_)
            {
               this._targetSelection.zone.direction = MapPoint(MapPoint.fromCellId(_loc6_.disposition.cellId)).advancedOrientationTo(MapPoint.fromCellId(_loc2_),false);
            }
            _loc7_ = this._targetSelection.renderer as ZoneDARenderer;
            if(Boolean(Atouin.getInstance().options.transparentOverlayMode) && _loc2_ != DofusEntities.getEntity(PlayedCharacterManager.getInstance().id).position.cellId)
            {
               _loc7_.currentStrata = PlacementStrataEnums.STRATA_NO_Z_ORDER;
               SelectionManager.getInstance().update(SELECTION_TARGET,_loc2_,true);
            }
            else
            {
               if(_loc7_.currentStrata == PlacementStrataEnums.STRATA_NO_Z_ORDER)
               {
                  _loc7_.currentStrata = PlacementStrataEnums.STRATA_AREA;
                  _loc8_ = true;
               }
               SelectionManager.getInstance().update(SELECTION_TARGET,_loc2_,_loc8_);
            }
            if(_loc4_)
            {
               LinkedCursorSpriteManager.getInstance().removeItem(FORBIDDEN_CURSOR_NAME);
               this._lastTargetStatus = true;
            }
            else
            {
               if(this._lastTargetStatus)
               {
                  LinkedCursorSpriteManager.getInstance().addItem(FORBIDDEN_CURSOR_NAME,this._cursorData,true);
               }
               this._lastTargetStatus = false;
            }
         }
         else
         {
            if(this._lastTargetStatus)
            {
               LinkedCursorSpriteManager.getInstance().addItem(FORBIDDEN_CURSOR_NAME,this._cursorData,true);
            }
            this.removeTarget();
            this._lastTargetStatus = false;
         }
      }
      
      public function drawRange() : void
      {
         var _loc7_:Cross = null;
         var _loc8_:Vector.<uint> = null;
         var _loc9_:Vector.<uint> = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:uint = 0;
         var _loc1_:int = CurrentPlayedFighterManager.getInstance().currentFighterId;
         var _loc2_:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc1_) as GameFightFighterInformations;
         var _loc3_:uint = uint(_loc2_.disposition.cellId);
         var _loc4_:CharacterBaseCharacteristic = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().range;
         var _loc5_:int = int(this._spellLevel.range);
         if(!this._spellLevel.castInLine && !this._spellLevel.castInDiagonal && !this._spellLevel.castTestLos && _loc5_ == 63)
         {
            this._isInfiniteTarget = true;
            return;
         }
         this._isInfiniteTarget = false;
         if(this._spellLevel["rangeCanBeBoosted"])
         {
            _loc5_ += _loc4_.base + _loc4_.objectsAndMountBonus + _loc4_.alignGiftBonus + _loc4_.contextModif;
            if(_loc5_ < this._spellLevel.minRange)
            {
               _loc5_ = int(this._spellLevel.minRange);
            }
         }
         _loc5_ = Math.min(_loc5_,AtouinConstants.MAP_WIDTH * AtouinConstants.MAP_HEIGHT);
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         var _loc6_:Boolean = Boolean(this._spellLevel.castTestLos) && Boolean(Dofus.getInstance().options.showLineOfSight);
         this._rangeSelection = new Selection();
         this._rangeSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
         this._rangeSelection.color = _loc6_ ? RANGE_COLOR : LOS_COLOR;
         this._rangeSelection.alpha = true;
         if(Boolean(this._spellLevel.castInLine) && Boolean(this._spellLevel.castInDiagonal))
         {
            _loc7_ = new Cross(this._spellLevel.minRange,_loc5_,DataMapProvider.getInstance());
            _loc7_.allDirections = true;
            this._rangeSelection.zone = _loc7_;
         }
         else if(this._spellLevel.castInLine)
         {
            this._rangeSelection.zone = new Cross(this._spellLevel.minRange,_loc5_,DataMapProvider.getInstance());
         }
         else if(this._spellLevel.castInDiagonal)
         {
            _loc7_ = new Cross(this._spellLevel.minRange,_loc5_,DataMapProvider.getInstance());
            _loc7_.diagonal = true;
            this._rangeSelection.zone = _loc7_;
         }
         else
         {
            this._rangeSelection.zone = new Lozenge(this._spellLevel.minRange,_loc5_,DataMapProvider.getInstance());
         }
         this._losSelection = null;
         if(_loc6_)
         {
            this.drawLos(_loc3_);
         }
         if(this._losSelection)
         {
            this._rangeSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA,0.5);
            _loc8_ = new Vector.<uint>();
            _loc9_ = this._rangeSelection.zone.getCells(_loc3_);
            _loc10_ = int(_loc9_.length);
            while(_loc11_ < _loc10_)
            {
               _loc12_ = _loc9_[_loc11_];
               if(this._losSelection.cells.indexOf(_loc12_) == -1)
               {
                  _loc8_.push(_loc12_);
               }
               _loc11_++;
            }
            this._rangeSelection.zone = new Custom(_loc8_);
         }
         SelectionManager.getInstance().addSelection(this._rangeSelection,SELECTION_RANGE,_loc3_);
      }
      
      private function clearTarget() : void
      {
         if(!this._clearTargetTimer.running)
         {
            this._clearTargetTimer.start();
         }
      }
      
      private function onClearTarget(param1:TimerEvent) : void
      {
         this.refreshTarget();
      }
      
      private function castSpell(param1:uint, param2:int = 0) : void
      {
         var _loc4_:GameActionFightCastOnTargetRequestMessage = null;
         var _loc5_:GameActionFightCastRequestMessage = null;
         var _loc3_:FightTurnFrame = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
         if(!_loc3_ || !_loc3_.myTurn)
         {
            return;
         }
         if(CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent < this._spellLevel.apCost)
         {
            return;
         }
         if(param2 != 0 && !FightEntitiesFrame.getCurrentInstance().entityIsIllusion(param2))
         {
            CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent - this._spellLevel.apCost;
            _loc4_ = new GameActionFightCastOnTargetRequestMessage();
            _loc4_.initGameActionFightCastOnTargetRequestMessage(this._spellId,param2);
            ConnectionsHandler.getConnection().send(_loc4_);
         }
         else if(this.isValidCell(param1))
         {
            CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent - this._spellLevel.apCost;
            _loc5_ = new GameActionFightCastRequestMessage();
            _loc5_.initGameActionFightCastRequestMessage(this._spellId,param1);
            ConnectionsHandler.getConnection().send(_loc5_);
         }
         this.cancelCast();
      }
      
      private function cancelCast(... rest) : void
      {
         this._cancelTimer.reset();
         Kernel.getWorker().removeFrame(this);
      }
      
      private function drawLos(param1:uint) : void
      {
         this._losSelection = new Selection();
         this._losSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
         this._losSelection.color = LOS_COLOR;
         var _loc2_:Vector.<uint> = this._rangeSelection.zone.getCells(param1);
         this._losSelection.zone = new Custom(LosDetector.getCell(DataMapProvider.getInstance(),_loc2_,MapPoint.fromCellId(param1)));
         SelectionManager.getInstance().addSelection(this._losSelection,SELECTION_LOS,param1);
      }
      
      private function removeRange() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection(SELECTION_RANGE);
         if(_loc1_)
         {
            _loc1_.remove();
            this._rangeSelection = null;
         }
         var _loc2_:Selection = SelectionManager.getInstance().getSelection(SELECTION_LOS);
         if(_loc2_)
         {
            _loc2_.remove();
            this._losSelection = null;
         }
         this._isInfiniteTarget = false;
      }
      
      private function removeTarget() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection(SELECTION_TARGET);
         if(_loc1_)
         {
            _loc1_.remove();
            this._rangeSelection = null;
         }
      }
      
      private function getSpellZone() : IZone
      {
         var _loc2_:uint = 0;
         var _loc4_:EffectInstance = null;
         var _loc5_:Cross = null;
         var _loc6_:Square = null;
         var _loc7_:Cross = null;
         var _loc8_:Cross = null;
         var _loc9_:Cross = null;
         var _loc10_:Cross = null;
         var _loc1_:uint = 88;
         _loc2_ = 666;
         var _loc3_:uint = 0;
         if(!this._spellLevel.hasOwnProperty("shape"))
         {
            for each(_loc4_ in this._spellLevel["effects"])
            {
               if(_loc4_.zoneShape != 0 && _loc4_.zoneSize > 0)
               {
                  _loc2_ = _loc4_.zoneSize;
                  _loc1_ = _loc4_.zoneShape;
                  _loc3_ = _loc4_.zoneMinSize;
               }
            }
         }
         else
         {
            _loc1_ = uint(this._spellLevel.shape);
            _loc2_ = uint(this._spellLevel.ray);
         }
         if(_loc2_ == 666)
         {
            _loc2_ = 0;
         }
         switch(_loc1_)
         {
            case SpellShapeEnum.X:
               return new Cross(0,_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.L:
               return new Line(_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.T:
               _loc5_ = new Cross(0,_loc2_,DataMapProvider.getInstance());
               _loc5_.onlyPerpendicular = true;
               return _loc5_;
            case SpellShapeEnum.D:
               return new Cross(0,_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.C:
               return new Lozenge(0,_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.I:
               return new Lozenge(_loc2_,63,DataMapProvider.getInstance());
            case SpellShapeEnum.O:
               return new Lozenge(_loc2_,_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.Q:
               return new Cross(!!_loc3_ ? _loc3_ : 1,_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.G:
               return new Square(0,_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.V:
               return new Cone(0,_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.W:
               _loc6_ = new Square(0,_loc2_,DataMapProvider.getInstance());
               _loc6_.diagonalFree = true;
               return _loc6_;
            case SpellShapeEnum.plus:
               _loc7_ = new Cross(0,_loc2_,DataMapProvider.getInstance());
               _loc7_.diagonal = true;
               return _loc7_;
            case SpellShapeEnum.sharp:
               _loc8_ = new Cross(1,_loc2_,DataMapProvider.getInstance());
               _loc8_.diagonal = true;
               return _loc8_;
            case SpellShapeEnum.star:
               _loc9_ = new Cross(0,_loc2_,DataMapProvider.getInstance());
               _loc9_.allDirections = true;
               return _loc9_;
            case SpellShapeEnum.slash:
               return new Line(_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.minus:
               _loc10_ = new Cross(0,_loc2_,DataMapProvider.getInstance());
               _loc10_.onlyPerpendicular = true;
               _loc10_.diagonal = true;
               return _loc10_;
            case SpellShapeEnum.U:
               return new HalfLozenge(0,_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.P:
         }
         return new Cross(0,0,DataMapProvider.getInstance());
      }
      
      private function isValidCell(param1:uint) : Boolean
      {
         var _loc2_:SpellLevel = null;
         var _loc3_:IEntity = null;
         var _loc4_:* = false;
         if(this._isInfiniteTarget)
         {
            return true;
         }
         if(this._spellId)
         {
            _loc2_ = this._spellLevel.spellLevelInfos;
            for each(_loc3_ in EntitiesManager.getInstance().getEntitiesOnCell(param1))
            {
               if(!CurrentPlayedFighterManager.getInstance().canCastThisSpell(this._spellLevel.spellId,this._spellLevel.spellLevel,_loc3_.id))
               {
                  return false;
               }
               _loc4_ = _loc3_ is Glyph;
               if(_loc2_.needFreeTrapCell && _loc4_ && (_loc3_ as Glyph).glyphType == GameActionMarkTypeEnum.TRAP)
               {
                  return false;
               }
               if(Boolean(this._spellLevel.needFreeCell) && !_loc4_)
               {
                  return false;
               }
            }
         }
         if(Boolean(this._spellLevel.castTestLos) && Boolean(Dofus.getInstance().options.showLineOfSight))
         {
            return SelectionManager.getInstance().isInside(param1,SELECTION_LOS);
         }
         return SelectionManager.getInstance().isInside(param1,SELECTION_RANGE);
      }
   }
}

