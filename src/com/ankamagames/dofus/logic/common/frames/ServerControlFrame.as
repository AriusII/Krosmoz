package com.ankamagames.dofus.logic.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.misc.OptionalFeature;
   import com.ankamagames.dofus.datacenter.misc.Url;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.shield.SecureModeManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.messages.game.script.URLOpenMessage;
   import com.ankamagames.dofus.network.messages.secure.TrustStatusMessage;
   import com.ankamagames.dofus.network.messages.security.RawDataMessage;
   import com.ankamagames.dofusModuleLibrary.enum.WebLocationEnum;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.display.Loader;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.getQualifiedClassName;
   
   public class ServerControlFrame implements Frame
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ServerControlFrame));
      
      public function ServerControlFrame()
      {
         super();
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:RawDataMessage = null;
         var _loc3_:Loader = null;
         var _loc4_:LoaderContext = null;
         var _loc5_:URLOpenMessage = null;
         var _loc6_:Url = null;
         var _loc7_:TrustStatusMessage = null;
         var _loc8_:URLRequest = null;
         var _loc9_:MiscFrame = null;
         var _loc10_:OptionalFeature = null;
         switch(true)
         {
            case param1 is RawDataMessage:
               _loc2_ = param1 as RawDataMessage;
               _loc3_ = new Loader();
               _loc4_ = new LoaderContext(false,ApplicationDomain.currentDomain);
               AirScanner.allowByteCodeExecution(_loc4_,true);
               _loc3_.loadBytes(_loc2_.content,_loc4_);
               return true;
            case param1 is URLOpenMessage:
               _loc5_ = param1 as URLOpenMessage;
               _loc6_ = Url.getUrlById(_loc5_.urlId);
               switch(_loc6_.browserId)
               {
                  case 1:
                     _loc8_ = new URLRequest(_loc6_.url);
                     _loc8_.method = _loc6_.method == "" ? "GET" : _loc6_.method.toUpperCase();
                     _loc8_.data = _loc6_.variables;
                     navigateToURL(_loc8_);
                     return true;
                  case 2:
                     KernelEventsManager.getInstance().processCallback(HookList.OpenWebPortal,WebLocationEnum.WEB_LOCATION_OGRINE);
                     return true;
                  case 3:
                     return true;
                  case 4:
                     if(HookList[_loc6_.url])
                     {
                        _loc9_ = Kernel.getWorker().getFrame(MiscFrame) as MiscFrame;
                        _loc10_ = OptionalFeature.getOptionalFeatureByKeyword("game.krosmasterGameInClient");
                        if(_loc9_ && _loc10_ && !_loc9_.isOptionalFeatureActive(_loc10_.id) && HookList.OpenKrosmaster == HookList[_loc6_.url])
                        {
                           _log.error("Tentative de lancement de Krosmaster, cependant la feature n\'est pas active");
                           return true;
                        }
                        KernelEventsManager.getInstance().processCallback(HookList[_loc6_.url]);
                     }
                     return true;
                  default:
                     return true;
               }
               break;
            case param1 is TrustStatusMessage:
               _loc7_ = param1 as TrustStatusMessage;
               SecureModeManager.getInstance().active = !_loc7_.trusted;
               return true;
            default:
               return false;
         }
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
   }
}

