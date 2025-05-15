package com.ankamagames.dofus.datacenter.jobs
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.jobs.RecipeWithSkill;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class Recipe implements IDataCenter
   {
      public static const MODULE:String = "Recipes";
      
      public var resultId:int;
      
      public var resultLevel:uint;
      
      public var ingredientIds:Vector.<int>;
      
      public var quantities:Vector.<uint>;
      
      private var _result:ItemWrapper;
      
      private var _ingredients:Vector.<ItemWrapper>;
      
      public function Recipe()
      {
         super();
      }
      
      public static function getRecipeByResultId(param1:int) : Recipe
      {
         return GameData.getObject(MODULE,param1) as Recipe;
      }
      
      public static function getAllRecipesForSkillId(param1:uint, param2:uint) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:Recipe = null;
         var _loc7_:uint = 0;
         var _loc3_:Array = new Array();
         var _loc4_:Vector.<int> = Skill.getSkillById(param1).craftableItemIds;
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = getRecipeByResultId(_loc5_);
            if(_loc6_)
            {
               _loc7_ = _loc6_.ingredientIds.length;
               if(_loc7_ <= param2)
               {
                  _loc3_.push(new RecipeWithSkill(_loc6_,Skill.getSkillById(param1)));
               }
            }
         }
         return _loc3_.sort(skillSortFunction);
      }
      
      private static function skillSortFunction(param1:RecipeWithSkill, param2:RecipeWithSkill) : Number
      {
         if(param1.recipe.quantities.length > param2.recipe.quantities.length)
         {
            return -1;
         }
         if(param1.recipe.quantities.length == param2.recipe.quantities.length)
         {
            return 0;
         }
         return 1;
      }
      
      public function get result() : ItemWrapper
      {
         if(!this._result)
         {
            this._result = ItemWrapper.create(0,0,this.resultId,0,null,false);
         }
         return this._result;
      }
      
      public function get ingredients() : Vector.<ItemWrapper>
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(!this._ingredients)
         {
            _loc1_ = this.ingredientIds.length;
            this._ingredients = new Vector.<ItemWrapper>(_loc1_,true);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               this._ingredients[_loc2_] = ItemWrapper.create(0,0,this.ingredientIds[_loc2_],this.quantities[_loc2_],null,false);
               _loc2_++;
            }
         }
         return this._ingredients;
      }
   }
}

