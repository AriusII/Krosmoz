package com.ankamagames.jerakine.utils.crypto
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.jerakine.utils.errors.SignatureError;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.getTimer;
   
   public class Signature
   {
      public static const ANKAMA_SIGNED_FILE_HEADER:String = "AKSF";
      
      private var _key:SignatureKey;
      
      public function Signature(param1:SignatureKey)
      {
         super();
         if(!param1)
         {
            throw ArgumentError("Key must be not null");
         }
         this._key = param1;
      }
      
      public function sign(param1:IDataInput) : ByteArray
      {
         var _loc2_:ByteArray = null;
         if(!this._key.canSign)
         {
            throw new Error("La clef fournit ne permet pas de signer des données");
         }
         if(param1 is ByteArray)
         {
            _loc2_ = param1 as ByteArray;
         }
         else
         {
            _loc2_ = new ByteArray();
            param1.readBytes(_loc2_);
            _loc2_.position = 0;
         }
         var _loc3_:uint = uint(_loc2_["position"]);
         var _loc4_:ByteArray = new ByteArray();
         var _loc5_:uint = Math.random() * 255;
         _loc4_.writeByte(_loc5_);
         _loc4_.writeUnsignedInt(_loc2_.bytesAvailable);
         var _loc6_:Number = getTimer();
         _loc4_.writeUTFBytes(MD5.hash(_loc2_.readUTFBytes(_loc2_.bytesAvailable)));
         trace("Temps de hash pour signature : " + (getTimer() - _loc6_) + " ms");
         var _loc7_:uint = 2;
         while(_loc7_ < _loc4_.length)
         {
            _loc4_[_loc7_] ^= _loc5_;
            _loc7_++;
         }
         var _loc8_:ByteArray = new ByteArray();
         _loc4_.position = 0;
         this._key.sign(_loc4_,_loc8_,_loc4_.length);
         var _loc9_:ByteArray = new ByteArray();
         _loc9_.writeUTF(ANKAMA_SIGNED_FILE_HEADER);
         _loc9_.writeShort(1);
         _loc9_.writeInt(_loc8_.length);
         _loc8_.position = 0;
         _loc9_.writeBytes(_loc8_);
         _loc2_.position = _loc3_;
         _loc9_.writeBytes(_loc2_);
         return _loc9_;
      }
      
      public function verify(param1:IDataInput, param2:ByteArray) : Boolean
      {
         var formatVersion:uint;
         var sigData:ByteArray;
         var decryptedHash:ByteArray;
         var ramdomPart:int;
         var hash:ByteArray;
         var i:uint;
         var contentLen:int;
         var testedContentLen:int;
         var signHash:String;
         var tH:Number;
         var contentHash:String;
         var header:String = null;
         var len:uint = 0;
         var input:IDataInput = param1;
         var output:ByteArray = param2;
         try
         {
            header = input.readUTF();
         }
         catch(e:Error)
         {
            throw new SignatureError("Invalid file format (can\'t read header)",SignatureError.INVALID_HEADER);
         }
         if(header != ANKAMA_SIGNED_FILE_HEADER)
         {
            throw new SignatureError("Invalid header",SignatureError.INVALID_HEADER);
         }
         formatVersion = uint(input.readShort());
         sigData = new ByteArray();
         decryptedHash = new ByteArray();
         try
         {
            len = uint(input.readInt());
            input.readBytes(sigData,0,len);
         }
         catch(e:Error)
         {
            throw new SignatureError("Invalid signature format, not enough data.",SignatureError.INVALID_SIGNATURE);
         }
         try
         {
            this._key.verify(sigData,decryptedHash,sigData.length);
         }
         catch(e:Error)
         {
            return false;
         }
         decryptedHash.position = 0;
         ramdomPart = decryptedHash.readByte();
         hash = new ByteArray();
         i = 2;
         while(i < decryptedHash.length)
         {
            decryptedHash[i] ^= ramdomPart;
            i++;
         }
         contentLen = int(decryptedHash.readUnsignedInt());
         testedContentLen = int(input.bytesAvailable);
         signHash = decryptedHash.readUTFBytes(decryptedHash.bytesAvailable).substr(1);
         input.readBytes(output);
         tH = getTimer();
         contentHash = MD5.hash(output.readUTFBytes(output.bytesAvailable)).substr(1);
         trace("Temps de hash pour validation de signature : " + (getTimer() - tH) + " ms");
         output.position = 0;
         return Boolean(signHash) && signHash == contentHash && contentLen == testedContentLen;
      }
      
      private function traceData(param1:ByteArray) : void
      {
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_[_loc3_] = param1[_loc3_];
            _loc3_++;
         }
         trace(_loc2_.join(","));
      }
   }
}

