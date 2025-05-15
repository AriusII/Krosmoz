package com.ankamagames.dofus.logic.shield
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.utils.RpcServiceManager;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.types.secure.TrustCertificate;
   import com.ankamagames.dofus.types.events.RpcEvent;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.ErrorManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class SecureModeManager
   {
      private static var RPC_URL:String;
      
      private static var _self:SecureModeManager;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SecureModeManager));
      
      private static const VALIDATECODE_CODEEXPIRE:String = "CODEEXPIRE";
      
      private static const VALIDATECODE_CODEBADCODE:String = "CODEBADCODE";
      
      private static const VALIDATECODE_CODENOTFOUND:String = "CODENOTFOUND";
      
      private static const VALIDATECODE_SECURITY:String = "SECURITY";
      
      private static const VALIDATECODE_TOOMANYCERTIFICATE:String = "TOOMANYCERTIFICATE";
      
      private static const VALIDATECODE_NOTAVAILABLE:String = "NOTAVAILABLE";
      
      private static const ACCOUNT_AUTHENTIFICATION_FAILED:String = "ACCOUNT_AUTHENTIFICATION_FAILED";
      
      private static const RPC_METHOD_SECURITY_CODE:String = "SecurityCode";
      
      private static const RPC_METHOD_VALIDATE_CODE:String = "ValidateCode";
      
      private static const RPC_METHOD_MIGRATE:String = "Migrate";
      
      private var _timeout:Timer = new Timer(30000);
      
      private var _active:Boolean;
      
      private var _computerName:String;
      
      private var _methodsCallback:Dictionary = new Dictionary();
      
      private var _hasV1Certif:Boolean;
      
      private var _rpcManager:RpcServiceManager;
      
      public var shieldLevel:uint = StoreDataManager.getInstance().getSetData(Constants.DATASTORE_COMPUTER_OPTIONS,"shieldLevel",ShieldSecureLevel.MEDIUM);
      
      public function SecureModeManager()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this.initRPC();
      }
      
      public static function getInstance() : SecureModeManager
      {
         if(!_self)
         {
            _self = new SecureModeManager();
         }
         return _self;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
         KernelEventsManager.getInstance().processCallback(HookList.SecureModeChange,param1);
      }
      
      public function get computerName() : String
      {
         return this._computerName;
      }
      
      public function set computerName(param1:String) : void
      {
         this._computerName = param1;
      }
      
      public function get certificate() : TrustCertificate
      {
         return this.retreiveCertificate();
      }
      
      public function askCode(param1:Function) : void
      {
         this._methodsCallback[RPC_METHOD_SECURITY_CODE] = param1;
         this._rpcManager.callMethod(RPC_METHOD_SECURITY_CODE,[this.getUsername(),AuthentificationManager.getInstance().ankamaPortalKey,1]);
      }
      
      public function sendCode(param1:String, param2:Function) : void
      {
         var _loc3_:ShieldCertifcate = new ShieldCertifcate();
         _loc3_.secureLevel = this.shieldLevel;
         this._methodsCallback[RPC_METHOD_VALIDATE_CODE] = param2;
         this._rpcManager.callMethod(RPC_METHOD_VALIDATE_CODE,[this.getUsername(),AuthentificationManager.getInstance().ankamaPortalKey,1,param1.toUpperCase(),_loc3_.hash,_loc3_.reverseHash,!!this._computerName ? true : false,!!this._computerName ? this._computerName : ""]);
      }
      
      private function initRPC() : void
      {
         if(BuildInfos.BUILD_TYPE == BuildTypeEnum.DEBUG || BuildInfos.BUILD_TYPE == BuildTypeEnum.INTERNAL || BuildInfos.BUILD_TYPE == BuildTypeEnum.TESTING)
         {
            RPC_URL = "http://api.ankama.lan/ankama/shield.json";
         }
         else
         {
            RPC_URL = "https://api.ankama.com/ankama/shield.json";
         }
         this._rpcManager = new RpcServiceManager(RPC_URL,"json");
         this._rpcManager.addEventListener(RpcEvent.EVENT_DATA,this.onRpcData);
         this._rpcManager.addEventListener(RpcEvent.EVENT_ERROR,this.onRpcData);
      }
      
      private function getUsername() : String
      {
         return AuthentificationManager.getInstance().username.toLowerCase().split("|")[0];
      }
      
      private function parseRpcValidateResponse(param1:Object, param2:String) : Object
      {
         var _loc4_:Boolean = false;
         var _loc3_:Object = new Object();
         _loc3_.error = param1.error;
         _loc3_.fatal = false;
         _loc3_.retry = false;
         _loc3_.text = "";
         switch(param1.error)
         {
            case VALIDATECODE_CODEEXPIRE:
               _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.expire");
               _loc3_.fatal = true;
               break;
            case VALIDATECODE_CODEBADCODE:
               _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.403");
               _loc3_.retry = true;
               break;
            case VALIDATECODE_CODENOTFOUND:
               _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.404") + " (1)";
               _loc3_.fatal = true;
               break;
            case VALIDATECODE_SECURITY:
               _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.security");
               _loc3_.fatal = true;
               break;
            case VALIDATECODE_TOOMANYCERTIFICATE:
               _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.413");
               _loc3_.fatal = true;
               break;
            case VALIDATECODE_NOTAVAILABLE:
               _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.202");
               _loc3_.fatal = true;
               break;
            case ACCOUNT_AUTHENTIFICATION_FAILED:
               _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.404") + " (2)";
               _loc3_.fatal = true;
               break;
            default:
               _loc3_.text = param1.error;
               _loc3_.fatal = true;
         }
         if(Boolean(param1.certificate) && Boolean(param1.id))
         {
            _loc4_ = this.addCertificate(param1.id,param1.certificate,this.shieldLevel);
            if(!_loc4_)
            {
               _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.202.fatal");
               _loc3_.fatal = true;
            }
         }
         return _loc3_;
      }
      
      private function parseRpcASkCodeResponse(param1:Object, param2:String) : Object
      {
         var _loc3_:Object = new Object();
         _loc3_.error = !_loc3_.error;
         _loc3_.fatal = false;
         _loc3_.retry = false;
         _loc3_.text = "";
         if(!param1.error)
         {
            _loc3_.domain = param1.domain;
            _loc3_.error = false;
         }
         else
         {
            switch(param1.error)
            {
               case VALIDATECODE_CODEEXPIRE:
                  _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.expire");
                  _loc3_.fatal = true;
            }
         }
         return _loc3_;
      }
      
      private function getCertifFolder(param1:uint) : File
      {
         var _loc4_:File = null;
         var _loc2_:Array = File.applicationStorageDirectory.nativePath.split(File.separator);
         _loc2_.pop();
         _loc2_.pop();
         var _loc3_:String = _loc2_.join(File.separator);
         if(param1 == 1)
         {
            _loc4_ = new File(_loc3_ + File.separator + "AnkamaCertificates/");
         }
         if(param1 == 2)
         {
            _loc4_ = new File(_loc3_ + File.separator + "AnkamaCertificates/v2-RELEASE");
         }
         _loc4_.createDirectory();
         return _loc4_;
      }
      
      private function addCertificate(param1:uint, param2:String, param3:uint = 2) : Boolean
      {
         var f:File = null;
         var fs:FileStream = null;
         var cert:ShieldCertifcate = null;
         var id:uint = param1;
         var content:String = param2;
         var secureLevel:uint = param3;
         try
         {
            f = this.getCertifFolder(2);
            f = f.resolvePath(MD5.hash(this.getUsername()));
            fs = new FileStream();
            fs.open(f,FileMode.WRITE);
            cert = new ShieldCertifcate();
            cert.id = id;
            cert.version = 3;
            cert.content = content;
            cert.secureLevel = secureLevel;
            fs.writeBytes(cert.serialize());
            fs.close();
            return true;
         }
         catch(e:Error)
         {
            ErrorManager.addError("Impossible de créer le fichier de certificat.",e);
         }
         return false;
      }
      
      public function checkMigrate() : void
      {
         if(!this._hasV1Certif)
         {
            return;
         }
         var _loc1_:TrustCertificate = this.retreiveCertificate();
         this.migrate(_loc1_.id,_loc1_.hash);
      }
      
      private function getCertificateFile() : File
      {
         var userName:String = null;
         var f:File = null;
         try
         {
            userName = this.getUsername();
            f = this.getCertifFolder(2).resolvePath(MD5.hash(userName));
            if(!f.exists)
            {
               f = this.getCertifFolder(1).resolvePath(MD5.hash(userName));
            }
            if(f.exists)
            {
               return f;
            }
         }
         catch(e:Error)
         {
            _log.error("Erreur lors de la recherche du certifcat : " + e.message);
         }
         return null;
      }
      
      public function retreiveCertificate() : TrustCertificate
      {
         var f:File = null;
         var fs:FileStream = null;
         var certif:ShieldCertifcate = null;
         try
         {
            this._hasV1Certif = false;
            f = this.getCertificateFile();
            if(f)
            {
               fs = new FileStream();
               fs.open(f,FileMode.READ);
               certif = ShieldCertifcate.fromRaw(fs);
               fs.close();
               return certif.toNetwork();
            }
         }
         catch(e:Error)
         {
            ErrorManager.addError("Impossible de lire le fichier de certificat.",e);
         }
         return null;
      }
      
      private function onRpcData(param1:RpcEvent) : void
      {
         if(param1.type == RpcEvent.EVENT_ERROR && !param1.result)
         {
            this._methodsCallback[param1.method]({
               "error":true,
               "fatal":true,
               "text":I18n.getUiText("ui.secureMode.error.checkCode.503")
            });
            return;
         }
         if(param1.method == RPC_METHOD_SECURITY_CODE)
         {
            this._methodsCallback[param1.method](this.parseRpcASkCodeResponse(param1.result,param1.method));
         }
         if(param1.method == RPC_METHOD_VALIDATE_CODE)
         {
            this._methodsCallback[param1.method](this.parseRpcValidateResponse(param1.result,param1.method));
         }
         if(param1.method == RPC_METHOD_MIGRATE)
         {
            if(param1.result.success)
            {
               this.migrationSuccess(param1.result);
            }
            else
            {
               _log.error("Impossible de migrer le certificat : " + param1.result.error);
            }
         }
      }
      
      private function migrate(param1:uint, param2:String) : void
      {
         var _loc3_:ShieldCertifcate = new ShieldCertifcate();
         _loc3_.secureLevel = this.shieldLevel;
         this._rpcManager.callMethod(RPC_METHOD_MIGRATE,[this.getUsername(),AuthentificationManager.getInstance().ankamaPortalKey,1,2,param1,param2,_loc3_.hash,_loc3_.reverseHash]);
      }
      
      private function migrationSuccess(param1:Object) : void
      {
         var _loc2_:File = this.getCertificateFile();
         if(!_loc2_.exists)
         {
         }
         this.addCertificate(param1.id,param1.certificate);
      }
   }
}

