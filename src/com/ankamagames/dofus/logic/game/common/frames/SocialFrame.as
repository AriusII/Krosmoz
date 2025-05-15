package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildFactSheetWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildHouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.EnemyWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.FriendWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.IgnoredWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.SpouseWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.managers.AccountManager;
   import com.ankamagames.dofus.logic.game.common.managers.TaxCollectorsManager;
   import com.ankamagames.dofus.network.messages.game.friend.FriendsGetListMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredGetListMessage;
   import com.ankamagames.dofus.network.messages.game.friend.SpouseGetInformationsMessage;
   import com.ankamagames.dofus.network.types.game.guild.GuildMember;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockContentInformations;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class SocialFrame implements Frame
   {
      private static var _instance:SocialFrame;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SocialFrame));
      
      private var _guildDialogFrame:GuildDialogFrame;
      
      private var _friendsList:Array;
      
      private var _enemiesList:Array;
      
      private var _ignoredList:Array;
      
      private var _spouse:SpouseWrapper;
      
      private var _hasGuild:Boolean = false;
      
      private var _hasSpouse:Boolean = false;
      
      private var _guild:GuildWrapper;
      
      private var _guildMembers:Vector.<GuildMember>;
      
      private var _guildHouses:Vector.<GuildHouseWrapper> = new Vector.<GuildHouseWrapper>();
      
      private var _guildHousesList:Boolean = false;
      
      private var _guildHousesListUpdate:Boolean = false;
      
      private var _guildPaddocks:Vector.<PaddockContentInformations> = new Vector.<PaddockContentInformations>();
      
      private var _guildPaddocksMax:int = 1;
      
      private var _upGuildEmblem:EmblemWrapper;
      
      private var _backGuildEmblem:EmblemWrapper;
      
      private var _warnOnFrienConnec:Boolean;
      
      private var _warnOnMemberConnec:Boolean;
      
      private var _warnWhenFriendOrGuildMemberLvlUp:Boolean;
      
      private var _warnWhenFriendOrGuildMemberAchieve:Boolean;
      
      private var _autoLeaveHelpers:Boolean;
      
      private var _allGuilds:Dictionary = new Dictionary(true);
      
      private var _socialDatFrame:SocialDataFrame;
      
      public function SocialFrame()
      {
         super();
      }
      
      public static function getInstance() : SocialFrame
      {
         return _instance;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get friendsList() : Array
      {
         return this._friendsList;
      }
      
      public function get enemiesList() : Array
      {
         return this._enemiesList;
      }
      
      public function get ignoredList() : Array
      {
         return this._ignoredList;
      }
      
      public function get spouse() : SpouseWrapper
      {
         return this._spouse;
      }
      
      public function get hasGuild() : Boolean
      {
         return this._hasGuild;
      }
      
      public function get hasSpouse() : Boolean
      {
         return this._hasSpouse;
      }
      
      public function get guild() : GuildWrapper
      {
         return this._guild;
      }
      
      public function get guildmembers() : Vector.<GuildMember>
      {
         return this._guildMembers;
      }
      
      public function get guildHouses() : Vector.<GuildHouseWrapper>
      {
         return this._guildHouses;
      }
      
      public function get guildPaddocks() : Vector.<PaddockContentInformations>
      {
         return this._guildPaddocks;
      }
      
      public function get maxGuildPaddocks() : int
      {
         return this._guildPaddocksMax;
      }
      
      public function get warnFriendConnec() : Boolean
      {
         return this._warnOnFrienConnec;
      }
      
      public function get warnMemberConnec() : Boolean
      {
         return this._warnOnMemberConnec;
      }
      
      public function get warnWhenFriendOrGuildMemberLvlUp() : Boolean
      {
         return this._warnWhenFriendOrGuildMemberLvlUp;
      }
      
      public function get warnWhenFriendOrGuildMemberAchieve() : Boolean
      {
         return this._warnWhenFriendOrGuildMemberAchieve;
      }
      
      public function get guildHousesUpdateNeeded() : Boolean
      {
         return this._guildHousesListUpdate;
      }
      
      public function getGuildById(param1:int) : GuildFactSheetWrapper
      {
         return this._allGuilds[param1];
      }
      
      public function updateGuildById(param1:int, param2:GuildFactSheetWrapper) : void
      {
         this._allGuilds[param1] = param2;
      }
      
      public function pushed() : Boolean
      {
         _instance = this;
         this._enemiesList = new Array();
         this._ignoredList = new Array();
         this._socialDatFrame = new SocialDataFrame();
         this._guildDialogFrame = new GuildDialogFrame();
         Kernel.getWorker().addFrame(this._socialDatFrame);
         ConnectionsHandler.getConnection().send(new FriendsGetListMessage());
         ConnectionsHandler.getConnection().send(new IgnoredGetListMessage());
         ConnectionsHandler.getConnection().send(new SpouseGetInformationsMessage());
         return true;
      }
      
      public function pulled() : Boolean
      {
         _instance = null;
         TaxCollectorsManager.getInstance().destroy();
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         /*
          * Erreur de décompilation
          * Le délais dattente de ({0}) est expiré
          * Nb d'instructions : 5540
          */
         throw new flash.errors.IllegalOperationError("Non décompilé car le délais d'attente a été atteint");
      }
      
      public function isIgnored(param1:String, param2:int = 0) : Boolean
      {
         var _loc4_:IgnoredWrapper = null;
         var _loc3_:String = AccountManager.getInstance().getAccountName(param1);
         for each(_loc4_ in this._ignoredList)
         {
            if(param2 != 0 && _loc4_.accountId == param2 || _loc3_ && _loc4_.name.toLowerCase() == _loc3_.toLowerCase())
            {
               return true;
            }
         }
         return false;
      }
      
      public function isFriend(param1:String) : Boolean
      {
         var _loc4_:FriendWrapper = null;
         var _loc2_:int = int(this._friendsList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._friendsList[_loc3_];
            if(_loc4_.playerName == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function isEnemy(param1:String) : Boolean
      {
         var _loc4_:EnemyWrapper = null;
         var _loc2_:int = int(this._enemiesList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._enemiesList[_loc3_];
            if(_loc4_.playerName == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
   }
}

