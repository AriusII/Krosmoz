package com.ankamagames.dofus.network.messages.authorized
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   [Trusted]
   public class ConsoleCommandsListMessage extends NetworkMessage implements INetworkMessage
   {
      public static const protocolId:uint = 6127;
      
      private var _isInitialized:Boolean = false;
      
      public var aliases:Vector.<String> = new Vector.<String>();
      
      public var arguments:Vector.<String> = new Vector.<String>();
      
      public var descriptions:Vector.<String> = new Vector.<String>();
      
      public function ConsoleCommandsListMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6127;
      }
      
      public function initConsoleCommandsListMessage(param1:Vector.<String> = null, param2:Vector.<String> = null, param3:Vector.<String> = null) : ConsoleCommandsListMessage
      {
         this.aliases = param1;
         this.arguments = param2;
         this.descriptions = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.aliases = new Vector.<String>();
         this.arguments = new Vector.<String>();
         this.descriptions = new Vector.<String>();
         this._isInitialized = false;
      }
      
      override public function pack(param1:IDataOutput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         this.serialize(_loc2_);
         writePacket(param1,this.getMessageId(),_loc2_);
      }
      
      override public function unpack(param1:IDataInput, param2:uint) : void
      {
         this.deserialize(param1);
      }
      
      public function serialize(param1:IDataOutput) : void
      {
         this.serializeAs_ConsoleCommandsListMessage(param1);
      }
      
      public function serializeAs_ConsoleCommandsListMessage(param1:IDataOutput) : void
      {
         param1.writeShort(this.aliases.length);
         var _loc3_:uint = 0;
         while(_loc3_ < this.aliases.length)
         {
            param1.writeUTF(this.aliases[_loc3_]);
            _loc3_++;
         }
         param1.writeShort(arguments.length);
         var _loc4_:uint = 0;
         while(_loc4_ < arguments.length)
         {
            param1.writeUTF(arguments[_loc4_]);
            _loc4_++;
         }
         param1.writeShort(this.descriptions.length);
         var _loc5_:uint = 0;
         while(_loc5_ < this.descriptions.length)
         {
            param1.writeUTF(this.descriptions[_loc5_]);
            _loc5_++;
         }
      }
      
      public function deserialize(param1:IDataInput) : void
      {
         this.deserializeAs_ConsoleCommandsListMessage(param1);
      }
      
      public function deserializeAs_ConsoleCommandsListMessage(param1:IDataInput) : void
      {
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc3_:uint = uint(param1.readUnsignedShort());
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc9_ = param1.readUTF();
            this.aliases.push(_loc9_);
            _loc4_++;
         }
         var _loc5_:uint = uint(param1.readUnsignedShort());
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            _loc10_ = param1.readUTF();
            arguments.push(_loc10_);
            _loc6_++;
         }
         var _loc7_:uint = uint(param1.readUnsignedShort());
         var _loc8_:uint = 0;
         while(_loc8_ < _loc7_)
         {
            _loc11_ = param1.readUTF();
            this.descriptions.push(_loc11_);
            _loc8_++;
         }
      }
   }
}

