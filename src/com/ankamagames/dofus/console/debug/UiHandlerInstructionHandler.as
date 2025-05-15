package com.ankamagames.dofus.console.debug
{
   import avmplus.getQualifiedClassName;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.BeriliaConstants;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.managers.UiRenderManager;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.utils.ModuleScriptAnalyzer;
   import com.ankamagames.dofus.console.moduleLogger.Console;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.utils.UiInspector;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   
   public class UiHandlerInstructionHandler implements ConsoleInstructionHandler
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(UiHandlerInstructionHandler));
      
      private var _uiInspector:UiInspector;
      
      public function UiHandlerInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var _loc4_:UiModule = null;
         var _loc5_:* = null;
         var _loc6_:Array = null;
         var _loc7_:UiModule = null;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:UiRootContainer = null;
         var _loc11_:GraphicContainer = null;
         var _loc12_:uint = 0;
         var _loc13_:Array = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:ModuleScriptAnalyzer = null;
         switch(param2)
         {
            case "loadui":
               break;
            case "unloadui":
               if(param3.length == 0)
               {
                  _loc12_ = 0;
                  _loc13_ = [];
                  for(_loc14_ in Berilia.getInstance().uiList)
                  {
                     if(Berilia.getInstance().uiList[_loc14_].name != "Console")
                     {
                        _loc13_.push(Berilia.getInstance().uiList[_loc14_].name);
                     }
                  }
                  for each(_loc14_ in _loc13_)
                  {
                     Berilia.getInstance().unloadUi(_loc14_);
                  }
                  param1.output(_loc13_.length + " UI were unload");
                  break;
               }
               if(Berilia.getInstance().unloadUi(param3[0]))
               {
                  param1.output("RIP " + param3[0]);
                  break;
               }
               param1.output(param3[0] + " does not exist or an error occured while unloading UI");
               break;
            case "clearuicache":
               UiRenderManager.getInstance().clearCache();
               break;
            case "setuiscale":
               Berilia.getInstance().scale = Number(param3[0]);
               break;
            case "useuicache":
               StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_UI_DEFINITION,"useCache",param3[0] == "true");
               BeriliaConstants.USE_UI_CACHE = param3[0] == "true";
               break;
            case "uilist":
               for(_loc15_ in Berilia.getInstance().uiList)
               {
                  param1.output(" - " + _loc15_);
               }
               break;
            case "reloadui":
               UiModuleManager.getInstance().loadModule(param3[0]);
               break;
            case "fps":
               Dofus.getInstance().toggleFPS();
               break;
            case "modulelist":
               _loc5_ = "Enable module :";
               _loc6_ = UiModuleManager.getInstance().getModules();
               for each(_loc4_ in _loc6_)
               {
                  _loc5_ += "\n - " + _loc4_.id;
               }
               _loc6_ = UiModuleManager.getInstance().disabledModule;
               if(_loc6_.length)
               {
                  _loc5_ += "\n\nDisable module :";
                  for each(_loc4_ in _loc6_)
                  {
                     _loc5_ += "\n - " + _loc4_.id;
                  }
               }
               param1.output(_loc5_);
               break;
            case "getmoduleinfo":
               _loc7_ = UiModuleManager.getInstance().getModule(param3[0]);
               if(_loc7_)
               {
                  _loc16_ = new ModuleScriptAnalyzer(_loc7_,null);
                  break;
               }
               param1.output("Module " + param3[0] + " does not exists");
               break;
            case "chatoutput":
               _loc8_ = !param3.length || String(param3[0]).toLowerCase() == "true" || String(param3[0]).toLowerCase() == "on";
               Console.getInstance().display();
               Console.getInstance().disableLogEvent();
               KernelEventsManager.getInstance().processCallback(ChatHookList.ToggleChatLog,_loc8_);
               _loc9_ = Boolean(OptionManager.getOptionManager("chat")["chatoutput"]);
               OptionManager.getOptionManager("chat")["chatoutput"] = _loc8_;
               if(_loc8_)
               {
                  param1.output("Chatoutput is on.");
                  break;
               }
               param1.output("Chatoutput is off.");
               break;
            case "uiinspector":
               if(!this._uiInspector)
               {
                  this._uiInspector = new UiInspector();
               }
               this._uiInspector.enable = !this._uiInspector.enable;
               if(this._uiInspector.enable)
               {
                  param1.output("UI Inspector is ON.\n Use Ctrl-C to save the last hovered element informations.");
                  break;
               }
               param1.output("UI Inspector is OFF.");
               break;
            case "inspectuielementsos":
            case "inspectuielement":
               if(param3.length == 0)
               {
                  param1.output(param2 + " need at least one argument (" + param2 + " uiName [uiElementName])");
                  break;
               }
               _loc10_ = Berilia.getInstance().getUi(param3[0]);
               if(!_loc10_)
               {
                  param1.output("UI " + param3[0] + " not found (use /uilist to grab current displayed UI list)");
                  break;
               }
               if(param3.length == 1)
               {
                  this.inspectUiElement(_loc10_,param2 == "inspectuielementsos" ? null : param1);
                  break;
               }
               _loc11_ = _loc10_.getElement(param3[1]);
               if(!_loc11_)
               {
                  param1.output("UI Element " + param3[0] + " not found on UI " + param3[0] + "(use /uiinspector to view elements names)");
                  break;
               }
               this.inspectUiElement(_loc11_,param2 == "inspectuielementsos" ? null : param1);
               break;
         }
      }
      
      private function inspectUiElement(param1:GraphicContainer, param2:ConsoleHandler) : void
      {
         var txt:String = null;
         var property:String = null;
         var type:String = null;
         var target:GraphicContainer = param1;
         var console:ConsoleHandler = param2;
         var properties:Array = DescribeTypeCache.getVariables(target).concat();
         properties.sort();
         for each(property in properties)
         {
            try
            {
               type = target[property] != null ? getQualifiedClassName(target[property]).split("::").pop() : "?";
               if(type == "Array")
               {
                  type += ", len: " + target[property].length;
               }
               txt = property + " (" + type + ") : " + target[property];
            }
            catch(e:Error)
            {
               txt = property + " (?) : <Exception throw by getter>";
            }
            if(!console)
            {
               _log.info(txt);
            }
            else
            {
               console.output(txt);
            }
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "loadui":
               return "Load an UI. Usage: loadUi <uiId> <uiInstanceName>(optional)";
            case "unloadui":
               return "Unload UI with the given UI instance name.";
            case "clearuicache":
               return "Clear all UI in cache (will force xml parsing).";
            case "setuiscale":
               return "Set scale for all scalable UI. Usage: setUiScale <Number> (100% = 1.0)";
            case "useuicache":
               return "Enable UI caching";
            case "uilist":
               return "Get current UI list";
            case "reloadui":
               return "Unload and reload an Ui";
            case "fps":
               return "Toggle FPS";
            case "chatoutput":
               return "Display the chat content in a separated window.";
            case "modulelist":
               return "Display activated modules.";
            case "uiinspector":
               return "Display a tooltip over each interactive UI element";
            case "inspectuielement":
               return "Display the property list of an UI element (UI or Component), usage /inspectuielement uiName (elementName)";
            case "inspectuielementsos":
               return "Display the property list of an UI element (UI or Component) to SOS, usage /inspectuielement uiName (elementName)";
            default:
               return "No help for command \'" + param1 + "\'";
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         var _loc5_:String = null;
         var _loc4_:Array = [];
         switch(param1)
         {
            case "unloadui":
               if(param2 == 0)
               {
                  for(_loc5_ in Berilia.getInstance().uiList)
                  {
                     _loc4_.push(Berilia.getInstance().uiList[_loc5_].name);
                  }
                  break;
               }
         }
         return _loc4_;
      }
   }
}

