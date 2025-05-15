package com.ankamagames.dofus.logic.connection.frames
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.dofus.internalDatacenter.connection.SubscriberGift;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.net.DisconnectionReasonEnum;
   import com.ankamagames.dofus.logic.common.frames.AuthorizedFrame;
   import com.ankamagames.dofus.logic.common.frames.ChangeCharacterFrame;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationAction;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationWithTicketAction;
   import com.ankamagames.dofus.logic.connection.actions.NicknameChoiceRequestAction;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.logic.connection.managers.SpecialBetaAuthentification;
   import com.ankamagames.dofus.logic.connection.managers.StoreUserDataManager;
   import com.ankamagames.dofus.logic.game.approach.actions.NewsLoginRequestAction;
   import com.ankamagames.dofus.logic.game.approach.actions.SubscribersGiftListRequestAction;
   import com.ankamagames.dofus.logic.game.approach.managers.PartManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.messages.connection.HelloConnectMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationFailedBannedMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationFailedForBadVersionMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationFailedMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationSuccessMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationSuccessWithLoginTokenMessage;
   import com.ankamagames.dofus.network.messages.connection.register.NicknameAcceptedMessage;
   import com.ankamagames.dofus.network.messages.connection.register.NicknameChoiceRequestMessage;
   import com.ankamagames.dofus.network.messages.connection.register.NicknameRefusedMessage;
   import com.ankamagames.dofus.network.messages.connection.register.NicknameRegistrationMessage;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.network.ServerConnection;
   import com.ankamagames.jerakine.network.messages.ServerConnectionFailedMessage;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.DataStoreType;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.crypto.Base64;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.CommandLineArguments;
   import flash.events.Event;
   import flash.system.LoaderContext;
   import flash.utils.getQualifiedClassName;
   
   public class AuthentificationFrame implements Frame
   {
      private static var _lastTicket:String;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AuthentificationFrame));
      
      private var _loader:IResourceLoader;
      
      private var _contextLoader:LoaderContext;
      
      private var _dispatchModuleHook:Boolean;
      
      private var _connexionSequence:Array;
      
      private var commonMod:Object = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
      
      private var _lva:LoginValidationAction;
      
      private var _streamingBetaAccess:Boolean = false;
      
      public function AuthentificationFrame(param1:Boolean = true)
      {
         super();
         this._dispatchModuleHook = param1;
         this._contextLoader = new LoaderContext();
         this._contextLoader.checkPolicyFile = true;
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onLoadError);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoad);
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         this.processInvokeArgs();
         if(this._dispatchModuleHook)
         {
            if(!AirScanner.isStreamingVersion())
            {
               _loc1_ = OptionManager.getOptionManager("dofus")["legalAgreementEula"];
               _loc2_ = OptionManager.getOptionManager("dofus")["legalAgreementTou"];
               _loc3_ = XmlConfig.getInstance().getEntry("config.lang.current") + "#" + I18n.getUiText("ui.legal.eula").length;
               _loc4_ = XmlConfig.getInstance().getEntry("config.lang.current") + "#" + (I18n.getUiText("ui.legal.tou1") + I18n.getUiText("ui.legal.tou2")).length;
               _loc5_ = new Array();
               if(_loc1_ != _loc3_)
               {
                  _loc5_.push("eula");
               }
               if(_loc2_ != _loc4_)
               {
                  _loc5_.push("tou");
               }
               if(_loc5_.length > 0)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.AgreementsRequired,_loc5_);
               }
            }
            KernelEventsManager.getInstance().processCallback(HookList.AuthentificationStart);
         }
         return true;
      }
      
      private function onStreamingBetaAuthentification(param1:Event) : void
      {
         var _loc2_:Object = null;
         if(SpecialBetaAuthentification(param1.target).haveAccess)
         {
            this._streamingBetaAccess = true;
            this.process(this._lva);
         }
         else
         {
            _log.fatal("Pas de droits, pas de chocolat");
            this._streamingBetaAccess = false;
            KernelEventsManager.getInstance().processCallback(HookList.IdentificationFailed,0);
            _loc2_ = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
            _loc2_.openPopup(I18n.getUiText("ui.popup.information"),"You are trying to access to a private beta but your account is not allowed.If you wish have an access, please contact Ankama.",[I18n.getUiText("ui.common.ok")]);
         }
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:LoginValidationAction = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:DataStoreType = null;
         var _loc8_:uint = 0;
         var _loc9_:Array = null;
         var _loc10_:Object = null;
         var _loc11_:ServerConnectionFailedMessage = null;
         var _loc12_:HelloConnectMessage = null;
         var _loc13_:IdentificationSuccessMessage = null;
         var _loc14_:IdentificationFailedForBadVersionMessage = null;
         var _loc15_:IdentificationFailedBannedMessage = null;
         var _loc16_:IdentificationFailedMessage = null;
         var _loc17_:NicknameRegistrationMessage = null;
         var _loc18_:NicknameRefusedMessage = null;
         var _loc19_:NicknameAcceptedMessage = null;
         var _loc20_:NicknameChoiceRequestAction = null;
         var _loc21_:NicknameChoiceRequestMessage = null;
         var _loc22_:SubscribersGiftListRequestAction = null;
         var _loc23_:Uri = null;
         var _loc24_:String = null;
         var _loc25_:NewsLoginRequestAction = null;
         var _loc26_:Uri = null;
         var _loc27_:String = null;
         var _loc28_:SpecialBetaAuthentification = null;
         var _loc29_:String = null;
         var _loc30_:String = null;
         var _loc31_:Object = null;
         var _loc32_:String = null;
         var _loc33_:uint = 0;
         var _loc34_:String = null;
         var _loc35_:Array = null;
         var _loc36_:Array = null;
         var _loc37_:String = null;
         var _loc38_:Array = null;
         var _loc39_:uint = 0;
         var _loc40_:Object = null;
         var _loc41_:String = null;
         var _loc42_:String = null;
         var _loc43_:Array = null;
         switch(true)
         {
            case param1 is LoginValidationAction:
               _loc2_ = LoginValidationAction(param1);
               if(BuildInfos.BUILD_TYPE < BuildTypeEnum.TESTING && (AirScanner.isStreamingVersion() || XmlConfig.getInstance().getEntry("config.dev.mode")) && !this._streamingBetaAccess)
               {
                  this._lva = _loc2_;
                  _loc28_ = new SpecialBetaAuthentification(_loc2_.username,AirScanner.isStreamingVersion() ? SpecialBetaAuthentification.STREAMING : SpecialBetaAuthentification.MODULES);
                  _loc28_.addEventListener(Event.INIT,this.onStreamingBetaAuthentification);
                  return true;
               }
               _loc3_ = new Array();
               _loc4_ = XmlConfig.getInstance().getEntry("config.connection.port");
               for each(_loc29_ in _loc4_.split(","))
               {
                  _loc3_.push(int(_loc29_));
               }
               _loc5_ = String(XmlConfig.getInstance().getEntry("config.connection.host")).split(",");
               _loc6_ = [];
               for each(_loc30_ in _loc5_)
               {
                  _loc6_.push({
                     "host":_loc30_,
                     "random":Math.random()
                  });
               }
               _loc6_.sortOn("random",Array.NUMERIC);
               _loc5_ = [];
               for each(_loc31_ in _loc6_)
               {
                  _loc5_.push(_loc31_.host);
               }
               _loc7_ = new DataStoreType("Dofus_ComputerOptions",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_ACCOUNT);
               _loc8_ = uint(StoreDataManager.getInstance().getData(_loc7_,"connectionPortDefault"));
               this._connexionSequence = [];
               _loc9_ = [];
               for each(_loc32_ in _loc5_)
               {
                  for each(_loc33_ in _loc3_)
                  {
                     if(_loc8_ == _loc33_)
                     {
                        _loc9_.push({
                           "host":_loc32_,
                           "port":_loc33_
                        });
                     }
                     else
                     {
                        this._connexionSequence.push({
                           "host":_loc32_,
                           "port":_loc33_
                        });
                     }
                  }
               }
               this._connexionSequence = _loc9_.concat(this._connexionSequence);
               if(Constants.EVENT_MODE)
               {
                  _loc34_ = Constants.EVENT_MODE_PARAM;
                  if((Boolean(_loc34_)) && _loc34_.charAt(0) != "!")
                  {
                     _loc34_ = Base64.decode(_loc34_);
                     _loc35_ = [];
                     _loc36_ = _loc34_.split(",");
                     for each(_loc37_ in _loc36_)
                     {
                        _loc38_ = _loc37_.split(":");
                        _loc35_[_loc38_[0]] = _loc38_[1];
                     }
                     if(_loc35_["login"])
                     {
                        _loc2_.username = _loc35_["login"];
                     }
                     if(_loc35_["password"])
                     {
                        _loc2_.password = _loc35_["password"];
                     }
                  }
               }
               AuthentificationManager.getInstance().setValidationAction(_loc2_);
               _loc10_ = this._connexionSequence.shift();
               ConnectionsHandler.connectToLoginServer(_loc10_.host,_loc10_.port);
               return true;
               break;
            case param1 is ServerConnectionFailedMessage:
               _loc11_ = ServerConnectionFailedMessage(param1);
               if(_loc11_.failedConnection == ConnectionsHandler.getConnection())
               {
                  PlayerManager.getInstance().destroy();
                  (ConnectionsHandler.getConnection() as ServerConnection).stopConnectionTimeout();
                  _loc39_ = _loc11_.failedConnection.port;
                  if(this._connexionSequence)
                  {
                     _loc40_ = this._connexionSequence.shift();
                     if(_loc40_)
                     {
                        ConnectionsHandler.connectToLoginServer(_loc40_.host,_loc40_.port);
                     }
                     else
                     {
                        KernelEventsManager.getInstance().processCallback(HookList.ServerConnectionFailed,DisconnectionReasonEnum.UNEXPECTED);
                     }
                  }
               }
               return true;
            case param1 is HelloConnectMessage:
               _loc12_ = HelloConnectMessage(param1);
               AuthentificationManager.getInstance().setPublicKey(_loc12_.key);
               AuthentificationManager.getInstance().setSalt(_loc12_.salt);
               ConnectionsHandler.getConnection().send(AuthentificationManager.getInstance().getIdentificationMessage());
               KernelEventsManager.getInstance().processCallback(HookList.ConnectionTimerStart);
               TimeManager.getInstance().reset();
               return true;
            case param1 is IdentificationSuccessMessage:
               _loc13_ = IdentificationSuccessMessage(param1);
               if(_loc13_ is IdentificationSuccessWithLoginTokenMessage)
               {
                  AuthentificationManager.getInstance().nextToken = IdentificationSuccessWithLoginTokenMessage(_loc13_).loginToken;
               }
               if(_loc13_.login)
               {
                  AuthentificationManager.getInstance().username = _loc13_.login;
               }
               PlayerManager.getInstance().accountId = _loc13_.accountId;
               PlayerManager.getInstance().communityId = _loc13_.communityId;
               PlayerManager.getInstance().hasRights = _loc13_.hasRights;
               PlayerManager.getInstance().nickname = _loc13_.nickname;
               PlayerManager.getInstance().subscriptionEndDate = _loc13_.subscriptionEndDate;
               PlayerManager.getInstance().secretQuestion = _loc13_.secretQuestion;
               PlayerManager.getInstance().accountCreation = _loc13_.accountCreation;
               AuthorizedFrame(Kernel.getWorker().getFrame(AuthorizedFrame)).hasRights = _loc13_.hasRights;
               if(PlayerManager.getInstance().subscriptionEndDate > 0 || PlayerManager.getInstance().hasRights)
               {
                  PartManager.getInstance().checkAndDownload("all");
                  PartManager.getInstance().checkAndDownload("subscribed");
               }
               if(PlayerManager.getInstance().hasRights)
               {
                  PartManager.getInstance().checkAndDownload("admin");
               }
               if(PlayerManager.getInstance().hasRights)
               {
                  PartManager.getInstance().checkAndDownload("admin");
                  _loc41_ = OptionManager.getOptionManager("dofus")["legalAgreementModsTou"];
                  _loc42_ = XmlConfig.getInstance().getEntry("config.lang.current") + "#" + I18n.getUiText("ui.legal.modstou").length;
                  _loc43_ = new Array();
                  if(_loc41_ != _loc42_)
                  {
                     _loc43_.push("modstou");
                  }
                  if(_loc43_.length > 0)
                  {
                     KernelEventsManager.getInstance().processCallback(HookList.AgreementsRequired,_loc43_);
                  }
               }
               StoreUserDataManager.getInstance().savePlayerData();
               Kernel.getWorker().removeFrame(this);
               Kernel.getWorker().addFrame(new ChangeCharacterFrame());
               Kernel.getWorker().addFrame(new ServerSelectionFrame());
               KernelEventsManager.getInstance().processCallback(HookList.IdentificationSuccess);
               return true;
            case param1 is IdentificationFailedForBadVersionMessage:
               _loc14_ = IdentificationFailedForBadVersionMessage(param1);
               PlayerManager.getInstance().destroy();
               ConnectionsHandler.closeConnection();
               KernelEventsManager.getInstance().processCallback(HookList.IdentificationFailedForBadVersion,_loc14_.reason,_loc14_.requiredVersion);
               if(!this._dispatchModuleHook)
               {
                  this._dispatchModuleHook = true;
                  this.pushed();
               }
               return true;
            case param1 is IdentificationFailedBannedMessage:
               _loc15_ = IdentificationFailedBannedMessage(param1);
               PlayerManager.getInstance().destroy();
               ConnectionsHandler.closeConnection();
               KernelEventsManager.getInstance().processCallback(HookList.IdentificationFailedWithDuration,_loc15_.reason,_loc15_.banEndDate);
               if(!this._dispatchModuleHook)
               {
                  this._dispatchModuleHook = true;
                  this.pushed();
               }
               return true;
            case param1 is IdentificationFailedMessage:
               _loc16_ = IdentificationFailedMessage(param1);
               PlayerManager.getInstance().destroy();
               ConnectionsHandler.closeConnection();
               KernelEventsManager.getInstance().processCallback(HookList.IdentificationFailed,_loc16_.reason);
               if(!this._dispatchModuleHook)
               {
                  this._dispatchModuleHook = true;
                  this.pushed();
               }
               return true;
            case param1 is NicknameRegistrationMessage:
               _loc17_ = NicknameRegistrationMessage(param1);
               KernelEventsManager.getInstance().processCallback(HookList.NicknameRegistration);
               return true;
            case param1 is NicknameRefusedMessage:
               _loc18_ = NicknameRefusedMessage(param1);
               KernelEventsManager.getInstance().processCallback(HookList.NicknameRefused,_loc18_.reason);
               return true;
            case param1 is NicknameAcceptedMessage:
               _loc19_ = NicknameAcceptedMessage(param1);
               KernelEventsManager.getInstance().processCallback(HookList.NicknameAccepted);
               return true;
            case param1 is NicknameChoiceRequestAction:
               _loc20_ = NicknameChoiceRequestAction(param1);
               _loc21_ = new NicknameChoiceRequestMessage();
               _loc21_.initNicknameChoiceRequestMessage(_loc20_.nickname);
               ConnectionsHandler.getConnection().send(_loc21_);
               return true;
            case param1 is SubscribersGiftListRequestAction:
               _loc22_ = SubscribersGiftListRequestAction(param1);
               _loc24_ = XmlConfig.getInstance().getEntry("config.lang.current");
               if(_loc24_ == "de" || _loc24_ == "en" || _loc24_ == "es" || _loc24_ == "pt" || _loc24_ == "fr" || _loc24_ == "uk" || _loc24_ == "ru")
               {
                  _loc23_ = new Uri(XmlConfig.getInstance().getEntry("config.subscribersGift") + "subscriberGifts_" + _loc24_ + ".xml");
               }
               else
               {
                  _loc23_ = new Uri(XmlConfig.getInstance().getEntry("config.subscribersGift") + "subscriberGifts_en.xml");
               }
               _loc23_.loaderContext = this._contextLoader;
               this._loader.load(_loc23_);
               return true;
            case param1 is NewsLoginRequestAction:
               _loc25_ = NewsLoginRequestAction(param1);
               _loc27_ = XmlConfig.getInstance().getEntry("config.lang.current");
               if(_loc27_ == "de" || _loc27_ == "en" || _loc27_ == "es" || _loc27_ == "pt" || _loc27_ == "fr" || _loc27_ == "uk" || _loc27_ == "it" || _loc27_ == "ru")
               {
                  _loc26_ = new Uri(XmlConfig.getInstance().getEntry("config.loginNews") + "news_" + _loc27_ + ".xml");
               }
               else
               {
                  _loc26_ = new Uri(XmlConfig.getInstance().getEntry("config.loginNews") + "news_en.xml");
               }
               _loc26_.loaderContext = this._contextLoader;
               this._loader.load(_loc26_);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         Berilia.getInstance().unloadUi("Login");
         this._loader.removeEventListener(ResourceErrorEvent.ERROR,this.onLoadError);
         this._loader.removeEventListener(ResourceLoadedEvent.LOADED,this.onLoad);
         return true;
      }
      
      private function processInvokeArgs() : void
      {
         var _loc1_:String = null;
         var _loc2_:LoginValidationWithTicketAction = null;
         if(CommandLineArguments.getInstance().hasArgument("ticket"))
         {
            _loc1_ = CommandLineArguments.getInstance().getArgument("ticket");
            if(_lastTicket == _loc1_)
            {
               return;
            }
            _log.info("Use ticket from launch param\'s");
            _lastTicket = _loc1_;
            _loc2_ = LoginValidationWithTicketAction.create(_loc1_,true);
            this.process(_loc2_);
         }
      }
      
      private function onLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:XML = null;
         var _loc7_:SubscriberGift = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:uint = 0;
         var _loc11_:XML = null;
         var _loc2_:Array = new Array();
         var _loc3_:XML = param1.resource;
         var _loc4_:String = _loc3_.toXMLString();
         if(_loc4_.substring(1,17) == "subscribersGifts")
         {
            _loc5_ = 0;
            for each(_loc6_ in _loc3_..gift)
            {
               _loc5_++;
               _loc7_ = new SubscriberGift(_loc5_,_loc6_.description,_loc6_.uri,_loc6_.link);
               _loc2_.push(_loc7_);
            }
            KernelEventsManager.getInstance().processCallback(HookList.SubscribersList,_loc2_);
         }
         else if(_loc4_.substring(1,9) == "newsList")
         {
            _loc10_ = 0;
            for each(_loc11_ in _loc3_..news)
            {
               if(_loc11_.@id > _loc10_)
               {
                  _loc8_ = _loc11_.text;
                  _loc9_ = _loc11_.link;
                  _loc10_ = uint(_loc11_.@id);
               }
            }
            KernelEventsManager.getInstance().processCallback(HookList.NewsLogin,_loc8_,_loc9_);
         }
      }
      
      private function onLoadError(param1:ResourceErrorEvent) : void
      {
         _log.error("Cannot load xml " + param1.uri + "(" + param1.errorMsg + ")");
      }
   }
}

