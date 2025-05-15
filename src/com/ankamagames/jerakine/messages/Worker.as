package com.ankamagames.jerakine.messages
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.pools.GenericPool;
   import com.ankamagames.jerakine.pools.Poolable;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManager;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.FrameIdManager;
   import com.ankamagames.jerakine.utils.misc.PriorityComparer;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class Worker implements MessageHandler
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Worker));
      
      private static const DEBUG_FRAMES:Boolean = true;
      
      private static const DEBUG_MESSAGES:Boolean = true;
      
      private static const MAX_MESSAGES_PER_FRAME:uint = 100;
      
      private static const MAX_TIME_FRAME:uint = 40;
      
      private var _messagesQueue:Vector.<Message>;
      
      private var _framesList:Vector.<Frame>;
      
      private var _processingMessage:Boolean;
      
      private var _framesToAdd:Vector.<Frame>;
      
      private var _framesToRemove:Vector.<Frame>;
      
      private var _paused:Boolean;
      
      private var _pauseFilter:Class;
      
      private var _pausedQueue:Vector.<Message>;
      
      private var _framesBeingDeleted:Dictionary = new Dictionary(true);
      
      private var _currentFrameTypesCache:Dictionary;
      
      public function Worker()
      {
         super();
      }
      
      public function get framesList() : Vector.<Frame>
      {
         return this._framesList;
      }
      
      public function get isPaused() : Boolean
      {
         return this._paused;
      }
      
      public function get pausedQueue() : Vector.<Message>
      {
         return this._pausedQueue;
      }
      
      public function process(param1:Message) : Boolean
      {
         this._messagesQueue.push(param1);
         this.run();
         return true;
      }
      
      public function addFrame(param1:Frame, param2:Boolean = false) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Frame = null;
         var _loc6_:Frame = null;
         if(this._currentFrameTypesCache[param1["constructor"]])
         {
            _loc3_ = false;
            _loc4_ = false;
            if(this._processingMessage)
            {
               for each(_loc5_ in this._framesToAdd)
               {
                  if(_loc5_["constructor"] == param1["constructor"])
                  {
                     _loc4_ = true;
                     break;
                  }
               }
               if(!_loc4_)
               {
                  for each(_loc6_ in this._framesToRemove)
                  {
                     if(_loc6_["constructor"] == param1["constructor"])
                     {
                        _loc3_ = true;
                        break;
                     }
                  }
               }
            }
            if(!_loc3_ || _loc4_)
            {
               _log.error("Someone asked for the frame " + param1 + " to be " + "added to the worker, but there is already another " + "frame of the same type within it.");
               if(!param2)
               {
                  return;
               }
            }
         }
         if(!param1)
         {
            return;
         }
         if(DEBUG_FRAMES)
         {
            _log.info("Adding frame: " + param1);
         }
         if(this._processingMessage)
         {
            this._framesToAdd.push(param1);
         }
         else
         {
            this.pushFrame(param1);
         }
      }
      
      public function removeFrame(param1:Frame) : void
      {
         if(!param1)
         {
            return;
         }
         if(DEBUG_FRAMES)
         {
            _log.info("Removing frame: " + param1);
         }
         if(this._processingMessage)
         {
            this._framesToRemove.push(param1);
         }
         else if(!this.isBeingDeleted(param1))
         {
            this._framesBeingDeleted[param1] = true;
            this.pullFrame(param1);
         }
      }
      
      private function isBeingDeleted(param1:Frame) : Boolean
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this._framesBeingDeleted)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function contains(param1:Class) : Boolean
      {
         return this.getFrame(param1) != null;
      }
      
      public function getFrame(param1:Class) : Frame
      {
         return this._currentFrameTypesCache[param1];
      }
      
      public function pause(param1:Class = null) : void
      {
         _log.info("Worker is paused, all queueable messages will be queued.");
         this._paused = true;
         this._pauseFilter = param1;
      }
      
      public function resume() : void
      {
         if(!this._paused)
         {
            return;
         }
         _log.info("Worker is resuming, processing all queued messages.");
         this._paused = false;
         this._messagesQueue = this._messagesQueue.concat(this._pausedQueue);
         this._pausedQueue = new Vector.<Message>();
         this.processFramesInAndOut();
         this.processMessages();
      }
      
      public function clear() : void
      {
         var _loc1_:Frame = null;
         if(DEBUG_FRAMES)
         {
            _log.info("Clearing worker (no more frames or messages in queue)");
         }
         for each(_loc1_ in this._framesList)
         {
            _loc1_.pulled();
         }
         this._framesList = new Vector.<Frame>();
         this._framesToAdd = new Vector.<Frame>();
         this._framesToRemove = new Vector.<Frame>();
         this._messagesQueue = new Vector.<Message>();
         this._pausedQueue = new Vector.<Message>();
         this._currentFrameTypesCache = new Dictionary();
         EnterFrameDispatcher.removeEventListener(this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         FpsManager.getInstance().startTracking("DofusFrame",16549650);
         this.processMessages();
         FpsManager.getInstance().stopTracking("DofusFrame");
      }
      
      private function run() : void
      {
         if(EnterFrameDispatcher.hasEventListener(this.onEnterFrame))
         {
            return;
         }
         EnterFrameDispatcher.addEventListener(this.onEnterFrame,"Worker");
      }
      
      private function pushFrame(param1:Frame) : void
      {
         if(param1.pushed())
         {
            this._framesList.push(param1);
            this._framesList.sort(PriorityComparer.compare);
            this._currentFrameTypesCache[param1["constructor"]] = param1;
         }
         else
         {
            _log.warn("Frame " + param1 + " refused to be pushed.");
         }
      }
      
      private function pullFrame(param1:Frame) : void
      {
         var _loc2_:int = 0;
         if(param1.pulled())
         {
            _loc2_ = int(this._framesList.indexOf(param1));
            if(_loc2_ > -1)
            {
               this._framesList.splice(_loc2_,1);
               delete this._currentFrameTypesCache[param1["constructor"]];
               delete this._framesBeingDeleted[param1];
            }
         }
         else
         {
            _log.warn("Frame " + param1 + " refused to be pulled.");
         }
      }
      
      private function processMessages() : void
      {
         var _loc3_:Message = null;
         var _loc1_:uint = 0;
         var _loc2_:uint = uint(getTimer());
         while(_loc1_ < MAX_MESSAGES_PER_FRAME && this._messagesQueue.length > 0 && getTimer() - _loc2_ < MAX_TIME_FRAME)
         {
            _loc3_ = this._messagesQueue.shift();
            if(!(_loc3_ is CancelableMessage && CancelableMessage(_loc3_).cancel))
            {
               if(this._paused && _loc3_ is QueueableMessage)
               {
                  this._pausedQueue.push(_loc3_);
                  _log.warn("Queued message: " + _loc3_);
               }
               else
               {
                  this.processMessage(_loc3_);
                  if(_loc3_ is Poolable)
                  {
                     GenericPool.free(_loc3_ as Poolable);
                  }
                  this.processFramesInAndOut();
                  _loc1_++;
               }
            }
         }
         if(this._messagesQueue.length == 0)
         {
            EnterFrameDispatcher.removeEventListener(this.onEnterFrame);
         }
      }
      
      private function processMessage(param1:Message) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Frame = null;
         this._processingMessage = true;
         for each(_loc3_ in this._framesList)
         {
            if(_loc3_.process(param1))
            {
               _loc2_ = true;
               break;
            }
         }
         this._processingMessage = false;
         if(!_loc2_ && !(param1 is DiscardableMessage) && getQualifiedClassName(param1).indexOf("MapContainer") == -1)
         {
            _log.warn("Discarded message: " + param1 + " (at frame " + FrameIdManager.frameId + ")");
         }
      }
      
      private function processFramesInAndOut() : void
      {
         var _loc1_:Frame = null;
         var _loc2_:Frame = null;
         if(this._framesToRemove.length > 0)
         {
            for each(_loc1_ in this._framesToRemove)
            {
               this.pullFrame(_loc1_);
            }
            this._framesToRemove.splice(0,this._framesToRemove.length);
         }
         if(this._framesToAdd.length > 0)
         {
            for each(_loc2_ in this._framesToAdd)
            {
               this.pushFrame(_loc2_);
            }
            this._framesToAdd.splice(0,this._framesToAdd.length);
         }
      }
   }
}

