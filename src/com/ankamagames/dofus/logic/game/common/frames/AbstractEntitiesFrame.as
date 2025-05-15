package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.items.Incarnation;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.mounts.MountBone;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.logic.game.common.actions.roleplay.SwitchCreatureModeAction;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.miscs.CarrierAnimationModifier;
   import com.ankamagames.dofus.logic.game.fight.miscs.CustomAnimStatiqueAnimationModifier;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.utils.LookCleaner;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMutantInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayHumanoidInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.types.entities.AnimStatiqueSubEntityBehavior;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.entities.BreedSkinModifier;
   import com.ankamagames.dofus.types.entities.RiderBehavior;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.errors.AbstractMethodCallError;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.types.IAnimationModifier;
   import com.ankamagames.tiphon.types.ISkinModifier;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class AbstractEntitiesFrame implements Frame
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AbstractEntitiesFrame));
      
      protected var _entities:Dictionary;
      
      protected var _creaturesMode:Boolean = false;
      
      protected var _creaturesLimit:int = -1;
      
      protected var _humanNumber:uint = 0;
      
      protected var _playerIsOnRide:Boolean = false;
      
      protected var _customAnimModifier:IAnimationModifier = new CustomAnimStatiqueAnimationModifier();
      
      protected var _skinModifier:ISkinModifier = new BreedSkinModifier();
      
      protected var _untargetableEntities:Boolean = false;
      
      protected var _interactiveElements:Vector.<InteractiveElement>;
      
      protected var _currentSubAreaId:uint;
      
      protected var _worldPoint:WorldPointWrapper;
      
      protected var _creaturesFightMode:Boolean = false;
      
      public function AbstractEntitiesFrame()
      {
         super();
      }
      
      public function get playerIsOnRide() : Boolean
      {
         return this._playerIsOnRide;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function set untargetableEntities(param1:Boolean) : void
      {
         var _loc2_:GameContextActorInformations = null;
         var _loc3_:AnimatedCharacter = null;
         this._untargetableEntities = param1;
         for each(_loc2_ in this._entities)
         {
            _loc3_ = DofusEntities.getEntity(_loc2_.contextualId) as AnimatedCharacter;
            if(_loc3_)
            {
               _loc3_.mouseEnabled = !param1;
            }
         }
      }
      
      public function get untargetableEntities() : Boolean
      {
         return this._untargetableEntities;
      }
      
      public function get interactiveElements() : Vector.<InteractiveElement>
      {
         return this._interactiveElements;
      }
      
      public function pushed() : Boolean
      {
         this._entities = new Dictionary();
         OptionManager.getOptionManager("atouin").addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onAtouinOptionChange);
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         throw new AbstractMethodCallError();
      }
      
      public function pulled() : Boolean
      {
         this._entities = null;
         Atouin.getInstance().clearEntities();
         OptionManager.getOptionManager("atouin").removeEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onAtouinOptionChange);
         return true;
      }
      
      public function getEntityInfos(param1:int) : GameContextActorInformations
      {
         if(!this._entities)
         {
            return null;
         }
         return this._entities[param1];
      }
      
      public function getEntitiesIdsList() : Vector.<int>
      {
         var _loc2_:GameContextActorInformations = null;
         var _loc1_:Vector.<int> = new Vector.<int>(0,false);
         for each(_loc2_ in this._entities)
         {
            _loc1_.push(_loc2_.contextualId);
         }
         return _loc1_;
      }
      
      public function getEntitiesDictionnary() : Dictionary
      {
         return this._entities;
      }
      
      public function registerActor(param1:GameContextActorInformations) : void
      {
         if(this._entities == null)
         {
            this._entities = new Dictionary();
         }
         this._entities[param1.contextualId] = param1;
      }
      
      public function addOrUpdateActor(param1:GameContextActorInformations, param2:IAnimationModifier = null) : AnimatedCharacter
      {
         var _loc5_:TiphonEntityLook = null;
         var _loc6_:TiphonEntityLook = null;
         var _loc7_:EntityLook = null;
         var _loc8_:EntityLook = null;
         var _loc9_:GameRolePlayHumanoidInformations = null;
         var _loc3_:AnimatedCharacter = DofusEntities.getEntity(param1.contextualId) as AnimatedCharacter;
         var _loc4_:Boolean = true;
         if(!(param1 is GameRolePlayNpcInformations) && param1 is GameRolePlayHumanoidInformations)
         {
            if(this._creaturesMode && this.isIncarnation(EntityLookAdapter.fromNetwork(param1.look).toString()))
            {
               _loc5_ = this.getFightPokemonLook(param1.look,false,false,true,false);
            }
            else
            {
               _loc5_ = this.getLook(param1.look);
            }
         }
         else if(this._creaturesMode && param1 is GameRolePlayMerchantInformations)
         {
            _loc5_ = this.getDealerPokemonLook(param1.look);
         }
         else if(this._creaturesMode && param1 is GameRolePlayTaxCollectorInformations)
         {
            _loc5_ = this.getPercoPokemonLook(param1.look);
         }
         else if(this._creaturesMode && param1 is GameRolePlayPrismInformations)
         {
            _loc6_ = EntityLookAdapter.fromNetwork(param1.look);
            _loc6_.setBone(2247);
            _loc6_.setScales(0.9,0.9);
            _loc5_ = _loc6_;
         }
         else if(this._creaturesFightMode && param1 is GameFightCharacterInformations)
         {
            _loc5_ = this.getLook(param1.look);
         }
         else if(this._creaturesFightMode && param1 is GameFightMonsterInformations)
         {
            _loc5_ = this.getFightPokemonLook(param1.look,true,(param1 as GameFightMonsterInformations).stats.summoned,false,false,(param1 as GameFightMonsterInformations).creatureGenericId == 3451);
         }
         else
         {
            _loc5_ = EntityLookAdapter.fromNetwork(param1.look);
         }
         if(param1.contextualId == PlayedCharacterManager.getInstance().id)
         {
            if(this._creaturesMode || this._creaturesFightMode)
            {
               _loc7_ = EntityLookAdapter.toNetwork(_loc5_);
               if(PlayedCharacterManager.getInstance().infos.entityLook.bonesId != _loc7_.bonesId)
               {
                  PlayedCharacterManager.getInstance().realEntityLook = PlayedCharacterManager.getInstance().infos.entityLook;
               }
            }
         }
         if(_loc3_ == null)
         {
            _loc3_ = new AnimatedCharacter(param1.contextualId,_loc5_);
            _loc3_.addEventListener(TiphonEvent.PLAYANIM_EVENT,this.onPlayAnim);
            if(OptionManager.getOptionManager("atouin").useLowDefSkin)
            {
               _loc3_.setAlternativeSkinIndex(0,true);
            }
            if(_loc5_.getBone() == 1)
            {
               if(param2)
               {
                  _loc3_.addAnimationModifier(param2);
               }
               else
               {
                  _loc3_.addAnimationModifier(this._customAnimModifier);
               }
            }
            _loc3_.skinModifier = this._skinModifier;
            if(param1.contextualId == PlayedCharacterManager.getInstance().id)
            {
               _loc8_ = EntityLookAdapter.toNetwork(_loc5_);
               if(PlayedCharacterManager.getInstance().infos.entityLook != _loc8_)
               {
                  PlayedCharacterManager.getInstance().infos.entityLook = _loc8_;
                  KernelEventsManager.getInstance().processCallback(HookList.PlayedCharacterLookChange,_loc5_);
               }
            }
         }
         else
         {
            _loc4_ = false;
            if(this._humanNumber > 0)
            {
               --this._humanNumber;
            }
            if(this._creaturesMode && param1 is GameRolePlayMerchantInformations)
            {
               _loc3_.look.updateFrom(_loc5_);
            }
            else
            {
               this.updateActorLook(param1.contextualId,param1.look,true);
            }
         }
         if(param1 is GameRolePlayHumanoidInformations)
         {
            _loc9_ = param1 as GameRolePlayHumanoidInformations;
            if(param1.contextualId == PlayedCharacterManager.getInstance().id)
            {
               PlayedCharacterManager.getInstance().restrictions = _loc9_.humanoidInfo.restrictions;
            }
         }
         if(!this._creaturesFightMode && !this._creaturesMode && _loc3_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER) && Boolean(_loc3_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER).length))
         {
            _loc3_.setSubEntityBehaviour(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,new RiderBehavior());
         }
         if(_loc3_.id == PlayedCharacterManager.getInstance().infos.id)
         {
            if(Boolean(_loc3_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER)) && Boolean(_loc3_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER).length))
            {
               this._playerIsOnRide = true;
            }
            else
            {
               this._playerIsOnRide = false;
            }
         }
         if(!this._creaturesFightMode && !this._creaturesMode && _loc3_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET) && Boolean(_loc3_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET).length))
         {
            _loc3_.setSubEntityBehaviour(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET,new AnimStatiqueSubEntityBehavior());
         }
         if(param1.disposition.cellId != -1)
         {
            _loc3_.position = MapPoint.fromCellId(param1.disposition.cellId);
         }
         if(_loc4_)
         {
            _loc3_.setDirection(param1.disposition.direction);
            _loc3_.display(PlacementStrataEnums.STRATA_PLAYER);
         }
         this.registerActor(param1);
         if(PlayedCharacterManager.getInstance().id == _loc3_.id)
         {
            SoundManager.getInstance().manager.setSoundSourcePosition(_loc3_.id,new Point(_loc3_.x,_loc3_.y));
         }
         _loc3_.mouseEnabled = !this.untargetableEntities;
         return _loc3_;
      }
      
      protected function updateActorLook(param1:int, param2:EntityLook, param3:Boolean = false) : void
      {
         var _loc5_:TiphonEntityLook = null;
         var _loc6_:GameContextActorInformations = null;
         var _loc7_:int = 0;
         var _loc8_:SerialSequencer = null;
         var _loc9_:AddGfxEntityStep = null;
         var _loc10_:Monster = null;
         var _loc11_:TiphonSprite = null;
         if(this._entities[param1])
         {
            _loc6_ = this._entities[param1] as GameContextActorInformations;
            _loc7_ = int(_loc6_.look.bonesId);
            _loc6_.look = param2;
            if(param3 && param2.bonesId != _loc7_)
            {
               _loc8_ = new SerialSequencer();
               _loc9_ = new AddGfxEntityStep(1165,DofusEntities.getEntity(param1).position.cellId);
               _loc8_.addStep(_loc9_);
               _loc8_.start();
            }
         }
         else
         {
            _log.warn("Cannot update unknown actor look (" + param1 + ") in informations.");
         }
         var _loc4_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         if(_loc4_)
         {
            _loc4_.addEventListener(TiphonEvent.RENDER_FAILED,this.onUpdateEntityFail,false,0,false);
            _loc4_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onUpdateEntitySuccess,false,0,false);
            if(param2.bonesId != 1)
            {
               _loc4_.removeAnimationModifier(this._customAnimModifier);
            }
            else
            {
               _loc4_.addAnimationModifier(this._customAnimModifier);
            }
            if(!this._creaturesFightMode && !(this._entities[param1] is GameRolePlayNpcInformations) && (this._entities[param1] is GameRolePlayHumanoidInformations || this._entities[param1] as GameFightCharacterInformations))
            {
               if(this.isIncarnation(EntityLookAdapter.fromNetwork(param2).toString()) && this._creaturesMode)
               {
                  _loc5_ = this.getFightPokemonLook(param2,false,false,true,false);
               }
               else
               {
                  _loc5_ = this.getLook(param2,param1);
               }
            }
            else if(this._creaturesFightMode && _loc6_ is GameFightTaxCollectorInformations)
            {
               _loc5_ = this.getPercoPokemonLook(param2);
            }
            else if(this._entities[param1] is GameFightMonsterInformations && this._creaturesFightMode)
            {
               if((this._entities[param1] as GameFightMonsterInformations).stats.summoned)
               {
                  _loc5_ = this.getFightPokemonLook(param2,true,true,false,false);
               }
               else
               {
                  _loc10_ = Monster.getMonsterById((this._entities[param1] as GameFightMonsterInformations).creatureGenericId);
                  _loc5_ = this.getFightPokemonLook(param2,true,false,false,_loc10_ == null ? false : _loc10_.isBoss,(this._entities[param1] as GameFightMonsterInformations).creatureGenericId == 3451);
               }
            }
            else if(this._creaturesFightMode && this._entities[param1] is GameFightCharacterInformations)
            {
               _loc11_ = TiphonUtility.getEntityWithoutMount(_loc4_) as TiphonSprite;
               if(_loc11_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_LIFTED_ENTITY,0))
               {
                  _loc11_.removeAnimationModifierByClass(CarrierAnimationModifier);
               }
               if((this._entities[param1] as GameFightCharacterInformations).stats.summoned)
               {
                  _loc5_ = this.getFightPokemonLook(param2,false,true,false,false);
               }
               else if(this.isIncarnation(EntityLookAdapter.fromNetwork(param2).toString()))
               {
                  _loc5_ = this.getFightPokemonLook(param2,false,false,true,false);
               }
               else
               {
                  _loc5_ = this.getLook(param2,param1);
               }
            }
            else if(this._creaturesFightMode && this._entities[param1] is GameFightMutantInformations)
            {
               _loc5_ = this.getFightPokemonLook(param2,true);
            }
            else
            {
               _loc5_ = EntityLookAdapter.fromNetwork(param2);
            }
            _loc4_.enableSubCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,!this._creaturesFightMode);
            _loc4_.look.updateFrom(_loc5_);
            if(this._creaturesMode || this._creaturesFightMode)
            {
               _loc4_.setAnimation(AnimationEnum.ANIM_STATIQUE);
            }
            else
            {
               _loc4_.setAnimation(_loc4_.getAnimation());
            }
            if(Boolean(_loc4_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET)) && Boolean(_loc4_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET).length))
            {
               _loc4_.setSubEntityBehaviour(1,new AnimStatiqueSubEntityBehavior());
            }
         }
         else
         {
            _log.warn("Cannot update unknown actor look (" + param1 + ") in the game world.");
         }
         if(param1 == PlayedCharacterManager.getInstance().id && Boolean(_loc5_))
         {
            if(this._creaturesMode || this._creaturesFightMode)
            {
               if(PlayedCharacterManager.getInstance().infos.entityLook.bonesId != param2.bonesId)
               {
                  PlayedCharacterManager.getInstance().realEntityLook = PlayedCharacterManager.getInstance().infos.entityLook;
               }
            }
            PlayedCharacterManager.getInstance().infos.entityLook = param2;
            KernelEventsManager.getInstance().processCallback(HookList.PlayedCharacterLookChange,LookCleaner.clean(_loc5_));
         }
      }
      
      protected function updateActorDisposition(param1:int, param2:EntityDispositionInformations) : void
      {
         if(this._entities[param1])
         {
            (this._entities[param1] as GameContextActorInformations).disposition = param2;
         }
         else
         {
            _log.warn("Cannot update unknown actor disposition (" + param1 + ") in informations.");
         }
         var _loc3_:IEntity = DofusEntities.getEntity(param1);
         if(_loc3_)
         {
            if(_loc3_ is IMovable && param2.cellId >= 0)
            {
               if(_loc3_ is TiphonSprite && (_loc3_ as TiphonSprite).rootEntity && (_loc3_ as TiphonSprite).rootEntity != _loc3_)
               {
                  _log.debug("PAS DE SYNCHRO pour " + (_loc3_ as TiphonSprite).name + " car entité portée");
               }
               else
               {
                  IMovable(_loc3_).jump(MapPoint.fromCellId(param2.cellId));
               }
            }
            if(_loc3_ is IAnimated)
            {
               IAnimated(_loc3_).setDirection(param2.direction);
            }
         }
         else
         {
            _log.warn("Cannot update unknown actor disposition (" + param1 + ") in the game world.");
         }
      }
      
      protected function updateActorOrientation(param1:int, param2:uint) : void
      {
         if(this._entities[param1])
         {
            (this._entities[param1] as GameContextActorInformations).disposition.direction = param2;
         }
         else
         {
            _log.warn("Cannot update unknown actor orientation (" + param1 + ") in informations.");
         }
         var _loc3_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         if(_loc3_)
         {
            if(param1 == PlayedCharacterManager.getInstance().id && param2 != DirectionsEnum.DOWN && _loc3_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_BASE_FOREGROUND,0) && Boolean(OptionManager.getOptionManager("tiphon").aura))
            {
               _loc3_.look.removeSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_BASE_FOREGROUND);
            }
            _loc3_.setDirection(param2);
         }
         else
         {
            _log.warn("Cannot update unknown actor orientation (" + param1 + ") in the game world.");
         }
      }
      
      protected function hideActor(param1:int) : void
      {
         var _loc2_:IDisplayable = DofusEntities.getEntity(param1) as IDisplayable;
         if(_loc2_)
         {
            _loc2_.remove();
         }
         else
         {
            _log.warn("Cannot remove an unknown actor (" + param1 + ").");
         }
      }
      
      protected function removeActor(param1:int) : void
      {
         this.hideActor(param1);
         var _loc2_:TiphonSprite = DofusEntities.getEntity(param1) as TiphonSprite;
         if(_loc2_)
         {
            _loc2_.destroy();
         }
         this.updateCreaturesLimit();
         if(this._humanNumber > 0)
         {
            --this._humanNumber;
         }
         delete this._entities[param1];
         if(this.switchPokemonMode())
         {
            _log.debug("switch pokemon/normal mode");
         }
      }
      
      protected function switchPokemonMode() : Boolean
      {
         var _loc1_:SwitchCreatureModeAction = null;
         if(this._creaturesLimit > -1 && this._creaturesMode != (!Kernel.getWorker().getFrame(FightEntitiesFrame) && this._creaturesLimit < 50 && this._humanNumber >= this._creaturesLimit))
         {
            _log.debug("human number: " + this._humanNumber + ", creature limit: " + this._creaturesLimit + " => " + this._creaturesMode);
            _loc1_ = SwitchCreatureModeAction.create(!this._creaturesMode);
            Kernel.getWorker().process(_loc1_);
            return true;
         }
         return false;
      }
      
      protected function getLook(param1:EntityLook, param2:int = -1) : TiphonEntityLook
      {
         var _loc5_:TiphonEntityLook = null;
         var _loc6_:uint = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc3_:TiphonEntityLook = EntityLookAdapter.fromNetwork(param1);
         var _loc4_:TiphonEntityLook = _loc3_;
         if(this._creaturesMode || this._creaturesFightMode)
         {
            _loc6_ = 0;
            _loc7_ = MountBone.getMountBonesIds();
            if(this.isBoneCorrect(_loc3_.getBone()))
            {
               if(param2 != -1 && Boolean(this._entities[param2].hasOwnProperty("breed")))
               {
                  _loc6_ = uint(this._entities[param2].breed);
               }
               else
               {
                  _loc6_ = uint(Breed.getBreedFromSkin(_loc3_.firstSkin).id);
               }
            }
            else if(_loc7_.indexOf(_loc3_.getBone()) != -1)
            {
               _loc5_ = TiphonUtility.getLookWithoutMount(_loc3_);
               if(_loc5_ != _loc3_)
               {
                  if(this.isBoneCorrect(_loc5_.getBone()))
                  {
                     if(param2 != -1 && Boolean(this._entities[param2].hasOwnProperty("breed")))
                     {
                        _loc6_ = uint(this._entities[param2].breed);
                     }
                     else
                     {
                        _loc6_ = uint(Breed.getBreedFromSkin(_loc5_.firstSkin).id);
                     }
                  }
               }
            }
            if(_loc6_ == 0)
            {
               if(!(param2 != -1 && Boolean(this._entities[param2].hasOwnProperty("breed"))))
               {
                  _loc8_ = !!_loc5_ ? int(_loc5_.getBone()) : int(_loc3_.getBone());
                  switch(_loc8_)
                  {
                     case 453:
                        _loc6_ = 12;
                        break;
                     case 706:
                     case 1504:
                     case 1509:
                        return this.getFightPokemonLook(param1,false,false,true,false);
                     case 923:
                  }
                  return !!_loc5_ ? _loc5_ : _loc3_;
               }
               _loc6_ = uint(this._entities[param2].breed);
            }
            _loc4_.setBone(Breed.getBreedById(_loc6_).creatureBonesId);
            _loc4_.setScales(0.9,0.9);
         }
         else if(!OptionManager.getOptionManager("tiphon").aura)
         {
            _loc4_.removeSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_BASE_FOREGROUND);
         }
         return _loc4_;
      }
      
      private function isBoneCorrect(param1:int) : Boolean
      {
         if(param1 == 1 || param1 == 113 || param1 == 44 || param1 == 1575 || param1 == 1576)
         {
            return true;
         }
         return false;
      }
      
      protected function getFightPokemonLook(param1:EntityLook, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false) : TiphonEntityLook
      {
         var _loc9_:int = 0;
         var _loc7_:TiphonEntityLook;
         var _loc8_:TiphonEntityLook = _loc7_ = EntityLookAdapter.fromNetwork(param1);
         switch(param2)
         {
            case true:
               if(param3)
               {
                  _loc9_ = 1765;
                  break;
               }
               if(param5)
               {
                  _loc9_ = 1748;
                  break;
               }
               _loc9_ = 1747;
               break;
            case false:
               if(param3)
               {
                  _loc9_ = 1765;
                  break;
               }
               if(param4)
               {
                  _loc9_ = 1749;
                  break;
               }
               _loc9_ = int(_loc7_.getBone());
               break;
         }
         if(param6)
         {
            _loc9_ = 2247;
         }
         _loc8_.setBone(_loc9_);
         _loc8_.setScales(0.9,0.9);
         return _loc8_;
      }
      
      private function getPercoPokemonLook(param1:EntityLook) : TiphonEntityLook
      {
         var _loc2_:TiphonEntityLook = EntityLookAdapter.fromNetwork(param1);
         _loc2_.setBone(1813);
         _loc2_.setScales(0.9,0.9);
         return _loc2_;
      }
      
      private function getDealerPokemonLook(param1:EntityLook) : TiphonEntityLook
      {
         var _loc2_:TiphonEntityLook = EntityLookAdapter.fromNetwork(param1);
         _loc2_.setBone(1965);
         _loc2_.setScales(0.9,0.9);
         return _loc2_;
      }
      
      protected function updateCreaturesLimit() : void
      {
         var _loc1_:Number = NaN;
         this._creaturesLimit = OptionManager.getOptionManager("tiphon").creaturesMode;
         if(this._creaturesMode && this._creaturesLimit > 0)
         {
            _loc1_ = this._creaturesLimit * 20 / 100;
            this._creaturesLimit = Math.ceil(this._creaturesLimit - _loc1_);
         }
      }
      
      public function onPlayAnim(param1:TiphonEvent) : void
      {
         var _loc2_:Array = new Array();
         var _loc3_:String = param1.params.substring(6,param1.params.length - 1);
         _loc2_ = _loc3_.split(",");
         param1.sprite.setAnimation(_loc2_[int(_loc2_.length * Math.random())]);
      }
      
      private function onAtouinOptionChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         if(param1.propertyName == "useLowDefSkin")
         {
            _loc2_ = EntitiesManager.getInstance().entities;
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_ is TiphonSprite)
               {
                  TiphonSprite(_loc3_).setAlternativeSkinIndex(!!param1.propertyValue ? 0 : -1,true);
               }
            }
         }
      }
      
      public function isInCreaturesFightMode() : Boolean
      {
         return this._creaturesFightMode;
      }
      
      private function onUpdateEntitySuccess(param1:TiphonEvent) : void
      {
         param1.sprite.removeEventListener(TiphonEvent.RENDER_FAILED,this.onUpdateEntityFail);
         param1.sprite.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onUpdateEntitySuccess);
      }
      
      private function onUpdateEntityFail(param1:TiphonEvent) : void
      {
         param1.sprite.removeEventListener(TiphonEvent.RENDER_FAILED,this.onUpdateEntityFail);
         param1.sprite.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onUpdateEntitySuccess);
         TiphonSprite(param1.sprite).setAnimation("AnimStatique");
      }
      
      private function isIncarnation(param1:String) : Boolean
      {
         var _loc3_:Incarnation = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:Array = Incarnation.getAllIncarnation();
         var _loc4_:String = param1.slice(1,param1.indexOf("|"));
         for each(_loc3_ in _loc2_)
         {
            _loc5_ = _loc3_.lookMale.slice(1,_loc3_.lookMale.indexOf("|"));
            _loc6_ = _loc3_.lookFemale.slice(1,_loc3_.lookFemale.indexOf("|"));
            if(_loc4_ == _loc5_ || _loc4_ == _loc6_)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.propertyName == "mapCoordinates")
         {
            KernelEventsManager.getInstance().processCallback(HookList.MapComplementaryInformationsData,this._worldPoint,this._currentSubAreaId,param1.propertyValue);
         }
      }
   }
}

