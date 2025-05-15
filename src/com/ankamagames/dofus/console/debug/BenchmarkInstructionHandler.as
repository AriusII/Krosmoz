package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.frames.DebugBotFrame;
   import com.ankamagames.dofus.logic.common.frames.FightBotFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.managers.TacticModeManager;
   import com.ankamagames.dofus.logic.game.roleplay.managers.AnimFunManager;
   import com.ankamagames.dofus.misc.BenchmarkMovementBehavior;
   import com.ankamagames.dofus.types.entities.BenchmarkCharacter;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManager;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.engine.TiphonDebugManager;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.utils.getQualifiedClassName;
   
   public class BenchmarkInstructionHandler implements ConsoleInstructionHandler
   {
      private static var id:uint = 50000;
      
      protected var _log:Logger = Log.getLogger(getQualifiedClassName(BenchmarkInstructionHandler));
      
      public function BenchmarkInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var _loc4_:IAnimated = null;
         var _loc5_:IAnimated = null;
         var _loc6_:FpsManager = null;
         var _loc7_:* = null;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:BenchmarkCharacter = null;
         var _loc17_:DebugBotFrame = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:* = false;
         var _loc21_:String = null;
         var _loc22_:Array = null;
         var _loc23_:String = null;
         switch(param2)
         {
            case "addmovingcharacter":
               if(param3.length > 0)
               {
                  _loc16_ = new BenchmarkCharacter(id++,TiphonEntityLook.fromString(param3[0]));
                  _loc16_.position = MapPoint.fromCellId(int(Math.random() * 300));
                  _loc16_.display();
                  _loc16_.move(BenchmarkMovementBehavior.getRandomPath(_loc16_));
               }
               break;
            case "setanimation":
               _loc4_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as IAnimated;
               _loc4_.setAnimation(param3[0]);
               break;
            case "setdirection":
               _loc5_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as IAnimated;
               _loc5_.setDirection(param3[0]);
               break;
            case "tiphon-error":
               TiphonDebugManager.disable();
               break;
            case "bot-spectator":
               if(Kernel.getWorker().contains(DebugBotFrame))
               {
                  Kernel.getWorker().removeFrame(DebugBotFrame.getInstance());
                  param1.output("Arret du bot-spectator, " + DebugBotFrame.getInstance().fightCount + " combat(s) vu");
                  break;
               }
               _loc17_ = DebugBotFrame.getInstance();
               _loc18_ = int(param3.indexOf("debugchat"));
               if(_loc18_ != -1)
               {
                  _loc19_ = 500;
                  if(param3.length > _loc18_ + 1)
                  {
                     _loc19_ = int(param3[_loc18_ + 1]);
                  }
                  _loc17_.enableChatMessagesBot(true,_loc19_);
               }
               Kernel.getWorker().addFrame(_loc17_);
               param1.output("Démarrage du bot-spectator ");
               break;
            case "bot-fight":
               if(Kernel.getWorker().contains(FightBotFrame))
               {
                  Kernel.getWorker().removeFrame(FightBotFrame.getInstance());
                  param1.output("Arret du bot-fight, " + FightBotFrame.getInstance().fightCount + " combat(s) effectué");
                  break;
               }
               Kernel.getWorker().addFrame(FightBotFrame.getInstance());
               param1.output("Démarrage du bot-fight ");
               break;
            case "fpsmanager":
               _loc6_ = FpsManager.getInstance();
               if(StageShareManager.stage.contains(_loc6_))
               {
                  _loc6_.hide();
                  break;
               }
               _loc20_ = param3.indexOf("external") != -1;
               if(_loc20_)
               {
                  param1.output("Fps Manager External");
               }
               _loc6_.display(_loc20_);
               break;
            case "fastanimfun":
               param1.output((AnimFunManager.getInstance().fastDelay ? "Désactivation" : "Activation") + " de l\'exécution rapide des anims-funs");
               AnimFunManager.getInstance().fastDelay = !AnimFunManager.getInstance().fastDelay;
               break;
            case "tacticmode":
               TacticModeManager.getInstance().hide();
               _loc8_ = false;
               _loc9_ = 0;
               _loc10_ = false;
               _loc11_ = false;
               _loc12_ = false;
               _loc13_ = false;
               _loc14_ = true;
               _loc15_ = true;
               for each(_loc21_ in param3)
               {
                  _loc22_ = _loc21_.split("=");
                  if(_loc22_ != null)
                  {
                     _loc23_ = _loc22_[1];
                     if(_loc21_.search("fightzone") != -1 && _loc22_.length > 1)
                     {
                        _loc10_ = _loc23_.toLowerCase() == "true" ? true : false;
                     }
                     else if(_loc21_.search("clearcache") != -1 && _loc22_.length > 1)
                     {
                        _loc8_ = _loc23_.toLowerCase() == "true" ? false : true;
                     }
                     else if(_loc21_.search("mode") != -1 && _loc22_.length > 1)
                     {
                        _loc9_ = _loc23_.toLowerCase() == "rp" ? 1 : 0;
                     }
                     else if(_loc21_.search("interactivecells") != -1 && _loc22_.length > 1)
                     {
                        _loc11_ = _loc23_.toLowerCase() == "true" ? true : false;
                     }
                     else if(_loc21_.search("scalezone") != -1 && _loc22_.length > 1)
                     {
                        _loc13_ = _loc23_.toLowerCase() == "true" ? true : false;
                     }
                     else if(_loc21_.search("show") != -1 && _loc22_.length > 1)
                     {
                        _loc12_ = _loc23_.toLowerCase() == "true" ? true : false;
                     }
                     else if(_loc21_.search("flattencells") != -1 && _loc22_.length > 1)
                     {
                        _loc14_ = _loc23_.toLowerCase() == "true" ? true : false;
                     }
                     else if(_loc21_.search("blocLDV") != -1 && _loc22_.length > 1)
                     {
                        _loc15_ = _loc23_.toLowerCase() == "true" ? true : false;
                     }
                  }
               }
               if(_loc12_)
               {
                  TacticModeManager.getInstance().setDebugMode(_loc10_,_loc8_,_loc9_,_loc11_,_loc13_,_loc14_,_loc15_);
                  TacticModeManager.getInstance().show(PlayedCharacterManager.getInstance().currentMap,true);
                  _loc7_ = "Activation";
               }
               else
               {
                  _loc7_ = "Désactivation";
               }
               _loc7_ += " du mode tactique.";
               param1.output(_loc7_);
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "addmovingcharacter":
               return "Add a new mobile character on scene.";
            case "fpsmanager":
               return "Displays the performance of the client. (external)";
            case "bot-spectator":
               return "Start/Stop the auto join fight spectator bot" + "\n    debugchat";
            case "tiphon-error":
               return "Désactive l\'affichage des erreurs du moteur d\'animation.";
            case "fastanimfun":
               return "Active/Désactive l\'exécution rapide des anims funs.";
            case "tacticmode":
               return "Active/Désactive le mode tactique" + "\n    show=[true|false]" + "\n    clearcache=[true|false]" + "\n    mode=[fight|RP]" + "\n    interactivecells=[true|false] " + "\n    fightzone=[true|false]" + "\n    scalezone=[true|false]" + "\n    flattencells=[true|false]";
            default:
               return "Unknow command";
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         var _loc4_:TiphonSprite = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         switch(param1)
         {
            case "tacticmode":
               return ["show","clearcache","mode","interactivecells","fightzone","scalezone","flattencells"];
            case "setanimation":
               _loc4_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as TiphonSprite;
               _loc5_ = _loc4_.animationList;
               _loc6_ = [];
               for each(_loc7_ in _loc5_)
               {
                  if(_loc7_.indexOf("Anim") != -1)
                  {
                     _loc6_.push(_loc7_);
                  }
               }
               _loc6_.sort();
               return _loc6_;
            default:
               return [];
         }
      }
   }
}

