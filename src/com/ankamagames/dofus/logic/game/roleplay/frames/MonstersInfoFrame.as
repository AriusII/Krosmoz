package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.messages.EntityMovementCompleteMessage;
   import com.ankamagames.atouin.messages.EntityMovementStartMessage;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import com.ankamagames.berilia.types.event.UiUnloadEvent;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRemoveElementMessage;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class MonstersInfoFrame implements Frame
   {
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(MonstersInfoFrame));
      
      private var _sysApi:SystemApi = new SystemApi();
      
      private var _roleplayEntitiesFrame:RoleplayEntitiesFrame;
      
      private var _tooltipsCacheNames:Dictionary = new Dictionary();
      
      private var _movingGroups:Vector.<int> = new Vector.<int>();
      
      private var _checkMovingGroups:Boolean;
      
      public function MonstersInfoFrame()
      {
         super();
      }
      
      public function pushed() : Boolean
      {
         this._roleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         if(Boolean(this._roleplayEntitiesFrame) && this._roleplayEntitiesFrame.monstersIds.length > 0)
         {
            this.update();
         }
         this._checkMovingGroups = true;
         EnterFrameDispatcher.addEventListener(this.updateTooltipPos,"MonstersInfo",StageShareManager.stage.frameRate);
         Berilia.getInstance().addEventListener(UiRenderEvent.UIRenderComplete,this.onLoadUi);
         Berilia.getInstance().addEventListener(UiUnloadEvent.UNLOAD_UI_COMPLETE,this.onUnLoadUi);
         return true;
      }
      
      public function pulled() : Boolean
      {
         var _loc1_:int = 0;
         for each(_loc1_ in this._tooltipsCacheNames)
         {
            delete this._tooltipsCacheNames[_loc1_];
         }
         this.removeTooltips();
         this._movingGroups.length = 0;
         EnterFrameDispatcher.removeEventListener(this.updateTooltipPos);
         Berilia.getInstance().removeEventListener(UiRenderEvent.UIRenderComplete,this.onLoadUi);
         Berilia.getInstance().removeEventListener(UiUnloadEvent.UNLOAD_UI_COMPLETE,this.onUnLoadUi);
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:AnimatedCharacter = null;
         var _loc3_:EntityMouseOverMessage = null;
         var _loc4_:EntityMouseOutMessage = null;
         var _loc5_:GameContextRemoveElementMessage = null;
         var _loc6_:EntityMovementStartMessage = null;
         var _loc7_:EntityMovementCompleteMessage = null;
         var _loc8_:int = 0;
         switch(true)
         {
            case param1 is EntityMouseOverMessage:
               _loc3_ = param1 as EntityMouseOverMessage;
               _loc2_ = _loc3_.entity as AnimatedCharacter;
               if(_loc2_)
               {
                  _loc2_ = _loc2_.getRootEntity();
                  if(this._tooltipsCacheNames[_loc2_.id])
                  {
                     TooltipManager.hide("MonstersInfo_" + _loc2_.id);
                  }
               }
               break;
            case param1 is EntityMouseOutMessage:
               _loc4_ = param1 as EntityMouseOutMessage;
               _loc2_ = _loc4_.entity as AnimatedCharacter;
               if(_loc2_)
               {
                  _loc2_ = _loc2_.getRootEntity();
                  if(this._tooltipsCacheNames[_loc2_.id])
                  {
                     this.showToolTip(_loc2_.id);
                  }
               }
               break;
            case param1 is GameContextRemoveElementMessage:
               _loc5_ = param1 as GameContextRemoveElementMessage;
               delete this._tooltipsCacheNames[_loc5_.id];
               TooltipManager.hide("MonstersInfo_" + _loc5_.id);
               break;
            case param1 is EntityMovementStartMessage:
               _loc6_ = param1 as EntityMovementStartMessage;
               _loc2_ = EntitiesManager.getInstance().getEntity(_loc6_.id) as AnimatedCharacter;
               if(_loc2_ == _loc2_.getRootEntity())
               {
                  if(Boolean(this._tooltipsCacheNames[_loc2_.id]) && this._movingGroups.indexOf(_loc2_.id) == -1)
                  {
                     this._movingGroups.push(_loc2_.id);
                  }
               }
               break;
            case param1 is EntityMovementCompleteMessage:
               _loc7_ = param1 as EntityMovementCompleteMessage;
               _loc2_ = EntitiesManager.getInstance().getEntity(_loc7_.id) as AnimatedCharacter;
               if(_loc2_ == _loc2_.getRootEntity())
               {
                  _loc8_ = int(this._movingGroups.indexOf(_loc2_.id));
                  if(Boolean(this._tooltipsCacheNames[_loc2_.id]) && _loc8_ != -1)
                  {
                     this._movingGroups.splice(_loc8_,1);
                  }
                  break;
               }
         }
         return false;
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
      
      public function update() : void
      {
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         var _loc2_:int = int(this._roleplayEntitiesFrame.monstersIds.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this._roleplayEntitiesFrame.monstersIds[_loc1_];
            if(!TooltipManager.isVisible("MonstersInfo_" + _loc3_))
            {
               this.showToolTip(_loc3_,"MonstersInfoCache" + _loc1_);
            }
            _loc1_++;
         }
      }
      
      private function onLoadUi(param1:UiRenderEvent) : void
      {
         if(!Atouin.getInstance().worldIsVisible)
         {
            EnterFrameDispatcher.removeEventListener(this.updateTooltipPos);
            this._checkMovingGroups = false;
         }
      }
      
      private function onUnLoadUi(param1:UiUnloadEvent) : void
      {
         this.update();
         if(!this._checkMovingGroups)
         {
            this._checkMovingGroups = true;
            EnterFrameDispatcher.addEventListener(this.updateTooltipPos,"MonstersInfo",StageShareManager.stage.frameRate);
         }
      }
      
      private function onEntityAnimationRendered(param1:TiphonEvent) : void
      {
         var _loc2_:AnimatedCharacter = param1.currentTarget as AnimatedCharacter;
         _loc2_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityAnimationRendered);
         this.showToolTip(_loc2_.id,this._tooltipsCacheNames[_loc2_.id]);
      }
      
      private function updateTooltipPos(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this._movingGroups.length > 0)
         {
            for each(_loc2_ in this._movingGroups)
            {
               this.showToolTip(_loc2_);
            }
         }
      }
      
      private function removeTooltips(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         if(Boolean(this._roleplayEntitiesFrame) && this._roleplayEntitiesFrame.monstersIds.length > 0)
         {
            for each(_loc2_ in this._roleplayEntitiesFrame.monstersIds)
            {
               if(param1)
               {
                  delete this._tooltipsCacheNames[_loc2_];
               }
               TooltipManager.hide("MonstersInfo_" + _loc2_);
            }
         }
      }
      
      private function showToolTip(param1:int, param2:String = null) : void
      {
         var _loc4_:AnimatedCharacter = null;
         var _loc3_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         if(_loc3_)
         {
            if(_loc3_.isMoving && this._movingGroups.indexOf(_loc3_.id) == -1)
            {
               this._movingGroups.push(_loc3_.id);
            }
            if(param2)
            {
               this._tooltipsCacheNames[_loc3_.id] = param2;
            }
            _loc4_ = _loc3_ as AnimatedCharacter;
            if(!_loc4_.rawAnimation)
            {
               _loc4_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityAnimationRendered);
            }
            else
            {
               TooltipManager.show(this._roleplayEntitiesFrame.getEntityInfos(_loc3_.id) as GameRolePlayGroupMonsterInformations,_loc3_.absoluteBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"MonstersInfo_" + _loc3_.id,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,null,null,this._tooltipsCacheNames[_loc3_.id],false,StrataEnum.STRATA_WORLD,this._sysApi.getCurrentZoom());
            }
         }
      }
   }
}

