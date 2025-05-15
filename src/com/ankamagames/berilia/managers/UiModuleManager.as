package com.ankamagames.berilia.managers
{
   import com.adobe.crypto.MD5;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.api.ApiBinder;
   import com.ankamagames.berilia.types.data.PreCompiledUiModule;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.berilia.types.data.UiGroup;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.event.ParsingErrorEvent;
   import com.ankamagames.berilia.types.event.ParsorEvent;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.types.messages.AllModulesLoadedMessage;
   import com.ankamagames.berilia.types.messages.AllUiXmlParsedMessage;
   import com.ankamagames.berilia.types.messages.ModuleLoadedMessage;
   import com.ankamagames.berilia.types.messages.ModuleRessourceLoadFailedMessage;
   import com.ankamagames.berilia.types.messages.UiXmlParsedErrorMessage;
   import com.ankamagames.berilia.types.messages.UiXmlParsedMessage;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   import com.ankamagames.berilia.types.shortcut.ShortcutCategory;
   import com.ankamagames.berilia.uiRender.XmlParsor;
   import com.ankamagames.berilia.utils.ModFlashProtocol;
   import com.ankamagames.berilia.utils.ModProtocol;
   import com.ankamagames.berilia.utils.UriCacheFactory;
   import com.ankamagames.berilia.utils.errors.UntrustedApiCallError;
   import com.ankamagames.berilia.utils.web.HttpServer;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.ErrorManager;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.newCache.garbage.LruGarbageCollector;
   import com.ankamagames.jerakine.newCache.impl.Cache;
   import com.ankamagames.jerakine.resources.ResourceType;
   import com.ankamagames.jerakine.resources.adapters.impl.AdvancedSignedFileAdapter;
   import com.ankamagames.jerakine.resources.adapters.impl.AdvancedSwfAdapter;
   import com.ankamagames.jerakine.resources.adapters.impl.BinaryAdapter;
   import com.ankamagames.jerakine.resources.adapters.impl.SignedFileAdapter;
   import com.ankamagames.jerakine.resources.adapters.impl.TxtAdapter;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoaderProgressEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.protocols.ProtocolFactory;
   import com.ankamagames.jerakine.types.ASwf;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.crypto.Signature;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.FrameIdManager;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class UiModuleManager
   {
      private static var _self:UiModuleManager;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(UiModuleManager));
      
      private var _sharedDefinitionLoader:IResourceLoader;
      
      private var _sharedDefinition:ApplicationDomain;
      
      private var _useSharedDefinition:Boolean;
      
      private var _loader:IResourceLoader;
      
      private var _uiLoader:IResourceLoader;
      
      private var _scriptNum:uint;
      
      private var _modules:Array;
      
      private var _preprocessorIndex:Dictionary;
      
      private var _uiFiles:Array;
      
      private var _regImport:RegExp = /<Import *url *= *"([^"]*)/g;
      
      private var _versions:Array;
      
      private var _clearUi:Array;
      
      private var _uiFileToLoad:uint;
      
      private var _moduleCount:uint = 0;
      
      private var _cacheLoader:IResourceLoader;
      
      private var _unparsedXml:Array;
      
      private var _unparsedXmlCount:uint;
      
      private var _unparsedXmlTotalCount:uint;
      
      private var _modulesRoot:File;
      
      private var _modulesPaths:Dictionary;
      
      private var _modulesHashs:Dictionary = new Dictionary();
      
      private var _resetState:Boolean;
      
      private var _parserAvaibleCount:uint = 2;
      
      private var _moduleLaunchWaitForSharedDefinition:Boolean;
      
      private var _unInitializedModule:Array;
      
      private var _useHttpServer:Boolean;
      
      private var _moduleLoaders:Dictionary;
      
      private var _loadingModule:Dictionary;
      
      private var _disabledModule:Array;
      
      private var _sharedDefinitionInstance:Object;
      
      private var _timeOutFrameNumber:int;
      
      private var _waitingInit:Boolean;
      
      private var _filter:Array;
      
      private var _filterInclude:Boolean;
      
      public var isDevMode:Boolean;
      
      private var _moduleScriptLoadedRef:Dictionary = new Dictionary();
      
      private var _uiLoaded:Dictionary = new Dictionary();
      
      private var _loadModuleFunction:Function;
      
      public function UiModuleManager(param1:Boolean = false)
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onLoadError,false,0,true);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoad,false,0,true);
         this._sharedDefinitionLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SINGLE_LOADER);
         this._sharedDefinitionLoader.addEventListener(ResourceErrorEvent.ERROR,this.onLoadError,false,0,true);
         this._sharedDefinitionLoader.addEventListener(ResourceLoadedEvent.LOADED,this.onSharedDefinitionLoad,false,0,true);
         this._uiLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._uiLoader.addEventListener(ResourceErrorEvent.ERROR,this.onUiLoadError,false,0,true);
         this._uiLoader.addEventListener(ResourceLoadedEvent.LOADED,this.onUiLoaded,false,0,true);
         this._cacheLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._moduleLoaders = new Dictionary();
         this._useHttpServer = false;
         if(!param1 && (this.isDevMode || Capabilities.isDebugger) && ApplicationDomain.currentDomain.hasDefinition("flash.net.ServerSocket"))
         {
            this._useHttpServer = true;
         }
         if(this._useHttpServer)
         {
            HttpServer.getInstance().init(File.applicationDirectory);
         }
      }
      
      public static function getInstance(param1:Boolean = false) : UiModuleManager
      {
         if(!_self)
         {
            _self = new UiModuleManager(param1);
         }
         return _self;
      }
      
      public function get moduleCount() : uint
      {
         return this._moduleCount;
      }
      
      public function get unparsedXmlCount() : uint
      {
         return this._unparsedXmlCount;
      }
      
      public function get unparsedXmlTotalCount() : uint
      {
         return this._unparsedXmlTotalCount;
      }
      
      public function set sharedDefinitionContainer(param1:Uri) : void
      {
         this._useSharedDefinition = param1 != null;
         if(param1)
         {
            if(this._useHttpServer)
            {
               this._sharedDefinitionLoader.load(new Uri(HttpServer.getInstance().getUrlTo(param1.fileName)),null,param1.fileType == "swf" ? AdvancedSwfAdapter : null);
               _log.fatal("trying to load sharedDefinition.swf throught an httpServer");
               FrameIdManager.frameId;
               this._timeOutFrameNumber = StageShareManager.stage.frameRate * 2;
               EnterFrameDispatcher.addEventListener(this.timeOutFrameCount,"frameCount");
            }
            else
            {
               this._sharedDefinitionLoader.load(param1,null,param1.fileType == "swf" ? AdvancedSwfAdapter : null);
               _log.fatal("trying to load sharedDefinition.swf the good ol\' way");
            }
         }
      }
      
      public function get sharedDefinition() : ApplicationDomain
      {
         return this._sharedDefinition;
      }
      
      public function get ready() : Boolean
      {
         return this._sharedDefinition != null;
      }
      
      public function get sharedDefinitionInstance() : Object
      {
         return this._sharedDefinitionInstance;
      }
      
      public function init(param1:Array, param2:Boolean) : void
      {
         var _loc4_:Uri = null;
         var _loc5_:File = null;
         this._filter = param1;
         this._filterInclude = param2;
         if(!this._sharedDefinition)
         {
            this._waitingInit = true;
            return;
         }
         this._moduleLaunchWaitForSharedDefinition = false;
         this._resetState = false;
         this._modules = new Array();
         this._preprocessorIndex = new Dictionary(true);
         this._scriptNum = 0;
         this._moduleCount = 0;
         this._versions = new Array();
         this._clearUi = new Array();
         this._uiFiles = new Array();
         this._modulesPaths = new Dictionary();
         this._unInitializedModule = new Array();
         this._loadingModule = new Dictionary();
         this._disabledModule = [];
         if(AirScanner.hasAir())
         {
            ProtocolFactory.addProtocol("mod",ModProtocol);
         }
         else
         {
            ProtocolFactory.addProtocol("mod",ModFlashProtocol);
         }
         var _loc3_:String = LangManager.getInstance().getEntry("config.mod.path");
         if(_loc3_.substr(0,2) != "\\\\" && _loc3_.substr(1,2) != ":/")
         {
            this._modulesRoot = new File(File.applicationDirectory.nativePath + File.separator + _loc3_);
         }
         else
         {
            this._modulesRoot = new File(_loc3_);
         }
         _loc4_ = new Uri(this._modulesRoot.nativePath + "/hash.metas");
         this._loader.load(_loc4_);
         BindsManager.getInstance().initialize();
         if(this._modulesRoot.exists)
         {
            for each(_loc5_ in this._modulesRoot.getDirectoryListing())
            {
               if(!(!_loc5_.isDirectory || _loc5_.name.charAt(0) == "."))
               {
                  if(param1.indexOf(_loc5_.name) != -1 == param2)
                  {
                     this.loadModule(_loc5_.name);
                  }
               }
            }
            return;
         }
         ErrorManager.addError("Impossible de trouver le dossier contenant les modules (url: " + LangManager.getInstance().getEntry("config.mod.path") + ")");
      }
      
      public function lightInit(param1:Vector.<UiModule>) : void
      {
         var _loc2_:UiModule = null;
         this._resetState = false;
         this._modules = new Array();
         this._modulesPaths = new Dictionary();
         for each(_loc2_ in param1)
         {
            this._modules[_loc2_.id] = _loc2_;
            this._modulesPaths[_loc2_.id] = _loc2_.rootPath;
         }
      }
      
      public function getModules() : Array
      {
         return this._modules;
      }
      
      public function getModule(param1:String) : UiModule
      {
         return this._modules[param1];
      }
      
      public function get disabledModule() : Array
      {
         return this._disabledModule;
      }
      
      public function reset() : void
      {
         var _loc1_:UiModule = null;
         _log.error("Reset des modules");
         this._resetState = true;
         if(this._loader)
         {
            this._loader.cancel();
         }
         if(this._cacheLoader)
         {
            this._cacheLoader.cancel();
         }
         if(this._uiLoader)
         {
            this._uiLoader.cancel();
         }
         Shortcut.reset();
         TooltipManager.clearCache();
         Berilia.getInstance().reset();
         ApiBinder.reset();
         KernelEventsManager.getInstance().initialize();
         for each(_loc1_ in this._modules)
         {
            this.unloadModule(_loc1_.id);
         }
         this._modules = [];
         this._uiFileToLoad = 0;
         this._scriptNum = 0;
         this._moduleCount = 0;
         this._parserAvaibleCount = 2;
         this._modulesPaths = new Dictionary();
      }
      
      public function getModulePath(param1:String) : String
      {
         return this._modulesPaths[param1];
      }
      
      public function loadModule(param1:String) : void
      {
         var _loc3_:File = null;
         var _loc4_:Uri = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         this.unloadModule(param1);
         var _loc2_:File = this._modulesRoot.resolvePath(param1);
         if(_loc2_.exists)
         {
            _loc3_ = this.searchDmFile(_loc2_);
            if(_loc3_)
            {
               ++this._moduleCount;
               ++this._scriptNum;
               if(_loc3_.url.indexOf("app:/") == 0)
               {
                  _loc6_ = "app:/".length;
                  _loc7_ = _loc3_.url.substring(_loc6_,_loc3_.url.length);
                  _loc4_ = new Uri(_loc7_);
                  _loc5_ = _loc7_.substr(0,_loc7_.lastIndexOf("/"));
               }
               else
               {
                  if(_loc3_.nativePath.substr(0,2) == "\\\\")
                  {
                     _loc8_ = _loc3_.nativePath;
                  }
                  else
                  {
                     _loc8_ = _loc3_.url;
                  }
                  _loc4_ = new Uri(_loc8_);
                  _loc5_ = _loc8_.substr(0,_loc8_.lastIndexOf("/"));
               }
               _loc4_.tag = _loc3_;
               this._modulesPaths[param1] = _loc5_;
               this._loader.load(_loc4_);
            }
            else
            {
               _log.error("Cannot found .dm or .d2ui file in " + _loc2_.url);
            }
         }
      }
      
      public function unloadModule(param1:String) : void
      {
         var m:UiModule;
         var moduleUiInstances:Array;
         var uiCtr:UiRootContainer = null;
         var ui:String = null;
         var group:UiGroup = null;
         var variables:Array = null;
         var varName:String = null;
         var apiList:Vector.<Object> = null;
         var api:Object = null;
         var id:String = param1;
         if(this._modules == null)
         {
            return;
         }
         m = this._modules[id];
         if(!m)
         {
            return;
         }
         moduleUiInstances = [];
         for each(uiCtr in Berilia.getInstance().uiList)
         {
            _log.trace("UI " + uiCtr.name + " >> " + uiCtr.uiModule.id + " (@" + uiCtr.uiModule.instanceId + ")");
            if(uiCtr.uiModule == m)
            {
               moduleUiInstances.push(uiCtr.name);
            }
         }
         for each(ui in moduleUiInstances)
         {
            Berilia.getInstance().unloadUi(ui);
         }
         for each(group in m.groups)
         {
            UiGroupManager.getInstance().removeGroup(group.name);
         }
         variables = DescribeTypeCache.getVariables(m.mainClass,true);
         for each(varName in variables)
         {
            if(m.mainClass[varName] is Object)
            {
               m.mainClass[varName] = null;
            }
         }
         m.destroy();
         apiList = m.apiList;
         while(apiList.length)
         {
            api = apiList.shift();
            if(Boolean(api) && Boolean(api.hasOwnProperty("destroy")))
            {
               try
               {
                  api["destroy"]();
               }
               catch(e:UntrustedApiCallError)
               {
                  api["destroy"](SecureCenter.ACCESS_KEY);
               }
            }
         }
         if(Boolean(m.mainClass) && Boolean(m.mainClass.hasOwnProperty("unload")))
         {
            m.mainClass["unload"]();
         }
         BindsManager.getInstance().removeEventListenerByName("__module_" + m.id);
         KernelEventsManager.getInstance().removeEventListenerByName("__module_" + m.id);
         delete this._modules[id];
         this._disabledModule.push(m);
      }
      
      public function checkSharedDefinitionHash(param1:String) : void
      {
         var _loc2_:Uri = new Uri(param1);
      }
      
      private function onTimeOut() : void
      {
         _log.error("SharedDefinition load Timeout");
         this.switchToNoHttpMode();
         EnterFrameDispatcher.removeEventListener(this.timeOutFrameCount);
      }
      
      private function timeOutFrameCount(param1:Event) : void
      {
         --this._timeOutFrameNumber;
         if(this._timeOutFrameNumber <= 0)
         {
            this.onTimeOut();
         }
      }
      
      private function launchModule() : void
      {
         var _loc2_:UiModule = null;
         var _loc3_:String = null;
         var _loc4_:UiModule = null;
         var _loc5_:Array = null;
         var _loc6_:UiModule = null;
         var _loc7_:uint = 0;
         this._moduleLaunchWaitForSharedDefinition = false;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._unInitializedModule)
         {
            if(_loc2_.trusted)
            {
               _loc1_.unshift(_loc2_);
            }
            else
            {
               _loc1_.push(_loc2_);
            }
         }
         while(_loc1_.length > 0)
         {
            _loc5_ = new Array();
            for each(_loc6_ in _loc1_)
            {
               ApiBinder.addApiData("currentUi",null);
               _loc3_ = ApiBinder.initApi(_loc6_.mainClass,_loc6_,this._sharedDefinition);
               if(_loc3_)
               {
                  _loc4_ = _loc6_;
                  _loc5_.push(_loc6_);
               }
               else if(_loc6_.mainClass)
               {
                  delete this._unInitializedModule[_loc6_.id];
                  _loc7_ = uint(getTimer());
                  ErrorManager.tryFunction(_loc6_.mainClass.main,null,"Une erreur est survenue lors de l\'appel à la fonction main() du module " + _loc6_.id);
                  _log.info("Exec main from module " + _loc6_.id + " : " + (getTimer() - _loc7_) + " ms");
               }
               else
               {
                  _log.error("Impossible d\'instancier la classe principale du module " + _loc6_.id);
               }
            }
            if(_loc5_.length == _loc1_.length)
            {
               ErrorManager.addError("Le module " + _loc4_.id + " demande une référence vers un module inexistant : " + _loc3_);
            }
            _loc1_ = _loc5_;
         }
         Berilia.getInstance().handler.process(new AllModulesLoadedMessage());
      }
      
      private function launchUiCheck() : void
      {
         this._uiFileToLoad = this._uiFiles.length;
         if(this._uiFiles.length)
         {
            this._uiLoader.load(this._uiFiles,null,TxtAdapter);
         }
         else
         {
            this.onAllUiChecked(null);
         }
      }
      
      private function processCachedFiles(param1:Array) : void
      {
         var _loc2_:Uri = null;
         var _loc3_:Uri = null;
         var _loc4_:ICache = null;
         for each(_loc3_ in param1)
         {
            switch(_loc3_.fileType.toLowerCase())
            {
               case "css":
                  CssManager.getInstance().load(_loc3_.uri);
                  break;
               case "jpg":
               case "png":
                  _loc2_ = new Uri(FileUtils.getFilePath(_loc3_.normalizedUri));
                  _loc4_ = UriCacheFactory.getCacheFromUri(_loc2_);
                  if(!_loc4_)
                  {
                     _loc4_ = UriCacheFactory.init(_loc2_.uri,new Cache(param1.length,new LruGarbageCollector()));
                  }
                  this._cacheLoader.load(_loc3_,_loc4_);
                  break;
               default:
                  ErrorManager.addError("Impossible de mettre en cache le fichier " + _loc3_.uri + ", le type n\'est pas supporté (uniquement css, jpg et png)");
                  break;
            }
         }
      }
      
      private function onLoadError(param1:ResourceErrorEvent) : void
      {
         var _loc2_:* = new Uri(HttpServer.getInstance().getUrlTo("SharedDefinitions.swf"));
         if(param1.uri == _loc2_)
         {
            this.switchToNoHttpMode();
         }
         else
         {
            if(param1.uri.fileType != "metas")
            {
               Berilia.getInstance().handler.process(new ModuleRessourceLoadFailedMessage(param1.uri.tag,param1.uri));
            }
            switch(param1.uri.fileType.toLowerCase())
            {
               case "swfs":
                  ErrorManager.addError("Impossible de charger le fichier " + param1.uri + " (" + param1.errorMsg + ")");
                  if(!--this._scriptNum)
                  {
                     this.launchUiCheck();
                  }
                  break;
               case "metas":
                  trace("fail");
                  break;
               default:
                  ErrorManager.addError("Impossible de charger le fichier " + param1.uri + " (" + param1.errorMsg + ")");
            }
         }
      }
      
      private function switchToNoHttpMode() : void
      {
         this._useHttpServer = false;
         _log.fatal("Failed Loading SharedDefinitions, Going no HttpServer Style !");
         this._sharedDefinitionLoader.cancel();
         var _loc1_:Uri = new Uri("SharedDefinitions.swf");
         _loc1_.loaderContext = new LoaderContext(false,new ApplicationDomain());
         this.sharedDefinitionContainer = _loc1_;
      }
      
      private function onUiLoadError(param1:ResourceErrorEvent) : void
      {
         ErrorManager.addError("Impossible de charger le fichier d\'interface " + param1.uri + " (" + param1.errorMsg + ")");
         Berilia.getInstance().handler.process(new ModuleRessourceLoadFailedMessage(param1.uri.tag,param1.uri));
         --this._uiFileToLoad;
      }
      
      private function onLoad(param1:ResourceLoadedEvent) : void
      {
         if(this._resetState)
         {
            return;
         }
         switch(param1.uri.fileType.toLowerCase())
         {
            case "swf":
            case "swfs":
               this.onScriptLoad(param1);
               break;
            case "d2ui":
            case "dm":
               this.onDMLoad(param1);
               break;
            case "xml":
               this.onShortcutLoad(param1);
               break;
            case "metas":
               this.onHashLoaded(param1);
         }
      }
      
      private function onDMLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:UiModule = null;
         var _loc3_:Uri = null;
         var _loc6_:File = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Uri = null;
         var _loc10_:File = null;
         var _loc11_:FileStream = null;
         var _loc12_:ByteArray = null;
         var _loc13_:ByteArray = null;
         var _loc14_:Signature = null;
         var _loc15_:Uri = null;
         var _loc16_:String = null;
         var _loc17_:UiData = null;
         var _loc18_:Array = null;
         var _loc19_:File = null;
         if(param1.resourceType == ResourceType.RESOURCE_XML)
         {
            _loc2_ = UiModule.createFromXml(param1.resource as XML,FileUtils.getFilePath(param1.uri.path),File(param1.uri.tag).parent.name);
         }
         else
         {
            _loc2_ = PreCompiledUiModule.fromRaw(param1.resource,FileUtils.getFilePath(param1.uri.path),File(param1.uri.tag).parent.name);
         }
         this._unInitializedModule[_loc2_.id] = _loc2_;
         _log.debug("onDMLoad : " + _loc2_.script);
         if(_loc2_.script)
         {
            _loc8_ = unescape(_loc2_.script);
            _loc9_ = new Uri(_loc8_);
            if(Berilia.getInstance().checkModuleAuthority)
            {
               _loc10_ = _loc9_.toFile();
               _log.debug("hash " + _loc9_);
               if(!_loc10_.exists)
               {
                  ErrorManager.addError("Le script du module " + _loc2_.id + " est introuvable (url: " + _loc10_.nativePath + ")");
                  --this._moduleCount;
                  --this._scriptNum;
                  _loc2_.trusted = false;
                  return;
               }
               _loc11_ = new FileStream();
               _loc11_.open(_loc10_,FileMode.READ);
               _loc12_ = new ByteArray();
               _loc11_.readBytes(_loc12_);
               _loc11_.close();
               if(_loc9_.fileType == "swf")
               {
                  _loc2_.trusted = MD5.hashBinary(_loc12_) == this._modulesHashs[_loc9_.fileName];
                  if(!_loc2_.trusted)
                  {
                     _log.error("Hash incorrect pour le module " + _loc2_.id);
                  }
               }
               else if(_loc9_.fileType == "swfs")
               {
                  _loc13_ = new ByteArray();
                  _loc14_ = new Signature(SignedFileAdapter.defaultSignatureKey);
                  if(!_loc14_.verify(_loc12_,_loc13_))
                  {
                     _log.fatal("Invalid signature in " + _loc10_.nativePath);
                     --this._moduleCount;
                     --this._scriptNum;
                     _loc2_.trusted = false;
                     return;
                  }
                  _loc2_.trusted = true;
               }
            }
            else
            {
               _loc2_.trusted = true;
            }
            if(!_loc2_.enable)
            {
               _log.fatal("Le module " + _loc2_.id + " est désactivé");
               --this._moduleCount;
               --this._scriptNum;
               this._disabledModule.push(_loc2_);
               return;
            }
            if(_loc2_.shortcuts)
            {
               _loc15_ = new Uri(_loc2_.shortcuts);
               _loc15_.tag = _loc2_.id;
               this._loader.load(_loc15_);
            }
            if(this._useHttpServer && _loc9_.fileType != "swfs")
            {
               _loc16_ = File.applicationDirectory.nativePath.split("\\").join("/");
               if(_loc8_.indexOf(_loc16_) != -1)
               {
                  _loc8_ = _loc8_.substr(_loc8_.indexOf(_loc16_) + _loc16_.length);
               }
               _loc8_ = HttpServer.getInstance().getUrlTo(_loc8_);
               _log.trace("[WebServer] Load " + _loc8_);
               this._loadModuleFunction(_loc8_,this.onModuleScriptLoaded,this.onScriptLoadFail,_loc2_);
            }
            else
            {
               if(!_loc2_.trusted)
               {
                  --this._moduleCount;
                  --this._scriptNum;
                  ErrorManager.addError("Les modules tiers nécessite la verison 2 de Air");
                  return;
               }
               _loc9_.tag = _loc2_.id;
               _loc9_.loaderContext = new LoaderContext();
               _loc9_.loaderContext.applicationDomain = new ApplicationDomain(this._sharedDefinition);
               this._loadingModule[_loc2_] = _loc2_.id;
               _log.trace("[Classic] Load " + _loc9_);
               this._loader.load(_loc9_,null,_loc9_.fileType != "swfs" ? BinaryAdapter : AdvancedSignedFileAdapter);
            }
         }
         var _loc4_:Array = new Array();
         if(!(_loc2_ is PreCompiledUiModule))
         {
            for each(_loc17_ in _loc2_.uis)
            {
               if(_loc17_.file)
               {
                  _loc3_ = new Uri(_loc17_.file);
                  _loc3_.tag = {
                     "mod":_loc2_.id,
                     "base":_loc17_.file
                  };
                  this._uiFiles.push(_loc3_);
               }
            }
         }
         var _loc5_:File = this._modulesRoot.resolvePath(_loc2_.id);
         _loc4_ = new Array();
         for each(_loc7_ in _loc2_.cachedFiles)
         {
            _loc6_ = _loc5_.resolvePath(_loc7_);
            if(_loc6_.exists)
            {
               if(!_loc6_.isDirectory)
               {
                  _loc4_.push(new Uri("mod://" + _loc2_.id + "/" + _loc7_));
               }
               else
               {
                  _loc18_ = _loc6_.getDirectoryListing();
                  for each(_loc19_ in _loc18_)
                  {
                     if(_loc19_.isDirectory)
                     {
                     }
                     _loc4_.push(new Uri("mod://" + _loc2_.id + "/" + _loc7_ + "/" + FileUtils.getFileName(_loc19_.url)));
                  }
               }
            }
         }
         this.processCachedFiles(_loc4_);
      }
      
      private function onScriptLoadFail(param1:IOErrorEvent, param2:UiModule) : void
      {
         _log.error("Le script du module " + param2.id + " est introuvable");
         if(!--this._scriptNum)
         {
            this.launchUiCheck();
         }
      }
      
      private function onScriptLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:UiModule = this._unInitializedModule[param1.uri.tag];
         var _loc3_:Loader = new Loader();
         this._moduleScriptLoadedRef[_loc3_] = _loc2_;
         var _loc4_:LoaderContext = new LoaderContext(false,new ApplicationDomain(this._sharedDefinition));
         AirScanner.allowByteCodeExecution(_loc4_,true);
         _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onModuleScriptLoaded);
         _loc3_.loadBytes(param1.resource as ByteArray,_loc4_);
      }
      
      private function onModuleScriptLoaded(param1:Event, param2:UiModule = null) : void
      {
         var _loc3_:Loader = LoaderInfo(param1.target).loader;
         _loc3_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onModuleScriptLoaded);
         if(!param2)
         {
            param2 = this._moduleScriptLoadedRef[_loc3_];
         }
         delete this._loadingModule[param2];
         _log.trace("Load script " + param2.id + ", " + (this._moduleCount - this._scriptNum + 1) + "/" + this._moduleCount);
         param2.loader = _loc3_;
         param2.applicationDomain = _loc3_.contentLoaderInfo.applicationDomain;
         param2.mainClass = _loc3_.content;
         this._modules[param2.id] = param2;
         var _loc4_:int = int(this._disabledModule.indexOf(param2));
         if(_loc4_ != -1)
         {
            this._disabledModule.splice(_loc4_,1);
         }
         Berilia.getInstance().handler.process(new ModuleLoadedMessage(param2.id));
         if(!--this._scriptNum)
         {
            this.launchUiCheck();
         }
      }
      
      private function onShortcutLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc3_:XML = null;
         var _loc4_:ShortcutCategory = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:XML = null;
         var _loc2_:XML = param1.resource;
         for each(_loc3_ in _loc2_..category)
         {
            _loc4_ = ShortcutCategory.create(_loc3_.@name,LangManager.getInstance().replaceKey(_loc3_.@description));
            for each(_loc8_ in _loc3_..shortcut)
            {
               if(!_loc8_.@name || !_loc8_.@name.toString().length)
               {
                  ErrorManager.addError("Le fichier de raccourci est mal formé, il manque la priopriété name dans le fichier " + param1.uri);
                  return;
               }
               _loc5_ = false;
               if(Boolean(_loc8_.@permanent) && _loc8_.@permanent == "true")
               {
                  _loc5_ = true;
               }
               _loc6_ = true;
               if(Boolean(_loc8_.@visible) && _loc8_.@visible == "false")
               {
                  _loc6_ = false;
               }
               _loc7_ = false;
               if(Boolean(_loc8_.@required) && _loc8_.@required == "true")
               {
                  _loc7_ = true;
               }
               new Shortcut(_loc8_.@name,_loc8_.@textfieldEnabled == "true",LangManager.getInstance().replaceKey(_loc8_.toString()),_loc4_,!_loc5_,_loc6_,_loc7_,LangManager.getInstance().replaceKey(_loc8_.@tooltipContent));
            }
         }
         BindsManager.getInstance().checkBinds();
      }
      
      private function onHashLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:XML = null;
         for each(_loc2_ in param1.resource..file)
         {
            this._modulesHashs[_loc2_.@name.toString()] = _loc2_.toString();
         }
      }
      
      private function onAllUiChecked(param1:ResourceLoaderProgressEvent) : void
      {
         var _loc3_:UiModule = null;
         var _loc4_:String = null;
         var _loc5_:UiData = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._unInitializedModule)
         {
            for each(_loc5_ in _loc3_.uis)
            {
               _loc2_[UiData(_loc5_).file] = _loc5_;
            }
         }
         this._unparsedXml = [];
         for(_loc4_ in this._clearUi)
         {
            UiRenderManager.getInstance().clearCacheFromId(_loc4_);
            UiRenderManager.getInstance().setUiVersion(_loc4_,this._clearUi[_loc4_]);
            if(_loc2_[_loc4_])
            {
               this._unparsedXml.push(_loc2_[_loc4_]);
            }
         }
         this._unparsedXmlCount = this._unparsedXmlTotalCount = this._unparsedXml.length;
         this.parseNextXml();
      }
      
      private function parseNextXml() : void
      {
         var _loc1_:UiData = null;
         var _loc2_:XmlParsor = null;
         this._unparsedXmlCount = this._unparsedXml.length;
         if(this._unparsedXml.length)
         {
            if(this._parserAvaibleCount)
            {
               --this._parserAvaibleCount;
               _loc1_ = this._unparsedXml.shift() as UiData;
               _loc2_ = new XmlParsor();
               _loc2_.rootPath = _loc1_.module.rootPath;
               _loc2_.addEventListener(Event.COMPLETE,this.onXmlParsed,false,0,true);
               _loc2_.addEventListener(ParsingErrorEvent.ERROR,this.onXmlParsingError);
               _loc2_.processFile(_loc1_.file);
            }
         }
         else
         {
            Berilia.getInstance().handler.process(new AllUiXmlParsedMessage());
            if(!this._useSharedDefinition || Boolean(this._sharedDefinition))
            {
               this.launchModule();
            }
            else
            {
               this._moduleLaunchWaitForSharedDefinition = true;
            }
         }
      }
      
      private function onXmlParsed(param1:ParsorEvent) : void
      {
         if(param1.uiDefinition)
         {
            param1.uiDefinition.name = XmlParsor(param1.target).url;
            UiRenderManager.getInstance().setUiDefinition(param1.uiDefinition);
            _log.info("Preparsing " + XmlParsor(param1.target).url + " ok");
            Berilia.getInstance().handler.process(new UiXmlParsedMessage(param1.uiDefinition.name));
         }
         ++this._parserAvaibleCount;
         this.parseNextXml();
      }
      
      private function onXmlParsingError(param1:ParsingErrorEvent) : void
      {
         Berilia.getInstance().handler.process(new UiXmlParsedErrorMessage(param1.url,param1.msg));
      }
      
      private function onUiLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:Uri = null;
         if(this._resetState)
         {
            return;
         }
         var _loc2_:int = int(this._uiFiles.indexOf(param1.uri));
         this._uiFiles.splice(this._uiFiles.indexOf(param1.uri),1);
         var _loc3_:UiModule = this._unInitializedModule[param1.uri.tag.mod];
         var _loc4_:String = param1.uri.tag.base;
         var _loc5_:String = this._versions[param1.uri.uri] != null ? this._versions[param1.uri.uri] : MD5.hash(param1.resource as String);
         var _loc6_:* = _loc5_ == UiRenderManager.getInstance().getUiVersion(param1.uri.uri);
         if(!_loc6_)
         {
            this._clearUi[param1.uri.uri] = _loc5_;
            if(param1.uri.tag.template)
            {
               this._clearUi[param1.uri.tag.base] = this._versions[param1.uri.tag.base];
            }
         }
         this._versions[param1.uri.uri] = _loc5_;
         var _loc7_:String = param1.resource as String;
         while(true)
         {
            _loc8_ = this._regImport.exec(_loc7_);
            if(!_loc8_)
            {
               break;
            }
            _loc9_ = LangManager.getInstance().replaceKey(_loc8_[1]);
            if(_loc9_.indexOf("mod://") != -1)
            {
               _loc10_ = _loc9_.substr(6,_loc9_.indexOf("/",6) - 6);
               _loc9_ = this._modulesPaths[_loc10_] + _loc9_.substr(6 + _loc10_.length);
            }
            else if(_loc9_.indexOf(":") == -1 && _loc9_.indexOf("ui/Ankama_Common") == -1)
            {
               _loc9_ = _loc3_.rootPath + _loc9_;
            }
            if(this._clearUi[_loc9_])
            {
               this._clearUi[param1.uri.uri] = _loc5_;
               this._clearUi[_loc4_] = this._versions[_loc4_];
            }
            else if(!this._uiLoaded[_loc9_])
            {
               this._uiLoaded[_loc9_] = true;
               ++this._uiFileToLoad;
               _loc11_ = new Uri(_loc9_);
               _loc11_.tag = {
                  "mod":_loc3_.id,
                  "base":_loc4_,
                  "template":true
               };
               this._uiLoader.load(_loc11_,null,TxtAdapter);
            }
         }
         if(!--this._uiFileToLoad)
         {
            this.onAllUiChecked(null);
         }
      }
      
      private function searchDmFile(param1:File) : File
      {
         var _loc3_:File = null;
         var _loc4_:File = null;
         if(param1.nativePath.indexOf(".svn") != -1)
         {
            return null;
         }
         var _loc2_:Array = param1.getDirectoryListing();
         for each(_loc3_ in _loc2_)
         {
            if(!_loc3_.isDirectory && Boolean(_loc3_.extension))
            {
               if(_loc3_.extension.toLowerCase() == "d2ui")
               {
                  return _loc3_;
               }
               if(!_loc4_ && _loc3_.extension.toLowerCase() == "dm")
               {
                  _loc4_ = _loc3_;
               }
            }
         }
         if(_loc4_)
         {
            return _loc4_;
         }
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.isDirectory)
            {
               _loc4_ = this.searchDmFile(_loc3_);
               if(_loc4_)
               {
                  break;
               }
            }
         }
         return _loc4_;
      }
      
      private function onSharedDefinitionLoad(param1:ResourceLoadedEvent) : void
      {
         EnterFrameDispatcher.removeEventListener(this.timeOutFrameCount);
         var _loc2_:ASwf = param1.resource as ASwf;
         this._sharedDefinition = _loc2_.applicationDomain;
         var _loc3_:Object = this._sharedDefinition.getDefinition("d2components::SecureComponent");
         _loc3_.init(SecureCenter.ACCESS_KEY,SecureCenter.unsecureContent,SecureCenter.secure,SecureCenter.unsecure,DescribeTypeCache.getVariables);
         var _loc4_:Object = this._sharedDefinition.getDefinition("utils::ReadOnlyData");
         _loc4_.init(SecureCenter.ACCESS_KEY,SecureCenter.unsecureContent,SecureCenter.secure,SecureCenter.unsecure);
         var _loc5_:Object = this._sharedDefinition.getDefinition("utils::DirectAccessObject");
         _loc5_.init(SecureCenter.ACCESS_KEY);
         SecureCenter.init(_loc3_,_loc4_,_loc5_);
         this._sharedDefinitionInstance = Object(_loc2_.content);
         this._loadModuleFunction = Object(_loc2_.content).loadModule;
         if(this._waitingInit)
         {
            this.init(this._filter,this._filterInclude);
         }
         if(this._moduleLaunchWaitForSharedDefinition)
         {
            this.launchModule();
         }
      }
   }
}

