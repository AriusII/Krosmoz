package com.ankamagames.dofus.logic.connection.managers
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationAction;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationWithTicketAction;
   import com.ankamagames.dofus.logic.game.common.frames.ProtectPishingFrame;
   import com.ankamagames.dofus.logic.shield.SecureModeManager;
   import com.ankamagames.dofus.network.enums.ClientInstallTypeEnum;
   import com.ankamagames.dofus.network.enums.ClientTechnologyEnum;
   import com.ankamagames.dofus.network.messages.connection.IdentificationAccountForceMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationMessage;
   import com.ankamagames.dofus.network.types.secure.TrustCertificate;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.crypto.Base64;
   import com.ankamagames.jerakine.utils.crypto.RSA;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.hurlant.crypto.rsa.RSAKey;
   import com.hurlant.util.der.PEM;
   import flash.net.NetworkInfo;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   public class AuthentificationManager implements IDestroyable
   {
      private static var _self:AuthentificationManager;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AuthentificationManager));
      
      private var _publicKey:String;
      
      private var _salt:String;
      
      private var _lva:LoginValidationAction;
      
      private var _certificate:TrustCertificate;
      
      private var _verifyKey:Class = AuthentificationManager__verifyKey;
      
      public var gameServerTicket:String;
      
      public var ankamaPortalKey:String;
      
      public var username:String;
      
      public var nextToken:String;
      
      public var tokenMode:Boolean = false;
      
      public function AuthentificationManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("AuthentificationManager is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : AuthentificationManager
      {
         if(_self == null)
         {
            _self = new AuthentificationManager();
         }
         return _self;
      }
      
      public function get salt() : String
      {
         return this._salt;
      }
      
      public function setSalt(param1:String) : void
      {
         this._salt = param1;
         if(this._salt.length < 32)
         {
            _log.warn("Authentification salt size is lower than 32 ");
            while(this._salt.length < 32)
            {
               this._salt += " ";
            }
         }
      }
      
      public function setPublicKey(param1:Vector.<int>) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeByte(param1[_loc3_]);
            _loc3_++;
         }
         _loc2_.position = 0;
         var _loc4_:ByteArray = new ByteArray();
         var _loc5_:RSAKey = PEM.readRSAPublicKey((new this._verifyKey() as ByteArray).readUTFBytes((new this._verifyKey() as ByteArray).length));
         _loc5_.verify(_loc2_,_loc4_,_loc2_.length);
         this._publicKey = "-----BEGIN PUBLIC KEY-----\n" + Base64.encodeByteArray(_loc4_) + "-----END PUBLIC KEY-----";
      }
      
      public function setValidationAction(param1:LoginValidationAction) : void
      {
         this.username = param1["username"];
         this._lva = param1;
         this._certificate = SecureModeManager.getInstance().retreiveCertificate();
         ProtectPishingFrame.setPasswordHash(MD5.hash(param1.password.toUpperCase()),param1.password.length);
      }
      
      public function get loginValidationAction() : LoginValidationAction
      {
         return this._lva;
      }
      
      public function get canAutoConnectWithToken() : Boolean
      {
         return this.nextToken != null;
      }
      
      public function getIdentificationMessage() : IdentificationMessage
      {
         var _loc1_:IdentificationMessage = null;
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:IdentificationAccountForceMessage = null;
         var _loc5:* = NetworkInfo.networkInfo.findInterfaces();
         var _loc6:uint = 0;
         var _loc7:String = "";
         while(_loc6 < _loc5.length)
         {
            _loc7 += _loc5[_loc6].hardwareAddress;
            _loc6++;
         }
         if(this._lva.username.indexOf("|") == -1)
         {
            _loc1_ = new IdentificationMessage();
            if(this._lva is LoginValidationWithTicketAction || Boolean(this.nextToken))
            {
               _loc2_ = !!this.nextToken ? this.nextToken : LoginValidationWithTicketAction(this._lva).ticket;
               this.nextToken = null;
               this.ankamaPortalKey = this.cipherMd5String(_loc2_);
               _loc1_.initIdentificationMessage(_loc1_.version,XmlConfig.getInstance().getEntry("config.lang.current"),this._lva.username,this._lva.password,_loc7,this._lva.serverId,this._lva.autoSelectServer,this._certificate != null,true);
            }
            else
            {
               this.ankamaPortalKey = this.cipherMd5String(this._lva.password);
               _loc1_.initIdentificationMessage(_loc1_.version,XmlConfig.getInstance().getEntry("config.lang.current"),this._lva.username,this._lva.password,_loc7,this._lva.serverId,this._lva.autoSelectServer,this._certificate != null,false);
            }
            _loc1_.version.initVersionExtended(BuildInfos.BUILD_VERSION.major,BuildInfos.BUILD_VERSION.minor,BuildInfos.BUILD_VERSION.release,AirScanner.isStreamingVersion() ? 70000 : uint(BuildInfos.BUILD_REVISION),BuildInfos.BUILD_PATCH,BuildInfos.BUILD_VERSION.buildType,AirScanner.isStreamingVersion() ? ClientInstallTypeEnum.CLIENT_STREAMING : ClientInstallTypeEnum.CLIENT_BUNDLE,AirScanner.hasAir() ? ClientTechnologyEnum.CLIENT_AIR : ClientTechnologyEnum.CLIENT_FLASH);
            return _loc1_;
         }
         this.ankamaPortalKey = this.cipherMd5String(this._lva.password);
         _loc3_ = this._lva.username.split("|");
         _loc4_ = new IdentificationAccountForceMessage();
         _loc4_.initIdentificationAccountForceMessage(_loc4_.version,XmlConfig.getInstance().getEntry("config.lang.current"),this._lva.username,this._lva.password,_loc7,this._lva.serverId,this._lva.autoSelectServer,this._certificate != null,false,0,_loc3_[1]);
         _loc4_.version.initVersionExtended(BuildInfos.BUILD_VERSION.major,BuildInfos.BUILD_VERSION.minor,BuildInfos.BUILD_VERSION.release,BuildInfos.BUILD_REVISION,BuildInfos.BUILD_PATCH,BuildInfos.BUILD_VERSION.buildType,AirScanner.isStreamingVersion() ? ClientInstallTypeEnum.CLIENT_STREAMING : ClientInstallTypeEnum.CLIENT_BUNDLE,AirScanner.hasAir() ? ClientTechnologyEnum.CLIENT_AIR : ClientTechnologyEnum.CLIENT_FLASH);
         return _loc4_;
      }
      
      public function destroy() : void
      {
         _self = null;
      }
      
      private function cipherMd5String(param1:String) : String
      {
         return MD5.hash(param1 + this._salt);
      }
      
      private function cipherRsa(param1:String, param2:String, param3:TrustCertificate) : Vector.<int>
      {
         var _loc5_:ByteArray = null;
         var _loc8_:int = 0;
         var _loc4_:ByteArray = new ByteArray();
         if(param3)
         {
            _loc4_.writeUTFBytes(this._salt);
            _loc4_.writeUnsignedInt(param3.id);
            _loc4_.writeUTFBytes(param3.hash);
            _loc4_.writeByte(param1.length);
            _loc4_.writeUTFBytes(param1);
            _loc4_.writeUTFBytes(param2);
         }
         else
         {
            _loc4_.writeUTFBytes(this._salt);
            _loc4_.writeByte(param1.length);
            _loc4_.writeUTFBytes(param1);
            _loc4_.writeUTFBytes(param2);
         }
         _loc5_ = RSA.publicEncrypt(this._publicKey,_loc4_);
         var _loc6_:Vector.<int> = new Vector.<int>();
         _loc5_.position = 0;
         var _loc7_:int = 0;
         while(_loc5_.bytesAvailable != 0)
         {
            _loc8_ = _loc5_.readByte();
            _loc6_[_loc7_] = _loc8_;
            _loc7_++;
         }
         return _loc6_;
      }
   }
}

