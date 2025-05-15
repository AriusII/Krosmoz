package com.ankamagames.jerakine.types
{
   public class Callback
   {
      public var method:Function;
      
      public var args:Array;
      
      public function Callback(param1:Function, ... rest)
      {
         super();
         this.method = param1;
         this.args = rest;
      }
      
      public function exec() : void
      {
         this.method.apply(null,this.args);
      }
   }
}

