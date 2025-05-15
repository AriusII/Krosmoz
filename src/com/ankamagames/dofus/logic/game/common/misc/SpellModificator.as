package com.ankamagames.dofus.logic.game.common.misc
{
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
   
   public final class SpellModificator
   {
      public var apCost:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var castInterval:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var castIntervalSet:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var maxCastPerTurn:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var maxCastPerTarget:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public function SpellModificator()
      {
         super();
      }
      
      public function getTotalBonus(param1:CharacterBaseCharacteristic) : int
      {
         if(!param1)
         {
            return 0;
         }
         return param1.alignGiftBonus + param1.base + param1.contextModif + param1.objectsAndMountBonus;
      }
   }
}

