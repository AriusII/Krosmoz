package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class MapCharactersItemCriterion extends ItemCriterion implements IDataCenter
   {
      private var _mapId:int;
      
      private var _nbCharacters:uint;
      
      public function MapCharactersItemCriterion(param1:String)
      {
         super(param1);
         var _loc2_:Array = _criterionValueText.split(",");
         if(_loc2_.length == 1)
         {
            this._mapId = PlayedCharacterManager.getInstance().currentMap.mapId;
            this._nbCharacters = uint(_loc2_[0]);
         }
         else if(_loc2_.length == 2)
         {
            this._mapId = int(_loc2_[0]);
            this._nbCharacters = uint(_loc2_[1]);
         }
      }
      
      override public function get text() : String
      {
         var _loc1_:String = I18n.getUiText("ui.criterion.MK",[this._mapId]);
         return _loc1_ + " " + _operator.text + " " + this._nbCharacters;
      }
      
      override public function clone() : IItemCriterion
      {
         return new MapCharactersItemCriterion(this.basicText);
      }
      
      override protected function getCriterion() : int
      {
         return PlayedCharacterManager.getInstance().infos.level;
      }
   }
}

