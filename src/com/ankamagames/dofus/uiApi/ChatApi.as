package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.factories.HyperlinkFactory;
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.managers.HtmlManager;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.console.moduleLogger.TypeMessage;
   import com.ankamagames.dofus.datacenter.communication.ChatChannel;
   import com.ankamagames.dofus.internalDatacenter.communication.BasicChatSentence;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatInformationSentence;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatSentenceWithRecipient;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatSentenceWithSource;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkItemManager;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.logic.game.common.managers.ChatAutocompleteNameManager;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.ModuleLogger;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class ChatApi implements IApi
   {
      protected var _log:Logger = Log.getLogger(getQualifiedClassName(ChatApi));
      
      private var _module:UiModule;
      
      public function ChatApi()
      {
         super();
      }
      
      private function get chatFrame() : ChatFrame
      {
         return Kernel.getWorker().getFrame(ChatFrame) as ChatFrame;
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function getChannelsId() : Array
      {
         var _loc3_:* = undefined;
         var _loc1_:Array = this.chatFrame.disallowedChannels;
         var _loc2_:Array = new Array();
         for each(_loc3_ in ChatChannel.getChannels())
         {
            if(_loc1_.indexOf(_loc3_.id) == -1)
            {
               _loc2_.push(_loc3_.id);
            }
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function getDisallowedChannelsId() : Array
      {
         return this.chatFrame.disallowedChannels;
      }
      
      [Untrusted]
      public function getChatColors() : Array
      {
         return this.chatFrame.chatColors;
      }
      
      [Untrusted]
      public function getSmileyMood() : int
      {
         return this.chatFrame.smileyMood;
      }
      
      [Untrusted]
      public function getMessagesByChannel(param1:uint) : Array
      {
         var _loc2_:Array = this.chatFrame.getMessages();
         return _loc2_[param1];
      }
      
      [NoBoxing]
      [Untrusted]
      public function getParagraphByChannel(param1:uint) : Array
      {
         var _loc2_:Array = this.chatFrame.getParagraphes();
         return _loc2_[param1];
      }
      
      [Untrusted]
      public function getMessagesStoredMax() : uint
      {
         return this.chatFrame.maxMessagesStored;
      }
      
      [Untrusted]
      public function addParagraphToHistory(param1:int, param2:Object) : void
      {
         this.chatFrame.addParagraphToHistory(param1,param2);
      }
      
      [Untrusted]
      public function removeLinesFromHistory(param1:int, param2:int) : void
      {
         this.chatFrame.removeLinesFromHistory(param1,param2);
      }
      
      [Untrusted]
      public function setMaxMessagesStored(param1:int) : void
      {
         this.chatFrame.maxMessagesStored = param1;
      }
      
      [Untrusted]
      public function getMaxMessagesStored() : int
      {
         return this.chatFrame.maxMessagesStored;
      }
      
      [Untrusted]
      public function newBasicChatSentence(param1:uint, param2:String, param3:uint = 0, param4:Number = 0, param5:String = "") : BasicChatSentence
      {
         return new BasicChatSentence(param1,param2,param2,param3,param4,param5);
      }
      
      [Untrusted]
      public function newChatSentenceWithSource(param1:uint, param2:String, param3:uint = 0, param4:Number = 0, param5:String = "", param6:uint = 0, param7:String = "", param8:Vector.<ItemWrapper> = null) : ChatSentenceWithSource
      {
         return new ChatSentenceWithSource(param1,param2,param2,param3,param4,param5,param6,param7,param8);
      }
      
      [Untrusted]
      public function newChatSentenceWithRecipient(param1:uint, param2:String, param3:uint = 0, param4:Number = 0, param5:String = "", param6:uint = 0, param7:String = "", param8:String = "", param9:uint = 0, param10:Vector.<ItemWrapper> = null) : ChatSentenceWithRecipient
      {
         return new ChatSentenceWithRecipient(param1,param2,param2,param3,param4,param5,param6,param7,param8,param9,param10);
      }
      
      [Untrusted]
      public function getTypeOfChatSentence(param1:Object) : String
      {
         if(param1 is ChatSentenceWithRecipient)
         {
            return "recipientSentence";
         }
         if(param1 is ChatSentenceWithSource)
         {
            return "sourceSentence";
         }
         if(param1 is ChatInformationSentence)
         {
            return "informationSentence";
         }
         return "basicSentence";
      }
      
      [Untrusted]
      public function searchChannel(param1:String) : int
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = ChatChannel.getChannels();
         for(_loc3_ in _loc2_)
         {
            if(param1 == _loc2_[_loc3_].shortcut)
            {
               return _loc2_[_loc3_].id;
            }
         }
         return -1;
      }
      
      [Untrusted]
      public function getHistoryByIndex(param1:String, param2:uint) : String
      {
         return "";
      }
      
      [Untrusted]
      public function getRedChannelId() : uint
      {
         return this.chatFrame.getRedId();
      }
      
      [Untrusted]
      public function getStaticHyperlink(param1:String) : String
      {
         return HyperlinkFactory.decode(param1,false);
      }
      
      [Untrusted]
      public function newChatItem(param1:ItemWrapper) : String
      {
         return HyperlinkItemManager.newChatItem(param1);
      }
      
      [Untrusted]
      public function addAutocompletionNameEntry(param1:String, param2:int) : void
      {
         ChatAutocompleteNameManager.getInstance().addEntry(param1,param2);
      }
      
      [Untrusted]
      public function getAutocompletion(param1:String, param2:int) : String
      {
         return ChatAutocompleteNameManager.getInstance().autocomplete(param1,param2);
      }
      
      [Trusted]
      public function changeCssHandler(param1:String) : void
      {
         HtmlManager.changeCssHandler(param1);
      }
      
      [Trusted]
      public function logChat(param1:String) : void
      {
         ModuleLogger.log(param1,TypeMessage.LOG_CHAT);
      }
      
      [Trusted]
      public function addHtmlLink(param1:String, param2:String) : String
      {
         return HtmlManager.addLink(param1,param2);
      }
      
      [Trusted]
      public function addSpan(param1:String, param2:Object) : void
      {
         HtmlManager.addTag(param1,HtmlManager.SPAN,param2);
      }
      
      [Trusted]
      public function escapeChatString(param1:String) : String
      {
         var _loc2_:RegExp = /&/g;
         param1 = param1.replace(_loc2_,"&amp;");
         _loc2_ = /{/g;
         param1 = param1.replace(_loc2_,"&#123;");
         _loc2_ = /}/g;
         return param1.replace(_loc2_,"&#125;");
      }
      
      [Trusted]
      public function unEscapeChatString(param1:String) : String
      {
         param1 = param1.split("&amp;#123;").join("&#123;");
         param1 = param1.split("&amp;#125;").join("&#125;");
         return param1.split("&amp;amp;").join("&amp;");
      }
   }
}

