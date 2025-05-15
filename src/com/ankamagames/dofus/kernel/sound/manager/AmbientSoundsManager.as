package com.ankamagames.dofus.kernel.sound.manager
{
   import com.ankamagames.dofus.datacenter.ambientSounds.AmbientSound;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.TubulSoundConfiguration;
   import com.ankamagames.dofus.kernel.sound.type.SoundDofus;
   import com.ankamagames.dofus.kernel.sound.utils.SoundUtil;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.protocolAudio.ProtocolEnum;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.tubul.enum.EnumSoundType;
   import com.ankamagames.tubul.factory.SoundFactory;
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.tubul.types.VolumeFadeEffect;
   import flash.utils.getQualifiedClassName;
   
   public class AmbientSoundsManager
   {
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(AmbientSoundsManager));
      
      private var _useCriterion:Boolean = false;
      
      private var _criterionID:uint;
      
      private var _ambientSounds:Vector.<AmbientSound>;
      
      private var _roleplayMusics:Vector.<AmbientSound>;
      
      private var _music:ISound;
      
      private var _previousMusic:ISound;
      
      private var _ambience:ISound;
      
      private var _previousAmbience:ISound;
      
      private var _musicA:AmbientSound;
      
      private var _ambienceA:AmbientSound;
      
      private var _previousMusicId:int;
      
      private var _previousAmbienceId:int;
      
      private var tubulOption:OptionManager;
      
      public function AmbientSoundsManager()
      {
         super();
         this.init();
      }
      
      public function get music() : ISound
      {
         return this._music;
      }
      
      public function get ambience() : ISound
      {
         return this._ambience;
      }
      
      public function get criterionID() : uint
      {
         return this._criterionID;
      }
      
      public function set criterionID(param1:uint) : void
      {
         this._criterionID = param1;
      }
      
      public function get ambientSounds() : Vector.<AmbientSound>
      {
         return this._ambientSounds;
      }
      
      public function setAmbientSounds(param1:Vector.<AmbientSound>, param2:Vector.<AmbientSound>) : void
      {
         var _loc4_:AmbientSound = null;
         this._ambientSounds = param1;
         this._roleplayMusics = param2;
         var _loc3_:String = "";
         if(this._ambientSounds.length == 0 && this._roleplayMusics.length == 0)
         {
            _loc3_ = "Ni musique ni ambiance pour cette map ??!!";
         }
         else
         {
            _loc3_ = "Cette map contient les ambiances d\'id : ";
            for each(_loc4_ in this._ambientSounds)
            {
               _loc3_ += _loc4_.id + ", ";
            }
            _loc3_ = " et les musiques d\'id : ";
            for each(_loc4_ in this._roleplayMusics)
            {
               _loc3_ += _loc4_.id + ", ";
            }
         }
         _log.info(_loc3_);
      }
      
      public function selectValidSounds() : void
      {
         var _loc2_:AmbientSound = null;
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         for each(_loc2_ in this._ambientSounds)
         {
            if(!this._useCriterion || _loc2_.criterionId == this._criterionID)
            {
               _loc1_++;
            }
         }
         _loc3_ = int(Math.random() * _loc1_);
         for each(_loc2_ in this._ambientSounds)
         {
            if(!this._useCriterion || _loc2_.criterionId == this._criterionID)
            {
               if(_loc3_ == 0)
               {
                  this._ambienceA = _loc2_;
                  break;
               }
               _loc3_--;
            }
         }
         _loc1_ = 0;
         for each(_loc2_ in this._roleplayMusics)
         {
            if(!this._useCriterion || _loc2_.criterionId == this._criterionID)
            {
               _loc1_++;
            }
         }
         _loc3_ = int(Math.random() * _loc1_);
         for each(_loc2_ in this._roleplayMusics)
         {
            if(!this._useCriterion || _loc2_.criterionId == this._criterionID)
            {
               if(_loc3_ == 0)
               {
                  this._musicA = _loc2_;
                  break;
               }
               _loc3_--;
            }
         }
      }
      
      public function playMusicAndAmbient() : void
      {
         var _loc1_:String = null;
         var _loc2_:Uri = null;
         var _loc3_:Number = NaN;
         var _loc4_:VolumeFadeEffect = null;
         var _loc5_:VolumeFadeEffect = null;
         var _loc6_:String = null;
         var _loc7_:Uri = null;
         var _loc8_:VolumeFadeEffect = null;
         var _loc9_:VolumeFadeEffect = null;
         if(!SoundManager.getInstance().manager.soundIsActivate)
         {
            return;
         }
         if(SoundManager.getInstance().manager is RegSoundManager && !RegConnectionManager.getInstance().isMain)
         {
            return;
         }
         if(this._ambienceA == null)
         {
            _log.warn("It\'s seems that we haven\'t any ambience for this area");
         }
         else
         {
            if(this._previousAmbienceId == this._ambienceA.id)
            {
               _log.warn("The ambiance is the same that previously");
            }
            else
            {
               if(this._previousAmbience != null)
               {
                  _loc5_ = new VolumeFadeEffect(-1,0,TubulSoundConfiguration.TIME_FADE_OUT_MUSIC);
                  this._previousAmbience.stop(_loc5_);
               }
               _loc1_ = SoundUtil.getConfigEntryByBusId(this._ambienceA.channel);
               _loc2_ = new Uri(_loc1_ + this._ambienceA.id + ".mp3");
               if(SoundManager.getInstance().manager is ClassicSoundManager)
               {
                  this._ambience = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,_loc2_);
                  this._ambience.busId = this._ambienceA.channel;
               }
               if(SoundManager.getInstance().manager is RegSoundManager)
               {
                  this._ambience = new SoundDofus(String(this._ambienceA.id));
               }
               this._ambience.volume = this._ambienceA.volume / 100;
               this._ambience.currentFadeVolume = 0;
               _loc4_ = new VolumeFadeEffect(-1,1,TubulSoundConfiguration.TIME_FADE_IN_MUSIC);
               this._ambience.play(true,0,_loc4_);
            }
            this._previousAmbienceId = this._ambienceA.id;
         }
         this._previousAmbience = this._ambience;
         if(this._musicA == null)
         {
            _log.warn("It\'s seems that we haven\'t any music for this area");
         }
         else
         {
            if(this._previousMusicId == this._musicA.id)
            {
               _log.warn("The music is the same that previously");
            }
            else
            {
               if(this._previousMusic != null)
               {
                  _loc9_ = new VolumeFadeEffect(-1,0,TubulSoundConfiguration.TIME_FADE_OUT_MUSIC);
                  this._previousMusic.stop(_loc9_);
               }
               _loc6_ = SoundUtil.getConfigEntryByBusId(this._musicA.channel);
               _loc7_ = new Uri(_loc6_ + this._musicA.id + ".mp3");
               if(SoundManager.getInstance().manager is ClassicSoundManager)
               {
                  this._music = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,_loc7_);
                  this._music.busId = this._musicA.channel;
               }
               if(SoundManager.getInstance().manager is RegSoundManager)
               {
                  this._music = new SoundDofus(String(this._musicA.id));
               }
               RegConnectionManager.getInstance().send(ProtocolEnum.SET_SILENCE,this._musicA.silenceMin,this._musicA.silenceMax);
               this._music.volume = this._musicA.volume / 100;
               this._music.currentFadeVolume = 0;
               this.tubulOption = OptionManager.getOptionManager("tubul");
               if(this.tubulOption["infiniteLoopMusics"])
               {
                  this._music.play(true,0);
               }
               else
               {
                  this._music.play(true,TubulSoundConfiguration.MUSIC_LOOPS);
               }
               this.tubulOption.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
               _loc8_ = new VolumeFadeEffect(-1,1,TubulSoundConfiguration.TIME_FADE_IN_MUSIC);
               _loc8_.attachToSoundSource(this._music);
               _loc8_.start();
            }
            this._previousMusicId = this._musicA.id;
         }
         this._previousMusic = this._music;
      }
      
      public function stopMusicAndAmbient() : void
      {
         if(this.ambience)
         {
            this.ambience.stop();
         }
         if(this.music)
         {
            this.music.stop();
         }
         this._previousAmbienceId = -1;
         this._previousMusicId = -1;
         if(this.tubulOption)
         {
            this.tubulOption.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         }
      }
      
      public function mergeSoundsArea(param1:Vector.<AmbientSound>) : void
      {
      }
      
      public function clear(param1:Number = 0, param2:Number = 0) : void
      {
         this.stopMusicAndAmbient();
      }
      
      private function init() : void
      {
      }
      
      private function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.propertyName != "infiniteLoopMusics")
         {
            return;
         }
         RegConnectionManager.getInstance().send(ProtocolEnum.OPTION_MUSIC_LOOP_VALUE_CHANGED,param1.propertyValue);
      }
   }
}

