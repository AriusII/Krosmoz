package com.ankamagames.dofus.logic.game.fight.managers
{
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Cone;
   import com.ankamagames.jerakine.types.zones.Cross;
   import com.ankamagames.jerakine.types.zones.HalfLozenge;
   import com.ankamagames.jerakine.types.zones.IZone;
   import com.ankamagames.jerakine.types.zones.Line;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.jerakine.types.zones.Square;
   import com.ankamagames.jerakine.utils.display.spellZone.SpellShapeEnum;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.utils.getQualifiedClassName;
   
   public class SpellZoneManager implements IDestroyable
   {
      private static var _self:SpellZoneManager;
      
      private static var _log:Logger = Log.getLogger(getQualifiedClassName(SpellZoneManager));
      
      private static const ZONE_COLOR:Color = new Color(10929860);
      
      private static const SELECTION_ZONE:String = "SpellCastZone";
      
      private var _targetSelection:Selection;
      
      private var _spellWrapper:Object;
      
      public function SpellZoneManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("SpellZoneManager is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : SpellZoneManager
      {
         if(_self == null)
         {
            _self = new SpellZoneManager();
         }
         return _self;
      }
      
      public function destroy() : void
      {
         _self = null;
      }
      
      public function displaySpellZone(param1:int, param2:int, param3:int, param4:uint, param5:uint) : void
      {
         this._spellWrapper = SpellWrapper.create(0,param4,param5,false,param1);
         if(this._spellWrapper && param2 != -1 && param3 != -1)
         {
            this._targetSelection = new Selection();
            this._targetSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_NO_Z_ORDER);
            this._targetSelection.color = ZONE_COLOR;
            this._targetSelection.zone = this.getSpellZone();
            this._targetSelection.zone.direction = MapPoint.fromCellId(param3).advancedOrientationTo(MapPoint.fromCellId(param2),false);
            SelectionManager.getInstance().addSelection(this._targetSelection,SELECTION_ZONE);
            SelectionManager.getInstance().update(SELECTION_ZONE,param2);
         }
         else
         {
            this.removeTarget();
         }
      }
      
      public function removeSpellZone() : void
      {
         this.removeTarget();
      }
      
      private function removeTarget() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection(SELECTION_ZONE);
         if(_loc1_)
         {
            _loc1_.remove();
         }
      }
      
      private function getSpellZone() : IZone
      {
         var _loc2_:uint = 0;
         var _loc3_:EffectInstance = null;
         var _loc4_:Cross = null;
         var _loc5_:Square = null;
         var _loc6_:Cross = null;
         var _loc7_:Cross = null;
         var _loc8_:Cross = null;
         var _loc9_:Cross = null;
         var _loc1_:uint = 88;
         _loc2_ = 666;
         for each(_loc3_ in this._spellWrapper["effects"])
         {
            if(_loc3_.zoneShape != 0 && _loc3_.zoneSize > 0)
            {
               _loc2_ = Math.min(_loc2_,_loc3_.zoneSize);
               _loc1_ = _loc3_.zoneShape;
            }
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
               _loc4_ = new Cross(0,_loc2_,DataMapProvider.getInstance());
               _loc4_.onlyPerpendicular = true;
               return _loc4_;
            case SpellShapeEnum.D:
               return new Cross(0,_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.C:
               return new Lozenge(0,_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.I:
               return new Lozenge(_loc2_,63,DataMapProvider.getInstance());
            case SpellShapeEnum.O:
               return new Lozenge(_loc2_,_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.Q:
               return new Cross(1,_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.G:
               return new Square(0,_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.V:
               return new Cone(0,_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.W:
               _loc5_ = new Square(0,_loc2_,DataMapProvider.getInstance());
               _loc5_.diagonalFree = true;
               return _loc5_;
            case SpellShapeEnum.plus:
               _loc6_ = new Cross(0,_loc2_,DataMapProvider.getInstance());
               _loc6_.diagonal = true;
               return _loc6_;
            case SpellShapeEnum.sharp:
               _loc7_ = new Cross(1,_loc2_,DataMapProvider.getInstance());
               _loc7_.diagonal = true;
               return _loc7_;
            case SpellShapeEnum.star:
               _loc8_ = new Cross(0,_loc2_,DataMapProvider.getInstance());
               _loc8_.allDirections = true;
               return _loc8_;
            case SpellShapeEnum.slash:
               return new Line(_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.minus:
               _loc9_ = new Cross(0,_loc2_,DataMapProvider.getInstance());
               _loc9_.onlyPerpendicular = true;
               _loc9_.diagonal = true;
               return _loc9_;
            case SpellShapeEnum.U:
               return new HalfLozenge(0,_loc2_,DataMapProvider.getInstance());
            case SpellShapeEnum.A:
               return new Lozenge(0,63,DataMapProvider.getInstance());
            case SpellShapeEnum.P:
         }
         _log.debug("spell shape : " + _loc1_);
         return new Cross(0,0,DataMapProvider.getInstance());
      }
   }
}

