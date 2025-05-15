package com.ankamagames.dofus.logic.game.common.actions.humanVendor
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeShopStockModifyObjectAction implements Action
   {
      public var objectUID:uint;
      
      public var quantity:int;
      
      public var price:int;
      
      public function ExchangeShopStockModifyObjectAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:int, param3:int) : ExchangeShopStockModifyObjectAction
      {
         var _loc4_:ExchangeShopStockModifyObjectAction = new ExchangeShopStockModifyObjectAction();
         _loc4_.objectUID = param1;
         _loc4_.quantity = param2;
         _loc4_.price = param3;
         return _loc4_;
      }
   }
}

