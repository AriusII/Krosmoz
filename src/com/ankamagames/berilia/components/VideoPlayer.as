package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.berilia.components.messages.VideoBufferChangeMessage;
   import com.ankamagames.berilia.components.messages.VideoConnectFailedMessage;
   import com.ankamagames.berilia.components.messages.VideoConnectSuccessMessage;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import flash.events.AsyncErrorEvent;
   import flash.events.NetStatusEvent;
   import flash.events.SecurityErrorEvent;
   import flash.media.SoundTransform;
   import flash.media.Video;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.net.ObjectEncoding;
   import flash.utils.getQualifiedClassName;
   
   public class VideoPlayer extends GraphicContainer implements FinalizableUIComponent
   {
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(VideoPlayer));
      
      private var _finalized:Boolean;
      
      private var _video:Video;
      
      private var _netConnection:NetConnection;
      
      private var _netStream:NetStream;
      
      private var _flv:String;
      
      private var _fms:String;
      
      private var _client:Object;
      
      private var _autoPlay:Boolean;
      
      private var _mute:Boolean;
      
      private var _optionManager:OptionManager;
      
      private var _soundTransform:SoundTransform;
      
      public function VideoPlayer()
      {
         super();
      }
      
      public function finalize() : void
      {
         NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;
         graphics.clear();
         graphics.beginFill(0);
         graphics.drawRect(0,0,width,height);
         graphics.endFill();
         this._video = new Video(width,height);
         addChild(this._video);
         this._client = new Object();
         this._client.onBWDone = this.onBWDone;
         this._client.onMetaData = this.onMetaData;
         this._netConnection = new NetConnection();
         this._netConnection.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
         this._netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         this._netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onASyncError);
         this._netConnection.client = this._client;
         if(this._autoPlay)
         {
            this.connect();
         }
         this._finalized = true;
         getUi().iAmFinalized(this);
         this._mute = false;
         this._optionManager = OptionManager.getOptionManager("tubul");
         if(this._optionManager)
         {
            this._optionManager.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChange,false,0,true);
            this._soundTransform = new SoundTransform(this._optionManager["volumeAmbientSound"]);
         }
      }
      
      public function connect() : void
      {
         this._netConnection.connect(this._fms);
      }
      
      public function play() : void
      {
         if(this._flv)
         {
            this._netStream = new NetStream(this._netConnection);
            this._netStream.client = this._client;
            this._netStream.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
            this._netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onASyncError);
            this._video.attachNetStream(this._netStream);
            this._netStream.soundTransform = this._soundTransform;
            this._netStream.receiveAudio(!this.mute);
            this._netStream.play(this._flv);
         }
         else
         {
            _log.error("No Video File to play :(");
         }
      }
      
      public function stop() : void
      {
         if(this._netStream)
         {
            this._netStream.close();
         }
         this._netConnection.close();
         this._video.clear();
      }
      
      private function onNetStatus(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetConnection.Connect.Failed":
               Berilia.getInstance().handler.process(new VideoConnectFailedMessage(this));
               _log.error("Can\'t connect to media server " + this._fms);
               break;
            case "NetStream.Failed":
               Berilia.getInstance().handler.process(new VideoConnectFailedMessage(this));
               _log.error("Can\'t connect to media server " + this._fms);
               break;
            case "NetStream.Play.StreamNotFound":
               Berilia.getInstance().handler.process(new VideoConnectFailedMessage(this));
               _log.error("Video file " + this._flv + "doesn\'t exist");
               break;
            case "Netstream.Play.failed":
               Berilia.getInstance().handler.process(new VideoConnectFailedMessage(this));
               _log.error("Video streaming failed for an unknown reason");
               break;
            case "NetConnection.Connect.Success":
               if(this._autoPlay)
               {
                  this.play();
               }
               Berilia.getInstance().handler.process(new VideoConnectSuccessMessage(this));
               break;
            case "NetStream.Buffer.Full":
               this.resizeVideo();
               Berilia.getInstance().handler.process(new VideoBufferChangeMessage(this,0));
               break;
            case "NetStream.Buffer.Flush":
               Berilia.getInstance().handler.process(new VideoBufferChangeMessage(this,2));
               break;
            case "NetStream.Buffer.Empty":
               Berilia.getInstance().handler.process(new VideoBufferChangeMessage(this,1));
         }
      }
      
      private function onSecurityError(param1:SecurityErrorEvent) : void
      {
         Berilia.getInstance().handler.process(new VideoConnectFailedMessage(this));
         _log.error("Security Error: " + param1);
      }
      
      private function onASyncError(param1:AsyncErrorEvent) : void
      {
         _log.warn("ASyncError: " + param1);
      }
      
      private function onBWDone() : void
      {
      }
      
      private function onMetaData(param1:Object) : void
      {
      }
      
      private function onPropertyChange(param1:PropertyChangeEvent) : void
      {
         if(Boolean(this._optionManager["muteAmbientSound"]) || Boolean(this._optionManager["tubulIsDesactivated"]))
         {
            this._soundTransform = new SoundTransform(0);
         }
         else
         {
            this._soundTransform = new SoundTransform(this._optionManager["volumeAmbientSound"]);
         }
         if(this._netStream)
         {
            this._netStream.soundTransform = this._soundTransform;
         }
      }
      
      public function set flv(param1:String) : void
      {
         if(!getUi().uiModule.trusted)
         {
            throw new SecurityError();
         }
         var _loc2_:Array = param1.split("file://");
         if(_loc2_.length > 1)
         {
            this._flv = _loc2_[_loc2_.length - 1];
         }
         else
         {
            this._flv = param1;
         }
      }
      
      public function get flv() : String
      {
         return this._flv;
      }
      
      public function set fms(param1:String) : void
      {
         if(!getUi().uiModule.trusted)
         {
            throw new SecurityError();
         }
         this._fms = param1;
      }
      
      public function get fms() : String
      {
         return this._fms;
      }
      
      public function get autoPlay() : Boolean
      {
         return this._autoPlay;
      }
      
      public function set autoPlay(param1:Boolean) : void
      {
         this._autoPlay = param1;
      }
      
      public function set finalized(param1:Boolean) : void
      {
         this._finalized = param1;
      }
      
      public function get finalized() : Boolean
      {
         return this._finalized;
      }
      
      public function set mute(param1:Boolean) : void
      {
         this._mute = param1;
         if(this._netStream)
         {
            this._netStream.receiveAudio(!this._mute);
         }
      }
      
      public function get mute() : Boolean
      {
         return this._mute;
      }
      
      private function resizeVideo() : void
      {
      }
   }
}

