package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.datacenter.jobs.Job;
   import com.ankamagames.dofus.datacenter.jobs.Recipe;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJob;
   import com.ankamagames.dofus.internalDatacenter.jobs.RecipeWithSkill;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.JobsFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.misc.utils.GameDataQuery;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobDescription;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobExperience;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElementSkill;
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescription;
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescriptionCollect;
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescriptionCraft;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class JobsApi implements IApi
   {
      protected var _log:Logger = Log.getLogger(getQualifiedClassName(JobsApi));
      
      private var _module:UiModule;
      
      public function JobsApi()
      {
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      private function get jobsFrame() : JobsFrame
      {
         return Kernel.getWorker().getFrame(JobsFrame) as JobsFrame;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function getKnownJobs() : Array
      {
         var _loc3_:KnownJob = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(!PlayedCharacterManager.getInstance().jobs)
         {
            return null;
         }
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         for each(_loc3_ in PlayedCharacterManager.getInstance().jobs)
         {
            if(_loc3_ != null)
            {
               _loc1_[_loc3_.jobPosition] = Job.getJobById(_loc3_.jobDescription.jobId);
            }
         }
         _loc4_ = 0;
         _loc5_ = 0;
         while(_loc5_ < 6)
         {
            if(Boolean(_loc1_[_loc5_]) && _loc1_[_loc5_].specializationOfId == 0)
            {
               _loc2_.push(_loc1_[_loc5_]);
            }
            _loc5_++;
         }
         var _loc6_:uint = 0;
         while(_loc6_ < 6)
         {
            if(Boolean(_loc1_[_loc6_]) && _loc1_[_loc6_].specializationOfId > 0)
            {
               _loc2_[3 + _loc4_] = _loc1_[_loc6_];
               _loc4_++;
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function getJobSkills(param1:Job) : Array
      {
         var _loc5_:SkillActionDescription = null;
         var _loc2_:JobDescription = this.getJobDescription(param1.id);
         if(!_loc2_)
         {
            return null;
         }
         var _loc3_:Array = new Array(_loc2_.skills.length);
         var _loc4_:uint = 0;
         for each(_loc5_ in _loc2_.skills)
         {
            var _loc8_:*;
            _loc3_[_loc8_ = _loc4_++] = Skill.getSkillById(_loc5_.skillId);
         }
         return _loc3_;
      }
      
      [Untrusted]
      public function getJobSkillType(param1:Job, param2:Skill) : String
      {
         var _loc3_:JobDescription = this.getJobDescription(param1.id);
         if(!_loc3_)
         {
            return "unknown";
         }
         var _loc4_:SkillActionDescription = this.getSkillActionDescription(_loc3_,param2.id);
         if(!_loc4_)
         {
            return "unknown";
         }
         switch(true)
         {
            case _loc4_ is SkillActionDescriptionCollect:
               return "collect";
            case _loc4_ is SkillActionDescriptionCraft:
               return "craft";
            default:
               this._log.warn("Unknown SkillActionDescription type : " + _loc4_);
               return "unknown";
         }
      }
      
      [Untrusted]
      public function getJobCollectSkillInfos(param1:Job, param2:Skill) : Object
      {
         var _loc3_:JobDescription = this.getJobDescription(param1.id);
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:SkillActionDescription = this.getSkillActionDescription(_loc3_,param2.id);
         if(!_loc4_)
         {
            return null;
         }
         if(!(_loc4_ is SkillActionDescriptionCollect))
         {
            return null;
         }
         var _loc5_:SkillActionDescriptionCollect = _loc4_ as SkillActionDescriptionCollect;
         var _loc6_:Object = new Object();
         _loc6_.time = _loc5_.time / 10;
         _loc6_.minResources = _loc5_.min;
         _loc6_.maxResources = _loc5_.max;
         _loc6_.resourceItem = Item.getItemById(param2.gatheredRessourceItem);
         return _loc6_;
      }
      
      [Untrusted]
      public function getMaxSlotsByJobId(param1:int) : int
      {
         var _loc4_:SkillActionDescription = null;
         var _loc5_:SkillActionDescriptionCraft = null;
         var _loc2_:JobDescription = this.getJobDescription(param1);
         var _loc3_:int = 0;
         if(!_loc2_)
         {
            return 0;
         }
         for each(_loc4_ in _loc2_.skills)
         {
            if(_loc4_ is SkillActionDescriptionCraft)
            {
               _loc5_ = _loc4_ as SkillActionDescriptionCraft;
               if(_loc5_.maxSlots > _loc3_)
               {
                  _loc3_ = int(_loc5_.maxSlots);
               }
            }
         }
         return _loc3_;
      }
      
      [Untrusted]
      public function getJobCraftSkillInfos(param1:Job, param2:Skill) : Object
      {
         var _loc3_:JobDescription = this.getJobDescription(param1.id);
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:SkillActionDescription = this.getSkillActionDescription(_loc3_,param2.id);
         if(!_loc4_)
         {
            return null;
         }
         if(!(_loc4_ is SkillActionDescriptionCraft))
         {
            return null;
         }
         var _loc5_:SkillActionDescriptionCraft = _loc4_ as SkillActionDescriptionCraft;
         var _loc6_:Object = new Object();
         _loc6_.maxSlots = _loc5_.maxSlots;
         _loc6_.probability = _loc5_.probability;
         if(param2.modifiableItemType > -1)
         {
            _loc6_.modifiableItemType = ItemType.getItemTypeById(param2.modifiableItemType);
         }
         return _loc6_;
      }
      
      [Untrusted]
      public function getJobExperience(param1:Job) : Object
      {
         var _loc2_:JobExperience = this.getJobExp(param1.id);
         if(!_loc2_)
         {
            return null;
         }
         var _loc3_:Object = new Object();
         _loc3_.currentLevel = _loc2_.jobLevel;
         _loc3_.currentExperience = _loc2_.jobXP;
         _loc3_.levelExperienceFloor = _loc2_.jobXpLevelFloor;
         _loc3_.levelExperienceCeil = _loc2_.jobXpNextLevelFloor;
         return _loc3_;
      }
      
      [Untrusted]
      public function getSkillFromId(param1:int) : Object
      {
         return Skill.getSkillById(param1);
      }
      
      [Untrusted]
      public function getJobRecipes(param1:Job, param2:Array = null, param3:Skill = null, param4:String = null) : Array
      {
         var _loc8_:SkillActionDescription = null;
         var _loc9_:Vector.<uint> = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:uint = 0;
         var _loc13_:Vector.<int> = null;
         var _loc14_:int = 0;
         var _loc15_:Recipe = null;
         var _loc16_:uint = 0;
         var _loc17_:Boolean = false;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         var _loc20_:ItemWrapper = null;
         var _loc5_:JobDescription = this.getJobDescription(param1.id);
         if(!_loc5_)
         {
            return null;
         }
         if(param4)
         {
            param4 = param4.toLowerCase();
         }
         var _loc6_:Dictionary = new Dictionary(true);
         var _loc7_:Array = new Array();
         if(param2)
         {
            param2.sort(Array.NUMERIC);
         }
         for each(_loc8_ in _loc5_.skills)
         {
            if(!(Boolean(param3) && _loc8_.skillId != param3.id))
            {
               _loc13_ = Skill.getSkillById(_loc8_.skillId).craftableItemIds;
               for each(_loc14_ in _loc13_)
               {
                  _loc15_ = Recipe.getRecipeByResultId(_loc14_);
                  if(_loc15_)
                  {
                     _loc16_ = _loc15_.ingredientIds.length;
                     _loc17_ = false;
                     if(param2)
                     {
                        _loc18_ = 0;
                        while(_loc18_ < param2.length)
                        {
                           _loc19_ = uint(param2[_loc18_]);
                           if(_loc19_ == _loc16_)
                           {
                              _loc17_ = true;
                           }
                           else if(_loc19_ > _loc16_)
                           {
                              break;
                           }
                           _loc18_++;
                        }
                     }
                     else
                     {
                        _loc17_ = true;
                     }
                     if(_loc17_)
                     {
                        if(param4)
                        {
                           if(StringUtils.noAccent(Item.getItemById(_loc14_).name).toLowerCase().indexOf(StringUtils.noAccent(param4)) != -1)
                           {
                              _loc6_[_loc15_.resultId] = new RecipeWithSkill(_loc15_,Skill.getSkillById(_loc8_.skillId));
                           }
                           else
                           {
                              for each(_loc20_ in _loc15_.ingredients)
                              {
                                 if(StringUtils.noAccent(_loc20_.name).toLowerCase().indexOf(StringUtils.noAccent(param4)) != -1)
                                 {
                                    _loc6_[_loc15_.resultId] = new RecipeWithSkill(_loc15_,Skill.getSkillById(_loc8_.skillId));
                                 }
                              }
                           }
                        }
                        else
                        {
                           _loc6_[_loc15_.resultId] = new RecipeWithSkill(_loc15_,Skill.getSkillById(_loc8_.skillId));
                        }
                     }
                  }
               }
            }
         }
         _loc9_ = new Vector.<uint>();
         for each(_loc11_ in _loc6_)
         {
            if(_loc11_)
            {
               _loc9_.push(_loc11_.recipe.resultId);
            }
         }
         _loc10_ = GameDataQuery.sort(Item,_loc9_,["recipeSlots","level","name"],[false,false,true]);
         for each(_loc12_ in _loc10_)
         {
            _loc7_.push(_loc6_[_loc12_]);
         }
         return _loc7_;
      }
      
      [Untrusted]
      public function getRecipe(param1:uint) : Recipe
      {
         return Recipe.getRecipeByResultId(param1);
      }
      
      [Untrusted]
      public function getRecipesList(param1:uint) : Array
      {
         var _loc2_:Array = Item.getItemById(param1).recipes;
         if(_loc2_)
         {
            return _loc2_;
         }
         return new Array();
      }
      
      [Untrusted]
      public function getJobName(param1:uint) : String
      {
         return Job.getJobById(param1).name;
      }
      
      [Untrusted]
      public function getJob(param1:uint) : Object
      {
         return Job.getJobById(param1);
      }
      
      [Untrusted]
      public function getJobCrafterDirectorySettingsById(param1:uint) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.jobsFrame.settings)
         {
            if(Boolean(_loc2_) && param1 == _loc2_.jobId)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      [Untrusted]
      public function getJobCrafterDirectorySettingsByIndex(param1:uint) : Object
      {
         return this.jobsFrame.settings[param1];
      }
      
      [Untrusted]
      public function getUsableSkillsInMap(param1:int) : Array
      {
         var _loc6_:Boolean = false;
         var _loc7_:uint = 0;
         var _loc8_:InteractiveElement = null;
         var _loc9_:InteractiveElementSkill = null;
         var _loc10_:InteractiveElementSkill = null;
         var _loc2_:Array = new Array();
         var _loc3_:RoleplayContextFrame = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
         var _loc4_:Vector.<InteractiveElement> = _loc3_.entitiesFrame.interactiveElements;
         var _loc5_:Vector.<uint> = _loc3_.getMultiCraftSkills(param1);
         for each(_loc7_ in _loc5_)
         {
            _loc6_ = false;
            for each(_loc8_ in _loc4_)
            {
               for each(_loc9_ in _loc8_.enabledSkills)
               {
                  if(_loc7_ == _loc9_.skillId && _loc2_.indexOf(_loc9_.skillId) == -1)
                  {
                     _loc6_ = true;
                     break;
                  }
               }
               for each(_loc10_ in _loc8_.disabledSkills)
               {
                  if(_loc7_ == _loc10_.skillId && _loc2_.indexOf(_loc10_.skillId) == -1)
                  {
                     _loc6_ = true;
                     break;
                  }
               }
               if(_loc6_)
               {
                  break;
               }
            }
            if(_loc6_)
            {
               _loc2_.push(Skill.getSkillById(_loc7_));
            }
         }
         return _loc2_;
      }
      
      [Trusted]
      public function getKnownJob(param1:uint) : KnownJob
      {
         if(!PlayedCharacterManager.getInstance().jobs)
         {
            return null;
         }
         var _loc2_:KnownJob = PlayedCharacterManager.getInstance().jobs[param1] as KnownJob;
         if(!_loc2_)
         {
            return null;
         }
         return _loc2_;
      }
      
      private function getJobDescription(param1:uint) : JobDescription
      {
         var _loc2_:KnownJob = this.getKnownJob(param1);
         if(!_loc2_)
         {
            return null;
         }
         return _loc2_.jobDescription;
      }
      
      private function getJobExp(param1:uint) : JobExperience
      {
         var _loc2_:KnownJob = this.getKnownJob(param1);
         if(!_loc2_)
         {
            return null;
         }
         return _loc2_.jobExperience;
      }
      
      private function getSkillActionDescription(param1:JobDescription, param2:uint) : SkillActionDescription
      {
         var _loc3_:SkillActionDescription = null;
         for each(_loc3_ in param1.skills)
         {
            if(_loc3_.skillId == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}

