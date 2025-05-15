package com.ankamagames.atouin.managers
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.map.Cell;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.data.map.Map;
   import com.ankamagames.atouin.messages.AdjacentMapClickMessage;
   import com.ankamagames.atouin.messages.AdjacentMapOutMessage;
   import com.ankamagames.atouin.messages.AdjacentMapOverMessage;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.types.Frustum;
   import com.ankamagames.atouin.utils.CellIdConverter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getQualifiedClassName;
   
   public class FrustumManager
   {
      private static var _self:FrustumManager;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FrustumManager));
      
      private var _frustumContainer:DisplayObjectContainer;
      
      private var _shapeTop:Sprite;
      
      private var _shapeRight:Sprite;
      
      private var _shapeBottom:Sprite;
      
      private var _shapeLeft:Sprite;
      
      private var _frustrum:Frustum;
      
      private var _lastCellId:int;
      
      private var _enable:Boolean;
      
      public function FrustumManager()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : FrustumManager
      {
         if(!_self)
         {
            _self = new FrustumManager();
         }
         return _self;
      }
      
      public function init(param1:DisplayObjectContainer) : void
      {
         this._frustumContainer = param1;
         this._shapeTop = new Sprite();
         this._shapeRight = new Sprite();
         this._shapeBottom = new Sprite();
         this._shapeLeft = new Sprite();
         this._frustumContainer.addChild(this._shapeLeft);
         this._frustumContainer.addChild(this._shapeTop);
         this._frustumContainer.addChild(this._shapeRight);
         this._frustumContainer.addChild(this._shapeBottom);
         this._shapeLeft.buttonMode = true;
         this._shapeTop.buttonMode = true;
         this._shapeRight.buttonMode = true;
         this._shapeBottom.buttonMode = true;
         this._shapeLeft.addEventListener(MouseEvent.CLICK,this.click);
         this._shapeTop.addEventListener(MouseEvent.CLICK,this.click);
         this._shapeRight.addEventListener(MouseEvent.CLICK,this.click);
         this._shapeBottom.addEventListener(MouseEvent.CLICK,this.click);
         this._shapeLeft.addEventListener(MouseEvent.MOUSE_OVER,this.mouseMove);
         this._shapeTop.addEventListener(MouseEvent.MOUSE_OVER,this.mouseMove);
         this._shapeRight.addEventListener(MouseEvent.MOUSE_OVER,this.mouseMove);
         this._shapeBottom.addEventListener(MouseEvent.MOUSE_OVER,this.mouseMove);
         this._shapeLeft.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this._shapeTop.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this._shapeRight.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this._shapeBottom.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this._shapeLeft.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         this._shapeTop.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         this._shapeRight.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         this._shapeBottom.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         this.setBorderInteraction(false);
         this._lastCellId = -1;
      }
      
      public function setBorderInteraction(param1:Boolean) : void
      {
         this._enable = param1;
         this._shapeTop.mouseEnabled = param1;
         this._shapeRight.mouseEnabled = param1;
         this._shapeBottom.mouseEnabled = param1;
         this._shapeLeft.mouseEnabled = param1;
         this.updateMap();
      }
      
      public function updateMap() : void
      {
         if(this._enable)
         {
            this._shapeTop.mouseEnabled = this.findNearestCell(this._shapeTop).cell != -1;
            this._shapeRight.mouseEnabled = this.findNearestCell(this._shapeRight).cell != -1;
            this._shapeBottom.mouseEnabled = this.findNearestCell(this._shapeBottom).cell != -1;
            this._shapeLeft.mouseEnabled = this.findNearestCell(this._shapeLeft).cell != -1;
         }
      }
      
      public function getShape(param1:int) : Sprite
      {
         switch(param1)
         {
            case DirectionsEnum.UP:
               return this._shapeTop;
            case DirectionsEnum.LEFT:
               return this._shapeLeft;
            case DirectionsEnum.RIGHT:
               return this._shapeRight;
            case DirectionsEnum.DOWN:
               return this._shapeBottom;
            default:
               return null;
         }
      }
      
      public function set frustum(param1:Frustum) : void
      {
         this._frustrum = param1;
         var _loc2_:Point = new Point(param1.x + AtouinConstants.CELL_HALF_WIDTH * param1.scale,param1.y + AtouinConstants.CELL_HALF_HEIGHT * param1.scale);
         var _loc3_:Point = new Point(param1.x - AtouinConstants.CELL_HALF_WIDTH * param1.scale + param1.width,param1.y + AtouinConstants.CELL_HALF_HEIGHT * param1.scale);
         var _loc4_:Point = new Point(param1.x + AtouinConstants.CELL_HALF_WIDTH * param1.scale,param1.y - AtouinConstants.CELL_HEIGHT * param1.scale + param1.height);
         var _loc5_:Point = new Point(param1.x - AtouinConstants.CELL_HALF_WIDTH * param1.scale + param1.width,param1.y - AtouinConstants.CELL_HEIGHT * param1.scale + param1.height);
         var _loc6_:Point = new Point(param1.x,param1.y);
         var _loc7_:Point = new Point(param1.x + param1.width,param1.y);
         var _loc8_:Point = new Point(param1.x,param1.y + param1.height - AtouinConstants.CELL_HALF_HEIGHT * param1.scale);
         var _loc9_:Point = new Point(param1.x + param1.width,param1.y + param1.height - AtouinConstants.CELL_HALF_HEIGHT * param1.scale);
         var _loc11_:Vector.<int> = new Vector.<int>(7,true);
         _loc11_[0] = 1;
         _loc11_[1] = 2;
         _loc11_[2] = 2;
         _loc11_[3] = 2;
         _loc11_[4] = 2;
         _loc11_[5] = 2;
         _loc11_[6] = 2;
         var _loc12_:Vector.<Number> = new Vector.<Number>(14,true);
         _loc12_[0] = 0;
         _loc12_[1] = _loc6_.y;
         _loc12_[2] = _loc6_.x;
         _loc12_[3] = _loc6_.y;
         _loc12_[4] = _loc2_.x;
         _loc12_[5] = _loc2_.y;
         _loc12_[6] = _loc4_.x;
         _loc12_[7] = _loc4_.y;
         _loc12_[8] = _loc8_.x;
         _loc12_[9] = _loc8_.y;
         _loc12_[10] = 0;
         _loc12_[11] = _loc8_.y;
         _loc12_[12] = 0;
         _loc12_[13] = _loc6_.y;
         var _loc13_:Bitmap = this.drawShape(16746564,_loc11_,_loc12_);
         if(_loc13_ != null)
         {
            this._shapeLeft.addChild(_loc13_);
         }
         var _loc14_:Vector.<Number> = new Vector.<Number>(14,true);
         _loc14_[0] = _loc6_.x;
         _loc14_[1] = 0;
         _loc14_[2] = _loc6_.x;
         _loc14_[3] = _loc6_.y;
         _loc14_[4] = _loc2_.x;
         _loc14_[5] = _loc2_.y;
         _loc14_[6] = _loc3_.x;
         _loc14_[7] = _loc3_.y;
         _loc14_[8] = _loc7_.x;
         _loc14_[9] = _loc7_.y;
         _loc14_[10] = _loc7_.x;
         _loc14_[11] = 0;
         _loc14_[12] = 0;
         _loc14_[13] = 0;
         _loc13_ = this.drawShape(7803289,_loc11_,_loc14_);
         if(_loc13_ != null)
         {
            this._shapeTop.addChild(_loc13_);
         }
         var _loc15_:Vector.<Number> = new Vector.<Number>(14,true);
         _loc15_[0] = StageShareManager.startWidth;
         _loc15_[1] = _loc7_.y;
         _loc15_[2] = _loc7_.x;
         _loc15_[3] = _loc7_.y;
         _loc15_[4] = _loc3_.x;
         _loc15_[5] = _loc3_.y;
         _loc15_[6] = _loc5_.x;
         _loc15_[7] = _loc5_.y;
         _loc15_[8] = _loc9_.x;
         _loc15_[9] = _loc9_.y;
         _loc15_[10] = StageShareManager.startWidth;
         _loc15_[11] = _loc9_.y;
         _loc15_[12] = StageShareManager.startWidth;
         _loc15_[13] = _loc7_.y;
         _loc13_ = this.drawShape(1218969,_loc11_,_loc15_);
         if(_loc13_ != null)
         {
            _loc13_.x = StageShareManager.startWidth - _loc13_.width;
            _loc13_.y = 15;
            this._shapeRight.addChild(_loc13_);
         }
         var _loc16_:Vector.<Number> = new Vector.<Number>(14,true);
         _loc16_[0] = _loc9_.x;
         _loc16_[1] = StageShareManager.startHeight;
         _loc16_[2] = _loc9_.x;
         _loc16_[3] = _loc9_.y;
         _loc16_[4] = _loc5_.x;
         _loc16_[5] = _loc5_.y + 10;
         _loc16_[6] = _loc4_.x;
         _loc16_[7] = _loc4_.y + 10;
         _loc16_[8] = _loc8_.x;
         _loc16_[9] = _loc8_.y;
         _loc16_[10] = _loc8_.x;
         _loc16_[11] = StageShareManager.startHeight;
         _loc16_[12] = _loc9_.x;
         _loc16_[13] = StageShareManager.startHeight;
         _loc13_ = this.drawShape(7807590,_loc11_,_loc16_);
         if(_loc13_ != null)
         {
            _loc13_.y = StageShareManager.startHeight - _loc13_.height;
            this._shapeBottom.addChild(_loc13_);
         }
      }
      
      private function drawShape(param1:uint, param2:Vector.<int>, param3:Vector.<Number>) : Bitmap
      {
         var _loc5_:BitmapData = null;
         var _loc4_:Shape = new Shape();
         _loc4_.graphics.beginFill(param1,0);
         _loc4_.graphics.drawPath(param2,param3);
         _loc4_.graphics.endFill();
         if(_loc4_.width > 0 && _loc4_.height > 0)
         {
            _loc5_ = new BitmapData(_loc4_.width,_loc4_.height,true,16777215);
            _loc5_.draw(_loc4_);
            _loc4_.graphics.clear();
            _loc4_ = null;
            return new Bitmap(_loc5_);
         }
         return null;
      }
      
      private function click(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Map = MapDisplayManager.getInstance().getDataMapContainer().dataMap;
         switch(param1.target)
         {
            case this._shapeRight:
               _loc2_ = uint(_loc3_.rightNeighbourId);
               break;
            case this._shapeLeft:
               _loc2_ = uint(_loc3_.leftNeighbourId);
               break;
            case this._shapeBottom:
               _loc2_ = uint(_loc3_.bottomNeighbourId);
               break;
            case this._shapeTop:
               _loc2_ = uint(_loc3_.topNeighbourId);
         }
         var _loc4_:Object = this.findNearestCell(param1.target as Sprite);
         if(_loc4_.cell == -1)
         {
            return;
         }
         if(!_loc4_.custom)
         {
            this.sendClickAdjacentMsg(_loc2_,_loc4_.cell);
         }
         else
         {
            this.sendCellClickMsg(_loc2_,_loc4_.cell);
         }
      }
      
      private function findCustomNearestCell(param1:Sprite) : Object
      {
         var _loc5_:Array = null;
         var _loc6_:Point = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc2_:Map = MapDisplayManager.getInstance().getDataMapContainer().dataMap;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         switch(param1)
         {
            case this._shapeRight:
               _loc4_ = 1;
               _loc5_ = _loc2_.rightArrowCell;
               break;
            case this._shapeLeft:
               _loc4_ = 1;
               _loc5_ = _loc2_.leftArrowCell;
               break;
            case this._shapeBottom:
               _loc3_ = 1;
               _loc5_ = _loc2_.bottomArrowCell;
               break;
            case this._shapeTop:
               _loc3_ = 1;
               _loc5_ = _loc2_.topArrowCell;
         }
         if(!_loc5_ || !_loc5_.length)
         {
            return {
               "cell":-1,
               "distance":Number.MAX_VALUE
            };
         }
         var _loc11_:Number = Number.MAX_VALUE;
         var _loc12_:uint = 0;
         while(_loc12_ < _loc5_.length)
         {
            _loc9_ = uint(_loc5_[_loc12_]);
            _loc6_ = Cell.cellPixelCoords(_loc9_);
            _loc8_ = CellData(_loc2_.cells[_loc9_]).floor;
            if(_loc4_ == 1)
            {
               _loc7_ = Math.abs(param1.mouseY - this._frustrum.y - (_loc6_.y - _loc8_ + AtouinConstants.CELL_HALF_HEIGHT) * this._frustrum.scale);
            }
            if(_loc3_ == 1)
            {
               _loc7_ = Math.abs(param1.mouseX - this._frustrum.x - (_loc6_.x + AtouinConstants.CELL_HALF_WIDTH) * this._frustrum.scale);
            }
            if(_loc7_ < _loc11_)
            {
               _loc11_ = _loc7_;
               _loc10_ = _loc9_;
            }
            _loc12_++;
         }
         return {
            "cell":_loc10_,
            "distance":_loc11_
         };
      }
      
      private function findNearestCell(param1:Sprite) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Point = null;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc13_:int = 0;
         var _loc15_:CellData = null;
         var _loc16_:uint = 0;
         var _loc12_:Map = MapDisplayManager.getInstance().getDataMapContainer().dataMap;
         var _loc14_:Number = Number.MAX_VALUE;
         switch(param1)
         {
            case this._shapeRight:
               _loc2_ = int(AtouinConstants.MAP_WIDTH - 1);
               _loc3_ = int(AtouinConstants.MAP_WIDTH - 1);
               _loc9_ = uint(_loc12_.rightNeighbourId);
               break;
            case this._shapeLeft:
               _loc2_ = 0;
               _loc3_ = 0;
               _loc9_ = uint(_loc12_.leftNeighbourId);
               break;
            case this._shapeBottom:
               _loc2_ = int(AtouinConstants.MAP_HEIGHT - 1);
               _loc3_ = -(AtouinConstants.MAP_HEIGHT - 1);
               _loc9_ = uint(_loc12_.bottomNeighbourId);
               break;
            case this._shapeTop:
               _loc2_ = 0;
               _loc3_ = 0;
               _loc9_ = uint(_loc12_.topNeighbourId);
         }
         var _loc17_:Object = this.findCustomNearestCell(param1);
         if(_loc17_.cell != -1)
         {
            _loc14_ = Number(_loc17_.distance);
            _loc4_ = CellIdConverter.cellIdToCoord(_loc17_.cell).x;
            _loc5_ = CellIdConverter.cellIdToCoord(_loc17_.cell).y;
         }
         if(param1 == this._shapeRight || param1 == this._shapeLeft)
         {
            _loc11_ = AtouinConstants.MAP_HEIGHT * 2;
            _loc10_ = 0;
            while(_loc10_ < _loc11_)
            {
               _loc13_ = int(CellIdConverter.coordToCellId(_loc2_,_loc3_));
               _loc6_ = Cell.cellPixelCoords(_loc13_);
               _loc7_ = CellData(_loc12_.cells[_loc13_]).floor;
               _loc8_ = Math.abs(param1.mouseY - this._frustrum.y - (_loc6_.y - _loc7_ + AtouinConstants.CELL_HALF_HEIGHT) * this._frustrum.scale);
               if(_loc8_ < _loc14_)
               {
                  _loc15_ = _loc12_.cells[_loc13_] as CellData;
                  _loc16_ = _loc15_.mapChangeData;
                  if((Boolean(_loc16_)) && (param1 == this._shapeRight && (_loc16_ & 1 || (_loc13_ + 1) % (AtouinConstants.MAP_WIDTH * 2) == 0 && _loc16_ & 2 || (_loc13_ + 1) % (AtouinConstants.MAP_WIDTH * 2) == 0 && _loc16_ & 0x80) || param1 == this._shapeLeft && (_loc2_ == -_loc3_ && _loc16_ & 8 || _loc16_ & 0x10 || _loc2_ == -_loc3_ && _loc16_ & 0x20)))
                  {
                     _loc4_ = _loc2_;
                     _loc5_ = _loc3_;
                     _loc14_ = _loc8_;
                  }
               }
               if(!(_loc10_ % 2))
               {
                  _loc2_++;
               }
               else
               {
                  _loc3_--;
               }
               _loc10_++;
            }
         }
         else
         {
            _loc10_ = 0;
            while(_loc10_ < AtouinConstants.MAP_WIDTH * 2)
            {
               _loc13_ = int(CellIdConverter.coordToCellId(_loc2_,_loc3_));
               _loc6_ = Cell.cellPixelCoords(_loc13_);
               _loc8_ = Math.abs(param1.mouseX - this._frustrum.x - (_loc6_.x + AtouinConstants.CELL_HALF_WIDTH) * this._frustrum.scale);
               if(_loc8_ < _loc14_)
               {
                  _loc15_ = _loc12_.cells[_loc13_] as CellData;
                  _loc16_ = _loc15_.mapChangeData;
                  if((Boolean(_loc16_)) && (param1 == this._shapeTop && (_loc13_ < AtouinConstants.MAP_WIDTH && _loc16_ & 0x20 || _loc16_ & 0x40 || _loc13_ < AtouinConstants.MAP_WIDTH && _loc16_ & 0x80) || param1 == this._shapeBottom && (_loc13_ >= AtouinConstants.MAP_CELLS_COUNT - AtouinConstants.MAP_WIDTH && _loc16_ & 2 || _loc16_ & 4 || _loc13_ >= AtouinConstants.MAP_CELLS_COUNT - AtouinConstants.MAP_WIDTH && _loc16_ & 8)))
                  {
                     _loc4_ = _loc2_;
                     _loc5_ = _loc3_;
                     _loc14_ = _loc8_;
                  }
               }
               if(!(_loc10_ % 2))
               {
                  _loc2_++;
               }
               else
               {
                  _loc3_++;
               }
               _loc10_++;
            }
         }
         if(_loc14_ != Number.MAX_VALUE)
         {
            return {
               "cell":CellIdConverter.coordToCellId(_loc4_,_loc5_),
               "custom":_loc14_ == _loc17_.distance
            };
         }
         return {
            "cell":-1,
            "custom":false
         };
      }
      
      private function sendClickAdjacentMsg(param1:uint, param2:uint) : void
      {
         var _loc3_:AdjacentMapClickMessage = new AdjacentMapClickMessage();
         _loc3_.cellId = param2;
         _loc3_.adjacentMapId = param1;
         Atouin.getInstance().handler.process(_loc3_);
      }
      
      private function sendCellClickMsg(param1:uint, param2:uint) : void
      {
         var _loc3_:CellClickMessage = new CellClickMessage();
         _loc3_.cellId = param2;
         _loc3_.id = param1;
         Atouin.getInstance().handler.process(_loc3_);
      }
      
      private function out(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         switch(param1.target)
         {
            case this._shapeRight:
               _loc2_ = uint(DirectionsEnum.RIGHT);
               break;
            case this._shapeLeft:
               _loc2_ = uint(DirectionsEnum.LEFT);
               break;
            case this._shapeBottom:
               _loc2_ = uint(DirectionsEnum.DOWN);
               break;
            case this._shapeTop:
               _loc2_ = uint(DirectionsEnum.UP);
         }
         this._lastCellId = -1;
         var _loc3_:AdjacentMapOutMessage = new AdjacentMapOutMessage(_loc2_,DisplayObject(param1.target));
         Atouin.getInstance().handler.process(_loc3_);
      }
      
      private function mouseMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         switch(param1.target)
         {
            case this._shapeRight:
               _loc2_ = uint(DirectionsEnum.RIGHT);
               break;
            case this._shapeLeft:
               _loc2_ = uint(DirectionsEnum.LEFT);
               break;
            case this._shapeBottom:
               _loc2_ = uint(DirectionsEnum.DOWN);
               break;
            case this._shapeTop:
               _loc2_ = uint(DirectionsEnum.UP);
         }
         var _loc3_:int = int(this.findNearestCell(param1.target as Sprite).cell);
         if(_loc3_ == -1 || _loc3_ == this._lastCellId)
         {
            return;
         }
         this._lastCellId = _loc3_;
         var _loc4_:CellData = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc3_] as CellData;
         var _loc5_:AdjacentMapOverMessage = new AdjacentMapOverMessage(_loc2_,DisplayObject(param1.target),_loc3_,_loc4_);
         Atouin.getInstance().handler.process(_loc5_);
      }
   }
}

