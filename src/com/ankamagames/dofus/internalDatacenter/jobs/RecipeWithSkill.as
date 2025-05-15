package com.ankamagames.dofus.internalDatacenter.jobs
{
   import com.ankamagames.dofus.datacenter.jobs.Recipe;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class RecipeWithSkill implements IDataCenter
   {
      private var _recipe:Recipe;
      
      private var _skill:Skill;
      
      public function RecipeWithSkill(param1:Recipe, param2:Skill)
      {
         super();
         this._recipe = param1;
         this._skill = param2;
      }
      
      public function get recipe() : Recipe
      {
         return this._recipe;
      }
      
      public function get skill() : Skill
      {
         return this._skill;
      }
   }
}

