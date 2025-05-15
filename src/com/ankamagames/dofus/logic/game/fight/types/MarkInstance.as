package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   
   public class MarkInstance
   {
      public var markId:int;
      
      public var markType:int;
      
      public var associatedSpell:Spell;
      
      public var selections:Vector.<Selection>;
      
      public var cells:Vector.<uint>;
      
      public function MarkInstance()
      {
         super();
      }
   }
}

