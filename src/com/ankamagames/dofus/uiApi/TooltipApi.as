package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.factories.TooltipsFactory;
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.interfaces.ITooltipMaker;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.ChunkData;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.types.tooltip.Tooltip;
   import com.ankamagames.berilia.types.tooltip.TooltipBlock;
   import com.ankamagames.berilia.types.tooltip.TooltipPlacer;
   import com.ankamagames.berilia.types.tooltip.TooltipRectangle;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.logic.game.common.frames.PlayedCharacterUpdatesFrame;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.modules.utils.SpellTooltipSettings;
   import com.ankamagames.dofus.types.data.ItemTooltipInfo;
   import com.ankamagames.dofus.types.data.SpellTooltipInfo;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.misc.CheckCompatibility;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class TooltipApi implements IApi
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(TooltipApi));
      
      private var _module:UiModule;
      
      private var _currentUi:UiRootContainer;
      
      public function TooltipApi()
      {
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [ApiData(name="currentUi")]
      public function set currentUi(param1:UiRootContainer) : void
      {
         this._currentUi = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
         this._currentUi = null;
      }
      
      [Untrusted]
      public function setDefaultTooltipUiScript(param1:String, param2:String) : void
      {
         var _loc3_:UiModule = UiModuleManager.getInstance().getModule(param1);
         if(!_loc3_)
         {
            throw new ApiError("Module " + param1 + " doesn\'t exist");
         }
         var _loc4_:UiData = _loc3_.getUi(param2);
         if(!_loc4_)
         {
            throw new ApiError("UI " + param2 + " doesn\'t exist in module " + param1);
         }
         TooltipManager.defaultTooltipUiScript = _loc4_.uiClass;
      }
      
      [NoBoxing]
      [Untrusted]
      public function createTooltip(param1:String, param2:String, param3:String = null) : Tooltip
      {
         var _loc4_:Tooltip = null;
         if(param1.substr(-4,4) != ".txt")
         {
            throw new ApiError("ChunkData support only [.txt] file, found " + param1);
         }
         if(param2.substr(-4,4) != ".txt")
         {
            throw new ApiError("ChunkData support only [.txt] file, found " + param2);
         }
         if(param3)
         {
            if(param3.substr(-4,4) != ".txt")
            {
               throw new ApiError("ChunkData support only [.txt] file, found " + param3);
            }
            _loc4_ = new Tooltip(new Uri(this._module.rootPath + "/" + param1),new Uri(this._module.rootPath + "/" + param2),new Uri(this._module.rootPath + "/" + param3));
         }
         else
         {
            _loc4_ = new Tooltip(new Uri(this._module.rootPath + "/" + param1),new Uri(this._module.rootPath + "/" + param2));
         }
         return _loc4_;
      }
      
      [NoBoxing]
      [Untrusted]
      public function createTooltipBlock(param1:Function, param2:Function) : TooltipBlock
      {
         var _loc3_:TooltipBlock = new TooltipBlock();
         _loc3_.onAllChunkLoadedCallback = param1;
         _loc3_.contentGetter = param2;
         return _loc3_;
      }
      
      [Untrusted]
      public function registerTooltipAssoc(param1:*, param2:String) : void
      {
         TooltipsFactory.registerAssoc(param1,param2);
      }
      
      [Untrusted]
      public function registerTooltipMaker(param1:String, param2:Class, param3:Class = null) : void
      {
         if(CheckCompatibility.isCompatible(ITooltipMaker,param2))
         {
            TooltipsFactory.registerMaker(param1,param2,param3);
            return;
         }
         throw new ApiError(param1 + " maker class is not compatible with ITooltipMaker");
      }
      
      [NoBoxing]
      [Untrusted]
      public function createChunkData(param1:String, param2:String) : ChunkData
      {
         var _loc3_:Uri = new Uri(this._module.rootPath + "/" + param2);
         if(_loc3_.fileType.toLowerCase() != "txt")
         {
            throw new ApiError("ChunkData support only [.txt] file, found " + param2);
         }
         return new ChunkData(param1,_loc3_);
      }
      
      [Untrusted]
      public function place(param1:*, param2:uint = 6, param3:uint = 0, param4:int = 3) : void
      {
         if(param1 && CheckCompatibility.isCompatible(IRectangle,param1))
         {
            TooltipPlacer.place(this._currentUi,param1,param2,param3,param4);
         }
      }
      
      [Untrusted]
      public function placeArrow(param1:*) : Object
      {
         if(param1 && CheckCompatibility.isCompatible(IRectangle,param1))
         {
            return TooltipPlacer.placeWithArrow(this._currentUi,param1);
         }
         return null;
      }
      
      [Untrusted]
      public function getSpellTooltipInfo(param1:SpellWrapper, param2:String = null) : Object
      {
         return new SpellTooltipInfo(param1,param2);
      }
      
      [Untrusted]
      public function getItemTooltipInfo(param1:ItemWrapper, param2:String = null) : Object
      {
         return new ItemTooltipInfo(param1,param2);
      }
      
      [Untrusted]
      public function getSpellTooltipCache() : int
      {
         return PlayedCharacterUpdatesFrame.SPELL_TOOLTIP_CACHE_NUM;
      }
      
      [Untrusted]
      public function resetSpellTooltipCache() : void
      {
         ++PlayedCharacterUpdatesFrame.SPELL_TOOLTIP_CACHE_NUM;
      }
      
      [NoBoxing]
      [Untrusted]
      public function createTooltipRectangle(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0) : TooltipRectangle
      {
         return new TooltipRectangle(param1,param2,param3,param4);
      }
      
      [Trusted]
      public function createSpellSettings() : SpellTooltipSettings
      {
         return new SpellTooltipSettings();
      }
      
      [Trusted]
      public function createItemSettings() : ItemTooltipSettings
      {
         return new ItemTooltipSettings();
      }
   }
}

