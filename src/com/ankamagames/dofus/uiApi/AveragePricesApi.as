package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.AveragePricesFrame;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class AveragePricesApi implements IApi
   {
      protected var _log:Logger = Log.getLogger(getQualifiedClassName(AveragePricesApi));
      
      private var _module:UiModule;
      
      public function AveragePricesApi()
      {
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Trusted]
      public function getItemAveragePrice(param1:uint) : int
      {
         var _loc2_:int = 0;
         var _loc3_:AveragePricesFrame = null;
         if(this.dataAvailable())
         {
            _loc3_ = Kernel.getWorker().getFrame(AveragePricesFrame) as AveragePricesFrame;
            _loc2_ = int(_loc3_.pricesData.items["item" + param1]);
         }
         return _loc2_;
      }
      
      [Trusted]
      public function getItemAveragePriceString(param1:*, param2:Boolean = false) : String
      {
         var _loc4_:int = 0;
         var _loc5_:* = false;
         var _loc3_:String = "";
         if(param1.exchangeable)
         {
            _loc4_ = this.getItemAveragePrice(param1.objectGID);
            _loc5_ = _loc4_ > 0;
            _loc3_ += (param2 ? "\n" : "") + I18n.getUiText("ui.item.averageprice") + " : " + (_loc5_ ? StringUtils.kamasToString(_loc4_) : I18n.getUiText("ui.item.averageprice.unavailable"));
            if(_loc5_ && param1.quantity > 1)
            {
               _loc3_ += "\n" + I18n.getUiText("ui.item.averageprice.stack") + " : " + StringUtils.kamasToString(_loc4_ * param1.quantity);
            }
         }
         return _loc3_;
      }
      
      [Trusted]
      public function dataAvailable() : Boolean
      {
         var _loc1_:AveragePricesFrame = Kernel.getWorker().getFrame(AveragePricesFrame) as AveragePricesFrame;
         return _loc1_.dataAvailable;
      }
   }
}

