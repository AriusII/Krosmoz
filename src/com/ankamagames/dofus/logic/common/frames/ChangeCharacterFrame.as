package com.ankamagames.dofus.logic.common.frames
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.logic.common.actions.ChangeCharacterAction;
   import com.ankamagames.dofus.logic.common.actions.ChangeServerAction;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationAction;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.logic.game.common.frames.QuestFrame;
   import com.ankamagames.dofus.misc.utils.errormanager.WebServiceDataHandler;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationListMessage;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   
   public class ChangeCharacterFrame implements Frame
   {
      public function ChangeCharacterFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return 0;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:ChangeCharacterAction = null;
         var _loc4_:LoginValidationAction = null;
         var _loc5_:LoginValidationAction = null;
         var _loc6_:LoginValidationAction = null;
         var _loc7_:LoginValidationAction = null;
         var _loc8_:NotificationListMessage = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:* = 0;
         var _loc12_:int = 0;
         switch(true)
         {
            case param1 is ChangeCharacterAction:
               _loc3_ = param1 as ChangeCharacterAction;
               WebServiceDataHandler.getInstance().changeCharacter();
               _loc2_ = XmlConfig.getInstance().getEntry("config.loginMode");
               _loc4_ = AuthentificationManager.getInstance().loginValidationAction;
               _loc5_ = LoginValidationAction.create(_loc4_.username,_loc4_.password,true,_loc3_.serverId);
               AuthentificationManager.getInstance().setValidationAction(_loc5_);
               SoundManager.getInstance().manager.removeAllSounds();
               ConnectionsHandler.closeConnection();
               Kernel.getWorker().resume();
               Kernel.getInstance().reset(null,AuthentificationManager.getInstance().canAutoConnectWithToken || !AuthentificationManager.getInstance().tokenMode);
               return true;
            case param1 is ChangeServerAction:
               _loc6_ = AuthentificationManager.getInstance().loginValidationAction;
               _loc7_ = LoginValidationAction.create(_loc6_.username,_loc6_.password,false);
               AuthentificationManager.getInstance().setValidationAction(_loc7_);
               ConnectionsHandler.closeConnection();
               Kernel.getInstance().reset(null,AuthentificationManager.getInstance().canAutoConnectWithToken || !AuthentificationManager.getInstance().tokenMode);
               return true;
            case param1 is NotificationListMessage:
               _loc8_ = param1 as NotificationListMessage;
               QuestFrame.notificationList = new Array();
               _loc9_ = int(_loc8_.flags.length);
               _loc10_ = 0;
               while(_loc10_ < _loc9_)
               {
                  _loc11_ = _loc8_.flags[_loc10_];
                  _loc12_ = 0;
                  while(_loc12_ < 32)
                  {
                     QuestFrame.notificationList[_loc12_ + _loc10_ * 32] = Boolean(_loc11_ & 1);
                     _loc11_ >>= 1;
                     _loc12_++;
                  }
                  _loc10_++;
               }
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
   }
}

