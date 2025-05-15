package com.ankamagames.dofus.network.types.game.character.characteristic
{
   import com.ankamagames.dofus.network.types.game.character.alignment.ActorExtendedAlignmentInformations;
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class CharacterCharacteristicsInformations implements INetworkType
   {
      public static const protocolId:uint = 8;
      
      public var experience:Number = 0;
      
      public var experienceLevelFloor:Number = 0;
      
      public var experienceNextLevelFloor:Number = 0;
      
      public var kamas:uint = 0;
      
      public var statsPoints:uint = 0;
      
      public var spellsPoints:uint = 0;
      
      public var alignmentInfos:ActorExtendedAlignmentInformations = new ActorExtendedAlignmentInformations();
      
      public var lifePoints:uint = 0;
      
      public var maxLifePoints:uint = 0;
      
      public var energyPoints:uint = 0;
      
      public var maxEnergyPoints:uint = 0;
      
      public var actionPointsCurrent:int = 0;
      
      public var movementPointsCurrent:int = 0;
      
      public var initiative:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var prospecting:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var actionPoints:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var movementPoints:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var strength:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var vitality:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var wisdom:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var chance:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var agility:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var intelligence:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var range:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var summonableCreaturesBoost:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var reflect:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var criticalHit:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var criticalHitWeapon:uint = 0;
      
      public var criticalMiss:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var healBonus:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var allDamagesBonus:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var weaponDamagesBonusPercent:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var damagesBonusPercent:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var trapBonus:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var trapBonusPercent:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var permanentDamagePercent:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var tackleBlock:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var tackleEvade:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var PAAttack:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var PMAttack:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var pushDamageBonus:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var criticalDamageBonus:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var neutralDamageBonus:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var earthDamageBonus:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var waterDamageBonus:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var airDamageBonus:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var fireDamageBonus:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var dodgePALostProbability:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var dodgePMLostProbability:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var neutralElementResistPercent:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var earthElementResistPercent:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var waterElementResistPercent:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var airElementResistPercent:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var fireElementResistPercent:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var neutralElementReduction:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var earthElementReduction:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var waterElementReduction:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var airElementReduction:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var fireElementReduction:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var pushDamageReduction:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var criticalDamageReduction:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var pvpNeutralElementResistPercent:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var pvpEarthElementResistPercent:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var pvpWaterElementResistPercent:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var pvpAirElementResistPercent:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var pvpFireElementResistPercent:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var pvpNeutralElementReduction:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var pvpEarthElementReduction:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var pvpWaterElementReduction:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var pvpAirElementReduction:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var pvpFireElementReduction:CharacterBaseCharacteristic = new CharacterBaseCharacteristic();
      
      public var spellModifications:Vector.<CharacterSpellModification> = new Vector.<CharacterSpellModification>();
      
      public var probationTime:uint = 0;
      
      public function CharacterCharacteristicsInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 8;
      }
      
      public function initCharacterCharacteristicsInformations(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:uint = 0, param5:uint = 0, param6:uint = 0, param7:ActorExtendedAlignmentInformations = null, param8:uint = 0, param9:uint = 0, param10:uint = 0, param11:uint = 0, param12:int = 0, param13:int = 0, param14:CharacterBaseCharacteristic = null, param15:CharacterBaseCharacteristic = null, param16:CharacterBaseCharacteristic = null, param17:CharacterBaseCharacteristic = null, param18:CharacterBaseCharacteristic = null, param19:CharacterBaseCharacteristic = null, param20:CharacterBaseCharacteristic = null, param21:CharacterBaseCharacteristic = null, param22:CharacterBaseCharacteristic = null, param23:CharacterBaseCharacteristic = null, param24:CharacterBaseCharacteristic = null, param25:CharacterBaseCharacteristic = null, param26:CharacterBaseCharacteristic = null, param27:CharacterBaseCharacteristic = null, param28:uint = 0, param29:CharacterBaseCharacteristic = null, param30:CharacterBaseCharacteristic = null, param31:CharacterBaseCharacteristic = null, param32:CharacterBaseCharacteristic = null, param33:CharacterBaseCharacteristic = null, param34:CharacterBaseCharacteristic = null, param35:CharacterBaseCharacteristic = null, param36:CharacterBaseCharacteristic = null, param37:CharacterBaseCharacteristic = null, param38:CharacterBaseCharacteristic = null, param39:CharacterBaseCharacteristic = null, param40:CharacterBaseCharacteristic = null, param41:CharacterBaseCharacteristic = null, param42:CharacterBaseCharacteristic = null, param43:CharacterBaseCharacteristic = null, param44:CharacterBaseCharacteristic = null, param45:CharacterBaseCharacteristic = null, param46:CharacterBaseCharacteristic = null, param47:CharacterBaseCharacteristic = null, param48:CharacterBaseCharacteristic = null, param49:CharacterBaseCharacteristic = null, param50:CharacterBaseCharacteristic = null, param51:CharacterBaseCharacteristic = null, param52:CharacterBaseCharacteristic = null, param53:CharacterBaseCharacteristic = null, param54:CharacterBaseCharacteristic = null, param55:CharacterBaseCharacteristic = null, param56:CharacterBaseCharacteristic = null, param57:CharacterBaseCharacteristic = null, param58:CharacterBaseCharacteristic = null, param59:CharacterBaseCharacteristic = null, param60:CharacterBaseCharacteristic = null, param61:CharacterBaseCharacteristic = null, param62:CharacterBaseCharacteristic = null, param63:CharacterBaseCharacteristic = null, param64:CharacterBaseCharacteristic = null, param65:CharacterBaseCharacteristic = null, param66:CharacterBaseCharacteristic = null, param67:CharacterBaseCharacteristic = null, param68:CharacterBaseCharacteristic = null, param69:CharacterBaseCharacteristic = null, param70:CharacterBaseCharacteristic = null, param71:CharacterBaseCharacteristic = null, param72:Vector.<CharacterSpellModification> = null, param73:uint = 0) : CharacterCharacteristicsInformations
      {
         this.experience = param1;
         this.experienceLevelFloor = param2;
         this.experienceNextLevelFloor = param3;
         this.kamas = param4;
         this.statsPoints = param5;
         this.spellsPoints = param6;
         this.alignmentInfos = param7;
         this.lifePoints = param8;
         this.maxLifePoints = param9;
         this.energyPoints = param10;
         this.maxEnergyPoints = param11;
         this.actionPointsCurrent = param12;
         this.movementPointsCurrent = param13;
         this.initiative = param14;
         this.prospecting = param15;
         this.actionPoints = param16;
         this.movementPoints = param17;
         this.strength = param18;
         this.vitality = param19;
         this.wisdom = param20;
         this.chance = param21;
         this.agility = param22;
         this.intelligence = param23;
         this.range = param24;
         this.summonableCreaturesBoost = param25;
         this.reflect = param26;
         this.criticalHit = param27;
         this.criticalHitWeapon = param28;
         this.criticalMiss = param29;
         this.healBonus = param30;
         this.allDamagesBonus = param31;
         this.weaponDamagesBonusPercent = param32;
         this.damagesBonusPercent = param33;
         this.trapBonus = param34;
         this.trapBonusPercent = param35;
         this.permanentDamagePercent = param36;
         this.tackleBlock = param37;
         this.tackleEvade = param38;
         this.PAAttack = param39;
         this.PMAttack = param40;
         this.pushDamageBonus = param41;
         this.criticalDamageBonus = param42;
         this.neutralDamageBonus = param43;
         this.earthDamageBonus = param44;
         this.waterDamageBonus = param45;
         this.airDamageBonus = param46;
         this.fireDamageBonus = param47;
         this.dodgePALostProbability = param48;
         this.dodgePMLostProbability = param49;
         this.neutralElementResistPercent = param50;
         this.earthElementResistPercent = param51;
         this.waterElementResistPercent = param52;
         this.airElementResistPercent = param53;
         this.fireElementResistPercent = param54;
         this.neutralElementReduction = param55;
         this.earthElementReduction = param56;
         this.waterElementReduction = param57;
         this.airElementReduction = param58;
         this.fireElementReduction = param59;
         this.pushDamageReduction = param60;
         this.criticalDamageReduction = param61;
         this.pvpNeutralElementResistPercent = param62;
         this.pvpEarthElementResistPercent = param63;
         this.pvpWaterElementResistPercent = param64;
         this.pvpAirElementResistPercent = param65;
         this.pvpFireElementResistPercent = param66;
         this.pvpNeutralElementReduction = param67;
         this.pvpEarthElementReduction = param68;
         this.pvpWaterElementReduction = param69;
         this.pvpAirElementReduction = param70;
         this.pvpFireElementReduction = param71;
         this.spellModifications = param72;
         this.probationTime = param73;
         return this;
      }
      
      public function reset() : void
      {
         this.experience = 0;
         this.experienceLevelFloor = 0;
         this.experienceNextLevelFloor = 0;
         this.kamas = 0;
         this.statsPoints = 0;
         this.spellsPoints = 0;
         this.alignmentInfos = new ActorExtendedAlignmentInformations();
         this.maxLifePoints = 0;
         this.energyPoints = 0;
         this.maxEnergyPoints = 0;
         this.actionPointsCurrent = 0;
         this.movementPointsCurrent = 0;
         this.initiative = new CharacterBaseCharacteristic();
         this.criticalMiss = new CharacterBaseCharacteristic();
         this.probationTime = 0;
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_CharacterCharacteristicsInformations(param1);
      }
      
      public function serializeAs_CharacterCharacteristicsInformations(param1:IDataOutput) : void
      {
         if(this.experience < 0)
         {
            throw new Error("Forbidden value (" + this.experience + ") on element experience.");
         }
         param1.writeDouble(this.experience);
         if(this.experienceLevelFloor < 0)
         {
            throw new Error("Forbidden value (" + this.experienceLevelFloor + ") on element experienceLevelFloor.");
         }
         param1.writeDouble(this.experienceLevelFloor);
         if(this.experienceNextLevelFloor < 0)
         {
            throw new Error("Forbidden value (" + this.experienceNextLevelFloor + ") on element experienceNextLevelFloor.");
         }
         param1.writeDouble(this.experienceNextLevelFloor);
         if(this.kamas < 0)
         {
            throw new Error("Forbidden value (" + this.kamas + ") on element kamas.");
         }
         param1.writeInt(this.kamas);
         if(this.statsPoints < 0)
         {
            throw new Error("Forbidden value (" + this.statsPoints + ") on element statsPoints.");
         }
         param1.writeInt(this.statsPoints);
         if(this.spellsPoints < 0)
         {
            throw new Error("Forbidden value (" + this.spellsPoints + ") on element spellsPoints.");
         }
         param1.writeInt(this.spellsPoints);
         this.alignmentInfos.serializeAs_ActorExtendedAlignmentInformations(param1);
         if(this.lifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.lifePoints + ") on element lifePoints.");
         }
         param1.writeInt(this.lifePoints);
         if(this.maxLifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.maxLifePoints + ") on element maxLifePoints.");
         }
         param1.writeInt(this.maxLifePoints);
         if(this.energyPoints < 0)
         {
            throw new Error("Forbidden value (" + this.energyPoints + ") on element energyPoints.");
         }
         param1.writeShort(this.energyPoints);
         if(this.maxEnergyPoints < 0)
         {
            throw new Error("Forbidden value (" + this.maxEnergyPoints + ") on element maxEnergyPoints.");
         }
         param1.writeShort(this.maxEnergyPoints);
         param1.writeShort(this.actionPointsCurrent);
         param1.writeShort(this.movementPointsCurrent);
         this.initiative.serializeAs_CharacterBaseCharacteristic(param1);
         this.prospecting.serializeAs_CharacterBaseCharacteristic(param1);
         this.actionPoints.serializeAs_CharacterBaseCharacteristic(param1);
         this.movementPoints.serializeAs_CharacterBaseCharacteristic(param1);
         this.strength.serializeAs_CharacterBaseCharacteristic(param1);
         this.vitality.serializeAs_CharacterBaseCharacteristic(param1);
         this.wisdom.serializeAs_CharacterBaseCharacteristic(param1);
         this.chance.serializeAs_CharacterBaseCharacteristic(param1);
         this.agility.serializeAs_CharacterBaseCharacteristic(param1);
         this.intelligence.serializeAs_CharacterBaseCharacteristic(param1);
         this.range.serializeAs_CharacterBaseCharacteristic(param1);
         this.summonableCreaturesBoost.serializeAs_CharacterBaseCharacteristic(param1);
         this.reflect.serializeAs_CharacterBaseCharacteristic(param1);
         this.criticalHit.serializeAs_CharacterBaseCharacteristic(param1);
         if(this.criticalHitWeapon < 0)
         {
            throw new Error("Forbidden value (" + this.criticalHitWeapon + ") on element criticalHitWeapon.");
         }
         param1.writeShort(this.criticalHitWeapon);
         this.criticalMiss.serializeAs_CharacterBaseCharacteristic(param1);
         this.healBonus.serializeAs_CharacterBaseCharacteristic(param1);
         this.allDamagesBonus.serializeAs_CharacterBaseCharacteristic(param1);
         this.weaponDamagesBonusPercent.serializeAs_CharacterBaseCharacteristic(param1);
         this.damagesBonusPercent.serializeAs_CharacterBaseCharacteristic(param1);
         this.trapBonus.serializeAs_CharacterBaseCharacteristic(param1);
         this.trapBonusPercent.serializeAs_CharacterBaseCharacteristic(param1);
         this.permanentDamagePercent.serializeAs_CharacterBaseCharacteristic(param1);
         this.tackleBlock.serializeAs_CharacterBaseCharacteristic(param1);
         this.tackleEvade.serializeAs_CharacterBaseCharacteristic(param1);
         this.PAAttack.serializeAs_CharacterBaseCharacteristic(param1);
         this.PMAttack.serializeAs_CharacterBaseCharacteristic(param1);
         this.pushDamageBonus.serializeAs_CharacterBaseCharacteristic(param1);
         this.criticalDamageBonus.serializeAs_CharacterBaseCharacteristic(param1);
         this.neutralDamageBonus.serializeAs_CharacterBaseCharacteristic(param1);
         this.earthDamageBonus.serializeAs_CharacterBaseCharacteristic(param1);
         this.waterDamageBonus.serializeAs_CharacterBaseCharacteristic(param1);
         this.airDamageBonus.serializeAs_CharacterBaseCharacteristic(param1);
         this.fireDamageBonus.serializeAs_CharacterBaseCharacteristic(param1);
         this.dodgePALostProbability.serializeAs_CharacterBaseCharacteristic(param1);
         this.dodgePMLostProbability.serializeAs_CharacterBaseCharacteristic(param1);
         this.neutralElementResistPercent.serializeAs_CharacterBaseCharacteristic(param1);
         this.earthElementResistPercent.serializeAs_CharacterBaseCharacteristic(param1);
         this.waterElementResistPercent.serializeAs_CharacterBaseCharacteristic(param1);
         this.airElementResistPercent.serializeAs_CharacterBaseCharacteristic(param1);
         this.fireElementResistPercent.serializeAs_CharacterBaseCharacteristic(param1);
         this.neutralElementReduction.serializeAs_CharacterBaseCharacteristic(param1);
         this.earthElementReduction.serializeAs_CharacterBaseCharacteristic(param1);
         this.waterElementReduction.serializeAs_CharacterBaseCharacteristic(param1);
         this.airElementReduction.serializeAs_CharacterBaseCharacteristic(param1);
         this.fireElementReduction.serializeAs_CharacterBaseCharacteristic(param1);
         this.pushDamageReduction.serializeAs_CharacterBaseCharacteristic(param1);
         this.criticalDamageReduction.serializeAs_CharacterBaseCharacteristic(param1);
         this.pvpNeutralElementResistPercent.serializeAs_CharacterBaseCharacteristic(param1);
         this.pvpEarthElementResistPercent.serializeAs_CharacterBaseCharacteristic(param1);
         this.pvpWaterElementResistPercent.serializeAs_CharacterBaseCharacteristic(param1);
         this.pvpAirElementResistPercent.serializeAs_CharacterBaseCharacteristic(param1);
         this.pvpFireElementResistPercent.serializeAs_CharacterBaseCharacteristic(param1);
         this.pvpNeutralElementReduction.serializeAs_CharacterBaseCharacteristic(param1);
         this.pvpEarthElementReduction.serializeAs_CharacterBaseCharacteristic(param1);
         this.pvpWaterElementReduction.serializeAs_CharacterBaseCharacteristic(param1);
         this.pvpAirElementReduction.serializeAs_CharacterBaseCharacteristic(param1);
         this.pvpFireElementReduction.serializeAs_CharacterBaseCharacteristic(param1);
         param1.writeShort(this.spellModifications.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.spellModifications.length)
         {
            (this.spellModifications[_loc2_] as CharacterSpellModification).serializeAs_CharacterSpellModification(param1);
            _loc2_++;
         }
         if(this.probationTime < 0)
         {
            throw new Error("Forbidden value (" + this.probationTime + ") on element probationTime.");
         }
         param1.writeInt(this.probationTime);
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_CharacterCharacteristicsInformations(param1);
      }
      
      public function deserializeAs_CharacterCharacteristicsInformations(param1:IDataInput) : void
      {
         var _loc4_:CharacterSpellModification = null;
         this.experience = param1.readDouble();
         if(this.experience < 0)
         {
            throw new Error("Forbidden value (" + this.experience + ") on element of CharacterCharacteristicsInformations.experience.");
         }
         this.experienceLevelFloor = param1.readDouble();
         if(this.experienceLevelFloor < 0)
         {
            throw new Error("Forbidden value (" + this.experienceLevelFloor + ") on element of CharacterCharacteristicsInformations.experienceLevelFloor.");
         }
         this.experienceNextLevelFloor = param1.readDouble();
         if(this.experienceNextLevelFloor < 0)
         {
            throw new Error("Forbidden value (" + this.experienceNextLevelFloor + ") on element of CharacterCharacteristicsInformations.experienceNextLevelFloor.");
         }
         this.kamas = param1.readInt();
         if(this.kamas < 0)
         {
            throw new Error("Forbidden value (" + this.kamas + ") on element of CharacterCharacteristicsInformations.kamas.");
         }
         this.statsPoints = param1.readInt();
         if(this.statsPoints < 0)
         {
            throw new Error("Forbidden value (" + this.statsPoints + ") on element of CharacterCharacteristicsInformations.statsPoints.");
         }
         this.spellsPoints = param1.readInt();
         if(this.spellsPoints < 0)
         {
            throw new Error("Forbidden value (" + this.spellsPoints + ") on element of CharacterCharacteristicsInformations.spellsPoints.");
         }
         this.alignmentInfos = new ActorExtendedAlignmentInformations();
         this.alignmentInfos.deserialize(param1);
         this.lifePoints = param1.readInt();
         if(this.lifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.lifePoints + ") on element of CharacterCharacteristicsInformations.lifePoints.");
         }
         this.maxLifePoints = param1.readInt();
         if(this.maxLifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.maxLifePoints + ") on element of CharacterCharacteristicsInformations.maxLifePoints.");
         }
         this.energyPoints = param1.readShort();
         if(this.energyPoints < 0)
         {
            throw new Error("Forbidden value (" + this.energyPoints + ") on element of CharacterCharacteristicsInformations.energyPoints.");
         }
         this.maxEnergyPoints = param1.readShort();
         if(this.maxEnergyPoints < 0)
         {
            throw new Error("Forbidden value (" + this.maxEnergyPoints + ") on element of CharacterCharacteristicsInformations.maxEnergyPoints.");
         }
         this.actionPointsCurrent = param1.readShort();
         this.movementPointsCurrent = param1.readShort();
         this.initiative = new CharacterBaseCharacteristic();
         this.initiative.deserialize(param1);
         this.prospecting = new CharacterBaseCharacteristic();
         this.prospecting.deserialize(param1);
         this.actionPoints = new CharacterBaseCharacteristic();
         this.actionPoints.deserialize(param1);
         this.movementPoints = new CharacterBaseCharacteristic();
         this.movementPoints.deserialize(param1);
         this.strength = new CharacterBaseCharacteristic();
         this.strength.deserialize(param1);
         this.vitality = new CharacterBaseCharacteristic();
         this.vitality.deserialize(param1);
         this.wisdom = new CharacterBaseCharacteristic();
         this.wisdom.deserialize(param1);
         this.chance = new CharacterBaseCharacteristic();
         this.chance.deserialize(param1);
         this.agility = new CharacterBaseCharacteristic();
         this.agility.deserialize(param1);
         this.intelligence = new CharacterBaseCharacteristic();
         this.intelligence.deserialize(param1);
         this.range = new CharacterBaseCharacteristic();
         this.range.deserialize(param1);
         this.summonableCreaturesBoost = new CharacterBaseCharacteristic();
         this.summonableCreaturesBoost.deserialize(param1);
         this.reflect = new CharacterBaseCharacteristic();
         this.reflect.deserialize(param1);
         this.criticalHit = new CharacterBaseCharacteristic();
         this.criticalHit.deserialize(param1);
         this.criticalHitWeapon = param1.readShort();
         if(this.criticalHitWeapon < 0)
         {
            throw new Error("Forbidden value (" + this.criticalHitWeapon + ") on element of CharacterCharacteristicsInformations.criticalHitWeapon.");
         }
         this.criticalMiss = new CharacterBaseCharacteristic();
         this.criticalMiss.deserialize(param1);
         this.healBonus = new CharacterBaseCharacteristic();
         this.healBonus.deserialize(param1);
         this.allDamagesBonus = new CharacterBaseCharacteristic();
         this.allDamagesBonus.deserialize(param1);
         this.weaponDamagesBonusPercent = new CharacterBaseCharacteristic();
         this.weaponDamagesBonusPercent.deserialize(param1);
         this.damagesBonusPercent = new CharacterBaseCharacteristic();
         this.damagesBonusPercent.deserialize(param1);
         this.trapBonus = new CharacterBaseCharacteristic();
         this.trapBonus.deserialize(param1);
         this.trapBonusPercent = new CharacterBaseCharacteristic();
         this.trapBonusPercent.deserialize(param1);
         this.permanentDamagePercent = new CharacterBaseCharacteristic();
         this.permanentDamagePercent.deserialize(param1);
         this.tackleBlock = new CharacterBaseCharacteristic();
         this.tackleBlock.deserialize(param1);
         this.tackleEvade = new CharacterBaseCharacteristic();
         this.tackleEvade.deserialize(param1);
         this.PAAttack = new CharacterBaseCharacteristic();
         this.PAAttack.deserialize(param1);
         this.PMAttack = new CharacterBaseCharacteristic();
         this.PMAttack.deserialize(param1);
         this.pushDamageBonus = new CharacterBaseCharacteristic();
         this.pushDamageBonus.deserialize(param1);
         this.criticalDamageBonus = new CharacterBaseCharacteristic();
         this.criticalDamageBonus.deserialize(param1);
         this.neutralDamageBonus = new CharacterBaseCharacteristic();
         this.neutralDamageBonus.deserialize(param1);
         this.earthDamageBonus = new CharacterBaseCharacteristic();
         this.earthDamageBonus.deserialize(param1);
         this.waterDamageBonus = new CharacterBaseCharacteristic();
         this.waterDamageBonus.deserialize(param1);
         this.airDamageBonus = new CharacterBaseCharacteristic();
         this.airDamageBonus.deserialize(param1);
         this.fireDamageBonus = new CharacterBaseCharacteristic();
         this.fireDamageBonus.deserialize(param1);
         this.dodgePALostProbability = new CharacterBaseCharacteristic();
         this.dodgePALostProbability.deserialize(param1);
         this.dodgePMLostProbability = new CharacterBaseCharacteristic();
         this.dodgePMLostProbability.deserialize(param1);
         this.neutralElementResistPercent = new CharacterBaseCharacteristic();
         this.neutralElementResistPercent.deserialize(param1);
         this.earthElementResistPercent = new CharacterBaseCharacteristic();
         this.earthElementResistPercent.deserialize(param1);
         this.waterElementResistPercent = new CharacterBaseCharacteristic();
         this.waterElementResistPercent.deserialize(param1);
         this.airElementResistPercent = new CharacterBaseCharacteristic();
         this.airElementResistPercent.deserialize(param1);
         this.fireElementResistPercent = new CharacterBaseCharacteristic();
         this.fireElementResistPercent.deserialize(param1);
         this.neutralElementReduction = new CharacterBaseCharacteristic();
         this.neutralElementReduction.deserialize(param1);
         this.earthElementReduction = new CharacterBaseCharacteristic();
         this.earthElementReduction.deserialize(param1);
         this.waterElementReduction = new CharacterBaseCharacteristic();
         this.waterElementReduction.deserialize(param1);
         this.airElementReduction = new CharacterBaseCharacteristic();
         this.airElementReduction.deserialize(param1);
         this.fireElementReduction = new CharacterBaseCharacteristic();
         this.fireElementReduction.deserialize(param1);
         this.pushDamageReduction = new CharacterBaseCharacteristic();
         this.pushDamageReduction.deserialize(param1);
         this.criticalDamageReduction = new CharacterBaseCharacteristic();
         this.criticalDamageReduction.deserialize(param1);
         this.pvpNeutralElementResistPercent = new CharacterBaseCharacteristic();
         this.pvpNeutralElementResistPercent.deserialize(param1);
         this.pvpEarthElementResistPercent = new CharacterBaseCharacteristic();
         this.pvpEarthElementResistPercent.deserialize(param1);
         this.pvpWaterElementResistPercent = new CharacterBaseCharacteristic();
         this.pvpWaterElementResistPercent.deserialize(param1);
         this.pvpAirElementResistPercent = new CharacterBaseCharacteristic();
         this.pvpAirElementResistPercent.deserialize(param1);
         this.pvpFireElementResistPercent = new CharacterBaseCharacteristic();
         this.pvpFireElementResistPercent.deserialize(param1);
         this.pvpNeutralElementReduction = new CharacterBaseCharacteristic();
         this.pvpNeutralElementReduction.deserialize(param1);
         this.pvpEarthElementReduction = new CharacterBaseCharacteristic();
         this.pvpEarthElementReduction.deserialize(param1);
         this.pvpWaterElementReduction = new CharacterBaseCharacteristic();
         this.pvpWaterElementReduction.deserialize(param1);
         this.pvpAirElementReduction = new CharacterBaseCharacteristic();
         this.pvpAirElementReduction.deserialize(param1);
         this.pvpFireElementReduction = new CharacterBaseCharacteristic();
         this.pvpFireElementReduction.deserialize(param1);
         var _loc2_:uint = uint(param1.readUnsignedShort());
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new CharacterSpellModification();
            _loc4_.deserialize(param1);
            this.spellModifications.push(_loc4_);
            _loc3_++;
         }
         this.probationTime = param1.readInt();
         if(this.probationTime < 0)
         {
            throw new Error("Forbidden value (" + this.probationTime + ") on element of CharacterCharacteristicsInformations.probationTime.");
         }
      }
   }
}

