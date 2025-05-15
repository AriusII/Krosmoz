package com.ankamagames.jerakine.network
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.ConnectedMessage;
   import com.ankamagames.jerakine.messages.MessageHandler;
   import com.ankamagames.jerakine.network.messages.ServerConnectionClosedMessage;
   import com.ankamagames.jerakine.network.messages.ServerConnectionFailedMessage;
   import com.ankamagames.jerakine.replay.LogFrame;
   import com.ankamagames.jerakine.replay.LogTypeEnum;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.IDataInput;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   [Event(name="securityError",type="flash.events.SecurityErrorEvent")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="close",type="flash.events.Event")]
   [Event(name="connect",type="flash.events.Event")]
   public class ServerConnection extends Socket implements IEventDispatcher, IServerConnection
   {
      public static var disabled:Boolean;
      
      public static var disabledIn:Boolean;
      
      public static var disabledOut:Boolean;
      
      private static const DEBUG_DATA:Boolean = true;
      
      private static const LATENCY_AVG_BUFFER_SIZE:uint = 50;
      
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ServerConnection));
      
      private var _rawParser:RawDataParser;
      
      private var _handler:MessageHandler;
      
      private var _remoteSrvHost:String;
      
      private var _remoteSrvPort:uint;
      
      private var _connecting:Boolean;
      
      private var _outputBuffer:Array;
      
      private var _splittedPacket:Boolean;
      
      private var _staticHeader:int;
      
      private var _splittedPacketId:uint;
      
      private var _splittedPacketLength:uint;
      
      private var _inputBuffer:ByteArray;
      
      private var _pauseBuffer:Array = new Array();
      
      private var _pause:Boolean;
      
      private var _latencyBuffer:Array = new Array();
      
      private var _latestSent:uint;
      
      private var _lastSent:uint;
      
      private var _timeoutTimer:Timer;
      
      private var _lagometer:ILagometer;
      
      private var _sendSequenceId:uint = 0;
      
      public function ServerConnection(param1:String = null, param2:int = 0)
      {
         super(param1,param2);
         this._remoteSrvHost = param1;
         this._remoteSrvPort = param2;
      }
      
      public function get rawParser() : RawDataParser
      {
         return this._rawParser;
      }
      
      public function set rawParser(param1:RawDataParser) : void
      {
         this._rawParser = param1;
      }
      
      public function get handler() : MessageHandler
      {
         return this._handler;
      }
      
      public function set handler(param1:MessageHandler) : void
      {
         this._handler = param1;
      }
      
      public function get pauseBuffer() : Array
      {
         return this._pauseBuffer;
      }
      
      public function get latencyAvg() : uint
      {
         var _loc2_:uint = 0;
         if(this._latencyBuffer.length == 0)
         {
            return 0;
         }
         var _loc1_:uint = 0;
         for each(_loc2_ in this._latencyBuffer)
         {
            _loc1_ += _loc2_;
         }
         return _loc1_ / this._latencyBuffer.length;
      }
      
      public function get latencySamplesCount() : uint
      {
         return this._latencyBuffer.length;
      }
      
      public function get latencySamplesMax() : uint
      {
         return LATENCY_AVG_BUFFER_SIZE;
      }
      
      public function get port() : uint
      {
         return this._remoteSrvPort;
      }
      
      public function get lastSent() : uint
      {
         return this._lastSent;
      }
      
      public function set lagometer(param1:ILagometer) : void
      {
         this._lagometer = param1;
      }
      
      public function get lagometer() : ILagometer
      {
         return this._lagometer;
      }
      
      public function get sendSequenceId() : uint
      {
         return this._sendSequenceId;
      }
      
      override public function connect(param1:String, param2:int) : void
      {
         if(this._connecting || disabled || disabledIn && disabledOut)
         {
            return;
         }
         this._connecting = true;
         this._remoteSrvHost = param1;
         this._remoteSrvPort = param2;
         this.addListeners();
         _log.trace("Connecting to " + param1 + ":" + param2 + "...");
         super.connect(param1,param2);
         this._timeoutTimer = new Timer(10000,1);
         this._timeoutTimer.start();
         this._timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onSocketTimeOut);
      }
      
      public function send(param1:INetworkMessage) : void
      {
         if(DEBUG_DATA)
         {
            _log.trace("[SND] > " + (!!DEBUG_VERBOSE ? this.inspect(msg) : msg));
         }
         LogFrame.log(LogTypeEnum.NETWORK_OUT,param1);
         if(disabled || disabledOut)
         {
            return;
         }
         if(!param1.isInitialized)
         {
            _log.warn("Sending non-initialized packet " + param1 + " !");
         }
         if(!connected)
         {
            if(this._connecting)
            {
               this._outputBuffer.push(param1);
            }
            return;
         }
         this.lowSend(param1);
      }
      
      override public function toString() : String
      {
         var _loc1_:* = "Server connection status:\n";
         _loc1_ += "  Connected:       " + (connected ? "Yes" : "No") + "\n";
         if(connected)
         {
            _loc1_ += "  Connected to:    " + this._remoteSrvHost + ":" + this._remoteSrvPort + "\n";
         }
         else
         {
            _loc1_ += "  Connecting:      " + (this._connecting ? "Yes" : "No") + "\n";
         }
         if(this._connecting)
         {
            _loc1_ += "  Connecting to:   " + this._remoteSrvHost + ":" + this._remoteSrvPort + "\n";
         }
         _loc1_ += "  Raw parser:      " + this.rawParser + "\n";
         _loc1_ += "  Message handler: " + this.handler + "\n";
         if(this._outputBuffer)
         {
            _loc1_ += "  Output buffer:   " + this._outputBuffer.length + " message(s)\n";
         }
         if(this._inputBuffer)
         {
            _loc1_ += "  Input buffer:    " + this._inputBuffer.length + " byte(s)\n";
         }
         if(this._splittedPacket)
         {
            _loc1_ += "  Splitted message in the input buffer:\n";
            _loc1_ += "    Message ID:      " + this._splittedPacketId + "\n";
            _loc1_ += "    Awaited length:  " + this._splittedPacketLength + "\n";
         }
         return _loc1_;
      }
      
      public function pause() : void
      {
         this._pause = true;
      }
      
      public function resume() : void
      {
         var _loc1_:INetworkMessage = null;
         this._pause = false;
         while(Boolean(this._pauseBuffer.length) && !this._pause)
         {
            _loc1_ = this._pauseBuffer.shift();
            if(DEBUG_DATA)
            {
               __log.trace("[RCV] (after Resume) " + (!!DEBUG_VERBOSE ? this.inspect(msg) : msg));
            }
            _log.logDirectly(new NetworkLogEvent(_loc1_,true));
            this._handler.process(_loc1_);
         }
         this._pauseBuffer = [];
      }
      
      public function stopConnectionTimeout() : void
      {
         if(this._timeoutTimer)
         {
            this._timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onSocketTimeOut);
            this._timeoutTimer.stop();
            this._timeoutTimer = null;
         }
      }
      
      private function addListeners() : void
      {
         addEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData,false,0,true);
         addEventListener(Event.CONNECT,this.onConnect,false,0,true);
         addEventListener(Event.CLOSE,this.onClose,false,0,true);
         addEventListener(IOErrorEvent.IO_ERROR,this.onSocketError,false,0,true);
         addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError,false,0,true);
      }
      
      private function removeListeners() : void
      {
         removeEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
         removeEventListener(Event.CONNECT,this.onConnect);
         removeEventListener(Event.CLOSE,this.onClose);
         removeEventListener(IOErrorEvent.IO_ERROR,this.onSocketError);
         removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
      }
      
      private function getType(v:*) : String
      {
         var className:String = getQualifiedClassName(v);
         if(className.indexOf("Vector") != -1)
         {
            className = className.split("__AS3__.vec::Vector.<").join("list{");
            className = className.split(">").join("}");
         }
         else
         {
            className = className.split("::").pop();
         }
         if(v is INetworkMessage)
         {
            className += ", id: " + INetworkMessage(v).getMessageId();
         }
         return className;
      }
      
      private function inspect(target:*, indent:String = "", isArray:Boolean = false) : String
      {
         var str:String = "";
         var content:Array = DescribeTypeCache.getVariables(target,true,false);
         if(!isArray)
         {
            str += this.getType(target);
         }
         for each(var property in content)
         {
            var v:* = target[property];
            str += "\n" + indent;
            if(isArray)
            {
               str += "[" + property + "]";
            }
            else
            {
               str += property;
            }
            switch(true)
            {
               case v is Vector.<int>:
               case v is Vector.<uint>:
               case v is Vector.<Boolean>:
               case v is Vector.<String>:
               case v is Vector.<Number>:
                  str += " (" + this.getType(v) + ", len:" + v.length + ") = " + v;
                  break;
               case getQualifiedClassName(v).indexOf("Vector") != -1:
               case v is Array:
                  str += " (" + this.getType(v) + ", len:" + v.length + ") = " + this.inspect(v,indent + "\t",true);
                  break;
               case v is String:
                  str += " = \"" + v + "\"";
                  break;
               case v is uint:
               case v is int:
               case v is Boolean:
               case v is Number:
                  str += " = " + v;
                  break;
               default:
                  str += " " + this.inspect(v,indent + "\t");
                  break;
            }
         }
         return str;
      }
      
      private function receive(param1:IDataInput) : void
      {
         var msg:INetworkMessage = null;
         var src:IDataInput = param1;
         var count:uint = 0;
         try
         {
            while(src.bytesAvailable > 0)
            {
               msg = this.lowReceive(src);
               if(msg is INetworkDataContainerMessage)
               {
                  while(INetworkDataContainerMessage(msg).content.bytesAvailable)
                  {
                     this.receive(INetworkDataContainerMessage(msg).content);
                  }
               }
               if(!(msg != null && !(msg is INetworkDataContainerMessage)))
               {
                  break;
               }
               if(this._lagometer)
               {
                  this._lagometer.pong(msg);
               }
               if(!this._pause)
               {
                  if(DEBUG_DATA)
                  {
                     _log.trace("[RCV] " + (!!DEBUG_VERBOSE ? this.inspect(msg) : msg));
                  }
                  _log.logDirectly(new NetworkLogEvent(msg,true));
                  if(!disabledIn)
                  {
                     this._handler.process(msg);
                  }
               }
               else
               {
                  this._pauseBuffer.push(msg);
               }
               count++;
            }
         }
         catch(e:Error)
         {
            if(e.getStackTrace())
            {
               _log.error("Error while reading socket. " + e.getStackTrace());
            }
            else
            {
               _log.error("Error while reading socket. No stack trace available");
            }
            close();
         }
      }
      
      private function getMessageId(param1:uint) : uint
      {
         return param1 >> NetworkMessage.BIT_RIGHT_SHIFT_LEN_PACKET_ID;
      }
      
      private function readMessageLength(param1:uint, param2:IDataInput) : uint
      {
         var _loc3_:uint = uint(param1 & NetworkMessage.BIT_MASK);
         var _loc4_:uint = 0;
         switch(_loc3_)
         {
            case 0:
               break;
            case 1:
               _loc4_ = uint(param2.readUnsignedByte());
               break;
            case 2:
               _loc4_ = uint(param2.readUnsignedShort());
               break;
            case 3:
               _loc4_ = uint(((param2.readByte() & 0xFF) << 16) + ((param2.readByte() & 0xFF) << 8) + (param2.readByte() & 0xFF));
         }
         return _loc4_;
      }
      
      protected function lowSend(param1:INetworkMessage, param2:Boolean = true) : void
      {
         param1.pack(this);
         this._latestSent = getTimer();
         this._lastSent = getTimer();
         ++this._sendSequenceId;
         if(this._lagometer)
         {
            this._lagometer.ping(param1);
         }
         if(param2)
         {
            flush();
         }
      }
      
      protected function lowReceive(param1:IDataInput) : INetworkMessage
      {
         var _loc2_:INetworkMessage = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(!this._splittedPacket)
         {
            if(param1.bytesAvailable < 2)
            {
               return null;
            }
            _loc3_ = uint(param1.readUnsignedShort());
            _loc4_ = this.getMessageId(_loc3_);
            if(param1.bytesAvailable >= (_loc3_ & NetworkMessage.BIT_MASK))
            {
               _loc5_ = this.readMessageLength(_loc3_,param1);
               if(param1.bytesAvailable >= _loc5_)
               {
                  this.updateLatency();
                  _loc2_ = this._rawParser.parse(param1,_loc4_,_loc5_);
                  MEMORY_LOG[_loc2_] = 1;
                  return _loc2_;
               }
               this._staticHeader = -1;
               this._splittedPacketLength = _loc5_;
               this._splittedPacketId = _loc4_;
               this._splittedPacket = true;
               readBytes(this._inputBuffer,0,param1.bytesAvailable);
               return null;
            }
            this._staticHeader = _loc3_;
            this._splittedPacketLength = _loc5_;
            this._splittedPacketId = _loc4_;
            this._splittedPacket = true;
            return null;
         }
         if(this._staticHeader != -1)
         {
            this._splittedPacketLength = this.readMessageLength(this._staticHeader,param1);
            this._staticHeader = -1;
         }
         if(param1.bytesAvailable + this._inputBuffer.length >= this._splittedPacketLength)
         {
            param1.readBytes(this._inputBuffer,this._inputBuffer.length,this._splittedPacketLength - this._inputBuffer.length);
            this._inputBuffer.position = 0;
            this.updateLatency();
            _loc2_ = this._rawParser.parse(this._inputBuffer,this._splittedPacketId,this._splittedPacketLength);
            MEMORY_LOG[_loc2_] = 1;
            this._splittedPacket = false;
            this._inputBuffer = new ByteArray();
            return _loc2_;
         }
         param1.readBytes(this._inputBuffer,this._inputBuffer.length,param1.bytesAvailable);
         return null;
      }
      
      private function updateLatency() : void
      {
         if(this._pause || this._pauseBuffer.length > 0 || this._latestSent == 0)
         {
            return;
         }
         var _loc1_:uint = uint(getTimer());
         var _loc2_:uint = uint(_loc1_ - this._latestSent);
         this._latestSent = 0;
         this._latencyBuffer.push(_loc2_);
         if(this._latencyBuffer.length > LATENCY_AVG_BUFFER_SIZE)
         {
            this._latencyBuffer.shift();
         }
      }
      
      protected function onConnect(param1:Event) : void
      {
         var _loc2_:INetworkMessage = null;
         this._connecting = false;
         if(this._timeoutTimer)
         {
            this._timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onSocketTimeOut);
            this._timeoutTimer.stop();
            this._timeoutTimer = null;
         }
         if(DEBUG_DATA)
         {
            _log.trace("Connection opened.");
         }
         for each(_loc2_ in this._outputBuffer)
         {
            this.lowSend(_loc2_,false);
         }
         flush();
         this._inputBuffer = new ByteArray();
         this._outputBuffer = new Array();
         this._handler.process(new ConnectedMessage());
      }
      
      protected function onClose(param1:Event) : void
      {
         if(DEBUG_DATA)
         {
            _log.trace("Connection closed.");
         }
         setTimeout(this.removeListeners,30000);
         if(this._lagometer)
         {
            this._lagometer.stop();
         }
         this._handler.process(new ServerConnectionClosedMessage(this));
         this._connecting = false;
         this._outputBuffer = new Array();
      }
      
      protected function onSocketData(param1:ProgressEvent) : void
      {
         this.receive(this);
      }
      
      protected function onSocketError(param1:IOErrorEvent) : void
      {
         if(this._lagometer)
         {
            this._lagometer.stop();
         }
         _log.error("Failure while opening socket.");
         this._connecting = false;
         this._handler.process(new ServerConnectionFailedMessage(this,param1.text));
      }
      
      protected function onSocketTimeOut(param1:Event) : void
      {
         if(this._lagometer)
         {
            this._lagometer.stop();
         }
         _log.error("Failure while opening socket, timeout.");
         this._connecting = false;
         this._handler.process(new ServerConnectionFailedMessage(this,"timeout"));
      }
      
      protected function onSecurityError(param1:SecurityErrorEvent) : void
      {
         if(this._lagometer)
         {
            this._lagometer.stop();
         }
         if(this.connected)
         {
            _log.error("Security error while connected : " + param1.text);
            this._handler.process(new ServerConnectionFailedMessage(this,param1.text));
         }
         else
         {
            _log.error("Security error while disconnected : " + param1.text);
         }
      }
   }
}

